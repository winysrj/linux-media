Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:46116 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933231AbeAKQZz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 11:25:55 -0500
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
Subject: [PATCH v2] MAINTAINERS: mtd/nand: update Microchip nand entry
Date: Thu, 11 Jan 2018 17:26:59 +0100
Message-ID: <20180111162659.740-1-nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update Wenyou Yang email address.
Take advantage of this update to move this entry to the MICROCHIP / ATMEL
location and add the DT binding documentation link.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Acked-by: Wenyou Yang <wenyou.yang@microchip.com>
---
v2: - patch agains 09ec417b0ea8 ("mtd: nand: samsung: Disable subpage
      writes on E-die NAND") of 
      http://git.infradead.org/linux-mtd.git/shortlog/refs/heads/nand/next
    - Ack by Wenyou added


Hi,

v1 patch was part of a series because it was conflicting with the previous one
named:
"[PATCH 1/2] MAINTAINERS: linux-media: update Microchip ISI and ISC entries"
Boris asked me to rebase it so that they are independent.
So, if this first one goes upstream through another tree, conflicts will have
to be resolved at one point.

Best regards,
  Nicolas


 MAINTAINERS | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa71ab52fd76..37ee5ae4bae2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2382,13 +2382,6 @@ F:	Documentation/devicetree/bindings/input/atmel,maxtouch.txt
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
@@ -9045,6 +9038,14 @@ F:	drivers/media/platform/atmel/atmel-isc.c
 F:	drivers/media/platform/atmel/atmel-isc-regs.h
 F:	devicetree/bindings/media/atmel-isc.txt
 
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
