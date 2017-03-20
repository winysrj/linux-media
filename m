Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:41975 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753766AbdCTPFA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 11:05:00 -0400
Date: Mon, 20 Mar 2017 15:04:58 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v4.12] RC fixes
Message-ID: <20170320150457.GA18384@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Various small RC fixes and documentation fixes. The most controversial is
the changing of the return code of lirc ioctls. I've tested lirc. If you
can think of anything else which needs testing, please let me know.

Thanks,
Sean

The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

  Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.12b

for you to fetch changes up to 3349540fb070a97d9cbd92a925235618490ec6d9:

  [media] rc: sunxi-cir: simplify optional reset handling (2017-03-20 12:08:28 +0000)

----------------------------------------------------------------
Derek Robson (1):
      [media] staging: lirc: use octal instead of symbolic permission

Johan Hovold (1):
      [media] mceusb: fix NULL-deref at probe

Philipp Zabel (2):
      [media] st_rc: simplify optional reset handling
      [media] rc: sunxi-cir: simplify optional reset handling

Sean Young (11):
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

 Documentation/media/lirc.h.rst.exceptions          |   1 -
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |  53 +++++++--
 Documentation/media/uapi/rc/lirc-get-features.rst  |  13 ++-
 Documentation/media/uapi/rc/lirc-get-length.rst    |   3 +-
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |   4 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |   7 +-
 Documentation/media/uapi/rc/lirc-read.rst          |  16 +--
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |   2 +-
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |   2 +
 Documentation/media/uapi/rc/lirc-write.rst         |  17 +--
 drivers/media/rc/gpio-ir-recv.c                    |   2 +-
 drivers/media/rc/igorplugusb.c                     |   2 +-
 drivers/media/rc/ir-lirc-codec.c                   |  34 ++++--
 drivers/media/rc/ir-mce_kbd-decoder.c              |  49 ++++++++-
 drivers/media/rc/keymaps/Makefile                  |   1 -
 drivers/media/rc/keymaps/rc-dvico-mce.c            |  92 ++++++++--------
 drivers/media/rc/keymaps/rc-dvico-portable.c       |  74 ++++++-------
 drivers/media/rc/keymaps/rc-lirc.c                 |  42 -------
 drivers/media/rc/lirc_dev.c                        | 122 +++++++++------------
 drivers/media/rc/mceusb.c                          |   4 +-
 drivers/media/rc/rc-core-priv.h                    |   2 +-
 drivers/media/rc/rc-ir-raw.c                       |   6 +-
 drivers/media/rc/rc-main.c                         |   8 +-
 drivers/media/rc/serial_ir.c                       |   4 +-
 drivers/media/rc/st_rc.c                           |  15 ++-
 drivers/media/rc/sunxi-cir.c                       |  21 ++--
 drivers/media/rc/winbond-cir.c                     |   4 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  24 ++--
 drivers/staging/media/lirc/lirc_sasem.c            |   2 +-
 drivers/staging/media/lirc/lirc_sir.c              |   8 +-
 include/media/rc-map.h                             |  79 ++++++-------
 31 files changed, 378 insertions(+), 335 deletions(-)
 delete mode 100644 drivers/media/rc/keymaps/rc-lirc.c
