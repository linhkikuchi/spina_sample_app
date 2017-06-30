def shared_filesystem?
  config.node['dna']['engineyard']['environment']['instances']
    .select{ |ins| %w(app_master solo).include?(ins["role"]) }.first
    .fetch('components')
    .map(&:values).flatten
    .include?("efs") rescue false
end

def efs_mount_point
  "/efs/shared"
end

if shared_filesystem?
  run "echo 'Shared File System found. Symlinking...'"
  run "echo 'release_path: #{config.release_path}/public/uploads' >> #{config.shared_path}/logs.log" 
  run "mkdir -p #{efs_mount_point}/public/uploads"
  run "ln -nfs #{efs_mount_point}/public/uploads #{config.release_path}/public/uploads"
else
  run "echo 'Environment does not have a Shared File System'"
end