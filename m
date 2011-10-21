Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40274 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab1JUHfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Oct 2011 03:35:45 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LTE00IQUNRJCHP0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:43 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LTE0023BNRJDQG0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Oct 2011 16:35:43 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: "HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 4/5] m5mols: Add boot flag for not showing the msg of I2C error
Date: Fri, 21 Oct 2011 16:35:53 +0900
Message-id: <1319182554-10645-4-git-send-email-riverful.kim@samsung.com>
In-reply-to: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
References: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In M-5MOLS sensor, the I2C error can be occured before sensor booting done,
becase I2C interface is not stabilized although the sensor have done already
for booting, so the right value is deliver through I2C interface. In case,
it needs to make the I2C error msg not to be printed.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h      |    2 ++
 drivers/media/video/m5mols/m5mols_core.c |   17 +++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 75f7984..0d7e202 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -175,6 +175,7 @@ struct m5mols_version {
  * @ver: information of the version
  * @cap: the capture mode attributes
  * @power: current sensor's power status
+ * @boot: "true" means the M-5MOLS sensor done ARM Booting
  * @ctrl_sync: true means all controls of the sensor are initialized
  * @int_capture: true means the capture interrupt is issued once
  * @lock_ae: true means the Auto Exposure is locked
@@ -210,6 +211,7 @@ struct m5mols_info {
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
 	bool power;
+	bool boot;
 	bool issue;
 	bool ctrl_sync;
 	bool lock_ae;
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 24e66ad..0aae868 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -138,6 +138,7 @@ static u32 m5mols_swap_byte(u8 *data, u8 length)
 static int m5mols_read(struct v4l2_subdev *sd, u32 size, u32 reg, u32 *val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct m5mols_info *info = to_m5mols(sd);
 	u8 rbuf[M5MOLS_I2C_MAX_SIZE + 1];
 	u8 category = I2C_CATEGORY(reg);
 	u8 cmd = I2C_COMMAND(reg);
@@ -168,8 +169,10 @@ static int m5mols_read(struct v4l2_subdev *sd, u32 size, u32 reg, u32 *val)
 
 	ret = i2c_transfer(client->adapter, msg, 2);
 	if (ret < 0) {
-		v4l2_err(sd, "read failed: size:%d cat:%02x cmd:%02x. %d\n",
-			 size, category, cmd, ret);
+		if (info->boot)
+			v4l2_err(sd,
+				"read failed: cat:%02x cmd:%02x ret:%d\n",
+				category, cmd, ret);
 		return ret;
 	}
 
@@ -232,6 +235,7 @@ int m5mols_read_u32(struct v4l2_subdev *sd, u32 reg, u32 *val)
 int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct m5mols_info *info = to_m5mols(sd);
 	u8 wbuf[M5MOLS_I2C_MAX_SIZE + 4];
 	u8 category = I2C_CATEGORY(reg);
 	u8 cmd = I2C_COMMAND(reg);
@@ -263,8 +267,10 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
 
 	ret = i2c_transfer(client->adapter, msg, 1);
 	if (ret < 0) {
-		v4l2_err(sd, "write failed: size:%d cat:%02x cmd:%02x. %d\n",
-			size, category, cmd, ret);
+		if (info->boot)
+			v4l2_err(sd,
+				"write failed: cat:%02x cmd:%02x ret:%d\n",
+				category, cmd, ret);
 		return ret;
 	}
 
@@ -778,6 +784,7 @@ int __attribute__ ((weak)) m5mols_update_fw(struct v4l2_subdev *sd,
  */
 static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
 {
+	struct m5mols_info *info = to_m5mols(sd);
 	int ret;
 
 	/* Execute ARM boot sequence */
@@ -786,6 +793,8 @@ static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
 		ret = m5mols_write(sd, FLASH_CAM_START, REG_START_ARM_BOOT);
 	if (!ret)
 		ret = m5mols_timeout_interrupt(sd, REG_INT_MODE, 2000);
+	if (!ret)
+		info->boot = true;
 	if (ret < 0)
 		return ret;
 
-- 
1.7.4.1

