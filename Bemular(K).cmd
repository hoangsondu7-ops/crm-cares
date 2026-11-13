;------------------------------------------------------------------------------
;-| キー２回連続入力 |---------------------------------------------------------

[Command]
name = "FF"       ;必須コマンド名
command = F, F
time = 10

[Command]
name = "BB"       ;必須コマンド名
command = B, B
time = 10

;------------------------------------------------------------------------------
;-| 同時押し |-----------------------------------------------------------------

[Command]
name = "recovery" ;必須コマンド名
command = x+y
time = 1

[Command]
name = "ab" ;必須コマンド名
command = a+b
time = 1

;------------------------------------------------------------------------------
;-| 方向キー＋ボタン |---------------------------------------------------------

[Command]
name = "down_a"
command = /$D,a
time = 1

[Command]
name = "down_b"
command = /$D,b
time = 1

[Command]
name = "F_a"
command = /$F,a
time = 1

[Command]
name = "F_b"
command = /$F,b
time = 1

[Command]
name = "F_x"
command = /$F,x
time = 1

[Command]
name = "F_z"
command = /$F,z
time = 1
;------------------------------------------------------------------------------
;-| ボタン単発 |---------------------------------------------------------------
[Command]
name = "a"
command = a
time = 1
[Command]
name = "b"
command = b
time = 1
[Command]
name = "c"
command = c
time = 1
[Command]
name = "x"
command = x
time = 1
[Command]
name = "y"
command = y
time = 1
[Command]
name = "z"
command = z
time = 1
[Command]
name = "start"
command = s
time = 1

;判定用[Command]
[Command]
name = "F"
command = $F
time = 1
[Command]
name = "B"
command = $B
time = 1
[Command]
name = "U"
command = $U
time = 1
[Command]
name = "D"
command = $D
time = 1

;人操作フラグ用[Command]：ラベルは同一で問題ない。
[Command]
name = "AI"
command = a
time = 1
[Command]
name = "AI"
command = b
time = 1
[Command]
name = "AI"
command = c
time = 1
[Command]
name = "AI"
command = x
time = 1
[Command]
name = "AI"
command = y
time = 1
[Command]
name = "AI"
command = z
time = 1
[Command]
name = "AI"
command = s
time = 1
[Command]
name = "AI"
command = $F
time = 1
[Command]
name = "AI"
command = $B
time = 1
[Command]
name = "AI"
command = $U
time = 1
[Command]
name = "AI"
command = $D
time = 1

;AI判定用[Command]：ラベルは同一で問題ない。
[Command]
name = "/command"
command = /a
time = 1
[Command]
name = "/command"
command = /b
time = 1
[Command]
name = "/command"
command = /c
time = 1
[Command]
name = "/command"
command = /x
time = 1
[Command]
name = "/command"
command = /y
time = 1
[Command]
name = "/command"
command = /z
time = 1
[Command]
name = "/command"
command = /s
time = 1
[Command]
name = "/command"
command = /$F
time = 1
[Command]
name = "/command"
command = /$B
time = 1
[Command]
name = "/command"
command = /$U
time = 1
[Command]
name = "/command"
command = /$D
time = 1
;------------------------------------------------------------------------------
;-| 方向キー |-----------------------------------------------------------------

[Command]
name = "holdfwd"   ;必須コマンド名
command = /$F
time = 1

[Command]
name = "holdback"  ;必須コマンド名
command = /$B
time = 1

[Command]
name = "holdup"    ;必須コマンド名
command = /$U
time = 1

[Command]
name = "holddown"  ;必須コマンド名
command = /$D
time = 1
;～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
[Statedef -1]

[State -1,突撃]
type = ChangeState
value = 2010
triggerall = var(59)<=0
triggerall = command = "F_z"
triggerall = power >= 1000
trigger1 = statetype = S
trigger1 = ctrl

[State -1,ハイパーペイル熱線]
type = ChangeState
value = 2000
triggerall = var(59)<=0
triggerall = command = "z"
triggerall = power >= 1000
trigger1 = statetype = S
trigger1 = ctrl

[State -1,球体攻撃]
type = ChangeState
value = 2100
triggerall = var(59)<=0
triggerall = command = "z"
triggerall = command = "holddown"
triggerall = power >= 1000
trigger1 = statetype = C
trigger1 = ctrl

[State -1,火球]
type = ChangeState
value = 1010
triggerall = var(59)<=0
triggerall = command = "F_x"
trigger1 = statetype = S
trigger1 = ctrl

[State -1,ペイル熱線]
type = ChangeState
value = 1000
triggerall = var(59)<=0
triggerall = command = "x"
trigger1 = statetype = S
trigger1 = ctrl

[State -1,尻尾攻撃]
type = ChangeState
value = 1100
triggerall = var(59)<=0
triggerall = command = "x"
triggerall = command = "holddown"
trigger1 = statetype = C
trigger1 = ctrl

[State -1,ジャンプペイル熱線]
type = ChangeState
value = 1200
triggerall = var(59)<=0
triggerall = command = "x"
trigger1 = statetype = A
trigger1 = ctrl

[State -1,投げ]
type = ChangeState
value = 800
triggerall = var(59)<=0
triggerall = command = "ab"
trigger1 = statetype = S
trigger1 = ctrl
;==============================================================================
; 移動関連
;=============================================================================
[State -1, 走る]
type = ChangeState
value = 100
trigger1 = command = "FF"
trigger1 = statetype = S
trigger1 = ctrl

[State -1, バックステップ]
type = ChangeState
value = 105
trigger1 = command = "BB"
trigger1 = statetype = S
trigger1 = ctrl

[State -1, 挑発]
type = ChangeState
value = 195
triggerall = command = "start"
triggerall = var(59)<=0
trigger1 = statetype != A
trigger1 = ctrl
;==============================================================================
; 通常攻撃技
;==============================================================================
[State -1,頭突き(強)]
type = ChangeState
value = 220
triggerall = var(59)<=0
triggerall = command = "F_a"
trigger1 = statetype = S
trigger1 = ctrl

[State -1,キック(強)]
type = ChangeState
value = 230
triggerall = var(59)<=0
triggerall = command = "F_b"
trigger1 = statetype = S
trigger1 = ctrl

[State -1,頭突き(弱)]
type = ChangeState
value = 200
triggerall = var(59)<=0
triggerall = command = "a"
trigger1 = statetype = S
trigger1 = ctrl

[State -1,キック(弱)]
type = ChangeState
value = 210
triggerall = var(59)<=0
triggerall = command = "b"
trigger1 = statetype = S
trigger1 = ctrl
;------------------------------------------------------------------------------
[State -1,しゃがみ頭突き]
type = ChangeState
value = 400
triggerall = var(59)<=0
triggerall = command = "a"
triggerall = command = "holddown"
trigger1 = statetype = C
trigger1 = ctrl

[State -1,しゃがみキック]
type = ChangeState
value = 410
triggerall = var(59)<=0
triggerall = command = "b"
triggerall = command = "holddown"
trigger1 = statetype = C
trigger1 = ctrl
;------------------------------------------------------------------------------
[State -1,ジャンプ頭突き]
type = ChangeState
value = 600
triggerall = var(59)<=0
triggerall = command = "a"
trigger1 = statetype = A
trigger1 = ctrl 

[State -1,ジャンプキック]
type = ChangeState
value = 610
triggerall = var(59)<=0
triggerall = command = "b"
trigger1 = statetype = A
trigger1 = ctrl 
;AI--------------------------------------------------------------------------
;==============================================================================
; 移動関連
;==============================================================================
[State -1, ガード]
type = ChangeState
value = 120
triggerall = var(59) = 1 && RoundState = 2 
triggerall = ctrl && stateno != [120,155]
trigger1 = random <= 700
trigger1 = p2movetype = A || InGuardDist
trigger2 = p2movetype = A || InGuardDist || enemynear,NumProj > 0
trigger2 = P2BodyDist X >= 90 || statetype = A

[State -1, Walk] 
type = ChangeState 
value = 20 
triggerall = var(59) = 1 && RoundState = 2 
trigger1 = statetype != A 
trigger1 = ctrl && stateno != 20 
trigger1 = random <= 100 
ctrl = 1 

[State -1, jump] 
type = ChangeState 
value = 40 
triggerall = var(59) = 1 && RoundState = 2 
triggerall = statetype != A && ctrl 
triggerall = random <= 100
trigger1 = p2statetype = A && p2movetype = H 
trigger1 = P2BodyDist X = [0,90] 
trigger1 = enemynear,vel Y = [-1,1] 
ctrl = 1 

[State -1, Dash] 
type = ChangeState 
value = 100 
triggerall = var(59) = 1 && RoundState = 2 
triggerall = statetype != A && ctrl 
triggerall = P2BodyDist X >= 80 && stateno != 100 
trigger1 = p2movetype = I && random <=50 
trigger2 = p2movetype = H 
trigger3 = p2movetype = I && random <=200
trigger3 = (stateno = 800 ) && time >20
ctrl = 1 

[State -1, Back Step] 
type = ChangeState 
value = 105 
triggerall = var(59) = 1 && RoundState = 2 
triggerall = statetype != A && ctrl 
triggerall = P2BodyDist X < 50 && BackEdgeBodyDist > 50 
trigger1 = p2statetype = L && life >= lifemax / 2 
ctrl = 1 
;---------------------------------------------------------------------------
[State -1,突撃]
type = ChangeState
value = 2010
triggerall = var(59)>0 && roundstate = 2
triggerall = power >= 1000
triggerall = p2statetype != L && P2BodyDist X = [80,160]  
triggerall = random <= 800  
trigger1 = statetype != A 
trigger1 = ctrl

[State -1,ハイパーペイル熱線]
type = ChangeState
value = 2000
triggerall = var(59)>0 && roundstate = 2
triggerall = power >= 1000
triggerall = p2statetype != L 
triggerall = random <= 800 
trigger1 = P2BodyDist X = [-20,80]   
trigger1 = statetype != A 
trigger1 = ctrl

[State -1,球体攻撃]
type = ChangeState
value = 2100
triggerall = var(59)>0 && roundstate = 2
triggerall = power >= 1000
triggerall = p2statetype != L && P2BodyDist X > 160
triggerall = random <= 800  
trigger1 = statetype != A 
trigger1 = ctrl

[State -1,ペイル熱線]
type = ChangeState
value = 1000
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [120,210]  
triggerall = random <= 800  
trigger1 = p2statetype != A 
trigger1 = statetype != A 
trigger1 = ctrl && p2movetype != A 

[State -1,火球]
type = ChangeState
value = 1010
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [80,180]  
triggerall = random <= 800  
trigger1 = p2statetype != A 
trigger1 = statetype != A 
trigger1 = ctrl && p2movetype != A 

[State -1,頭突き(弱)]
type = ChangeState
value = 200
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [20,60] 
triggerall = random <= 800  
trigger1 = statetype != A 
trigger1 = ctrl && p2movetype != A 

[State -1,キック(弱)]
type = ChangeState
value = 210
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [-20,20] 
triggerall = random <= 800  
trigger1 = statetype != A 
trigger1 = ctrl && p2movetype != A 

[State -1,頭突き(強)]
type = ChangeState
value = 220
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [20,60] 
trigger1 = random <= 800  
trigger1 = statetype != A 
trigger1 = ctrl && p2movetype != A 
trigger2 = random <= 500  
trigger2 = (stateno = 200) && time > 10
trigger2 = movehit

[State -1,キック(強)]
type = ChangeState
value = 230
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [-20,20] 
trigger1 = random <= 800  
trigger1 = statetype != A 
trigger1 = ctrl && p2movetype != A 
trigger2 = random <= 500  
trigger2 = (stateno = 210) && time > 10
trigger2 = movehit

[State -1,しゃがみ頭突き]
type = ChangeState
value = 400
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [-20,20] 
triggerall = statetype != A
trigger1 = random <= 800    
trigger1 = p2statetype != A 
trigger1 = ctrl && p2movetype != A 
trigger2 = random <= 500  
trigger2 = (stateno = [200,230]) && time > 10
trigger2 = movehit

[State -1,しゃがみキック]
type = ChangeState
value = 410
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype = L &&  P2BodyDist X = [-20,20] 
triggerall = statetype != A
trigger1 = random <= 800    
trigger1 = p2statetype != A 
trigger1 = ctrl && p2movetype != A 
trigger2 = random <= 500  
trigger2 = (stateno = [200,230]) && time > 10
trigger2 = movehit

[State -1,尻尾攻撃]
type = ChangeState
value = 1100
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype = L &&  P2BodyDist X = [20,80] 
triggerall = statetype != A
trigger1 = random <= 800    
trigger1 = p2statetype != A 
trigger1 = ctrl && p2movetype != A 
trigger2 = random <= 500  
trigger2 = (stateno = [200,230]) && time > 10
trigger2 = movehit

[State -1,ジャンプ赤色光線]
type = ChangeState
value = 1200
triggerall = var(59)>0 && roundstate = 2
triggerall = P2BodyDist X = [40,80] 
triggerall = P2BodyDist Y = [-40,90]
triggerall = random <= 800  
trigger1 = statetype = A 
trigger1 = ctrl && p2movetype != A

[State -1,投げ ]
type = ChangeState
value = 800
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [-20,20] 
triggerall = random <= 500  
triggerall = statetype != A 
triggerall = P2statetype != A
trigger1 = ctrl && p2movetype != A 
trigger2 = (stateno =[200,410]) && time > 10
trigger2 = movecontact
;------------------------------------------------------------------------------
[State -1,ジャンプ頭突き]
type = ChangeState
value = 600
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [20,40] 
triggerall = P2BodyDist Y = [-40,40]
triggerall = random <= 800  
trigger1 = statetype = A 
trigger1 = ctrl && p2movetype != A 

[State -1, ジャンプキック]
type = ChangeState
value = 610
triggerall = var(59)>0 && roundstate = 2
triggerall = p2statetype != L && P2BodyDist X = [-20,20] 
triggerall = P2BodyDist Y = [-40,40]
triggerall = random <= 800  
trigger1 = statetype = A 
trigger1 = ctrl && p2movetype != A 
;------------------------------------------------------------------------------
[State -1, 挑発]
type = ChangeState
value = 195
triggerall = var(59)>0 && roundstate = 2
triggerall =  P2BodyDist X = [180,200] 
triggerall = random <= 5 
trigger1 = statetype != A
trigger1 = ctrl