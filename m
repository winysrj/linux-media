Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48680 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbbFFMDW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 08:03:22 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 7/9] hackrf: switch to single function which configures everything
Date: Sat,  6 Jun 2015 15:03:06 +0300
Message-Id: <1433592188-31748-7-git-send-email-crope@iki.fi>
In-Reply-To: <1433592188-31748-1-git-send-email-crope@iki.fi>
References: <1433592188-31748-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement single funtion, hackrf_set_params(), which handles all
needed settings. Controls and other IOCTLs are just wrappers to that
function. That way we can get easily better control what we could do
on different device states - sleeping, receiving, transmitting.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/hackrf/hackrf.c | 323 +++++++++++++++++++++-----------------
 1 file changed, 175 insertions(+), 148 deletions(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 136de9a..5bd291b 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -91,11 +91,17 @@ struct hackrf_frame_buf {
 };
 
 struct hackrf_dev {
-#define POWER_ON           (1 << 1)
-#define URB_BUF            (1 << 2)
-#define USB_STATE_URB_BUF  (1 << 3)
+#define POWER_ON                         1
+#define USB_STATE_URB_BUF                2 /* XXX: set manually */
+#define SAMPLE_RATE_SET                 10
+#define RX_BANDWIDTH                    11
+#define RX_RF_FREQUENCY                 12
+#define RX_RF_GAIN                      13
+#define RX_LNA_GAIN                     14
+#define RX_IF_GAIN                      15
 	unsigned long flags;
 
+	struct usb_interface *intf;
 	struct device *dev;
 	struct usb_device *udev;
 	struct video_device vdev;
@@ -208,6 +214,140 @@ err:
 	return ret;
 }
 
+static int hackrf_set_params(struct hackrf_dev *dev)
+{
+	struct usb_interface *intf = dev->intf;
+	int ret, i;
+	u8 buf[8], u8tmp;
+	unsigned int uitmp, uitmp1, uitmp2;
+
+	if (!test_bit(POWER_ON, &dev->flags)) {
+		dev_dbg(&intf->dev, "device is sleeping\n");
+		return 0;
+	}
+
+	if (test_and_clear_bit(SAMPLE_RATE_SET, &dev->flags)) {
+		dev_dbg(&intf->dev, "ADC frequency=%u Hz\n", dev->f_adc);
+		uitmp1 = dev->f_adc;
+		uitmp2 = 1;
+		buf[0] = (uitmp1 >>  0) & 0xff;
+		buf[1] = (uitmp1 >>  8) & 0xff;
+		buf[2] = (uitmp1 >> 16) & 0xff;
+		buf[3] = (uitmp1 >> 24) & 0xff;
+		buf[4] = (uitmp2 >>  0) & 0xff;
+		buf[5] = (uitmp2 >>  8) & 0xff;
+		buf[6] = (uitmp2 >> 16) & 0xff;
+		buf[7] = (uitmp2 >> 24) & 0xff;
+		ret = hackrf_ctrl_msg(dev, CMD_SAMPLE_RATE_SET, 0, 0, buf, 8);
+		if (ret)
+			goto err;
+	}
+
+	if (test_and_clear_bit(RX_BANDWIDTH, &dev->flags)) {
+		static const struct {
+			u32 freq;
+		} bandwidth_lut[] = {
+			{ 1750000}, /*  1.75 MHz */
+			{ 2500000}, /*  2.5  MHz */
+			{ 3500000}, /*  3.5  MHz */
+			{ 5000000}, /*  5    MHz */
+			{ 5500000}, /*  5.5  MHz */
+			{ 6000000}, /*  6    MHz */
+			{ 7000000}, /*  7    MHz */
+			{ 8000000}, /*  8    MHz */
+			{ 9000000}, /*  9    MHz */
+			{10000000}, /* 10    MHz */
+			{12000000}, /* 12    MHz */
+			{14000000}, /* 14    MHz */
+			{15000000}, /* 15    MHz */
+			{20000000}, /* 20    MHz */
+			{24000000}, /* 24    MHz */
+			{28000000}, /* 28    MHz */
+		};
+
+		if (dev->bandwidth_auto->val == true)
+			uitmp = dev->f_adc;
+		else
+			uitmp = dev->bandwidth->val;
+
+		for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
+			if (uitmp <= bandwidth_lut[i].freq) {
+				uitmp = bandwidth_lut[i].freq;
+				break;
+			}
+		}
+
+		dev->bandwidth->val = uitmp;
+		dev->bandwidth->cur.val = uitmp;
+
+		dev_dbg(&intf->dev, "bandwidth selected=%u\n", uitmp);
+
+		uitmp1 = 0;
+		uitmp1 |= ((uitmp >> 0) & 0xff) << 0;
+		uitmp1 |= ((uitmp >> 8) & 0xff) << 8;
+		uitmp2 = 0;
+		uitmp2 |= ((uitmp >> 16) & 0xff) << 0;
+		uitmp2 |= ((uitmp >> 24) & 0xff) << 8;
+
+		ret = hackrf_ctrl_msg(dev, CMD_BASEBAND_FILTER_BANDWIDTH_SET,
+				      uitmp1, uitmp2, NULL, 0);
+		if (ret)
+			goto err;
+	}
+
+	if (test_and_clear_bit(RX_RF_FREQUENCY, &dev->flags)) {
+		dev_dbg(&intf->dev, "RF frequency=%u Hz\n", dev->f_rf);
+		uitmp1 = dev->f_rf / 1000000;
+		uitmp2 = dev->f_rf % 1000000;
+		buf[0] = (uitmp1 >>  0) & 0xff;
+		buf[1] = (uitmp1 >>  8) & 0xff;
+		buf[2] = (uitmp1 >> 16) & 0xff;
+		buf[3] = (uitmp1 >> 24) & 0xff;
+		buf[4] = (uitmp2 >>  0) & 0xff;
+		buf[5] = (uitmp2 >>  8) & 0xff;
+		buf[6] = (uitmp2 >> 16) & 0xff;
+		buf[7] = (uitmp2 >> 24) & 0xff;
+		ret = hackrf_ctrl_msg(dev, CMD_SET_FREQ, 0, 0, buf, 8);
+		if (ret)
+			goto err;
+	}
+
+	if (test_and_clear_bit(RX_RF_GAIN, &dev->flags)) {
+		dev_dbg(&intf->dev, "RF gain val=%d->%d\n",
+			dev->rf_gain->cur.val, dev->rf_gain->val);
+
+		u8tmp = (dev->rf_gain->val) ? 1 : 0;
+		ret = hackrf_ctrl_msg(dev, CMD_AMP_ENABLE, u8tmp, 0, NULL, 0);
+		if (ret)
+			goto err;
+	}
+
+	if (test_and_clear_bit(RX_LNA_GAIN, &dev->flags)) {
+		dev_dbg(dev->dev, "LNA gain val=%d->%d\n",
+			dev->lna_gain->cur.val, dev->lna_gain->val);
+
+		ret = hackrf_ctrl_msg(dev, CMD_SET_LNA_GAIN, 0,
+				      dev->lna_gain->val, &u8tmp, 1);
+		if (ret)
+			goto err;
+	}
+
+	if (test_and_clear_bit(RX_IF_GAIN, &dev->flags)) {
+		dev_dbg(&intf->dev, "IF gain val=%d->%d\n",
+			dev->if_gain->cur.val, dev->if_gain->val);
+
+		ret = hackrf_ctrl_msg(dev, CMD_SET_VGA_GAIN, 0,
+				      dev->if_gain->val, &u8tmp, 1);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
+	return ret;
+}
+
 /* Private functions */
 static struct hackrf_frame_buf *hackrf_get_next_fill_buf(struct hackrf_dev *dev)
 {
@@ -524,6 +664,10 @@ static int hackrf_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret)
 		goto err;
 
+	ret = hackrf_set_params(dev);
+	if (ret)
+		goto err;
+
 	/* start hardware streaming */
 	ret = hackrf_ctrl_msg(dev, CMD_SET_TRANSCEIVER_MODE, 1, 0, NULL, 0);
 	if (ret)
@@ -735,47 +879,32 @@ static int hackrf_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
 	struct hackrf_dev *dev = video_drvdata(file);
+	struct usb_interface *intf = dev->intf;
 	int ret;
-	unsigned int upper, lower;
-	u8 buf[8];
 
-	dev_dbg(dev->dev, "tuner=%d type=%d frequency=%u\n",
+	dev_dbg(&intf->dev, "tuner=%d type=%d frequency=%u\n",
 			f->tuner, f->type, f->frequency);
 
 	if (f->tuner == 0) {
 		dev->f_adc = clamp_t(unsigned int, f->frequency,
 				bands_adc[0].rangelow, bands_adc[0].rangehigh);
-		dev_dbg(dev->dev, "ADC frequency=%u Hz\n", dev->f_adc);
-		upper = dev->f_adc;
-		lower = 1;
-		buf[0] = (upper >>  0) & 0xff;
-		buf[1] = (upper >>  8) & 0xff;
-		buf[2] = (upper >> 16) & 0xff;
-		buf[3] = (upper >> 24) & 0xff;
-		buf[4] = (lower >>  0) & 0xff;
-		buf[5] = (lower >>  8) & 0xff;
-		buf[6] = (lower >> 16) & 0xff;
-		buf[7] = (lower >> 24) & 0xff;
-		ret = hackrf_ctrl_msg(dev, CMD_SAMPLE_RATE_SET, 0, 0, buf, 8);
+		set_bit(SAMPLE_RATE_SET, &dev->flags);
 	} else if (f->tuner == 1) {
 		dev->f_rf = clamp_t(unsigned int, f->frequency,
 				bands_rf[0].rangelow, bands_rf[0].rangehigh);
-		dev_dbg(dev->dev, "RF frequency=%u Hz\n", dev->f_rf);
-		upper = dev->f_rf / 1000000;
-		lower = dev->f_rf % 1000000;
-		buf[0] = (upper >>  0) & 0xff;
-		buf[1] = (upper >>  8) & 0xff;
-		buf[2] = (upper >> 16) & 0xff;
-		buf[3] = (upper >> 24) & 0xff;
-		buf[4] = (lower >>  0) & 0xff;
-		buf[5] = (lower >>  8) & 0xff;
-		buf[6] = (lower >> 16) & 0xff;
-		buf[7] = (lower >> 24) & 0xff;
-		ret = hackrf_ctrl_msg(dev, CMD_SET_FREQ, 0, 0, buf, 8);
+		set_bit(RX_RF_FREQUENCY, &dev->flags);
 	} else {
 		ret = -EINVAL;
+		goto err;
 	}
 
+	ret = hackrf_set_params(dev);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -888,144 +1017,41 @@ static void hackrf_video_release(struct v4l2_device *v)
 	kfree(dev);
 }
 
-static int hackrf_set_bandwidth(struct hackrf_dev *dev)
-{
-	int ret, i;
-	u16 u16tmp, u16tmp2;
-	unsigned int bandwidth;
-
-	static const struct {
-		u32 freq;
-	} bandwidth_lut[] = {
-		{ 1750000}, /*  1.75 MHz */
-		{ 2500000}, /*  2.5  MHz */
-		{ 3500000}, /*  3.5  MHz */
-		{ 5000000}, /*  5    MHz */
-		{ 5500000}, /*  5.5  MHz */
-		{ 6000000}, /*  6    MHz */
-		{ 7000000}, /*  7    MHz */
-		{ 8000000}, /*  8    MHz */
-		{ 9000000}, /*  9    MHz */
-		{10000000}, /* 10    MHz */
-		{12000000}, /* 12    MHz */
-		{14000000}, /* 14    MHz */
-		{15000000}, /* 15    MHz */
-		{20000000}, /* 20    MHz */
-		{24000000}, /* 24    MHz */
-		{28000000}, /* 28    MHz */
-	};
-
-	dev_dbg(dev->dev, "bandwidth auto=%d->%d val=%d->%d f_adc=%u\n",
-			dev->bandwidth_auto->cur.val,
-			dev->bandwidth_auto->val, dev->bandwidth->cur.val,
-			dev->bandwidth->val, dev->f_adc);
-
-	if (dev->bandwidth_auto->val == true)
-		bandwidth = dev->f_adc;
-	else
-		bandwidth = dev->bandwidth->val;
-
-	for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
-		if (bandwidth <= bandwidth_lut[i].freq) {
-			bandwidth = bandwidth_lut[i].freq;
-			break;
-		}
-	}
-
-	dev->bandwidth->val = bandwidth;
-	dev->bandwidth->cur.val = bandwidth;
-
-	dev_dbg(dev->dev, "bandwidth selected=%d\n", bandwidth);
-
-	u16tmp = 0;
-	u16tmp |= ((bandwidth >> 0) & 0xff) << 0;
-	u16tmp |= ((bandwidth >> 8) & 0xff) << 8;
-	u16tmp2 = 0;
-	u16tmp2 |= ((bandwidth >> 16) & 0xff) << 0;
-	u16tmp2 |= ((bandwidth >> 24) & 0xff) << 8;
-
-	ret = hackrf_ctrl_msg(dev, CMD_BASEBAND_FILTER_BANDWIDTH_SET,
-				u16tmp, u16tmp2, NULL, 0);
-	if (ret)
-		dev_dbg(dev->dev, "failed=%d\n", ret);
-
-	return ret;
-}
-
-static int hackrf_set_rf_gain(struct hackrf_dev *dev)
-{
-	int ret;
-	u8 u8tmp;
-
-	dev_dbg(dev->dev, "rf val=%d->%d\n",
-		dev->rf_gain->cur.val, dev->rf_gain->val);
-
-	u8tmp = (dev->rf_gain->val) ? 1 : 0;
-	ret = hackrf_ctrl_msg(dev, CMD_AMP_ENABLE, u8tmp, 0, NULL, 0);
-	if (ret)
-		dev_dbg(dev->dev, "failed=%d\n", ret);
-
-	return ret;
-}
-
-static int hackrf_set_lna_gain(struct hackrf_dev *dev)
-{
-	int ret;
-	u8 u8tmp;
-
-	dev_dbg(dev->dev, "lna val=%d->%d\n",
-			dev->lna_gain->cur.val, dev->lna_gain->val);
-
-	ret = hackrf_ctrl_msg(dev, CMD_SET_LNA_GAIN, 0, dev->lna_gain->val,
-			&u8tmp, 1);
-	if (ret)
-		dev_dbg(dev->dev, "failed=%d\n", ret);
-
-	return ret;
-}
-
-static int hackrf_set_if_gain(struct hackrf_dev *dev)
-{
-	int ret;
-	u8 u8tmp;
-
-	dev_dbg(dev->dev, "val=%d->%d\n",
-			dev->if_gain->cur.val, dev->if_gain->val);
-
-	ret = hackrf_ctrl_msg(dev, CMD_SET_VGA_GAIN, 0, dev->if_gain->val,
-			&u8tmp, 1);
-	if (ret)
-		dev_dbg(dev->dev, "failed=%d\n", ret);
-
-	return ret;
-}
-
 static int hackrf_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct hackrf_dev *dev = container_of(ctrl->handler,
 			struct hackrf_dev, hdl);
+	struct usb_interface *intf = dev->intf;
 	int ret;
 
 	switch (ctrl->id) {
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
 	case V4L2_CID_RF_TUNER_BANDWIDTH:
-		ret = hackrf_set_bandwidth(dev);
+		set_bit(RX_BANDWIDTH, &dev->flags);
 		break;
 	case  V4L2_CID_RF_TUNER_RF_GAIN:
-		ret = hackrf_set_rf_gain(dev);
+		set_bit(RX_RF_GAIN, &dev->flags);
 		break;
 	case  V4L2_CID_RF_TUNER_LNA_GAIN:
-		ret = hackrf_set_lna_gain(dev);
+		set_bit(RX_LNA_GAIN, &dev->flags);
 		break;
 	case  V4L2_CID_RF_TUNER_IF_GAIN:
-		ret = hackrf_set_if_gain(dev);
+		set_bit(RX_IF_GAIN, &dev->flags);
 		break;
 	default:
-		dev_dbg(dev->dev, "unknown ctrl: id=%d name=%s\n",
-				ctrl->id, ctrl->name);
+		dev_dbg(&intf->dev, "unknown ctrl: id=%d name=%s\n",
+			ctrl->id, ctrl->name);
 		ret = -EINVAL;
+		goto err;
 	}
 
+	ret = hackrf_set_params(dev);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1048,6 +1074,7 @@ static int hackrf_probe(struct usb_interface *intf,
 	mutex_init(&dev->vb_queue_lock);
 	spin_lock_init(&dev->queued_bufs_lock);
 	INIT_LIST_HEAD(&dev->queued_bufs);
+	dev->intf = intf;
 	dev->dev = &intf->dev;
 	dev->udev = interface_to_usbdev(intf);
 	dev->f_adc = bands_adc[0].rangelow;
-- 
http://palosaari.fi/

