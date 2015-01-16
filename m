Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45287 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754942AbbAPMGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 07:06:02 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CDA5D2A002F
	for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 13:05:43 +0100 (CET)
Message-ID: <54B8FE97.3040606@xs4all.nl>
Date: Fri, 16 Jan 2015 13:05:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] Fixes, cleanups, improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains various fixes, cleanups and improvements.

The only notable change is the addition of unpacking and logging functions
for InfoFrames to drivers/video/hdmi.c. Thierry was OK with taking this via
the media tree (http://www.spinics.net/lists/linux-media/msg84655.html) and
Acked all patches touching hdmi.c/h.

Regards,

	Hans

The following changes since commit 99f3cd52aee21091ce62442285a68873e3be833f:

  [media] vb2-vmalloc: Protect DMA-specific code by #ifdef CONFIG_HAS_DMA (2014-12-23 16:28:09 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.20a

for you to fetch changes up to 2f45da9e0a1b198a99b6e92486a85311920e799d:

  adv7842: simplify InfoFrame logging (2015-01-16 12:54:55 +0100)

----------------------------------------------------------------
Asaf Vertz (1):
      media: stb0899_drv: use time_after()

Dan Carpenter (1):
      coda: improve safety in coda_register_device()

Fabian Frederick (2):
      tw68: remove unnecessary version.h inclusion
      vivid: remove unnecessary version.h inclusion

Fabio Estevam (2):
      coda: coda-common: Remove mx53 entry from coda_platform_ids
      adv7180: Remove the unneeded 'err' label

Hans Verkuil (3):
      videobuf: make unused exported functions static
      hdmi: add new HDMI 2.0 defines
      hdmi: rename HDMI_AUDIO_CODING_TYPE_EXT_STREAM to _EXT_CT

Ismael Luceno (4):
      solo6x10: s/unsigned char/u8/
      solo6x10: Fix eeprom_* functions buffer's type
      solo6x10: Fix solo_eeprom_read retval type
      solo6x10: s/uint8_t/u8/

Julia Lawall (4):
      au0828: Use setup_timer
      s2255drv: Use setup_timer
      usbvision: Use setup_timer
      pvrusb2: Use setup_timer

Martin Bugge (2):
      hdmi: added unpack and logging functions for InfoFrames
      adv7842: simplify InfoFrame logging

Ondrej Zary (3):
      bttv: Convert to generic TEA575x interface
      tea575x: split and export functions
      bttv: Improve TEA575x support

Prabhakar Lad (1):
      media: Kconfig: drop duplicate dependency of HAS_DMA

Rickard Strandqvist (7):
      media: radio: wl128x: fmdrv_rx.c: Remove unused function
      media: i2c: adv7604.c: Remove some unused functions
      media: pci: mantis: mantis_core.c: Remove unused function
      media: pci: saa7134: saa7134-video.c: Remove unused function
      media: platform: vsp1: vsp1_hsit: Remove unused function
      media: i2c: adv7604: Remove some unused functions
      usb: pvrusb2: pvrusb2-hdw: Remove unused function

Wolfram Sang (1):
      staging: media: bcm2048: Remove obsolete cleanup for clientdata

 drivers/media/dvb-frontends/stb0899_drv.c      |   7 +-
 drivers/media/i2c/Kconfig                      |   1 +
 drivers/media/i2c/adv7180.c                    |   7 +-
 drivers/media/i2c/adv7604.c                    |  76 --------
 drivers/media/i2c/adv7842.c                    | 184 +++++-------------
 drivers/media/i2c/ths8200.c                    |  10 -
 drivers/media/pci/bt8xx/Kconfig                |   3 +
 drivers/media/pci/bt8xx/bttv-cards.c           | 317 +++++++++++-------------------
 drivers/media/pci/bt8xx/bttv-driver.c          |  37 +++-
 drivers/media/pci/bt8xx/bttvp.h                |  14 +-
 drivers/media/pci/mantis/mantis_core.c         |  23 ---
 drivers/media/pci/saa7134/saa7134-video.c      |   5 -
 drivers/media/pci/solo6x10/solo6x10-core.c     |   4 +-
 drivers/media/pci/solo6x10/solo6x10-eeprom.c   |   2 +-
 drivers/media/pci/solo6x10/solo6x10-enc.c      |   6 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c     |   4 +-
 drivers/media/pci/solo6x10/solo6x10-jpeg.h     |   4 +-
 drivers/media/pci/solo6x10/solo6x10-tw28.c     |   4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c |  18 +-
 drivers/media/pci/solo6x10/solo6x10.h          |   4 +-
 drivers/media/pci/tw68/tw68.h                  |   1 -
 drivers/media/platform/Kconfig                 |   1 -
 drivers/media/platform/coda/coda-common.c      |   6 +-
 drivers/media/platform/vivid/vivid-tpg.h       |   1 -
 drivers/media/platform/vsp1/vsp1_hsit.c        |   5 -
 drivers/media/radio/tea575x.c                  |  41 +++-
 drivers/media/radio/wl128x/fmdrv_rx.c          |  16 --
 drivers/media/radio/wl128x/fmdrv_rx.h          |   1 -
 drivers/media/usb/au0828/au0828-video.c        |  11 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c        |  31 +--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h        |   3 -
 drivers/media/usb/s2255/s2255drv.c             |   4 +-
 drivers/media/usb/usbvision/usbvision-core.c   |   5 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c      |  15 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c  |   2 -
 drivers/video/hdmi.c                           | 822 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/hdmi.h                           |  37 +++-
 include/media/tea575x.h                        |   5 +
 include/media/videobuf-dma-sg.h                |   8 -
 39 files changed, 1144 insertions(+), 601 deletions(-)
