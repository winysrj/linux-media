Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37800 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab0BWIel (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 03:34:41 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V1 08/10] DM644x CCDC : Add Suspend/Resume Support
Date: Tue, 23 Feb 2010 14:04:31 +0530
Message-Id: <1266914073-30135-9-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/ti-media/dm644x_ccdc.c      |  114 +++++++++++++++++++++++
 drivers/media/video/ti-media/dm644x_ccdc_regs.h |    2 +-
 2 files changed, 115 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ti-media/dm644x_ccdc.c b/drivers/media/video/ti-media/dm644x_ccdc.c
index 506bbf5..3045ebc 100644
--- a/drivers/media/video/ti-media/dm644x_ccdc.c
+++ b/drivers/media/video/ti-media/dm644x_ccdc.c
@@ -100,6 +100,9 @@ static u32 ccdc_raw_bayer_pix_formats[] =
 static u32 ccdc_raw_yuv_pix_formats[] =
 	{V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_YUYV};

+/* CCDC Save/Restore context */
+static u32 ccdc_ctx[CCDC_REG_END / sizeof(u32)];
+
 /* register access routines */
 static inline u32 regr(u32 offset)
 {
@@ -845,6 +848,87 @@ static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
 	return 0;
 }

+static void ccdc_save_context(void)
+{
+	ccdc_ctx[CCDC_PCR >> 2] = regr(CCDC_PCR);
+	ccdc_ctx[CCDC_SYN_MODE >> 2] = regr(CCDC_SYN_MODE);
+	ccdc_ctx[CCDC_HD_VD_WID >> 2] = regr(CCDC_HD_VD_WID);
+	ccdc_ctx[CCDC_PIX_LINES >> 2] = regr(CCDC_PIX_LINES);
+	ccdc_ctx[CCDC_HORZ_INFO >> 2] = regr(CCDC_HORZ_INFO);
+	ccdc_ctx[CCDC_VERT_START >> 2] = regr(CCDC_VERT_START);
+	ccdc_ctx[CCDC_VERT_LINES >> 2] = regr(CCDC_VERT_LINES);
+	ccdc_ctx[CCDC_CULLING >> 2] = regr(CCDC_CULLING);
+	ccdc_ctx[CCDC_HSIZE_OFF >> 2] = regr(CCDC_HSIZE_OFF);
+	ccdc_ctx[CCDC_SDOFST >> 2] = regr(CCDC_SDOFST);
+	ccdc_ctx[CCDC_SDR_ADDR >> 2] = regr(CCDC_SDR_ADDR);
+	ccdc_ctx[CCDC_CLAMP >> 2] = regr(CCDC_CLAMP);
+	ccdc_ctx[CCDC_DCSUB >> 2] = regr(CCDC_DCSUB);
+	ccdc_ctx[CCDC_COLPTN >> 2] = regr(CCDC_COLPTN);
+	ccdc_ctx[CCDC_BLKCMP >> 2] = regr(CCDC_BLKCMP);
+	ccdc_ctx[CCDC_FPC >> 2] = regr(CCDC_FPC);
+	ccdc_ctx[CCDC_FPC_ADDR >> 2] = regr(CCDC_FPC_ADDR);
+	ccdc_ctx[CCDC_VDINT >> 2] = regr(CCDC_VDINT);
+	ccdc_ctx[CCDC_ALAW >> 2] = regr(CCDC_ALAW);
+	ccdc_ctx[CCDC_REC656IF >> 2] = regr(CCDC_REC656IF);
+	ccdc_ctx[CCDC_CCDCFG >> 2] = regr(CCDC_CCDCFG);
+	ccdc_ctx[CCDC_FMTCFG >> 2] = regr(CCDC_FMTCFG);
+	ccdc_ctx[CCDC_FMT_HORZ >> 2] = regr(CCDC_FMT_HORZ);
+	ccdc_ctx[CCDC_FMT_VERT >> 2] = regr(CCDC_FMT_VERT);
+	ccdc_ctx[CCDC_FMT_ADDR0 >> 2] = regr(CCDC_FMT_ADDR0);
+	ccdc_ctx[CCDC_FMT_ADDR1 >> 2] = regr(CCDC_FMT_ADDR1);
+	ccdc_ctx[CCDC_FMT_ADDR2 >> 2] = regr(CCDC_FMT_ADDR2);
+	ccdc_ctx[CCDC_FMT_ADDR3 >> 2] = regr(CCDC_FMT_ADDR3);
+	ccdc_ctx[CCDC_FMT_ADDR4 >> 2] = regr(CCDC_FMT_ADDR4);
+	ccdc_ctx[CCDC_FMT_ADDR5 >> 2] = regr(CCDC_FMT_ADDR5);
+	ccdc_ctx[CCDC_FMT_ADDR6 >> 2] = regr(CCDC_FMT_ADDR6);
+	ccdc_ctx[CCDC_FMT_ADDR7 >> 2] = regr(CCDC_FMT_ADDR7);
+	ccdc_ctx[CCDC_PRGEVEN_0 >> 2] = regr(CCDC_PRGEVEN_0);
+	ccdc_ctx[CCDC_PRGEVEN_1 >> 2] = regr(CCDC_PRGEVEN_1);
+	ccdc_ctx[CCDC_PRGODD_0 >> 2] = regr(CCDC_PRGODD_0);
+	ccdc_ctx[CCDC_PRGODD_1 >> 2] = regr(CCDC_PRGODD_1);
+	ccdc_ctx[CCDC_VP_OUT >> 2] = regr(CCDC_VP_OUT);
+}
+
+static void ccdc_restore_context(void)
+{
+	regw(ccdc_ctx[CCDC_SYN_MODE >> 2], CCDC_SYN_MODE);
+	regw(ccdc_ctx[CCDC_HD_VD_WID >> 2], CCDC_HD_VD_WID);
+	regw(ccdc_ctx[CCDC_PIX_LINES >> 2], CCDC_PIX_LINES);
+	regw(ccdc_ctx[CCDC_HORZ_INFO >> 2], CCDC_HORZ_INFO);
+	regw(ccdc_ctx[CCDC_VERT_START >> 2], CCDC_VERT_START);
+	regw(ccdc_ctx[CCDC_VERT_LINES >> 2], CCDC_VERT_LINES);
+	regw(ccdc_ctx[CCDC_CULLING >> 2], CCDC_CULLING);
+	regw(ccdc_ctx[CCDC_HSIZE_OFF >> 2], CCDC_HSIZE_OFF);
+	regw(ccdc_ctx[CCDC_SDOFST >> 2], CCDC_SDOFST);
+	regw(ccdc_ctx[CCDC_SDR_ADDR >> 2], CCDC_SDR_ADDR);
+	regw(ccdc_ctx[CCDC_CLAMP >> 2], CCDC_CLAMP);
+	regw(ccdc_ctx[CCDC_DCSUB >> 2], CCDC_DCSUB);
+	regw(ccdc_ctx[CCDC_COLPTN >> 2], CCDC_COLPTN);
+	regw(ccdc_ctx[CCDC_BLKCMP >> 2], CCDC_BLKCMP);
+	regw(ccdc_ctx[CCDC_FPC >> 2], CCDC_FPC);
+	regw(ccdc_ctx[CCDC_FPC_ADDR >> 2], CCDC_FPC_ADDR);
+	regw(ccdc_ctx[CCDC_VDINT >> 2], CCDC_VDINT);
+	regw(ccdc_ctx[CCDC_ALAW >> 2], CCDC_ALAW);
+	regw(ccdc_ctx[CCDC_REC656IF >> 2], CCDC_REC656IF);
+	regw(ccdc_ctx[CCDC_CCDCFG >> 2], CCDC_CCDCFG);
+	regw(ccdc_ctx[CCDC_FMTCFG >> 2], CCDC_FMTCFG);
+	regw(ccdc_ctx[CCDC_FMT_HORZ >> 2], CCDC_FMT_HORZ);
+	regw(ccdc_ctx[CCDC_FMT_VERT >> 2], CCDC_FMT_VERT);
+	regw(ccdc_ctx[CCDC_FMT_ADDR0 >> 2], CCDC_FMT_ADDR0);
+	regw(ccdc_ctx[CCDC_FMT_ADDR1 >> 2], CCDC_FMT_ADDR1);
+	regw(ccdc_ctx[CCDC_FMT_ADDR2 >> 2], CCDC_FMT_ADDR2);
+	regw(ccdc_ctx[CCDC_FMT_ADDR3 >> 2], CCDC_FMT_ADDR3);
+	regw(ccdc_ctx[CCDC_FMT_ADDR4 >> 2], CCDC_FMT_ADDR4);
+	regw(ccdc_ctx[CCDC_FMT_ADDR5 >> 2], CCDC_FMT_ADDR5);
+	regw(ccdc_ctx[CCDC_FMT_ADDR6 >> 2], CCDC_FMT_ADDR6);
+	regw(ccdc_ctx[CCDC_FMT_ADDR7 >> 2], CCDC_FMT_ADDR7);
+	regw(ccdc_ctx[CCDC_PRGEVEN_0 >> 2], CCDC_PRGEVEN_0);
+	regw(ccdc_ctx[CCDC_PRGEVEN_1 >> 2], CCDC_PRGEVEN_1);
+	regw(ccdc_ctx[CCDC_PRGODD_0 >> 2], CCDC_PRGODD_0);
+	regw(ccdc_ctx[CCDC_PRGODD_1 >> 2], CCDC_PRGODD_1);
+	regw(ccdc_ctx[CCDC_VP_OUT >> 2], CCDC_VP_OUT);
+	regw(ccdc_ctx[CCDC_PCR >> 2], CCDC_PCR);
+}
 static struct ccdc_hw_device ccdc_hw_dev = {
 	.name = "DM6446 CCDC",
 	.owner = THIS_MODULE,
@@ -953,10 +1037,40 @@ static int dm644x_ccdc_remove(struct platform_device *pdev)
 	return 0;
 }

+static int dm644x_ccdc_suspend(struct device *dev)
+{
+	/* Save CCDC context */
+	ccdc_save_context();
+	/* Disable CCDC */
+	ccdc_enable(0);
+	/* Disable both master and slave clock */
+	clk_disable(ccdc_cfg.mclk);
+	clk_disable(ccdc_cfg.sclk);
+
+	return 0;
+}
+
+static int dm644x_ccdc_resume(struct device *dev)
+{
+	/* Enable both master and slave clock */
+	clk_enable(ccdc_cfg.mclk);
+	clk_enable(ccdc_cfg.sclk);
+	/* Restore CCDC context */
+	ccdc_restore_context();
+
+	return 0;
+}
+
+static const struct dev_pm_ops dm644x_ccdc_pm_ops = {
+	.suspend = dm644x_ccdc_suspend,
+	.resume = dm644x_ccdc_resume,
+};
+
 static struct platform_driver dm644x_ccdc_driver = {
 	.driver = {
 		.name	= "dm644x_ccdc",
 		.owner = THIS_MODULE,
+		.pm = &dm644x_ccdc_pm_ops,
 	},
 	.remove = __devexit_p(dm644x_ccdc_remove),
 	.probe = dm644x_ccdc_probe,
diff --git a/drivers/media/video/ti-media/dm644x_ccdc_regs.h b/drivers/media/video/ti-media/dm644x_ccdc_regs.h
index b18d166..90370e4 100644
--- a/drivers/media/video/ti-media/dm644x_ccdc_regs.h
+++ b/drivers/media/video/ti-media/dm644x_ccdc_regs.h
@@ -59,7 +59,7 @@
 #define CCDC_PRGODD_0				0x8c
 #define CCDC_PRGODD_1				0x90
 #define CCDC_VP_OUT				0x94
-
+#define CCDC_REG_END				0x98

 /***************************************************************
 *	Define for various register bit mask and shifts for CCDC
--
1.6.2.4

