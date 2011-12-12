Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41577 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1LLRpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:07 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW300DC4QN3CU90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3001DTQN2FG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:50 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 06/14] m5mols: Add support for the system initialization
 interrupt
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-7-git-send-email-s.nawrocki@samsung.com>
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: HeungJun Kim <riverful.kim@samsung.com>

The M-5MOLS internal controller's initialization time depends on the
hardware and firmware revision. Currently the driver just waits for
worst case time period, after applying the voltage supplies, for
the device to be ready. The M-5MOLS supports "System initialization"
interrupt which is triggered after the controller finished booting.
So use this interrupt to optimize the initialization sequence.

After the voltage supplies are applied the I2C communication will
fail, until the internal controller initializes to Flash Writer
state. For the period when the I2C is not accessible use the
isp_ready flag to suppress the error logs.

Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h      |   12 +++--
 drivers/media/video/m5mols/m5mols_core.c |   77 +++++++++++++++++------------
 drivers/media/video/m5mols/m5mols_reg.h  |    3 +-
 3 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index cf9701c..3cf9af3 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -182,8 +182,8 @@ struct m5mols_version {
  * @ver: information of the version
  * @cap: the capture mode attributes
  * @power: current sensor's power status
- * @ctrl_sync: true means all controls of the sensor are initialized
- * @int_capture: true means the capture interrupt is issued once
+ * @isp_ready: 1 when the ISP controller has completed booting
+ * @ctrl_sync: 1 when the control handler state is restored in H/W
  * @lock_ae: true means the Auto Exposure is locked
  * @lock_awb: true means the Aut WhiteBalance is locked
  * @resolution:	register value for current resolution
@@ -212,8 +212,11 @@ struct m5mols_info {
 
 	struct m5mols_version ver;
 	struct m5mols_capture cap;
-	bool power;
-	bool ctrl_sync;
+
+	unsigned int isp_ready:1;
+	unsigned int power:1;
+	unsigned int ctrl_sync:1;
+
 	bool lock_ae;
 	bool lock_awb;
 	u8 resolution;
@@ -221,7 +224,6 @@ struct m5mols_info {
 	int (*set_power)(struct device *dev, int on);
 };
 
-#define is_powered(__info) (__info->power)
 #define is_ctrl_synced(__info) (__info->ctrl_sync)
 #define is_available_af(__info)	(__info->ver.af)
 #define is_code(__code, __type) (__code == m5mols_default_ffmt[__type].code)
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 8ee5e81..3298c6f 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -135,10 +135,13 @@ static u32 m5mols_swap_byte(u8 *data, u8 length)
  * @reg: combination of size, category and command for the I2C packet
  * @size: desired size of I2C packet
  * @val: read value
+ *
+ * Returns 0 on success, or else negative errno.
  */
 static int m5mols_read(struct v4l2_subdev *sd, u32 size, u32 reg, u32 *val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct m5mols_info *info = to_m5mols(sd);
 	u8 rbuf[M5MOLS_I2C_MAX_SIZE + 1];
 	u8 category = I2C_CATEGORY(reg);
 	u8 cmd = I2C_COMMAND(reg);
@@ -168,15 +171,17 @@ static int m5mols_read(struct v4l2_subdev *sd, u32 size, u32 reg, u32 *val)
 	usleep_range(200, 200);
 
 	ret = i2c_transfer(client->adapter, msg, 2);
-	if (ret < 0) {
-		v4l2_err(sd, "read failed: size:%d cat:%02x cmd:%02x. %d\n",
-			 size, category, cmd, ret);
-		return ret;
+
+	if (ret == 2) {
+		*val = m5mols_swap_byte(&rbuf[1], size);
+		return 0;
 	}
 
-	*val = m5mols_swap_byte(&rbuf[1], size);
+	if (info->isp_ready)
+		v4l2_err(sd, "read failed: size:%d cat:%02x cmd:%02x. %d\n",
+			 size, category, cmd, ret);
 
-	return 0;
+	return ret < 0 ? ret : -EIO;
 }
 
 int m5mols_read_u8(struct v4l2_subdev *sd, u32 reg, u8 *val)
@@ -229,10 +234,13 @@ int m5mols_read_u32(struct v4l2_subdev *sd, u32 reg, u32 *val)
  * m5mols_write - I2C command write function
  * @reg: combination of size, category and command for the I2C packet
  * @val: value to write
+ *
+ * Returns 0 on success, or else negative errno.
  */
 int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct m5mols_info *info = to_m5mols(sd);
 	u8 wbuf[M5MOLS_I2C_MAX_SIZE + 4];
 	u8 category = I2C_CATEGORY(reg);
 	u8 cmd = I2C_COMMAND(reg);
@@ -263,13 +271,14 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
 	usleep_range(200, 200);
 
 	ret = i2c_transfer(client->adapter, msg, 1);
-	if (ret < 0) {
-		v4l2_err(sd, "write failed: size:%d cat:%02x cmd:%02x. %d\n",
-			size, category, cmd, ret);
-		return ret;
-	}
+	if (ret == 1)
+		return 0;
 
-	return 0;
+	if (info->isp_ready)
+		v4l2_err(sd, "write failed: cat:%02x cmd:%02x ret:%d\n",
+			 category, cmd, ret);
+
+	return ret < 0 ? ret : -EIO;
 }
 
 /**
@@ -634,7 +643,7 @@ int m5mols_sync_controls(struct m5mols_info *info)
 			return ret;
 
 		v4l2_ctrl_handler_setup(&info->handle);
-		info->ctrl_sync = true;
+		info->ctrl_sync = 1;
 	}
 
 	return ret;
@@ -714,10 +723,10 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 	const struct m5mols_platform_data *pdata = info->pdata;
 	int ret;
 
-	if (enable) {
-		if (is_powered(info))
-			return 0;
+	if (info->power == enable)
+		return 0;
 
+	if (enable) {
 		if (info->set_power) {
 			ret = info->set_power(&client->dev, 1);
 			if (ret)
@@ -731,15 +740,11 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 		}
 
 		gpio_set_value(pdata->gpio_reset, !pdata->reset_polarity);
-		usleep_range(1000, 1000);
-		info->power = true;
+		info->power = 1;
 
 		return ret;
 	}
 
-	if (!is_powered(info))
-		return 0;
-
 	ret = regulator_bulk_disable(ARRAY_SIZE(supplies), supplies);
 	if (ret)
 		return ret;
@@ -748,8 +753,9 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 		info->set_power(&client->dev, 0);
 
 	gpio_set_value(pdata->gpio_reset, pdata->reset_polarity);
-	usleep_range(1000, 1000);
-	info->power = false;
+
+	info->isp_ready = 0;
+	info->power = 0;
 
 	return ret;
 }
@@ -762,21 +768,28 @@ int __attribute__ ((weak)) m5mols_update_fw(struct v4l2_subdev *sd,
 }
 
 /**
- * m5mols_sensor_armboot - Booting M-5MOLS internal ARM core.
+ * m5mols_fw_start - M-5MOLS internal ARM controller initialization
  *
- * Booting internal ARM core makes the M-5MOLS is ready for getting commands
- * with I2C. It's the first thing to be done after it powered up. It must wait
- * at least 520ms recommended by M-5MOLS datasheet, after executing arm booting.
+ * Execute the M-5MOLS internal ARM controller initialization sequence.
+ * This function should be called after the supply voltage has been
+ * applied and before any requests to the device are made.
  */
-static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
+static int m5mols_fw_start(struct v4l2_subdev *sd)
 {
+	struct m5mols_info *info = to_m5mols(sd);
 	int ret;
 
-	ret = m5mols_write(sd, FLASH_CAM_START, REG_START_ARM_BOOT);
+	/* Wait until I2C slave is initialized in Flash Writer mode */
+	ret = m5mols_busy_wait(sd, FLASH_CAM_START, REG_IN_FLASH_MODE,
+			       M5MOLS_I2C_RDY_WAIT_MASK, -1);
+	if (!ret)
+		ret = m5mols_write(sd, FLASH_CAM_START, REG_START_ARM_BOOT);
+	if (!ret)
+		ret = m5mols_wait_interrupt(sd, REG_INT_MODE, 2000);
 	if (ret < 0)
 		return ret;
 
-	msleep(520);
+	info->isp_ready = 1;
 
 	ret = m5mols_get_version(sd);
 	if (!ret)
@@ -854,7 +867,7 @@ static int m5mols_s_power(struct v4l2_subdev *sd, int on)
 	if (on) {
 		ret = m5mols_sensor_power(info, true);
 		if (!ret)
-			ret = m5mols_sensor_armboot(sd);
+			ret = m5mols_fw_start(sd);
 		if (!ret)
 			ret = m5mols_init_controls(info);
 		if (ret)
@@ -883,7 +896,7 @@ static int m5mols_s_power(struct v4l2_subdev *sd, int on)
 	ret = m5mols_sensor_power(info, false);
 	if (!ret) {
 		v4l2_ctrl_handler_free(&info->handle);
-		info->ctrl_sync = false;
+		info->ctrl_sync = 0;
 	}
 
 	return ret;
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index 03d1c47..2e40b86 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -356,6 +356,7 @@
 
 /* Starts internal ARM core booting after power-up */
 #define FLASH_CAM_START		I2C_REG(CAT_FLASH, 0x12, 1)
-#define REG_START_ARM_BOOT	0x01
+#define REG_START_ARM_BOOT	0x01	/* write value */
+#define REG_IN_FLASH_MODE	0x00	/* read value */
 
 #endif	/* M5MOLS_REG_H */
-- 
1.7.8

