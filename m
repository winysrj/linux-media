Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54193 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbeKGHGs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 02:06:48 -0500
Date: Tue, 6 Nov 2018 21:39:32 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.21] rc changes
Message-ID: <20181106213932.boecsqxcv4wurz3c@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A new driver for the usb IR receiver for the original XBox, and a few
minor fixes.

Thanks,

Sean

The following changes since commit ef86eaf97acd6d82cd3fd40f997b1c8c4895a443:

  media: Rename vb2_m2m_request_queue -> v4l2_m2m_request_queue (2018-11-06 05:24:22 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.21a

for you to fetch changes up to ca8dc4056dcff7c0cfcb0daaf0b630bcfa34c932:

  media: rc: ensure close() is called on rc_unregister_device (2018-11-06 10:55:53 +0000)

----------------------------------------------------------------
Benjamin Valentin (1):
      media: rc: add driver for Xbox DVD Movie Playback Kit

Brad Love (1):
      mceusb: Include three Hauppauge USB dvb device with IR rx

Mauro Carvalho Chehab (1):
      media: rc: imon: replace strcpy() by strscpy()

Sean Young (6):
      media: rc: XBox DVD Remote uses 12 bits scancodes
      media: rc: imon_raw: use fls rather than loop per bit
      media: saa7134: rc device does not need 'saa7134 IR (' prefix
      media: saa7134: hvr1110 can decode rc6
      media: rc: cec devices do not have a lirc chardev
      media: rc: ensure close() is called on rc_unregister_device

 MAINTAINERS                               |   6 +
 drivers/media/pci/saa7134/saa7134-input.c |  47 +----
 drivers/media/pci/saa7134/saa7134.h       |   1 -
 drivers/media/rc/Kconfig                  |  12 ++
 drivers/media/rc/Makefile                 |   1 +
 drivers/media/rc/imon.c                   |   4 +-
 drivers/media/rc/imon_raw.c               |  47 +++--
 drivers/media/rc/keymaps/Makefile         |   1 +
 drivers/media/rc/keymaps/rc-xbox-dvd.c    |  63 ++++++
 drivers/media/rc/mceusb.c                 |   9 +
 drivers/media/rc/rc-main.c                |   8 +-
 drivers/media/rc/xbox_remote.c            | 306 ++++++++++++++++++++++++++++++
 include/media/rc-map.h                    |   1 +
 13 files changed, 435 insertions(+), 71 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-xbox-dvd.c
 create mode 100644 drivers/media/rc/xbox_remote.c
