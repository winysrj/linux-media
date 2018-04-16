Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43691 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751042AbeDPPKp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 11:10:45 -0400
Date: Mon, 16 Apr 2018 16:10:44 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.18] rc changes
Message-ID: <20180416151044.ozm4qnvdp6t7f2iq@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These patches include the low latency changes, which do make IR more
responsive. These patches could breaks things in subtle ways, so it
would be great to have these changes in early in the cycle.

Thanks,
Sean

The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:

  Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.18a

for you to fetch changes up to e3313098d94c3e6df414e72732bdb5ae9f581185:

  media: rc: mtk-cir: use of_device_get_match_data() (2018-04-16 14:37:52 +0100)

----------------------------------------------------------------
Andi Shyti (1):
      media: rc: ir-spi: update Andi's e-mail

Ryder Lee (1):
      media: rc: mtk-cir: use of_device_get_match_data()

Sean Young (11):
      media: rc: report receiver and transmitter type on device register
      media: rc: set timeout to smallest value required by enabled protocols
      media: rc: add ioctl to get the current timeout
      media: rc: per-protocol repeat period and minimum keyup timer
      media: rc: mce_kbd decoder: low timeout values cause double keydowns
      media: rc: mce_kbd protocol encodes two scancodes
      media: rc: mce_kbd decoder: fix stuck keys
      media: rc: mce_kbd decoder: remove superfluous call to input_sync
      media: rc: mce_kbd decoder: fix race condition
      media: rc: mceusb: allow the timeout to be configurable
      media: cx88: enable IR transmitter on HVR-1300

 Documentation/media/uapi/rc/lirc-dev-intro.rst     |  2 +-
 Documentation/media/uapi/rc/lirc-func.rst          |  1 +
 .../media/uapi/rc/lirc-set-rec-timeout.rst         | 14 +++--
 drivers/media/cec/cec-core.c                       |  2 +-
 drivers/media/pci/cx88/cx88-input.c                |  5 +-
 drivers/media/rc/ir-imon-decoder.c                 |  1 +
 drivers/media/rc/ir-jvc-decoder.c                  |  1 +
 drivers/media/rc/ir-mce_kbd-decoder.c              | 58 +++++++++++-------
 drivers/media/rc/ir-nec-decoder.c                  |  1 +
 drivers/media/rc/ir-rc5-decoder.c                  |  1 +
 drivers/media/rc/ir-rc6-decoder.c                  |  1 +
 drivers/media/rc/ir-sanyo-decoder.c                |  1 +
 drivers/media/rc/ir-sharp-decoder.c                |  1 +
 drivers/media/rc/ir-sony-decoder.c                 |  1 +
 drivers/media/rc/ir-spi.c                          |  4 +-
 drivers/media/rc/ir-xmp-decoder.c                  |  1 +
 drivers/media/rc/lirc_dev.c                        | 31 +++++++++-
 drivers/media/rc/mceusb.c                          | 22 +++++++
 drivers/media/rc/mtk-cir.c                         |  4 +-
 drivers/media/rc/rc-core-priv.h                    |  3 +
 drivers/media/rc/rc-ir-raw.c                       | 31 +++++++++-
 drivers/media/rc/rc-main.c                         | 68 +++++++++++-----------
 include/uapi/linux/lirc.h                          |  6 ++
 23 files changed, 188 insertions(+), 72 deletions(-)
