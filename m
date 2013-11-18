Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2952 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3KRPdH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Nov 2013 10:33:07 -0500
Message-ID: <528A3327.40202@xs4all.nl>
Date: Mon, 18 Nov 2013 16:32:55 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dinesh Ram <Dinesh.Ram@cern.ch>,
	"edubezval@gmail.com" <edubezval@gmail.com>
Subject: [GIT PULL FOR v3.14] New si4713 usb driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the driver for the SiLabs 4713 USB development board. Many thanks to
Dinesh Ram who wrote this driver as part of a Cisco Summer Internship. It took
awhile to get all the Acked-by's, Tested-by's and Signed-off-by's, but it is
finally ready for merging.

Thanks also to Eduardo for testing that this didn't break the si4713 i2c driver.

Regards,

	Hans

The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

  [media] media: st-rc: Add ST remote control driver (2013-10-31 08:20:08 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git si4713

for you to fetch changes up to f18f888f94a04d590b5a89e282f6e128172e7c7f:

  si4713: print product number (2013-11-18 16:13:31 +0100)

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

Hans Verkuil (1):
      si4713: si4713_set_rds_radio_text overwrites terminating \0

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
 drivers/media/radio/{si4713-i2c.c => si4713/si4713.c}                  | 184 ++++++++++--------
 drivers/media/radio/{si4713-i2c.h => si4713/si4713.h}                  |   4 +-
 include/media/si4713.h                                                 |   2 +
 13 files changed, 721 insertions(+), 110 deletions(-)
 create mode 100644 drivers/media/radio/si4713/Kconfig
 create mode 100644 drivers/media/radio/si4713/Makefile
 rename drivers/media/radio/{radio-si4713.c => si4713/radio-platform-si4713.c} (100%)
 create mode 100644 drivers/media/radio/si4713/radio-usb-si4713.c
 rename drivers/media/radio/{si4713-i2c.c => si4713/si4713.c} (91%)
 rename drivers/media/radio/{si4713-i2c.h => si4713/si4713.h} (98%)
