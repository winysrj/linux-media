Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55549 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdJ2U6V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:21 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Walls <awalls.cx18@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org
Subject: [PATCH 00/28] lirc scancode interface, and more
Date: Sun, 29 Oct 2017 20:58:18 +0000
Message-Id: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Port lirc_zilog to rc-core, introduce lirc scancode mode for
sending and receiving, and then remove the lirc kernel api.

Note that the ported zilog driver needs the scancode interface,
since without it the RC_DRIVER_SCANCODE type IR driver would not
have a lirc chardev.

In summary:
 - This removes the lirc staging directory.
 - lirc IR TX can use in-kernel encoders for scancode encoding
 - lirc_zilog now can transmit raw IR (or scancodes using above interface)
 - lirc kapi (not uapi!) is gone
 - The reading lirc scancode interface gives more information (e.g. protocol,
   toggle, repeat). So you can determine what protocol variant a remotes uses
 - Line count is actually down and code cleaner (imo)

v2:
 - Add MAINTAINERS entries
 - Fixes for nec repeat
 - Validate scancode for tx
 - Minor bugfixes

v3:
 - Review comments from Hans Verkuil
 - Documented and fixed rc_validate_scancode()
 - Fix a bug in kfifo on arm 32-bit
 - this inferface won't be used for cec remote control passthrough

v4:
 - Rewrote zilog driver to send raw IR rather than codes from database
 - Minor ir-kbd-i2c improvements

Sean Young (28):
  media: rc: i2c: set parent of rc device and improve name
  media: rc: i2c: use dev_dbg rather hand-rolled debug
  media: rc: i2c: only poll if the rc device is opened
  media: merge ir_tx_z8f0811_haup and ir_rx_z8f0811_haup i2c devices
  media: rc: implement zilog transmitter
  media: i2c: enable i2c IR for hardware which isn't HD-PVR
  media: staging: remove lirc_zilog driver
  media: MAINTAINERS: remove lirc staging area
  media: lirc: remove LIRCCODE and LIRC_GET_LENGTH
  media: lirc: implement scancode sending
  media: lirc: use the correct carrier for scancode transmit
  media: rc: auto load encoder if necessary
  media: lirc: lirc interface should not be a raw decoder
  media: lirc: validate scancode for transmit
  media: rc: document and fix rc_validate_scancode()
  media: lirc: merge lirc_dev_fop_ioctl and ir_lirc_ioctl
  media: lirc: use kfifo rather than lirc_buffer for raw IR
  media: lirc: move lirc_dev->attached to rc_dev->registered
  media: lirc: do not call rc_close() on unregistered devices
  media: lirc: create rc-core open and close lirc functions
  media: lirc: remove name from lirc_dev
  media: lirc: remove last remnants of lirc kapi
  media: lirc: implement reading scancode
  media: rc: ensure lirc device receives nec repeats
  media: lirc: document LIRC_MODE_SCANCODE
  media: lirc: introduce LIRC_SET_POLL_MODES
  media: lirc: scancode rc devices should have a lirc device too
  kfifo: DECLARE_KIFO_PTR(fifo, u64) does not work on arm 32 bit

 Documentation/media/kapi/rc-core.rst               |    5 -
 Documentation/media/lirc.h.rst.exceptions          |   31 +
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |   68 +-
 Documentation/media/uapi/rc/lirc-func.rst          |    2 +-
 Documentation/media/uapi/rc/lirc-get-features.rst  |   17 +-
 Documentation/media/uapi/rc/lirc-get-length.rst    |   44 -
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |    5 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |    2 +-
 Documentation/media/uapi/rc/lirc-read.rst          |   15 +-
 .../media/uapi/rc/lirc-set-poll-modes.rst          |   52 +
 Documentation/media/uapi/rc/lirc-write.rst         |   19 +-
 MAINTAINERS                                        |    6 -
 drivers/media/i2c/ir-kbd-i2c.c                     |  540 ++++++-
 drivers/media/pci/cx18/cx18-cards.h                |    8 +-
 drivers/media/pci/cx18/cx18-i2c.c                  |   13 +-
 drivers/media/pci/ivtv/ivtv-cards.h                |   22 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |   20 +-
 drivers/media/pci/saa7134/saa7134-input.c          |    3 +-
 drivers/media/rc/Kconfig                           |   29 +-
 drivers/media/rc/Makefile                          |    5 +-
 drivers/media/rc/ir-jvc-decoder.c                  |    1 +
 drivers/media/rc/ir-lirc-codec.c                   |  559 ++++---
 drivers/media/rc/ir-mce_kbd-decoder.c              |   12 +-
 drivers/media/rc/ir-nec-decoder.c                  |    1 +
 drivers/media/rc/ir-rc5-decoder.c                  |    1 +
 drivers/media/rc/ir-rc6-decoder.c                  |    1 +
 drivers/media/rc/ir-sanyo-decoder.c                |    1 +
 drivers/media/rc/ir-sharp-decoder.c                |    1 +
 drivers/media/rc/ir-sony-decoder.c                 |    1 +
 drivers/media/rc/lirc_dev.c                        |  487 +-----
 drivers/media/rc/rc-core-priv.h                    |   54 +-
 drivers/media/rc/rc-ir-raw.c                       |   56 +-
 drivers/media/rc/rc-main.c                         |  166 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |   11 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   23 +-
 drivers/media/usb/hdpvr/hdpvr.h                    |    3 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |   13 +-
 drivers/staging/media/Kconfig                      |    3 -
 drivers/staging/media/Makefile                     |    1 -
 drivers/staging/media/lirc/Kconfig                 |   21 -
 drivers/staging/media/lirc/Makefile                |    6 -
 drivers/staging/media/lirc/TODO                    |   36 -
 drivers/staging/media/lirc/lirc_zilog.c            | 1653 --------------------
 include/linux/kfifo.h                              |    3 +-
 include/media/i2c/ir-kbd-i2c.h                     |    6 +-
 include/media/lirc_dev.h                           |  192 ---
 include/media/rc-core.h                            |   53 +-
 include/media/rc-map.h                             |   54 +-
 include/uapi/linux/lirc.h                          |   91 ++
 49 files changed, 1479 insertions(+), 2937 deletions(-)
 delete mode 100644 Documentation/media/uapi/rc/lirc-get-length.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-poll-modes.rst
 delete mode 100644 drivers/staging/media/lirc/Kconfig
 delete mode 100644 drivers/staging/media/lirc/Makefile
 delete mode 100644 drivers/staging/media/lirc/TODO
 delete mode 100644 drivers/staging/media/lirc/lirc_zilog.c
 delete mode 100644 include/media/lirc_dev.h

-- 
2.13.6
