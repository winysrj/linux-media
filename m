Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:32903 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbdJ2NjP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 09:39:15 -0400
Date: Sun, 29 Oct 2017 13:39:13 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.15] ids and RC timer API change
Message-ID: <20171029133913.qadat6qfmaxwgrrc@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here the timer updates and some IDs for mceusb and cx231xx.

Thanks
Sean

The following changes since commit bbae615636155fa43a9b0fe0ea31c678984be864:

  media: staging: atomisp2: cleanup null check on memory allocation (2017-10-27 17:33:39 +0200)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.15d

for you to fetch changes up to 1bfd8c214a396fb51f8428bfda66c2eff6076f12:

  media: cx231xx: Fix NTSC/PAL on Astrometa T2hybrid (2017-10-29 12:09:14 +0000)

----------------------------------------------------------------
Kees Cook (1):
      media: rc: Convert timers to use timer_setup()

Oleh Kravchenko (5):
      media: rc: mceusb: add support for 1b80:d3b2
      media: rc: Add Astrometa T2hybrid keymap module
      media: rc: mceusb: add support for 15f4:0135
      media: cx231xx: Fix NTSC/PAL on Evromedia USB Full Hybrid Full HD
      media: cx231xx: Fix NTSC/PAL on Astrometa T2hybrid

 drivers/media/rc/ene_ir.c                        |  7 +--
 drivers/media/rc/igorplugusb.c                   |  6 +-
 drivers/media/rc/img-ir/img-ir-hw.c              | 13 ++---
 drivers/media/rc/img-ir/img-ir-raw.c             |  6 +-
 drivers/media/rc/imon.c                          |  7 +--
 drivers/media/rc/ir-mce_kbd-decoder.c            |  7 +--
 drivers/media/rc/keymaps/Makefile                |  1 +
 drivers/media/rc/keymaps/rc-astrometa-t2hybrid.c | 70 ++++++++++++++++++++++++
 drivers/media/rc/mceusb.c                        | 18 ++++++
 drivers/media/rc/rc-ir-raw.c                     |  8 +--
 drivers/media/rc/rc-main.c                       |  7 +--
 drivers/media/rc/sir_ir.c                        |  4 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c        |  3 +-
 include/media/rc-map.h                           |  1 +
 14 files changed, 122 insertions(+), 36 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-astrometa-t2hybrid.c
