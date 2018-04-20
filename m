Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52245 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753743AbeDTIAf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 04:00:35 -0400
Date: Fri, 20 Apr 2018 09:00:33 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Subject: [GIT PULL v2 FOR v4.18] rc changes
Message-ID: <20180420080033.7q5idv6bc5yw4vnu@gofer.mess.org>
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

The following changes since commit 8b8fcf32502694971fb7f166030361212cb2f9e6:

  media: ddbridge: don't uselessly check for dma in start/stop functions (2018-04-17 05:52:43 -0400)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.18a

for you to fetch changes up to d0ae74e455d6a5328a1ea601b926c5c66e0c7fd0:

  media: rc: mtk-cir: use of_device_get_match_data() (2018-04-19 23:28:22 +0100)

----------------------------------------------------------------
Andi Shyti (1):
      media: rc: ir-spi: update Andi's e-mail

Ryder Lee (1):
      media: rc: mtk-cir: use of_device_get_match_data()

Sean Young (12):
      media: rc: report receiver and transmitter type on device register
      media: rc: set timeout to smallest value required by enabled protocols
      media: rc: add ioctl to get the current timeout
      media: rc: per-protocol repeat period and minimum keyup timer
      media: rc: mce_kbd decoder: low timeout values cause double keydowns
      media: rc: mce_kbd protocol encodes two scancodes
      media: rc: mce_kbd decoder: fix stuck keys
      media: rc: mce_kbd decoder: remove superfluous call to input_sync
      media: rc: mce_kbd decoder: fix race condition
      media: rc: mceusb: IR of length 0 means IR timeout, not reset
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
 drivers/media/rc/mceusb.c                          | 29 ++++++++-
 drivers/media/rc/mtk-cir.c                         |  4 +-
 drivers/media/rc/rc-core-priv.h                    |  3 +
 drivers/media/rc/rc-ir-raw.c                       | 31 +++++++++-
 drivers/media/rc/rc-main.c                         | 68 +++++++++++-----------
 include/uapi/linux/lirc.h                          |  6 ++
 23 files changed, 194 insertions(+), 73 deletions(-)
