Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:59692
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbZBFSEo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Feb 2009 13:04:44 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: [PATCH v3] Add support for sq905 based cameras to gspca
Date: Fri, 6 Feb 2009 18:04:36 +0000
Cc: Linux Media <linux-media@vger.kernel.org>,
	Driver Development <sqcam-devel@lists.sourceforge.net>,
	kilgota@banach.math.auburn.edu
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200902061804.36756.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add initial support for cameras based on the SQ Technologies SQ-905
chipset (USB ID 2770:9120) to V4L2 using the gspca infrastructure.
Currently only supports one resolution and doesn't attempt to inform
libv4l what image flipping options are needed.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
---
This version adds locking around the USB operations and hopefully incorporates all
suggested changes that I haven't posted a reason for not implementing. Also increased
the data timeout as Theodore found some cameras misbehaved otherwise, especially if
streaming from 2 cameras simultaneously.
---
diff -r 8c8bf45f5b40 linux/drivers/media/video/gspca/Kconfig
--- a/linux/drivers/media/video/gspca/Kconfig	Thu Feb 05 19:12:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/Kconfig	Thu Feb 05 21:42:19 2009 +0000
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
diff -r 8c8bf45f5b40 linux/drivers/media/video/gspca/Makefile
--- a/linux/drivers/media/video/gspca/Makefile	Thu Feb 05 19:12:24 2009 +0100
+++ b/linux/drivers/media/video/gspca/Makefile	Thu Feb 05 21:42:19 2009 +0000
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
diff -r 8c8bf45f5b40 linux/drivers/media/video/gspca/sq905.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/sq905.c	Thu Feb 05 21:42:19 2009 +0000
@@ -0,0 +1,438 @@
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
+ * Marcell Lengyel and furter developed by many other contributers
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
+#define SQ905_DATA_TIMEOUT 1000
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
+/* Structure to hold all of our device specific stuff */
+struct sd {
+	struct gspca_dev gspca_dev;	/* !! must be the first item */
+
+	u8 cam_type;
+
+	/*
+	 * Driver stuff
+	 */
+	struct work_struct work_struct;
+	struct workqueue_struct *work_thread;
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
+struct cam_type {
+	u32 ident_word;
+	char *name;
+	struct v4l2_pix_format *min_mode;
+	u8 num_modes;
+	u8 sensor_flags;
+};
+
+#define SQ905_FLIP_HORIZ (1 << 0)
+#define SQ905_FLIP_VERT  (1 << 1)
+
+/* Last entry is default if nothing else matches */
+static struct cam_type cam_types[] = {
+	{ 0x19010509, "PocketCam", &sq905_mode[0], 1, SQ905_FLIP_HORIZ },
+	{ 0x32010509, "Magpix", &sq905_mode[0], 1, SQ905_FLIP_HORIZ },
+	{ 0, "Default", &sq905_mode[0], 1, SQ905_FLIP_HORIZ | SQ905_FLIP_VERT }
+};
+
+/*
+ * Send a command to the camera.
+ */
+static int sq905_command(struct gspca_dev *gspca_dev, u16 index)
+{
+	int ret;
+
+	gspca_dev->usb_buf[0] = '\0';
+	ret = usb_control_msg(gspca_dev->dev,
+			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_COMMAND, index, gspca_dev->usb_buf, 1,
+			      SQ905_CMD_TIMEOUT);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "%s: usb_control_msg failed (%d)",
+			__func__, ret);
+		return ret;
+	}
+
+	ret = usb_control_msg(gspca_dev->dev,
+			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_PING, 0, gspca_dev->usb_buf, 1,
+			      SQ905_CMD_TIMEOUT);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "%s: usb_control_msg failed 2 (%d)",
+			__func__, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Acknowledge the end of a frame - see warning on sq905_command.
+ */
+static int sq905_ack_frame(struct gspca_dev *gspca_dev)
+{
+	int ret;
+
+	gspca_dev->usb_buf[0] = '\0';
+	ret = usb_control_msg(gspca_dev->dev,
+			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_READ_DONE, 0, gspca_dev->usb_buf, 1,
+			      SQ905_CMD_TIMEOUT);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "%s: usb_control_msg failed (%d)", __func__, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ *  request and read a block of data - see warning on sq905_command.
+ */
+static int
+sq905_read_data(struct gspca_dev *gspca_dev, u8 *data, int size)
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
+	if (ret < 0) {
+		PDEBUG(D_ERR, "%s: usb_control_msg failed (%d)", __func__, ret);
+		return ret;
+	}
+	ret = usb_bulk_msg(gspca_dev->dev,
+			   usb_rcvbulkpipe(gspca_dev->dev, 0x81),
+			   data, size, &act_len, SQ905_DATA_TIMEOUT);
+
+	/* successful, it returns 0, otherwise  negative */
+	if (ret < 0 || act_len != size) {
+		PDEBUG(D_ERR, "bulk read fail (%d) len %d/%d",
+			ret, act_len, size);
+		return -EIO;
+	}
+	return 0;
+}
+
+/* This function is called as a workqueue function and runs whenever the camera
+ * is streaming data. Because it is a workqueue function it is allowed to sleep
+ * so we can use synchronous USB calls. To avoid possible collisions with other
+ * threads attempting to use the camera's USB interface we take the gspca
+ * usb_lock when performing USB operations. In practice the only thing we need
+ * to protect against is the usb_set_interface call that gspca makes during
+ * stream_off as the camera doesn't provide any controls that the user could try
+ * to change.
+ */
+static void sq905_dostream(struct work_struct *work)
+{
+	struct sd *dev = container_of(work, struct sd, work_struct);
+	struct gspca_dev *gspca_dev = &dev->gspca_dev;
+	struct gspca_frame *frame;
+	int bytes_left; /* bytes remaining in current frame. */
+	int data_len;   /* size to use for the next read. */
+	int header_read; /* true if we have already read the frame header. */
+	int discarding; /* true if we failed to get space for frame. */
+	int packet_type;
+	int ret;
+	u8 *data;
+	u8 *buffer;
+
+	buffer = kmalloc(SQ905_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
+	mutex_lock(&gspca_dev->usb_lock);
+	if (!buffer) {
+		PDEBUG(D_ERR, "Couldn't allocate USB buffer");
+		goto quit_stream;
+	}
+
+	while (gspca_dev->present && gspca_dev->streaming) {
+		/* Need a short delay to ensure streaming flag was set by
+		 * gspca and to make sure gspca can grab the mutex. */
+		mutex_unlock(&gspca_dev->usb_lock);
+		msleep(1);
+
+		/* request some data and then read it until we have
+		 * a complete frame. */
+		bytes_left = sq905_mode[0].sizeimage + FRAME_HEADER_LEN;
+		header_read = 0;
+		discarding = 0;
+
+		while (bytes_left > 0) {
+			data_len = bytes_left > SQ905_MAX_TRANSFER ?
+				SQ905_MAX_TRANSFER : bytes_left;
+			mutex_lock(&gspca_dev->usb_lock);
+			if (!gspca_dev->present)
+				goto quit_stream;
+			ret = sq905_read_data(gspca_dev, buffer, data_len);
+			if (ret < 0)
+				goto quit_stream;
+			mutex_unlock(&gspca_dev->usb_lock);
+			PDEBUG(D_STREAM,
+				"Got %d bytes out of %d for frame",
+				data_len, bytes_left);
+			bytes_left -= data_len;
+			data = buffer;
+			if (!header_read) {
+				packet_type = FIRST_PACKET;
+				/* The first 64 bytes of each frame are
+				 * a header full of FF 00 bytes */
+				data += FRAME_HEADER_LEN;
+				data_len -= FRAME_HEADER_LEN;
+				header_read = 1;
+			} else if (bytes_left == 0) {
+				packet_type = LAST_PACKET;
+			} else {
+				packet_type = INTER_PACKET;
+			}
+			frame = gspca_get_i_frame(gspca_dev);
+			if (frame && !discarding)
+				gspca_frame_add(gspca_dev, packet_type,
+						frame, data, data_len);
+			else
+				discarding = 1;
+		}
+		/* acknowledge the frame */
+		mutex_lock(&gspca_dev->usb_lock);
+		if (!gspca_dev->present)
+			goto quit_stream;
+		ret = sq905_ack_frame(gspca_dev);
+		if (ret < 0)
+			goto quit_stream;
+	}
+quit_stream:
+	/* the usb_lock is already acquired */
+	if (gspca_dev->present)
+		sq905_command(gspca_dev, SQ905_CLEAR);
+	mutex_unlock(&gspca_dev->usb_lock);
+	kfree(buffer);
+}
+
+/* This function is called at probe time just before sd_init */
+static int sd_config(struct gspca_dev *gspca_dev,
+		const struct usb_device_id *id)
+{
+	struct cam *cam = &gspca_dev->cam;
+	struct sd *dev = (struct sd *) gspca_dev;
+
+	cam->cam_mode = sq905_mode;
+	cam->nmodes = 1;
+	/* We don't use the buffer gspca allocates so make it small. */
+	cam->bulk_size = 64;
+
+	INIT_WORK(&dev->work_struct, sq905_dostream);
+
+	return 0;
+}
+
+/* called on streamoff with alt==0 and on disconnect */
+/* the usb_lock is held at entry - restore on exit */
+static void sd_stop0(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+
+	/* wait for the work queue to terminate */
+	mutex_unlock(&gspca_dev->usb_lock);
+	/* This waits for sq905_dostream to finish */
+	destroy_workqueue(dev->work_thread);
+	dev->work_thread = NULL;
+	mutex_lock(&gspca_dev->usb_lock);
+}
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+	u32 ident;
+	int ret;
+
+	/* connect to the camera and read
+	 * the model ID and process that and put it away.
+	 */
+	ret = sq905_command(gspca_dev, SQ905_CLEAR);
+	if (ret < 0)
+		return ret;
+	ret = sq905_command(gspca_dev, SQ905_ID);
+	if (ret < 0)
+		return ret;
+	ret = sq905_read_data(gspca_dev, gspca_dev->usb_buf, 4);
+	if (ret < 0)
+		return ret;
+	/* usb_buf is allocated with kmalloc so is aligned. */
+	ident = le32_to_cpup((u32 *)gspca_dev->usb_buf);
+	ret = sq905_command(gspca_dev, SQ905_CLEAR);
+	if (ret < 0)
+		return ret;
+	dev->cam_type = 0;
+	while (dev->cam_type < ARRAY_SIZE(cam_types) - 1 &&
+	       ident != cam_types[dev->cam_type].ident_word)
+		dev->cam_type++;
+	PDEBUG(D_CONF, "SQ905 camera %s, ID %08x detected",
+	       cam_types[dev->cam_type].name, ident);
+	return 0;
+}
+
+/* Set up for getting frames. */
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+	int ret;
+
+	/* "Open the shutter" and set size, to start capture */
+	ret = sq905_command(&dev->gspca_dev, SQ905_CAPTURE_MED);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "Start streaming command failed");
+		return ret;
+	}
+
+	/* Start the workqueue function to do the streaming */
+	dev->work_thread = create_singlethread_workqueue(MODULE_NAME);
+	queue_work(dev->work_thread, &dev->work_struct);
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
+	.name   = MODULE_NAME,
+	.config = sd_config,
+	.init   = sd_init,
+	.start  = sd_start,
+	.stop0  = sd_stop0,
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
+	.name       = MODULE_NAME,
+	.id_table   = device_table,
+	.probe      = sd_probe,
+	.disconnect = gspca_disconnect,
+#ifdef CONFIG_PM
+	.suspend = gspca_suspend,
+	.resume  = gspca_resume,
+#endif
+};
+
+/* -- module insert / remove -- */
+static int __init sd_mod_init(void)
+{
+	int ret;
+
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
+		return ret;
+	PDEBUG(D_PROBE, "registered");
+	return 0;
+}
+
+static void __exit sd_mod_exit(void)
+{
+	usb_deregister(&sd_driver);
+	PDEBUG(D_PROBE, "deregistered");
+}
+
+module_init(sd_mod_init);
+module_exit(sd_mod_exit);
