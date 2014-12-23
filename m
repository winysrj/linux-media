Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60672 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635AbaLWUug (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 50/66] rtl2832_sdr: cleanups
Date: Tue, 23 Dec 2014 22:49:43 +0200
Message-Id: <1419367799-14263-50-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Small cleanups. Remove unneeded variables. Some checkpatch issues.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 46 +++++++++++++++----------------
 drivers/media/dvb-frontends/rtl2832_sdr.h | 17 ------------
 2 files changed, 23 insertions(+), 40 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 361b1eb7..62e85a3 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -22,7 +22,6 @@
  *
  */
 
-#include "dvb_frontend.h"
 #include "rtl2832_sdr.h"
 #include "dvb_usb.h"
 
@@ -114,10 +113,6 @@ struct rtl2832_sdr_dev {
 	unsigned long flags;
 
 	struct platform_device *pdev;
-	struct dvb_frontend *fe;
-	struct dvb_usb_device *d;
-	struct i2c_adapter *i2c;
-	u8 bank;
 
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
@@ -355,6 +350,7 @@ static int rtl2832_sdr_submit_urbs(struct rtl2832_sdr_dev *dev)
 static int rtl2832_sdr_free_stream_bufs(struct rtl2832_sdr_dev *dev)
 {
 	struct platform_device *pdev = dev->pdev;
+
 	if (dev->flags & USB_STATE_URB_BUF) {
 		while (dev->buf_num) {
 			dev->buf_num--;
@@ -372,6 +368,7 @@ static int rtl2832_sdr_free_stream_bufs(struct rtl2832_sdr_dev *dev)
 static int rtl2832_sdr_alloc_stream_bufs(struct rtl2832_sdr_dev *dev)
 {
 	struct platform_device *pdev = dev->pdev;
+
 	dev->buf_num = 0;
 	dev->buf_size = BULK_BUFFER_SIZE;
 
@@ -536,7 +533,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 {
 	struct platform_device *pdev = dev->pdev;
 	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
-	struct dvb_frontend *fe = dev->fe;
+	struct dvb_frontend *fe = pdata->dvb_frontend;
 	int ret;
 	unsigned int f_sr, f_if;
 	u8 buf[4], u8tmp1, u8tmp2;
@@ -801,7 +798,8 @@ err:
 static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_dev *dev)
 {
 	struct platform_device *pdev = dev->pdev;
-	struct dvb_frontend *fe = dev->fe;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
+	struct dvb_frontend *fe = pdata->dvb_frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct v4l2_ctrl *bandwidth_auto;
 	struct v4l2_ctrl *bandwidth;
@@ -843,7 +841,8 @@ static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_dev *dev)
 static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_dev *dev)
 {
 	struct platform_device *pdev = dev->pdev;
-	struct dvb_frontend *fe = dev->fe;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
+	struct dvb_frontend *fe = pdata->dvb_frontend;
 
 	dev_dbg(&pdev->dev, "\n");
 
@@ -856,7 +855,8 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_dev *dev)
 static void rtl2832_sdr_unset_tuner(struct rtl2832_sdr_dev *dev)
 {
 	struct platform_device *pdev = dev->pdev;
-	struct dvb_frontend *fe = dev->fe;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
+	struct dvb_frontend *fe = pdata->dvb_frontend;
 
 	dev_dbg(&pdev->dev, "\n");
 
@@ -870,6 +870,8 @@ static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
 	struct platform_device *pdev = dev->pdev;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
+	struct dvb_usb_device *d = pdata->dvb_usb_device;
 	int ret;
 
 	dev_dbg(&pdev->dev, "\n");
@@ -880,12 +882,12 @@ static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (mutex_lock_interruptible(&dev->v4l2_lock))
 		return -ERESTARTSYS;
 
-	if (dev->d->props->power_ctrl)
-		dev->d->props->power_ctrl(dev->d, 1);
+	if (d->props->power_ctrl)
+		d->props->power_ctrl(d, 1);
 
 	/* enable ADC */
-	if (dev->d->props->frontend_ctrl)
-		dev->d->props->frontend_ctrl(dev->fe, 1);
+	if (d->props->frontend_ctrl)
+		d->props->frontend_ctrl(pdata->dvb_frontend, 1);
 
 	set_bit(POWER_ON, &dev->flags);
 
@@ -925,6 +927,8 @@ static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
 	struct platform_device *pdev = dev->pdev;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
+	struct dvb_usb_device *d = pdata->dvb_usb_device;
 
 	dev_dbg(&pdev->dev, "\n");
 
@@ -940,11 +944,11 @@ static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 	clear_bit(POWER_ON, &dev->flags);
 
 	/* disable ADC */
-	if (dev->d->props->frontend_ctrl)
-		dev->d->props->frontend_ctrl(dev->fe, 0);
+	if (d->props->frontend_ctrl)
+		d->props->frontend_ctrl(pdata->dvb_frontend, 0);
 
-	if (dev->d->props->power_ctrl)
-		dev->d->props->power_ctrl(dev->d, 0);
+	if (d->props->power_ctrl)
+		d->props->power_ctrl(d, 0);
 
 	mutex_unlock(&dev->v4l2_lock);
 }
@@ -1230,8 +1234,9 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct rtl2832_sdr_dev *dev =
 			container_of(ctrl->handler, struct rtl2832_sdr_dev,
 					hdl);
-	struct dvb_frontend *fe = dev->fe;
 	struct platform_device *pdev = dev->pdev;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
+	struct dvb_frontend *fe = pdata->dvb_frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
@@ -1307,8 +1312,6 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 	}
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
-		dev_err(&pdev->dev,
-			"Could not allocate memory for rtl2832_sdr_dev\n");
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -1316,10 +1319,7 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 	/* setup the state */
 	subdev = pdata->v4l2_subdev;
 	dev->pdev = pdev;
-	dev->fe = pdata->dvb_frontend;
-	dev->d = pdata->dvb_usb_device;
 	dev->udev = pdata->dvb_usb_device->udev;
-	dev->i2c = pdata->i2c_client->adapter;
 	dev->f_adc = bands_adc[0].rangelow;
 	dev->f_tuner = bands_fm[0].rangelow;
 	dev->pixelformat = formats[0].pixelformat;
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.h b/drivers/media/dvb-frontends/rtl2832_sdr.h
index 5efe609..dd22e42 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.h
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.h
@@ -20,22 +20,14 @@
  * GNU Radio plugin "gr-kernel" for device usage will be on:
  * http://git.linuxtv.org/anttip/gr-kernel.git
  *
- * TODO:
- * Help is very highly welcome for these + all the others you could imagine:
- * - move controls to V4L2 API
- * - use libv4l2 for stream format conversions
- * - gr-kernel: switch to v4l2_mmap (current read eats a lot of cpu)
- * - SDRSharp support
  */
 
 #ifndef RTL2832_SDR_H
 #define RTL2832_SDR_H
 
-#include <linux/kconfig.h>
 #include <linux/i2c.h>
 #include <media/v4l2-subdev.h>
 #include "dvb_frontend.h"
-#include "rtl2832.h"
 
 struct rtl2832_sdr_platform_data {
 	/*
@@ -66,13 +58,4 @@ struct rtl2832_sdr_platform_data {
 	struct dvb_usb_device *dvb_usb_device;
 };
 
-
-static inline struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
-	struct v4l2_subdev *sd)
-{
-	dev_warn(&i2c->dev, "%s: driver disabled!\n", __func__);
-	return NULL;
-}
-
 #endif /* RTL2832_SDR_H */
-- 
http://palosaari.fi/

