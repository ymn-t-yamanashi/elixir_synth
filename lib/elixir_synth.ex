defmodule ElixirSynth do
  @moduledoc """
  Documentation for `ElixirSynth`.
  """
  @hi 42
  @bass_drum 36
  @snare 38

  def hello do
    # MIDI 初期化
    {:ok, synth} = MIDISynth.start_link([])

    # 最初だけ同期が取れなかったから、ダミーで1音ならす　理由はわからない
    note(@snare, synth, 1000, 0)
    Process.sleep(100)

    # 8小節最初
    Enum.each(1..8, fn _ ->
      play(synth)
    end)

    :world
  end

  def play(synth) do
    #ハイハット 8分刻み
    hi_task = notes(@hi, 100, 8, synth)

    #バスドラ 4分刻み
    bass_drum_task = notes(@bass_drum, 400, 4, synth)

    #スネア 裏拍
    snare_task = notes(@snare, 400, 2, synth, 600)

    # 小節終わるまで待機
    Task.await(hi_task)
    Task.await(bass_drum_task)
    Task.await(snare_task)
  end

  def notes(note, time, conut, synth, before \\ 0) do
    # 指定した回数音を鳴らす
    # note　ノートナンバー
    # time 間隔
    # 鳴らす回数
    # synth　MIDIオープンした変数
    # 事前のスリーブ時間
    Task.async(fn ->
      Enum.each(1..conut, fn _ ->
        note(note, synth, time, before)
      end)
    end)
  end

  def note(note, synth, time, before) do
    Process.sleep(before)
    MIDISynth.Keyboard.play(synth, note, 200, 127, 9)
    Process.sleep(time)
  end
end
