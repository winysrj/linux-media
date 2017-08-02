Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38721 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752311AbdHBImr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:42:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Eric Anholt <eric@anholt.net>,
        devicetree@vger.kernel.org
Subject: [PATCH 0/3] cec-gpio: add HDMI CEC GPIO-based driver
Date: Wed,  2 Aug 2017 10:42:39 +0200
Message-Id: <20170802084242.14947-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver adds support for CEC implementations that use a pull-up
GPIO pin. While SoCs exist that do this, the primary use-case is to
turn a single-board computer into a cheap CEC debugger.

Together with 'cec-ctl --monitor-pin' you can do low-level CEC bus
monitoring and do protocol analysis. And error injection is also
planned for the future.

Here is an example using the Raspberry Pi 3:

https://hverkuil.home.xs4all.nl/rpi3-cec.jpg

A patch for the Raspberry Pi 2B/3 is added below for reference.
It uses pin 7 aka BCM4 aka GPCLK0 on the GPIO pin header.

While this example is for the Rpi, this driver will work for any
SoC with a pull-up GPIO pin.

I have one question: is there a generic way to check/force the gpio
to pull-up mode? I have not found that, but I am no gpio-expert.

Regards,

	Hans

--- cut here ---
diff --git a/arch/arm/boot/dts/bcm2836-rpi-2-b.dts b/arch/arm/boot/dts/bcm2836-rpi-2-b.dts
index bf19e8cfb9e6..8cb82a70f33d 100644
--- a/arch/arm/boot/dts/bcm2836-rpi-2-b.dts
+++ b/arch/arm/boot/dts/bcm2836-rpi-2-b.dts
@@ -24,6 +24,11 @@
 			linux,default-trigger = "default-on";
 		};
 	};
+
+	cec-gpio {
+		compatible = "cec-gpio";
+		gpio = <&gpio 4 GPIO_ACTIVE_HIGH>;
+	};
 };
 
 &gpio {
diff --git a/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts b/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
index 972f14db28ac..cd0ec70732f4 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
+++ b/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
@@ -17,6 +17,11 @@
 			gpios = <&gpio 47 0>;
 		};
 	};
+
+	cec-gpio {
+		compatible = "cec-gpio";
+		gpio = <&gpio 4 GPIO_ACTIVE_HIGH>;
+	};
 };
 
 &uart1 {
--- cut here ---


Hans Verkuil (3):
  dt-bindings: document the CEC GPIO bindings
  cec-gpio: add HDMI CEC GPIO driver
  MAINTAINERS: add cec-gpio entry

 .../devicetree/bindings/media/cec-gpio.txt         |  18 ++
 MAINTAINERS                                        |   9 +
 drivers/media/platform/Kconfig                     |  10 ++
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/cec-gpio/Makefile           |   1 +
 drivers/media/platform/cec-gpio/cec-gpio.c         | 190 +++++++++++++++++++++
 6 files changed, 230 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt
 create mode 100644 drivers/media/platform/cec-gpio/Makefile
 create mode 100644 drivers/media/platform/cec-gpio/cec-gpio.c

-- 
2.13.2
