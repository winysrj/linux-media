Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59205 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932348AbdLOQzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 11:55:07 -0500
Date: Fri, 15 Dec 2017 16:55:06 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.16] RC fixes
Message-ID: <20171215165506.aruixz775skkvpxa@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some regressions and improvements since the lirc scancodes changes. 

Thanks,

Sean

The following changes since commit 0ca4e3130402caea8731a7b54afde56a6edb17c9:

  media: pxa_camera: rename the soc_camera_ prefix to pxa_camera_ (2017-12-14 12:40:01 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.16b

for you to fetch changes up to 4cb896c68d5296e2af834033a34575f61fc5228f:

  media: ir-spi: add SPDX identifier (2017-12-15 16:42:11 +0000)

----------------------------------------------------------------
Andi Shyti (1):
      media: ir-spi: add SPDX identifier

Sean Young (8):
      media: imon: auto-config ffdc 26 device
      media: imon: remove unused function tv2int
      media: rc: bang in ir_do_keyup
      media: lirc: when transmitting scancodes, block until transmit is done
      media: rc: iguanair: simplify tx loop
      media: lirc: do not pass ERR_PTR to kfree
      media: lirc: no need to recalculate duration
      media: lirc: release lock before sleep

 Documentation/media/uapi/rc/lirc-write.rst |  4 +-
 drivers/media/rc/iguanair.c                | 19 ++++-----
 drivers/media/rc/imon.c                    | 28 +++----------
 drivers/media/rc/ir-spi.c                  | 15 +++----
 drivers/media/rc/lirc_dev.c                | 67 ++++++++++++++----------------
 drivers/media/rc/rc-main.c                 |  2 +-
 6 files changed, 53 insertions(+), 82 deletions(-)
