Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:60897 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751887AbaHDLOe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Aug 2014 07:14:34 -0400
From: Martin Kepplinger <martink@posteo.de>
To: dan.carpenter@oracle.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	m.chehab@samsung.com, Martin Kepplinger <martink@posteo.de>
Subject: [PATCHv3] staging: media: as102: replace custom dprintk() with dev_dbg()
Date: Mon,  4 Aug 2014 13:13:16 +0200
Message-Id: <1407150796-29909-1-git-send-email-martink@posteo.de>
In-Reply-To: <20140804104016.GQ4804@mwanda>
References: <20140804104016.GQ4804@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

remove dprintk() and replace it with dev_dbg() or pr_debug()
in order to use the common kernel coding style.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
Thanks for looking at it. So this doesn't add anything and actually does
what it says. If I haven't understood what you meant, or if I should try
to add struct_device info, I'll look again in a few hours.

 drivers/staging/media/as102/as102_drv.c     |   15 +++++-----
 drivers/staging/media/as102/as102_drv.h     |    7 -----
 drivers/staging/media/as102/as102_fe.c      |   25 +++++++---------
 drivers/staging/media/as102/as102_usb_drv.c |   41 ++++++++++++++++-----------
 4 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 09d64cd..e0ee618 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -31,10 +31,6 @@
 #include "as102_fw.h"
 #include "dvbdev.h"
 
-int as102_debug;
-module_param_named(debug, as102_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off debugging (default: off)");
-
 int dual_tuner;
 module_param_named(dual_tuner, dual_tuner, int, 0644);
 MODULE_PARM_DESC(dual_tuner, "Activate Dual-Tuner config (default: off)");
@@ -74,7 +70,8 @@ static void as102_stop_stream(struct as102_dev_t *dev)
 			return;
 
 		if (as10x_cmd_stop_streaming(bus_adap) < 0)
-			dprintk(debug, "as10x_cmd_stop_streaming failed\n");
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
+				"as10x_cmd_stop_streaming failed\n");
 
 		mutex_unlock(&dev->bus_adap.lock);
 	}
@@ -112,14 +109,16 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
 	int ret = -EFAULT;
 
 	if (mutex_lock_interruptible(&dev->bus_adap.lock)) {
-		dprintk(debug, "mutex_lock_interruptible(lock) failed !\n");
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"amutex_lock_interruptible(lock) failed !\n");
 		return -EBUSY;
 	}
 
 	switch (onoff) {
 	case 0:
 		ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
-		dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
 			index, pid, ret);
 		break;
 	case 1:
@@ -131,7 +130,7 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
 		filter.pid = pid;
 
 		ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
-		dprintk(debug,
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
 			"ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
 			index, filter.idx, filter.pid, ret);
 		break;
diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index a06837d..49d0c42 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -27,17 +27,10 @@
 #define DRIVER_FULL_NAME "Abilis Systems as10x usb driver"
 #define DRIVER_NAME "as10x_usb"
 
-extern int as102_debug;
 #define debug	as102_debug
 extern struct usb_driver as102_usb_driver;
 extern int elna_enable;
 
-#define dprintk(debug, args...) \
-	do { if (debug) {	\
-		pr_debug("%s: ", __func__);	\
-		printk(args);	\
-	} } while (0)
-
 #define AS102_DEVICE_MAJOR	192
 
 #define AS102_USB_BUF_SIZE	512
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index b686b76..67e55b8 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -46,7 +46,8 @@ static int as102_fe_set_frontend(struct dvb_frontend *fe)
 	/* send abilis command: SET_TUNE */
 	ret =  as10x_cmd_set_tune(&dev->bus_adap, &tune_args);
 	if (ret != 0)
-		dprintk(debug, "as10x_cmd_set_tune failed. (err = %d)\n", ret);
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"as10x_cmd_set_tune failed. (err = %d)\n", ret);
 
 	mutex_unlock(&dev->bus_adap.lock);
 
@@ -81,13 +82,6 @@ static int as102_fe_get_frontend(struct dvb_frontend *fe)
 static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
 			struct dvb_frontend_tune_settings *settings) {
 
-#if 0
-	dprintk(debug, "step_size    = %d\n", settings->step_size);
-	dprintk(debug, "max_drift    = %d\n", settings->max_drift);
-	dprintk(debug, "min_delay_ms = %d -> %d\n", settings->min_delay_ms,
-		1000);
-#endif
-
 	settings->min_delay_ms = 1000;
 
 	return 0;
@@ -110,7 +104,8 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	/* send abilis command: GET_TUNE_STATUS */
 	ret = as10x_cmd_get_tune_status(&dev->bus_adap, &tstate);
 	if (ret < 0) {
-		dprintk(debug, "as10x_cmd_get_tune_status failed (err = %d)\n",
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"as10x_cmd_get_tune_status failed (err = %d)\n",
 			ret);
 		goto out;
 	}
@@ -133,7 +128,8 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		*status = TUNE_STATUS_NOT_TUNED;
 	}
 
-	dprintk(debug, "tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
+	dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
 			tstate.tune_state, tstate.signal_strength,
 			tstate.PER, tstate.BER);
 
@@ -141,10 +137,10 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		if (as10x_cmd_get_demod_stats(&dev->bus_adap,
 			(struct as10x_demod_stats *) &dev->demod_stats) < 0) {
 			memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
-			dprintk(debug,
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
 				"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
 		} else {
-			dprintk(debug,
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
 				"demod status: fc: 0x%08x, bad fc: 0x%08x, "
 				"bytes corrected: 0x%08x , MER: 0x%04x\n",
 				dev->demod_stats.frame_count,
@@ -531,7 +527,7 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 		break;
 	}
 
-	dprintk(debug, "tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
+	pr_debug("as102: tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
 			params->frequency,
 			tune_args->bandwidth,
 			tune_args->guard_interval);
@@ -556,8 +552,7 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 			   as102_fe_get_code_rate(params->code_rate_LP);
 		}
 
-		dprintk(debug,
-			"\thierarchy: 0x%02x  selected: %s  code_rate_%s: 0x%02x\n",
+		pr_debug("as102: \thierarchy: 0x%02x  selected: %s  code_rate_%s: 0x%02x\n",
 			tune_args->hierarchy,
 			tune_args->hier_select == HIER_HIGH_PRIORITY ?
 			"HP" : "LP",
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index e6f6278..86f83b9 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -104,21 +104,22 @@ static int as102_usb_xfer_cmd(struct as10x_bus_adapter_t *bus_adap,
 				      send_buf, send_buf_len,
 				      USB_CTRL_SET_TIMEOUT /* 200 */);
 		if (ret < 0) {
-			dprintk(debug, "usb_control_msg(send) failed, err %i\n",
-					ret);
+			dev_dbg(&bus_adap->usb_dev->dev,
+				"usb_control_msg(send) failed, err %i\n", ret);
 			return ret;
 		}
 
 		if (ret != send_buf_len) {
-			dprintk(debug, "only wrote %d of %d bytes\n",
-					ret, send_buf_len);
+			dev_dbg(&bus_adap->usb_dev->dev,
+			"only wrote %d of %d bytes\n", ret, send_buf_len);
 			return -1;
 		}
 	}
 
 	if (recv_buf != NULL) {
 #ifdef TRACE
-		dprintk(debug, "want to read: %d bytes\n", recv_buf_len);
+		dev_dbg(bus_adap->usb_dev->dev,
+			"want to read: %d bytes\n", recv_buf_len);
 #endif
 		ret = usb_control_msg(bus_adap->usb_dev,
 				      usb_rcvctrlpipe(bus_adap->usb_dev, 0),
@@ -130,12 +131,13 @@ static int as102_usb_xfer_cmd(struct as10x_bus_adapter_t *bus_adap,
 				      recv_buf, recv_buf_len,
 				      USB_CTRL_GET_TIMEOUT /* 200 */);
 		if (ret < 0) {
-			dprintk(debug, "usb_control_msg(recv) failed, err %i\n",
-					ret);
+			dev_dbg(&bus_adap->usb_dev->dev,
+				"usb_control_msg(recv) failed, err %i\n", ret);
 			return ret;
 		}
 #ifdef TRACE
-		dprintk(debug, "read %d bytes\n", recv_buf_len);
+		dev_dbg(bus_adap->usb_dev->dev,
+			"read %d bytes\n", recv_buf_len);
 #endif
 	}
 
@@ -153,13 +155,14 @@ static int as102_send_ep1(struct as10x_bus_adapter_t *bus_adap,
 			   usb_sndbulkpipe(bus_adap->usb_dev, 1),
 			   send_buf, send_buf_len, &actual_len, 200);
 	if (ret) {
-		dprintk(debug, "usb_bulk_msg(send) failed, err %i\n", ret);
+		dev_dbg(&bus_adap->usb_dev->dev,
+			"usb_bulk_msg(send) failed, err %i\n", ret);
 		return ret;
 	}
 
 	if (actual_len != send_buf_len) {
-		dprintk(debug, "only wrote %d of %d bytes\n",
-				actual_len, send_buf_len);
+		dev_dbg(&bus_adap->usb_dev->dev, "only wrote %d of %d bytes\n",
+			actual_len, send_buf_len);
 		return -1;
 	}
 	return ret ? ret : actual_len;
@@ -177,13 +180,14 @@ static int as102_read_ep2(struct as10x_bus_adapter_t *bus_adap,
 			   usb_rcvbulkpipe(bus_adap->usb_dev, 2),
 			   recv_buf, recv_buf_len, &actual_len, 200);
 	if (ret) {
-		dprintk(debug, "usb_bulk_msg(recv) failed, err %i\n", ret);
+		dev_dbg(&bus_adap->usb_dev->dev,
+			"usb_bulk_msg(recv) failed, err %i\n", ret);
 		return ret;
 	}
 
 	if (actual_len != recv_buf_len) {
-		dprintk(debug, "only read %d of %d bytes\n",
-				actual_len, recv_buf_len);
+		dev_dbg(&bus_adap->usb_dev->dev, "only read %d of %d bytes\n",
+			actual_len, recv_buf_len);
 		return -1;
 	}
 	return ret ? ret : actual_len;
@@ -211,7 +215,8 @@ static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb)
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err)
-		dprintk(debug, "%s: usb_submit_urb failed\n", __func__);
+		dev_dbg(&urb->dev->dev,
+			"%s: usb_submit_urb failed\n", __func__);
 
 	return err;
 }
@@ -256,7 +261,8 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 				       GFP_KERNEL,
 				       &dev->dma_addr);
 	if (!dev->stream) {
-		dprintk(debug, "%s: usb_buffer_alloc failed\n", __func__);
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"%s: usb_buffer_alloc failed\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -268,7 +274,8 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 
 		urb = usb_alloc_urb(0, GFP_ATOMIC);
 		if (urb == NULL) {
-			dprintk(debug, "%s: usb_alloc_urb failed\n", __func__);
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
+				"%s: usb_alloc_urb failed\n", __func__);
 			as102_free_usb_stream_buffer(dev);
 			return -ENOMEM;
 		}
-- 
1.7.10.4

