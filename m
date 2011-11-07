Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab1KGQRZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 11:17:25 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 9454A189F95
	for <linux-media@vger.kernel.org>; Mon,  7 Nov 2011 17:17:23 +0100 (CET)
Date: Mon, 7 Nov 2011 17:17:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [KS workshop follow-up] multiple sensor contexts
Message-ID: <Pine.LNX.4.64.1111071645180.26363@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

At the V4L/DVB workshop in Prague a couple of weeks ago possible merits of 
supporting multiple camera sensor contexts have been discussed. Such 
contexts are often promoted by camera manufacturers as a hardware 
optimization to support fast switching to the snapshot mode. Such a switch 
is often accompanied by a change of the frame format. Typically, a smaller 
frame is used for the preview mode and a larger frame is used for photo 
shooting. Those sensors provide 2 (or more) sets of frame size and data 
format registers and a single command to switch between them. The 
decision, whether or not to support these multiple camera contexts has 
been postponed until some measurements become available, how much time 
such a "fast switching" implementation would save us.

I took the mt9m111 driver, that supports mt9m111, mt9m131, and mt9m112 
camera sensors from Aptina. They do indeed implement two contexts, 
however, the driver first had to be somewhat reorganised to make use of 
them. I pushed my (highly!) experimental tree to

git://linuxtv.org/gliakhovetski/v4l-dvb.git staging-3.3

with the addition of the below debugging diff, that pre-programs a fixed 
format into the second context registers and switches to it, once a 
matching S_FMT is called. On the i.MX31 based pcm037 board, that I've got, 
this sensor is attached to the I2C bus #2, running at 20kHz. The explicit 
programming of the new format parameters measures to take around 27ms, 
which is also about what we win, when using the second context.

As for interpretation: firstly 20kHz is not much, I expect many other set 
ups to run much faster. But even if we accept, that on some hardware > 
20kHz doesn't work and we really lose 27ms when not using multiple 
register contexts, is it a lot? Thinking about my personal photographing 
experiences with cameras and camera-phones, I don't think, I'd notice a 
27ms latency;-) I don't think anything below 200ms really makes a 
difference and, I think, the major contributor to the snapshot latency is 
the need to synchronise on a frame, and, possibly skip or shoot several 
frames, instead of just one.

So, my conclusion would be: when working with "sane" camera sensors, i.e., 
those, where you don't have to reprogram 100s of registers from some magic 
tables to configure a different frame format (;-)), supporting several 
register contexts doesn't bring a huge advantage in terms of snapshot 
latency. OTOH, it can well happen, that at some point we anyway will have 
to support those multiple register contexts for some other reason.

Opinions?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 45739a1..23ffcd9 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -13,6 +13,7 @@
 #include <linux/log2.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
+#include <linux/time.h>
 #include <linux/v4l2-mediabus.h>
 
 #include <media/soc_camera.h>
@@ -309,11 +310,10 @@ static int mt9m111_reg_mask(struct i2c_client *client, const u16 reg,
 	return ret;
 }
 
-static int mt9m111_set_context(struct mt9m111 *mt9m111,
-			       struct mt9m111_context *ctx)
+static int mt9m111_set_context(struct mt9m111 *mt9m111)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	return reg_write(CONTEXT_CONTROL, ctx->control);
+	return reg_write(CONTEXT_CONTROL, mt9m111->ctx->control);
 }
 
 static int mt9m111_setup_rect_ctx(struct mt9m111 *mt9m111,
@@ -349,10 +349,7 @@ static int mt9m111_setup_geometry(struct mt9m111 *mt9m111, struct v4l2_rect *rec
 	if (code != V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
 		/* IFP in use, down-scaling possible */
 		if (!ret)
-			ret = mt9m111_setup_rect_ctx(mt9m111, &context_b,
-						     rect, width, height);
-		if (!ret)
-			ret = mt9m111_setup_rect_ctx(mt9m111, &context_a,
+			ret = mt9m111_setup_rect_ctx(mt9m111, mt9m111->ctx,
 						     rect, width, height);
 	}
 
@@ -523,11 +520,8 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
 		return -EINVAL;
 	}
 
-	ret = mt9m111_reg_mask(client, context_a.output_fmt_ctrl2,
+	ret = mt9m111_reg_mask(client, mt9m111->ctx->output_fmt_ctrl2,
 			       data_outfmt2, mask_outfmt2);
-	if (!ret)
-		ret = mt9m111_reg_mask(client, context_b.output_fmt_ctrl2,
-				       data_outfmt2, mask_outfmt2);
 
 	return ret;
 }
@@ -576,27 +570,53 @@ static int mt9m111_try_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+#define SNAPSHOT_WIDTH 640
+#define SNAPSHOT_HEIGHT 480
+#define SNAPSHOT_CODE V4L2_MBUS_FMT_SBGGR8_1X8
+
 static int mt9m111_s_fmt(struct v4l2_subdev *sd,
 			 struct v4l2_mbus_framefmt *mf)
 {
 	const struct mt9m111_datafmt *fmt;
 	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	struct v4l2_rect *rect = &mt9m111->rect;
+	struct timespec ts_1, ts_2;
 	int ret;
 
+	/* FIXME: testing only: an arbitrary policy: != VGA use context A */
+	if (mf->width != SNAPSHOT_WIDTH || mf->height != SNAPSHOT_HEIGHT ||
+	    mf->code != SNAPSHOT_CODE)
+		mt9m111->ctx = &context_a;
+	else
+		mt9m111->ctx = &context_b;
+
 	mt9m111_try_fmt(sd, mf);
 	fmt = mt9m111_find_datafmt(mt9m111, mf->code);
 	/* try_fmt() guarantees fmt != NULL && fmt->code == mf->code */
 
-	ret = mt9m111_setup_geometry(mt9m111, rect, mf->width, mf->height, mf->code);
-	if (!ret)
-		ret = mt9m111_set_pixfmt(mt9m111, mf->code);
+	ret = mt9m111_set_context(mt9m111);
+	ktime_get_ts(&ts_1);
+	if (!mt9m111->power_count || mt9m111->ctx == &context_a) {
+		if (!ret)
+			ret = mt9m111_setup_geometry(mt9m111, rect,
+					mf->width, mf->height, mf->code);
+		if (!ret)
+			ret = mt9m111_set_pixfmt(mt9m111, mf->code);
+	}
+	ktime_get_ts(&ts_2);
 	if (!ret) {
 		mt9m111->width	= mf->width;
 		mt9m111->height	= mf->height;
 		mt9m111->fmt	= fmt;
 	}
 
+	if (ts_2.tv_nsec < ts_1.tv_nsec) {
+		ts_2.tv_nsec += 1000000000;
+		ts_2.tv_sec -= 1;
+	}
+
+	pr_info("Context switch took %lu.%09lus\n", ts_2.tv_sec - ts_1.tv_sec, ts_2.tv_nsec - ts_1.tv_nsec);
+
 	return ret;
 }
 
@@ -762,7 +782,7 @@ static int mt9m111_suspend(struct mt9m111 *mt9m111)
 
 static void mt9m111_restore_state(struct mt9m111 *mt9m111)
 {
-	mt9m111_set_context(mt9m111, mt9m111->ctx);
+	mt9m111_set_context(mt9m111);
 	mt9m111_set_pixfmt(mt9m111, mt9m111->fmt->code);
 	mt9m111_setup_geometry(mt9m111, &mt9m111->rect,
 			mt9m111->width, mt9m111->height, mt9m111->fmt->code);
@@ -780,23 +800,6 @@ static int mt9m111_resume(struct mt9m111 *mt9m111)
 	return ret;
 }
 
-static int mt9m111_init(struct mt9m111 *mt9m111)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
-	int ret;
-
-	/* Default HIGHPOWER context */
-	mt9m111->ctx = &context_b;
-	ret = mt9m111_enable(mt9m111);
-	if (!ret)
-		ret = mt9m111_reset(mt9m111);
-	if (!ret)
-		ret = mt9m111_set_context(mt9m111, mt9m111->ctx);
-	if (ret)
-		dev_err(&client->dev, "mt9m111 init failed: %d\n", ret);
-	return ret;
-}
-
 /*
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
@@ -805,7 +808,6 @@ static int mt9m111_video_probe(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	s32 data;
-	int ret;
 
 	data = reg_read(CHIP_VERSION);
 
@@ -826,9 +828,8 @@ static int mt9m111_video_probe(struct i2c_client *client)
 		return -ENODEV;
 	}
 
-	ret = mt9m111_init(mt9m111);
-	if (ret)
-		return ret;
+	mt9m111->ctx = &context_b;
+
 	return v4l2_ctrl_handler_setup(&mt9m111->hdl);
 }
 
@@ -836,33 +837,45 @@ static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&mt9m111->power_lock);
 
-	/*
-	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
-	 * update the power state.
-	 */
-	if (mt9m111->power_count == !on) {
-		if (on) {
+	if (on) {
+		if (!mt9m111->power_count) {
+			struct v4l2_mbus_framefmt mf_snapshot = {
+				.width	= SNAPSHOT_WIDTH,
+				.height	= SNAPSHOT_HEIGHT,
+				.code	= SNAPSHOT_CODE,
+			};
+
+			/* Pre-program a fixed snapshot format */
+			mt9m111_s_fmt(&mt9m111->subdev, &mf_snapshot);
+
+			/* Default preview context */
+			mt9m111->ctx = &context_a;
+
 			ret = mt9m111_resume(mt9m111);
-			if (ret) {
+			if (ret < 0)
 				dev_err(&client->dev,
 					"Failed to resume the sensor: %d\n", ret);
-				goto out;
-			}
 		} else {
-			mt9m111_suspend(mt9m111);
+			ret = 0;
 		}
+		if (!ret)
+			mt9m111->power_count++;
+	} else {
+		if (WARN_ON(!mt9m111->power_count)) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ret = mt9m111_suspend(mt9m111);
+		mt9m111->power_count--;
 	}
 
-	/* Update the power count. */
-	mt9m111->power_count += on ? 1 : -1;
-	WARN_ON(mt9m111->power_count < 0);
-
 out:
 	mutex_unlock(&mt9m111->power_lock);
+
 	return ret;
 }
 
