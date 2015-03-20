Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:12876 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbCTPDp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 11:03:45 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v1 00/11] LED / flash API integration
Date: Fri, 20 Mar 2015 16:03:20 +0100
Message-id: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a first non-RFC version of LED / flash API integration
series [1]. It is based on linux-next_20150320.

======================
Changes since RFC v13:
======================

- reduced number of patches - some of them have been merged
- slightly modified max77693-led device naming
- fixed issues in v4l2-flash helpers detected with yavta
- cleaned up AAT1290 device tree documentation
- added GPIOLIB dependecy to AAT1290 related entry in Kconfig

Thanks,
Jacek Anaszewski

[1] http://www.spinics.net/lists/kernel/msg1944538.html


Jacek Anaszewski (11):
  leds: Add support for max77693 mfd flash cell
  DT: Add documentation for the mfd Maxim max77693
  leds: Add driver for AAT1290 current regulator
  of: Add Skyworks Solutions, Inc. vendor prefix
  DT: Add documentation for the Skyworks AAT1290
  exynos4-is: Add support for v4l2-flash subdevs
  media: Add registration helpers for V4L2 flash sub-devices
  Documentation: leds: Add description of v4l2-flash sub-device
  DT: Add documentation for exynos4-is 'flashes' property
  leds: max77693: add support for V4L2 Flash sub-device
  leds: aat1290: add support for V4L2 Flash sub-device

 .../devicetree/bindings/leds/leds-aat1290.txt      |   70 ++
 .../devicetree/bindings/media/samsung-fimc.txt     |    8 +
 Documentation/devicetree/bindings/mfd/max77693.txt |   61 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/leds/leds-class-flash.txt            |   13 +
 drivers/leds/Kconfig                               |   19 +
 drivers/leds/Makefile                              |    2 +
 drivers/leds/leds-aat1290.c                        |  564 ++++++++++
 drivers/leds/leds-max77693.c                       | 1136 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/media-dev.c      |   36 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   13 +-
 drivers/media/v4l2-core/Kconfig                    |   12 +
 drivers/media/v4l2-core/Makefile                   |    2 +
 drivers/media/v4l2-core/v4l2-flash.c               |  607 +++++++++++
 include/media/v4l2-flash.h                         |  145 +++
 15 files changed, 2686 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt
 create mode 100644 drivers/leds/leds-aat1290.c
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

