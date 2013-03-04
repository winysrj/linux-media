Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2229 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab3CDLTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 06:19:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/2] davinci: more gama -> gamma typo fixes.
Date: Mon,  4 Mar 2013 12:19:23 +0100
Message-Id: <1c75e578e64fa834679109097006030973afaa66.1362395861.git.hans.verkuil@cisco.com>
In-Reply-To: <1362395963-14266-1-git-send-email-hverkuil@xs4all.nl>
References: <1362395963-14266-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea9d6410777ee7ed06cd2869b20ce0f03b1bb8d7.1362395861.git.hans.verkuil@cisco.com>
References: <ea9d6410777ee7ed06cd2869b20ce0f03b1bb8d7.1362395861.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/dm355_ccdc.c      |   10 +++++-----
 drivers/media/platform/davinci/dm355_ccdc_regs.h |    2 +-
 drivers/media/platform/davinci/isif.c            |    2 +-
 drivers/media/platform/davinci/isif_regs.h       |    4 ++--
 include/media/davinci/dm355_ccdc.h               |    6 +++---
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index 4277e4a..2364dba 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -85,7 +85,7 @@ static struct ccdc_oper_config {
 			.mfilt1 = CCDC_NO_MEDIAN_FILTER1,
 			.mfilt2 = CCDC_NO_MEDIAN_FILTER2,
 			.alaw = {
-				.gama_wd = 2,
+				.gamma_wd = 2,
 			},
 			.blk_clamp = {
 				.sample_pixel = 1,
@@ -303,8 +303,8 @@ static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
 	}
 
 	if (ccdcparam->alaw.enable) {
-		if (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_13_4 ||
-		    ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) {
+		if (ccdcparam->alaw.gamma_wd < CCDC_GAMMA_BITS_13_4 ||
+		    ccdcparam->alaw.gamma_wd > CCDC_GAMMA_BITS_09_0) {
 			dev_dbg(ccdc_cfg.dev, "Invalid value of ALAW\n");
 			return -EINVAL;
 		}
@@ -680,8 +680,8 @@ static int ccdc_config_raw(void)
 	/* Enable and configure aLaw register if needed */
 	if (config_params->alaw.enable) {
 		val |= (CCDC_ALAW_ENABLE |
-			((config_params->alaw.gama_wd &
-			CCDC_ALAW_GAMA_WD_MASK) <<
+			((config_params->alaw.gamma_wd &
+			CCDC_ALAW_GAMMA_WD_MASK) <<
 			CCDC_GAMMAWD_INPUT_SHIFT));
 	}
 
diff --git a/drivers/media/platform/davinci/dm355_ccdc_regs.h b/drivers/media/platform/davinci/dm355_ccdc_regs.h
index d6d2ef0..2e1946e 100644
--- a/drivers/media/platform/davinci/dm355_ccdc_regs.h
+++ b/drivers/media/platform/davinci/dm355_ccdc_regs.h
@@ -153,7 +153,7 @@
 #define CCDC_VDHDEN_ENABLE			(1 << 16)
 #define CCDC_LPF_ENABLE				(1 << 14)
 #define CCDC_ALAW_ENABLE			1
-#define CCDC_ALAW_GAMA_WD_MASK			7
+#define CCDC_ALAW_GAMMA_WD_MASK			7
 #define CCDC_REC656IF_BT656_EN			3
 
 #define CCDC_FMTCFG_FMTMODE_MASK 		3
diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index 5050f92..abc3ae3 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -604,7 +604,7 @@ static int isif_config_raw(void)
 	if (module_params->compress.alg == ISIF_ALAW)
 		val |= ISIF_ALAW_ENABLE;
 
-	val |= (params->data_msb << ISIF_ALAW_GAMA_WD_SHIFT);
+	val |= (params->data_msb << ISIF_ALAW_GAMMA_WD_SHIFT);
 	regw(val, CGAMMAWD);
 
 	/* Configure DPCM compression settings */
diff --git a/drivers/media/platform/davinci/isif_regs.h b/drivers/media/platform/davinci/isif_regs.h
index aa69a46..3993aec 100644
--- a/drivers/media/platform/davinci/isif_regs.h
+++ b/drivers/media/platform/davinci/isif_regs.h
@@ -203,8 +203,8 @@
 #define ISIF_LPF_MASK				1
 
 /* GAMMAWD registers */
-#define ISIF_ALAW_GAMA_WD_MASK			0xF
-#define ISIF_ALAW_GAMA_WD_SHIFT			1
+#define ISIF_ALAW_GAMMA_WD_MASK			0xF
+#define ISIF_ALAW_GAMMA_WD_SHIFT		1
 #define ISIF_ALAW_ENABLE			1
 #define ISIF_GAMMAWD_CFA_SHIFT			5
 
diff --git a/include/media/davinci/dm355_ccdc.h b/include/media/davinci/dm355_ccdc.h
index adf2fe4..c669a9f 100644
--- a/include/media/davinci/dm355_ccdc.h
+++ b/include/media/davinci/dm355_ccdc.h
@@ -38,7 +38,7 @@ enum ccdc_sample_line {
 	CCDC_SAMPLE_16LINES
 };
 
-/* enum for Alaw gama width */
+/* enum for Alaw gamma width */
 enum ccdc_gamma_width {
 	CCDC_GAMMA_BITS_13_4,
 	CCDC_GAMMA_BITS_12_3,
@@ -97,8 +97,8 @@ enum ccdc_mfilt2 {
 struct ccdc_a_law {
 	/* Enable/disable A-Law */
 	unsigned char enable;
-	/* Gama Width Input */
-	enum ccdc_gamma_width gama_wd;
+	/* Gamma Width Input */
+	enum ccdc_gamma_width gamma_wd;
 };
 
 /* structure for Black Clamping */
-- 
1.7.10.4

