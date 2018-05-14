Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44913 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752129AbeENVLD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 17:11:03 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH v1 0/4] IR decoding using BPF
Date: Mon, 14 May 2018 22:10:57 +0100
Message-Id: <cover.1526331777.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kernel IR decoders support the most widely used IR protocols, but there
are many protocols which are not supported[1]. For example, the
lirc-remotes[2] repo has over 2700 remotes, many of which are not supported
by rc-core. There is a "long tail" of unsupported IR protocols.

IR encoding is done in such a way that some simple circuit can decode it;
therefore, bpf is ideal.

In order to support all these protocols, here we have bpf based IR decoding.
The idea is that user-space can define a decoder in bpf, attach it to
the rc device through the lirc chardev.

Separate work is underway to extend ir-keytable to have an extensive library
of bpf-based decoders, and a much expanded library of rc keymaps. 

Another future application would be to compile IRP[3] to a IR BPF program, and
so support virtually every remote without having to write a decoder for each.

Thanks,

Sean Young

[1] http://www.hifi-remote.com/wiki/index.php?title=DecodeIR
[2] https://sourceforge.net/p/lirc-remotes/code/ci/master/tree/remotes/
[3] http://www.hifi-remote.com/wiki/index.php?title=IRP_Notation

Sean Young (4):
  media: rc: introduce BPF_PROG_IR_DECODER
  media: bpf: allow raw IR decoder bpf programs to be used
  media: rc bpf: move ir_raw_event to uapi
  samples/bpf: an example of a raw IR decoder

 drivers/media/rc/Kconfig                  |   8 +
 drivers/media/rc/Makefile                 |   1 +
 drivers/media/rc/ir-bpf-decoder.c         | 284 ++++++++++++++++++++++
 drivers/media/rc/lirc_dev.c               |  30 +++
 drivers/media/rc/rc-core-priv.h           |  15 ++
 drivers/media/rc/rc-ir-raw.c              |   5 +
 include/linux/bpf_types.h                 |   3 +
 include/media/rc-core.h                   |  19 +-
 include/uapi/linux/bpf.h                  |  17 +-
 include/uapi/linux/bpf_rcdev.h            |  24 ++
 kernel/bpf/syscall.c                      |   7 +
 samples/bpf/Makefile                      |   4 +
 samples/bpf/bpf_load.c                    |   9 +-
 samples/bpf/grundig_decoder_kern.c        | 112 +++++++++
 samples/bpf/grundig_decoder_user.c        |  54 ++++
 tools/bpf/bpftool/prog.c                  |   1 +
 tools/include/uapi/linux/bpf.h            |  17 +-
 tools/testing/selftests/bpf/bpf_helpers.h |   6 +
 18 files changed, 594 insertions(+), 22 deletions(-)
 create mode 100644 drivers/media/rc/ir-bpf-decoder.c
 create mode 100644 include/uapi/linux/bpf_rcdev.h
 create mode 100644 samples/bpf/grundig_decoder_kern.c
 create mode 100644 samples/bpf/grundig_decoder_user.c

-- 
2.17.0
