Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38354 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752012AbdEHW0a (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 18:26:30 -0400
Received: by mail-wm0-f46.google.com with SMTP id 142so80958527wma.1
        for <linux-media@vger.kernel.org>; Mon, 08 May 2017 15:26:29 -0700 (PDT)
From: Mark Railton <mark@markrailton.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Railton <mark@markrailton.com>
Subject: [PATCH] ATOMISP: Tidies up code warnings and errors in file
Date: Mon,  8 May 2017 23:25:55 +0100
Message-Id: <1494282355-1926-1-git-send-email-mark@markrailton.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleared up some errors and warnings in
drivers/staging/media/atomisp/i2c/ap1302.c

Signed-off-by: Mark Railton <mark@markrailton.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 83 ++++++++++++++++++------------
 1 file changed, 50 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index bacffbe..8c33a35 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -11,11 +11,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- *
  */
 
 #include "../include/linux/atomisp.h"
@@ -162,9 +157,11 @@ static struct ap1302_context_info context_info[] = {
 	{CNTX_HINF_CTRL, AP1302_REG16, "hinf_ctrl"},
 };
 
-/* This array stores the description list for metadata.
-   The metadata contains exposure settings and face
-   detection results. */
+/*
+ *  This array stores the description list for metadata.
+ *  The metadata contains exposure settings and face
+ *  detection results.
+ */
 static u16 ap1302_ss_list[] = {
 	0xb01c, /* From 0x0186 with size 0x1C are exposure settings. */
 	0x0186,
@@ -213,6 +210,7 @@ static int ap1302_i2c_write_reg(struct v4l2_subdev *sd,
 	struct ap1302_device *dev = to_ap1302_device(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret;
+
 	if (len == AP1302_REG16)
 		ret = regmap_write(dev->regmap16, reg, val);
 	else if (len == AP1302_REG32)
@@ -236,11 +234,13 @@ static u16
 ap1302_calculate_context_reg_addr(enum ap1302_contexts context, u16 offset)
 {
 	u16 reg_addr;
-	/* The register offset is defined according to preview/video registers.
-	   Preview and video context have the same register definition.
-	   But snapshot context does not have register S1_SENSOR_MODE.
-	   When setting snapshot registers, if the offset exceeds
-	   S1_SENSOR_MODE, the actual offset needs to minus 2. */
+	/*
+	 *  The register offset is defined according to preview/video registers.
+	 *  Preview and video context have the same register definition.
+	 *  But snapshot context does not have register S1_SENSOR_MODE.
+	 *  When setting snapshot registers, if the offset exceeds
+	 *  S1_SENSOR_MODE, the actual offset needs to minus 2.
+	 */
 	if (context == CONTEXT_SNAPSHOT) {
 		if (offset == CNTX_S1_SENSOR_MODE)
 			return 0;
@@ -261,6 +261,7 @@ static int ap1302_read_context_reg(struct v4l2_subdev *sd,
 {
 	struct ap1302_device *dev = to_ap1302_device(sd);
 	u16 reg_addr = ap1302_calculate_context_reg_addr(context, offset);
+
 	if (reg_addr == 0)
 		return -EINVAL;
 	return ap1302_i2c_read_reg(sd, reg_addr, len,
@@ -272,6 +273,7 @@ static int ap1302_write_context_reg(struct v4l2_subdev *sd,
 {
 	struct ap1302_device *dev = to_ap1302_device(sd);
 	u16 reg_addr = ap1302_calculate_context_reg_addr(context, offset);
+
 	if (reg_addr == 0)
 		return -EINVAL;
 	return ap1302_i2c_write_reg(sd, reg_addr, len,
@@ -284,7 +286,9 @@ static int ap1302_dump_context_reg(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ap1302_device *dev = to_ap1302_device(sd);
 	int i;
+
 	dev_dbg(&client->dev, "Dump registers for context[%d]:\n", context);
+
 	for (i = 0; i < ARRAY_SIZE(context_info); i++) {
 		struct ap1302_context_info *info = &context_info[i];
 		u8 *var = (u8 *)&dev->cntx_config[context] + info->offset;
@@ -308,6 +312,7 @@ static int ap1302_request_firmware(struct v4l2_subdev *sd)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ap1302_device *dev = to_ap1302_device(sd);
 	int ret;
+
 	ret = request_firmware(&dev->fw, "ap1302_fw.bin", &client->dev);
 	if (ret)
 		dev_err(&client->dev,
@@ -315,12 +320,14 @@ static int ap1302_request_firmware(struct v4l2_subdev *sd)
 	return ret;
 }
 
-/* When loading firmware, host writes firmware data from address 0x8000.
-   When the address reaches 0x9FFF, the next address should return to 0x8000.
-   This function handles this address window and load firmware data to AP1302.
-   win_pos indicates the offset within this window. Firmware loading procedure
-   may call this function several times. win_pos records the current position
-   that has been written to.*/
+/*
+ *  When loading firmware, host writes firmware data from address 0x8000.
+ *  When the address reaches 0x9FFF, the next address should return to 0x8000.
+ *  This function handles this address window and load firmware data to AP1302.
+ *  win_pos indicates the offset within this window. Firmware loading procedure
+ *  may call this function several times. win_pos records the current position
+ *  that has been written to.
+ */
 static int ap1302_write_fw_window(struct v4l2_subdev *sd,
 				  u16 *win_pos, const u8 *buf, u32 len)
 {
@@ -328,6 +335,7 @@ static int ap1302_write_fw_window(struct v4l2_subdev *sd,
 	int ret;
 	u32 pos;
 	u32 sub_len;
+
 	for (pos = 0; pos < len; pos += sub_len) {
 		if (len - pos < AP1302_FW_WINDOW_SIZE - *win_pos)
 			sub_len = len - pos;
@@ -365,9 +373,11 @@ static int ap1302_load_firmware(struct v4l2_subdev *sd)
 		dev_err(&client->dev, "firmware size does not match.\n");
 		return -EINVAL;
 	}
-	/* The fw binary contains a header of struct ap1302_firmware.
-	   Following the header is the bootdata of AP1302.
-	   The bootdata pointer can be referenced as &fw[1]. */
+	/*
+	 *  The fw binary contains a header of struct ap1302_firmware.
+	 *  Following the header is the bootdata of AP1302.
+	 *  The bootdata pointer can be referenced as &fw[1].
+	 */
 	fw_data = (u8 *)&fw[1];
 
 	/* Clear crc register. */
@@ -380,8 +390,10 @@ static int ap1302_load_firmware(struct v4l2_subdev *sd)
 	if (ret)
 		return ret;
 
-	/* Write 2 to bootdata_stage register to apply basic_init_hp
-	   settings and enable PLL. */
+	/*
+	 *  Write 2 to bootdata_stage register to apply basic_init_hp
+	 *  settings and enable PLL.
+	 */
 	ret = ap1302_i2c_write_reg(sd, REG_BOOTDATA_STAGE,
 				   AP1302_REG16, 0x0002);
 	if (ret)
@@ -407,8 +419,10 @@ static int ap1302_load_firmware(struct v4l2_subdev *sd)
 		return -EAGAIN;
 	}
 
-	/* Write 0xFFFF to bootdata_stage register to indicate AP1302 that
-	   the whole bootdata content has been loaded. */
+	/*
+	 *  Write 0xFFFF to bootdata_stage register to indicate AP1302 that
+	 *  the whole bootdata content has been loaded.
+	 */
 	ret = ap1302_i2c_write_reg(sd, REG_BOOTDATA_STAGE,
 				   AP1302_REG16, 0xFFFF);
 	if (ret)
@@ -536,6 +550,7 @@ static int ap1302_s_config(struct v4l2_subdev *sd, void *pdata)
 static enum ap1302_contexts ap1302_get_context(struct v4l2_subdev *sd)
 {
 	struct ap1302_device *dev = to_ap1302_device(sd);
+
 	return dev->cur_context;
 }
 
@@ -606,16 +621,16 @@ static s32 ap1302_try_mbus_fmt_locked(struct v4l2_subdev *sd,
 
 
 static int ap1302_get_fmt(struct v4l2_subdev *sd,
-	                 struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_pad_config *cfg,
 					 struct v4l2_subdev_format *format)
 
 {
-    struct v4l2_mbus_framefmt *fmt = &format->format;
-    struct ap1302_device *dev = to_ap1302_device(sd);
-	enum ap1302_contexts context;
-	struct ap1302_res_struct *res_table;
-	s32 cur_res;
-     if (format->pad)
+	struct v4l2_mbus_framefmt *fmt = &format->format;
+	struct ap1302_device *dev = to_ap1302_device(sd);
+		enum ap1302_contexts context;
+		struct ap1302_res_struct *res_table;
+		s32 cur_res;
+	if (format->pad)
 		return -EINVAL;
 	mutex_lock(&dev->input_lock);
 	context = ap1302_get_context(sd);
@@ -638,6 +653,7 @@ static int ap1302_set_fmt(struct v4l2_subdev *sd,
 	struct atomisp_input_stream_info *stream_info =
 		(struct atomisp_input_stream_info *)fmt->reserved;
 	enum ap1302_contexts context, main_context;
+
 	if (format->pad)
 		return -EINVAL;
 	if (!fmt)
@@ -1000,6 +1016,7 @@ static int ap1302_s_register(struct v4l2_subdev *sd,
 static long ap1302_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 {
 	long ret = 0;
+
 	switch (cmd) {
 	case VIDIOC_DBG_G_REGISTER:
 		ret = ap1302_g_register(sd, arg);
-- 
2.7.4
