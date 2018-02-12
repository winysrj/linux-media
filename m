Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48329 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750924AbeBLUDT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 15:03:19 -0500
Date: Mon, 12 Feb 2018 20:03:18 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.17] rc changes
Message-ID: <20180212200318.cxnxro2vsqauexqz@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just very minor changes this time (other stuff is not ready yet). I would
really appreciate if you could cast an extra critical eye on the commit 
"no need to check for transitions", just to be sure it is the right change.

Thanks,

Sean

The following changes since commit 61605f79d576b0c2bea98fd0d1b2b3eeebb682f0:

  Merge tag 'v4.16-rc1' into patchwork (2018-02-12 07:52:06 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.17a

for you to fetch changes up to 42ed0e7cd25fe42cf2ba16b0962fe018676b4da6:

  media: rc: get start time just before calling driver tx (2018-02-12 14:56:59 +0000)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      media: rc: ir-hix5hd2: fix error handling of clk_prepare_enable()

Andi Kleen (1):
      media: rc: don't mark IR decoders default y

Sean Young (8):
      media: rc: ir-spi: fix duty cycle
      media: rc: no need to check for transitions
      media: rc: unnecessary use of do_div
      media: rc: replace IR_dprintk() with dev_dbg in IR decoders
      media: rc: remove IR_dprintk() from rc-core
      media: rc: remove obsolete comment
      media: rc: remove useless if statement
      media: rc: get start time just before calling driver tx

 drivers/media/rc/Kconfig              | 11 -----
 drivers/media/rc/ir-hix5hd2.c         | 35 +++++++++++---
 drivers/media/rc/ir-jvc-decoder.c     | 14 +++---
 drivers/media/rc/ir-mce_kbd-decoder.c | 66 ++++++++++++-------------
 drivers/media/rc/ir-nec-decoder.c     | 20 ++++----
 drivers/media/rc/ir-rc5-decoder.c     | 15 +++---
 drivers/media/rc/ir-rc6-decoder.c     | 35 ++++++--------
 drivers/media/rc/ir-sanyo-decoder.c   | 18 +++----
 drivers/media/rc/ir-sharp-decoder.c   | 17 +++----
 drivers/media/rc/ir-sony-decoder.c    | 14 +++---
 drivers/media/rc/ir-spi.c             | 24 +--------
 drivers/media/rc/ir-xmp-decoder.c     | 29 +++++------
 drivers/media/rc/lirc_dev.c           | 24 +++++----
 drivers/media/rc/rc-core-priv.h       | 13 -----
 drivers/media/rc/rc-ir-raw.c          |  7 ++-
 drivers/media/rc/rc-main.c            | 91 +++++++++++++++++------------------
 include/media/rc-core.h               |  7 ---
 17 files changed, 196 insertions(+), 244 deletions(-)
