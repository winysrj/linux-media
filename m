Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway09.websitewelcome.com ([70.85.130.13]:35866 "EHLO
	gateway09.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbaBDUj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Feb 2014 15:39:58 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway09.websitewelcome.com (Postfix) with ESMTP id 2D8E9753C7F98
	for <linux-media@vger.kernel.org>; Tue,  4 Feb 2014 14:18:27 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: removal of s2255_dmaqueue structure
Date: Tue,  4 Feb 2014 12:18:03 -0800
Message-Id: <1391545083-3897-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removal of unused and unnecessary s2255dma_queue structure.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index c6bdccc..5f09a56 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1,7 +1,7 @@
 /*
  *  s2255drv.c - a driver for the Sensoray 2255 USB video capture device
  *
- *   Copyright (C) 2007-2013 by Sensoray Company Inc.
+ *   Copyright (C) 2007-2014 by Sensoray Company Inc.
  *                              Dean Anderson
  *
  * Some video buffer code based on vivi driver:
@@ -52,7 +52,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 
-#define S2255_VERSION		"1.23.1"
+#define S2255_VERSION		"1.24.1"
 #define FIRMWARE_FILE_NAME "f2255usb.bin"
 
 /* default JPEG quality */
@@ -178,11 +178,6 @@ struct s2255_bufferi {
 			DEF_FDEC, DEF_BRIGHT, DEF_CONTRAST, DEF_SATURATION, \
 			DEF_HUE, 0, DEF_USB_BLOCK, 0}
 
-struct s2255_dmaqueue {
-	struct list_head	active;
-	struct s2255_dev	*dev;
-};
-
 /* for firmware loading, fw_state */
 #define S2255_FW_NOTLOADED	0
 #define S2255_FW_LOADED_DSPWAIT	1
@@ -223,7 +218,7 @@ struct s2255_channel {
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_ctrl	*jpegqual_ctrl;
 	int			resources;
-	struct s2255_dmaqueue	vidq;
+	struct list_head        buf_list;
 	struct s2255_bufferi	buffer;
 	struct s2255_mode	mode;
 	v4l2_std_id		std;
@@ -574,18 +569,17 @@ static void s2255_fwchunk_complete(struct urb *urb)
 
 static int s2255_got_frame(struct s2255_channel *channel, int jpgsize)
 {
-	struct s2255_dmaqueue *dma_q = &channel->vidq;
 	struct s2255_buffer *buf;
 	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
 	unsigned long flags = 0;
 	int rc = 0;
 	spin_lock_irqsave(&dev->slock, flags);
-	if (list_empty(&dma_q->active)) {
+	if (list_empty(&channel->buf_list)) {
 		dprintk(dev, 1, "No active queue to serve\n");
 		rc = -1;
 		goto unlock;
 	}
-	buf = list_entry(dma_q->active.next,
+	buf = list_entry(channel->buf_list.next,
 			 struct s2255_buffer, vb.queue);
 	list_del(&buf->vb.queue);
 	v4l2_get_timestamp(&buf->vb.ts);
@@ -747,10 +741,9 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	struct s2255_fh *fh = vq->priv_data;
 	struct s2255_channel *channel = fh->channel;
-	struct s2255_dmaqueue *vidq = &channel->vidq;
 	dprintk(fh->dev, 1, "%s\n", __func__);
 	buf->vb.state = VIDEOBUF_QUEUED;
-	list_add_tail(&buf->vb.queue, &vidq->active);
+	list_add_tail(&buf->vb.queue, &channel->buf_list);
 }
 
 static void buffer_release(struct videobuf_queue *vq,
@@ -1679,11 +1672,10 @@ static int __s2255_open(struct file *file)
 	}
 	dprintk(dev, 1, "%s: dev=%s type=%s\n", __func__,
 		video_device_node_name(vdev), v4l2_type_names[type]);
-	dprintk(dev, 2, "%s: fh=0x%08lx, dev=0x%08lx, vidq=0x%08lx\n", __func__,
-		(unsigned long)fh, (unsigned long)dev,
-		(unsigned long)&channel->vidq);
+	dprintk(dev, 2, "%s: fh=0x%08lx, dev=0x%08lx\n", __func__,
+		(unsigned long)fh, (unsigned long)dev);
 	dprintk(dev, 4, "%s: list_empty active=%d\n", __func__,
-		list_empty(&channel->vidq.active));
+		list_empty(&channel->buf_list));
 	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
 				    NULL, &dev->slock,
 				    fh->type,
@@ -1876,7 +1868,7 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 	/* register 4 video devices */
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		channel = &dev->channel[i];
-		INIT_LIST_HEAD(&channel->vidq.active);
+		INIT_LIST_HEAD(&channel->buf_list);
 
 		v4l2_ctrl_handler_init(&channel->hdl, 6);
 		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
@@ -1901,7 +1893,6 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 			dev_err(&dev->udev->dev, "couldn't register control\n");
 			break;
 		}
-		channel->vidq.dev = dev;
 		/* register 4 video devices */
 		channel->vdev = template;
 		channel->vdev.ctrl_handler = &channel->hdl;
-- 
1.7.9.5

