# 编译torch时使用的cudnn和cuda版本
import torch
print(torch.__version__)

print(torch.version.cuda)
print(torch.backends.cudnn.version())