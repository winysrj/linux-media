Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:36900 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1E0M6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 08:58:14 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LLU0096EUOYJTU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLU00DYAUOY16@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Date: Fri, 27 May 2011 21:58:12 +0900
From: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [PATCH 2/5] m5mols: add m5mols_read_u8/u16/u32() according to I2C byte
 width
In-reply-to: <20110525135435.GA3547@valkosipuli.localdomain>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1306501095-28267-3-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <20110525135435.GA3547@valkosipuli.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

For now, the m5mols_read() share in case of I2C packet 1, 2, 4 byte(2) width.
So, this commit adds 3 functions - m5mols_read_u8/u16/u32() according to byte
width of I2C packet. And, the u32 variables in spite of u8 or u16 for fitting
to m5mols_read() having no choice, is replaced to have original byte width
like u8, u16, u32 as same reason.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |   52 +++++++-------
 drivers/media/video/m5mols/m5mols_capture.c  |   18 +++---
 drivers/media/video/m5mols/m5mols_controls.c |    2 +-
 drivers/media/video/m5mols/m5mols_core.c     |   96 ++++++++++++++++++--------
 4 files changed, 104 insertions(+), 64 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 10b55c8..dbe8928 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -106,23 +106,23 @@ struct m5mols_capture {
  * The each value according to each scenemode is recommended in the documents.
  */
 struct m5mols_scenemode {
-	u32 metering;
-	u32 ev_bias;
-	u32 wb_mode;
-	u32 wb_preset;
-	u32 chroma_en;
-	u32 chroma_lvl;
-	u32 edge_en;
-	u32 edge_lvl;
-	u32 af_range;
-	u32 fd_mode;
-	u32 mcc;
-	u32 light;
-	u32 flash;
-	u32 tone;
-	u32 iso;
-	u32 capt_mode;
-	u32 wdr;
+	u8 metering;
+	u8 ev_bias;
+	u8 wb_mode;
+	u8 wb_preset;
+	u8 chroma_en;
+	u8 chroma_lvl;
+	u8 edge_en;
+	u8 edge_lvl;
+	u8 af_range;
+	u8 fd_mode;
+	u8 mcc;
+	u8 light;
+	u8 flash;
+	u8 tone;
+	u8 iso;
+	u8 capt_mode;
+	u8 wdr;
 };
 
 /**
@@ -216,9 +216,9 @@ struct m5mols_info {
 	bool lock_ae;
 	bool lock_awb;
 	u8 resolution;
-	u32 interrupt;
-	u32 mode;
-	u32 mode_save;
+	u8 interrupt;
+	u8 mode;
+	u8 mode_save;
 	int (*set_power)(struct device *dev, int on);
 };
 
@@ -256,9 +256,11 @@ struct m5mols_info {
  *   +-------+---+----------+-----+------+------+------+------+
  *   - d[0..3]: according to size1
  */
-int m5mols_read(struct v4l2_subdev *sd, u32 reg_comb, u32 *val);
+int m5mols_read_u8(struct v4l2_subdev *sd, u32 reg_comb, u8 *val);
+int m5mols_read_u16(struct v4l2_subdev *sd, u32 reg_comb, u16 *val);
+int m5mols_read_u32(struct v4l2_subdev *sd, u32 reg_comb, u32 *val);
 int m5mols_write(struct v4l2_subdev *sd, u32 reg_comb, u32 val);
-int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u32 value);
+int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u8 value);
 
 /*
  * Mode operation of the M-5MOLS
@@ -280,12 +282,12 @@ int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u32 value);
  * The available executing order between each modes are as follows:
  *   PARAMETER <---> MONITOR <---> CAPTURE
  */
-int m5mols_mode(struct m5mols_info *info, u32 mode);
+int m5mols_mode(struct m5mols_info *info, u8 mode);
 
-int m5mols_enable_interrupt(struct v4l2_subdev *sd, u32 reg);
+int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg);
 int m5mols_sync_controls(struct m5mols_info *info);
 int m5mols_start_capture(struct m5mols_info *info);
-int m5mols_do_scenemode(struct m5mols_info *info, u32 mode);
+int m5mols_do_scenemode(struct m5mols_info *info, u8 mode);
 int m5mols_lock_3a(struct m5mols_info *info, bool lock);
 int m5mols_set_ctrl(struct v4l2_ctrl *ctrl);
 
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index d71a390..751f459 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -58,9 +58,9 @@ static int m5mols_read_rational(struct v4l2_subdev *sd, u32 addr_num,
 {
 	u32 num, den;
 
-	int ret = m5mols_read(sd, addr_num, &num);
+	int ret = m5mols_read_u32(sd, addr_num, &num);
 	if (!ret)
-		ret = m5mols_read(sd, addr_den, &den);
+		ret = m5mols_read_u32(sd, addr_den, &den);
 	if (ret)
 		return ret;
 	*val = den == 0 ? 0 : num / den;
@@ -99,20 +99,20 @@ static int m5mols_capture_info(struct m5mols_info *info)
 	if (ret)
 		return ret;
 
-	ret = m5mols_read(sd, EXIF_INFO_ISO, (u32 *)&exif->iso_speed);
+	ret = m5mols_read_u16(sd, EXIF_INFO_ISO, &exif->iso_speed);
 	if (!ret)
-		ret = m5mols_read(sd, EXIF_INFO_FLASH, (u32 *)&exif->flash);
+		ret = m5mols_read_u16(sd, EXIF_INFO_FLASH, &exif->flash);
 	if (!ret)
-		ret = m5mols_read(sd, EXIF_INFO_SDR, (u32 *)&exif->sdr);
+		ret = m5mols_read_u16(sd, EXIF_INFO_SDR, &exif->sdr);
 	if (!ret)
-		ret = m5mols_read(sd, EXIF_INFO_QVAL, (u32 *)&exif->qval);
+		ret = m5mols_read_u16(sd, EXIF_INFO_QVAL, &exif->qval);
 	if (ret)
 		return ret;
 
 	if (!ret)
-		ret = m5mols_read(sd, CAPC_IMAGE_SIZE, &info->cap.main);
+		ret = m5mols_read_u32(sd, CAPC_IMAGE_SIZE, &info->cap.main);
 	if (!ret)
-		ret = m5mols_read(sd, CAPC_THUMB_SIZE, &info->cap.thumb);
+		ret = m5mols_read_u32(sd, CAPC_THUMB_SIZE, &info->cap.thumb);
 	if (!ret)
 		info->cap.total = info->cap.main + info->cap.thumb;
 
@@ -122,7 +122,7 @@ static int m5mols_capture_info(struct m5mols_info *info)
 int m5mols_start_capture(struct m5mols_info *info)
 {
 	struct v4l2_subdev *sd = &info->sd;
-	u32 resolution = info->resolution;
+	u8 resolution = info->resolution;
 	int timeout;
 	int ret;
 
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 817c16f..d392c83 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -130,7 +130,7 @@ static struct m5mols_scenemode m5mols_default_scenemode[] = {
  *
  * WARNING: The execution order is important. Do not change the order.
  */
-int m5mols_do_scenemode(struct m5mols_info *info, u32 mode)
+int m5mols_do_scenemode(struct m5mols_info *info, u8 mode)
 {
 	struct v4l2_subdev *sd = &info->sd;
 	struct m5mols_scenemode scenemode = m5mols_default_scenemode[mode];
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 76eac26..2b1f23f 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -133,13 +133,13 @@ static u32 m5mols_swap_byte(u8 *data, u8 length)
 /**
  * m5mols_read -  I2C read function
  * @reg: combination of size, category and command for the I2C packet
+ * @size: desired size of I2C packet
  * @val: read value
  */
-int m5mols_read(struct v4l2_subdev *sd, u32 reg, u32 *val)
+static int m5mols_read(struct v4l2_subdev *sd, u32 size, u32 reg, u32 *val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	u8 rbuf[M5MOLS_I2C_MAX_SIZE + 1];
-	u8 size = I2C_SIZE(reg);
 	u8 category = I2C_CATEGORY(reg);
 	u8 cmd = I2C_COMMAND(reg);
 	struct i2c_msg msg[2];
@@ -149,11 +149,6 @@ int m5mols_read(struct v4l2_subdev *sd, u32 reg, u32 *val)
 	if (!client->adapter)
 		return -ENODEV;
 
-	if (size != 1 && size != 2 && size != 4) {
-		v4l2_err(sd, "Wrong data size\n");
-		return -EINVAL;
-	}
-
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
 	msg[0].len = 5;
@@ -184,6 +179,52 @@ int m5mols_read(struct v4l2_subdev *sd, u32 reg, u32 *val)
 	return 0;
 }
 
+int m5mols_read_u8(struct v4l2_subdev *sd, u32 reg, u8 *val)
+{
+	u32 val_32;
+	int ret;
+
+	if (I2C_SIZE(reg) != 1) {
+		v4l2_err(sd, "Wrong data size\n");
+		return -EINVAL;
+	}
+
+	ret = m5mols_read(sd, I2C_SIZE(reg), reg, &val_32);
+	if (ret)
+		return ret;
+
+	*val = (u8)val_32;
+	return ret;
+}
+
+int m5mols_read_u16(struct v4l2_subdev *sd, u32 reg, u16 *val)
+{
+	u32 val_32;
+	int ret;
+
+	if (I2C_SIZE(reg) != 2) {
+		v4l2_err(sd, "Wrong data size\n");
+		return -EINVAL;
+	}
+
+	ret = m5mols_read(sd, I2C_SIZE(reg), reg, &val_32);
+	if (ret)
+		return ret;
+
+	*val = (u16)val_32;
+	return ret;
+}
+
+int m5mols_read_u32(struct v4l2_subdev *sd, u32 reg, u32 *val)
+{
+	if (I2C_SIZE(reg) != 4) {
+		v4l2_err(sd, "Wrong data size\n");
+		return -EINVAL;
+	}
+
+	return m5mols_read(sd, I2C_SIZE(reg), reg, val);
+}
+
 /**
  * m5mols_write - I2C command write function
  * @reg: combination of size, category and command for the I2C packet
@@ -231,13 +272,14 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
 	return 0;
 }
 
-int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u32 mask)
+int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u8 mask)
 {
-	u32 busy, i;
+	u8 busy;
+	int i;
 	int ret;
 
 	for (i = 0; i < M5MOLS_I2C_CHECK_RETRY; i++) {
-		ret = m5mols_read(sd, I2C_REG(category, cmd, 1), &busy);
+		ret = m5mols_read_u8(sd, I2C_REG(category, cmd, 1), &busy);
 		if (ret < 0)
 			return ret;
 		if ((busy & mask) == mask)
@@ -252,14 +294,14 @@ int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u32 mask)
  * Before writing desired interrupt value the INT_FACTOR register should
  * be read to clear pending interrupts.
  */
-int m5mols_enable_interrupt(struct v4l2_subdev *sd, u32 reg)
+int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg)
 {
 	struct m5mols_info *info = to_m5mols(sd);
-	u32 mask = is_available_af(info) ? REG_INT_AF : 0;
-	u32 dummy;
+	u8 mask = is_available_af(info) ? REG_INT_AF : 0;
+	u8 dummy;
 	int ret;
 
-	ret = m5mols_read(sd, SYSTEM_INT_FACTOR, &dummy);
+	ret = m5mols_read_u8(sd, SYSTEM_INT_FACTOR, &dummy);
 	if (!ret)
 		ret = m5mols_write(sd, SYSTEM_INT_ENABLE, reg & ~mask);
 	return ret;
@@ -271,7 +313,7 @@ int m5mols_enable_interrupt(struct v4l2_subdev *sd, u32 reg)
  * It always accompanies a little delay changing the M-5MOLS mode, so it is
  * needed checking current busy status to guarantee right mode.
  */
-static int m5mols_reg_mode(struct v4l2_subdev *sd, u32 mode)
+static int m5mols_reg_mode(struct v4l2_subdev *sd, u8 mode)
 {
 	int ret = m5mols_write(sd, SYSTEM_SYSMODE, mode);
 
@@ -286,16 +328,16 @@ static int m5mols_reg_mode(struct v4l2_subdev *sd, u32 mode)
  * can be guaranteed only when the sensor is operating in mode which which
  * a command belongs to.
  */
-int m5mols_mode(struct m5mols_info *info, u32 mode)
+int m5mols_mode(struct m5mols_info *info, u8 mode)
 {
 	struct v4l2_subdev *sd = &info->sd;
 	int ret = -EINVAL;
-	u32 reg;
+	u8 reg;
 
 	if (mode < REG_PARAMETER && mode > REG_CAPTURE)
 		return ret;
 
-	ret = m5mols_read(sd, SYSTEM_SYSMODE, &reg);
+	ret = m5mols_read_u8(sd, SYSTEM_SYSMODE, &reg);
 	if ((!ret && reg == mode) || ret)
 		return ret;
 
@@ -348,28 +390,24 @@ static int m5mols_get_version(struct v4l2_subdev *sd)
 		struct m5mols_version ver;
 		u8 bytes[VERSION_SIZE];
 	} version;
-	u32 *value;
 	u8 cmd = CAT0_VER_CUSTOMER;
 	int ret;
 
 	do {
-		value = (u32 *)&version.bytes[cmd];
-		ret = m5mols_read(sd, SYSTEM_CMD(cmd), value);
+		ret = m5mols_read_u8(sd, SYSTEM_CMD(cmd), &version.bytes[cmd]);
 		if (ret)
 			return ret;
 	} while (cmd++ != CAT0_VER_AWB);
 
 	do {
-		value = (u32 *)&version.bytes[cmd];
-		ret = m5mols_read(sd, SYSTEM_VER_STRING, value);
+		ret = m5mols_read_u8(sd, SYSTEM_VER_STRING, &version.bytes[cmd]);
 		if (ret)
 			return ret;
 		if (cmd >= VERSION_SIZE - 1)
 			return -EINVAL;
 	} while (version.bytes[cmd++]);
 
-	value = (u32 *)&version.bytes[cmd];
-	ret = m5mols_read(sd, AF_VERSION, value);
+	ret = m5mols_read_u8(sd, AF_VERSION, &version.bytes[cmd]);
 	if (ret)
 		return ret;
 
@@ -722,7 +760,7 @@ static int m5mols_init_controls(struct m5mols_info *info)
 	int ret;
 
 	/* Determine value's range & step of controls for various FW version */
-	ret = m5mols_read(sd, AE_MAX_GAIN_MON, (u32 *)&max_exposure);
+	ret = m5mols_read_u16(sd, AE_MAX_GAIN_MON, &max_exposure);
 	if (!ret)
 		step_zoom = is_manufacturer(info, REG_SAMSUNG_OPTICS) ? 31 : 1;
 	if (ret)
@@ -842,18 +880,18 @@ static void m5mols_irq_work(struct work_struct *work)
 	struct m5mols_info *info =
 		container_of(work, struct m5mols_info, work_irq);
 	struct v4l2_subdev *sd = &info->sd;
-	u32 reg;
+	u8 reg;
 	int ret;
 
 	if (!is_powered(info) ||
-			m5mols_read(sd, SYSTEM_INT_FACTOR, &info->interrupt))
+			m5mols_read_u8(sd, SYSTEM_INT_FACTOR, &info->interrupt))
 		return;
 
 	switch (info->interrupt & REG_INT_MASK) {
 	case REG_INT_AF:
 		if (!is_available_af(info))
 			break;
-		ret = m5mols_read(sd, AF_STATUS, &reg);
+		ret = m5mols_read_u8(sd, AF_STATUS, &reg);
 		v4l2_dbg(2, m5mols_debug, sd, "AF %s\n",
 			 reg == REG_AF_FAIL ? "Failed" :
 			 reg == REG_AF_SUCCESS ? "Success" :
-- 
1.7.0.4

