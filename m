Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36197 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751642AbeCHSSa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 13:18:30 -0500
Date: Thu, 8 Mar 2018 18:18:29 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.17] RC imon and sunxi fixes
Message-ID: <20180308181829.swlvhbaysdjj5r3r@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

There is a new driver for older, raw IR imon devices and a raw decoder for
the imon protocol for imon pad remotes.

Thanks,

Sean

The following changes since commit 50718972f555cc7a061162003f1bc59ef6635db1:

  media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 05:23:45 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.17c

for you to fetch changes up to f637937e5b05a9221deea488f2f329efcb8df59e:

  media: imon: rename protocol from other to imon (2018-03-08 11:22:53 +0000)

----------------------------------------------------------------
Philipp Rossak (2):
      media: rc: update sunxi-ir driver to get base clock frequency from devicetree
      media: dt: bindings: Update binding documentation for sunxi IR controller

Sean Young (6):
      Revert "[media] staging: lirc_imon: port remaining usb ids to imon and remove"
      media: rc: add keymap for iMON RSC remote
      media: rc: new driver for early iMon device
      media: rc: oops in ir_timer_keyup after device unplug
      media: rc: add new imon protocol decoder and encoder
      media: imon: rename protocol from other to imon

 .../devicetree/bindings/media/sunxi-ir.txt         |   3 +
 MAINTAINERS                                        |   7 +
 drivers/media/rc/Kconfig                           |  21 +++
 drivers/media/rc/Makefile                          |   2 +
 drivers/media/rc/imon.c                            | 170 +++---------------
 drivers/media/rc/imon_raw.c                        | 199 +++++++++++++++++++++
 drivers/media/rc/ir-imon-decoder.c                 | 193 ++++++++++++++++++++
 drivers/media/rc/keymaps/Makefile                  |   1 +
 drivers/media/rc/keymaps/rc-imon-pad.c             |   3 +-
 drivers/media/rc/keymaps/rc-imon-rsc.c             |  81 +++++++++
 drivers/media/rc/rc-core-priv.h                    |   6 +
 drivers/media/rc/rc-main.c                         |   9 +-
 drivers/media/rc/sunxi-cir.c                       |  19 +-
 include/media/rc-map.h                             |   9 +-
 include/uapi/linux/lirc.h                          |   2 +
 15 files changed, 568 insertions(+), 157 deletions(-)
 create mode 100644 drivers/media/rc/imon_raw.c
 create mode 100644 drivers/media/rc/ir-imon-decoder.c
 create mode 100644 drivers/media/rc/keymaps/rc-imon-rsc.c
