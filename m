Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:55000 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751629AbdIUPJW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:09:22 -0400
Subject: [PATCH 3/4] [media] usbvision-core: Delete unnecessary braces in 11
 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
Message-ID: <f4b939c7-b16e-c956-190b-51339afaac53@users.sourceforge.net>
Date: Thu, 21 Sep 2017 17:08:35 +0200
MIME-Version: 1.0
In-Reply-To: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 21 Sep 2017 16:24:20 +0200

Do not use curly brackets at some source code places
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/usbvision/usbvision-core.c | 71 ++++++++++++----------------
 1 file changed, 31 insertions(+), 40 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index bb6f4f69165f..54db35b03106 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -188,10 +188,9 @@ static int scratch_free(struct usb_usbvision *usbvision)
 	int free = usbvision->scratch_read_ptr - usbvision->scratch_write_ptr;
 	if (free <= 0)
 		free += scratch_buf_size;
-	if (free) {
+	if (free)
 		free -= 1;							/* at least one byte in the buffer must */
 										/* left blank, otherwise there is no chance to differ between full and empty */
-	}
 	PDEBUG(DBG_SCRATCH, "return %d\n", free);
 
 	return free;
@@ -699,11 +698,12 @@ static enum parse_state usbvision_parse_compress(struct usb_usbvision *usbvision
 
 	frame = usbvision->cur_frame;
 	image_size = frame->frmwidth * frame->frmheight;
-	if ((frame->v4l2_format.format == V4L2_PIX_FMT_YUV422P) ||
-	    (frame->v4l2_format.format == V4L2_PIX_FMT_YVU420)) {       /* this is a planar format */
+	if (frame->v4l2_format.format == V4L2_PIX_FMT_YUV422P ||
+	    frame->v4l2_format.format == V4L2_PIX_FMT_YVU420)
+		/* this is a planar format */
 		/* ... v4l2_linesize not used here. */
 		f = frame->data + (frame->width * frame->curline);
-	} else
+	else
 		f = frame->data + (frame->v4l2_linesize * frame->curline);
 
 	if (frame->v4l2_format.format == V4L2_PIX_FMT_YUYV) { /* initialise u and v pointers */
@@ -734,22 +734,19 @@ static enum parse_state usbvision_parse_compress(struct usb_usbvision *usbvision
 		return parse_state_next_frame;
 	}
 
-	if (frame->curline != (int)strip_header[2]) {
+	if (frame->curline != (int)strip_header[2])
 		/* line number mismatch error */
 		usbvision->strip_line_number_errors++;
-	}
 
 	strip_len = 2 * (unsigned int)strip_header[1];
-	if (strip_len > USBVISION_STRIP_LEN_MAX) {
+	if (strip_len > USBVISION_STRIP_LEN_MAX)
 		/* strip overrun */
 		/* I think this never happens */
 		usbvision_request_intra(usbvision);
-	}
 
-	if (scratch_len(usbvision) < strip_len) {
+	if (scratch_len(usbvision) < strip_len)
 		/* there is not enough data for the strip */
 		return parse_state_out;
-	}
 
 	if (usbvision->intra_frame_buffer) {
 		Y = usbvision->intra_frame_buffer + frame->frmwidth * frame->curline;
@@ -1306,11 +1303,11 @@ static void usbvision_isoc_irq(struct urb *urb)
 		/* If we collected enough data let's parse! */
 		if (scratch_len(usbvision) > USBVISION_HEADER_LENGTH &&
 		    !list_empty(&(usbvision->inqueue))) {
-			if (!(*f)) {
+			if (!(*f))
 				(*f) = list_entry(usbvision->inqueue.next,
 						  struct usbvision_frame,
 						  frame);
-			}
+
 			usbvision_parse_data(usbvision);
 		} else {
 			/* If we don't have a frame
@@ -1334,12 +1331,10 @@ static void usbvision_isoc_irq(struct urb *urb)
 	urb->status = 0;
 	urb->dev = usbvision->dev;
 	err_code = usb_submit_urb(urb, GFP_ATOMIC);
-
-	if (err_code) {
+	if (err_code)
 		dev_err(&usbvision->dev->dev,
 			"%s: usb_submit_urb failed: error %d\n",
 				__func__, err_code);
-	}
 
 	return;
 }
@@ -1398,11 +1393,10 @@ int usbvision_write_reg(struct usb_usbvision *usbvision, unsigned char reg,
 				USB_DIR_OUT | USB_TYPE_VENDOR |
 				USB_RECIP_ENDPOINT, 0, (__u16) reg,
 				usbvision->ctrl_urb_buffer, 1, HZ);
-
-	if (err_code < 0) {
+	if (err_code < 0)
 		dev_err(&usbvision->dev->dev,
 			"%s: failed: error %d\n", __func__, err_code);
-	}
+
 	return err_code;
 }
 
@@ -1443,10 +1437,10 @@ static int usbvision_write_reg_irq(struct usb_usbvision *usbvision, int address,
 	memcpy(usbvision->ctrl_urb_buffer, data, len);
 
 	err_code = usb_submit_urb(usbvision->ctrl_urb, GFP_ATOMIC);
-	if (err_code < 0) {
+	if (err_code < 0)
 		/* error in usb_submit_urb() */
 		usbvision->ctrl_urb_busy = 0;
-	}
+
 	PDEBUG(DBG_IRQ, "submit %d byte: error %d", len, err_code);
 	return err_code;
 }
@@ -1477,11 +1471,11 @@ static int usbvision_measure_bandwidth(struct usb_usbvision *usbvision)
 		usbvision->isoc_measure_bandwidth_count++;
 		return 0;
 	}
-	if ((usbvision->isoc_packet_size > 0) && (usbvision->isoc_packet_count > 0)) {
+	if (usbvision->isoc_packet_size > 0 && usbvision->isoc_packet_count > 0)
 		usbvision->used_bandwidth = usbvision->isoc_data_count /
 					(usbvision->isoc_packet_count + usbvision->isoc_skip_count) *
 					100 / usbvision->isoc_packet_size;
-	}
+
 	usbvision->isoc_measure_bandwidth_count = 0;
 	usbvision->isoc_data_count = 0;
 	usbvision->isoc_packet_count = 0;
@@ -1648,11 +1642,10 @@ static int usbvision_set_video_format(struct usb_usbvision *usbvision, int forma
 			     USB_DIR_OUT | USB_TYPE_VENDOR |
 			     USB_RECIP_ENDPOINT, 0,
 			     (__u16) USBVISION_FILT_CONT, value, 2, HZ);
-
-	if (rc < 0) {
+	if (rc < 0)
 		printk(KERN_ERR "%s: ERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
 		       proc, rc);
-	}
+
 	usbvision->isoc_mode = format;
 	return rc;
 }
@@ -1935,17 +1928,17 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 		return 0;
 
 	/* Set input format expected from decoder*/
-	if (usbvision_device_data[usbvision->dev_model].vin_reg1_override) {
+	if (usbvision_device_data[usbvision->dev_model].vin_reg1_override)
 		value[0] = usbvision_device_data[usbvision->dev_model].vin_reg1;
-	} else if (usbvision_device_data[usbvision->dev_model].codec == CODEC_SAA7113) {
+	else if (usbvision_device_data[usbvision->dev_model].codec
+		 == CODEC_SAA7113)
 		/* SAA7113 uses 8 bit output */
 		value[0] = USBVISION_8_422_SYNC;
-	} else {
+	else
 		/* I'm sure only about d2-d0 [010] 16 bit 4:2:2 usin sync pulses
 		 * as that is how saa7111 is configured */
 		value[0] = USBVISION_16_422_SYNC;
 		/* | USBVISION_VSNC_POL | USBVISION_VCLK_POL);*/
-	}
 
 	rc = usbvision_write_reg(usbvision, USBVISION_VIN_REG1, value[0]);
 	if (rc < 0)
@@ -2015,12 +2008,12 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 
 	dvi_yuv_value = 0x00;	/* U comes after V, Ya comes after U/V, Yb comes after Yb */
 
-	if (usbvision_device_data[usbvision->dev_model].dvi_yuv_override) {
+	if (usbvision_device_data[usbvision->dev_model].dvi_yuv_override)
 		dvi_yuv_value = usbvision_device_data[usbvision->dev_model].dvi_yuv;
-	} else if (usbvision_device_data[usbvision->dev_model].codec == CODEC_SAA7113) {
+	else if (usbvision_device_data[usbvision->dev_model].codec
+		 == CODEC_SAA7113)
 		/* This changes as the fine sync control changes. Further investigation necessary */
 		dvi_yuv_value = 0x06;
-	}
 
 	return usbvision_write_reg(usbvision, USBVISION_DVI_YUV, dvi_yuv_value);
 
@@ -2320,11 +2313,10 @@ int usbvision_init_isoc(struct usb_usbvision *usbvision)
 	for (buf_idx = 0; buf_idx < USBVISION_NUMSBUF; buf_idx++) {
 		err_code = usb_submit_urb(usbvision->sbuf[buf_idx].urb,
 					 GFP_KERNEL);
-		if (err_code) {
+		if (err_code)
 			dev_err(&usbvision->dev->dev,
 				"%s: usb_submit_urb(%d) failed: error %d\n",
 					__func__, buf_idx, err_code);
-		}
 	}
 
 	usbvision->streaming = stream_idle;
@@ -2352,12 +2344,12 @@ void usbvision_stop_isoc(struct usb_usbvision *usbvision)
 	/* Unschedule all of the iso td's */
 	for (buf_idx = 0; buf_idx < USBVISION_NUMSBUF; buf_idx++) {
 		usb_kill_urb(usbvision->sbuf[buf_idx].urb);
-		if (usbvision->sbuf[buf_idx].data) {
+		if (usbvision->sbuf[buf_idx].data)
 			usb_free_coherent(usbvision->dev,
 					  sb_size,
 					  usbvision->sbuf[buf_idx].data,
 					  usbvision->sbuf[buf_idx].urb->transfer_dma);
-		}
+
 		usb_free_urb(usbvision->sbuf[buf_idx].urb);
 		usbvision->sbuf[buf_idx].urb = NULL;
 	}
@@ -2409,14 +2401,13 @@ int usbvision_muxsel(struct usb_usbvision *usbvision, int channel)
 	switch (usbvision_device_data[usbvision->dev_model].codec) {
 	case CODEC_SAA7113:
 		mode[1] = SAA7115_COMPOSITE2;
-		if (switch_svideo_input) {
+		if (switch_svideo_input)
 			/* To handle problems with S-Video Input for
 			 * some devices.  Use switch_svideo_input
 			 * parameter when loading the module.*/
 			mode[2] = SAA7115_COMPOSITE1;
-		} else {
+		else
 			mode[2] = SAA7115_SVIDEO1;
-		}
 		break;
 	case CODEC_SAA7111:
 	default:
-- 
2.14.1
