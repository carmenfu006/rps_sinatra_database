class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results do |t|
      t.references :player, foreign_key: true
      t.integer :round
      t.integer :win_record
      t.integer :lose_record
      t.integer :tied_record

      t.timestamps
    end
  end
end