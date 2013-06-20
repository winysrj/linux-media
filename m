Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2174 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab3FTPY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 11:24:59 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5KFOu7i085735
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 17:24:58 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 5EDDD35E015B
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 17:24:55 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Various fixes + the new usbtv driver
Date: Thu, 20 Jun 2013 17:24:55 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201724.55659.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 37c1d2e4098e48d9107858246027510efcfd7774:

  Merge branch 'linus' into patchwork (2013-06-20 05:19:09 -0300)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to 442d51f936ccf6f90bc4083a451bfea81ebe72e2:

  go7007: fix return 0 for unsupported devices in go7007_usb_probe() (2013-06-20 16:48:51 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (2):
      usbvision-video: fix memory leak of alt_max_pkt_size
      go7007: fix return 0 for unsupported devices in go7007_usb_probe()

Lad, Prabhakar (13):
      media: davinci: vpif: remove unwanted header mach/hardware.h and sort the includes alphabetically
      media: davinci: vpif: Convert to devm_* api
      media: davinci: vpif: remove unnecessary braces around defines
      media: davinci: vpif_capture: move the freeing of irq and global variables to remove()
      media: davinci: vpif_capture: use module_platform_driver()
      media: davinci: vpif_capture: Convert to devm_* api
      media: davinci: vpif_capture: remove unnecessary loop for IRQ resource
      media: davinci: vpif_display: move the freeing of irq and global variables to remove()
      media: davinci: vpif_display: use module_platform_driver()
      media: davinci: vpif_display: Convert to devm_* api
      media: davinci: vpif_display: remove unnecessary loop for IRQ resource
      media: i2c: tvp514x: add OF support
      media: i2c: ths7303: remove unused member driver_data

Lubomir Rintel (1):
      usbtv: Add driver for Fushicai USBTV007 video frame grabber

Ondrej Zary (2):
      radio-sf16fmi: Add module name to bus_info
      radio-sf16fmi: Set frequency during init

 Documentation/devicetree/bindings/media/i2c/tvp514x.txt |  44 +++++
 drivers/media/i2c/ths7303.c                             |   4 -
 drivers/media/i2c/tvp514x.c                             |  62 ++++++-
 drivers/media/platform/davinci/vpif.c                   |  45 ++---
 drivers/media/platform/davinci/vpif_capture.c           |  76 ++------
 drivers/media/platform/davinci/vpif_display.c           |  65 ++-----
 drivers/media/radio/radio-sf16fmi.c                     |  27 ++-
 drivers/media/usb/Kconfig                               |   1 +
 drivers/media/usb/Makefile                              |   1 +
 drivers/media/usb/usbtv/Kconfig                         |  10 ++
 drivers/media/usb/usbtv/Makefile                        |   1 +
 drivers/media/usb/usbtv/usbtv.c                         | 696 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/usb/usbvision/usbvision-video.c           |   2 +
 drivers/staging/media/go7007/go7007-usb.c               |   4 +-
 14 files changed, 870 insertions(+), 168 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt
 create mode 100644 drivers/media/usb/usbtv/Kconfig
 create mode 100644 drivers/media/usb/usbtv/Makefile
 create mode 100644 drivers/media/usb/usbtv/usbtv.c
