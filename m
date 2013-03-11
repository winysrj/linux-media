Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4917 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3CKLqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 04/42] saa7115: add config flag to change the IDQ polarity.
Date: Mon, 11 Mar 2013 12:45:42 +0100
Message-Id: <5188f8de24bcb24f13bb22f36df6291aaf6fe2fc.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Needed by the go7007 driver: it assumes a different polarity of the IDQ
signal, so we need to be able to tell the saa7115 about this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa7115.c |    6 ++++++
 include/media/saa7115.h     |   31 +++++++++++++++++++++----------
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 6b6788c..f249b20 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1259,6 +1259,12 @@ static int saa711x_s_routing(struct v4l2_subdev *sd,
 				(saa711x_read(sd, R_83_X_PORT_I_O_ENA_AND_OUT_CLK) & 0xfe) |
 				(state->output & 0x01));
 	}
+	if (state->ident > V4L2_IDENT_SAA7111A) {
+		if (config & SAA7115_IDQ_IS_DEFAULT)
+			saa711x_write(sd, R_85_I_PORT_SIGNAL_POLAR, 0x20);
+		else
+			saa711x_write(sd, R_85_I_PORT_SIGNAL_POLAR, 0x21);
+	}
 	return 0;
 }
 
diff --git a/include/media/saa7115.h b/include/media/saa7115.h
index bab2127..8b2ecc6 100644
--- a/include/media/saa7115.h
+++ b/include/media/saa7115.h
@@ -21,6 +21,8 @@
 #ifndef _SAA7115_H_
 #define _SAA7115_H_
 
+/* s_routing inputs, outputs, and config */
+
 /* SAA7111/3/4/5 HW inputs */
 #define SAA7115_COMPOSITE0 0
 #define SAA7115_COMPOSITE1 1
@@ -33,24 +35,33 @@
 #define SAA7115_SVIDEO2    8
 #define SAA7115_SVIDEO3    9
 
-/* SAA7115 v4l2_crystal_freq frequency values */
-#define SAA7115_FREQ_32_11_MHZ  32110000   /* 32.11 MHz crystal, SAA7114/5 only */
-#define SAA7115_FREQ_24_576_MHZ 24576000   /* 24.576 MHz crystal */
-
-/* SAA7115 v4l2_crystal_freq audio clock control flags */
-#define SAA7115_FREQ_FL_UCGC   (1 << 0)	   /* SA 3A[7], UCGC, SAA7115 only */
-#define SAA7115_FREQ_FL_CGCDIV (1 << 1)	   /* SA 3A[6], CGCDIV, SAA7115 only */
-#define SAA7115_FREQ_FL_APLL   (1 << 2)	   /* SA 3A[3], APLL, SAA7114/5 only */
-
+/* outputs */
 #define SAA7115_IPORT_ON    	1
 #define SAA7115_IPORT_OFF   	0
 
-/* SAA7111 specific output flags */
+/* SAA7111 specific outputs. */
 #define SAA7111_VBI_BYPASS 	2
 #define SAA7111_FMT_YUV422      0x00
 #define SAA7111_FMT_RGB 	0x40
 #define SAA7111_FMT_CCIR 	0x80
 #define SAA7111_FMT_YUV411 	0xc0
 
+/* config flags */
+/* Register 0x85 should set bit 0 to 0 (it's 1 by default). This bit
+ * controls the IDQ signal polarity which is set to 'inverted' if the bit
+ * it 1 and to 'default' if it is 0. */
+#define SAA7115_IDQ_IS_DEFAULT  (1 << 0)
+
+/* s_crystal_freq values and flags */
+
+/* SAA7115 v4l2_crystal_freq frequency values */
+#define SAA7115_FREQ_32_11_MHZ  32110000   /* 32.11 MHz crystal, SAA7114/5 only */
+#define SAA7115_FREQ_24_576_MHZ 24576000   /* 24.576 MHz crystal */
+
+/* SAA7115 v4l2_crystal_freq audio clock control flags */
+#define SAA7115_FREQ_FL_UCGC   (1 << 0)	   /* SA 3A[7], UCGC, SAA7115 only */
+#define SAA7115_FREQ_FL_CGCDIV (1 << 1)	   /* SA 3A[6], CGCDIV, SAA7115 only */
+#define SAA7115_FREQ_FL_APLL   (1 << 2)	   /* SA 3A[3], APLL, SAA7114/5 only */
+
 #endif
 
-- 
1.7.10.4

