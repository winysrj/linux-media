Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48933
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753253AbdFMOtV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 10:49:21 -0400
Date: Tue, 13 Jun 2017 11:49:12 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.12-rc6] media fixes
Message-ID: <20170613114912.2959beb4@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.12-3

For:

  - some build dependency issues at CEC core with randconfigs;
  - fix an off by one error at vb2;
  - a race fix at cec core;
  - driver fixes at tc358743, sir_ir and rainshadow-cec.

Regards,
Mauro

-

The following changes since commit 963761a0b2e85663ee4a5630f72930885a06598a:

  [media] rc-core: race condition during ir_raw_event_register() (2017-06-04 15:25:38 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.12-3

for you to fetch changes up to f9f314f323951a33d8b4a4f63f7d04b7f3bc0603:

  [media] media/cec.h: use IS_REACHABLE instead of IS_ENABLED (2017-06-08 16:52:28 -0300)

----------------------------------------------------------------
media fixes for v4.12-rc6

----------------------------------------------------------------
Arnd Bergmann (2):
      [media] cec: improve MEDIA_CEC_RC dependencies
      [media] cec-notifier.h: handle unreachable CONFIG_CEC_CORE

Christophe JAILLET (1):
      [media] vb2: Fix an off by one error in 'vb2_plane_vaddr'

Hans Verkuil (2):
      [media] cec: race fix: don't return -ENONET in cec_receive()
      [media] media/cec.h: use IS_REACHABLE instead of IS_ENABLED

Philipp Zabel (1):
      [media] tc358743: fix register i2c_rd/wr function fix

Sean Young (1):
      [media] sir_ir: infinite loop in interrupt handler

Wei Yongjun (1):
      [media] rainshadow-cec: Fix missing spin_lock_init()

 drivers/media/cec/Kconfig                         |  1 +
 drivers/media/cec/cec-api.c                       |  8 +-------
 drivers/media/i2c/tc358743.c                      |  2 +-
 drivers/media/rc/sir_ir.c                         |  6 ++++++
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c |  1 +
 drivers/media/v4l2-core/videobuf2-core.c          |  2 +-
 include/media/cec-notifier.h                      | 10 ++++++++++
 include/media/cec.h                               |  2 +-
 8 files changed, 22 insertions(+), 10 deletions(-)
