Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54570 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab3CJBnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 20:43:46 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 2/5] dvb_usb_v2: make checkpatch.pl happy
Date: Sun, 10 Mar 2013 03:42:32 +0200
Message-Id: <1362879755-4839-2-git-send-email-crope@iki.fi>
In-Reply-To: <1362879755-4839-1-git-send-email-crope@iki.fi>
References: <1362879755-4839-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New checkpatch version likes to see strings not to split multiple
lines even those are exceeding 80 line length.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 81 +++++++++++++++--------------
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c  |  5 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c      | 36 +++++++------
 3 files changed, 65 insertions(+), 57 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index c91da3c..9b24a0e 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -28,10 +28,11 @@ MODULE_PARM_DESC(disable_rc_polling,
 static int dvb_usb_force_pid_filter_usage;
 module_param_named(force_pid_filter_usage, dvb_usb_force_pid_filter_usage,
 		int, 0444);
-MODULE_PARM_DESC(force_pid_filter_usage, "force all DVB USB devices to use a " \
-		"PID filter, if any (default: 0)");
+MODULE_PARM_DESC(force_pid_filter_usage,
+		"force all DVB USB devices to use a PID filter, if any (default: 0)");
 
-static int dvb_usbv2_download_firmware(struct dvb_usb_device *d, const char *name)
+static int dvb_usbv2_download_firmware(struct dvb_usb_device *d,
+		const char *name)
 {
 	int ret;
 	const struct firmware *fw;
@@ -44,10 +45,9 @@ static int dvb_usbv2_download_firmware(struct dvb_usb_device *d, const char *nam
 
 	ret = request_firmware(&fw, name, &d->udev->dev);
 	if (ret < 0) {
-		dev_err(&d->udev->dev, "%s: Did not find the firmware file "\
-				"'%s'. Please see linux/Documentation/dvb/ " \
-				"for more details on firmware-problems. " \
-				"Status %d\n", KBUILD_MODNAME, name, ret);
+		dev_err(&d->udev->dev,
+				"%s: Did not find the firmware file '%s'. Please see linux/Documentation/dvb/ for more details on firmware-problems. Status %d\n",
+				KBUILD_MODNAME, name, ret);
 		goto err;
 	}
 
@@ -181,9 +181,9 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
 		/* initialize a work queue for handling polling */
 		INIT_DELAYED_WORK(&d->rc_query_work,
 				dvb_usb_read_remote_control);
-		dev_info(&d->udev->dev, "%s: schedule remote query interval " \
-				"to %d msecs\n", KBUILD_MODNAME,
-				d->rc.interval);
+		dev_info(&d->udev->dev,
+				"%s: schedule remote query interval to %d msecs\n",
+				KBUILD_MODNAME, d->rc.interval);
 		schedule_delayed_work(&d->rc_query_work,
 				msecs_to_jiffies(d->rc.interval));
 		d->rc_polling_active = true;
@@ -266,8 +266,7 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 	struct dvb_usb_adapter *adap = dvbdmxfeed->demux->priv;
 	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret;
-	dev_dbg(&d->udev->dev, "%s: adap=%d active_fe=%d feed_type=%d " \
-			"setting pid [%s]: %04x (%04d) at index %d '%s'\n",
+	dev_dbg(&d->udev->dev, "%s: adap=%d active_fe=%d feed_type=%d setting pid [%s]: %04x (%04d) at index %d '%s'\n",
 			__func__, adap->id, adap->active_fe, dvbdmxfeed->type,
 			adap->pid_filtering ? "yes" : "no", dvbdmxfeed->pid,
 			dvbdmxfeed->pid, dvbdmxfeed->index,
@@ -289,9 +288,9 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 			ret = d->props->streaming_ctrl(
 					adap->fe[adap->active_fe], 0);
 			if (ret < 0) {
-				dev_err(&d->udev->dev, "%s: streaming_ctrl() " \
-						"failed=%d\n", KBUILD_MODNAME,
-						ret);
+				dev_err(&d->udev->dev,
+						"%s: streaming_ctrl() failed=%d\n",
+						KBUILD_MODNAME, ret);
 				usb_urb_killv2(&adap->stream);
 				goto err_clear_wait;
 			}
@@ -354,8 +353,8 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 			ret = adap->props->pid_filter_ctrl(adap,
 					adap->pid_filtering);
 			if (ret < 0) {
-				dev_err(&d->udev->dev, "%s: " \
-						"pid_filter_ctrl() failed=%d\n",
+				dev_err(&d->udev->dev,
+						"%s: pid_filter_ctrl() failed=%d\n",
 						KBUILD_MODNAME, ret);
 				goto err_clear_wait;
 			}
@@ -365,9 +364,9 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 			ret = d->props->streaming_ctrl(
 					adap->fe[adap->active_fe], 1);
 			if (ret < 0) {
-				dev_err(&d->udev->dev, "%s: streaming_ctrl() " \
-						"failed=%d\n", KBUILD_MODNAME,
-						ret);
+				dev_err(&d->udev->dev,
+						"%s: streaming_ctrl() failed=%d\n",
+						KBUILD_MODNAME, ret);
 				goto err_clear_wait;
 			}
 		}
@@ -595,8 +594,9 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
 	if (d->props->frontend_attach) {
 		ret = d->props->frontend_attach(adap);
 		if (ret < 0) {
-			dev_dbg(&d->udev->dev, "%s: frontend_attach() " \
-					"failed=%d\n", __func__, ret);
+			dev_dbg(&d->udev->dev,
+					"%s: frontend_attach() failed=%d\n",
+					__func__, ret);
 			goto err_dvb_frontend_detach;
 		}
 	} else {
@@ -616,8 +616,9 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
 
 		ret = dvb_register_frontend(&adap->dvb_adap, adap->fe[i]);
 		if (ret < 0) {
-			dev_err(&d->udev->dev, "%s: frontend%d registration " \
-					"failed\n", KBUILD_MODNAME, i);
+			dev_err(&d->udev->dev,
+					"%s: frontend%d registration failed\n",
+					KBUILD_MODNAME, i);
 			goto err_dvb_unregister_frontend;
 		}
 
@@ -691,33 +692,33 @@ static int dvb_usbv2_adapter_init(struct dvb_usb_device *d)
 		/* speed - when running at FULL speed we need a HW PID filter */
 		if (d->udev->speed == USB_SPEED_FULL &&
 				!(adap->props->caps & DVB_USB_ADAP_HAS_PID_FILTER)) {
-			dev_err(&d->udev->dev, "%s: this USB2.0 device " \
-					"cannot be run on a USB1.1 port (it " \
-					"lacks a hardware PID filter)\n",
+			dev_err(&d->udev->dev,
+					"%s: this USB2.0 device cannot be run on a USB1.1 port (it lacks a hardware PID filter)\n",
 					KBUILD_MODNAME);
 			ret = -ENODEV;
 			goto err;
 		} else if ((d->udev->speed == USB_SPEED_FULL &&
 				adap->props->caps & DVB_USB_ADAP_HAS_PID_FILTER) ||
 				(adap->props->caps & DVB_USB_ADAP_NEED_PID_FILTERING)) {
-			dev_info(&d->udev->dev, "%s: will use the device's " \
-					"hardware PID filter " \
-					"(table count: %d)\n", KBUILD_MODNAME,
+			dev_info(&d->udev->dev,
+					"%s: will use the device's hardware PID filter (table count: %d)\n",
+					KBUILD_MODNAME,
 					adap->props->pid_filter_count);
 			adap->pid_filtering  = 1;
 			adap->max_feed_count = adap->props->pid_filter_count;
 		} else {
-			dev_info(&d->udev->dev, "%s: will pass the complete " \
-					"MPEG2 transport stream to the " \
-					"software demuxer\n", KBUILD_MODNAME);
+			dev_info(&d->udev->dev,
+					"%s: will pass the complete MPEG2 transport stream to the software demuxer\n",
+					KBUILD_MODNAME);
 			adap->pid_filtering  = 0;
 			adap->max_feed_count = 255;
 		}
 
 		if (!adap->pid_filtering && dvb_usb_force_pid_filter_usage &&
 				adap->props->caps & DVB_USB_ADAP_HAS_PID_FILTER) {
-			dev_info(&d->udev->dev, "%s: PID filter enabled by " \
-					"module option\n", KBUILD_MODNAME);
+			dev_info(&d->udev->dev,
+					"%s: PID filter enabled by module option\n",
+					KBUILD_MODNAME);
 			adap->pid_filtering  = 1;
 			adap->max_feed_count = adap->props->pid_filter_count;
 		}
@@ -846,8 +847,9 @@ static void dvb_usbv2_init_work(struct work_struct *work)
 		if (ret == 0) {
 			;
 		} else if (ret == COLD) {
-			dev_info(&d->udev->dev, "%s: found a '%s' in cold " \
-					"state\n", KBUILD_MODNAME, d->name);
+			dev_info(&d->udev->dev,
+					"%s: found a '%s' in cold state\n",
+					KBUILD_MODNAME, d->name);
 
 			if (!name)
 				name = d->props->firmware;
@@ -889,8 +891,9 @@ static void dvb_usbv2_init_work(struct work_struct *work)
 	if (ret < 0)
 		goto err_usb_driver_release_interface;
 
-	dev_info(&d->udev->dev, "%s: '%s' successfully initialized and " \
-			"connected\n", KBUILD_MODNAME, d->name);
+	dev_info(&d->udev->dev,
+			"%s: '%s' successfully initialized and connected\n",
+			KBUILD_MODNAME, d->name);
 
 	return;
 err_usb_driver_release_interface:
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
index 5716662..dbc4b891 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
@@ -56,8 +56,9 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
 				d->props->generic_bulk_ctrl_endpoint_response),
 				rbuf, rlen, &actual_length, 2000);
 		if (ret)
-			dev_err(&d->udev->dev, "%s: 2nd usb_bulk_msg() " \
-					"failed=%d\n", KBUILD_MODNAME, ret);
+			dev_err(&d->udev->dev,
+					"%s: 2nd usb_bulk_msg() failed=%d\n",
+					KBUILD_MODNAME, ret);
 
 		dev_dbg(&d->udev->dev, "%s: <<< %*ph\n", __func__,
 				actual_length, rbuf);
diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c b/drivers/media/usb/dvb-usb-v2/usb_urb.c
index 7346f85..ca8f3c2 100644
--- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
@@ -22,8 +22,8 @@ static void usb_urb_complete(struct urb *urb)
 	int i;
 	u8 *b;
 
-	dev_dbg_ratelimited(&stream->udev->dev, "%s: %s urb completed " \
-			"status=%d length=%d/%d pack_num=%d errors=%d\n",
+	dev_dbg_ratelimited(&stream->udev->dev,
+			"%s: %s urb completed status=%d length=%d/%d pack_num=%d errors=%d\n",
 			__func__, ptype == PIPE_ISOCHRONOUS ? "isoc" : "bulk",
 			urb->status, urb->actual_length,
 			urb->transfer_buffer_length,
@@ -49,8 +49,8 @@ static void usb_urb_complete(struct urb *urb)
 	case PIPE_ISOCHRONOUS:
 		for (i = 0; i < urb->number_of_packets; i++) {
 			if (urb->iso_frame_desc[i].status != 0)
-				dev_dbg(&stream->udev->dev, "%s: iso frame " \
-						"descriptor has an error=%d\n",
+				dev_dbg(&stream->udev->dev,
+						"%s: iso frame descriptor has an error=%d\n",
 						__func__,
 						urb->iso_frame_desc[i].status);
 			else if (urb->iso_frame_desc[i].actual_length > 0)
@@ -67,8 +67,9 @@ static void usb_urb_complete(struct urb *urb)
 			stream->complete(stream, b, urb->actual_length);
 		break;
 	default:
-		dev_err(&stream->udev->dev, "%s: unknown endpoint type in " \
-				"completition handler\n", KBUILD_MODNAME);
+		dev_err(&stream->udev->dev,
+				"%s: unknown endpoint type in completition handler\n",
+				KBUILD_MODNAME);
 		return;
 	}
 	usb_submit_urb(urb, GFP_ATOMIC);
@@ -101,8 +102,8 @@ int usb_urb_submitv2(struct usb_data_stream *stream,
 		dev_dbg(&stream->udev->dev, "%s: submit urb=%d\n", __func__, i);
 		ret = usb_submit_urb(stream->urb_list[i], GFP_ATOMIC);
 		if (ret) {
-			dev_err(&stream->udev->dev, "%s: could not submit " \
-					"urb no. %d - get them all back\n",
+			dev_err(&stream->udev->dev,
+					"%s: could not submit urb no. %d - get them all back\n",
 					KBUILD_MODNAME, i);
 			usb_urb_killv2(stream);
 			return ret;
@@ -229,8 +230,9 @@ static int usb_alloc_stream_buffers(struct usb_data_stream *stream, int num,
 	stream->buf_num = 0;
 	stream->buf_size = size;
 
-	dev_dbg(&stream->udev->dev, "%s: all in all I will use %lu bytes for " \
-			"streaming\n", __func__,  num * size);
+	dev_dbg(&stream->udev->dev,
+			"%s: all in all I will use %lu bytes for streaming\n",
+			__func__,  num * size);
 
 	for (stream->buf_num = 0; stream->buf_num < num; stream->buf_num++) {
 		stream->buf_list[stream->buf_num] = usb_alloc_coherent(
@@ -274,8 +276,8 @@ int usb_urb_reconfig(struct usb_data_stream *stream,
 	}
 
 	if (stream->buf_num < props->count || stream->buf_size < buf_size) {
-		dev_err(&stream->udev->dev, "%s: cannot reconfigure as " \
-				"allocated buffers are too small\n",
+		dev_err(&stream->udev->dev,
+				"%s: cannot reconfigure as allocated buffers are too small\n",
 				KBUILD_MODNAME);
 		return -EINVAL;
 	}
@@ -321,8 +323,9 @@ int usb_urb_initv2(struct usb_data_stream *stream,
 	memcpy(&stream->props, props, sizeof(*props));
 
 	if (!stream->complete) {
-		dev_err(&stream->udev->dev, "%s: there is no data callback - " \
-				"this doesn't make sense\n", KBUILD_MODNAME);
+		dev_err(&stream->udev->dev,
+				"%s: there is no data callback - this doesn't make sense\n",
+				KBUILD_MODNAME);
 		return -EINVAL;
 	}
 
@@ -343,8 +346,9 @@ int usb_urb_initv2(struct usb_data_stream *stream,
 
 		return usb_urb_alloc_isoc_urbs(stream);
 	default:
-		dev_err(&stream->udev->dev, "%s: unknown urb-type for data " \
-				"transfer\n", KBUILD_MODNAME);
+		dev_err(&stream->udev->dev,
+				"%s: unknown urb-type for data transfer\n",
+				KBUILD_MODNAME);
 		return -EINVAL;
 	}
 }
-- 
1.7.11.7

