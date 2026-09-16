; Convert a stored Pokemon nickname to the name that should be displayed.
;
; Input:
;   c  = species
;   de = direct pointer to the Pokemon's raw nickname
; Output:
;   de = wcd6d
; Preserves:
;   wd11e
;
; Modes 0 and 1 display the raw nickname exactly as before. In mode 2, an
; English canonical default nickname is displayed as the Chinese species name;
; every other nickname is displayed unchanged.
GetMonDisplayName::
	push bc
	ld a, c
	ld b, a
	ld a, [wd11e]
	push af
	push de
	ld a, b
	ld [wd11e], a
	ld a, [wENGNameMark]
	cp 2
	jr nz, .copyRawNickname

	call GetMonEnglishName
	pop hl
	push hl
	ld b, NAME_LENGTH
.compareDefaultName
	ld a, [de]
	cp [hl]
	jr nz, .customNickname
	cp "@"
	jr z, .defaultNickname
	inc de
	inc hl
	dec b
	jr nz, .compareDefaultName
	jr .customNickname

.defaultNickname
	pop hl
	call GetMonChineseName
	jr .done

.customNickname
	pop hl
	jr .copyNicknameFromHL
.copyRawNickname
	pop hl
.copyNicknameFromHL
	ld de, wcd6d
	push de
	ld bc, NAME_LENGTH
	call CopyData
	pop de
.done
	pop af
	ld [wd11e], a
	pop bc
	ret

; The indexed wrappers deliberately resolve species and nickname from the same
; collection and slot. Callers never rely on an unrelated global species value.
GetPartyMonDisplayName::
	; Input: e = party slot. Bankswitch overwrites BC before entering a farcall.
	push hl
	push bc
	ld c, e
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wPartyMonNicks
	ld a, c
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	pop af
	ld c, a
	call GetMonDisplayName
	pop bc
	pop hl
	ret

GetEnemyMonDisplayName::
	; Input: e = enemy party slot. Bankswitch overwrites BC before entering a farcall.
	push hl
	push bc
	ld c, e
	ld b, 0
	ld hl, wEnemyPartySpecies
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wEnemyMonNicks
	ld a, c
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	pop af
	ld c, a
	call GetMonDisplayName
	pop bc
	pop hl
	ret

GetBoxMonDisplayName::
	; Input: e = box slot. Bankswitch overwrites BC before entering a farcall.
	push hl
	push bc
	ld c, e
	ld b, 0
	ld hl, wBoxSpecies
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wBoxMonNicks
	ld a, c
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	pop af
	ld c, a
	call GetMonDisplayName
	pop bc
	pop hl
	ret

GetDayCareMonDisplayName::
	ld a, [wDayCareMonSpecies]
	ld c, a
	ld de, wDayCareMonName
	jp GetMonDisplayName

GetListMonDisplayName::
; Input: e = slot in the party/box list selected by wListPointer.
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l
	jp z, GetPartyMonDisplayName
	jp GetBoxMonDisplayName

GetHoFMonDisplayName::
; Input: de = Hall of Fame raw nickname pointer.
; The caller's species is already recorded in wHoFMonSpecies.
	ld a, [wHoFMonSpecies]
	ld c, a
	jp GetMonDisplayName

RenameEvolvedMon::
; Renames the mon to its new, evolved form's stored default name unless it had
; a nickname, in which case the nickname is kept.
	ld a, [wMonHIndex]
	call GetMonStoredDefaultName
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call SkipFixedLengthTextEntries
	ld de, wcd6d
	ld b, NAME_LENGTH
.compareNamesLoop
	ld a, [de]
	cp [hl]
	ret nz
	cp "@"
	jr z, .useNewDefaultName
	inc hl
	inc de
	dec b
	jr nz, .compareNamesLoop
	ret
.useNewDefaultName
	ld a, [wWhichPokemon]
	ld bc, NAME_LENGTH
	ld hl, wPartyMonNicks
	call AddNTimes
	push hl
	ld a, [wd0b5]
	call GetMonStoredDefaultName
	ld hl, wcd6d
	pop de
	ld bc, NAME_LENGTH
	jp CopyData
