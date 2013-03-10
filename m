Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47149 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3CJBnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 20:43:46 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 4/5] dvb_usb_v2: rework USB streaming logic
Date: Sun, 10 Mar 2013 03:42:34 +0200
Message-Id: <1362879755-4839-4-git-send-email-crope@iki.fi>
In-Reply-To: <1362879755-4839-1-git-send-email-crope@iki.fi>
References: <1362879755-4839-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Control flow order changed a little bit. HW PID filter is now
disabled also when streaming is stopped - earlier it was just
set only when streaming was started.

Control flow is now:

* set 'streaming' status bit
* submit USB streaming packets
* enable HW PID filter
* ask device to start streaming
* N x add PID to device HW PID filter
... streaming video ...
* N x remove PID from device HW PID filter
* ask device to stop streaming
* disable HW PID filter
* kill USB streaming packets
* clear 'streaming' status bit

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 215 +++++++++++++++-------------
 1 file changed, 116 insertions(+), 99 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 9b24a0e..19f6737 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -260,135 +260,152 @@ static int wait_schedule(void *ptr)
 	return 0;
 }
 
-static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
-		int count)
+static int dvb_usb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
 	struct dvb_usb_adapter *adap = dvbdmxfeed->demux->priv;
 	struct dvb_usb_device *d = adap_to_d(adap);
-	int ret;
-	dev_dbg(&d->udev->dev, "%s: adap=%d active_fe=%d feed_type=%d setting pid [%s]: %04x (%04d) at index %d '%s'\n",
+	int ret = 0;
+	struct usb_data_stream_properties stream_props;
+	dev_dbg(&d->udev->dev,
+			"%s: adap=%d active_fe=%d feed_type=%d setting pid [%s]: %04x (%04d) at index %d\n",
 			__func__, adap->id, adap->active_fe, dvbdmxfeed->type,
 			adap->pid_filtering ? "yes" : "no", dvbdmxfeed->pid,
-			dvbdmxfeed->pid, dvbdmxfeed->index,
-			(count == 1) ? "on" : "off");
+			dvbdmxfeed->pid, dvbdmxfeed->index);
 
+	/* wait init is done */
 	wait_on_bit(&adap->state_bits, ADAP_INIT, wait_schedule,
 			TASK_UNINTERRUPTIBLE);
 
 	if (adap->active_fe == -1)
 		return -EINVAL;
 
-	adap->feed_count += count;
-
-	/* stop feeding if it is last pid */
-	if (adap->feed_count == 0) {
-		dev_dbg(&d->udev->dev, "%s: stop feeding\n", __func__);
-
-		if (d->props->streaming_ctrl) {
-			ret = d->props->streaming_ctrl(
-					adap->fe[adap->active_fe], 0);
-			if (ret < 0) {
-				dev_err(&d->udev->dev,
-						"%s: streaming_ctrl() failed=%d\n",
-						KBUILD_MODNAME, ret);
-				usb_urb_killv2(&adap->stream);
-				goto err_clear_wait;
-			}
-		}
-		usb_urb_killv2(&adap->stream);
+	/* skip feed setup if we are already feeding */
+	if (adap->feed_count++ > 0)
+		goto skip_feed_start;
 
-		clear_bit(ADAP_STREAMING, &adap->state_bits);
-		smp_mb__after_clear_bit();
-		wake_up_bit(&adap->state_bits, ADAP_STREAMING);
+	/* set 'streaming' status bit */
+	set_bit(ADAP_STREAMING, &adap->state_bits);
+
+	/* resolve input and output streaming parameters */
+	if (d->props->get_stream_config) {
+		memcpy(&stream_props, &adap->props->stream,
+				sizeof(struct usb_data_stream_properties));
+		ret = d->props->get_stream_config(adap->fe[adap->active_fe],
+				&adap->ts_type, &stream_props);
+		if (ret)
+			dev_err(&d->udev->dev,
+					"%s: get_stream_config() failed=%d\n",
+					KBUILD_MODNAME, ret);
+	} else {
+		stream_props = adap->props->stream;
+	}
+
+	switch (adap->ts_type) {
+	case DVB_USB_FE_TS_TYPE_204:
+		adap->stream.complete = dvb_usb_data_complete_204;
+		break;
+	case DVB_USB_FE_TS_TYPE_RAW:
+		adap->stream.complete = dvb_usb_data_complete_raw;
+		break;
+	case DVB_USB_FE_TS_TYPE_188:
+	default:
+		adap->stream.complete = dvb_usb_data_complete;
+		break;
+	}
+
+	/* submit USB streaming packets */
+	usb_urb_submitv2(&adap->stream, &stream_props);
+
+	/* enable HW PID filter */
+	if (adap->pid_filtering && adap->props->pid_filter_ctrl) {
+		ret = adap->props->pid_filter_ctrl(adap, 1);
+		if (ret)
+			dev_err(&d->udev->dev,
+					"%s: pid_filter_ctrl() failed=%d\n",
+					KBUILD_MODNAME, ret);
 	}
 
-	/* activate the pid on the device pid filter */
-	if (adap->props->caps & DVB_USB_ADAP_HAS_PID_FILTER &&
-			adap->pid_filtering && adap->props->pid_filter) {
+	/* ask device to start streaming */
+	if (d->props->streaming_ctrl) {
+		ret = d->props->streaming_ctrl(adap->fe[adap->active_fe], 1);
+		if (ret)
+			dev_err(&d->udev->dev,
+					"%s: streaming_ctrl() failed=%d\n",
+					KBUILD_MODNAME, ret);
+	}
+skip_feed_start:
+
+	/* add PID to device HW PID filter */
+	if (adap->pid_filtering && adap->props->pid_filter) {
 		ret = adap->props->pid_filter(adap, dvbdmxfeed->index,
-				dvbdmxfeed->pid, (count == 1) ? 1 : 0);
-		if (ret < 0)
+				dvbdmxfeed->pid, 1);
+		if (ret)
 			dev_err(&d->udev->dev, "%s: pid_filter() failed=%d\n",
 					KBUILD_MODNAME, ret);
 	}
 
-	/* start feeding if it is first pid */
-	if (adap->feed_count == 1 && count == 1) {
-		struct usb_data_stream_properties stream_props;
-		set_bit(ADAP_STREAMING, &adap->state_bits);
-		dev_dbg(&d->udev->dev, "%s: start feeding\n", __func__);
+	if (ret)
+		dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
 
-		/* resolve input and output streaming paramters */
-		if (d->props->get_stream_config) {
-			memcpy(&stream_props, &adap->props->stream,
-				sizeof(struct usb_data_stream_properties));
-			ret = d->props->get_stream_config(
-					adap->fe[adap->active_fe],
-					&adap->ts_type, &stream_props);
-			if (ret < 0)
-				goto err_clear_wait;
-		} else {
-			stream_props = adap->props->stream;
-		}
+static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	struct dvb_usb_adapter *adap = dvbdmxfeed->demux->priv;
+	struct dvb_usb_device *d = adap_to_d(adap);
+	int ret = 0;
+	dev_dbg(&d->udev->dev,
+			"%s: adap=%d active_fe=%d feed_type=%d setting pid [%s]: %04x (%04d) at index %d\n",
+			__func__, adap->id, adap->active_fe, dvbdmxfeed->type,
+			adap->pid_filtering ? "yes" : "no", dvbdmxfeed->pid,
+			dvbdmxfeed->pid, dvbdmxfeed->index);
 
-		switch (adap->ts_type) {
-		case DVB_USB_FE_TS_TYPE_204:
-			adap->stream.complete = dvb_usb_data_complete_204;
-			break;
-		case DVB_USB_FE_TS_TYPE_RAW:
-			adap->stream.complete = dvb_usb_data_complete_raw;
-			break;
-		case DVB_USB_FE_TS_TYPE_188:
-		default:
-			adap->stream.complete = dvb_usb_data_complete;
-			break;
-		}
+	if (adap->active_fe == -1)
+		return -EINVAL;
 
-		usb_urb_submitv2(&adap->stream, &stream_props);
-
-		if (adap->props->caps & DVB_USB_ADAP_HAS_PID_FILTER &&
-				adap->props->caps &
-				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF &&
-				adap->props->pid_filter_ctrl) {
-			ret = adap->props->pid_filter_ctrl(adap,
-					adap->pid_filtering);
-			if (ret < 0) {
-				dev_err(&d->udev->dev,
-						"%s: pid_filter_ctrl() failed=%d\n",
-						KBUILD_MODNAME, ret);
-				goto err_clear_wait;
-			}
-		}
+	/* remove PID from device HW PID filter */
+	if (adap->pid_filtering && adap->props->pid_filter) {
+		ret = adap->props->pid_filter(adap, dvbdmxfeed->index,
+				dvbdmxfeed->pid, 0);
+		if (ret)
+			dev_err(&d->udev->dev, "%s: pid_filter() failed=%d\n",
+					KBUILD_MODNAME, ret);
+	}
 
-		if (d->props->streaming_ctrl) {
-			ret = d->props->streaming_ctrl(
-					adap->fe[adap->active_fe], 1);
-			if (ret < 0) {
-				dev_err(&d->udev->dev,
-						"%s: streaming_ctrl() failed=%d\n",
-						KBUILD_MODNAME, ret);
-				goto err_clear_wait;
-			}
-		}
+	/* we cannot stop streaming until last PID is removed */
+	if (--adap->feed_count > 0)
+		goto skip_feed_stop;
+
+	/* ask device to stop streaming */
+	if (d->props->streaming_ctrl) {
+		ret = d->props->streaming_ctrl(adap->fe[adap->active_fe], 0);
+		if (ret)
+			dev_err(&d->udev->dev,
+					"%s: streaming_ctrl() failed=%d\n",
+					KBUILD_MODNAME, ret);
 	}
 
-	return 0;
-err_clear_wait:
+	/* disable HW PID filter */
+	if (adap->pid_filtering && adap->props->pid_filter_ctrl) {
+		ret = adap->props->pid_filter_ctrl(adap, 0);
+		if (ret)
+			dev_err(&d->udev->dev,
+					"%s: pid_filter_ctrl() failed=%d\n",
+					KBUILD_MODNAME, ret);
+	}
+
+	/* kill USB streaming packets */
+	usb_urb_killv2(&adap->stream);
+
+	/* clear 'streaming' status bit */
 	clear_bit(ADAP_STREAMING, &adap->state_bits);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&adap->state_bits, ADAP_STREAMING);
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-static int dvb_usb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
-{
-	return dvb_usb_ctrl_feed(dvbdmxfeed, 1);
-}
+skip_feed_stop:
 
-static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
-{
-	return dvb_usb_ctrl_feed(dvbdmxfeed, -1);
+	if (ret)
+		dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
 }
 
 static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
-- 
1.7.11.7

