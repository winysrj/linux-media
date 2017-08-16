Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49076 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751370AbdHPMym (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:54:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/3] AS3645A flash support
Date: Wed, 16 Aug 2017 15:54:40 +0300
Message-Id: <20170816125440.27534-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This set adds support for the AS3645A flash driver which can be found e.g.
in Nokia N9.

The set depeds on the flash patches here so I'd prefer to merge this
through mediatree.

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=flash>

Jacek: would that be ok for you?

Since the RFC set:

- Add back the DT binding documentation I lost long ago.

- Use colon (":") in the default names instead of a space.

Sakari Ailus (3):
  dt: bindings: Document DT bindings for Analog devices as3645a
  leds: as3645a: Add LED flash class driver
  arm: dts: omap3: N9/N950: Add AS3645A camera flash

 .../devicetree/bindings/leds/ams,as3645a.txt       |  56 ++
 MAINTAINERS                                        |   6 +
 arch/arm/boot/dts/omap3-n9.dts                     |   1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |  14 +
 arch/arm/boot/dts/omap3-n950.dts                   |   1 +
 drivers/leds/Kconfig                               |   8 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/leds-as3645a.c                        | 785 +++++++++++++++++++++
 8 files changed, 872 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/ams,as3645a.txt
 create mode 100644 drivers/leds/leds-as3645a.c

-- 
2.11.0
