Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3484 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760719Ab3LIJH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 04:07:59 -0500
Message-ID: <52A58861.1050504@xs4all.nl>
Date: Mon, 09 Dec 2013 10:07:45 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [GIT PULL FOR v3.14] New si4713-usb driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I'm trying again to get this driver merged. The comments you made have all been
addressed, so hopefully this will now be OK.

Regards,

	Hans

The following changes since commit 3f823e094b935c1882605f8720336ee23433a16d:

  [media] exynos4-is: Simplify fimc-is hardware polling helpers (2013-12-04 15:54:19 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git si4713

for you to fetch changes up to 8789394c0a0261ac35770212ab19172a2bd76ac1:

  si4713: coding style cleanups (2013-12-09 10:01:58 +0100)

----------------------------------------------------------------
Dinesh Ram (8):
      si4713: Reorganized drivers/media/radio directory
      si4713: Modified i2c driver to handle cases where interrupts are not used
      si4713: Reorganized includes in si4713.c/h
      si4713: Bug fix for si4713_tx_tune_power() method in the i2c driver
      si4713: HID blacklist Si4713 USB development board
      si4713: Added the USB driver for Si4713
      si4713: Added MAINTAINERS entry for radio-usb-si4713 driver
      si4713: move supply list to si4713_platform_data

Eduardo Valentin (1):
      si4713: print product number

Hans Verkuil (2):
      si4713: si4713_set_rds_radio_text overwrites terminating \0
      si4713: coding style cleanups

 MAINTAINERS                                                            |  12 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c                           |   7 +
 drivers/hid/hid-core.c                                                 |   1 +
 drivers/hid/hid-ids.h                                                  |   2 +
 drivers/media/radio/Kconfig                                            |  29 +--
 drivers/media/radio/Makefile                                           |   3 +-
 drivers/media/radio/si4713/Kconfig                                     |  40 ++++
 drivers/media/radio/si4713/Makefile                                    |   7 +
 drivers/media/radio/{radio-si4713.c => si4713/radio-platform-si4713.c} |   0
 drivers/media/radio/si4713/radio-usb-si4713.c                          | 540 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/radio/{si4713-i2c.c => si4713/si4713.c}                  | 279 ++++++++++++++-------------
 drivers/media/radio/{si4713-i2c.h => si4713/si4713.h}                  |   4 +-
 include/media/si4713.h                                                 |   2 +
 13 files changed, 771 insertions(+), 155 deletions(-)
 create mode 100644 drivers/media/radio/si4713/Kconfig
 create mode 100644 drivers/media/radio/si4713/Makefile
 rename drivers/media/radio/{radio-si4713.c => si4713/radio-platform-si4713.c} (100%)
 create mode 100644 drivers/media/radio/si4713/radio-usb-si4713.c
 rename drivers/media/radio/{si4713-i2c.c => si4713/si4713.c} (86%)
 rename drivers/media/radio/{si4713-i2c.h => si4713/si4713.h} (98%)
