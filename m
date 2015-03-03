Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52244 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbbCCKR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 05:17:26 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 701B62A008D
	for <linux-media@vger.kernel.org>; Tue,  3 Mar 2015 11:17:10 +0100 (CET)
Message-ID: <54F58A26.5090307@xs4all.nl>
Date: Tue, 03 Mar 2015 11:17:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] Various fixes/improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just a pile of fixes/improvements, nothing that stands out.

Regards,

	Hans

The following changes since commit b44b2e06ae463327334235bf160e804632b9b37c:

  [media] media: i2c: ADV7604: Rename adv7604 prefixes (2015-03-02 16:59:32 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1c

for you to fetch changes up to 6e10c830b20252981b3896648fafcec60fb74dc5:

  media: adv7604: improve usage of gpiod API (2015-03-03 11:01:51 +0100)

----------------------------------------------------------------
Fabian Frederick (1):
      saa7146: replace current->state by set_current_state()

Gilles Risch (1):
      Basic support for the Elgato EyeTV Hybrid INT 2008 USB Stick

Hans Verkuil (1):
      DocBook media: fix typos in YUV420M description

Lad, Prabhakar (4):
      media: au0828: drop vbi_buffer_filled() and re-use buffer_filled()
      media: drop call to v4l2_device_unregister_subdev()
      media: i2c: ths7303: drop module param debug
      media: omap/omap_vout: fix type of input members to omap_vout_setup_vrfb_bufs()

Olli Salonen (1):
      saa7164: free_irq before pci_disable_device

Shuah Khan (3):
      media: au0828 replace printk KERN_DEBUG with pr_debug
      media: em28xx replace printk in dprintk macros
      media: au0828 - embed vdev and vbi_dev structs in au0828_dev

Simon Farnsworth (1):
      cx18: Fix bytes_per_line

Tapasweni Pathak (1):
      drivers: media: i2c : s5c73m3: Replace dev_err with pr_err

Uwe Kleine-König (1):
      media: adv7604: improve usage of gpiod API

Wei Yongjun (1):
      v4l2: remove unused including <linux/version.h>

 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |   4 +--
 drivers/media/common/saa7146/saa7146_vbi.c         |   4 +--
 drivers/media/i2c/adv7343.c                        |   1 -
 drivers/media/i2c/adv7604.c                        |  17 +++++--------
 drivers/media/i2c/mt9v032.c                        |   1 -
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |   2 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |   1 -
 drivers/media/i2c/ths7303.c                        |   4 ---
 drivers/media/i2c/ths8200.c                        |   1 -
 drivers/media/i2c/tvp514x.c                        |   1 -
 drivers/media/i2c/tvp7002.c                        |   1 -
 drivers/media/pci/cx18/cx18-driver.h               |   1 +
 drivers/media/pci/cx18/cx18-ioctl.c                |   9 ++++---
 drivers/media/pci/saa7164/saa7164-core.c           |   4 +--
 drivers/media/platform/omap/omap_vout.c            |   2 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |   1 +
 drivers/media/platform/omap/omap_vout_vrfb.h       |   4 +--
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |   1 -
 drivers/media/usb/au0828/au0828-video.c            | 100 ++++++++++++++++++++++++++-----------------------------------------------
 drivers/media/usb/au0828/au0828.h                  |   6 ++---
 drivers/media/usb/em28xx/em28xx-audio.c            |   3 +--
 drivers/media/usb/em28xx/em28xx-cards.c            |  13 +++++++++-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   3 ++-
 drivers/media/usb/em28xx/em28xx-input.c            |   2 +-
 drivers/media/usb/em28xx/em28xx.h                  |   1 +
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   1 -
 26 files changed, 80 insertions(+), 108 deletions(-)
