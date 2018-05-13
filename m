Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50807 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751260AbeEMMi3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 08:38:29 -0400
Date: Sun, 13 May 2018 13:38:27 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.18] RC fixes
Message-ID: <20180513123827.vo5566xuezxwyf3i@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a fix for the lirc docs warning, a fix for the topseed mceusb
device which did not like having its IR timeout set, and some patches
which validate the IR raw events drivers produce.

Thanks
Sean

The following changes since commit 2a5f2705c97625aa1a4e1dd4d584eaa05392e060:

  media: lgdt330x.h: fix compiler warning (2018-05-11 11:40:09 -0400)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.18c

for you to fetch changes up to 4190ce876ae3ac624bbc9d57c10e84525e56be94:

  media: rc: ite-cir: lower timeout and extend allowed timeout range (2018-05-13 13:14:12 +0100)

----------------------------------------------------------------
Matthias Reichl (1):
      media: rc: ite-cir: lower timeout and extend allowed timeout range

Sean Young (8):
      media: mceusb: MCE_CMD_SETIRTIMEOUT cause strange behaviour on device
      media: mceusb: filter out bogus timing irdata of duration 0
      media: mceusb: add missing break
      media: lirc-func.rst: new ioctl LIRC_GET_REC_TIMEOUT is not in a separate file
      media: rc: default to idle on at startup or after reset
      media: rc: drivers should produce alternate pulse and space timing events
      media: rc: decoders do not need to check for transitions
      media: rc: winbond: do not send reset and timeout raw events on startup

 Documentation/media/uapi/rc/lirc-func.rst |  1 -
 drivers/media/rc/ir-mce_kbd-decoder.c     |  6 ------
 drivers/media/rc/ir-rc5-decoder.c         |  3 ---
 drivers/media/rc/ir-rc6-decoder.c         | 10 ----------
 drivers/media/rc/ite-cir.c                |  8 +++++---
 drivers/media/rc/ite-cir.h                |  7 -------
 drivers/media/rc/mceusb.c                 | 28 +++++++++++++++++++++++++---
 drivers/media/rc/rc-ir-raw.c              | 20 ++++++++++++++++----
 drivers/media/rc/winbond-cir.c            |  4 ++--
 include/media/rc-core.h                   |  1 +
 10 files changed, 49 insertions(+), 39 deletions(-)
