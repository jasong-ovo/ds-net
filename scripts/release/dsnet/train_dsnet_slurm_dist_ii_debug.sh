ngpu=1
batch_size=8
tag=train_dsnet_slurm_dist_bs_8

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
    --job-name=_dsnet_debug \
    --gres=gpu:$ngpu \
    --ntasks=1 \
    --ntasks-per-node=1 \
    --mpi=pmi2  --quotatype=reserved\
    --cpus-per-task=8 \
    python -u cfg_train.py \
        --tcp_port $PORT \
        --batch_size $batch_size \
        --config cfgs/release/dsnet.yaml \
        --pretrained_ckpt pretrained_weight/offset_pretrain_pq_0.564.pth \
        --tag $tag \
        --launcher slurm \
        --fix_semantic_instance
