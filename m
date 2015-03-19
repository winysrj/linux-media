Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53030 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbbCSVuU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 17:50:20 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [RFC PATCH 0/6] Send and receive decoded IR using lirc interface
Date: Thu, 19 Mar 2015 21:50:11 +0000
Message-Id: <cover.1426801061.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series tries to fix the lirc interface and extend it so it can
be used to send/recv scancodes in addition to raw IR:

 - Make it possible to receive scancodes from hardware that generates 
   scancodes (with rc protocol information)
 - Make it possible to receive decoded scancodes from raw IR, from the 
   in-kernel decoders (not mce mouse/keyboard). Now you can take any
   remote, run ir-rec and you will get both the raw IR and the decoded
   scancodes plus rc protocol information.
 - Make it possible to send scancodes; in kernel-encoding of IR
 - Make it possible to send scancodes for hardware that can only do that
   (so that lirc_zilog can be moved out of staging, not completed yet)
 - Possibly the lirc interface can be used for cec?

This requires a little refactoring.
 - All rc-core devices will have a lirc device associated with them
 - The rc-core <-> lirc bridge no longer is a "decoder", this never made 
   sense and caused confusion

This requires new API for rc-core lirc devices.
 - New feature LIRC_CAN_REC_SCANCODE and LIRC_CAN_SEND_SCANCODE
 - REC_MODE and SEND_MODE do not enable LIRC_MODE_SCANCODE by default since 
   this would confuse existing userspace code
 - For each scancode we need: 
   - rc protocol (RC_TYPE_*) 
   - toggle and repeat bit for some protocols
   - 32 bit scancode

A separate patch will introduce new v4l-utils tools ir-rec and ir-send for 
displaying and sending IR, raw or scancode.

There are few FIXMEs in the code, I am sending this for early feedback. For
example there are no encoders for most IR protocols (just nec).

However the first four patches can be merged as-is should it be accepted.

Sean Young (6):
  [PATCH 1/6] [media] lirc: remove broken features
  [PATCH 2/6] [media] lirc: LIRC_[SG]ET_SEND_MODE should return -ENOSYS
  [PATCH 3/6] [media] rc: lirc bridge should not be a raw decoder
  [PATCH 4/6] [media] rc: lirc is not a protocol or a keymap
  [PATCH 5/6] [media] lirc: pass IR scancodes to userspace via lirc
    bridge
  [PATCH 6/6] [media] rc: teach lirc how to send scancodes

 .../DocBook/media/v4l/lirc_device_interface.xml    |  82 ++++----
 drivers/media/rc/Kconfig                           |  19 +-
 drivers/media/rc/Makefile                          |   6 +-
 drivers/media/rc/ir-lirc-codec.c                   | 211 ++++++++++++---------
 drivers/media/rc/ir-nec-decoder.c                  |  50 +++++
 drivers/media/rc/keymaps/Makefile                  |   1 -
 drivers/media/rc/keymaps/rc-lirc.c                 |  42 ----
 drivers/media/rc/lirc_dev.c                        |  18 +-
 drivers/media/rc/rc-core-priv.h                    |  43 +++--
 drivers/media/rc/rc-ir-raw.c                       |  23 ++-
 drivers/media/rc/rc-main.c                         |  29 ++-
 drivers/media/rc/st_rc.c                           |   2 +-
 include/media/lirc.h                               |  31 ++-
 include/media/rc-core.h                            |   9 +
 include/media/rc-map.h                             |  42 ++--
 15 files changed, 336 insertions(+), 272 deletions(-)
 delete mode 100644 drivers/media/rc/keymaps/rc-lirc.c

-- 
2.1.0

