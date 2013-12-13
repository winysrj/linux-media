Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3001 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3LMNbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 08:31:10 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBDDV5cm087054
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 14:31:07 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CA7EA2A2224
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 14:30:55 +0100 (CET)
Message-ID: <52AB0C0F.106@xs4all.nl>
Date: Fri, 13 Dec 2013 14:30:55 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] New si4713-usb driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series is identical to http://www.spinics.net/lists/linux-media/msg70312.html,
except that the last patch (coding style cleanups) is split into one whitespace clean
up patch and one time-related cleanup patch as you requested. It's also rebased to
the latest master.

Regards,

	Hans

The following changes since commit 675722b0e3917c6c917f1aa5f6d005cd3a0479f5:

  Merge branch 'upstream-fixes' into patchwork (2013-12-13 05:04:00 -0200)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git si4713

for you to fetch changes up to 14ceedc35bdf41cf83ca3f732e4583206f5d716f:

  si4713: coding style time-related cleanups (2013-12-13 14:12:10 +0100)

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

Hans Verkuil (3):
      si4713: si4713_set_rds_radio_text overwrites terminating \0
      si4713: coding style whitespace cleanups
      si4713: coding style time-related cleanups

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
