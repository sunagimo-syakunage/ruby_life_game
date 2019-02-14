class DeadOrAlive
  def initialize(cell_num)
    @cell_num = cell_num
    @cell_max = cell_num - 1
  end

  def doa(world, turn)
    hoge_world = Array.new(@cell_num).map { Array.new(@cell_num, 0) }
    (0...@cell_num).each do |world_x|
      (0...@cell_num).each do |world_y|
        cnt = if world_x == 0
                # 上下左右がつながっている
                # 四隅の判定があるからこんな感じに
                if world_y == 0
                  alive_count(world, world_x, world_y, turn, left_sell: @cell_max, x_sell: 0, right_sell: 1, up_sell: @cell_max, y_sell: 0, down_sell: 1)
                elsif world_y == @cell_max
                  alive_count(world, world_x, world_y, turn, left_sell: @cell_max, x_sell: 0, right_sell: 1, up_sell: @cell_max - 1, y_sell: @cell_max, down_sell: 0)
                else
                  alive_count(world, world_x, world_y, turn, left_sell: @cell_max, x_sell: 0, right_sell: 1)
                      end
              elsif world_x == @cell_max
                if world_y == 0
                  alive_count(world, world_x, world_y, turn, left_sell: @cell_max - 1, x_sell: @cell_max, right_sell: 0, up_sell: @cell_max, y_sell: 0, down_sell: 1)
                elsif world_y == @cell_max
                  alive_count(world, world_x, world_y, turn, left_sell: @cell_max - 1, x_sell: @cell_max, right_sell: 0, up_sell: @cell_max - 1, y_sell: @cell_max, down_sell: 0)
                else
                  alive_count(world, world_x, world_y, turn, left_sell: @cell_max - 1, x_sell: @cell_max, right_sell: 0)
                      end
              elsif world_y == 0
                alive_count(world, world_x, world_y, turn, up_sell: @cell_max, y_sell: 0, down_sell: 1)
              elsif world_y == @cell_max
                alive_count(world, world_x, world_y, turn, up_sell: @cell_max - 1, y_sell: @cell_max, down_sell: 0)
              else
                alive_count(world, world_x, world_y, turn)
        end
        decision(world, hoge_world, turn, world_x, world_y, cnt)
      end # world_y
    end # world_x
    hoge_world
  end # doa

  # 次生きているか判定するよ
  def decision(world, hoge_world, turn, world_x, world_y, cnt)
    if world[turn][world_x][world_y] == 1
      if cnt <= 1 || cnt >= 4
        hoge_world[world_x][world_y] = 0
      elsif cnt <= 3
        hoge_world[world_x][world_y] = 1
      end
    elsif world[turn][world_x][world_y] == 0
      hoge_world[world_x][world_y] = 1 if cnt == 3
    else
      hoge_world[world_x][world_y] = 0
    end
  end

  # 周囲を見て生きている人を数える周囲を設定することもできる
  def alive_count(world, world_x, world_y, turn, left_sell: world_x - 1, x_sell: world_x, right_sell: world_x + 1, up_sell: world_y - 1, y_sell: world_y, down_sell: world_y + 1)
    cnt = 0
    [left_sell, x_sell, right_sell].each do |around_x|
      [up_sell, y_sell, down_sell].each do |around_y|
        cnt += 1 if (around_x != world_x || around_y != world_y) && (world[turn][around_x][around_y] == 1)
      end
    end
    cnt
  end

  def push_doa(world, turn)
    world << doa(world, turn)
    # p 'push'
  end

  def change_old_doa(world, turn)
    world[turn + 1] = doa(world, turn)
    # p 'old'
  end

  def push_random(world)
    world << random
    # p 'push-random'
  end

  def change_old_random(world, turn)
    world[turn + 1] = random
    # p 'old-random'
  end

  def random
    hoge_world = Array.new(@cell_num).map { Array.new(@cell_num, 0) }
    (0...@cell_num).each do |world_x|
      (0...@cell_num).each do |world_y|
        hoge_world[world_x][world_y] = rand(2) == 1 ? 1 : 0
      end
    end
    hoge_world
  end
end
