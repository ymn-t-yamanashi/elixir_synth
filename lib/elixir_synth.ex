defmodule ElixirSynth do
  @moduledoc """
  Documentation for `ElixirSynth`.
  """
  @hi 42
  @bass_drum 36
  @snare 38

  def hello do
    {:ok, synth} = MIDISynth.start_link([])

    Enum.each(1..8, fn _ ->
      play(synth)
    end)

    :world
  end

  def play(synth) do
    t = notes(@hi, 100, 8, synth)
    t2 = notes(@bass_drum, 400, 4, synth)
    t3 = notes(@snare, 400, 2, synth, 600)

    Task.await(t)
    Task.await(t2)
    Task.await(t3)
  end

  def notes(note, time, conut, synth, before \\ 0) do
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
