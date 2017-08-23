Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60356 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753426AbdHWILE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 04:11:04 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        javier@dowhile0.org, jacek.anaszewski@gmail.com
Subject: [PATCH v3 0/3] AS3645A flash support
Date: Wed, 23 Aug 2017 11:10:57 +0300
Message-Id: <20170823081100.11733-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This set adds support for the AS3645A flash driver which can be found e.g.
in Nokia N9.

The set depeds on the flash patches here so I'd prefer to merge this
through mediatree.

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=flash>

since v2:

- Add acks.

- Improve commit message in dt binding patch.

- Align From header and SoB tags.

Since v1:

- Fix flash label use.

- Drop "flash" property from sensors in N9 DTS patch. This will reappear in
  a sepeate patch after the "flash" binding documentation patch.

- Remove PM support from the driver (the LED framework handles this).

- Enable runtime PM un as3645a driver.

- Add I²C device ID table for module autoloading.

- Add label to the binding examples as well as reference to common.txt.

- Document label as an optional property for both LED sub-nodes.

Since the RFC set:

- Add back the DT binding documentation I lost long ago.

- Use colon (":") in the default names instead of a space.

Sakari Ailus (3):
  dt: bindings: Document DT bindings for Analog devices as3645a
  leds: as3645a: Add LED flash class driver
  arm: dts: omap3: N9/N950: Add AS3645A camera flash

 .../devicetree/bindings/leds/ams,as3645a.txt       |  71 ++
 MAINTAINERS                                        |   6 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |  14 +
 drivers/leds/Kconfig                               |   8 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/leds-as3645a.c                        | 770 +++++++++++++++++++++
 6 files changed, 870 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/ams,as3645a.txt
 create mode 100644 drivers/leds/leds-as3645a.c

-- 
2.11.0


*** BLURB HERE ***

Sakari Ailus (3):
  dt: bindings: Document DT bindings for Analog devices as3645a
  leds: as3645a: Add LED flash class driver
  arm: dts: omap3: N9/N950: Add AS3645A camera flash

 .../devicetree/bindings/leds/ams,as3645a.txt       |  71 ++
 MAINTAINERS                                        |   6 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |  14 +
 drivers/leds/Kconfig                               |   8 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/leds-as3645a.c                        | 763 +++++++++++++++++++++
 6 files changed, 863 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/ams,as3645a.txt
 create mode 100644 drivers/leds/leds-as3645a.c

-- 
2.11.0
