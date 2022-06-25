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

srun -p ai4science --job-name=ds_train_backbone --gres=gpu:$ngpu --ntasks=1 --mpi=pmi2 --ntasks-per-node=1 --quotatype=reserved\
        python -u cfg_train.py \
        --tcp_port $PORT \
        --batch_size 16 \
        --config cfgs/release/backbone.yaml \
        --pretrained_ckpt pretrained_weight/checkpoint_epoch_7_0.629_0.558_0.632.pth\
        --tag $tag \
        --launcher slurm
    # #-w SG-IDC1-10-51-2-74 \
    # python -u cfg_train.py \
    #     --tcp_port $PORT \
    #     --batch_size ${ngpu} \
    #     --config cfgs/release/backbone.yaml \
    #     --pretrained_ckpt pretrained_weight/sem_pretrain.pth \
    #     --tag ${tag} \
    #     --launcher slurm
