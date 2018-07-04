Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49269 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752881AbeGDVhu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 17:37:50 -0400
Date: Wed, 4 Jul 2018 22:37:48 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.18] leaking bpf programs after detach
Message-ID: <20180704213748.c6m64e4xkqykcyht@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

With the syscall bpf(BPF_PROG_ATTACH), a bpf program can be attached to a
lirc device; that should increase the refcount so that the program is not
freed. However, when we detach the bpf program, we don't decrease the
refcount, so the bpf program will never be freed.

Tested with kasan and ubsan. The list of bpf programs can be using the
bpftool (in the kernel tree), command line "bpftool prog list".

Thanks,

Sean

The following changes since commit 0ca54b29054151b7a52cbb8904732280afe5a302:

  media: rc: be less noisy when driver misbehaves (2018-06-27 10:03:45 -0400)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.18f

for you to fetch changes up to ff003645581b1ee4a0ac80fefdc262a5933b7007:

  media: bpf: ensure bpf program is freed on detach (2018-07-04 20:48:29 +0100)

----------------------------------------------------------------
Sean Young (1):
      media: bpf: ensure bpf program is freed on detach

 drivers/media/rc/bpf-lirc.c | 1 +
 1 file changed, 1 insertion(+)
