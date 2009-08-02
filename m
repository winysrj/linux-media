Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:40981 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbZHBUWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 16:22:23 -0400
Date: Sun, 2 Aug 2009 15:37:35 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Jean-Francois Moine <moinejf@free.fr>
cc: Andy Walls <awalls@radix.net>,
	Matthias Huber <matthias.huber@wollishausen.de>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
 (resubmit)
In-Reply-To: <20090802103350.19657a07@tele>
Message-ID: <alpine.LNX.2.00.0908021525550.12884@banach.math.auburn.edu>
References: <20090418183124.1c9160e3@free.fr> <alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu> <20090802103350.19657a07@tele>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-1133453164-1249245317=:12884"
Content-ID: <alpine.LNX.2.00.0908021535340.12884@banach.math.auburn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-1133453164-1249245317=:12884
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.0908021535341.12884@banach.math.auburn.edu>



On Sun, 2 Aug 2009, Jean-Francois Moine wrote:

> On Sat, 1 Aug 2009 16:56:06 -0500 (CDT)
> Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:
>
>> Several cameras are supported here, which all share the same USB
>> Vendor:Product number when started up in streaming mode. All of these
>> cameras use bulk transport for streaming, and all of them produce
>> frames in JPEG format.
>
> Hi Theodore,
>
> Your patch seems ok, but:
>
> - there is no kfree(sd->jpeg_hdr). Should be in stop0().
>
> - as there is only one vend:prod, one line is enough in gspca.txt.
>
> May you fix this and resend?
>
> Thanks.
>
> -- 
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Jean-Francois,

The version below should meet your objections. The memory for the header 
is freed, and I keep only one entry for the USB ID in gspca.txt. After 
some deliberation, I decided to keep the entry for the Sakar camera 
(belongs to Andy Walls), as that seems to be the one which was most 
recently purchased.

At the same time, I hope very much that the points which I have raised 
in my previous response in regard to documentation can be seriously 
discussed. As I see it, there is a problem about documentation.

Theodore Kilgore

Patch follows.

Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>

----------------
diff -r d189fb4be712 linux/Documentation/video4linux/gspca.txt
--- a/linux/Documentation/video4linux/gspca.txt	Wed Jul 29 10:01:54 2009 +0200
+++ b/linux/Documentation/video4linux/gspca.txt	Sun Aug 02 14:12:25 2009 -0500
@@ -239,6 +239,7 @@
  pac7311		093a:2629	Genious iSlim 300
  pac7311		093a:262a	Webcam 300k
  pac7311		093a:262c	Philips SPC 230 NC
+jeilinj		0979:0280	Sakar 57379
  zc3xx		0ac8:0302	Z-star Vimicro zc0302
  vc032x		0ac8:0321	Vimicro generic vc0321
  vc032x		0ac8:0323	Vimicro Vc0323
diff -r d189fb4be712 linux/drivers/media/video/gspca/Kconfig
--- a/linux/drivers/media/video/gspca/Kconfig	Wed Jul 29 10:01:54 2009 +0200
+++ b/linux/drivers/media/video/gspca/Kconfig	Sun Aug 02 14:12:25 2009 -0500
@@ -47,6 +47,15 @@
  	  To compile this driver as a module, choose M here: the
  	  module will be called gspca_finepix.

+config USB_GSPCA_JEILINJ
+	tristate "Jeilin JPEG USB V4L2 driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for cameras based on this Jeilin chip.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_jeilinj.
+
  config USB_GSPCA_MARS
  	tristate "Mars USB Camera Driver"
  	depends on VIDEO_V4L2 && USB_GSPCA
diff -r d189fb4be712 linux/drivers/media/video/gspca/Makefile
--- a/linux/drivers/media/video/gspca/Makefile	Wed Jul 29 10:01:54 2009 +0200
+++ b/linux/drivers/media/video/gspca/Makefile	Sun Aug 02 14:12:25 2009 -0500
@@ -2,6 +2,7 @@
  obj-$(CONFIG_USB_GSPCA_CONEX)    += gspca_conex.o
  obj-$(CONFIG_USB_GSPCA_ETOMS)    += gspca_etoms.o
  obj-$(CONFIG_USB_GSPCA_FINEPIX)  += gspca_finepix.o
+obj-$(CONFIG_USB_GSPCA_JEILINJ)  += gspca_jeilinj.o
  obj-$(CONFIG_USB_GSPCA_MARS)     += gspca_mars.o
  obj-$(CONFIG_USB_GSPCA_MR97310A) += gspca_mr97310a.o
  obj-$(CONFIG_USB_GSPCA_OV519)    += gspca_ov519.o
@@ -30,6 +31,7 @@
  gspca_conex-objs    := conex.o
  gspca_etoms-objs    := etoms.o
  gspca_finepix-objs  := finepix.o
+gspca_jeilinj-objs  := jeilinj.o
  gspca_mars-objs     := mars.o
  gspca_mr97310a-objs := mr97310a.o
  gspca_ov519-objs    := ov519.o
diff -r d189fb4be712 linux/drivers/media/video/gspca/jeilinj.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/jeilinj.c	Sun Aug 02 14:12:25 2009 -0500
@@ -0,0 +1,388 @@
+/*
+ * Jeilinj subdriver
+ *
+ * Supports some Jeilin dual-mode cameras which use bulk transport and
+ * download raw JPEG data.
+ *
+ * Copyright (C) 2009 Theodore Kilgore
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
+#define MODULE_NAME "jeilinj"
+
+#include <linux/workqueue.h>
+#include "gspca.h"
+#include "jpeg.h"
+
+MODULE_AUTHOR("Theodore Kilgore <kilgota@auburn.edu>");
+MODULE_DESCRIPTION("GSPCA/JEILINJ USB Camera Driver");
+MODULE_LICENSE("GPL");
+
+/* Default timeouts, in ms */
+#define JEILINJ_CMD_TIMEOUT 500
+#define JEILINJ_DATA_TIMEOUT 1000
+
+/* Maximum transfer size to use. */
+#define JEILINJ_MAX_TRANSFER 0x200
+
+#define FRAME_HEADER_LEN 0x10
+
+/* Structure to hold all of our device specific stuff */
+struct sd {
+	struct gspca_dev gspca_dev;	/* !! must be the first item */
+	const struct v4l2_pix_format *cap_mode;
+	/* Driver stuff */
+	struct work_struct work_struct;
+	struct workqueue_struct *work_thread;
+	u8 quality;				 /* image quality */
+	u8 jpegqual;				/* webcam quality */
+	u8 *jpeg_hdr;
+};
+
+	struct jlj_command {
+		unsigned char instruction[2];
+		unsigned char ack_wanted;
+	};
+
+/* AFAICT these cameras will only do 320x240. */
+static struct v4l2_pix_format jlj_mode[] = {
+	{ 320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
+		.bytesperline = 320,
+		.sizeimage = 320 * 240,
+		.colorspace = V4L2_COLORSPACE_JPEG,
+		.priv = 0}
+};
+
+/*
+ * cam uses endpoint 0x03 to send commands, 0x84 for read commands,
+ * and 0x82 for bulk transfer.
+ */
+
+/* All commands are two bytes only */
+static int jlj_write2(struct gspca_dev *gspca_dev, unsigned char *command)
+{
+	int retval;
+
+	memcpy(gspca_dev->usb_buf, command, 2);
+	retval = usb_bulk_msg(gspca_dev->dev,
+			usb_sndbulkpipe(gspca_dev->dev, 3),
+			gspca_dev->usb_buf, 2, NULL, 500);
+	if (retval < 0)
+		PDEBUG(D_ERR, "command write [%02x] error %d",
+				gspca_dev->usb_buf[0], retval);
+	return retval;
+}
+
+/* Responses are one byte only */
+static int jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
+{
+	int retval;
+
+	retval = usb_bulk_msg(gspca_dev->dev,
+	usb_rcvbulkpipe(gspca_dev->dev, 0x84),
+				gspca_dev->usb_buf, 1, NULL, 500);
+	response = gspca_dev->usb_buf[0];
+	if (retval < 0)
+		PDEBUG(D_ERR, "read command [%02x] error %d",
+				gspca_dev->usb_buf[0], retval);
+	return retval;
+}
+
+static int jlj_start(struct gspca_dev *gspca_dev)
+{
+	int i;
+	int retval = -1;
+	u8 response = 0xff;
+	struct jlj_command start_commands[] = {
+		{{0x71, 0x81}, 0},
+		{{0x70, 0x05}, 0},
+		{{0x95, 0x70}, 1},
+		{{0x71, 0x81}, 0},
+		{{0x70, 0x04}, 0},
+		{{0x95, 0x70}, 1},
+		{{0x71, 0x00}, 0},
+		{{0x70, 0x08}, 0},
+		{{0x95, 0x70}, 1},
+		{{0x94, 0x02}, 0},
+		{{0xde, 0x24}, 0},
+		{{0x94, 0x02}, 0},
+		{{0xdd, 0xf0}, 0},
+		{{0x94, 0x02}, 0},
+		{{0xe3, 0x2c}, 0},
+		{{0x94, 0x02}, 0},
+		{{0xe4, 0x00}, 0},
+		{{0x94, 0x02}, 0},
+		{{0xe5, 0x00}, 0},
+		{{0x94, 0x02}, 0},
+		{{0xe6, 0x2c}, 0},
+		{{0x94, 0x03}, 0},
+		{{0xaa, 0x00}, 0},
+		{{0x71, 0x1e}, 0},
+		{{0x70, 0x06}, 0},
+		{{0x71, 0x80}, 0},
+		{{0x70, 0x07}, 0}
+	};
+	for (i = 0; i < ARRAY_SIZE(start_commands); i++) {
+		retval = jlj_write2(gspca_dev, start_commands[i].instruction);
+		if (retval < 0)
+			return retval;
+		if (start_commands[i].ack_wanted)
+			retval = jlj_read1(gspca_dev, response);
+		if (retval < 0)
+			return retval;
+	}
+	PDEBUG(D_ERR, "jlj_start retval is %d", retval);
+	return retval;
+}
+
+static int jlj_stop(struct gspca_dev *gspca_dev)
+{
+	int i;
+	int retval;
+	struct jlj_command stop_commands[] = {
+		{{0x71, 0x00}, 0},
+		{{0x70, 0x09}, 0},
+		{{0x71, 0x80}, 0},
+		{{0x70, 0x05}, 0}
+	};
+	for (i = 0; i < ARRAY_SIZE(stop_commands); i++) {
+		retval = jlj_write2(gspca_dev, stop_commands[i].instruction);
+		if (retval < 0)
+			return retval;
+	}
+	return retval;
+}
+
+/* This function is called as a workqueue function and runs whenever the camera
+ * is streaming data. Because it is a workqueue function it is allowed to sleep
+ * so we can use synchronous USB calls. To avoid possible collisions with other
+ * threads attempting to use the camera's USB interface the gspca usb_lock is
+ * used when performing the one USB control operation inside the workqueue,
+ * which tells the camera to close the stream. In practice the only thing
+ * which needs to be protected against is the usb_set_interface call that
+ * gspca makes during stream_off. Otherwise the camera doesn't provide any
+ * controls that the user could try to change.
+ */
+
+static void jlj_dostream(struct work_struct *work)
+{
+	struct sd *dev = container_of(work, struct sd, work_struct);
+	struct gspca_dev *gspca_dev = &dev->gspca_dev;
+	struct gspca_frame *frame;
+	int blocks_left; /* 0x200-sized blocks remaining in current frame. */
+	int size_in_blocks;
+	int act_len;
+	int discarding = 0; /* true if we failed to get space for frame. */
+	int packet_type;
+	int ret;
+	u8 *buffer;
+
+	buffer = kmalloc(JEILINJ_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
+	if (!buffer) {
+		PDEBUG(D_ERR, "Couldn't allocate USB buffer");
+		goto quit_stream;
+	}
+	while (gspca_dev->present && gspca_dev->streaming) {
+		if (!gspca_dev->present)
+			goto quit_stream;
+		/* Start a new frame, and add the JPEG header, first thing */
+		frame = gspca_get_i_frame(gspca_dev);
+		if (frame && !discarding)
+			gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
+					dev->jpeg_hdr, JPEG_HDR_SZ);
+		 else
+			discarding = 1;
+		/*
+		 * Now request data block 0. Line 0 reports the size
+		 * to download, in blocks of size 0x200, and also tells the
+		 * "actual" data size, in bytes, which seems best to ignore.
+		 */
+		ret = usb_bulk_msg(gspca_dev->dev,
+				usb_rcvbulkpipe(gspca_dev->dev, 0x82),
+				buffer, JEILINJ_MAX_TRANSFER, &act_len,
+				JEILINJ_DATA_TIMEOUT);
+		PDEBUG(D_STREAM,
+			"Got %d bytes out of %d for Block 0",
+			act_len, JEILINJ_MAX_TRANSFER);
+		if (ret < 0 || act_len < FRAME_HEADER_LEN)
+			goto quit_stream;
+		size_in_blocks = buffer[0x0a];
+		blocks_left = buffer[0x0a] - 1;
+		PDEBUG(D_STREAM, "blocks_left = 0x%x", blocks_left);
+		packet_type = INTER_PACKET;
+		if (frame && !discarding)
+			/* Toss line 0 of data block 0, keep the rest. */
+			gspca_frame_add(gspca_dev, packet_type,
+				frame, buffer + FRAME_HEADER_LEN,
+				JEILINJ_MAX_TRANSFER - FRAME_HEADER_LEN);
+			else
+				discarding = 1;
+		while (blocks_left > 0) {
+			if (!gspca_dev->present)
+				goto quit_stream;
+			ret = usb_bulk_msg(gspca_dev->dev,
+				usb_rcvbulkpipe(gspca_dev->dev, 0x82),
+				buffer, JEILINJ_MAX_TRANSFER, &act_len,
+				JEILINJ_DATA_TIMEOUT);
+			if (ret < 0 || act_len < JEILINJ_MAX_TRANSFER)
+				goto quit_stream;
+			PDEBUG(D_STREAM,
+				"%d blocks remaining for frame", blocks_left);
+			blocks_left -= 1;
+			if (blocks_left == 0)
+				packet_type = LAST_PACKET;
+			else
+				packet_type = INTER_PACKET;
+			if (frame && !discarding)
+				gspca_frame_add(gspca_dev, packet_type,
+						frame, buffer,
+						JEILINJ_MAX_TRANSFER);
+			else
+				discarding = 1;
+		}
+	}
+quit_stream:
+	mutex_lock(&gspca_dev->usb_lock);
+	if (gspca_dev->present)
+		jlj_stop(gspca_dev);
+	mutex_unlock(&gspca_dev->usb_lock);
+	kfree(buffer);
+}
+
+/* This function is called at probe time just before sd_init */
+static int sd_config(struct gspca_dev *gspca_dev,
+		const struct usb_device_id *id)
+{
+	struct cam *cam = &gspca_dev->cam;
+	struct sd *dev  = (struct sd *) gspca_dev;
+
+	dev->quality  = 85;
+	dev->jpegqual = 85;
+	PDEBUG(D_PROBE,
+		"JEILINJ camera detected"
+		" (vid/pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
+	cam->cam_mode = jlj_mode;
+	cam->nmodes = 1;
+	cam->bulk = 1;
+	/* We don't use the buffer gspca allocates so make it small. */
+	cam->bulk_size = 32;
+	INIT_WORK(&dev->work_struct, jlj_dostream);
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
+	/* This waits for jlj_dostream to finish */
+	destroy_workqueue(dev->work_thread);
+	dev->work_thread = NULL;
+	mutex_lock(&gspca_dev->usb_lock);
+	kfree(dev->jpeg_hdr);
+}
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	return 0;
+}
+
+/* Set up for getting frames. */
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+	int ret;
+
+	/* create the JPEG header */
+	dev->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
+	jpeg_define(dev->jpeg_hdr, gspca_dev->height, gspca_dev->width,
+			0x21);          /* JPEG 422 */
+	jpeg_set_qual(dev->jpeg_hdr, dev->quality);
+	PDEBUG(D_STREAM, "Start streaming at 320x240");
+	ret = jlj_start(gspca_dev);
+	if (ret < 0) {
+		PDEBUG(D_ERR, "Start streaming command failed");
+		return ret;
+	}
+	/* Start the workqueue function to do the streaming */
+	dev->work_thread = create_singlethread_workqueue(MODULE_NAME);
+	queue_work(dev->work_thread, &dev->work_struct);
+
+	return 0;
+}
+
+/* Table of supported USB devices */
+static const __devinitdata struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x0979, 0x0280)},
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
---863829203-1133453164-1249245317=:12884--
