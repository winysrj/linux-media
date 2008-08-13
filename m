Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DBZK43018975
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 07:35:20 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7DBZ8Ye013839
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 07:35:08 -0400
Date: Wed, 13 Aug 2008 13:35:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1218621820.48a2b17c963cd@imp.free.fr>
Message-ID: <Pine.LNX.4.64.0808131322340.3884@axis700.grange>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
	<873alnt2bh.fsf@free.fr>
	<Pine.LNX.4.64.0808121612330.8089@axis700.grange>
	<1218616667.48a29d5bcb7ea@imp.free.fr>
	<Pine.LNX.4.64.0808131105020.3884@axis700.grange>
	<1218621820.48a2b17c963cd@imp.free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: [PATCH] mt9m111: style cleanup
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Fix a typo in Kconfig, simplify error checking, further minor cleanup.

Signed-off-by: Guennadi Liakhovetski <g.iakhovetski@gmx.de>

---

On Wed, 13 Aug 2008, robert.jarzmik@free.fr wrote:

> Selon Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> 
> > As for your mt9m111 patch - unfortunately, during my first quick review I
> > missed a few more minor formatting issues, so, because it is kinda my
> > fault, my plan is to apply your patch as it is, and then I can just post
> > for your ack a clean-up patch. And then, as we get format negotiation in
> > place, you can extend it with further supported formats. What do you
> > think?
> Very good idea. Let's do it that way, it's perfect for me.

Robert, please have a look at and test this patch. It fixes a typo, cleans 
up a couple of places, the big bulk of the change is replacing (ret >= 0) 
tests with (!ret), since smbus functions return a negative error or 0, 
just as we need it. I will do the same to mt9m001 and mt9v022.

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 68e7e90..68d5810 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -939,7 +939,7 @@ config MT9M001_PCA9536_SWITCH
 	  extender to switch between 8 and 10 bit datawidth modes
 
 config SOC_CAMERA_MT9M111
-	tristate "mt9m001 support"
+	tristate "mt9m111 support"
 	depends on SOC_CAMERA && I2C
 	help
 	  This driver supports MT9M111 cameras from Micron
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 0c88e5d..537cff0 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -173,7 +173,7 @@ static int reg_page_map_set(struct i2c_client *client, const u16 reg)
 		return -EINVAL;
 
 	ret = i2c_smbus_write_word_data(client, MT9M111_PAGE_MAP, swab16(page));
-	if (ret >= 0)
+	if (!ret)
 		lastpage = page;
 	return ret;
 }
@@ -200,7 +200,7 @@ static int mt9m111_reg_write(struct soc_camera_device *icd, const u16 reg,
 	int ret;
 
 	ret = reg_page_map_set(client, reg);
-	if (ret >= 0)
+	if (!ret)
 		ret = i2c_smbus_write_word_data(mt9m111->client, (reg & 0xff),
 						swab16(data));
 	dev_dbg(&icd->dev, "write reg.%03x = %04x -> %d\n", reg, data, ret);
@@ -246,7 +246,7 @@ static int mt9m111_set_context(struct soc_camera_device *icd,
 static int mt9m111_setup_rect(struct soc_camera_device *icd)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	int ret = 0, is_raw_format;
+	int ret, is_raw_format;
 	int width = mt9m111->width;
 	int height = mt9m111->height;
 
@@ -256,32 +256,31 @@ static int mt9m111_setup_rect(struct soc_camera_device *icd)
 	else
 		is_raw_format = 0;
 
-	if (ret >= 0)
-		ret = reg_write(COLUMN_START, mt9m111->left);
-	if (ret >= 0)
+	ret = reg_write(COLUMN_START, mt9m111->left);
+	if (!ret)
 		ret = reg_write(ROW_START, mt9m111->top);
 
 	if (is_raw_format) {
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(WINDOW_WIDTH, width);
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(WINDOW_HEIGHT, height);
 	} else {
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(REDUCER_XZOOM_B, MT9M111_MAX_WIDTH);
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(REDUCER_YZOOM_B, MT9M111_MAX_HEIGHT);
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(REDUCER_XSIZE_B, width);
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(REDUCER_YSIZE_B, height);
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(REDUCER_XZOOM_A, MT9M111_MAX_WIDTH);
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(REDUCER_YZOOM_A, MT9M111_MAX_HEIGHT);
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(REDUCER_XSIZE_A, width);
-		if (ret >= 0)
+		if (!ret)
 			ret = reg_write(REDUCER_YSIZE_A, height);
 	}
 
@@ -293,7 +292,7 @@ static int mt9m111_setup_pixfmt(struct soc_camera_device *icd, u16 outfmt)
 	int ret;
 
 	ret = reg_write(OUTPUT_FORMAT_CTRL2_A, outfmt);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(OUTPUT_FORMAT_CTRL2_B, outfmt);
 	return ret;
 }
@@ -305,7 +304,6 @@ static int mt9m111_setfmt_bayer8(struct soc_camera_device *icd)
 
 static int mt9m111_setfmt_bayer10(struct soc_camera_device *icd)
 {
-
 	return mt9m111_setup_pixfmt(icd, MT9M111_OUTFMT_BYPASS_IFP);
 }
 
@@ -356,7 +354,7 @@ static int mt9m111_enable(struct soc_camera_device *icd)
 	int ret;
 
 	ret = reg_set(RESET, MT9M111_RESET_CHIP_ENABLE);
-	if (ret >= 0)
+	if (!ret)
 		mt9m111->powered = 1;
 	return ret;
 }
@@ -367,7 +365,7 @@ static int mt9m111_disable(struct soc_camera_device *icd)
 	int ret;
 
 	ret = reg_clear(RESET, MT9M111_RESET_CHIP_ENABLE);
-	if (ret >= 0)
+	if (!ret)
 		mt9m111->powered = 0;
 	return ret;
 }
@@ -377,9 +375,9 @@ static int mt9m111_reset(struct soc_camera_device *icd)
 	int ret;
 
 	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_set(RESET, MT9M111_RESET_RESET_SOC);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_clear(RESET, MT9M111_RESET_RESET_MODE
 				| MT9M111_RESET_RESET_SOC);
 	return ret;
@@ -410,7 +408,7 @@ static int mt9m111_set_bus_param(struct soc_camera_device *icd, unsigned long f)
 static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	int ret = 0;
+	int ret;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_SBGGR8:
@@ -433,7 +431,7 @@ static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
 		ret = -EINVAL;
 	}
 
-	if (ret >= 0)
+	if (!ret)
 		mt9m111->pixfmt = pixfmt;
 
 	return ret;
@@ -443,7 +441,7 @@ static int mt9m111_set_fmt_cap(struct soc_camera_device *icd,
 			       __u32 pixfmt, struct v4l2_rect *rect)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	int ret = 0;
+	int ret;
 
 	mt9m111->left = rect->left;
 	mt9m111->top = rect->top;
@@ -455,9 +453,9 @@ static int mt9m111_set_fmt_cap(struct soc_camera_device *icd,
 		mt9m111->height);
 
 	ret = mt9m111_setup_rect(icd);
-	if (ret >= 0)
+	if (!ret)
 		ret = mt9m111_set_pixfmt(icd, pixfmt);
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 static int mt9m111_try_fmt_cap(struct soc_camera_device *icd,
@@ -644,7 +642,7 @@ static int mt9m111_set_global_gain(struct soc_camera_device *icd, int gain)
 	if ((gain >= 64 * 2) && (gain < 63 * 2 * 2))
 		val = (1 << 10) | (1 << 9) | (gain / 4);
 	else if ((gain >= 64) && (gain < 64 * 2))
-		val = (1<<9) | (gain / 2);
+		val = (1 << 9) | (gain / 2);
 	else
 		val = gain;
 
@@ -661,7 +659,7 @@ static int mt9m111_set_autoexposure(struct soc_camera_device *icd, int on)
 	else
 		ret = reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOEXPO_EN);
 
-	if (ret >= 0)
+	if (!ret)
 		mt9m111->autoexposure = on;
 
 	return ret;
@@ -711,7 +709,7 @@ static int mt9m111_set_control(struct soc_camera_device *icd,
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 	const struct v4l2_queryctrl *qctrl;
-	int ret = 0;
+	int ret;
 
 	qctrl = soc_camera_find_qctrl(&mt9m111_ops, ctrl->id);
 
@@ -739,7 +737,7 @@ static int mt9m111_set_control(struct soc_camera_device *icd,
 		ret = -EINVAL;
 	}
 
-	return ret < 0 ? -EIO : 0;
+	return ret;
 }
 
 int mt9m111_restore_state(struct soc_camera_device *icd)
@@ -763,10 +761,10 @@ static int mt9m111_resume(struct soc_camera_device *icd)
 
 	if (mt9m111->powered) {
 		ret = mt9m111_enable(icd);
-		if (ret >= 0)
+		if (!ret) {
 			mt9m111_reset(icd);
-		if (ret >= 0)
 			mt9m111_restore_state(icd);
+		}
 	}
 	return ret;
 }
@@ -778,15 +776,13 @@ static int mt9m111_init(struct soc_camera_device *icd)
 
 	mt9m111->context = HIGHPOWER;
 	ret = mt9m111_enable(icd);
-	if (ret >= 0)
+	if (!ret) {
 		mt9m111_reset(icd);
-	if (ret >= 0)
 		mt9m111_set_context(icd, mt9m111->context);
-	if (ret >= 0)
 		mt9m111_set_autoexposure(icd, mt9m111->autoexposure);
-	if (ret < 0)
+	} else
 		dev_err(&icd->dev, "mt9m111 init failed: %d\n", ret);
-	return ret ? -EIO : 0;
+	return ret;
 }
 
 static int mt9m111_release(struct soc_camera_device *icd)
@@ -797,7 +793,7 @@ static int mt9m111_release(struct soc_camera_device *icd)
 	if (ret < 0)
 		dev_err(&icd->dev, "mt9m111 release failed: %d\n", ret);
 
-	return ret ? -EIO : 0;
+	return ret;
 }
 
 /*

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
