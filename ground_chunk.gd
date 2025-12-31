extends StaticBody2D
var _noise = FastNoiseLite.new()

@export var grade = 75
@export var sisyphus: CharacterBody2D

var segment_end: Vector2 = Vector2(0, 600)
var new_segment_x: int = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
	_noise.seed = randi()
	_noise.fractal_octaves = 4
	_noise.frequency = 1.0 / 40.0
	segment_end = generate_chunk()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if sisyphus.get_position().x > new_segment_x:
		_noise.seed = randi()
		segment_end = generate_chunk(segment_end)
		new_segment_x += 800
		

#later on we should be storing each noise output in order to efficiently store terrain history
func generate_chunk(start: Vector2 = Vector2(0, 600)) -> Vector2:
	var last = start
	for i in 33:
		var elevation = last.y - abs(_noise.get_noise_1d(i) * grade)
		var delta = start.x + i * 25
		#print(elevation)
		var next = Vector2(delta, elevation)
		$GroundLine.add_point(next)
		var collide_segment = CollisionShape2D.new()
		add_child(collide_segment)
		collide_segment.shape = SegmentShape2D.new()
		collide_segment.shape.a = last
		collide_segment.shape.b = next
		last = next
	return last
