DisplayMode2PlayerRivalPreset::
; Input: e = NAME_PLAYER_SCREEN (0) or NAME_RIVAL_SCREEN (1).
	ld a, e
	and a
	ld de, Mode2PlayerPresetList
	jr z, .draw
	ld de, Mode2RivalPresetList
.draw
	hlcoord 2, 2
	; The list is drawn here rather than over the normal Chinese list, so the
	; third preset is RED/BLUE from the first frame.
	jp PlaceString

GetMode2PlayerRivalName::
; Input: e = NAME_PLAYER_SCREEN (0) or NAME_RIVAL_SCREEN (1).
; Output: de = wcd6d containing the matching English canonical name.
	ld a, e
	and a
IF DEF(_RED)
	ld hl, Mode2PlayerPresetName ; RED
	jr z, .copy
	ld l, LOW(Mode2RivalPresetName) ; GREEN
ELIF DEF(_GREEN)
	ld hl, Mode2PlayerPresetName ; GREEN
	jr z, .copy
	ld l, LOW(Mode2RivalPresetName) ; RED
ELSE
	ld hl, Mode2PlayerPresetName ; BLUE
	jr z, .copy
	ld l, LOW(Mode2RivalPresetName) ; RED
ENDC
.copy
	ld de, wcd6d
	ld bc, NAME_BUFFER_LENGTH
	jp CopyData

IF DEF(_RED)
Mode2PlayerPresetName:
	db "R", "E", "D", "@"
Mode2RivalPresetName:
	db "G", "R", "E", "E", "N", "@"
ELIF DEF(_GREEN)
Mode2PlayerPresetName:
	db "G", "R", "E", "E", "N", "@"
Mode2RivalPresetName:
	db "R", "E", "D", "@"
ELSE
Mode2PlayerPresetName:
	db "B", "L", "U", "E", "@"
Mode2RivalPresetName:
	db "R", "E", "D", "@"
ENDC

ASSERT HIGH(Mode2PlayerPresetName) == HIGH(Mode2RivalPresetName)

; The text importer converts the normal source list to Chinese at build time.
; These byte-coded rows deliberately stay literal: in Mode 2, only the third
; preset is English while the other menu entries retain their Chinese labels.
IF DEF(_RED)
Mode2PlayerPresetList:
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $06, $43, $09, $3a ; 赤红
	next $12, $0d, $18, $bd ; 小智
	next "R", "E", "D"
	db "@"

Mode2RivalPresetList:
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $0e, $a0, $0c, $7a ; 青绿
	next $12, $0d, $0c, $bb ; 小茂
	next "G", "R", "E", "E", "N"
	db "@"
ELIF DEF(_GREEN)
Mode2PlayerPresetList:
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $0e, $a0, $0c, $7a ; 青绿
	next $12, $0d, $0c, $bb ; 小茂
	next "G", "R", "E", "E", "N"
	db "@"

Mode2RivalPresetList:
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $06, $43, $09, $3a ; 赤红
	next $12, $0d, $18, $bd ; 小智
	next "R", "E", "D"
	db "@"
ELSE
Mode2PlayerPresetList:
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $05, $6a, $0b, $8a ; 碧蓝
	next $09, $31, $09, $1a ; 恒和
	next "B", "L", "U", "E"
	db "@"

Mode2RivalPresetList:
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $06, $43, $09, $3a ; 赤红
	next $0e, $a0, $0c, $7a ; 青绿
	next "R", "E", "D"
	db "@"
ENDC
