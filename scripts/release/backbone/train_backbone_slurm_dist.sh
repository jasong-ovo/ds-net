ngpu=2
tag=train_backbone_slurm_dist

# find available port
while true
do
    PORT=$(( ((RANDOM<<15)|RANDOM) % 49152 + 10000 ))
    status="$(nc -z 127.0.0.1 $PORT < /dev/null &>/dev/null; echo $?)"
    if [ "${status}" != "0" ]; then
        break;
    fi
done
echo $PORT

srun -p ai4science \
    --job-name=ds_train_backbone \
    --gres=gpu:${ngpu} \
    --ntasks=${ngpu} \
    --mpi=pmi2 \
    --ntasks-per-node=${ngpu} \
    --kill-on-bad-exit=1 \
    #-w SG-IDC1-10-51-2-74 \
    python -u cfg_train.py \
        --tcp_port $PORT \
        --batch_size ${ngpu} \
        --config cfgs/release/backbone.yaml \
        --pretrained_ckpt pretrained_weight/sem_pretrain.pth \
        --tag ${tag} \
        --launcher slurm
