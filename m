Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38242 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbbL3Qq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:59 -0500
Received: by mail-wm0-f45.google.com with SMTP id b14so55525823wmb.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:58 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 14/16] media: rc: nuvoton-cir: fix wakeup interrupt bits
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56840A0C.8030701@gmail.com>
Date: Wed, 30 Dec 2015 17:45:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most likely a copy & paste error.
The wakeup interrupt supports less triggering events.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 48c09c7..4a5650d 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -293,10 +293,7 @@ struct nvt_dev {
 #define CIR_WAKE_IREN_RTR		0x40
 #define CIR_WAKE_IREN_PE		0x20
 #define CIR_WAKE_IREN_RFO		0x10
-#define CIR_WAKE_IREN_TE		0x08
-#define CIR_WAKE_IREN_TTR		0x04
-#define CIR_WAKE_IREN_TFU		0x02
-#define CIR_WAKE_IREN_GH		0x01
+#define CIR_WAKE_IREN_GH		0x08
 
 /* CIR WAKE FIFOCON settings */
 #define CIR_WAKE_FIFOCON_RXFIFOCLR	0x08
-- 
2.6.4


