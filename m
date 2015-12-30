Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38164 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbL3Qqw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:52 -0500
Received: by mail-wm0-f44.google.com with SMTP id b14so55522735wmb.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:52 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 09/16] media: rc: nuvoton-cir: use IR_DEFAULT_TIMEOUT and
 consider SAMPLE_PERIOD
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568409A6.2000502@gmail.com>
Date: Wed, 30 Dec 2015 17:43:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to using the recently introduced IR default timeout value
(IR_DEFAULT_TIMEOUT) and consider the value of SAMPLE_PERIOD
when calculating the limit count register value.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 0ad15d3..6a3de08 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -157,8 +157,8 @@ struct nvt_dev {
 /* total length of CIR and CIR WAKE */
 #define CIR_IOREG_LENGTH	0x0f
 
-/* RX limit length, 8 high bits for SLCH, 8 low bits for SLCL (0x7d0 = 2000) */
-#define CIR_RX_LIMIT_COUNT	0x7d0
+/* RX limit length, 8 high bits for SLCH, 8 low bits for SLCL */
+#define CIR_RX_LIMIT_COUNT  (IR_DEFAULT_TIMEOUT / US_TO_NS(SAMPLE_PERIOD))
 
 /* CIR Regs */
 #define CIR_IRCON	0x00
-- 
2.6.4


