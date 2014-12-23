Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34890 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630AbaLWUuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 46/66] rtl2832_sdr: convert to platform driver
Date: Tue, 23 Dec 2014 22:49:39 +0200
Message-Id: <1419367799-14263-46-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That SDR driver module was abusing DVB frontend SEC (satellite
equipment controller) device and due to that it was also using
legacy DVB binding. Platform bus is pseudo-bus provided by kernel
driver model and it fits cases like that, where any other busses
are not suitable.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 355 +++++++++++-------------------
 drivers/media/dvb-frontends/rtl2832_sdr.h |  42 +++-
 2 files changed, 156 insertions(+), 241 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 3af869c..6c5b294 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -32,6 +32,7 @@
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
 
+#include <linux/platform_device.h>
 #include <linux/jiffies.h>
 #include <linux/math64.h>
 
@@ -112,7 +113,7 @@ struct rtl2832_sdr_dev {
 #define URB_BUF            (1 << 2)
 	unsigned long flags;
 
-	const struct rtl2832_config *cfg;
+	struct platform_device *pdev;
 	struct dvb_frontend *fe;
 	struct dvb_usb_device *d;
 	struct i2c_adapter *i2c;
@@ -160,110 +161,29 @@ struct rtl2832_sdr_dev {
 	unsigned long jiffies_next;
 };
 
-/* write multiple hardware registers */
-static int rtl2832_sdr_wr(struct rtl2832_sdr_dev *dev, u8 reg, const u8 *val,
-		int len)
-{
-	int ret;
-#define MAX_WR_LEN 24
-#define MAX_WR_XFER_LEN (MAX_WR_LEN + 1)
-	u8 buf[MAX_WR_XFER_LEN];
-	struct i2c_msg msg[1] = {
-		{
-			.addr = dev->cfg->i2c_addr,
-			.flags = 0,
-			.len = 1 + len,
-			.buf = buf,
-		}
-	};
-
-	if (WARN_ON(len > MAX_WR_LEN))
-		return -EINVAL;
-
-	buf[0] = reg;
-	memcpy(&buf[1], val, len);
-
-	ret = i2c_transfer(dev->i2c, msg, 1);
-	if (ret == 1) {
-		ret = 0;
-	} else {
-		dev_err(&dev->i2c->dev,
-			"%s: I2C wr failed=%d reg=%02x len=%d\n",
-			KBUILD_MODNAME, ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
-/* read multiple hardware registers */
-static int rtl2832_sdr_rd(struct rtl2832_sdr_dev *dev, u8 reg, u8 *val, int len)
-{
-	int ret;
-	struct i2c_msg msg[2] = {
-		{
-			.addr = dev->cfg->i2c_addr,
-			.flags = 0,
-			.len = 1,
-			.buf = &reg,
-		}, {
-			.addr = dev->cfg->i2c_addr,
-			.flags = I2C_M_RD,
-			.len = len,
-			.buf = val,
-		}
-	};
-
-	ret = i2c_transfer(dev->i2c, msg, 2);
-	if (ret == 2) {
-		ret = 0;
-	} else {
-		dev_err(&dev->i2c->dev,
-				"%s: I2C rd failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
-		ret = -EREMOTEIO;
-	}
-	return ret;
-}
-
 /* write multiple registers */
 static int rtl2832_sdr_wr_regs(struct rtl2832_sdr_dev *dev, u16 reg,
 		const u8 *val, int len)
 {
-	int ret;
-	u8 reg2 = (reg >> 0) & 0xff;
-	u8 bank = (reg >> 8) & 0xff;
-
-	/* switch bank if needed */
-	if (bank != dev->bank) {
-		ret = rtl2832_sdr_wr(dev, 0x00, &bank, 1);
-		if (ret)
-			return ret;
+	struct platform_device *pdev = dev->pdev;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
+	struct i2c_client *client = pdata->i2c_client;
 
-		dev->bank = bank;
-	}
-
-	return rtl2832_sdr_wr(dev, reg2, val, len);
+	return pdata->bulk_write(client, reg, val, len);
 }
 
+#if 0
 /* read multiple registers */
 static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_dev *dev, u16 reg, u8 *val,
 		int len)
 {
-	int ret;
-	u8 reg2 = (reg >> 0) & 0xff;
-	u8 bank = (reg >> 8) & 0xff;
-
-	/* switch bank if needed */
-	if (bank != dev->bank) {
-		ret = rtl2832_sdr_wr(dev, 0x00, &bank, 1);
-		if (ret)
-			return ret;
+	struct platform_device *pdev = dev->pdev;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
+	struct i2c_client *client = pdata->i2c_client;
 
-		dev->bank = bank;
-	}
-
-	return rtl2832_sdr_rd(dev, reg2, val, len);
+	return pdata->bulk_read(client, reg, val, len);
 }
+#endif
 
 /* write single register */
 static int rtl2832_sdr_wr_reg(struct rtl2832_sdr_dev *dev, u16 reg, u8 val)
@@ -271,59 +191,16 @@ static int rtl2832_sdr_wr_reg(struct rtl2832_sdr_dev *dev, u16 reg, u8 val)
 	return rtl2832_sdr_wr_regs(dev, reg, &val, 1);
 }
 
-#if 0
-/* read single register */
-static int rtl2832_sdr_rd_reg(struct rtl2832_sdr_dev *dev, u16 reg, u8 *val)
-{
-	return rtl2832_sdr_rd_regs(dev, reg, val, 1);
-}
-#endif
-
 /* write single register with mask */
 static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_dev *dev, u16 reg,
 		u8 val, u8 mask)
 {
-	int ret;
-	u8 tmp;
-
-	/* no need for read if whole reg is written */
-	if (mask != 0xff) {
-		ret = rtl2832_sdr_rd_regs(dev, reg, &tmp, 1);
-		if (ret)
-			return ret;
-
-		val &= mask;
-		tmp &= ~mask;
-		val |= tmp;
-	}
-
-	return rtl2832_sdr_wr_regs(dev, reg, &val, 1);
-}
-
-#if 0
-/* read single register with mask */
-static int rtl2832_sdr_rd_reg_mask(struct rtl2832_sdr_dev *dev, u16 reg,
-		u8 *val, u8 mask)
-{
-	int ret, i;
-	u8 tmp;
-
-	ret = rtl2832_sdr_rd_regs(dev, reg, &tmp, 1);
-	if (ret)
-		return ret;
-
-	tmp &= mask;
-
-	/* find position of the first bit */
-	for (i = 0; i < 8; i++) {
-		if ((mask >> i) & 0x01)
-			break;
-	}
-	*val = tmp >> i;
+	struct platform_device *pdev = dev->pdev;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
+	struct i2c_client *client = pdata->i2c_client;
 
-	return 0;
+	return pdata->update_bits(client, reg, mask, val);
 }
-#endif
 
 /* Private functions */
 static struct rtl2832_sdr_frame_buf *rtl2832_sdr_get_next_fill_buf(
@@ -584,28 +461,6 @@ static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_dev *dev)
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
 
-/* The user yanked out the cable... */
-static void rtl2832_sdr_release_sec(struct dvb_frontend *fe)
-{
-	struct rtl2832_sdr_dev *dev = fe->sec_priv;
-
-	dev_dbg(&dev->udev->dev, "\n");
-
-	mutex_lock(&dev->vb_queue_lock);
-	mutex_lock(&dev->v4l2_lock);
-	/* No need to keep the urbs around after disconnection */
-	dev->udev = NULL;
-
-	v4l2_device_disconnect(&dev->v4l2_dev);
-	video_unregister_device(&dev->vdev);
-	mutex_unlock(&dev->v4l2_lock);
-	mutex_unlock(&dev->vb_queue_lock);
-
-	v4l2_device_put(&dev->v4l2_dev);
-
-	fe->sec_priv = NULL;
-}
-
 static int rtl2832_sdr_querycap(struct file *file, void *fh,
 		struct v4l2_capability *cap)
 {
@@ -672,6 +527,8 @@ static void rtl2832_sdr_buf_queue(struct vb2_buffer *vb)
 
 static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
 	struct dvb_frontend *fe = dev->fe;
 	int ret;
 	unsigned int f_sr, f_if;
@@ -707,9 +564,9 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 		goto err;
 
 	/* program IF */
-	u64tmp = f_if % dev->cfg->xtal;
+	u64tmp = f_if % pdata->clk;
 	u64tmp *= 0x400000;
-	u64tmp = div_u64(u64tmp, dev->cfg->xtal);
+	u64tmp = div_u64(u64tmp, pdata->clk);
 	u64tmp = -u64tmp;
 	u32tmp = u64tmp & 0x3fffff;
 
@@ -746,7 +603,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 		goto err;
 
 	/* program sampling rate (resampling down) */
-	u32tmp = div_u64(dev->cfg->xtal * 0x400000ULL, f_sr * 4U);
+	u32tmp = div_u64(pdata->clk * 0x400000ULL, f_sr * 4U);
 	u32tmp <<= 2;
 	buf[0] = (u32tmp >> 24) & 0xff;
 	buf[1] = (u32tmp >> 16) & 0xff;
@@ -787,8 +644,8 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 		goto err;
 
 	/* used RF tuner based settings */
-	switch (dev->cfg->tuner) {
-	case RTL2832_TUNER_E4000:
+	switch (pdata->tuner) {
+	case RTL2832_SDR_TUNER_E4000:
 		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x5a", 1);
 		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
 		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x5a", 1);
@@ -824,8 +681,8 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 		ret = rtl2832_sdr_wr_regs(dev, 0x00d, "\x85", 1);
 		ret = rtl2832_sdr_wr_regs(dev, 0x013, "\x02", 1);
 		break;
-	case RTL2832_TUNER_FC0012:
-	case RTL2832_TUNER_FC0013:
+	case RTL2832_SDR_TUNER_FC0012:
+	case RTL2832_SDR_TUNER_FC0013:
 		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x5a", 1);
 		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
 		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x5a", 1);
@@ -856,7 +713,8 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 		ret = rtl2832_sdr_wr_regs(dev, 0x1e6, "\x02", 1);
 		ret = rtl2832_sdr_wr_regs(dev, 0x1d7, "\x09", 1);
 		break;
-	case RTL2832_TUNER_R820T:
+	case RTL2832_SDR_TUNER_R820T:
+	case RTL2832_SDR_TUNER_R828D:
 		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x5a", 1);
 		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
 		ret = rtl2832_sdr_wr_regs(dev, 0x115, "\x01", 1);
@@ -1401,34 +1259,46 @@ static void rtl2832_sdr_video_release(struct v4l2_device *v)
 {
 	struct rtl2832_sdr_dev *dev =
 			container_of(v, struct rtl2832_sdr_dev, v4l2_dev);
+	struct platform_device *pdev = dev->pdev;
+
+	dev_dbg(&pdev->dev, "\n");
 
 	v4l2_ctrl_handler_free(&dev->hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
 }
 
-struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
-		struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
-		struct v4l2_subdev *sd)
+/* Platform driver interface */
+static int rtl2832_sdr_probe(struct platform_device *pdev)
 {
-	int ret;
 	struct rtl2832_sdr_dev *dev;
+	struct rtl2832_sdr_platform_data *pdata = pdev->dev.platform_data;
 	const struct v4l2_ctrl_ops *ops = &rtl2832_sdr_ctrl_ops;
-	struct dvb_usb_device *d = i2c_get_adapdata(i2c);
+	struct v4l2_subdev *subdev;
+	int ret;
 
-	dev = kzalloc(sizeof(struct rtl2832_sdr_dev), GFP_KERNEL);
+	dev_dbg(&pdev->dev, "\n");
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "Cannot proceed without platform data\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
-		dev_err(&d->udev->dev,
-				"Could not allocate memory for rtl2832_sdr_dev\n");
-		return NULL;
+		dev_err(&pdev->dev,
+			"Could not allocate memory for rtl2832_sdr_dev\n");
+		ret = -ENOMEM;
+		goto err;
 	}
 
 	/* setup the state */
-	dev->fe = fe;
-	dev->d = d;
-	dev->udev = d->udev;
-	dev->i2c = i2c;
-	dev->cfg = cfg;
+	subdev = pdata->v4l2_subdev;
+	dev->pdev = pdev;
+	dev->fe = pdata->dvb_frontend;
+	dev->d = pdata->dvb_usb_device;
+	dev->udev = pdata->dvb_usb_device->udev;
+	dev->i2c = pdata->i2c_client->adapter;
 	dev->f_adc = bands_adc[0].rangelow;
 	dev->f_tuner = bands_fm[0].rangelow;
 	dev->pixelformat = formats[0].pixelformat;
@@ -1452,50 +1322,49 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	dev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	ret = vb2_queue_init(&dev->vb_queue);
 	if (ret) {
-		dev_err(&dev->udev->dev, "Could not initialize vb2 queue\n");
-		goto err_free_mem;
+		dev_err(&pdev->dev, "Could not initialize vb2 queue\n");
+		goto err_kfree;
 	}
 
 	/* Register controls */
-	switch (dev->cfg->tuner) {
-	case RTL2832_TUNER_E4000:
+	switch (pdata->tuner) {
+	case RTL2832_SDR_TUNER_E4000:
 		v4l2_ctrl_handler_init(&dev->hdl, 9);
-		if (sd)
-			v4l2_ctrl_add_handler(&dev->hdl, sd->ctrl_handler, NULL);
+		if (subdev)
+			v4l2_ctrl_add_handler(&dev->hdl, subdev->ctrl_handler, NULL);
 		break;
-	case RTL2832_TUNER_R820T:
+	case RTL2832_SDR_TUNER_R820T:
+	case RTL2832_SDR_TUNER_R828D:
 		v4l2_ctrl_handler_init(&dev->hdl, 2);
 		dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, ops,
-						      V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
-						      0, 1, 1, 1);
+							V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
+							0, 1, 1, 1);
 		dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, ops,
-						 V4L2_CID_RF_TUNER_BANDWIDTH,
-						 0, 8000000, 100000, 0);
+						   V4L2_CID_RF_TUNER_BANDWIDTH,
+						   0, 8000000, 100000, 0);
 		v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
 		break;
-	case RTL2832_TUNER_FC0012:
-	case RTL2832_TUNER_FC0013:
+	case RTL2832_SDR_TUNER_FC0012:
+	case RTL2832_SDR_TUNER_FC0013:
 		v4l2_ctrl_handler_init(&dev->hdl, 2);
 		dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, ops,
-						      V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
-						      0, 1, 1, 1);
+							V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
+							0, 1, 1, 1);
 		dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, ops,
-						 V4L2_CID_RF_TUNER_BANDWIDTH,
-						 6000000, 8000000, 1000000,
-						 6000000);
+						   V4L2_CID_RF_TUNER_BANDWIDTH,
+						   6000000, 8000000, 1000000,
+						   6000000);
 		v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
 		break;
 	default:
 		v4l2_ctrl_handler_init(&dev->hdl, 0);
-		dev_notice(&dev->udev->dev, "%s: Unsupported tuner\n",
-				KBUILD_MODNAME);
-		goto err_free_controls;
+		dev_err(&pdev->dev, "Unsupported tuner\n");
+		goto err_v4l2_ctrl_handler_free;
 	}
-
 	if (dev->hdl.error) {
 		ret = dev->hdl.error;
-		dev_err(&dev->udev->dev, "Could not initialize controls\n");
-		goto err_free_controls;
+		dev_err(&pdev->dev, "Could not initialize controls\n");
+		goto err_v4l2_ctrl_handler_free;
 	}
 
 	/* Init video_device structure */
@@ -1508,9 +1377,8 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	dev->v4l2_dev.release = rtl2832_sdr_video_release;
 	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
 	if (ret) {
-		dev_err(&dev->udev->dev,
-				"Failed to register v4l2-device (%d)\n", ret);
-		goto err_free_controls;
+		dev_err(&pdev->dev, "Failed to register v4l2-device %d\n", ret);
+		goto err_v4l2_ctrl_handler_free;
 	}
 
 	dev->v4l2_dev.ctrl_handler = &dev->hdl;
@@ -1520,33 +1388,56 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 
 	ret = video_register_device(&dev->vdev, VFL_TYPE_SDR, -1);
 	if (ret) {
-		dev_err(&dev->udev->dev,
-				"Failed to register as video device (%d)\n",
-				ret);
-		goto err_unregister_v4l2_dev;
+		dev_err(&pdev->dev, "Failed to register as video device %d\n",
+			ret);
+		goto err_v4l2_device_unregister;
 	}
-	dev_info(&dev->udev->dev, "Registered as %s\n",
-			video_device_node_name(&dev->vdev));
-
-	fe->sec_priv = dev;
-	fe->ops.release_sec = rtl2832_sdr_release_sec;
-
-	dev_info(&dev->i2c->dev, "%s: Realtek RTL2832 SDR attached\n",
-			KBUILD_MODNAME);
-	dev_notice(&dev->udev->dev,
-			"%s: SDR API is still slightly experimental and functionality changes may follow\n",
-			KBUILD_MODNAME);
-	return fe;
-
-err_unregister_v4l2_dev:
+	dev_info(&pdev->dev, "Registered as %s\n",
+		 video_device_node_name(&dev->vdev));
+	dev_info(&pdev->dev, "Realtek RTL2832 SDR attached\n");
+	dev_notice(&pdev->dev,
+		   "SDR API is still slightly experimental and functionality changes may follow\n");
+	platform_set_drvdata(pdev, dev);
+	return 0;
+err_v4l2_device_unregister:
 	v4l2_device_unregister(&dev->v4l2_dev);
-err_free_controls:
+err_v4l2_ctrl_handler_free:
 	v4l2_ctrl_handler_free(&dev->hdl);
-err_free_mem:
+err_kfree:
 	kfree(dev);
-	return NULL;
+err:
+	return ret;
 }
-EXPORT_SYMBOL(rtl2832_sdr_attach);
+
+static int rtl2832_sdr_remove(struct platform_device *pdev)
+{
+	struct rtl2832_sdr_dev *dev = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "\n");
+
+	mutex_lock(&dev->vb_queue_lock);
+	mutex_lock(&dev->v4l2_lock);
+	/* No need to keep the urbs around after disconnection */
+	dev->udev = NULL;
+	v4l2_device_disconnect(&dev->v4l2_dev);
+	video_unregister_device(&dev->vdev);
+	mutex_unlock(&dev->v4l2_lock);
+	mutex_unlock(&dev->vb_queue_lock);
+
+	v4l2_device_put(&dev->v4l2_dev);
+
+	return 0;
+}
+
+static struct platform_driver rtl2832_sdr_driver = {
+	.driver = {
+		.name   = "rtl2832_sdr",
+		.owner  = THIS_MODULE,
+	},
+	.probe          = rtl2832_sdr_probe,
+	.remove         = rtl2832_sdr_remove,
+};
+module_platform_driver(rtl2832_sdr_driver);
 
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Realtek RTL2832 SDR driver");
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.h b/drivers/media/dvb-frontends/rtl2832_sdr.h
index b865fad..5efe609 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.h
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.h
@@ -32,23 +32,47 @@
 #define RTL2832_SDR_H
 
 #include <linux/kconfig.h>
+#include <linux/i2c.h>
 #include <media/v4l2-subdev.h>
-
-/* for config struct */
+#include "dvb_frontend.h"
 #include "rtl2832.h"
 
-#if IS_ENABLED(CONFIG_DVB_RTL2832_SDR)
-extern struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
-	struct v4l2_subdev *sd);
-#else
+struct rtl2832_sdr_platform_data {
+	/*
+	 * Clock frequency.
+	 * Hz
+	 * 4000000, 16000000, 25000000, 28800000
+	 */
+	u32 clk;
+
+	/*
+	 * Tuner.
+	 * XXX: This list must be kept sync with dvb_usb_rtl28xxu USB IF driver.
+	 */
+#define RTL2832_SDR_TUNER_TUA9001   0x24
+#define RTL2832_SDR_TUNER_FC0012    0x26
+#define RTL2832_SDR_TUNER_E4000     0x27
+#define RTL2832_SDR_TUNER_FC0013    0x29
+#define RTL2832_SDR_TUNER_R820T     0x2a
+#define RTL2832_SDR_TUNER_R828D     0x2b
+	u8 tuner;
+
+	struct i2c_client *i2c_client;
+	int (*bulk_read)(struct i2c_client *, unsigned int, void *, size_t);
+	int (*bulk_write)(struct i2c_client *, unsigned int, const void *, size_t);
+	int (*update_bits)(struct i2c_client *, unsigned int, unsigned int, unsigned int);
+	struct dvb_frontend *dvb_frontend;
+	struct v4l2_subdev *v4l2_subdev;
+	struct dvb_usb_device *dvb_usb_device;
+};
+
+
 static inline struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
 	struct v4l2_subdev *sd)
 {
-	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
+	dev_warn(&i2c->dev, "%s: driver disabled!\n", __func__);
 	return NULL;
 }
-#endif
 
 #endif /* RTL2832_SDR_H */
-- 
http://palosaari.fi/

