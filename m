Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2601 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3CKLqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 06/42] saa7115: add support for double-rate ASCLK
Date: Mon, 11 Mar 2013 12:45:44 +0100
Message-Id: <6f49fd63991545d1e9aada9c8c06ae5a3fcd5bee.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some devices expect a double rate ASCLK. Add a flag to let the driver know
through the s_crystal_freq call.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa7115.c |   16 +++++++++++-----
 include/media/saa7115.h     |    7 ++++---
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index d301442..9d3dbb3 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -83,9 +83,10 @@ struct saa711x_state {
 	u32 ident;
 	u32 audclk_freq;
 	u32 crystal_freq;
-	u8 ucgc;
+	bool ucgc;
 	u8 cgcdiv;
-	u8 apll;
+	bool apll;
+	bool double_asclk;
 };
 
 static inline struct saa711x_state *to_state(struct v4l2_subdev *sd)
@@ -732,8 +733,12 @@ static int saa711x_s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 	if (state->apll)
 		acc |= 0x08;
 
+	if (state->double_asclk) {
+		acpf <<= 1;
+		acni <<= 1;
+	}
 	saa711x_write(sd, R_38_CLK_RATIO_AMXCLK_TO_ASCLK, 0x03);
-	saa711x_write(sd, R_39_CLK_RATIO_ASCLK_TO_ALRCLK, 0x10);
+	saa711x_write(sd, R_39_CLK_RATIO_ASCLK_TO_ALRCLK, 0x10 << state->double_asclk);
 	saa711x_write(sd, R_3A_AUD_CLK_GEN_BASIC_SETUP, acc);
 
 	saa711x_write(sd, R_30_AUD_MAST_CLK_CYCLES_PER_FIELD, acpf & 0xff);
@@ -1302,9 +1307,10 @@ static int saa711x_s_crystal_freq(struct v4l2_subdev *sd, u32 freq, u32 flags)
 	if (freq != SAA7115_FREQ_32_11_MHZ && freq != SAA7115_FREQ_24_576_MHZ)
 		return -EINVAL;
 	state->crystal_freq = freq;
+	state->double_asclk = flags & SAA7115_FREQ_FL_DOUBLE_ASCLK;
 	state->cgcdiv = (flags & SAA7115_FREQ_FL_CGCDIV) ? 3 : 4;
-	state->ucgc = (flags & SAA7115_FREQ_FL_UCGC) ? 1 : 0;
-	state->apll = (flags & SAA7115_FREQ_FL_APLL) ? 1 : 0;
+	state->ucgc = flags & SAA7115_FREQ_FL_UCGC;
+	state->apll = flags & SAA7115_FREQ_FL_APLL;
 	saa711x_s_clock_freq(sd, state->audclk_freq);
 	return 0;
 }
diff --git a/include/media/saa7115.h b/include/media/saa7115.h
index 8b2ecc6..4079186 100644
--- a/include/media/saa7115.h
+++ b/include/media/saa7115.h
@@ -59,9 +59,10 @@
 #define SAA7115_FREQ_24_576_MHZ 24576000   /* 24.576 MHz crystal */
 
 /* SAA7115 v4l2_crystal_freq audio clock control flags */
-#define SAA7115_FREQ_FL_UCGC   (1 << 0)	   /* SA 3A[7], UCGC, SAA7115 only */
-#define SAA7115_FREQ_FL_CGCDIV (1 << 1)	   /* SA 3A[6], CGCDIV, SAA7115 only */
-#define SAA7115_FREQ_FL_APLL   (1 << 2)	   /* SA 3A[3], APLL, SAA7114/5 only */
+#define SAA7115_FREQ_FL_UCGC         (1 << 0) /* SA 3A[7], UCGC, SAA7115 only */
+#define SAA7115_FREQ_FL_CGCDIV       (1 << 1) /* SA 3A[6], CGCDIV, SAA7115 only */
+#define SAA7115_FREQ_FL_APLL         (1 << 2) /* SA 3A[3], APLL, SAA7114/5 only */
+#define SAA7115_FREQ_FL_DOUBLE_ASCLK (1 << 3) /* SA 39, LRDIV, SAA7114/5 only */
 
 #endif
 
-- 
1.7.10.4

