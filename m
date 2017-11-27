Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:37790 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752712AbdK0VpZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 16:45:25 -0500
Received: by mail-wr0-f195.google.com with SMTP id k61so27891997wrc.4
        for <linux-media@vger.kernel.org>; Mon, 27 Nov 2017 13:45:24 -0800 (PST)
From: Riccardo Schirone <sirmy15@gmail.com>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Cc: Riccardo Schirone <sirmy15@gmail.com>
Subject: [PATCH 2/4] staging: improve comments usage in atomisp-ov5693
Date: Mon, 27 Nov 2017 22:44:11 +0100
Message-Id: <20171127214413.10749-3-sirmy15@gmail.com>
In-Reply-To: <20171127214413.10749-1-sirmy15@gmail.com>
References: <20171127214413.10749-1-sirmy15@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Fix "Block comments use a trailing */ on a separate line" issue
* Fix "Block comments use * on subsequent lines" issue

Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>
---
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      | 38 ++++++++++++++--------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index 387c65be10f4..ecd607b7b005 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -213,7 +213,8 @@ static int vcm_dw_i2c_write(struct i2c_client *client, u16 data)
 	return ret == num_msg ? 0 : -EIO;
 }
 
-/* Theory: per datasheet, the two VCMs both allow for a 2-byte read.
+/*
+ * Theory: per datasheet, the two VCMs both allow for a 2-byte read.
  * The DW9714 doesn't actually specify what this does (it has a
  * two-byte write-only protocol, but specifies the read sequence as
  * legal), but it returns the same data (zeroes) always, after an
@@ -224,7 +225,8 @@ static int vcm_dw_i2c_write(struct i2c_client *client, u16 data)
  * these) in AD5823 are not pairwise repetitions of the same 16 bit
  * word.  So all we have to do is sequentially read two bytes at a
  * time and see if we detect a difference in any of the first four
- * pairs.  */
+ * pairs.
+ */
 static int vcm_detect(struct i2c_client *client)
 {
 	int i, ret;
@@ -238,8 +240,10 @@ static int vcm_detect(struct i2c_client *client)
 		msg.buf = (u8 *)&data;
 		ret = i2c_transfer(client->adapter, &msg, 1);
 
-		/* DW9714 always fails the first read and returns
-		 * zeroes for subsequent ones */
+		/*
+		 * DW9714 always fails the first read and returns
+		 * zeroes for subsequent ones
+		 */
 		if (i == 0 && ret == -EREMOTEIO) {
 			data0 = 0;
 			continue;
@@ -533,9 +537,11 @@ static long __ov5693_set_exposure(struct v4l2_subdev *sd, int coarse_itg,
 
 	hts = ov5693_res[dev->fmt_idx].pixels_per_line;
 	vts = ov5693_res[dev->fmt_idx].lines_per_frame;
-	/*If coarse_itg is larger than 1<<15, can not write to reg directly.
-	  The way is to write coarse_itg/2 to the reg, meanwhile write 2*hts
-	  to the reg. */
+	/*
+	 * If coarse_itg is larger than 1<<15, can not write to reg directly.
+	 * The way is to write coarse_itg/2 to the reg, meanwhile write 2*hts
+	 * to the reg.
+	 */
 	if (coarse_itg > (1 << 15)) {
 		hts = hts * 2;
 		coarse_itg = (int)coarse_itg / 2;
@@ -880,8 +886,10 @@ static long ov5693_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 	return 0;
 }
 
-/* This returns the exposure time being used. This should only be used
-   for filling in EXIF data, not for actual image processing. */
+/*
+ * This returns the exposure time being used. This should only be used
+ * for filling in EXIF data, not for actual image processing.
+ */
 static int ov5693_q_exposure(struct v4l2_subdev *sd, s32 *value)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -1301,11 +1309,13 @@ static int power_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* This driver assumes "internal DVDD, PWDNB tied to DOVDD".
+	/*
+	 * This driver assumes "internal DVDD, PWDNB tied to DOVDD".
 	 * In this set up only gpio0 (XSHUTDN) should be available
 	 * but in some products (for example ECS) gpio1 (PWDNB) is
 	 * also available. If gpio1 is available we emulate it being
-	 * tied to DOVDD here. */
+	 * tied to DOVDD here.
+	 */
 	if (flag) {
 		ret = dev->platform_data->v2p8_ctrl(sd, 1);
 		dev->platform_data->gpio1_ctrl(sd, 1);
@@ -1944,10 +1954,12 @@ static int ov5693_probe(struct i2c_client *client)
 	struct acpi_device *adev;
 	unsigned int i;
 
-	/* Firmware workaround: Some modules use a "secondary default"
+	/*
+	 * Firmware workaround: Some modules use a "secondary default"
 	 * address of 0x10 which doesn't appear on schematics, and
 	 * some BIOS versions haven't gotten the memo.  Work around
-	 * via config. */
+	 * via config.
+	 */
 	i2c = gmin_get_var_int(&client->dev, "I2CAddr", -1);
 	if (i2c != -1) {
 		dev_info(&client->dev,
-- 
2.14.3
