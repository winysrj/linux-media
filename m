Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1419 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab3CDLTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 06:19:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/2] davinci/dm644x_ccdc: fix compiler warning
Date: Mon,  4 Mar 2013 12:19:22 +0100
Message-Id: <ea9d6410777ee7ed06cd2869b20ce0f03b1bb8d7.1362395861.git.hans.verkuil@cisco.com>
In-Reply-To: <1362395963-14266-1-git-send-email-hverkuil@xs4all.nl>
References: <1362395963-14266-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/platform/davinci/dm644x_ccdc.c: In function ‘validate_ccdc_param’:
drivers/media/platform/davinci/dm644x_ccdc.c:233:32: warning: comparison between ‘enum ccdc_gama_width’ and ‘enum ccdc_data_size’ [-Wenum-compare]

It took a bit of work, see this thread of an earlier attempt to fix this:

https://patchwork.kernel.org/patch/1923091/

I've chosen not to follow the suggestions in that thread since gamma_width is
really a different property from data_size. What you really want is to know if
gamma_width fits inside data_size and for that you need to translate each
enum into a maximum bit number so you can safely compare the two.

So I put in two static inline translation functions instead, keeping the rest
of the code the same (except for fixing the 'gama' typo).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/dm644x_ccdc.c      |   13 ++++++-----
 drivers/media/platform/davinci/dm644x_ccdc_regs.h |    2 +-
 include/media/davinci/dm644x_ccdc.h               |   24 +++++++++++++++------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 318e805..971d639 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -228,9 +228,12 @@ static void ccdc_readregs(void)
 static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
 {
 	if (ccdcparam->alaw.enable) {
-		if ((ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) ||
-		    (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_15_6) ||
-		    (ccdcparam->alaw.gama_wd < ccdcparam->data_sz)) {
+		u8 max_gamma = ccdc_gamma_width_max_bit(ccdcparam->alaw.gamma_wd);
+		u8 max_data = ccdc_data_size_max_bit(ccdcparam->data_sz);
+
+		if ((ccdcparam->alaw.gamma_wd > CCDC_GAMMA_BITS_09_0) ||
+		    (ccdcparam->alaw.gamma_wd < CCDC_GAMMA_BITS_15_6) ||
+		    (max_gamma > max_data)) {
 			dev_dbg(ccdc_cfg.dev, "\nInvalid data line select");
 			return -1;
 		}
@@ -560,8 +563,8 @@ void ccdc_config_raw(void)
 
 	/* Enable and configure aLaw register if needed */
 	if (config_params->alaw.enable) {
-		val = ((config_params->alaw.gama_wd &
-		      CCDC_ALAW_GAMA_WD_MASK) | CCDC_ALAW_ENABLE);
+		val = ((config_params->alaw.gamma_wd &
+		      CCDC_ALAW_GAMMA_WD_MASK) | CCDC_ALAW_ENABLE);
 		regw(val, CCDC_ALAW);
 		dev_dbg(ccdc_cfg.dev, "\nWriting 0x%x to ALAW...\n", val);
 	}
diff --git a/drivers/media/platform/davinci/dm644x_ccdc_regs.h b/drivers/media/platform/davinci/dm644x_ccdc_regs.h
index 90370e4..2b0aca5 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc_regs.h
+++ b/drivers/media/platform/davinci/dm644x_ccdc_regs.h
@@ -84,7 +84,7 @@
 #define CCDC_VDHDEN_ENABLE			(1 << 16)
 #define CCDC_LPF_ENABLE				(1 << 14)
 #define CCDC_ALAW_ENABLE			(1 << 3)
-#define CCDC_ALAW_GAMA_WD_MASK			7
+#define CCDC_ALAW_GAMMA_WD_MASK			7
 #define CCDC_BLK_CLAMP_ENABLE			(1 << 31)
 #define CCDC_BLK_SGAIN_MASK			0x1F
 #define CCDC_BLK_ST_PXL_MASK			0x7FFF
diff --git a/include/media/davinci/dm644x_ccdc.h b/include/media/davinci/dm644x_ccdc.h
index 3e178eb..852e96c 100644
--- a/include/media/davinci/dm644x_ccdc.h
+++ b/include/media/davinci/dm644x_ccdc.h
@@ -38,17 +38,23 @@ enum ccdc_sample_line {
 	CCDC_SAMPLE_16LINES
 };
 
-/* enum for Alaw gama width */
-enum ccdc_gama_width {
-	CCDC_GAMMA_BITS_15_6,
+/* enum for Alaw gamma width */
+enum ccdc_gamma_width {
+	CCDC_GAMMA_BITS_15_6,	/* use bits 15-6 for gamma */
 	CCDC_GAMMA_BITS_14_5,
 	CCDC_GAMMA_BITS_13_4,
 	CCDC_GAMMA_BITS_12_3,
 	CCDC_GAMMA_BITS_11_2,
 	CCDC_GAMMA_BITS_10_1,
-	CCDC_GAMMA_BITS_09_0
+	CCDC_GAMMA_BITS_09_0	/* use bits 9-0 for gamma */
 };
 
+/* returns the highest bit used for the gamma */
+static inline u8 ccdc_gamma_width_max_bit(enum ccdc_gamma_width width)
+{
+	return 15 - width;
+}
+
 enum ccdc_data_size {
 	CCDC_DATA_16BITS,
 	CCDC_DATA_15BITS,
@@ -60,12 +66,18 @@ enum ccdc_data_size {
 	CCDC_DATA_8BITS
 };
 
+/* returns the highest bit used for this data size */
+static inline u8 ccdc_data_size_max_bit(enum ccdc_data_size sz)
+{
+	return sz == CCDC_DATA_8BITS ? 7 : 15 - sz;
+}
+
 /* structure for ALaw */
 struct ccdc_a_law {
 	/* Enable/disable A-Law */
 	unsigned char enable;
-	/* Gama Width Input */
-	enum ccdc_gama_width gama_wd;
+	/* Gamma Width Input */
+	enum ccdc_gamma_width gamma_wd;
 };
 
 /* structure for Black Clamping */
-- 
1.7.10.4

