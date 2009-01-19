Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:7548
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbZASXjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 18:39:24 -0500
From: Adam Baker <adam@baker-net.org.uk>
To: "Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: [PATCH v2] Add support for sq905 based cameras to gspca
Date: Mon, 19 Jan 2009 23:29:25 +0000
Cc: kilgota@banach.math.auburn.edu, sqcam-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192329.25630.adam@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add initial support for cameras based on the SQ Technologies SQ-905
chipset (USB ID 2770:9120) to V4L2 using the gspca infrastructure.
Currently only supports one resolution and doesn't attempt to inform
libv4l what image flipping options are needed.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>

---
This is the alternate version that uses asynchronous USB commands

See previous mail for details.
---

diff -r c1ebc0e03fa1 linux/drivers/media/video/gspca/Kconfig
--- a/linux/drivers/media/video/gspca/Kconfig	Sun Jan 18 18:24:52 2009 +0100
+++ b/linux/drivers/media/video/gspca/Kconfig	Mon Jan 19 23:28:12 2009 +0000
@@ -176,6 +176,15 @@ config USB_GSPCA_SPCA561
 	  To compile this driver as a module, choose M here: the
 	  module will be called gspca_spca561.
 
+config USB_GSPCA_SQ905
+	tristate "SQ Technologies SQ905 based USB Camera Driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for cameras based on the SQ905 chip.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_sq905.
+
 config USB_GSPCA_STK014
 	tristate "Syntek DV4000 (STK014) USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
diff -r c1ebc0e03fa1 linux/drivers/media/video/gspca/Makefile
--- a/linux/drivers/media/video/gspca/Makefile	Sun Jan 18 18:24:52 2009 +0100
+++ b/linux/drivers/media/video/gspca/Makefile	Mon Jan 19 23:28:12 2009 +0000
@@ -16,6 +16,7 @@ obj-$(CONFIG_USB_GSPCA_SPCA506)  += gspc
 obj-$(CONFIG_USB_GSPCA_SPCA506)  += gspca_spca506.o
 obj-$(CONFIG_USB_GSPCA_SPCA508)  += gspca_spca508.o
 obj-$(CONFIG_USB_GSPCA_SPCA561)  += gspca_spca561.o
+obj-$(CONFIG_USB_GSPCA_SQ905)    += gspca_sq905.o
 obj-$(CONFIG_USB_GSPCA_SUNPLUS)  += gspca_sunplus.o
 obj-$(CONFIG_USB_GSPCA_STK014)   += gspca_stk014.o
 obj-$(CONFIG_USB_GSPCA_T613)     += gspca_t613.o
@@ -41,6 +42,7 @@ gspca_spca506-objs  := spca506.o
 gspca_spca506-objs  := spca506.o
 gspca_spca508-objs  := spca508.o
 gspca_spca561-objs  := spca561.o
+gspca_sq905-objs    := sq905.o
 gspca_stk014-objs   := stk014.o
 gspca_sunplus-objs  := sunplus.o
 gspca_t613-objs     := t613.o
diff -r c1ebc0e03fa1 linux/drivers/media/video/gspca/sq905.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/sq905.c	Mon Jan 19 23:28:12 2009 +0000
@@ -0,0 +1,527 @@
+/*
+ * SQ905 subdriver
+ *
+ * Copyright (C) 2008, 2009 Adam Baker and Theodore Kilgore
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+/*
+ * History and Acknowledgments
+ *
+ * The original Linux driver for SQ905 based cameras was written by
+ * Marcell Lengyel and further developed by many other contributors
+ * and is available from http://sourceforge.net/projects/sqcam/
+ *
+ * This driver takes advantage of the reverse engineering work done for
+ * that driver and for libgphoto2 but shares no code with them.
+ *
+ * This driver has used as a base the finepix driver and other gspca
+ * based drivers and may still contain code fragments taken from those
+ * drivers.
+ */
+
+#define MODULE_NAME "sq905"
+
+#include <linux/workqueue.h>
+#include "gspca.h"
+
+MODULE_AUTHOR("Adam Baker <linux@baker-net.org.uk>, "
+		"Theodore Kilgore <kilgota@auburn.edu>");
+MODULE_DESCRIPTION("GSPCA/SQ905 USB Camera Driver");
+MODULE_LICENSE("GPL");
+
+/* Default timeouts, in ms */
+#define SQ905_CMD_TIMEOUT 500
+#define SQ905_DATA_TIMEOUT 250
+
+/* Maximum transfer size to use. */
+#define SQ905_MAX_TRANSFER 0x8000
+#define FRAME_HEADER_LEN 64
+
+/* The known modes, or registers. These go in the "value" slot. */
+
+/* 00 is "none" obviously */
+
+#define SQ905_BULK_READ	0x03	/* precedes any bulk read */
+#define SQ905_COMMAND	0x06	/* precedes the command codes below */
+#define SQ905_PING	0x07	/* when reading an "idling" command */
+#define SQ905_READ_DONE 0xc0    /* ack bulk read completed */
+
+/* Some command codes. These go in the "index" slot. */
+
+#define SQ905_ID      0xf0	/* asks for model string */
+#define SQ905_CONFIG  0x20	/* gets photo alloc. table, not used here */
+#define SQ905_DATA    0x30	/* accesses photo data, not used here */
+#define SQ905_CLEAR   0xa0	/* clear everything */
+#define SQ905_CAPTURE_LOW 0x60	/* Starts capture at 160x120 */
+#define SQ905_CAPTURE_MED 0x61	/* Starts capture at 320x240 */
+/* note that the capture command also controls the output dimensions */
+/* 0x60 -> 160x120, 0x61 -> 320x240 0x62 -> 640x480 depends on camera */
+/* 0x62 is not correct, at least for some cams. Should be 0x63 ? */
+
+
+/* declare this as the submit functions it uses need to reference it. */
+static void urb_callback(struct urb *urb);
+
+/* Structure to hold all of our device specific stuff */
+struct sd {
+	struct gspca_dev gspca_dev;	/* !! must be the first item */
+
+	enum {
+		SQ905_MODEL_DEFAULT,
+		SQ905_MODEL_POCK_CAM,
+		SQ905_MODEL_MAGPIX
+	} cam_model;
+
+	/*
+	 * USB Stuff
+	 *
+	 * The GSPCA framework provides us with an urb for bulk in transfers
+	 * but we have to provide our own URB for control messages.
+	 */
+	struct usb_ctrlrequest ctrlreq;
+	struct urb *control_urb;
+	struct timer_list usb_timer;
+
+	/*
+	 * State Machine
+	 */
+	enum {
+		SQ_STATE_NOP,
+		SQ_STATE_REQUEST_DATA,
+		SQ_STATE_BULK_READ,
+		SQ_STATE_ACK_FRAME
+	} state;
+	/*
+	 * Driver stuff
+	 */
+	struct completion can_close;
+	int streaming;
+	int discarding;
+	int frame_len;
+	int bytes_left;
+	struct urb *active_urb; /* The urb to clean up on timeout */
+};
+
+/* The driver only supports 320x240 so far. */
+static struct v4l2_pix_format sq905_mode[1] = {
+	{ 320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
+		.bytesperline = 320,
+		.sizeimage = 320 * 240,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 0}
+};
+
+/*
+ * Send a command to the camera. Must not be called while async
+ * streaming transfers are in progress as they also use usb_buf.
+ */
+static int sq905_command(struct gspca_dev *gspca_dev, __u16 index)
+{
+	int ret;
+	gspca_dev->usb_buf[0] = '\0';
+	ret = usb_control_msg(gspca_dev->dev,
+			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_COMMAND, index, gspca_dev->usb_buf, 1,
+			      SQ905_CMD_TIMEOUT);
+	if (ret != 1) {
+		PDEBUG(D_ERR, "%s: usb_control_msg failed (%d)",
+			__func__, ret);
+		return -EIO;
+	}
+
+	ret = usb_control_msg(gspca_dev->dev,
+			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_PING, 0, gspca_dev->usb_buf, 1,
+			      SQ905_CMD_TIMEOUT);
+	if (ret != 1) {
+		PDEBUG(D_ERR, "%s: usb_control_msg failed 2 (%d)",
+			__func__, ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/*
+ *  request and read a block of data. Must not be called while async
+ *  streaming transfers are in progress as they also use usb_buf.
+ */
+static int
+sq905_read_data(struct gspca_dev *gspca_dev, int size)
+{
+	int ret;
+	int act_len;
+
+	gspca_dev->usb_buf[0] = '\0';
+	ret = usb_control_msg(gspca_dev->dev,
+			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_BULK_READ, size, gspca_dev->usb_buf,
+			      1, SQ905_CMD_TIMEOUT);
+	if (ret != 1) {
+		PDEBUG(D_ERR, "%s: usb_control_msg failed (%d)", __func__, ret);
+		return -EIO;
+	}
+	ret = usb_bulk_msg(gspca_dev->dev,
+			   usb_rcvbulkpipe(gspca_dev->dev, 0x81),
+			   gspca_dev->usb_buf, size, &act_len,
+			   SQ905_DATA_TIMEOUT);
+	/* successful, it returns 0, otherwise  negative */
+	if ((ret != 0) || (act_len != size)) {
+		PDEBUG(D_ERR, "%s: bulk read fail (%d) len %d/%d",
+			__func__, ret, act_len, size);
+		return -EIO;
+	}
+	return 0;
+}
+
+/*
+ * Cleanup after a timeout or other USB error during streaming.
+ * Can potentially get called twice for the same failure (once
+ * from the timer and once from urb_callback) so usb_unlink_urb
+ * might be called for an already completed urb and complete
+ * may get called twice.
+ */
+static void sq905_stream_err_cleanup(unsigned long data)
+{
+	struct gspca_dev *gspca_dev = (struct gspca_dev *) data;
+	struct sd *dev = (struct sd *)gspca_dev;
+	PDEBUG(D_ERR, "%s: USB Error occured in state %d", __func__,
+		dev->state);
+
+	dev->state = SQ_STATE_NOP;
+	if (dev->active_urb)
+		usb_unlink_urb(dev->active_urb);
+	dev->active_urb = NULL;
+	if (dev->streaming)
+		complete(&dev->can_close);
+	dev->streaming = 0;
+}
+
+/*
+ * submit a command asyncyronously
+ */
+static void sq905_submit_command(struct gspca_dev *gspca_dev, int cmd,
+				 int index)
+{
+	int ret;
+	struct sd *dev = (struct sd *)gspca_dev;
+
+	PDEBUG(D_STREAM, "%s: cmd=%d, index=%d", __func__, cmd, index);
+	gspca_dev->usb_buf[0] = '\0';
+	dev->ctrlreq.bRequestType =
+		USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE;
+	dev->ctrlreq.bRequest = USB_REQ_SYNCH_FRAME;
+	dev->ctrlreq.wValue   = cpu_to_le16(cmd);
+	dev->ctrlreq.wIndex   = cpu_to_le16(index);
+	dev->ctrlreq.wLength  = cpu_to_le16(1);
+
+	usb_fill_control_urb(dev->control_urb,
+			     gspca_dev->dev,
+			     usb_sndctrlpipe(gspca_dev->dev, 0),
+			     (unsigned char *) &dev->ctrlreq,
+			     gspca_dev->usb_buf,
+			     1, urb_callback, gspca_dev);
+	ret = usb_submit_urb(dev->control_urb, GFP_ATOMIC);
+	if (ret) {
+		PDEBUG(D_ERR, "%s: submit_urb failed %d", __func__, ret);
+		sq905_stream_err_cleanup((unsigned long)gspca_dev);
+		return;
+	}
+	dev->usb_timer.expires = jiffies + msecs_to_jiffies(SQ905_CMD_TIMEOUT);
+	dev->active_urb = dev->control_urb;
+	add_timer(&dev->usb_timer);
+}
+
+static void sq905_submit_read(struct gspca_dev *gspca_dev, int len)
+{
+	int ret;
+	struct sd *dev = (struct sd *)gspca_dev;
+
+	PDEBUG(D_STREAM, "%s: len==%d", __func__, len);
+	gspca_dev->urb[0]->transfer_buffer_length = len;
+	ret = usb_submit_urb(dev->gspca_dev.urb[0], GFP_ATOMIC);
+	if (ret) {
+		PDEBUG(D_ERR, "%s: submit_urb failed %d", __func__, ret);
+		sq905_stream_err_cleanup((unsigned long)gspca_dev);
+		return;
+	}
+	dev->usb_timer.expires = jiffies + msecs_to_jiffies(SQ905_DATA_TIMEOUT);
+	dev->active_urb = gspca_dev->urb[0];
+	add_timer(&dev->usb_timer);
+}
+
+/*
+ * This function is called when an async read completes so there
+ * is data available to pass to the gspca framework.
+ */
+static void read_callback(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *)gspca_dev;
+	struct gspca_frame *frame;
+	int packet_type = INTER_PACKET;
+	__u8 *data = gspca_dev->urb[0]->transfer_buffer;
+	int data_len = gspca_dev->urb[0]->actual_length;
+
+	PDEBUG(D_STREAM, "Got %d bytes out of %d for frame",
+			data_len, dev->bytes_left);
+
+	if (dev->bytes_left == dev->frame_len) {
+		dev->discarding = 0;
+		/* The first 64 bytes of each frame are
+		 * a header full of FF 00 bytes */
+		data += FRAME_HEADER_LEN;
+		data_len -= FRAME_HEADER_LEN;
+		packet_type = FIRST_PACKET;
+	}
+
+	dev->bytes_left -= data_len;
+	if (dev->bytes_left == 0)
+		packet_type = LAST_PACKET;
+
+	frame = gspca_get_i_frame(gspca_dev);
+	if (!frame) {
+		dev->discarding = 1;
+		return;
+	}
+
+	gspca_frame_add(gspca_dev, packet_type, frame,
+			data, data_len);
+}
+
+/*
+ * This function is called when asynchronous USB operation completes.
+ */
+static void urb_callback(struct urb *urb)
+{
+	struct gspca_dev *gspca_dev = urb->context;
+	struct sd *dev = (struct sd *)gspca_dev;
+	int len;
+
+	del_timer(&dev->usb_timer);
+	dev->active_urb = NULL;
+
+	if (urb->status != 0) {
+		PDEBUG(D_ERR, "%s: got USB status %d, len %d", __func__,
+			urb->status, urb->actual_length);
+		sq905_stream_err_cleanup((unsigned long)gspca_dev);
+		return;
+	}
+
+	switch (dev->state) {
+	case SQ_STATE_REQUEST_DATA:
+		len = dev->bytes_left > SQ905_MAX_TRANSFER ?
+				SQ905_MAX_TRANSFER : dev->bytes_left;
+		PDEBUG(D_STREAM, "Reading %d bytes", len);
+		sq905_submit_read(gspca_dev, len);
+		dev->state = SQ_STATE_BULK_READ;
+		break;
+	case SQ_STATE_BULK_READ:
+		read_callback(gspca_dev);
+		PDEBUG(D_STREAM, "Read done, %d bytes left", dev->bytes_left);
+		if (dev->bytes_left == 0) {
+			sq905_submit_command(gspca_dev, SQ905_READ_DONE, 0);
+			dev->state = SQ_STATE_ACK_FRAME;
+		} else {
+			len = dev->bytes_left > SQ905_MAX_TRANSFER ?
+				SQ905_MAX_TRANSFER : dev->bytes_left;
+			sq905_submit_command(gspca_dev, SQ905_BULK_READ, len);
+			dev->state = SQ_STATE_REQUEST_DATA;
+		}
+		break;
+	case SQ_STATE_ACK_FRAME:
+		if (!dev->streaming) {
+			PDEBUG(D_STREAM, "Streaming completed");
+			complete(&dev->can_close);
+			dev->state = SQ_STATE_NOP;
+		} else {
+			PDEBUG(D_STREAM, "Sending frame acknowledge");
+			dev->bytes_left = dev->frame_len;
+			sq905_submit_command(gspca_dev, SQ905_BULK_READ,
+					     SQ905_MAX_TRANSFER);
+			dev->state = SQ_STATE_REQUEST_DATA;
+		}
+		break;
+	default:
+		sq905_stream_err_cleanup((unsigned long)gspca_dev);
+		break;
+	}
+}
+
+/* this function is called at probe time */
+static int sd_config(struct gspca_dev *gspca_dev,
+		const struct usb_device_id *id)
+{
+	struct cam *cam = &gspca_dev->cam;
+
+	cam->cam_mode = sq905_mode;
+	cam->nmodes = 1;
+	/* bulk_size is used by gspca to set the buffer size
+	 * allocated to urb[0] */
+	cam->bulk_size = SQ905_MAX_TRANSFER;
+	return 0;
+}
+
+/* Stop streaming and free the resources allocated by sd_start. */
+static void sd_stopN(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+
+	dev->streaming = 0;
+
+	/* wait for urb_callback */
+	wait_for_completion(&dev->can_close);
+}
+
+/* called on streamoff with alt 0 and disconnect */
+static void sd_stop0(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+	sq905_command(gspca_dev, SQ905_CLEAR);
+	usb_free_urb(dev->control_urb);
+	dev->control_urb = NULL;
+}
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+	init_timer(&dev->usb_timer);
+	dev->usb_timer.function = sq905_stream_err_cleanup;
+	dev->usb_timer.data = (unsigned long) gspca_dev;
+	dev->control_urb = NULL;
+
+	/* connect to the camera and read
+	 * the model ID and process that and put it away.
+	 */
+	sq905_command(gspca_dev, SQ905_CLEAR);
+	sq905_command(gspca_dev, SQ905_ID);
+	sq905_read_data(gspca_dev, 4);
+	sq905_command(gspca_dev, SQ905_CLEAR);
+	if (!memcmp(gspca_dev->usb_buf, "\x09\x05\x01\x19", 4)) {
+		dev->cam_model = SQ905_MODEL_POCK_CAM;
+		PDEBUG(D_CONF, "Model is SQ905_MODEL_POCK_CAM");
+	} else if (!memcmp(gspca_dev->usb_buf, "\x09\x05\x01\x32", 4)) {
+		dev->cam_model = SQ905_MODEL_MAGPIX;
+		PDEBUG(D_CONF, "Model is SQ905_MODEL_MAGPIX");
+	} else {
+		dev->cam_model = SQ905_MODEL_DEFAULT;
+		PDEBUG(D_CONF, "Model is SQ905_MODEL_DEFAULT");
+	}
+	return 0;
+}
+
+/* Set up for getting frames. */
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+
+	/* Various initializations. */
+	init_completion(&dev->can_close);
+	dev->streaming = 1;
+
+	/* Setup for async USB. */
+	BUG_ON(dev->control_urb);
+	dev->control_urb  = usb_alloc_urb(0, GFP_KERNEL);
+	if (!dev->control_urb) {
+		PDEBUG(D_ERR, "%s: Couldn't allocate URB",
+			__func__);
+		dev->streaming = 0;
+		return -EIO;
+	}
+
+	dev->gspca_dev.urb[0]->complete = urb_callback;
+
+	/* "Open the shutter" and set size, to start capture */
+	if (sq905_command(gspca_dev, SQ905_CAPTURE_MED)) {
+		PDEBUG(D_ERR, "%s: start streaming command failed\n",
+			__func__);
+		dev->streaming = 0;
+		usb_free_urb(dev->control_urb);
+		dev->control_urb = NULL;
+		return -EIO;
+	}
+
+	/* submit the initial read command to start streaming */
+	dev->frame_len = sq905_mode[0].sizeimage;
+	dev->bytes_left = dev->frame_len;
+	dev->state = SQ_STATE_REQUEST_DATA;
+	sq905_submit_command(gspca_dev, SQ905_BULK_READ, SQ905_MAX_TRANSFER);
+
+	return 0;
+}
+
+/* Table of supported USB devices */
+static const __devinitdata struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x2770, 0x9120)},
+	{}
+};
+
+MODULE_DEVICE_TABLE(usb, device_table);
+
+/* sub-driver description */
+static const struct sd_desc sd_desc = {
+	.name	= MODULE_NAME,
+	.config	= sd_config,
+	.init	= sd_init,
+	.start	= sd_start,
+	.stopN	= sd_stopN,
+	.stop0	= sd_stop0,
+};
+
+/* -- device connect -- */
+static int sd_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
+{
+	return gspca_dev_probe(intf, id,
+			&sd_desc,
+			sizeof(struct sd),
+			THIS_MODULE);
+}
+
+static struct usb_driver sd_driver = {
+	.name		= MODULE_NAME,
+	.id_table 	= device_table,
+	.probe 		= sd_probe,
+	.disconnect 	= gspca_disconnect,
+#ifdef CONFIG_PM
+	.suspend 	= gspca_suspend,
+	.resume 	= gspca_resume,
+#endif
+};
+
+/* -- module insert / remove -- */
+static int __init sd_mod_init(void)
+{
+	if (usb_register(&sd_driver) < 0)
+		return -1;
+	PDEBUG(D_PROBE, "registered");
+	return 0;
+}
+static void __exit sd_mod_exit(void)
+{
+	usb_deregister(&sd_driver);
+	PDEBUG(D_PROBE, "deregistered");
+}
+
+module_init(sd_mod_init);
+module_exit(sd_mod_exit);
