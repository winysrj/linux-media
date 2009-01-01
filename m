Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n010YHjN027940
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 19:34:17 -0500
Received: from mk-outboundfilter-5.mail.uk.tiscali.com
	(mk-outboundfilter-5.mail.uk.tiscali.com [212.74.114.1])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n010Y17k027561
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 19:34:02 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: "video4linux-list" <video4linux-list@redhat.com>
Date: Thu, 1 Jan 2009 00:33:57 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901010033.58093.linux@baker-net.org.uk>
Cc: kilgota@banach.math.auburn.edu, sqcam-devel@lists.sourceforge.net
Subject: [REVIEW] Driver for SQ-905 based cameras
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Theodore Kilgore and I now have a driver for cameras based on the 
SQ 905 chipset that is capable of producing images. It is based on gspca
and uses libv4l. Issues so far are

1) With the cameras used so far for testing the image is always upside down.
It is known that there are cameras that have different sensor layouts but without
a mechanism to communicate that layout to libv4l we can't do much more.
(Yes I have read Hans de Geode's posts about this but wanted to have a real 
driver to use as a basis before discussing further).

2) The code is all using the gspca PDEBUG macros not dev_err / dev_warn 
etc. As the rest of gspca seems to do the same I thought consistency was the 
best option but will change this on request.

3) There seem to be a limited selection of apps that work well with it even using 
the LD_PRELOAD tricks in libv4l but those that don't seem to misbehave similarly 
with a pac207 camera so I'm assumming the problem isn't with the sq905 
sub-driver (e.g. xawtv is always giving a green image).

4) Only a single resolution is supported. All sq905 cameras should support a
 lower resolution and some also support a higher resolution but I see support for
 that as something to worry about once the basic driver is accepted.

5) The patch below doesn't have a signed off by line attached, partly because 
I'm not sure the correct order to list signed-off-by for a patch with multiple authors 
but also because I'm expecting some comments back before it gets accepted.

6) I've fixed all the errors thrown up by make checkpatch but I haven't yet 
tried to run sparse on it.

The patch is against yesterday's gspca tree, changeset: 10164:6f3948c174c1

---

diff -r 6f3948c174c1 linux/drivers/media/video/gspca/Kconfig
--- a/linux/drivers/media/video/gspca/Kconfig	Wed Dec 31 18:33:53 2008 +0100
+++ b/linux/drivers/media/video/gspca/Kconfig	Thu Jan 01 00:16:28 2009 +0000
@@ -167,6 +167,15 @@ config USB_GSPCA_SPCA561
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
diff -r 6f3948c174c1 linux/drivers/media/video/gspca/Makefile
--- a/linux/drivers/media/video/gspca/Makefile	Wed Dec 31 18:33:53 2008 +0100
+++ b/linux/drivers/media/video/gspca/Makefile	Thu Jan 01 00:16:28 2009 +0000
@@ -16,6 +16,7 @@ obj-$(CONFIG_USB_GSPCA_SPCA508) += gspca
 obj-$(CONFIG_USB_GSPCA_SPCA508) += gspca_spca508.o
 obj-$(CONFIG_USB_GSPCA_SPCA561) += gspca_spca561.o
 obj-$(CONFIG_USB_GSPCA_SUNPLUS) += gspca_sunplus.o
+obj-$(CONFIG_USB_GSPCA_SQ905)	+= gspca_sq905.o
 obj-$(CONFIG_USB_GSPCA_STK014)	+= gspca_stk014.o
 obj-$(CONFIG_USB_GSPCA_T613)	+= gspca_t613.o
 obj-$(CONFIG_USB_GSPCA_TV8532)	+= gspca_tv8532.o
@@ -39,6 +40,7 @@ gspca_spca506-objs		:= spca506.o
 gspca_spca506-objs		:= spca506.o
 gspca_spca508-objs		:= spca508.o
 gspca_spca561-objs		:= spca561.o
+gspca_sq905-objs		:= sq905.o
 gspca_stk014-objs		:= stk014.o
 gspca_sunplus-objs		:= sunplus.o
 gspca_t613-objs			:= t613.o
diff -r 6f3948c174c1 linux/drivers/media/video/gspca/sq905.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/gspca/sq905.c	Thu Jan 01 00:16:28 2009 +0000
@@ -0,0 +1,381 @@
+/*
+ * SQ905 subdriver
+ *
+ * Copyright (C) 2008 Adam Baker and Theodore Kilgore
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
+#include "gspca.h"
+
+MODULE_AUTHOR("Adam Baker <linux@baker-net.org.uk>, "
+		"Theodore Kilgore <kilgota@auburn.edu>");
+MODULE_DESCRIPTION("GSPCA/SQ905 USB Camera Driver");
+MODULE_LICENSE("GPL");
+
+/* Default timeout, in ms */
+#define SQ905_TIMEOUT (HZ / 10)
+
+/* Maximum transfer size to use. The windows driver reads by chunks of
+ * 0x8000 bytes, so do the same. Note: reading more seems to work
+ * too. */
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
+	 * Driver stuff
+	 */
+	__u8 *buffer;
+	struct delayed_work wqe;
+	struct completion can_close;
+	int streaming;
+};
+
+/* These cameras only support 320x200. Actually not true but good for a start*/
+static struct v4l2_pix_format sq905_mode[1] = {
+	{ 320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
+		.bytesperline = 320,
+		.sizeimage = 320 * 240,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 0}
+};
+
+static int sq905_command(struct usb_device *dev, __u16 index)
+{
+	__u8 status;
+	int ret;
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_COMMAND, index, "\x0", 1, 500);
+	if (ret != 1) {
+		PDEBUG(D_ERR, "sq905_command: usb_control_msg failed (%d)",
+			ret);
+		return -EIO;
+	}
+
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_PING, 0, &status, 1, 500);
+	if (ret != 1) {
+		PDEBUG(D_ERR, "sq905_command: usb_control_msg failed 2 (%d)",
+			ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int sq905_ack_frame(struct usb_device *dev)
+{
+	int ret;
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_READ_DONE, 0, "\x0", 1, 500);
+	if (ret != 1) {
+		PDEBUG(D_ERR, "sq905_ack_frame: usb_ctrl_msg failed (%d)", ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int
+sq905_read_data(struct gspca_dev *gspca_dev, __u8 *data, int size)
+{
+	int ret;
+	int act_len;
+
+	if (!data) {
+		PDEBUG(D_ERR, "sq905_read_data: data pointer was NULL\n");
+		return -EINVAL;
+	}
+
+	ret = usb_control_msg(gspca_dev->dev,
+			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      USB_REQ_SYNCH_FRAME,                /* request */
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      SQ905_BULK_READ, size, "\x0", 1, 500);
+	if (ret != 1) {
+		PDEBUG(D_ERR, "sq905_read_data: usb_ctrl_msg failed (%d)", ret);
+		return -EIO;
+	}
+	ret = usb_bulk_msg(gspca_dev->dev,
+			   usb_rcvbulkpipe(gspca_dev->dev, 0x81),
+			   data, size, &act_len, 500);
+	/* successful, it returns 0, otherwise  negative */
+	if ((ret != 0) || (act_len != size)) {
+		PDEBUG(D_ERR, "sq905_read_data: bulk read fail (%d) len %d/%d",
+			ret, act_len, size);
+		return -EIO;
+	}
+	return 0;
+}
+
+/* This function is called as a workqueue function and runs whenever the camera
+ * is streaming data. Because it is a workqueue function it is allowed to sleep
+ * so we can use synchronous USB calls. There appears to be no reason to
+ * terminate before we stop streaming.
+ */
+static void sq905_dostream(struct work_struct *work)
+{
+	struct sd *dev = container_of(work, struct sd, wqe.work);
+	struct gspca_frame *frame;
+	int bytes_left; /* bytes remaining in current frame. */
+	int data_len;   /* size to use for the next read. */
+	int header_read; /* true if we have already read the frame header. */
+	int discarding; /* true if we failed to get space for frame. */
+	int packet_type;
+	__u8 *data;
+
+	while ((dev->gspca_dev.present) && (dev->streaming)) {
+		/* request some data and then read it until we have
+		 * a complete frame. */
+		bytes_left = sq905_mode[0].sizeimage + FRAME_HEADER_LEN;
+		header_read = 0;
+		discarding = 0;
+
+		while (bytes_left > 0) {
+			data_len = bytes_left > SQ905_MAX_TRANSFER  ?
+				SQ905_MAX_TRANSFER : bytes_left;
+			if (sq905_read_data(&dev->gspca_dev, dev->buffer,
+					 data_len) == 0) {
+				PDEBUG(D_STREAM,
+					"Got %d bytes out of %d for frame",
+					data_len, bytes_left);
+				bytes_left -= data_len;
+				data = dev->buffer;
+				if (!header_read) {
+					packet_type = FIRST_PACKET;
+					/* The first 64 bytes of each frame are
+					 * a header of unknown format */
+					data += FRAME_HEADER_LEN;
+					data_len -= FRAME_HEADER_LEN;
+					header_read = 1;
+				} else if (bytes_left == 0) {
+					packet_type = LAST_PACKET;
+				} else {
+					packet_type = INTER_PACKET;
+				}
+				frame = gspca_get_i_frame(&dev->gspca_dev);
+				if (frame &&  !discarding)
+					gspca_frame_add(&dev->gspca_dev,
+						packet_type, frame,
+						data, data_len);
+				else
+					discarding = 1;
+			} else {
+				/* shut down if we got a USB error. */
+				dev->streaming = 0;
+			}
+		}
+		/* acknowledge the frame */
+		sq905_ack_frame(dev->gspca_dev.dev);
+	}
+	complete(&dev->can_close);
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
+	cam->bulk_size = SQ905_MAX_TRANSFER; /* Mention here, use everywhere! */
+	/* Gives the number of altsettings. There is only one. */
+	gspca_dev->nbalt = 1;	/* use bulk transfer */
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
+	/* wait for the work queue to terminate */
+	wait_for_completion(&dev->can_close);
+}
+
+/* called on streamoff with alt 0 and disconnect */
+static void sd_stop0(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+	sq905_command(gspca_dev->dev, SQ905_CLEAR);
+	kfree(dev->buffer);
+}
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	struct sd *dev = (struct sd *) gspca_dev;
+	INIT_DELAYED_WORK(&dev->wqe, sq905_dostream);
+
+	/* connect to the camera and read
+	 * the model ID and process that and put it away.
+	 */
+	sq905_command(gspca_dev->dev, SQ905_CLEAR);
+	sq905_command(gspca_dev->dev, SQ905_ID);
+	sq905_read_data(gspca_dev, gspca_dev->usb_buf, 4);
+	sq905_command(gspca_dev->dev, SQ905_CLEAR);
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
+	dev->buffer = kmalloc(SQ905_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
+	if (!dev->buffer) {
+		PDEBUG(D_ERR, "Couldn't allocate USB buffer\n");
+		return -ENOMEM;
+	}
+	init_completion(&dev->can_close);
+	dev->streaming = 1;
+
+	/* "Open the shutter" and set size, to start capture */
+	if (sq905_command(gspca_dev->dev, SQ905_CAPTURE_MED)) {
+		PDEBUG(D_ERR, "Start streaming command failed\n");
+		dev->streaming = 0;
+		return -EIO;
+	}
+	/* Start the workqueue function to do the streaming */
+	schedule_delayed_work(&dev->wqe, 1);
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
+	.name = MODULE_NAME,
+	.config = sd_config,
+	.init = sd_init,
+	.start = sd_start,
+	.stopN = sd_stopN,
+	.stop0 = sd_stop0,
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
+	.name = MODULE_NAME,
+	.id_table = device_table,
+	.probe = sd_probe,
+	.disconnect = gspca_disconnect,
+#ifdef CONFIG_PM
+	.suspend = gspca_suspend,
+	.resume = gspca_resume,
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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
