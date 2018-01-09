Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:36485 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758014AbeAINpm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 08:45:42 -0500
From: Nicolas Ferre <nicolas.ferre@microchip.com>
To: <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: <linux-media@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-mtd@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Josh Wu <rainyfeeling@outlook.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 2/2] MAINTAINERS: mtd/nand: update Microchip nand entry
Date: Tue, 9 Jan 2018 14:46:40 +0100
Message-ID: <d8a6b8a3fe05c57972de1c374fcdeb933717396b.1515503733.git.nicolas.ferre@microchip.com>
In-Reply-To: <eb6b3cbe8e48faee7e88eca0649e42cbde91ffa6.1515503733.git.nicolas.ferre@microchip.com>
References: <eb6b3cbe8e48faee7e88eca0649e42cbde91ffa6.1515503733.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update Wenyou Yang email address.
Take advantage of this update to move this entry to the MICROCHIP / ATMEL
location and add the DT binding documentation link.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Hi,

Patch against next-20180109.
This patch is somehow dependent on the previous one in the series
("MAINTAINERS: linux-media: update Microchip ISI and ISC entries") but can be
rebased easily.

I don't know if it's better to have them added at the end of the development
cycle or just after rc1: let me know if you plan to take them or if I need to
rebase them for next cycle.

Best regards,
  Nicolas


 MAINTAINERS | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 65c4b59b582f..b48e217d41fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2373,13 +2373,6 @@ F:	Documentation/devicetree/bindings/input/atmel,maxtouch.txt
 F:	drivers/input/touchscreen/atmel_mxt_ts.c
 F:	include/linux/platform_data/atmel_mxt_ts.h
 
-ATMEL NAND DRIVER
-M:	Wenyou Yang <wenyou.yang@atmel.com>
-M:	Josh Wu <rainyfeeling@outlook.com>
-L:	linux-mtd@lists.infradead.org
-S:	Supported
-F:	drivers/mtd/nand/atmel/*
-
 ATMEL SAMA5D2 ADC DRIVER
 M:	Ludovic Desroches <ludovic.desroches@microchip.com>
 L:	linux-iio@vger.kernel.org
@@ -9110,6 +9103,14 @@ F:	drivers/media/platform/atmel/atmel-isi.c
 F:	include/media/atmel-isi.h
 F:	Documentation/devicetree/bindings/media/atmel-isi.txt
 
+MICROCHIP / ATMEL NAND DRIVER
+M:	Wenyou Yang <wenyou.yang@microchip.com>
+M:	Josh Wu <rainyfeeling@outlook.com>
+L:	linux-mtd@lists.infradead.org
+S:	Supported
+F:	drivers/mtd/nand/atmel/*
+F:	Documentation/devicetree/bindings/mtd/atmel-nand.txt
+
 MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER
 M:	Woojung Huh <Woojung.Huh@microchip.com>
 M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
-- 
2.9.0
