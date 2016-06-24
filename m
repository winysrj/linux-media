Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35476 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbcFXFkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 01:40:22 -0400
Received: by mail-wm0-f67.google.com with SMTP id a66so2181127wme.2
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2016 22:40:22 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 4/9] media: rc: nuvoton: simplify a few functions
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <4583ec6c-85bb-86f7-35cd-832779d2e9ac@gmail.com>
Date: Fri, 24 Jun 2016 07:39:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify a few functions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index c405c83..1d99f10 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -139,11 +139,7 @@ static inline void nvt_cir_reg_write(struct nvt_dev *nvt, u8 val, u8 offset)
 /* read val from cir config register */
 static u8 nvt_cir_reg_read(struct nvt_dev *nvt, u8 offset)
 {
-	u8 val;
-
-	val = inb(nvt->cir_addr + offset);
-
-	return val;
+	return inb(nvt->cir_addr + offset);
 }
 
 /* write val to cir wake register */
@@ -156,11 +152,7 @@ static inline void nvt_cir_wake_reg_write(struct nvt_dev *nvt,
 /* read val from cir wake config register */
 static u8 nvt_cir_wake_reg_read(struct nvt_dev *nvt, u8 offset)
 {
-	u8 val;
-
-	val = inb(nvt->cir_wake_addr + offset);
-
-	return val;
+	return inb(nvt->cir_wake_addr + offset);
 }
 
 /* don't override io address if one is set already */
@@ -487,9 +479,7 @@ static void nvt_cir_wake_ldev_init(struct nvt_dev *nvt)
 /* clear out the hardware's cir rx fifo */
 static void nvt_clear_cir_fifo(struct nvt_dev *nvt)
 {
-	u8 val;
-
-	val = nvt_cir_reg_read(nvt, CIR_FIFOCON);
+	u8 val = nvt_cir_reg_read(nvt, CIR_FIFOCON);
 	nvt_cir_reg_write(nvt, val | CIR_FIFOCON_RXFIFOCLR, CIR_FIFOCON);
 }
 
-- 
2.9.0

