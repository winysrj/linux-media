Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63178 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1JUHfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Oct 2011 03:35:44 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LTE0088NNQUP620@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:43 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LTE0015QNRIS6S0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:42 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: "HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/5] m5mols: Add more functions to check busy status
Date: Fri, 21 Oct 2011 16:35:50 +0900
Message-id: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add 3 type of checking busy status functions. 1) Keep busy-loop
ignoring the error of I2C negative return, 2) Provide the read status value
from I2C to the caller, 3) Compare masked value with desire value.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h      |    1 -
 drivers/media/video/m5mols/m5mols_core.c |   43 ++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 89d09a8..c8e1572 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -259,7 +259,6 @@ int m5mols_read_u8(struct v4l2_subdev *sd, u32 reg_comb, u8 *val);
 int m5mols_read_u16(struct v4l2_subdev *sd, u32 reg_comb, u16 *val);
 int m5mols_read_u32(struct v4l2_subdev *sd, u32 reg_comb, u32 *val);
 int m5mols_write(struct v4l2_subdev *sd, u32 reg_comb, u32 val);
-int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u8 value);
 
 /*
  * Mode operation of the M-5MOLS
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 5d21d05..73db96e 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -271,22 +271,49 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
 	return 0;
 }
 
-int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u8 mask)
+/**
+ * __m5mols_busy - Base function of checking busy status.
+ * @use: use return value for checking I2C err, or keep the loop until RETRY.
+ * @mask: mask the I2C value for comparing desire value, or do not mask.
+ * @desire: this is compared with the I2C value.
+ *
+ * The M-5MOLS use frequently polling method for checking registers.
+ */
+int __m5mols_busy(struct v4l2_subdev *sd, bool use, u8 mask, u8 desire,
+		  u8 *value, u8 category, u8 cmd)
 {
-	u8 busy;
 	int i;
 	int ret;
 
 	for (i = 0; i < M5MOLS_I2C_CHECK_RETRY; i++) {
-		ret = m5mols_read_u8(sd, I2C_REG(category, cmd, 1), &busy);
-		if (ret < 0)
+		ret = m5mols_read_u8(sd, I2C_REG(category, cmd, 1), value);
+
+		if ((use ? ret : 0) < 0)
 			return ret;
-		if ((busy & mask) == mask)
+		if ((mask ? (*value & mask) : *value) == desire)
 			return 0;
 	}
 	return -EBUSY;
 }
 
+int m5mols_busy(struct v4l2_subdev *sd, u8 desire, u8 category, u8 cmd)
+{
+	u8 dummy;
+	return __m5mols_busy(sd, false, 0x0, desire, &dummy, category, cmd);
+}
+
+int m5mols_busy_val(struct v4l2_subdev *sd, u8 desire, u8 *value,
+		    u8 category, u8 cmd)
+{
+	return __m5mols_busy(sd, false, 0x0, desire, value, category, cmd);
+}
+
+int m5mols_busy_mask(struct v4l2_subdev *sd, u8 desire, u8 category, u8 cmd)
+{
+	u8 dummy;
+	return __m5mols_busy(sd, true, desire, desire, &dummy, category, cmd);
+}
+
 /**
  * m5mols_enable_interrupt - Clear interrupt pending bits and unmask interrupts
  *
@@ -316,7 +343,7 @@ static int m5mols_reg_mode(struct v4l2_subdev *sd, u8 mode)
 {
 	int ret = m5mols_write(sd, SYSTEM_SYSMODE, mode);
 
-	return ret ? ret : m5mols_busy(sd, CAT_SYSTEM, CAT0_SYSMODE, mode);
+	return ret ? ret : m5mols_busy_mask(sd, mode, CAT_SYSTEM, CAT0_SYSMODE);
 }
 
 /**
@@ -832,8 +859,8 @@ static int m5mols_s_power(struct v4l2_subdev *sd, int on)
 		if (!ret)
 			ret = m5mols_write(sd, AF_MODE, REG_AF_POWEROFF);
 		if (!ret)
-			ret = m5mols_busy(sd, CAT_SYSTEM, CAT0_STATUS,
-					REG_AF_IDLE);
+			ret = m5mols_busy_mask(sd, REG_AF_IDLE,
+						CAT_SYSTEM, CAT0_STATUS);
 		if (!ret)
 			v4l2_info(sd, "Success soft-landing lens\n");
 	}
-- 
1.7.4.1

