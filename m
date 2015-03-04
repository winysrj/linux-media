Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23647 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbbCDQPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 11:15:37 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v12 00/19] LED / flash API integration
Date: Wed, 04 Mar 2015 17:14:21 +0100
Message-id: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is a follow-up of the LED / flash API integration
series [1]. It is based on linux-next_20150304

========================
Changes since version 11 :
========================

- removed synchronized strobe feature from LED Flash class, as it
  turned out to be not fitting for sysfs interface. The V4L2 part
  can cover this in the future.
- Improved external strobe handling for AAT1290
- added removing led-triggers on v4l2-flash sub-device open
- applied minor improvements and cleanups

========================
Changes since version 10 :
========================

- added to the v4l2-flash sub-device driver the support for flash
  LED devices with non-linear brightness setting
- improved current setting in the max77693-led driver 
- added ABI documentation for flash LED sysfs attributes
- improved synchronized LEDs related sysfs attributes in the
  LED Flash class
- applied various fixes and cleanups

========================
Changes since version 9 :
========================

- switched to assigning sub-led related of_node to led_cdev->dev->of_node
  member which allowed for avoiding modifications around v4l-async
- reimplemented max77693 flash cell driver to avoid extensive use
  of macros
- added led-sources DT property and switched to using it
- switched to reporting flash faults in the LED subsystem in the form
  of human readable strings
- added available_sync_leds sysfs attribute to the LED Flash class
  and changed the semantics of flash_sync_strobe attribute
- made LED subsystem flash faults not depending on the V4L2 Flash ones
- applied various fixes and cleanups

========================
Changes since version 8:
========================

- added a new way of registering async sub-device
- switched to matching flash leds by DT phandles
- improved Device Tree bindings documentation
- split the drivers patches to LED Flash class
  and V4L2 Flash part
- fixed indicator leds handling in v4l2-flash
- applied various fixes an cleanups

========================
Changes since version 7:
========================

- removed explicit support for indicator leds from
  LED Flash class - indicator leds will be registered
  as a separate LED Flash class devices
- added flash_sync_strobe sysfs attribute and related
  V4L2_CID_FLASH_SYNC_STROBE control
- changed the way of matching V4L2 Flash sub-devices
  in a media device, which entailed modification in
  v4l2-async driver
- modified max77693 DT bindings documentation
- applied various fixes an cleanups

========================
Changes since version 6:
========================

- removed addition of public LED subsystem API for setting
  torch brightness in favour of internal API for
  synchronous and asynchronous led brightness level setting
- fixed possible race condition upon creating LED Flash class
  related sysfs attributes

========================
Changes since version 5:
========================

- removed flash manager framework - its implementation needs
  further thorough discussion.
- removed external strobe facilities from the LED Flash Class
  and provided external_strobe_set op in v4l2-flash. LED subsystem
  should be strobe provider agnostic.

Thanks,
Jacek Anaszewski

[1] https://lkml.org/lkml/2014/7/11/914

Jacek Anaszewski (19):
  leds: flash: Remove synchronized flash strobe feature
  leds: flash: document sysfs interface
  Documentation: leds: Add description of LED Flash class extension
  dt-binding: leds: Add common LED DT bindings macros
  mfd: max77693: Modify flash cell name identifiers
  mfd: max77693: Remove struct max77693_led_platform_data
  mfd: max77693: add TORCH_IOUT_MASK macro
  mfd: max77693: Adjust FLASH_EN_SHIFT and TORCH_EN_SHIFT macros
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

 Documentation/ABI/testing/sysfs-class-led-flash    |   80 ++
 .../devicetree/bindings/leds/leds-aat1290.txt      |   64 ++
 .../devicetree/bindings/media/samsung-fimc.txt     |    8 +
 Documentation/devicetree/bindings/mfd/max77693.txt |   61 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/leds/leds-class-flash.txt            |   35 +
 drivers/leds/Kconfig                               |   18 +
 drivers/leds/Makefile                              |    2 +
 drivers/leds/led-class-flash.c                     |   82 --
 drivers/leds/leds-aat1290.c                        |  571 ++++++++++
 drivers/leds/leds-max77693.c                       | 1122 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/media-dev.c      |   36 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   13 +-
 drivers/media/v4l2-core/Kconfig                    |   11 +
 drivers/media/v4l2-core/Makefile                   |    2 +
 drivers/media/v4l2-core/v4l2-flash.c               |  598 +++++++++++
 drivers/mfd/max77693.c                             |    4 +-
 include/dt-bindings/leds/max77693.h                |   21 +
 include/linux/led-class-flash.h                    |   14 -
 include/linux/leds.h                               |    1 -
 include/linux/mfd/max77693-private.h               |    5 +-
 include/linux/mfd/max77693.h                       |   13 -
 include/media/v4l2-flash.h                         |  143 +++
 23 files changed, 2788 insertions(+), 117 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-flash
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt
 create mode 100644 Documentation/leds/leds-class-flash.txt
 create mode 100644 drivers/leds/leds-aat1290.c
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/dt-bindings/leds/max77693.h
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

