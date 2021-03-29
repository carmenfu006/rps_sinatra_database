users = [
  {name: 'Jon Doe', age: 30},
  {name: 'Jane Doe', age: 25}
]

users.each do |u|
  User.create(u)
end