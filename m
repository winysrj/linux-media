Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3707 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaGVEZz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 00:25:55 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6M4Po92024513
	for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 06:25:53 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5225F2A0523
	for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 06:25:48 +0200 (CEST)
Message-ID: <53CDE7CC.5000302@xs4all.nl>
Date: Tue, 22 Jul 2014 06:25:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] Move go7007 and solo6x10 out of staging
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rebased and dropped the offending files as requested.

I plan on making the saa7134-go7007 patch work (which was why I kept it in
the mainline driver), but I'll just add it back later. That's probably
going to be for 3.18 anyway.

Regards,

	Hans


The following changes since commit 9aabd95a2d531308ad997d2b92f46a3635782e0c:

  [media] media:platform: OMAP3 camera support needs VIDEOBUF2_DMA_CONTIG (2014-07-22 01:04:10 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17e

for you to fetch changes up to 6265838d9fab40743a02f6d120b18af88473fb29:

  go7007: move out of staging into drivers/media/usb. (2014-07-22 06:23:01 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      solo6x10: move out of staging into drivers/media/pci.
      go7007: move out of staging into drivers/media/usb.

 drivers/media/pci/Kconfig                                         |   1 +
 drivers/media/pci/Makefile                                        |   1 +
 drivers/{staging/media => media/pci}/solo6x10/Kconfig             |   2 +-
 drivers/{staging/media => media/pci}/solo6x10/Makefile            |   2 +-
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-core.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-disp.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-eeprom.c   |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-enc.c      |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-g723.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-gpio.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-i2c.c      |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-jpeg.h     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-offsets.h  |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-p2m.c      |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-regs.h     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.h     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2-enc.c |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10.h          |   0
 drivers/media/usb/Kconfig                                         |   1 +
 drivers/media/usb/Makefile                                        |   1 +
 drivers/{staging/media => media/usb}/go7007/Kconfig               |   0
 drivers/{staging/media => media/usb}/go7007/Makefile              |   4 -
 drivers/{staging/media => media/usb}/go7007/go7007-driver.c       |   0
 drivers/{staging/media => media/usb}/go7007/go7007-fw.c           |   0
 drivers/{staging/media => media/usb}/go7007/go7007-i2c.c          |   0
 drivers/{staging/media => media/usb}/go7007/go7007-loader.c       |   0
 drivers/{staging/media => media/usb}/go7007/go7007-priv.h         |   0
 drivers/{staging/media => media/usb}/go7007/go7007-usb.c          |   0
 drivers/{staging/media => media/usb}/go7007/go7007-v4l2.c         |   0
 drivers/{staging/media => media/usb}/go7007/s2250-board.c         |   0
 drivers/{staging/media => media/usb}/go7007/snd-go7007.c          |   0
 drivers/staging/media/Kconfig                                     |   4 -
 drivers/staging/media/Makefile                                    |   2 -
 drivers/staging/media/go7007/README                               | 136 --------------
 drivers/staging/media/go7007/go7007.txt                           | 478 -------------------------------------------------
 drivers/staging/media/go7007/saa7134-go7007.c                     | 560 ----------------------------------------------------------
 drivers/staging/media/solo6x10/TODO                               |  15 --
 39 files changed, 6 insertions(+), 1201 deletions(-)
 rename drivers/{staging/media => media/pci}/solo6x10/Kconfig (96%)
 rename drivers/{staging/media => media/pci}/solo6x10/Makefile (82%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-core.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-disp.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-eeprom.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-enc.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-g723.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-gpio.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-i2c.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-jpeg.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-offsets.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-p2m.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-regs.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2-enc.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10.h (100%)
 rename drivers/{staging/media => media/usb}/go7007/Kconfig (100%)
 rename drivers/{staging/media => media/usb}/go7007/Makefile (68%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-driver.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-fw.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-i2c.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-loader.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-priv.h (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-usb.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-v4l2.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/s2250-board.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/snd-go7007.c (100%)
 delete mode 100644 drivers/staging/media/go7007/README
 delete mode 100644 drivers/staging/media/go7007/go7007.txt
 delete mode 100644 drivers/staging/media/go7007/saa7134-go7007.c
 delete mode 100644 drivers/staging/media/solo6x10/TODO
