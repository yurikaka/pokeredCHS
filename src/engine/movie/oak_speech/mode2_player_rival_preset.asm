DisplayMode2PlayerRivalPreset::
; Input: e = NAME_PLAYER_SCREEN (0) or NAME_RIVAL_SCREEN (1).
	ld a, e
	and a
	ld de, .player
	jr z, .draw
	ld de, .rival
.draw
	hlcoord 2, 2
	; The list is drawn here rather than over the normal Chinese list, so the
	; third preset is RED/BLUE from the first frame.
	jp PlaceString

; The text importer converts the normal source list to Chinese at build time.
; These byte-coded rows deliberately stay literal: in Mode 2, only the third
; preset is English while the other menu entries retain their Chinese labels.
IF DEF(_RED)
.player
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $06, $43, $09, $3a ; 赤红
	next $12, $0d, $18, $bd ; 小智
	next "R", "E", "D"
	db "@"

.rival
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $0e, $a0, $0c, $7a ; 青绿
	next $12, $0d, $0c, $bb ; 小茂
	next "B", "L", "U", "E"
	db "@"
ELSE
.player
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $0e, $a0, $0c, $7a ; 青绿
	next $12, $0d, $0c, $bb ; 小茂
	next "B", "L", "U", "E"
	db "@"

.rival
	db $19, $30, $09, $da, $0a, $f0, $07, $43 ; 自己决定
	next $06, $43, $09, $3a ; 赤红
	next $12, $0d, $18, $bd ; 小智
	next "R", "E", "D"
	db "@"
ENDC
