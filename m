Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:46180 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaAGWOG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 17:14:06 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so468583eaj.37
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 14:14:04 -0800 (PST)
From: Federico Simoncelli <federico.simoncelli@gmail.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: m.chehab@samsung.com, lkundrak@v3.sk, hans.verkuil@cisco.com,
	Federico Simoncelli <fsimonce@redhat.com>
Subject: [PATCH 1/2] usbtv: split core and video implementation
Date: Tue,  7 Jan 2014 23:13:21 +0100
Message-Id: <1389132802-31200-1-git-send-email-federico.simoncelli@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Federico Simoncelli <fsimonce@redhat.com>

Signed-off-by: Federico Simoncelli <fsimonce@redhat.com>
Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/usb/usbtv/Makefile                   |   3 +
 drivers/media/usb/usbtv/usbtv-core.c               | 136 +++++++++++++++++
 drivers/media/usb/usbtv/{usbtv.c => usbtv-video.c} | 163 ++-------------------
 drivers/media/usb/usbtv/usbtv.h                    |  98 +++++++++++++
 4 files changed, 246 insertions(+), 154 deletions(-)
 create mode 100644 drivers/media/usb/usbtv/usbtv-core.c
 rename drivers/media/usb/usbtv/{usbtv.c => usbtv-video.c} (82%)
 create mode 100644 drivers/media/usb/usbtv/usbtv.h

diff --git a/drivers/media/usb/usbtv/Makefile b/drivers/media/usb/usbtv/Makefile
index 28b872f..775316a 100644
--- a/drivers/media/usb/usbtv/Makefile
+++ b/drivers/media/usb/usbtv/Makefile
@@ -1 +1,4 @@
+usbtv-y := usbtv-core.o \
+	usbtv-video.o
+
 obj-$(CONFIG_VIDEO_USBTV) += usbtv.o
diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
new file mode 100644
index 0000000..e89e48b
--- /dev/null
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -0,0 +1,136 @@
+/*
+ * Fushicai USBTV007 Video Grabber Driver
+ *
+ * Product web site:
+ * http://www.fushicai.com/products_detail/&productId=d05449ee-b690-42f9-a661-aa7353894bed.html
+ *
+ * Following LWN articles were very useful in construction of this driver:
+ * Video4Linux2 API series: http://lwn.net/Articles/203924/
+ * videobuf2 API explanation: http://lwn.net/Articles/447435/
+ * Thanks go to Jonathan Corbet for providing this quality documentation.
+ * He is awesome.
+ *
+ * Copyright (c) 2013 Lubomir Rintel
+ * All rights reserved.
+ * No physical hardware was harmed running Windows during the
+ * reverse-engineering activity
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL").
+ */
+
+#include <linux/module.h>
+
+#include "usbtv.h"
+
+int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size)
+{
+	int ret;
+	int pipe = usb_rcvctrlpipe(usbtv->udev, 0);
+	int i;
+
+	for (i = 0; i < size; i++) {
+		u16 index = regs[i][0];
+		u16 value = regs[i][1];
+
+		ret = usb_control_msg(usbtv->udev, pipe, USBTV_REQUEST_REG,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			value, index, NULL, 0, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int usbtv_probe(struct usb_interface *intf,
+	const struct usb_device_id *id)
+{
+	int ret;
+	int size;
+	struct device *dev = &intf->dev;
+	struct usbtv *usbtv;
+
+	/* Checks that the device is what we think it is. */
+	if (intf->num_altsetting != 2)
+		return -ENODEV;
+	if (intf->altsetting[1].desc.bNumEndpoints != 4)
+		return -ENODEV;
+
+	/* Packet size is split into 11 bits of base size and count of
+	 * extra multiplies of it.*/
+	size = usb_endpoint_maxp(&intf->altsetting[1].endpoint[0].desc);
+	size = (size & 0x07ff) * (((size & 0x1800) >> 11) + 1);
+
+	/* Device structure */
+	usbtv = kzalloc(sizeof(struct usbtv), GFP_KERNEL);
+	if (usbtv == NULL)
+		return -ENOMEM;
+	usbtv->dev = dev;
+	usbtv->udev = usb_get_dev(interface_to_usbdev(intf));
+
+	usbtv->iso_size = size;
+
+	usb_set_intfdata(intf, usbtv);
+
+	ret = usbtv_video_init(usbtv);
+	if (ret < 0)
+		goto usbtv_video_fail;
+
+	/* for simplicity we exploit the v4l2_device reference counting */
+	v4l2_device_get(&usbtv->v4l2_dev);
+
+	dev_info(dev, "Fushicai USBTV007 Video Grabber\n");
+	return 0;
+
+usbtv_video_fail:
+	kfree(usbtv);
+
+	return ret;
+}
+
+static void usbtv_disconnect(struct usb_interface *intf)
+{
+	struct usbtv *usbtv = usb_get_intfdata(intf);
+	usb_set_intfdata(intf, NULL);
+
+	if (!usbtv)
+		return;
+
+	usbtv_video_free(usbtv);
+
+	usb_put_dev(usbtv->udev);
+	usbtv->udev = NULL;
+
+	/* the usbtv structure will be deallocated when v4l2 will be
+	   done using it */
+	v4l2_device_put(&usbtv->v4l2_dev);
+}
+
+struct usb_device_id usbtv_id_table[] = {
+	{ USB_DEVICE(0x1b71, 0x3002) },
+	{}
+};
+MODULE_DEVICE_TABLE(usb, usbtv_id_table);
+
+MODULE_AUTHOR("Lubomir Rintel");
+MODULE_DESCRIPTION("Fushicai USBTV007 Video Grabber Driver");
+MODULE_LICENSE("Dual BSD/GPL");
+
+struct usb_driver usbtv_usb_driver = {
+	.name = "usbtv",
+	.id_table = usbtv_id_table,
+	.probe = usbtv_probe,
+	.disconnect = usbtv_disconnect,
+};
+
+module_usb_driver(usbtv_usb_driver);
diff --git a/drivers/media/usb/usbtv/usbtv.c b/drivers/media/usb/usbtv/usbtv-video.c
similarity index 82%
rename from drivers/media/usb/usbtv/usbtv.c
rename to drivers/media/usb/usbtv/usbtv-video.c
index 6222a4a..496bc2e 100644
--- a/drivers/media/usb/usbtv/usbtv.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -28,45 +28,10 @@
  * GNU General Public License ("GPL").
  */
 
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/usb.h>
-#include <linux/videodev2.h>
-
-#include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-core.h>
-#include <media/videobuf2-vmalloc.h>
-
-/* Hardware. */
-#define USBTV_VIDEO_ENDP	0x81
-#define USBTV_BASE		0xc000
-#define USBTV_REQUEST_REG	12
-
-/* Number of concurrent isochronous urbs submitted.
- * Higher numbers was seen to overly saturate the USB bus. */
-#define USBTV_ISOC_TRANSFERS	16
-#define USBTV_ISOC_PACKETS	8
-
-#define USBTV_CHUNK_SIZE	256
-#define USBTV_CHUNK		240
-
-/* Chunk header. */
-#define USBTV_MAGIC_OK(chunk)	((be32_to_cpu(chunk[0]) & 0xff000000) \
-							== 0x88000000)
-#define USBTV_FRAME_ID(chunk)	((be32_to_cpu(chunk[0]) & 0x00ff0000) >> 16)
-#define USBTV_ODD(chunk)	((be32_to_cpu(chunk[0]) & 0x0000f000) >> 15)
-#define USBTV_CHUNK_NO(chunk)	(be32_to_cpu(chunk[0]) & 0x00000fff)
-
-#define USBTV_TV_STD  (V4L2_STD_525_60 | V4L2_STD_PAL)
-
-/* parameters for supported TV norms */
-struct usbtv_norm_params {
-	v4l2_std_id norm;
-	int cap_width, cap_height;
-};
+
+#include "usbtv.h"
 
 static struct usbtv_norm_params norm_params[] = {
 	{
@@ -81,43 +46,6 @@ static struct usbtv_norm_params norm_params[] = {
 	}
 };
 
-/* A single videobuf2 frame buffer. */
-struct usbtv_buf {
-	struct vb2_buffer vb;
-	struct list_head list;
-};
-
-/* Per-device structure. */
-struct usbtv {
-	struct device *dev;
-	struct usb_device *udev;
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	struct vb2_queue vb2q;
-	struct mutex v4l2_lock;
-	struct mutex vb2q_lock;
-
-	/* List of videobuf2 buffers protected by a lock. */
-	spinlock_t buflock;
-	struct list_head bufs;
-
-	/* Number of currently processed frame, useful find
-	 * out when a new one begins. */
-	u32 frame_id;
-	int chunks_done;
-
-	enum {
-		USBTV_COMPOSITE_INPUT,
-		USBTV_SVIDEO_INPUT,
-	} input;
-	v4l2_std_id norm;
-	int width, height;
-	int n_chunks;
-	int iso_size;
-	unsigned int sequence;
-	struct urb *isoc_urbs[USBTV_ISOC_TRANSFERS];
-};
-
 static int usbtv_configure_for_norm(struct usbtv *usbtv, v4l2_std_id norm)
 {
 	int i, ret = 0;
@@ -142,26 +70,6 @@ static int usbtv_configure_for_norm(struct usbtv *usbtv, v4l2_std_id norm)
 	return ret;
 }
 
-static int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size)
-{
-	int ret;
-	int pipe = usb_rcvctrlpipe(usbtv->udev, 0);
-	int i;
-
-	for (i = 0; i < size; i++) {
-		u16 index = regs[i][0];
-		u16 value = regs[i][1];
-
-		ret = usb_control_msg(usbtv->udev, pipe, USBTV_REQUEST_REG,
-			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, index, NULL, 0, 0);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-
 static int usbtv_select_input(struct usbtv *usbtv, int input)
 {
 	int ret;
@@ -560,12 +468,6 @@ start_fail:
 	return ret;
 }
 
-struct usb_device_id usbtv_id_table[] = {
-	{ USB_DEVICE(0x1b71, 0x3002) },
-	{}
-};
-MODULE_DEVICE_TABLE(usb, usbtv_id_table);
-
 static int usbtv_querycap(struct file *file, void *priv,
 				struct v4l2_capability *cap)
 {
@@ -759,33 +661,9 @@ static void usbtv_release(struct v4l2_device *v4l2_dev)
 	kfree(usbtv);
 }
 
-static int usbtv_probe(struct usb_interface *intf,
-	const struct usb_device_id *id)
+int usbtv_video_init(struct usbtv *usbtv)
 {
 	int ret;
-	int size;
-	struct device *dev = &intf->dev;
-	struct usbtv *usbtv;
-
-	/* Checks that the device is what we think it is. */
-	if (intf->num_altsetting != 2)
-		return -ENODEV;
-	if (intf->altsetting[1].desc.bNumEndpoints != 4)
-		return -ENODEV;
-
-	/* Packet size is split into 11 bits of base size and count of
-	 * extra multiplies of it.*/
-	size = usb_endpoint_maxp(&intf->altsetting[1].endpoint[0].desc);
-	size = (size & 0x07ff) * (((size & 0x1800) >> 11) + 1);
-
-	/* Device structure */
-	usbtv = kzalloc(sizeof(struct usbtv), GFP_KERNEL);
-	if (usbtv == NULL)
-		return -ENOMEM;
-	usbtv->dev = dev;
-	usbtv->udev = usb_get_dev(interface_to_usbdev(intf));
-
-	usbtv->iso_size = size;
 
 	(void)usbtv_configure_for_norm(usbtv, V4L2_STD_525_60);
 
@@ -805,20 +683,18 @@ static int usbtv_probe(struct usb_interface *intf,
 	usbtv->vb2q.lock = &usbtv->vb2q_lock;
 	ret = vb2_queue_init(&usbtv->vb2q);
 	if (ret < 0) {
-		dev_warn(dev, "Could not initialize videobuf2 queue\n");
-		goto usbtv_fail;
+		dev_warn(usbtv->dev, "Could not initialize videobuf2 queue\n");
+		return ret;
 	}
 
 	/* v4l2 structure */
 	usbtv->v4l2_dev.release = usbtv_release;
-	ret = v4l2_device_register(dev, &usbtv->v4l2_dev);
+	ret = v4l2_device_register(usbtv->dev, &usbtv->v4l2_dev);
 	if (ret < 0) {
-		dev_warn(dev, "Could not register v4l2 device\n");
+		dev_warn(usbtv->dev, "Could not register v4l2 device\n");
 		goto v4l2_fail;
 	}
 
-	usb_set_intfdata(intf, usbtv);
-
 	/* Video structure */
 	strlcpy(usbtv->vdev.name, "usbtv", sizeof(usbtv->vdev.name));
 	usbtv->vdev.v4l2_dev = &usbtv->v4l2_dev;
@@ -832,52 +708,31 @@ static int usbtv_probe(struct usb_interface *intf,
 	video_set_drvdata(&usbtv->vdev, usbtv);
 	ret = video_register_device(&usbtv->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
-		dev_warn(dev, "Could not register video device\n");
+		dev_warn(usbtv->dev, "Could not register video device\n");
 		goto vdev_fail;
 	}
 
-	dev_info(dev, "Fushicai USBTV007 Video Grabber\n");
 	return 0;
 
 vdev_fail:
 	v4l2_device_unregister(&usbtv->v4l2_dev);
 v4l2_fail:
 	vb2_queue_release(&usbtv->vb2q);
-usbtv_fail:
-	kfree(usbtv);
 
 	return ret;
 }
 
-static void usbtv_disconnect(struct usb_interface *intf)
+void usbtv_video_free(struct usbtv *usbtv)
 {
-	struct usbtv *usbtv = usb_get_intfdata(intf);
-
 	mutex_lock(&usbtv->vb2q_lock);
 	mutex_lock(&usbtv->v4l2_lock);
 
 	usbtv_stop(usbtv);
-	usb_set_intfdata(intf, NULL);
 	video_unregister_device(&usbtv->vdev);
 	v4l2_device_disconnect(&usbtv->v4l2_dev);
-	usb_put_dev(usbtv->udev);
-	usbtv->udev = NULL;
 
 	mutex_unlock(&usbtv->v4l2_lock);
 	mutex_unlock(&usbtv->vb2q_lock);
 
 	v4l2_device_put(&usbtv->v4l2_dev);
 }
-
-MODULE_AUTHOR("Lubomir Rintel");
-MODULE_DESCRIPTION("Fushicai USBTV007 Video Grabber Driver");
-MODULE_LICENSE("Dual BSD/GPL");
-
-struct usb_driver usbtv_usb_driver = {
-	.name = "usbtv",
-	.id_table = usbtv_id_table,
-	.probe = usbtv_probe,
-	.disconnect = usbtv_disconnect,
-};
-
-module_usb_driver(usbtv_usb_driver);
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
new file mode 100644
index 0000000..536343d
--- /dev/null
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -0,0 +1,98 @@
+/*
+ * Fushicai USBTV007 Video Grabber Driver
+ *
+ * Copyright (c) 2013 Lubomir Rintel
+ * All rights reserved.
+ * No physical hardware was harmed running Windows during the
+ * reverse-engineering activity
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL").
+ */
+
+#include <linux/slab.h>
+#include <linux/usb.h>
+
+#include <media/v4l2-device.h>
+#include <media/videobuf2-vmalloc.h>
+
+/* Hardware. */
+#define USBTV_VIDEO_ENDP	0x81
+#define USBTV_BASE		0xc000
+#define USBTV_REQUEST_REG	12
+
+/* Number of concurrent isochronous urbs submitted.
+ * Higher numbers was seen to overly saturate the USB bus. */
+#define USBTV_ISOC_TRANSFERS	16
+#define USBTV_ISOC_PACKETS	8
+
+#define USBTV_CHUNK_SIZE	256
+#define USBTV_CHUNK		240
+
+/* Chunk header. */
+#define USBTV_MAGIC_OK(chunk)	((be32_to_cpu(chunk[0]) & 0xff000000) \
+							== 0x88000000)
+#define USBTV_FRAME_ID(chunk)	((be32_to_cpu(chunk[0]) & 0x00ff0000) >> 16)
+#define USBTV_ODD(chunk)	((be32_to_cpu(chunk[0]) & 0x0000f000) >> 15)
+#define USBTV_CHUNK_NO(chunk)	(be32_to_cpu(chunk[0]) & 0x00000fff)
+
+#define USBTV_TV_STD  (V4L2_STD_525_60 | V4L2_STD_PAL)
+
+/* parameters for supported TV norms */
+struct usbtv_norm_params {
+	v4l2_std_id norm;
+	int cap_width, cap_height;
+};
+
+/* A single videobuf2 frame buffer. */
+struct usbtv_buf {
+	struct vb2_buffer vb;
+	struct list_head list;
+};
+
+/* Per-device structure. */
+struct usbtv {
+	struct device *dev;
+	struct usb_device *udev;
+
+	/* video */
+	struct v4l2_device v4l2_dev;
+	struct video_device vdev;
+	struct vb2_queue vb2q;
+	struct mutex v4l2_lock;
+	struct mutex vb2q_lock;
+
+	/* List of videobuf2 buffers protected by a lock. */
+	spinlock_t buflock;
+	struct list_head bufs;
+
+	/* Number of currently processed frame, useful find
+	 * out when a new one begins. */
+	u32 frame_id;
+	int chunks_done;
+
+	enum {
+		USBTV_COMPOSITE_INPUT,
+		USBTV_SVIDEO_INPUT,
+	} input;
+	v4l2_std_id norm;
+	int width, height;
+	int n_chunks;
+	int iso_size;
+	unsigned int sequence;
+	struct urb *isoc_urbs[USBTV_ISOC_TRANSFERS];
+};
+
+int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size);
+
+int usbtv_video_init(struct usbtv *usbtv);
+void usbtv_video_free(struct usbtv *usbtv);
-- 
1.8.4.2

