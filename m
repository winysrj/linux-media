Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59117 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751859AbeEOSuX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 14:50:23 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>
Subject: [PATCH v2 0/2] IR decoding using BPF
Date: Tue, 15 May 2018 19:50:18 +0100
Message-Id: <cover.1526409690.git.sean@mess.org>
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

Changes since v1:
 - Code review comments from Y Song <ys114321@gmail.com> and
   Randy Dunlap <rdunlap@infradead.org>
 - Re-wrote sample bpf to be selftest
 - Renamed RAWIR_DECODER -> RAWIR_EVENT (Kconfig, context, bpf prog type)
 - Rebase on bpf-next
 - Introduced bpf_rawir_event context structure with simpler access checking

Sean Young (2):
  media: rc: introduce BPF_PROG_RAWIR_EVENT
  bpf: add selftest for rawir_event type program

 drivers/media/rc/Kconfig                      |  10 +
 drivers/media/rc/Makefile                     |   1 +
 drivers/media/rc/bpf-rawir-event.c            | 322 ++++++++++++++++++
 drivers/media/rc/lirc_dev.c                   |  28 ++
 drivers/media/rc/rc-core-priv.h               |  19 ++
 drivers/media/rc/rc-ir-raw.c                  |   3 +
 include/linux/bpf_rcdev.h                     |  30 ++
 include/linux/bpf_types.h                     |   3 +
 include/uapi/linux/bpf.h                      |  55 ++-
 kernel/bpf/syscall.c                          |   7 +
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |  55 ++-
 tools/lib/bpf/libbpf.c                        |   1 +
 tools/testing/selftests/bpf/Makefile          |   7 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   6 +
 tools/testing/selftests/bpf/test_rawir.sh     |  37 ++
 .../selftests/bpf/test_rawir_event_kern.c     |  26 ++
 .../selftests/bpf/test_rawir_event_user.c     |  90 +++++
 18 files changed, 696 insertions(+), 5 deletions(-)
 create mode 100644 drivers/media/rc/bpf-rawir-event.c
 create mode 100644 include/linux/bpf_rcdev.h
 create mode 100755 tools/testing/selftests/bpf/test_rawir.sh
 create mode 100644 tools/testing/selftests/bpf/test_rawir_event_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_rawir_event_user.c

-- 
2.17.0
