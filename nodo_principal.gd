extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)
var ponto_j1 = 0;
var ponto_j2 = 0;
var direcao_s1 = 1;
var direcao_s2 = -1;

# Constant for ball speed (in pixels/second)
const INITIAL_BALL_SPEED = 80
# Speed of the ball (also in pixels/second)
var ball_speed = INITIAL_BALL_SPEED
# Constant for pads speed
const PAD_SPEED = 150


func comecaragigar(spinner):
	var novosentido;
	if(get_node(spinner).get_rot() < 0):
		novosentido = 1;
	else:
		novosentido = -1;
	get_node(spinner).set_rot(get_node(spinner).get_rot()+(novosentido*10));

func tirardomeio():
	var ball_pos = screen_size*0.5
	ball_speed = INITIAL_BALL_SPEED
	direction = Vector2(-1,0)
	get_node("bola").set_pos(ball_pos)
	get_node("pontos_j1").set_text(str(ponto_j1))
	get_node("pontos_j2").set_text(str(ponto_j2))
	comecaragigar('esquerda');
	comecaragigar('direita');

func _process(delta):
	var ball_pos = get_node("bola").get_pos()
	var left_rect = Rect2( get_node("esquerda").get_pos() - pad_size*0.5, pad_size )
	var right_rect = Rect2( get_node("direita").get_pos() - pad_size*0.5, pad_size )
	# Integrate new ball position
	ball_pos += direction * ball_speed * delta
	# Flip when touching roof or floor
	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
	# Flip, change direction and increase speed when touching pads
	if(left_rect.has_point(ball_pos) and direction.x < 0):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
		comecaragigar('esquerda')
	elif(right_rect.has_point(ball_pos) and direction.x > 0):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
		comecaragigar('direita')
	get_node("bola").set_pos(ball_pos)
	
	# Move left pad
	var left_pos = get_node("esquerda").get_pos()
	if (left_pos.y > 0 and Input.is_action_pressed("esquerda_cima")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("esquerda_baixo")):
		left_pos.y += PAD_SPEED * delta
	if (left_pos.x > 0 and Input.is_action_pressed("esquerda_esquerda")):
		left_pos.x += -PAD_SPEED * delta
	if (left_pos.x < screen_size.x and Input.is_action_pressed("esquerda_direita")):
		left_pos.x += PAD_SPEED * delta
	get_node("esquerda").set_pos(left_pos)

	# Move right pad
	var right_pos = get_node("direita").get_pos()
	if (right_pos.y > 0 and Input.is_action_pressed("direita_cima")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("direita_baixo")):
		right_pos.y += PAD_SPEED * delta
	if (right_pos.x > 0 and Input.is_action_pressed("direita_esquerda")):
		right_pos.x += -PAD_SPEED * delta
	if (right_pos.x < screen_size.x and Input.is_action_pressed("direita_direita")):
		right_pos.x += PAD_SPEED * delta
	get_node("direita").set_pos(right_pos)
	
	# Check gameover
	if (ball_pos.x < 0):
		ponto_j1 +=1
		tirardomeio()
	elif(ball_pos.x > screen_size.x):
		ponto_j2 +=1
		tirardomeio();
		
	girar('esquerda');
	girar('direita');

func girar(spinner):
	var novosentido;
	if(get_node(spinner).get_rot() < 0):
		novosentido = -1;
	else:
		novosentido = 1;
	get_node(spinner).set_rot(get_node(spinner).get_rot()+(novosentido*10));

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	screen_size = get_viewport_rect().size
	pad_size = get_node("esquerda").get_texture().get_size()
	print('teste')
	tirardomeio()
	set_process(true)
	
	pass
