Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52382 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbeKHW7b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 17:59:31 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] MAINTAINERS fixups
Message-ID: <e4b6f459-407a-3ca3-cb52-421fb8f915fd@xs4all.nl>
Date: Thu, 8 Nov 2018 14:23:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update file paths in MAINTAINERS.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Joe Perches <joe@perches.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index a8588dedc683..4ee360fb33ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2062,7 +2062,6 @@ M:	Andrzej Hajda <a.hajda@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-samsung/s5p-dev-mfc.c
 F:	drivers/media/platform/s5p-mfc/

 ARM/SHMOBILE ARM ARCHITECTURE
@@ -3913,7 +3912,6 @@ T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/i2c/cs3308.c
-F:	drivers/media/i2c/cs3308.h

 CS5535 Audio ALSA driver
 M:	Jaya Kumar <jayakumar.alsa@gmail.com>
@@ -3944,7 +3942,7 @@ T:	git git://linuxtv.org/media_tree.git
 W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/common/cx2341x*
-F:	include/media/cx2341x*
+F:	include/media/drv-intf/cx2341x.h

 CX24120 MEDIA DRIVER
 M:	Jemma Denson <jdenson@gmail.com>
@@ -9670,14 +9668,14 @@ L:	linux-media@vger.kernel.org
 S:	Supported
 F:	drivers/media/platform/atmel/atmel-isc.c
 F:	drivers/media/platform/atmel/atmel-isc-regs.h
-F:	devicetree/bindings/media/atmel-isc.txt
+F:	Documentation/devicetree/bindings/media/atmel-isc.txt

 MICROCHIP ISI DRIVER
 M:	Eugen Hristev <eugen.hristev@microchip.com>
 L:	linux-media@vger.kernel.org
 S:	Supported
 F:	drivers/media/platform/atmel/atmel-isi.c
-F:	include/media/atmel-isi.h
+F:	drivers/media/platform/atmel/atmel-isi.h

 MICROCHIP AT91 USART MFD DRIVER
 M:	Radu Pirea <radu_nicolae.pirea@upb.ro>
@@ -12991,7 +12989,7 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/common/saa7146/
 F:	drivers/media/pci/saa7146/
-F:	include/media/saa7146*
+F:	include/media/drv-intf/saa7146*

 SAMSUNG AUDIO (ASoC) DRIVERS
 M:	Krzysztof Kozlowski <krzk@kernel.org>
