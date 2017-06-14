Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34294 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752282AbdFNJrg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 05:47:36 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org
Cc: devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
Subject: [PATCH 0/8] Support registering lens, flash and EEPROM devices
Date: Wed, 14 Jun 2017 12:47:11 +0300
Message-Id: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This set adds support for async registering of lens, flash and EEPROM
devices, as well as support for this in the smiapp driver and a LED driver
for the as3645a.

The lens and flash devices are entities in the media graph whereas the
EEPROM is at least currently not. By providing the association information
it is possible to add the flash device to the media graph.

The smiapp driver makes use of the newly added properties.

changes since "Document bindings for camera modules and associated flash 
        devices",
	<URL:https://www.spinics.net/lists/linux-media/msg115124.html>:

- Mention flash is a phandle reference to the flash driver chip only. Do
  not reference to LEDs themselves since this would be somewhat
  problematic for drivers to handle: the V4L2 sub-devices may have a flash
  as well as an indicator LED. Alternatively, allowing to use both LED
  driver and LED references could cause complications in async matching:
  the flash driver (software) doesn't know which one is presend in the
  sensor OF node.

  Instead, I'll propose using numeric IDs for the LEDs, just as we have
  for clocks for instance. The current definition of a flash driver device
  reference remains extensible.

  Due to the changes I've dropped the acks I've received to the flash
  binding patch.

Sakari Ailus (8):
  dt: bindings: Add a binding for flash devices associated to a sensor
  dt: bindings: Add lens-focus binding for image sensors
  dt: bindings: Add a binding for referencing EEPROM from camera sensors
  v4l2-flash: Use led_classdev instead of led_classdev_flash for
    indicator
  v4l2-flash: Flash ops aren't mandatory
  leds: as3645a: Add LED flash class driver
  smiapp: Add support for flash, lens and EEPROM devices
  arm: dts: omap3: N9/N950: Add AS3645A camera flash

 .../devicetree/bindings/media/video-interfaces.txt |  13 +
 MAINTAINERS                                        |   6 +
 arch/arm/boot/dts/omap3-n9.dts                     |   1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |  14 +
 arch/arm/boot/dts/omap3-n950.dts                   |   1 +
 drivers/leds/Kconfig                               |   8 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/leds-as3645a.c                        | 744 +++++++++++++++++++++
 drivers/media/i2c/smiapp/smiapp-core.c             |  81 ++-
 drivers/media/i2c/smiapp/smiapp.h                  |   5 +
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |  23 +-
 include/media/v4l2-flash-led-class.h               |   6 +-
 12 files changed, 879 insertions(+), 24 deletions(-)
 create mode 100644 drivers/leds/leds-as3645a.c

-- 
2.1.4
