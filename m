Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:45427 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2K1Kzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 05:55:50 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v3 1/3] davinci: vpss: dm365: enable ISP registers
Date: Wed, 28 Nov 2012 16:25:32 +0530
Message-Id: <1354100134-21095-2-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1354100134-21095-1-git-send-email-prabhakar.lad@ti.com>
References: <1354100134-21095-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Manjunath Hadli <manjunath.hadli@ti.com>

enable PPCR, enbale ISIF out on BCR and disable all events to
get the correct operation from ISIF.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpss.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 146e4b0..34ad7bd 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -52,9 +52,11 @@ MODULE_AUTHOR("Texas Instruments");
 #define DM355_VPSSBL_EVTSEL_DEFAULT	0x4
 
 #define DM365_ISP5_PCCR 		0x04
+#define DM365_ISP5_BCR			0x08
 #define DM365_ISP5_INTSEL1		0x10
 #define DM365_ISP5_INTSEL2		0x14
 #define DM365_ISP5_INTSEL3		0x18
+#define DM365_ISP5_EVTSEL		0x1c
 #define DM365_ISP5_CCDCMUX 		0x20
 #define DM365_ISP5_PG_FRAME_SIZE 	0x28
 #define DM365_VPBE_CLK_CTRL 		0x00
@@ -357,6 +359,10 @@ void dm365_vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
 }
 EXPORT_SYMBOL(dm365_vpss_set_pg_frame_size);
 
+#define DM365_ISP5_EVTSEL_EVT_DISABLE	0x00000000
+#define DM365_ISP5_BCR_ISIF_OUT_ENABLE	0x00000002
+#define DM365_ISP5_PCCR_CLK_ENABLE	0x0000007f
+
 static int __devinit vpss_probe(struct platform_device *pdev)
 {
 	struct resource		*r1, *r2;
@@ -426,9 +432,16 @@ static int __devinit vpss_probe(struct platform_device *pdev)
 		oper_cfg.hw_ops.enable_clock = dm365_enable_clock;
 		oper_cfg.hw_ops.select_ccdc_source = dm365_select_ccdc_source;
 		/* Setup vpss interrupts */
+		isp5_write((isp5_read(DM365_ISP5_PCCR) |
+				DM365_ISP5_PCCR_CLK_ENABLE), DM365_ISP5_PCCR);
+		isp5_write((isp5_read(DM365_ISP5_BCR) |
+			     DM365_ISP5_BCR_ISIF_OUT_ENABLE), DM365_ISP5_BCR);
 		isp5_write(DM365_ISP5_INTSEL1_DEFAULT, DM365_ISP5_INTSEL1);
 		isp5_write(DM365_ISP5_INTSEL2_DEFAULT, DM365_ISP5_INTSEL2);
 		isp5_write(DM365_ISP5_INTSEL3_DEFAULT, DM365_ISP5_INTSEL3);
+		/* No event selected */
+		isp5_write((isp5_read(DM365_ISP5_EVTSEL) |
+			DM365_ISP5_EVTSEL_EVT_DISABLE), DM365_ISP5_EVTSEL);
 	} else
 		oper_cfg.hw_ops.clear_wbl_overflow = dm644x_clear_wbl_overflow;
 
-- 
1.7.4.1

