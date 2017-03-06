Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:35451 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753237AbdCFRtG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 12:49:06 -0500
Date: Mon, 6 Mar 2017 17:38:43 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.12] media/rc: fixes and improvements
Message-ID: <20170306173843.GA20265@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some RC and lirc documentation fixes, a userspace lirc API for sending
IR using the encoders, and lirc userspace API for reading decoded scancodes.

Thanks,

Sean

The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

  Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.12a

for you to fetch changes up to 3e7520f07ac0482ee37a8a71c88d011bf2de5cb6:

  [media] lirc: introduce LIRC_SET_POLL_MODE (2017-03-06 17:23:53 +0000)

----------------------------------------------------------------
Derek Robson (1):
      [media] staging: lirc: use octal instead of symbolic permission

Sean Young (21):
      [media] cxusb: dvico remotes are nec
      [media] lirc: document lirc modes better
      [media] lirc: return ENOTTY when ioctl is not supported
      [media] lirc: return ENOTTY when device does support ioctl
      [media] winbond: allow timeout to be set
      [media] gpio-ir: do not allow a timeout of 0
      [media] rc: lirc keymap no longer makes any sense
      [media] lirc: advertise LIRC_CAN_GET_REC_RESOLUTION and improve
      [media] mce_kbd: add encoder
      [media] serial_ir: iommap is a memory address, not bool
      [media] lirc: use refcounting for lirc devices
      [media] lirc: lirc interface should not be a raw decoder
      [media] lirc: exorcise struct irctl
      [media] lirc: use plain kfifo rather than lirc_buffer
      [media] lirc: implement scancode sending
      [media] rc: use the correct carrier for scancode transmit
      [media] rc: auto load encoder if necessary
      [media] lirc: implement reading scancode
      [media] lirc: scancode rc devices should have a lirc device too
      [media] lirc: document LIRC_MODE_SCANCODE
      [media] lirc: introduce LIRC_SET_POLL_MODE

 Documentation/media/lirc.h.rst.exceptions          |  50 ++-
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |  78 +++-
 Documentation/media/uapi/rc/lirc-func.rst          |   1 +
 Documentation/media/uapi/rc/lirc-get-features.rst  |  28 +-
 Documentation/media/uapi/rc/lirc-get-length.rst    |   3 +-
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |   8 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |   8 +-
 Documentation/media/uapi/rc/lirc-read.rst          |  22 +-
 Documentation/media/uapi/rc/lirc-set-poll-mode.rst |  45 +++
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |   2 +-
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |   2 +
 Documentation/media/uapi/rc/lirc-write.rst         |  25 +-
 drivers/media/rc/Kconfig                           |  15 +-
 drivers/media/rc/Makefile                          |   6 +-
 drivers/media/rc/gpio-ir-recv.c                    |   2 +-
 drivers/media/rc/igorplugusb.c                     |   2 +-
 drivers/media/rc/ir-jvc-decoder.c                  |   1 +
 drivers/media/rc/ir-lirc-codec.c                   | 388 +++++++++++++------
 drivers/media/rc/ir-mce_kbd-decoder.c              |  56 ++-
 drivers/media/rc/ir-nec-decoder.c                  |   1 +
 drivers/media/rc/ir-rc5-decoder.c                  |   1 +
 drivers/media/rc/ir-rc6-decoder.c                  |   1 +
 drivers/media/rc/ir-sanyo-decoder.c                |   1 +
 drivers/media/rc/ir-sharp-decoder.c                |   1 +
 drivers/media/rc/ir-sony-decoder.c                 |   1 +
 drivers/media/rc/keymaps/Makefile                  |   1 -
 drivers/media/rc/keymaps/rc-dvico-mce.c            |  92 ++---
 drivers/media/rc/keymaps/rc-dvico-portable.c       |  74 ++--
 drivers/media/rc/keymaps/rc-lirc.c                 |  42 --
 drivers/media/rc/lirc_dev.c                        | 431 +++++++++------------
 drivers/media/rc/rc-core-priv.h                    |  62 ++-
 drivers/media/rc/rc-ir-raw.c                       |  55 ++-
 drivers/media/rc/rc-main.c                         |  73 ++--
 drivers/media/rc/serial_ir.c                       |   4 +-
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/rc/winbond-cir.c                     |   4 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  24 +-
 drivers/staging/media/lirc/lirc_sasem.c            |   5 +-
 drivers/staging/media/lirc/lirc_sir.c              |   8 +-
 drivers/staging/media/lirc/lirc_zilog.c            | 167 ++++----
 include/media/lirc_dev.h                           |  33 +-
 include/media/rc-core.h                            |   3 +
 include/media/rc-map.h                             | 109 ++----
 include/uapi/linux/lirc.h                          |  85 ++++
 44 files changed, 1246 insertions(+), 776 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-poll-mode.rst
 delete mode 100644 drivers/media/rc/keymaps/rc-lirc.c
