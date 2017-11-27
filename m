Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41325 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751690AbdK0Vxp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 16:53:45 -0500
Date: Mon, 27 Nov 2017 21:53:43 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.16] RC changes
Message-ID: <20171127215343.lowcktqozx7qp5kh@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is my big rc-core pull request. In summary:

 - Teaches ir-kbd-i2c to send raw IR with the zilog microcontroller,
   tested on PVR-150 (ivtv), HVR-1600 (cx18), HD-PVR (hdpvr). Only
   driver which supports this hardware not tested is usbpvr2.

 - Removes lirc_zilog, lirc staging and lirc kapi. This breaks any
   out of tree lirc drivers.

 - Introduces lirc mode scancode for transmission using the IR encoders,
   and receiving full IR protocol information for decoded IR (requires
   kfifo fix)

 - Various bugs with the lirc uapi have been fixed (e.g. locking), and
   now a lirc device can be opened more than once.

 - Line count is down 1500 and code is cleaner.

Thanks,

Sean

The following changes since commit 04226916d2360f56d57ad00bc48d2d1854d1e0b0:

  media: usbtv: add a new usbid (2017-11-27 14:49:18 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.16a

for you to fetch changes up to b2c96ba352b5ba1f68d13f24d62cbccdb8faa3be:

  media: cec: move cec autorepeat handling to rc-core (2017-11-27 21:44:09 +0000)

----------------------------------------------------------------
Arvind Yadav (1):
      media: winbond-cir: Fix pnp_irq's error checking for wbcir_probe

Chunyan Zhang (1):
      media: rc: Replace timeval with ktime_t in imon.c

Sean Young (33):
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
      media: lirc: do not call close() or open() on unregistered devices
      media: lirc: create rc-core open and close lirc functions
      media: lirc: remove name from lirc_dev
      media: lirc: remove last remnants of lirc kapi
      media: lirc: implement reading scancode
      media: lirc: ensure lirc device receives nec repeats
      media: lirc: document LIRC_MODE_SCANCODE
      media: lirc: scancode rc devices should have a lirc device too
      kfifo: DECLARE_KIFO_PTR(fifo, u64) does not work on arm 32 bit
      media: rc: move ir-lirc-codec.c contents into lirc_dev.c
      media: rc: include <uapi/linux/lirc.h> rather than <media/lirc.h>
      media: lirc: allow lirc device to be opened more than once
      media: lirc: improve locking
      media: imon: auto-config ffdc 30 device
      media: cec: move cec autorepeat handling to rc-core

 Documentation/media/kapi/rc-core.rst               |    5 -
 Documentation/media/lirc.h.rst.exceptions          |   31 +
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |   68 +-
 Documentation/media/uapi/rc/lirc-func.rst          |    1 -
 Documentation/media/uapi/rc/lirc-get-features.rst  |   17 +-
 Documentation/media/uapi/rc/lirc-get-length.rst    |   44 -
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |    5 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |    2 +-
 Documentation/media/uapi/rc/lirc-read.rst          |   15 +-
 Documentation/media/uapi/rc/lirc-write.rst         |   19 +-
 MAINTAINERS                                        |    6 -
 drivers/media/cec/cec-adap.c                       |   56 +-
 drivers/media/cec/cec-core.c                       |   12 -
 drivers/media/i2c/ir-kbd-i2c.c                     |  540 ++++++-
 drivers/media/pci/cx18/cx18-cards.h                |    8 +-
 drivers/media/pci/cx18/cx18-i2c.c                  |   13 +-
 drivers/media/pci/ivtv/ivtv-cards.h                |   22 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |   20 +-
 drivers/media/pci/saa7134/saa7134-input.c          |    3 +-
 drivers/media/rc/Kconfig                           |   29 +-
 drivers/media/rc/Makefile                          |    5 +-
 drivers/media/rc/imon.c                            |   27 +-
 drivers/media/rc/ir-jvc-decoder.c                  |    1 +
 drivers/media/rc/ir-lirc-codec.c                   |  448 ------
 drivers/media/rc/ir-mce_kbd-decoder.c              |   12 +-
 drivers/media/rc/ir-nec-decoder.c                  |    1 +
 drivers/media/rc/ir-rc5-decoder.c                  |    1 +
 drivers/media/rc/ir-rc6-decoder.c                  |    1 +
 drivers/media/rc/ir-sanyo-decoder.c                |    1 +
 drivers/media/rc/ir-sharp-decoder.c                |    1 +
 drivers/media/rc/ir-sony-decoder.c                 |    1 +
 drivers/media/rc/lirc_dev.c                        |  982 ++++++++----
 drivers/media/rc/rc-core-priv.h                    |   52 +-
 drivers/media/rc/rc-ir-raw.c                       |   56 +-
 drivers/media/rc/rc-main.c                         |  229 ++-
 drivers/media/rc/winbond-cir.c                     |    2 +-
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
 include/media/cec.h                                |    5 -
 include/media/i2c/ir-kbd-i2c.h                     |    6 +-
 include/media/lirc.h                               |    1 -
 include/media/lirc_dev.h                           |  192 ---
 include/media/rc-core.h                            |   65 +-
 include/media/rc-map.h                             |   54 +-
 include/uapi/linux/lirc.h                          |   82 +
 54 files changed, 1707 insertions(+), 3207 deletions(-)
 delete mode 100644 Documentation/media/uapi/rc/lirc-get-length.rst
 delete mode 100644 drivers/media/rc/ir-lirc-codec.c
 delete mode 100644 drivers/staging/media/lirc/Kconfig
 delete mode 100644 drivers/staging/media/lirc/Makefile
 delete mode 100644 drivers/staging/media/lirc/TODO
 delete mode 100644 drivers/staging/media/lirc/lirc_zilog.c
 delete mode 100644 include/media/lirc.h
 delete mode 100644 include/media/lirc_dev.h
