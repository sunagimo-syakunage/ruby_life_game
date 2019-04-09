require 'dxopal'
include DXOpal
require_remote './class/view.rb'
require_remote './class/DeadOrAlive.rb'
Window.load_resources do
# 一辺のセル数
cell_num = 50
# キャンバスの幅
screen_size = 800
# セルの大きさ
cell_size = screen_size / cell_num

# セルの見た目
# ウィンドウの大きさ
Window.width = screen_size
Window.height = screen_size

# 世界の生成
world = Array.new(1).map { Array.new(cell_num).map { Array.new(cell_num, 0) } }

# グライダー
world[0][2][3] = 1
world[0][3][4] = 1
world[0][1][5] = 1
world[0][2][5] = 1
world[0][3][5] = 1
world[0][7][8] = 1
world[0][8][9] = 1
world[0][6][10] = 1
world[0][7][10] = 1
world[0][8][10] = 1

scene = 'stop'

timer = 0
turn = 0
max = 0

doa = DeadOrAlive.new(cell_num)
view = View.new(cell_num, screen_size, cell_size)
view.change(world, turn)

Window.loop do
  mx = Input.mouse_pos_x
  my = Input.mouse_pos_y

  # 衝突判定じゃなくて計算で求めてるよ
  if Input.mouse_push?(M_LBUTTON) && mx.between?(0, screen_size) && my.between?(0, screen_size)
    world[turn][mx / cell_size][my / cell_size] = world [turn] [mx / cell_size][my / cell_size] == 1 ? 0 : 1
    view.change(world, turn)
  end
  max = turn if turn > max
  view.view_run
  case scene
  when 'stop'
    if Input.key_down?(K_RIGHT) && !world[turn + 1].nil?
      turn += 1
      view.change(world, turn)
    elsif Input.key_push?(K_DOWN) # 一つだけ進める
      turn >= max ? doa.push_doa(world, turn) : doa.change_old_doa(world, turn)
      turn += 1
      view.change(world, turn)
    elsif (Input.key_down?(K_LEFT) || Input.key_push?(K_UP)) && turn > 0
      turn -= 1
      view.change(world, turn)
    elsif Input.key_push?(K_R)
      # ランダムを発動したらそこから末尾までの配列を削除にして常にランダムが最新になるようにしてもいい
      turn >= max ? doa.push_random(world) : doa.change_old_random(world, turn)
      turn += 1
      view.change(world, turn)
    elsif Input.key_push?(K_D) || Input.key_push?(K_C)
      turn >= max ? doa.push_clear(world) : doa.change_old_clear(world, turn)
      turn += 1
      view.change(world, turn)
    end

    if Input.key_push?(K_SPACE)
      timer = Time.now.to_f
      scene = 'run'
    end
  when 'run'
    scene = 'stop' if Input.key_push?(K_SPACE)
    if Time.now.to_f - timer >= 0.1
      turn >= max ? doa.push_doa(world, turn) : doa.change_old_doa(world, turn)
      turn += 1
      view.change(world, turn)
      timer = Time.now.to_f
    end
  end
end
end
