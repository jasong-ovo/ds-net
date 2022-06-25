import torch
import torch.nn as nn

if __name__ == "__main__":
    a = torch.randn(3, 3)
    a.diagonal(0) 
