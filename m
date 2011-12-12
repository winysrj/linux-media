Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41577 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1LLRpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:04 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW300D5SQN2ER90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:02 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3007URQN1EF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:02 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:47 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 03/14] m5mols: Extend the busy wait helper
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-4-git-send-email-s.nawrocki@samsung.com>
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: HeungJun Kim <riverful.kim@samsung.com>

Make m5mols_busy_wait function jiffies based rather than relying
on some fixed number of I2C read iterations while busy waiting
for the device to execute a request. With fixed number of iterations
we may be getting different wait times, depending on the I2C speed.

In some conditions we have to wait even if the I2C communications
fails, in those cases M5MOLS_I2C_RDY_WAIT_MASK should be passed
as the mask argument to m5mols_busy_wait().

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h      |   11 ++++++-
 drivers/media/video/m5mols/m5mols_core.c |   47 +++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 21ccc98..2461a44 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -23,6 +23,10 @@
 #define M5MOLS_JPEG_TAGS_SIZE		0x20000
 #define M5MOLS_MAIN_JPEG_SIZE_MAX	(5 * SZ_1M)
 
+/* ISP state transition timeout, in ms */
+#define M5MOLS_MODE_CHANGE_TIMEOUT	200
+#define M5MOLS_BUSY_WAIT_DEF_TIMEOUT	250
+
 extern int m5mols_debug;
 
 #define to_m5mols(__sd)	container_of(__sd, struct m5mols_info, sd)
@@ -261,7 +265,12 @@ int m5mols_read_u8(struct v4l2_subdev *sd, u32 reg_comb, u8 *val);
 int m5mols_read_u16(struct v4l2_subdev *sd, u32 reg_comb, u16 *val);
 int m5mols_read_u32(struct v4l2_subdev *sd, u32 reg_comb, u32 *val);
 int m5mols_write(struct v4l2_subdev *sd, u32 reg_comb, u32 val);
-int m5mols_busy(struct v4l2_subdev *sd, u32 reg, u8 value);
+
+int m5mols_busy_wait(struct v4l2_subdev *sd, u32 reg, u32 value, u32 mask,
+		     int timeout);
+
+/* Mask value for busy waiting until M-5MOLS I2C interface is initialized */
+#define M5MOLS_I2C_RDY_WAIT_MASK ((u32)~0)
 
 /*
  * Mode operation of the M-5MOLS
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 59903ed..a1302dc 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -272,19 +272,35 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
 	return 0;
 }
 
-int m5mols_busy(struct v4l2_subdev *sd, u32 reg, u8 mask)
+/**
+ * m5mols_busy_wait - Busy waiting with I2C register polling
+ * @reg: the I2C_REG() address of an 8-bit status register to check
+ * @value: expected status register value
+ * @mask: bit mask for the read status register value
+ * @timeout: timeout in miliseconds, or -1 for default timeout
+ *
+ * The @reg register value is ORed with @mask before comparing with @value.
+ *
+ * Return: 0 if the requested condition became true within less than
+ *         @timeout ms, or else negative errno.
+ */
+int m5mols_busy_wait(struct v4l2_subdev *sd, u32 reg, u32 value, u32 mask,
+		     int timeout)
 {
-	u8 busy;
-	int i;
-	int ret;
+	int ms = timeout < 0 ? M5MOLS_BUSY_WAIT_DEF_TIMEOUT : timeout;
+	unsigned long end = jiffies + msecs_to_jiffies(ms);
+	u8 status;
 
-	for (i = 0; i < M5MOLS_I2C_CHECK_RETRY; i++) {
-		ret = m5mols_read_u8(sd, reg, &busy);
-		if (ret < 0)
+	do {
+		int ret = m5mols_read_u8(sd, reg, &status);
+
+		if (ret < 0 && mask <= 0xff)
 			return ret;
-		if ((busy & mask) == mask)
+		if (!ret && (status & mask) == value)
 			return 0;
-	}
+		usleep_range(100, 250);
+	} while (ms > 0 && time_is_after_jiffies(end));
+
 	return -EBUSY;
 }
 
@@ -316,8 +332,10 @@ int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg)
 static int m5mols_reg_mode(struct v4l2_subdev *sd, u8 mode)
 {
 	int ret = m5mols_write(sd, SYSTEM_SYSMODE, mode);
-
-	return ret ? ret : m5mols_busy(sd, mode, SYSTEM_SYSMODE);
+	if (ret < 0)
+		return ret;
+	return m5mols_busy_wait(sd, SYSTEM_SYSMODE, mode, 0xff,
+				M5MOLS_MODE_CHANGE_TIMEOUT);
 }
 
 /**
@@ -844,9 +862,10 @@ static int m5mols_s_power(struct v4l2_subdev *sd, int on)
 		if (!ret)
 			ret = m5mols_write(sd, AF_MODE, REG_AF_POWEROFF);
 		if (!ret)
-			ret = m5mols_busy(sd, SYSTEM_STATUS, REG_AF_IDLE);
-		if (!ret)
-			v4l2_info(sd, "Success soft-landing lens\n");
+			ret = m5mols_busy_wait(sd, SYSTEM_STATUS, REG_AF_IDLE,
+					       0xff, -1);
+		if (ret < 0)
+			v4l2_warn(sd, "Soft landing lens failed\n");
 	}
 
 	ret = m5mols_sensor_power(info, false);
-- 
1.7.8

