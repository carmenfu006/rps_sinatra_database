module ApplicationHelper
  def gamer_choices
    session['gamer_choices']
  end

  def computer_choices
    session['computer_choices']
  end

  def player_name
    session['player_name']
  end

  def player_rounds
    session['player_rounds']
  end

  def results_ready
    session['results_ready']
  end

  def win_results
    session['results'].count('win')
  end

  def lose_results
    session['results'].count('lose')
  end

  def tied_results
    session['results'].count('tied')
  end
end