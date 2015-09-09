Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:50969 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbbIILUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 07:20:04 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NUE00SIAQ5DP1B0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Sep 2015 20:20:01 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v4 3/8] [media] videobuf2: Restructure vb2_buffer (2/3)
Date: Wed, 09 Sep 2015 20:19:52 +0900
Message-id: <1441797597-17389-4-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com>
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify all device drivers related with previous change that restructures
vb2_buffer for common use.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/input/touchscreen/sur40.c                  |   17 ++++----
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   21 +++++----
 drivers/media/pci/cobalt/cobalt-driver.h           |    6 ++-
 drivers/media/pci/cobalt/cobalt-irq.c              |    7 +--
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   20 +++++----
 drivers/media/pci/cx23885/cx23885-417.c            |   11 +++--
 drivers/media/pci/cx23885/cx23885-core.c           |   24 +++++-----
 drivers/media/pci/cx23885/cx23885-dvb.c            |    9 ++--
 drivers/media/pci/cx23885/cx23885-vbi.c            |   16 ++++---
 drivers/media/pci/cx23885/cx23885-video.c          |   27 +++++++-----
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |   21 +++++----
 drivers/media/pci/cx25821/cx25821.h                |    3 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   13 +++---
 drivers/media/pci/cx88/cx88-core.c                 |    8 ++--
 drivers/media/pci/cx88/cx88-dvb.c                  |   11 +++--
 drivers/media/pci/cx88/cx88-mpeg.c                 |   14 +++---
 drivers/media/pci/cx88/cx88-vbi.c                  |   17 +++++---
 drivers/media/pci/cx88/cx88-video.c                |   19 ++++----
 drivers/media/pci/cx88/cx88.h                      |    2 +-
 drivers/media/pci/dt3155/dt3155.c                  |   17 ++++----
 drivers/media/pci/dt3155/dt3155.h                  |    3 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |   19 ++++----
 drivers/media/pci/saa7134/saa7134-core.c           |   14 +++---
 drivers/media/pci/saa7134/saa7134-ts.c             |   14 +++---
 drivers/media/pci/saa7134/saa7134-vbi.c            |   10 +++--
 drivers/media/pci/saa7134/saa7134-video.c          |   21 +++++----
 drivers/media/pci/saa7134/saa7134.h                |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   46 +++++++++++---------
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   19 ++++----
 drivers/media/pci/solo6x10/solo6x10.h              |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   12 ++---
 drivers/media/pci/tw68/tw68-video.c                |   19 ++++----
 drivers/media/pci/tw68/tw68.h                      |    3 +-
 drivers/media/usb/airspy/airspy.c                  |   24 +++++-----
 drivers/media/usb/au0828/au0828-vbi.c              |    7 +--
 drivers/media/usb/au0828/au0828-video.c            |   45 ++++++++++---------
 drivers/media/usb/au0828/au0828.h                  |    3 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    7 +--
 drivers/media/usb/em28xx/em28xx-video.c            |   34 +++++++++------
 drivers/media/usb/em28xx/em28xx.h                  |    3 +-
 drivers/media/usb/go7007/go7007-driver.c           |   29 ++++++------
 drivers/media/usb/go7007/go7007-priv.h             |    2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   20 +++++----
 drivers/media/usb/hackrf/hackrf.c                  |   22 ++++++----
 drivers/media/usb/msi2500/msi2500.c                |   17 +++++---
 drivers/media/usb/pwc/pwc-if.c                     |   33 +++++++++-----
 drivers/media/usb/pwc/pwc-uncompress.c             |    6 +--
 drivers/media/usb/pwc/pwc.h                        |    4 +-
 drivers/media/usb/s2255/s2255drv.c                 |   27 +++++++-----
 drivers/media/usb/stk1160/stk1160-v4l.c            |   15 ++++---
 drivers/media/usb/stk1160/stk1160-video.c          |   12 ++---
 drivers/media/usb/stk1160/stk1160.h                |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   19 ++++----
 drivers/media/usb/usbtv/usbtv.h                    |    3 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   26 ++++++-----
 drivers/media/usb/uvc/uvc_video.c                  |   20 ++++-----
 drivers/media/usb/uvc/uvcvideo.h                   |    4 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |    8 ++--
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   43 ++++++++++--------
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    3 +-
 drivers/staging/media/omap4iss/iss_video.c         |   23 +++++-----
 drivers/staging/media/omap4iss/iss_video.h         |    6 +--
 drivers/usb/gadget/function/uvc_queue.c            |   26 ++++++-----
 drivers/usb/gadget/function/uvc_queue.h            |    2 +-
 include/media/davinci/vpbe_display.h               |    3 +-
 include/media/v4l2-mem2mem.h                       |    9 ++--
 include/trace/events/v4l2.h                        |   35 +++++++--------
 68 files changed, 576 insertions(+), 435 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 8be7b9b..8d0b6f0 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -38,6 +38,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-sg.h>
 
 /* read 512 bytes from endpoint 0x86 -> get header + blobs */
@@ -163,7 +164,7 @@ struct sur40_state {
 };
 
 struct sur40_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -420,7 +421,7 @@ static void sur40_process_video(struct sur40_state *sur40)
 
 	dev_dbg(sur40->dev, "header acquired\n");
 
-	sgt = vb2_dma_sg_plane_desc(&new_buf->vb, 0);
+	sgt = vb2_dma_sg_plane_desc(&new_buf->vb.vb2_buf, 0);
 
 	result = usb_sg_init(&sgr, sur40->usbdev,
 		usb_rcvbulkpipe(sur40->usbdev, VIDEO_ENDPOINT), 0,
@@ -443,15 +444,15 @@ static void sur40_process_video(struct sur40_state *sur40)
 		goto err_poll;
 
 	/* mark as finished */
-	v4l2_get_timestamp(&new_buf->vb.v4l2_buf.timestamp);
-	new_buf->vb.v4l2_buf.sequence = sur40->sequence++;
-	new_buf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
-	vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&new_buf->vb.timestamp);
+	new_buf->vb.sequence = sur40->sequence++;
+	new_buf->vb.field = V4L2_FIELD_NONE;
+	vb2_buffer_done(&new_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	dev_dbg(sur40->dev, "buffer marked done\n");
 	return;
 
 err_poll:
-	vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_ERROR);
+	vb2_buffer_done(&new_buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 }
 
 /* Initialize input device parameters. */
@@ -700,7 +701,7 @@ static void return_all_buffers(struct sur40_state *sur40,
 
 	spin_lock(&sur40->qlock);
 	list_for_each_entry_safe(buf, node, &sur40->buf_list, list) {
-		vb2_buffer_done(&buf->vb, state);
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
 		list_del(&buf->list);
 	}
 	spin_unlock(&sur40->qlock);
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index d5b994f..bf306a2 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -29,6 +29,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
 #include <linux/platform_device.h>
@@ -107,7 +108,8 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct rtl2832_sdr_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -304,13 +306,13 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
+		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		len = rtl2832_sdr_convert_stream(dev, ptr, urb->transfer_buffer,
 				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb, 0, len);
-		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
-		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
+		v4l2_get_timestamp(&fbuf->vb.timestamp);
+		fbuf->vb.sequence = dev->sequence++;
+		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 skip:
 	usb_submit_urb(urb, GFP_ATOMIC);
@@ -464,7 +466,7 @@ static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_dev *dev)
 		buf = list_entry(dev->queued_bufs.next,
 				struct rtl2832_sdr_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -518,14 +520,15 @@ static int rtl2832_sdr_buf_prepare(struct vb2_buffer *vb)
 
 static void rtl2832_sdr_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct rtl2832_sdr_frame_buf *buf =
-			container_of(vb, struct rtl2832_sdr_frame_buf, vb);
+			container_of(vbuf, struct rtl2832_sdr_frame_buf, vb);
 	unsigned long flags;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (!dev->udev) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index c206df9..b2f08e4 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -35,6 +35,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-sg.h>
 
 #include "m00233_video_measure_memmap_package.h"
@@ -206,11 +207,12 @@ struct sg_dma_desc_info {
 #define COBALT_STREAM_FL_ADV_IRQ		1
 
 struct cobalt_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
-static inline struct cobalt_buffer *to_cobalt_buffer(struct vb2_buffer *vb2)
+static inline
+struct cobalt_buffer *to_cobalt_buffer(struct vb2_v4l2_buffer *vb2)
 {
 	return container_of(vb2, struct cobalt_buffer, vb);
 }
diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index dd4bff9..099326e 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -134,11 +134,12 @@ done:
 		skip = true;
 		s->skip_first_frames--;
 	}
-	v4l2_get_timestamp(&cb->vb.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&cb->vb.timestamp);
 	/* TODO: the sequence number should be read from the FPGA so we
 	   also know about dropped frames. */
-	cb->vb.v4l2_buf.sequence = s->sequence++;
-	vb2_buffer_done(&cb->vb, (skip || s->unstable_frame) ?
+	cb->vb.sequence = s->sequence++;
+	vb2_buffer_done(&cb->vb.vb2_buf,
+			(skip || s->unstable_frame) ?
 			VB2_BUF_STATE_QUEUED : VB2_BUF_STATE_DONE);
 }
 
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 9756fd3..7d331a4 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -75,7 +75,7 @@ static int cobalt_buf_init(struct vb2_buffer *vb)
 	const size_t bytes =
 		COBALT_MAX_HEIGHT * max_pages_per_line * 0x20;
 	const size_t audio_bytes = ((1920 * 4) / PAGE_SIZE + 1) * 0x20;
-	struct sg_dma_desc_info *desc = &s->dma_desc_info[vb->v4l2_buf.index];
+	struct sg_dma_desc_info *desc = &s->dma_desc_info[vb->index];
 	struct sg_table *sg_desc = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned size;
 	int ret;
@@ -105,17 +105,18 @@ static int cobalt_buf_init(struct vb2_buffer *vb)
 static void cobalt_buf_cleanup(struct vb2_buffer *vb)
 {
 	struct cobalt_stream *s = vb->vb2_queue->drv_priv;
-	struct sg_dma_desc_info *desc = &s->dma_desc_info[vb->v4l2_buf.index];
+	struct sg_dma_desc_info *desc = &s->dma_desc_info[vb->index];
 
 	descriptor_list_free(desc);
 }
 
 static int cobalt_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cobalt_stream *s = vb->vb2_queue->drv_priv;
 
 	vb2_set_plane_payload(vb, 0, s->stride * s->height);
-	vb->v4l2_buf.field = V4L2_FIELD_NONE;
+	vbuf->field = V4L2_FIELD_NONE;
 	return 0;
 }
 
@@ -128,7 +129,7 @@ static void chain_all_buffers(struct cobalt_stream *s)
 
 	list_for_each(p, &s->bufs) {
 		cb = list_entry(p, struct cobalt_buffer, list);
-		desc[i] = &s->dma_desc_info[cb->vb.v4l2_buf.index];
+		desc[i] = &s->dma_desc_info[cb->vb.vb2_buf.index];
 		if (i > 0)
 			descriptor_list_chain(desc[i-1], desc[i]);
 		i++;
@@ -137,10 +138,11 @@ static void chain_all_buffers(struct cobalt_stream *s)
 
 static void cobalt_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 	struct cobalt_stream *s = q->drv_priv;
-	struct cobalt_buffer *cb = to_cobalt_buffer(vb);
-	struct sg_dma_desc_info *desc = &s->dma_desc_info[vb->v4l2_buf.index];
+	struct cobalt_buffer *cb = to_cobalt_buffer(vbuf);
+	struct sg_dma_desc_info *desc = &s->dma_desc_info[vb->index];
 	unsigned long flags;
 
 	/* Prepare new buffer */
@@ -284,7 +286,7 @@ static void cobalt_dma_start_streaming(struct cobalt_stream *s)
 			  &vo->control);
 	}
 	cb = list_first_entry(&s->bufs, struct cobalt_buffer, list);
-	omni_sg_dma_start(s, &s->dma_desc_info[cb->vb.v4l2_buf.index]);
+	omni_sg_dma_start(s, &s->dma_desc_info[cb->vb.vb2_buf.index]);
 	spin_unlock_irqrestore(&s->irqlock, flags);
 }
 
@@ -381,7 +383,7 @@ static void cobalt_dma_stop_streaming(struct cobalt_stream *s)
 	spin_lock_irqsave(&s->irqlock, flags);
 	list_for_each(p, &s->bufs) {
 		cb = list_entry(p, struct cobalt_buffer, list);
-		desc = &s->dma_desc_info[cb->vb.v4l2_buf.index];
+		desc = &s->dma_desc_info[cb->vb.vb2_buf.index];
 		/* Stop DMA after this descriptor chain */
 		descriptor_list_end_of_chain(desc);
 	}
@@ -416,7 +418,7 @@ static void cobalt_stop_streaming(struct vb2_queue *q)
 	list_for_each_safe(p, safe, &s->bufs) {
 		cb = list_entry(p, struct cobalt_buffer, list);
 		list_del(&cb->list);
-		vb2_buffer_done(&cb->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&cb->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&s->irqlock, flags);
 
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 63c0ee5..316a322 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1155,17 +1155,19 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx23885_buffer *buf =
-		container_of(vb, struct cx23885_buffer, vb);
+		container_of(vbuf, struct cx23885_buffer, vb);
 
 	return cx23885_buf_prepare(buf, &dev->ts1);
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx23885_buffer *buf = container_of(vb,
+	struct cx23885_buffer *buf = container_of(vbuf,
 		struct cx23885_buffer, vb);
 
 	cx23885_free_buffer(dev, buf);
@@ -1173,8 +1175,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx23885_buffer   *buf = container_of(vb,
+	struct cx23885_buffer   *buf = container_of(vbuf,
 		struct cx23885_buffer, vb);
 
 	cx23885_buf_queue(&dev->ts1, buf);
@@ -1201,7 +1204,7 @@ static int cx23885_start_streaming(struct vb2_queue *q, unsigned int count)
 			struct cx23885_buffer, queue);
 
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 	return ret;
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 7aee76a..bc1c960 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -427,12 +427,13 @@ static void cx23885_wakeup(struct cx23885_tsport *port,
 	buf = list_entry(q->active.next,
 			 struct cx23885_buffer, queue);
 
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	buf->vb.v4l2_buf.sequence = q->count++;
-	dprintk(1, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.v4l2_buf.index,
+	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.sequence = q->count++;
+	dprintk(1, "[%p/%d] wakeup reg=%d buf=%d\n", buf,
+		buf->vb.vb2_buf.index,
 		count, q->count);
 	list_del(&buf->queue);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 int cx23885_sram_channel_setup(struct cx23885_dev *dev,
@@ -1453,12 +1454,12 @@ int cx23885_buf_prepare(struct cx23885_buffer *buf, struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
 	int size = port->ts_packet_size * port->ts_packet_count;
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb, 0);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb.vb2_buf, 0);
 
 	dprintk(1, "%s: %p\n", __func__, buf);
-	if (vb2_plane_size(&buf->vb, 0) < size)
+	if (vb2_plane_size(&buf->vb.vb2_buf, 0) < size)
 		return -EINVAL;
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 
 	cx23885_risc_databuffer(dev->pci, &buf->risc,
 				sgt->sgl,
@@ -1503,7 +1504,7 @@ void cx23885_buf_queue(struct cx23885_tsport *port, struct cx23885_buffer *buf)
 	if (list_empty(&cx88q->active)) {
 		list_add_tail(&buf->queue, &cx88q->active);
 		dprintk(1, "[%p/%d] %s - first active\n",
-			buf, buf->vb.v4l2_buf.index, __func__);
+			buf, buf->vb.vb2_buf.index, __func__);
 	} else {
 		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
 		prev = list_entry(cx88q->active.prev, struct cx23885_buffer,
@@ -1511,7 +1512,7 @@ void cx23885_buf_queue(struct cx23885_tsport *port, struct cx23885_buffer *buf)
 		list_add_tail(&buf->queue, &cx88q->active);
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk(1, "[%p/%d] %s - append to active\n",
-			 buf, buf->vb.v4l2_buf.index, __func__);
+			 buf, buf->vb.vb2_buf.index, __func__);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -1530,9 +1531,10 @@ static void do_cancel_buffers(struct cx23885_tsport *port, char *reason)
 		buf = list_entry(q->active.next, struct cx23885_buffer,
 				 queue);
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		dprintk(1, "[%p/%d] %s - dma=0x%08lx\n",
-			buf, buf->vb.v4l2_buf.index, reason, (unsigned long)buf->risc.dma);
+			buf, buf->vb.vb2_buf.index, reason,
+			(unsigned long)buf->risc.dma);
 	}
 	spin_unlock_irqrestore(&port->slock, flags);
 }
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 6e8c24c..09ad512 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -110,18 +110,20 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
 	struct cx23885_buffer *buf =
-		container_of(vb, struct cx23885_buffer, vb);
+		container_of(vbuf, struct cx23885_buffer, vb);
 
 	return cx23885_buf_prepare(buf, port);
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
 	struct cx23885_dev *dev = port->dev;
-	struct cx23885_buffer *buf = container_of(vb,
+	struct cx23885_buffer *buf = container_of(vbuf,
 		struct cx23885_buffer, vb);
 
 	cx23885_free_buffer(dev, buf);
@@ -129,8 +131,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
-	struct cx23885_buffer   *buf = container_of(vb,
+	struct cx23885_buffer   *buf = container_of(vbuf,
 		struct cx23885_buffer, vb);
 
 	cx23885_buf_queue(port, buf);
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index d362d38..6c9bb03 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -138,8 +138,9 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx23885_buffer *buf = container_of(vb,
+	struct cx23885_buffer *buf = container_of(vbuf,
 		struct cx23885_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned lines = VBI_PAL_LINE_COUNT;
@@ -161,7 +162,8 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
-	struct cx23885_buffer *buf = container_of(vb,
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct cx23885_buffer *buf = container_of(vbuf,
 		struct cx23885_buffer, vb);
 
 	cx23885_free_buffer(vb->vb2_queue->drv_priv, buf);
@@ -190,8 +192,10 @@ static void buffer_finish(struct vb2_buffer *vb)
  */
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx23885_buffer *buf = container_of(vb, struct cx23885_buffer, vb);
+	struct cx23885_buffer *buf = container_of(vbuf,
+			struct cx23885_buffer, vb);
 	struct cx23885_buffer *prev;
 	struct cx23885_dmaqueue *q = &dev->vbiq;
 	unsigned long flags;
@@ -206,7 +210,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		list_add_tail(&buf->queue, &q->active);
 		spin_unlock_irqrestore(&dev->slock, flags);
 		dprintk(2, "[%p/%d] vbi_queue - first active\n",
-			buf, buf->vb.v4l2_buf.index);
+			buf, buf->vb.vb2_buf.index);
 
 	} else {
 		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
@@ -217,7 +221,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		spin_unlock_irqrestore(&dev->slock, flags);
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk(2, "[%p/%d] buffer_queue - append to active\n",
-			buf, buf->vb.v4l2_buf.index);
+			buf, buf->vb.vb2_buf.index);
 	}
 }
 
@@ -245,7 +249,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 			struct cx23885_buffer, queue);
 
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ec76470..b6a193d 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -104,12 +104,12 @@ void cx23885_video_wakeup(struct cx23885_dev *dev,
 	buf = list_entry(q->active.next,
 			struct cx23885_buffer, queue);
 
-	buf->vb.v4l2_buf.sequence = q->count++;
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.v4l2_buf.index,
-			count, q->count);
+	buf->vb.sequence = q->count++;
+	v4l2_get_timestamp(&buf->vb.timestamp);
+	dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf,
+			buf->vb.vb2_buf.index, count, q->count);
 	list_del(&buf->queue);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm)
@@ -329,9 +329,10 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx23885_buffer *buf =
-		container_of(vb, struct cx23885_buffer, vb);
+		container_of(vbuf, struct cx23885_buffer, vb);
 	u32 line0_offset, line1_offset;
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	int field_tff;
@@ -401,7 +402,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		BUG();
 	}
 	dprintk(2, "[%p/%d] buffer_init - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
-		buf, buf->vb.v4l2_buf.index,
+		buf, buf->vb.vb2_buf.index,
 		dev->width, dev->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
 	return 0;
@@ -409,7 +410,8 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
-	struct cx23885_buffer *buf = container_of(vb,
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct cx23885_buffer *buf = container_of(vbuf,
 		struct cx23885_buffer, vb);
 
 	cx23885_free_buffer(vb->vb2_queue->drv_priv, buf);
@@ -438,8 +440,9 @@ static void buffer_finish(struct vb2_buffer *vb)
  */
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx23885_buffer   *buf = container_of(vb,
+	struct cx23885_buffer   *buf = container_of(vbuf,
 		struct cx23885_buffer, vb);
 	struct cx23885_buffer   *prev;
 	struct cx23885_dmaqueue *q    = &dev->vidq;
@@ -455,7 +458,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	if (list_empty(&q->active)) {
 		list_add_tail(&buf->queue, &q->active);
 		dprintk(2, "[%p/%d] buffer_queue - first active\n",
-			buf, buf->vb.v4l2_buf.index);
+			buf, buf->vb.vb2_buf.index);
 	} else {
 		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
 		prev = list_entry(q->active.prev, struct cx23885_buffer,
@@ -463,7 +466,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		list_add_tail(&buf->queue, &q->active);
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk(2, "[%p/%d] buffer_queue - append to active\n",
-				buf, buf->vb.v4l2_buf.index);
+				buf, buf->vb.vb2_buf.index);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -492,7 +495,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 			struct cx23885_buffer, queue);
 
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 027ead4..c5ba083 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -170,7 +170,7 @@ struct cx23885_riscmem {
 /* buffer for one video frame */
 struct cx23885_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head queue;
 
 	/* cx23885 specific */
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 7bc495e..f1deb8f 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -130,10 +130,10 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 			buf = list_entry(dmaq->active.next,
 					 struct cx25821_buffer, queue);
 
-			v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-			buf->vb.v4l2_buf.sequence = dmaq->count++;
+			v4l2_get_timestamp(&buf->vb.timestamp);
+			buf->vb.sequence = dmaq->count++;
 			list_del(&buf->queue);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 		}
 		spin_unlock(&dev->slock);
 		handled++;
@@ -159,10 +159,11 @@ static int cx25821_queue_setup(struct vb2_queue *q, const struct v4l2_format *fm
 
 static int cx25821_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx25821_channel *chan = vb->vb2_queue->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
 	struct cx25821_buffer *buf =
-		container_of(vb, struct cx25821_buffer, vb);
+		container_of(vbuf, struct cx25821_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	u32 line0_offset;
 	int bpl_local = LINE_SIZE_D1;
@@ -176,7 +177,7 @@ static int cx25821_buffer_prepare(struct vb2_buffer *vb)
 	if (vb2_plane_size(vb, 0) < chan->height * buf->bpl)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, chan->height * buf->bpl);
-	buf->vb.v4l2_buf.field = chan->field;
+	buf->vb.field = chan->field;
 
 	if (chan->pixel_formats == PIXEL_FRMT_411) {
 		bpl_local = buf->bpl;
@@ -231,7 +232,7 @@ static int cx25821_buffer_prepare(struct vb2_buffer *vb)
 	}
 
 	dprintk(2, "[%p/%d] buffer_prep - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
-		buf, buf->vb.v4l2_buf.index, chan->width, chan->height,
+		buf, buf->vb.vb2_buf.index, chan->width, chan->height,
 		chan->fmt->depth, chan->fmt->name,
 		(unsigned long)buf->risc.dma);
 
@@ -240,8 +241,9 @@ static int cx25821_buffer_prepare(struct vb2_buffer *vb)
 
 static void cx25821_buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx25821_buffer *buf =
-		container_of(vb, struct cx25821_buffer, vb);
+		container_of(vbuf, struct cx25821_buffer, vb);
 	struct cx25821_channel *chan = vb->vb2_queue->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
 
@@ -250,8 +252,9 @@ static void cx25821_buffer_finish(struct vb2_buffer *vb)
 
 static void cx25821_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx25821_buffer *buf =
-		container_of(vb, struct cx25821_buffer, vb);
+		container_of(vbuf, struct cx25821_buffer, vb);
 	struct cx25821_channel *chan = vb->vb2_queue->drv_priv;
 	struct cx25821_dev *dev = chan->dev;
 	struct cx25821_buffer *prev;
@@ -300,7 +303,7 @@ static void cx25821_stop_streaming(struct vb2_queue *q)
 			struct cx25821_buffer, queue);
 
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index d81a08a..a513b68 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -34,6 +34,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-sg.h>
 
 #include "cx25821-reg.h"
@@ -127,7 +128,7 @@ struct cx25821_riscmem {
 /* buffer for one video frame */
 struct cx25821_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head queue;
 
 	/* cx25821 specific */
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 24216ef..49d0b7c 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -653,16 +653,18 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer *buf = container_of(vbuf, struct cx88_buffer, vb);
 
 	return cx8802_buf_prepare(vb->vb2_queue, dev, buf);
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct cx88_riscmem *risc = &buf->risc;
 
 	if (risc->cpu)
@@ -672,8 +674,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer    *buf = container_of(vbuf, struct cx88_buffer, vb);
 
 	cx8802_buf_queue(dev, buf);
 }
@@ -721,7 +724,7 @@ fail:
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 	return err;
@@ -749,7 +752,7 @@ static void stop_streaming(struct vb2_queue *q)
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index aab7cf4..9a43c78 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -518,11 +518,11 @@ void cx88_wakeup(struct cx88_core *core,
 
 	buf = list_entry(q->active.next,
 			 struct cx88_buffer, list);
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	buf->vb.v4l2_buf.field = core->field;
-	buf->vb.v4l2_buf.sequence = q->count++;
+	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.field = core->field;
+	buf->vb.sequence = q->count++;
 	list_del(&buf->list);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 void cx88_shutdown(struct cx88_core *core)
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 9dfa5ee..f0923fb 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -99,16 +99,18 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer *buf = container_of(vbuf, struct cx88_buffer, vb);
 
 	return cx8802_buf_prepare(vb->vb2_queue, dev, buf);
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct cx88_riscmem *risc = &buf->risc;
 
 	if (risc->cpu)
@@ -118,8 +120,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8802_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer    *buf = container_of(vbuf, struct cx88_buffer, vb);
 
 	cx8802_buf_queue(dev, buf);
 }
@@ -149,7 +152,7 @@ static void stop_streaming(struct vb2_queue *q)
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 34f5057..9961b22 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -214,7 +214,7 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 
 	buf = list_entry(q->active.next, struct cx88_buffer, list);
 	dprintk(2,"restart_queue [%p/%d]: restart dma\n",
-		buf, buf->vb.v4l2_buf.index);
+		buf, buf->vb.vb2_buf.index);
 	cx8802_start_dma(dev, q, buf);
 	return 0;
 }
@@ -225,13 +225,13 @@ int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 			struct cx88_buffer *buf)
 {
 	int size = dev->ts_packet_size * dev->ts_packet_count;
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb, 0);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb.vb2_buf, 0);
 	struct cx88_riscmem *risc = &buf->risc;
 	int rc;
 
-	if (vb2_plane_size(&buf->vb, 0) < size)
+	if (vb2_plane_size(&buf->vb.vb2_buf, 0) < size)
 		return -EINVAL;
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 
 	rc = cx88_risc_databuffer(dev->pci, risc, sgt->sgl,
 			     dev->ts_packet_size, dev->ts_packet_count, 0);
@@ -259,7 +259,7 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 		dprintk( 1, "queue is empty - first active\n" );
 		list_add_tail(&buf->list, &cx88q->active);
 		dprintk(1,"[%p/%d] %s - first active\n",
-			buf, buf->vb.v4l2_buf.index, __func__);
+			buf, buf->vb.vb2_buf.index, __func__);
 
 	} else {
 		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
@@ -268,7 +268,7 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 		list_add_tail(&buf->list, &cx88q->active);
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk( 1, "[%p/%d] %s - append to active\n",
-			buf, buf->vb.v4l2_buf.index, __func__);
+			buf, buf->vb.vb2_buf.index, __func__);
 	}
 }
 
@@ -284,7 +284,7 @@ static void do_cancel_buffers(struct cx8802_dev *dev)
 	while (!list_empty(&q->active)) {
 		buf = list_entry(q->active.next, struct cx88_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock,flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 7510e80..1d65543 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -100,7 +100,7 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 
 	buf = list_entry(q->active.next, struct cx88_buffer, list);
 	dprintk(2,"restart_queue [%p/%d]: restart dma\n",
-		buf, buf->vb.v4l2_buf.index);
+		buf, buf->vb.vb2_buf.index);
 	cx8800_start_vbi_dma(dev, q, buf);
 	return 0;
 }
@@ -125,8 +125,9 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned int lines;
 	unsigned int size;
@@ -149,8 +150,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct cx88_riscmem *risc = &buf->risc;
 
 	if (risc->cpu)
@@ -160,8 +162,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer    *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct cx88_buffer    *prev;
 	struct cx88_dmaqueue  *q    = &dev->vbiq;
 
@@ -174,7 +177,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		list_add_tail(&buf->list, &q->active);
 		cx8800_start_vbi_dma(dev, q, buf);
 		dprintk(2,"[%p/%d] vbi_queue - first active\n",
-			buf, buf->vb.v4l2_buf.index);
+			buf, buf->vb.vb2_buf.index);
 
 	} else {
 		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
@@ -182,7 +185,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		list_add_tail(&buf->list, &q->active);
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk(2,"[%p/%d] buffer_queue - append to active\n",
-			buf, buf->vb.v4l2_buf.index);
+			buf, buf->vb.vb2_buf.index);
 	}
 }
 
@@ -213,7 +216,7 @@ static void stop_streaming(struct vb2_queue *q)
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 400e5ca..c6a337a 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -420,7 +420,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 	if (!list_empty(&q->active)) {
 		buf = list_entry(q->active.next, struct cx88_buffer, list);
 		dprintk(2,"restart_queue [%p/%d]: restart dma\n",
-			buf, buf->vb.v4l2_buf.index);
+			buf, buf->vb.vb2_buf.index);
 		start_video_dma(dev, q, buf);
 	}
 	return 0;
@@ -444,9 +444,10 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_core *core = dev->core;
-	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
 	buf->bpl = core->width * dev->fmt->depth >> 3;
@@ -489,7 +490,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		break;
 	}
 	dprintk(2,"[%p/%d] buffer_prepare - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
-		buf, buf->vb.v4l2_buf.index,
+		buf, buf->vb.vb2_buf.index,
 		core->width, core->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
 	return 0;
@@ -497,8 +498,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct cx88_riscmem *risc = &buf->risc;
 
 	if (risc->cpu)
@@ -508,8 +510,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx88_buffer    *buf = container_of(vb, struct cx88_buffer, vb);
+	struct cx88_buffer    *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct cx88_buffer    *prev;
 	struct cx88_core      *core = dev->core;
 	struct cx88_dmaqueue  *q    = &dev->vidq;
@@ -522,7 +525,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	if (list_empty(&q->active)) {
 		list_add_tail(&buf->list, &q->active);
 		dprintk(2,"[%p/%d] buffer_queue - first active\n",
-			buf, buf->vb.v4l2_buf.index);
+			buf, buf->vb.vb2_buf.index);
 
 	} else {
 		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
@@ -530,7 +533,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		list_add_tail(&buf->list, &q->active);
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk(2, "[%p/%d] buffer_queue - append to active\n",
-			buf, buf->vb.v4l2_buf.index);
+			buf, buf->vb.vb2_buf.index);
 	}
 }
 
@@ -560,7 +563,7 @@ static void stop_streaming(struct vb2_queue *q)
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 785fe2e..2996eb3 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -321,7 +321,7 @@ struct cx88_riscmem {
 /* buffer for one video frame */
 struct cx88_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head       list;
 
 	/* cx88 specific */
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index 8df6345..f27a858 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -160,7 +160,7 @@ static int dt3155_buf_prepare(struct vb2_buffer *vb)
 static int dt3155_start_streaming(struct vb2_queue *q, unsigned count)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
-	struct vb2_buffer *vb = pd->curr_buf;
+	struct vb2_buffer *vb = &pd->curr_buf->vb2_buf;
 	dma_addr_t dma_addr;
 
 	pd->sequence = 0;
@@ -208,7 +208,7 @@ static void dt3155_stop_streaming(struct vb2_queue *q)
 
 	spin_lock_irq(&pd->lock);
 	if (pd->curr_buf) {
-		vb2_buffer_done(pd->curr_buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&pd->curr_buf->vb2_buf, VB2_BUF_STATE_ERROR);
 		pd->curr_buf = NULL;
 	}
 
@@ -222,6 +222,7 @@ static void dt3155_stop_streaming(struct vb2_queue *q)
 
 static void dt3155_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct dt3155_priv *pd = vb2_get_drv_priv(vb->vb2_queue);
 
 	/*  pd->vidq.streaming = 1 when dt3155_buf_queue() is invoked  */
@@ -229,7 +230,7 @@ static void dt3155_buf_queue(struct vb2_buffer *vb)
 	if (pd->curr_buf)
 		list_add_tail(&vb->done_entry, &pd->dmaq);
 	else
-		pd->curr_buf = vb;
+		pd->curr_buf = vbuf;
 	spin_unlock_irq(&pd->lock);
 }
 
@@ -269,14 +270,14 @@ static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 
 	spin_lock(&ipd->lock);
 	if (ipd->curr_buf && !list_empty(&ipd->dmaq)) {
-		v4l2_get_timestamp(&ipd->curr_buf->v4l2_buf.timestamp);
-		ipd->curr_buf->v4l2_buf.sequence = ipd->sequence++;
-		ipd->curr_buf->v4l2_buf.field = V4L2_FIELD_NONE;
-		vb2_buffer_done(ipd->curr_buf, VB2_BUF_STATE_DONE);
+		v4l2_get_timestamp(&ipd->curr_buf->timestamp);
+		ipd->curr_buf->sequence = ipd->sequence++;
+		ipd->curr_buf->field = V4L2_FIELD_NONE;
+		vb2_buffer_done(&ipd->curr_buf->vb2_buf, VB2_BUF_STATE_DONE);
 
 		ivb = list_first_entry(&ipd->dmaq, typeof(*ivb), done_entry);
 		list_del(&ivb->done_entry);
-		ipd->curr_buf = ivb;
+		ipd->curr_buf = to_vb2_v4l2_buffer(ivb);
 		dma_addr = vb2_dma_contig_plane_dma_addr(ivb, 0);
 		iowrite32(dma_addr, ipd->regs + EVEN_DMA_START);
 		iowrite32(dma_addr + ipd->width, ipd->regs + ODD_DMA_START);
diff --git a/drivers/media/pci/dt3155/dt3155.h b/drivers/media/pci/dt3155/dt3155.h
index 4e1f4d5..b3531e0 100644
--- a/drivers/media/pci/dt3155/dt3155.h
+++ b/drivers/media/pci/dt3155/dt3155.h
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
+#include <media/videobuf2-v4l2.h>
 
 #define DT3155_NAME "dt3155"
 #define DT3155_VER_MAJ 2
@@ -181,7 +182,7 @@ struct dt3155_priv {
 	struct pci_dev *pdev;
 	struct vb2_queue vidq;
 	struct vb2_alloc_ctx *alloc_ctx;
-	struct vb2_buffer *curr_buf;
+	struct vb2_v4l2_buffer *curr_buf;
 	struct mutex mux;
 	struct list_head dmaq;
 	spinlock_t lock;
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 6d8bf627..b012aa65 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/list.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
 #include "netup_unidvb.h"
@@ -110,7 +111,7 @@ struct netup_dma_regs {
 } __packed __aligned(1);
 
 struct netup_unidvb_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head	list;
 	u32			size;
 };
@@ -300,7 +301,8 @@ static int netup_unidvb_queue_setup(struct vb2_queue *vq,
 static int netup_unidvb_buf_prepare(struct vb2_buffer *vb)
 {
 	struct netup_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
-	struct netup_unidvb_buffer *buf = container_of(vb,
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct netup_unidvb_buffer *buf = container_of(vbuf,
 				struct netup_unidvb_buffer, vb);
 
 	dev_dbg(&dma->ndev->pci_dev->dev, "%s(): buf 0x%p\n", __func__, buf);
@@ -312,7 +314,8 @@ static void netup_unidvb_buf_queue(struct vb2_buffer *vb)
 {
 	unsigned long flags;
 	struct netup_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
-	struct netup_unidvb_buffer *buf = container_of(vb,
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct netup_unidvb_buffer *buf = container_of(vbuf,
 				struct netup_unidvb_buffer, vb);
 
 	dev_dbg(&dma->ndev->pci_dev->dev, "%s(): %p\n", __func__, buf);
@@ -509,7 +512,7 @@ static int netup_unidvb_ring_copy(struct netup_dma *dma,
 {
 	u32 copy_bytes, ring_bytes;
 	u32 buff_bytes = NETUP_DMA_PACKETS_COUNT * 188 - buf->size;
-	u8 *p = vb2_plane_vaddr(&buf->vb, 0);
+	u8 *p = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	struct netup_unidvb_dev *ndev = dma->ndev;
 
 	if (p == NULL) {
@@ -579,9 +582,9 @@ static void netup_unidvb_dma_worker(struct work_struct *work)
 			dev_dbg(&ndev->pci_dev->dev,
 				"%s(): buffer %p done, size %d\n",
 				__func__, buf, buf->size);
-			v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-			vb2_set_plane_payload(&buf->vb, 0, buf->size);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+			v4l2_get_timestamp(&buf->vb.timestamp);
+			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->size);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 		}
 	}
 work_done:
@@ -599,7 +602,7 @@ static void netup_unidvb_queue_cleanup(struct netup_dma *dma)
 		buf = list_first_entry(&dma->free_buffers,
 			struct netup_unidvb_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dma->lock, flags);
 }
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 72d7f99..87f39f9 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -216,13 +216,14 @@ int saa7134_buffer_count(unsigned int size, unsigned int count)
 
 int saa7134_buffer_startpage(struct saa7134_buf *buf)
 {
-	return saa7134_buffer_pages(vb2_plane_size(&buf->vb2, 0)) * buf->vb2.v4l2_buf.index;
+	return saa7134_buffer_pages(vb2_plane_size(&buf->vb2.vb2_buf, 0))
+			* buf->vb2.vb2_buf.index;
 }
 
 unsigned long saa7134_buffer_base(struct saa7134_buf *buf)
 {
 	unsigned long base;
-	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2.vb2_buf, 0);
 
 	base  = saa7134_buffer_startpage(buf) * 4096;
 	base += dma->sgl[0].offset;
@@ -308,9 +309,9 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 	core_dbg("buffer_finish %p\n", q->curr);
 
 	/* finish current buffer */
-	v4l2_get_timestamp(&q->curr->vb2.v4l2_buf.timestamp);
-	q->curr->vb2.v4l2_buf.sequence = q->seq_nr++;
-	vb2_buffer_done(&q->curr->vb2, state);
+	v4l2_get_timestamp(&q->curr->vb2.timestamp);
+	q->curr->vb2.sequence = q->seq_nr++;
+	vb2_buffer_done(&q->curr->vb2.vb2_buf, state);
 	q->curr = NULL;
 }
 
@@ -375,7 +376,8 @@ void saa7134_stop_streaming(struct saa7134_dev *dev, struct saa7134_dmaqueue *q)
 	if (!list_empty(&q->queue)) {
 		list_for_each_safe(pos, n, &q->queue) {
 			 tmp = list_entry(pos, struct saa7134_buf, entry);
-			 vb2_buffer_done(&tmp->vb2, VB2_BUF_STATE_ERROR);
+			 vb2_buffer_done(&tmp->vb2.vb2_buf,
+					 VB2_BUF_STATE_ERROR);
 			 list_del(pos);
 			 tmp = NULL;
 		}
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 4b202fa..b0ef37d 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -79,8 +79,9 @@ static int buffer_activate(struct saa7134_dev *dev,
 
 int saa7134_ts_buffer_init(struct vb2_buffer *vb2)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb2);
 	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
 
 	dmaq->curr = NULL;
 	buf->activate = buffer_activate;
@@ -91,9 +92,10 @@ EXPORT_SYMBOL_GPL(saa7134_ts_buffer_init);
 
 int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb2);
 	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(vb2, 0);
 	unsigned int lines, llength, size;
 
@@ -107,7 +109,7 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 		return -EINVAL;
 
 	vb2_set_plane_payload(vb2, 0, size);
-	vb2->v4l2_buf.field = dev->field;
+	vbuf->field = dev->field;
 
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
@@ -148,10 +150,12 @@ int saa7134_ts_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 		list_for_each_entry_safe(buf, tmp, &dmaq->queue, entry) {
 			list_del(&buf->entry);
-			vb2_buffer_done(&buf->vb2, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb2.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 		if (dmaq->curr) {
-			vb2_buffer_done(&dmaq->curr->vb2, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&dmaq->curr->vb2.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 			dmaq->curr = NULL;
 		}
 		return -EBUSY;
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 4d36586..fb1605e 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -83,7 +83,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *buf,
 			   struct saa7134_buf *next)
 {
-	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2_buf.vb2_queue->drv_priv;
 	unsigned long control, base;
 
 	vbi_dbg("buffer_activate [%p]\n", buf);
@@ -119,8 +119,9 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 {
 	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
-	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb2);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(vb2, 0);
 	unsigned int size;
 
 	if (dma->sgl->offset) {
@@ -161,7 +162,8 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 static int buffer_init(struct vb2_buffer *vb2)
 {
 	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb2);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
 
 	dmaq->curr = NULL;
 	buf->activate = buffer_activate;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 035039c..602d53d 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -791,7 +791,7 @@ static int buffer_activate(struct saa7134_dev *dev,
 			   struct saa7134_buf *buf,
 			   struct saa7134_buf *next)
 {
-	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2_queue->drv_priv;
+	struct saa7134_dmaqueue *dmaq = buf->vb2.vb2_buf.vb2_queue->drv_priv;
 	unsigned long base,control,bpl;
 	unsigned long bpl_uv,lines_uv,base2,base3,tmp; /* planar */
 
@@ -872,7 +872,8 @@ static int buffer_activate(struct saa7134_dev *dev,
 static int buffer_init(struct vb2_buffer *vb2)
 {
 	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb2);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
 
 	dmaq->curr = NULL;
 	buf->activate = buffer_activate;
@@ -883,8 +884,9 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 {
 	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
-	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb2);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(vb2, 0);
 	unsigned int size;
 
 	if (dma->sgl->offset) {
@@ -896,7 +898,7 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 		return -EINVAL;
 
 	vb2_set_plane_payload(vb2, 0, size);
-	vb2->v4l2_buf.field = dev->field;
+	vbuf->field = dev->field;
 
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
@@ -932,7 +934,8 @@ void saa7134_vb2_buffer_queue(struct vb2_buffer *vb)
 {
 	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb2);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
 
 	saa7134_buffer_queue(dev, dmaq, buf);
 }
@@ -953,10 +956,12 @@ int saa7134_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 		list_for_each_entry_safe(buf, tmp, &dmaq->queue, entry) {
 			list_del(&buf->entry);
-			vb2_buffer_done(&buf->vb2, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb2.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 		if (dmaq->curr) {
-			vb2_buffer_done(&dmaq->curr->vb2, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&dmaq->curr->vb2.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 			dmaq->curr = NULL;
 		}
 		return -EBUSY;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 6b5f6f4..002ba1d8 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -459,7 +459,7 @@ struct saa7134_thread {
 /* buffer for one video/vbi/ts frame */
 struct saa7134_buf {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb2;
+	struct vb2_v4l2_buffer vb2;
 
 	/* saa7134 specific */
 	unsigned int            top_seen;
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 53fff54..78ac3fe 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -458,11 +458,12 @@ static inline u32 vop_usec(const vop_header *vh)
 static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 			  struct vb2_buffer *vb, const vop_header *vh)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_size;
 
-	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+	vbuf->flags |= V4L2_BUF_FLAG_KEYFRAME;
 
 	if (vb2_plane_size(vb, 0) < vop_jpeg_size(vh) + solo_enc->jpeg_len)
 		return -EIO;
@@ -470,7 +471,7 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 	frame_size = ALIGN(vop_jpeg_size(vh) + solo_enc->jpeg_len, DMA_ALIGN);
 	vb2_set_plane_payload(vb, 0, vop_jpeg_size(vh) + solo_enc->jpeg_len);
 
-	return solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf,
+	return solo_send_desc(solo_enc, solo_enc->jpeg_len, sgt,
 			     vop_jpeg_offset(vh) - SOLO_JPEG_EXT_ADDR(solo_dev),
 			     frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
 			     SOLO_JPEG_EXT_SIZE(solo_dev));
@@ -479,8 +480,9 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 		struct vb2_buffer *vb, const vop_header *vh)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_off, frame_size;
 	int skip = 0;
 
@@ -488,15 +490,15 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 		return -EIO;
 
 	/* If this is a key frame, add extra header */
-	vb->v4l2_buf.flags &= ~(V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_PFRAME |
+	vbuf->flags &= ~(V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_PFRAME |
 		V4L2_BUF_FLAG_BFRAME);
 	if (!vop_type(vh)) {
 		skip = solo_enc->vop_len;
-		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+		vbuf->flags |= V4L2_BUF_FLAG_KEYFRAME;
 		vb2_set_plane_payload(vb, 0, vop_mpeg_size(vh) +
 			solo_enc->vop_len);
 	} else {
-		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
+		vbuf->flags |= V4L2_BUF_FLAG_PFRAME;
 		vb2_set_plane_payload(vb, 0, vop_mpeg_size(vh));
 	}
 
@@ -505,7 +507,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 		sizeof(*vh)) % SOLO_MP4E_EXT_SIZE(solo_dev);
 	frame_size = ALIGN(vop_mpeg_size(vh) + skip, DMA_ALIGN);
 
-	return solo_send_desc(solo_enc, skip, vbuf, frame_off, frame_size,
+	return solo_send_desc(solo_enc, skip, sgt, frame_off, frame_size,
 			SOLO_MP4E_EXT_ADDR(solo_dev),
 			SOLO_MP4E_EXT_SIZE(solo_dev));
 }
@@ -513,6 +515,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 			    struct vb2_buffer *vb, struct solo_enc_buf *enc_buf)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	const vop_header *vh = enc_buf->vh;
 	int ret;
 
@@ -527,17 +530,18 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 	}
 
 	if (!ret) {
-		vb->v4l2_buf.sequence = solo_enc->sequence++;
-		vb->v4l2_buf.timestamp.tv_sec = vop_sec(vh);
-		vb->v4l2_buf.timestamp.tv_usec = vop_usec(vh);
+		vbuf->sequence = solo_enc->sequence++;
+		vbuf->timestamp.tv_sec = vop_sec(vh);
+		vbuf->timestamp.tv_usec = vop_usec(vh);
 
 		/* Check for motion flags */
 		if (solo_is_motion_on(solo_enc) && enc_buf->motion) {
 			struct v4l2_event ev = {
 				.type = V4L2_EVENT_MOTION_DET,
 				.u.motion_det = {
-					.flags = V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ,
-					.frame_sequence = vb->v4l2_buf.sequence,
+					.flags
+					= V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ,
+					.frame_sequence = vbuf->sequence,
 					.region_mask = enc_buf->motion ? 1 : 0,
 				},
 			};
@@ -571,7 +575,7 @@ static void solo_enc_handle_one(struct solo_enc_dev *solo_enc,
 	list_del(&vb->list);
 	spin_unlock_irqrestore(&solo_enc->av_lock, flags);
 
-	solo_enc_fillbuf(solo_enc, &vb->vb, enc_buf);
+	solo_enc_fillbuf(solo_enc, &vb->vb.vb2_buf, enc_buf);
 unlock:
 	mutex_unlock(&solo_enc->lock);
 }
@@ -678,10 +682,11 @@ static int solo_enc_queue_setup(struct vb2_queue *q,
 
 static void solo_enc_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(vq);
 	struct solo_vb2_buf *solo_vb =
-		container_of(vb, struct solo_vb2_buf, vb);
+		container_of(vbuf, struct solo_vb2_buf, vb);
 
 	spin_lock(&solo_enc->av_lock);
 	list_add_tail(&solo_vb->list, &solo_enc->vidq_active);
@@ -734,25 +739,26 @@ static void solo_enc_stop_streaming(struct vb2_queue *q)
 				struct solo_vb2_buf, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&solo_enc->av_lock, flags);
 }
 
 static void solo_enc_buf_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(vb->vb2_queue);
-	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
 	switch (solo_enc->fmt) {
 	case V4L2_PIX_FMT_MPEG4:
 	case V4L2_PIX_FMT_H264:
-		if (vb->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME)
-			sg_copy_from_buffer(vbuf->sgl, vbuf->nents,
+		if (vbuf->flags & V4L2_BUF_FLAG_KEYFRAME)
+			sg_copy_from_buffer(sgt->sgl, sgt->nents,
 					solo_enc->vop, solo_enc->vop_len);
 		break;
 	default: /* V4L2_PIX_FMT_MJPEG */
-		sg_copy_from_buffer(vbuf->sgl, vbuf->nents,
+		sg_copy_from_buffer(sgt->sgl, sgt->nents,
 				solo_enc->jpeg_header, solo_enc->jpeg_len);
 		break;
 	}
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 63ae8a6..57d0d9c 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -26,6 +26,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "solo6x10.h"
@@ -191,13 +192,14 @@ static int solo_v4l2_set_ch(struct solo_dev *solo_dev, u8 ch)
 static void solo_fillbuf(struct solo_dev *solo_dev,
 			 struct vb2_buffer *vb)
 {
-	dma_addr_t vbuf;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	dma_addr_t addr;
 	unsigned int fdma_addr;
 	int error = -1;
 	int i;
 
-	vbuf = vb2_dma_contig_plane_dma_addr(vb, 0);
-	if (!vbuf)
+	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (!addr)
 		goto finish_buf;
 
 	if (erase_off(solo_dev)) {
@@ -213,7 +215,7 @@ static void solo_fillbuf(struct solo_dev *solo_dev,
 		fdma_addr = SOLO_DISP_EXT_ADDR + (solo_dev->old_write *
 				(SOLO_HW_BPL * solo_vlines(solo_dev)));
 
-		error = solo_p2m_dma_t(solo_dev, 0, vbuf, fdma_addr,
+		error = solo_p2m_dma_t(solo_dev, 0, addr, fdma_addr,
 				       solo_bytesperline(solo_dev),
 				       solo_vlines(solo_dev), SOLO_HW_BPL);
 	}
@@ -222,8 +224,8 @@ finish_buf:
 	if (!error) {
 		vb2_set_plane_payload(vb, 0,
 			solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
-		vb->v4l2_buf.sequence = solo_dev->sequence++;
-		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
+		vbuf->sequence = solo_dev->sequence++;
+		v4l2_get_timestamp(&vbuf->timestamp);
 	}
 
 	vb2_buffer_done(vb, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
@@ -256,7 +258,7 @@ static void solo_thread_try(struct solo_dev *solo_dev)
 
 		spin_unlock(&solo_dev->slock);
 
-		solo_fillbuf(solo_dev, &vb->vb);
+		solo_fillbuf(solo_dev, &vb->vb.vb2_buf);
 	}
 
 	assert_spin_locked(&solo_dev->slock);
@@ -345,10 +347,11 @@ static void solo_stop_streaming(struct vb2_queue *q)
 
 static void solo_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct solo_dev *solo_dev = vb2_get_drv_priv(vq);
 	struct solo_vb2_buf *solo_vb =
-		container_of(vb, struct solo_vb2_buf, vb);
+		container_of(vbuf, struct solo_vb2_buf, vb);
 
 	spin_lock(&solo_dev->slock);
 	list_add_tail(&solo_vb->list, &solo_dev->vidq_active);
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 5cc9e9d..4ab6586 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -135,7 +135,7 @@ struct solo_p2m_dev {
 #define OSD_TEXT_MAX		44
 
 struct solo_vb2_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 59b3a36..8fe6ea6 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -88,7 +88,7 @@
 
 
 struct vip_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head	list;
 	dma_addr_t		dma;
 };
@@ -307,7 +307,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&vip_buf->vb, 0, size);
+	vb2_set_plane_payload(&vip_buf->vb.vb2_buf, 0, size);
 
 	return 0;
 }
@@ -370,7 +370,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* Release all active buffers */
 	spin_lock(&vip->lock);
 	list_for_each_entry_safe(vip_buf, node, &vip->buffer_list, list) {
-		vb2_buffer_done(&vip_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&vip_buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&vip_buf->list);
 	}
 	spin_unlock(&vip->lock);
@@ -813,9 +813,9 @@ static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
 		/* Disable acquisition */
 		reg_write(vip, DVP_CTL, reg_read(vip, DVP_CTL) & ~DVP_CTL_ENA);
 		/* Remove the active buffer from the list */
-		v4l2_get_timestamp(&vip->active->vb.v4l2_buf.timestamp);
-		vip->active->vb.v4l2_buf.sequence = vip->sequence++;
-		vb2_buffer_done(&vip->active->vb, VB2_BUF_STATE_DONE);
+		v4l2_get_timestamp(&vip->active->vb.timestamp);
+		vip->active->vb.sequence = vip->sequence++;
+		vb2_buffer_done(&vip->active->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 8355e55..3237214 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -423,9 +423,10 @@ static int tw68_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
  */
 static void tw68_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
-	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
+	struct tw68_buf *buf = container_of(vbuf, struct tw68_buf, vb);
 	struct tw68_buf *prev;
 	unsigned long flags;
 
@@ -457,9 +458,10 @@ static void tw68_buf_queue(struct vb2_buffer *vb)
  */
 static int tw68_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
-	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
+	struct tw68_buf *buf = container_of(vbuf, struct tw68_buf, vb);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned size, bpl;
 
@@ -499,9 +501,10 @@ static int tw68_buf_prepare(struct vb2_buffer *vb)
 
 static void tw68_buf_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
-	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
+	struct tw68_buf *buf = container_of(vbuf, struct tw68_buf, vb);
 
 	pci_free_consistent(dev->pci, buf->size, buf->cpu, buf->dma);
 }
@@ -528,7 +531,7 @@ static void tw68_stop_streaming(struct vb2_queue *q)
 			container_of(dev->active.next, struct tw68_buf, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 }
 
@@ -1012,10 +1015,10 @@ void tw68_irq_video_done(struct tw68_dev *dev, unsigned long status)
 		buf = list_entry(dev->active.next, struct tw68_buf, list);
 		list_del(&buf->list);
 		spin_unlock(&dev->slock);
-		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-		buf->vb.v4l2_buf.field = dev->field;
-		buf->vb.v4l2_buf.sequence = dev->seqnr++;
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+		v4l2_get_timestamp(&buf->vb.timestamp);
+		buf->vb.field = dev->field;
+		buf->vb.sequence = dev->seqnr++;
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 		status &= ~(TW68_DMAPI);
 		if (0 == status)
 			return;
diff --git a/drivers/media/pci/tw68/tw68.h b/drivers/media/pci/tw68/tw68.h
index ef51e4d..6c7dcb3 100644
--- a/drivers/media/pci/tw68/tw68.h
+++ b/drivers/media/pci/tw68/tw68.h
@@ -36,6 +36,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-sg.h>
 
 #include "tw68-reg.h"
@@ -118,7 +119,7 @@ struct tw68_dev;	/* forward delclaration */
 
 /* buffer for one video/vbi/ts frame */
 struct tw68_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	unsigned int   size;
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 8f2e1c2..2542af3 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -21,6 +21,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
 /* AirSpy USB API commands (from AirSpy Library) */
@@ -97,7 +98,8 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct airspy_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -310,13 +312,13 @@ static void airspy_urb_complete(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
+		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		len = airspy_convert_stream(s, ptr, urb->transfer_buffer,
 				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb, 0, len);
-		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
-		fbuf->vb.v4l2_buf.sequence = s->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
+		v4l2_get_timestamp(&fbuf->vb.timestamp);
+		fbuf->vb.sequence = s->sequence++;
+		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 skip:
 	usb_submit_urb(urb, GFP_ATOMIC);
@@ -459,7 +461,7 @@ static void airspy_cleanup_queued_bufs(struct airspy *s)
 		buf = list_entry(s->queued_bufs.next,
 				struct airspy_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
 }
@@ -505,14 +507,15 @@ static int airspy_queue_setup(struct vb2_queue *vq,
 
 static void airspy_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct airspy *s = vb2_get_drv_priv(vb->vb2_queue);
 	struct airspy_frame_buf *buf =
-			container_of(vb, struct airspy_frame_buf, vb);
+			container_of(vbuf, struct airspy_frame_buf, vb);
 	unsigned long flags;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (unlikely(!s->udev)) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
@@ -571,7 +574,8 @@ err_clear_bit:
 
 		list_for_each_entry_safe(buf, tmp, &s->queued_bufs, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index f67247c..5ec507e 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -52,7 +52,6 @@ static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static int vbi_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
 	unsigned long size;
 
 	size = dev->vbi_width * dev->vbi_height * 2;
@@ -62,7 +61,7 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 			__func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -71,7 +70,9 @@ static void
 vbi_buffer_queue(struct vb2_buffer *vb)
 {
 	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct au0828_buffer *buf =
+			container_of(vbuf, struct au0828_buffer, vb);
 	struct au0828_dmaqueue *vbiq = &dev->vbiq;
 	unsigned long flags = 0;
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 1a362a0..065b9c8 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -302,20 +302,20 @@ static inline void buffer_filled(struct au0828_dev *dev,
 				 struct au0828_dmaqueue *dma_q,
 				 struct au0828_buffer *buf)
 {
-	struct vb2_buffer *vb = &buf->vb;
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_v4l2_buffer *vb = &buf->vb;
+	struct vb2_queue *q = vb->vb2_buf.vb2_queue;
 
 	/* Advice that buffer was filled */
 	au0828_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		vb->v4l2_buf.sequence = dev->frame_count++;
+		vb->sequence = dev->frame_count++;
 	else
-		vb->v4l2_buf.sequence = dev->vbi_frame_count++;
+		vb->sequence = dev->vbi_frame_count++;
 
-	vb->v4l2_buf.field = V4L2_FIELD_INTERLACED;
-	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+	vb->field = V4L2_FIELD_INTERLACED;
+	v4l2_get_timestamp(&vb->timestamp);
+	vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 /*
@@ -531,11 +531,11 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 
 	buf = dev->isoc_ctl.buf;
 	if (buf != NULL)
-		outp = vb2_plane_vaddr(&buf->vb, 0);
+		outp = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 
 	vbi_buf = dev->isoc_ctl.vbi_buf;
 	if (vbi_buf != NULL)
-		vbioutp = vb2_plane_vaddr(&vbi_buf->vb, 0);
+		vbioutp = vb2_plane_vaddr(&vbi_buf->vb.vb2_buf, 0);
 
 	for (i = 0; i < urb->number_of_packets; i++) {
 		int status = urb->iso_frame_desc[i].status;
@@ -574,7 +574,7 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 					vbioutp = NULL;
 				else
 					vbioutp = vb2_plane_vaddr(
-						&vbi_buf->vb, 0);
+						&vbi_buf->vb.vb2_buf, 0);
 
 				/* Video */
 				if (buf != NULL)
@@ -583,7 +583,8 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 				if (buf == NULL)
 					outp = NULL;
 				else
-					outp = vb2_plane_vaddr(&buf->vb, 0);
+					outp = vb2_plane_vaddr(
+						&buf->vb.vb2_buf, 0);
 
 				/* As long as isoc traffic is arriving, keep
 				   resetting the timer */
@@ -658,7 +659,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static int
 buffer_prepare(struct vb2_buffer *vb)
 {
-	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct au0828_buffer *buf = container_of(vbuf,
+				struct au0828_buffer, vb);
 	struct au0828_dev    *dev = vb2_get_drv_priv(vb->vb2_queue);
 
 	buf->length = dev->height * dev->bytesperline;
@@ -668,14 +671,15 @@ buffer_prepare(struct vb2_buffer *vb)
 			__func__, vb2_plane_size(vb, 0), buf->length);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, buf->length);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->length);
 	return 0;
 }
 
 static void
 buffer_queue(struct vb2_buffer *vb)
 {
-	struct au0828_buffer    *buf     = container_of(vb,
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct au0828_buffer    *buf     = container_of(vbuf,
 							struct au0828_buffer,
 							vb);
 	struct au0828_dev       *dev     = vb2_get_drv_priv(vb->vb2_queue);
@@ -826,14 +830,15 @@ static void au0828_stop_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->isoc_ctl.buf != NULL) {
-		vb2_buffer_done(&dev->isoc_ctl.buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->isoc_ctl.buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		dev->isoc_ctl.buf = NULL;
 	}
 	while (!list_empty(&vidq->active)) {
 		struct au0828_buffer *buf;
 
 		buf = list_entry(vidq->active.next, struct au0828_buffer, list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&buf->list);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
@@ -853,7 +858,7 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->isoc_ctl.vbi_buf != NULL) {
-		vb2_buffer_done(&dev->isoc_ctl.vbi_buf->vb,
+		vb2_buffer_done(&dev->isoc_ctl.vbi_buf->vb.vb2_buf,
 				VB2_BUF_STATE_ERROR);
 		dev->isoc_ctl.vbi_buf = NULL;
 	}
@@ -862,7 +867,7 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vbiq->active.next, struct au0828_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 
@@ -911,7 +916,7 @@ static void au0828_vid_buffer_timeout(unsigned long data)
 
 	buf = dev->isoc_ctl.buf;
 	if (buf != NULL) {
-		vid_data = vb2_plane_vaddr(&buf->vb, 0);
+		vid_data = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 		memset(vid_data, 0x00, buf->length); /* Blank green frame */
 		buffer_filled(dev, dma_q, buf);
 	}
@@ -935,7 +940,7 @@ static void au0828_vbi_buffer_timeout(unsigned long data)
 
 	buf = dev->isoc_ctl.vbi_buf;
 	if (buf != NULL) {
-		vbi_data = vb2_plane_vaddr(&buf->vb, 0);
+		vbi_data = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 		memset(vbi_data, 0x00, buf->length);
 		buffer_filled(dev, dma_q, buf);
 	}
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 3b48000..60b5939 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -28,6 +28,7 @@
 
 /* Analog */
 #include <linux/videodev2.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
@@ -167,7 +168,7 @@ struct au0828_usb_isoc_ctl {
 /* buffer for one video frame */
 struct au0828_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	void *mem;
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 744e7ed..23a6148 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -61,7 +61,6 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct em28xx        *dev  = vb2_get_drv_priv(vb->vb2_queue);
 	struct em28xx_v4l2   *v4l2 = dev->v4l2;
-	struct em28xx_buffer *buf  = container_of(vb, struct em28xx_buffer, vb);
 	unsigned long        size;
 
 	size = v4l2->vbi_width * v4l2->vbi_height * 2;
@@ -71,7 +70,7 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 		       __func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -79,8 +78,10 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 static void
 vbi_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct em28xx *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer *buf =
+		container_of(vbuf, struct em28xx_buffer, vb);
 	struct em28xx_dmaqueue *vbiq = &dev->vbiq;
 	unsigned long flags = 0;
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4397ce5..262e032 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -433,14 +433,14 @@ static inline void finish_buffer(struct em28xx *dev,
 {
 	em28xx_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
 
-	buf->vb.v4l2_buf.sequence = dev->v4l2->field_count++;
+	buf->vb.sequence = dev->v4l2->field_count++;
 	if (dev->v4l2->progressive)
-		buf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
+		buf->vb.field = V4L2_FIELD_NONE;
 	else
-		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+		buf->vb.field = V4L2_FIELD_INTERLACED;
+	v4l2_get_timestamp(&buf->vb.timestamp);
 
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 /*
@@ -900,12 +900,12 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static int
 buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct em28xx        *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct em28xx_v4l2   *v4l2 = dev->v4l2;
-	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
 	unsigned long size;
 
-	em28xx_videodbg("%s, field=%d\n", __func__, vb->v4l2_buf.field);
+	em28xx_videodbg("%s, field=%d\n", __func__, vbuf->field);
 
 	size = (v4l2->width * v4l2->height * v4l2->format->depth + 7) >> 3;
 
@@ -914,7 +914,7 @@ buffer_prepare(struct vb2_buffer *vb)
 				__func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -924,6 +924,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	struct v4l2_frequency f;
+	struct v4l2_fh *owner;
 	int rc = 0;
 
 	em28xx_videodbg("%s\n", __func__);
@@ -964,7 +965,8 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 		/* Ask tuner to go to analog or radio mode */
 		memset(&f, 0, sizeof(f));
 		f.frequency = v4l2->frequency;
-		if (vq->owner && vq->owner->vdev->vfl_type == VFL_TYPE_RADIO)
+		owner = (struct v4l2_fh *)vq->owner;
+		if (owner && owner->vdev->vfl_type == VFL_TYPE_RADIO)
 			f.type = V4L2_TUNER_RADIO;
 		else
 			f.type = V4L2_TUNER_ANALOG_TV;
@@ -995,7 +997,8 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->usb_ctl.vid_buf != NULL) {
-		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vid_buf = NULL;
 	}
 	while (!list_empty(&vidq->active)) {
@@ -1003,7 +1006,7 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vidq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -1026,7 +1029,8 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->usb_ctl.vbi_buf != NULL) {
-		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vbi_buf = NULL;
 	}
 	while (!list_empty(&vbiq->active)) {
@@ -1034,7 +1038,7 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vbiq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -1042,8 +1046,10 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 static void
 buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct em28xx *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer *buf =
+		container_of(vbuf, struct em28xx_buffer, vb);
 	struct em28xx_dmaqueue *vidq = &dev->vidq;
 	unsigned long flags = 0;
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e6559c6..76bf8ba 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -35,6 +35,7 @@
 #include <linux/kref.h>
 #include <linux/videodev2.h>
 
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
@@ -264,7 +265,7 @@ struct em28xx_fmt {
 /* buffer for one video frame */
 struct em28xx_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	void *mem;
diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 0ab81ec..ae1cfa7 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -386,10 +386,10 @@ start_error:
  */
 static inline void store_byte(struct go7007_buffer *vb, u8 byte)
 {
-	if (vb && vb->vb.v4l2_planes[0].bytesused < GO7007_BUF_SIZE) {
-		u8 *ptr = vb2_plane_vaddr(&vb->vb, 0);
+	if (vb && vb->vb.vb2_buf.planes[0].bytesused < GO7007_BUF_SIZE) {
+		u8 *ptr = vb2_plane_vaddr(&vb->vb.vb2_buf, 0);
 
-		ptr[vb->vb.v4l2_planes[0].bytesused++] = byte;
+		ptr[vb->vb.vb2_buf.planes[0].bytesused++] = byte;
 	}
 }
 
@@ -401,7 +401,7 @@ static void go7007_set_motion_regions(struct go7007 *go, struct go7007_buffer *v
 			.type = V4L2_EVENT_MOTION_DET,
 			.u.motion_det = {
 				.flags = V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ,
-				.frame_sequence = vb->vb.v4l2_buf.sequence,
+				.frame_sequence = vb->vb.sequence,
 				.region_mask = motion_regions,
 			},
 		};
@@ -417,7 +417,7 @@ static void go7007_set_motion_regions(struct go7007 *go, struct go7007_buffer *v
  */
 static void go7007_motion_regions(struct go7007 *go, struct go7007_buffer *vb)
 {
-	u32 *bytesused = &vb->vb.v4l2_planes[0].bytesused;
+	u32 *bytesused = &vb->vb.vb2_buf.planes[0].bytesused;
 	unsigned motion[4] = { 0, 0, 0, 0 };
 	u32 motion_regions = 0;
 	unsigned stride = (go->width + 7) >> 3;
@@ -458,25 +458,26 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
 		go->next_seq++;
 		return vb;
 	}
-	bytesused = &vb->vb.v4l2_planes[0].bytesused;
+	bytesused = &vb->vb.vb2_buf.planes[0].bytesused;
 
-	vb->vb.v4l2_buf.sequence = go->next_seq++;
+	vb->vb.sequence = go->next_seq++;
 	if (vb->modet_active && *bytesused + 216 < GO7007_BUF_SIZE)
 		go7007_motion_regions(go, vb);
 	else
 		go7007_set_motion_regions(go, vb, 0);
 
-	v4l2_get_timestamp(&vb->vb.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&vb->vb.timestamp);
 	vb_tmp = vb;
 	spin_lock(&go->spinlock);
 	list_del(&vb->list);
 	if (list_empty(&go->vidq_active))
 		vb = NULL;
 	else
-		vb = list_first_entry(&go->vidq_active, struct go7007_buffer, list);
+		vb = list_first_entry(&go->vidq_active,
+				struct go7007_buffer, list);
 	go->active_buf = vb;
 	spin_unlock(&go->spinlock);
-	vb2_buffer_done(&vb_tmp->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb_tmp->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	return vb;
 }
 
@@ -519,9 +520,10 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 	}
 
 	for (i = 0; i < length; ++i) {
-		if (vb && vb->vb.v4l2_planes[0].bytesused >= GO7007_BUF_SIZE - 3) {
+		if (vb && vb->vb.vb2_buf.planes[0].bytesused >=
+				GO7007_BUF_SIZE - 3) {
 			v4l2_info(&go->v4l2_dev, "dropping oversized frame\n");
-			vb->vb.v4l2_planes[0].bytesused = 0;
+			vb->vb.vb2_buf.planes[0].bytesused = 0;
 			vb->frame_offset = 0;
 			vb->modet_active = 0;
 			vb = go->active_buf = NULL;
@@ -601,7 +603,8 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 					vb = frame_boundary(go, vb);
 				go->seen_frame = buf[i] == frame_start_code;
 				if (vb && go->seen_frame)
-					vb->frame_offset = vb->vb.v4l2_planes[0].bytesused;
+					vb->frame_offset =
+					vb->vb.vb2_buf.planes[0].bytesused;
 			}
 			/* Handle any special chunk types, or just write the
 			 * start code to the (potentially new) buffer */
diff --git a/drivers/media/usb/go7007/go7007-priv.h b/drivers/media/usb/go7007/go7007-priv.h
index 9e83bbf..745185e 100644
--- a/drivers/media/usb/go7007/go7007-priv.h
+++ b/drivers/media/usb/go7007/go7007-priv.h
@@ -136,7 +136,7 @@ struct go7007_hpi_ops {
 #define	GO7007_BUF_SIZE		(GO7007_BUF_PAGES << PAGE_SHIFT)
 
 struct go7007_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 	unsigned int frame_offset;
 	u32 modet_active;
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index c57207e..63d87a2 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -52,7 +52,7 @@ static bool valid_pixelformat(u32 pixelformat)
 
 static u32 get_frame_type_flag(struct go7007_buffer *vb, int format)
 {
-	u8 *ptr = vb2_plane_vaddr(&vb->vb, 0);
+	u8 *ptr = vb2_plane_vaddr(&vb->vb.vb2_buf, 0);
 
 	switch (format) {
 	case V4L2_PIX_FMT_MJPEG:
@@ -386,8 +386,9 @@ static void go7007_buf_queue(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct go7007 *go = vb2_get_drv_priv(vq);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct go7007_buffer *go7007_vb =
-		container_of(vb, struct go7007_buffer, vb);
+		container_of(vbuf, struct go7007_buffer, vb);
 	unsigned long flags;
 
 	spin_lock_irqsave(&go->spinlock, flags);
@@ -397,12 +398,13 @@ static void go7007_buf_queue(struct vb2_buffer *vb)
 
 static int go7007_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct go7007_buffer *go7007_vb =
-		container_of(vb, struct go7007_buffer, vb);
+		container_of(vbuf, struct go7007_buffer, vb);
 
 	go7007_vb->modet_active = 0;
 	go7007_vb->frame_offset = 0;
-	vb->v4l2_planes[0].bytesused = 0;
+	vb->planes[0].bytesused = 0;
 	return 0;
 }
 
@@ -410,15 +412,15 @@ static void go7007_buf_finish(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct go7007 *go = vb2_get_drv_priv(vq);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct go7007_buffer *go7007_vb =
-		container_of(vb, struct go7007_buffer, vb);
+		container_of(vbuf, struct go7007_buffer, vb);
 	u32 frame_type_flag = get_frame_type_flag(go7007_vb, go->format);
-	struct v4l2_buffer *buf = &vb->v4l2_buf;
 
-	buf->flags &= ~(V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_BFRAME |
+	vbuf->flags &= ~(V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_BFRAME |
 			V4L2_BUF_FLAG_PFRAME);
-	buf->flags |= frame_type_flag;
-	buf->field = V4L2_FIELD_NONE;
+	vbuf->flags |= frame_type_flag;
+	vbuf->field = V4L2_FIELD_NONE;
 }
 
 static int go7007_start_streaming(struct vb2_queue *q, unsigned int count)
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index fd1fa41..e1d4d16 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -21,6 +21,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
 /* HackRF USB API commands (from HackRF Library) */
@@ -85,7 +86,8 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct hackrf_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -287,13 +289,13 @@ static void hackrf_urb_complete(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
+		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		len = hackrf_convert_stream(dev, ptr, urb->transfer_buffer,
 				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb, 0, len);
-		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
-		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
+		v4l2_get_timestamp(&fbuf->vb.timestamp);
+		fbuf->vb.sequence = dev->sequence++;
+		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 skip:
 	usb_submit_urb(urb, GFP_ATOMIC);
@@ -437,7 +439,7 @@ static void hackrf_cleanup_queued_bufs(struct hackrf_dev *dev)
 		buf = list_entry(dev->queued_bufs.next,
 				struct hackrf_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -483,9 +485,10 @@ static int hackrf_queue_setup(struct vb2_queue *vq,
 
 static void hackrf_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct hackrf_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct hackrf_frame_buf *buf =
-			container_of(vb, struct hackrf_frame_buf, vb);
+			container_of(vbuf, struct hackrf_frame_buf, vb);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->queued_bufs_lock, flags);
@@ -539,7 +542,8 @@ err:
 
 		list_for_each_entry_safe(buf, tmp, &dev->queued_bufs, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 3f276d9..26a76e0 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -28,6 +28,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <linux/usb.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #include <linux/spi/spi.h>
 
@@ -112,7 +113,8 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct msi2500_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -431,10 +433,10 @@ static void msi2500_isoc_handler(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
+		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		flen = msi2500_convert_stream(dev, ptr, iso_buf, flen);
-		vb2_set_plane_payload(&fbuf->vb, 0, flen);
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, flen);
+		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 handler_end:
@@ -569,7 +571,7 @@ static void msi2500_cleanup_queued_bufs(struct msi2500_dev *dev)
 		buf = list_entry(dev->queued_bufs.next,
 				 struct msi2500_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -633,15 +635,16 @@ static int msi2500_queue_setup(struct vb2_queue *vq,
 
 static void msi2500_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct msi2500_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct msi2500_frame_buf *buf = container_of(vb,
+	struct msi2500_frame_buf *buf = container_of(vbuf,
 						     struct msi2500_frame_buf,
 						     vb);
 	unsigned long flags;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (unlikely(!dev->udev)) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 702267e..3f5395a 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -240,9 +240,9 @@ static void pwc_frame_complete(struct pwc_device *pdev)
 			PWC_DEBUG_FLOW("Frame buffer underflow (%d bytes);"
 				       " discarded.\n", fbuf->filled);
 		} else {
-			fbuf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
-			fbuf->vb.v4l2_buf.sequence = pdev->vframe_count;
-			vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+			fbuf->vb.field = V4L2_FIELD_NONE;
+			fbuf->vb.sequence = pdev->vframe_count;
+			vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 			pdev->fill_buf = NULL;
 			pdev->vsync = 0;
 		}
@@ -287,7 +287,7 @@ static void pwc_isoc_handler(struct urb *urb)
 		{
 			PWC_ERROR("Too many ISOC errors, bailing out.\n");
 			if (pdev->fill_buf) {
-				vb2_buffer_done(&pdev->fill_buf->vb,
+				vb2_buffer_done(&pdev->fill_buf->vb.vb2_buf,
 						VB2_BUF_STATE_ERROR);
 				pdev->fill_buf = NULL;
 			}
@@ -317,7 +317,7 @@ static void pwc_isoc_handler(struct urb *urb)
 
 			if (pdev->vsync == 1) {
 				v4l2_get_timestamp(
-					&fbuf->vb.v4l2_buf.timestamp);
+					&fbuf->vb.timestamp);
 				pdev->vsync = 2;
 			}
 
@@ -520,7 +520,7 @@ static void pwc_cleanup_queued_bufs(struct pwc_device *pdev,
 		buf = list_entry(pdev->queued_bufs.next, struct pwc_frame_buf,
 				 list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, state);
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
 	}
 	spin_unlock_irqrestore(&pdev->queued_bufs_lock, flags);
 }
@@ -594,7 +594,9 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int buffer_init(struct vb2_buffer *vb)
 {
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf =
+		container_of(vbuf, struct pwc_frame_buf, vb);
 
 	/* need vmalloc since frame buffer > 128K */
 	buf->data = vzalloc(PWC_FRAME_SIZE);
@@ -618,7 +620,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 static void buffer_finish(struct vb2_buffer *vb)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf =
+		container_of(vbuf, struct pwc_frame_buf, vb);
 
 	if (vb->state == VB2_BUF_STATE_DONE) {
 		/*
@@ -633,7 +637,9 @@ static void buffer_finish(struct vb2_buffer *vb)
 
 static void buffer_cleanup(struct vb2_buffer *vb)
 {
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf =
+		container_of(vbuf, struct pwc_frame_buf, vb);
 
 	vfree(buf->data);
 }
@@ -641,12 +647,14 @@ static void buffer_cleanup(struct vb2_buffer *vb)
 static void buffer_queue(struct vb2_buffer *vb)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf =
+		container_of(vbuf, struct pwc_frame_buf, vb);
 	unsigned long flags = 0;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (!pdev->udev) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
@@ -695,7 +703,8 @@ static void stop_streaming(struct vb2_queue *vq)
 
 	pwc_cleanup_queued_bufs(pdev, VB2_BUF_STATE_ERROR);
 	if (pdev->fill_buf)
-		vb2_buffer_done(&pdev->fill_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&pdev->fill_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	mutex_unlock(&pdev->v4l2_lock);
 }
 
diff --git a/drivers/media/usb/pwc/pwc-uncompress.c b/drivers/media/usb/pwc/pwc-uncompress.c
index b65903f..98c46f9 100644
--- a/drivers/media/usb/pwc/pwc-uncompress.c
+++ b/drivers/media/usb/pwc/pwc-uncompress.c
@@ -40,7 +40,7 @@ int pwc_decompress(struct pwc_device *pdev, struct pwc_frame_buf *fbuf)
 	u16 *src;
 	u16 *dsty, *dstu, *dstv;
 
-	image = vb2_plane_vaddr(&fbuf->vb, 0);
+	image = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 
 	yuv = fbuf->data + pdev->frame_header_size;  /* Skip header */
 
@@ -55,12 +55,12 @@ int pwc_decompress(struct pwc_device *pdev, struct pwc_frame_buf *fbuf)
 			 * determine this using the type of the webcam */
 		memcpy(raw_frame->cmd, pdev->cmd_buf, 4);
 		memcpy(raw_frame+1, yuv, pdev->frame_size);
-		vb2_set_plane_payload(&fbuf->vb, 0,
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
 			pdev->frame_size + sizeof(struct pwc_raw_frame));
 		return 0;
 	}
 
-	vb2_set_plane_payload(&fbuf->vb, 0,
+	vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
 			      pdev->width * pdev->height * 3 / 2);
 
 	if (pdev->vbandlength == 0) {
diff --git a/drivers/media/usb/pwc/pwc.h b/drivers/media/usb/pwc/pwc.h
index 81b017a..3c73bda 100644
--- a/drivers/media/usb/pwc/pwc.h
+++ b/drivers/media/usb/pwc/pwc.h
@@ -40,6 +40,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
 #include <linux/input.h>
@@ -210,7 +211,8 @@ struct pwc_raw_frame {
 /* intermediate buffers with raw data from the USB cam */
 struct pwc_frame_buf
 {
-	struct vb2_buffer vb;	/* common v4l buffer stuff -- must be first */
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 	void *data;
 	int filled;		/* number of bytes filled */
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 0f3c34d..32b5115 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -45,6 +45,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/usb.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
@@ -293,7 +294,7 @@ struct s2255_fmt {
 /* buffer for one video frame */
 struct s2255_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -573,14 +574,14 @@ static void s2255_got_frame(struct s2255_vc *vc, int jpgsize)
 	buf = list_entry(vc->buf_list.next,
 			 struct s2255_buffer, list);
 	list_del(&buf->list);
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	buf->vb.v4l2_buf.field = vc->field;
-	buf->vb.v4l2_buf.sequence = vc->frame_count;
+	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.field = vc->field;
+	buf->vb.sequence = vc->frame_count;
 	spin_unlock_irqrestore(&vc->qlock, flags);
 
 	s2255_fillbuff(vc, buf, jpgsize);
 	/* tell v4l buffer was filled */
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	dprintk(dev, 2, "%s: [buf] [%p]\n", __func__, buf);
 }
 
@@ -612,7 +613,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 {
 	int pos = 0;
 	const char *tmpbuf;
-	char *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	char *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	unsigned long last_frame;
 	struct s2255_dev *dev = vc->dev;
 
@@ -635,7 +636,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 			break;
 		case V4L2_PIX_FMT_JPEG:
 		case V4L2_PIX_FMT_MJPEG:
-			vb2_set_plane_payload(&buf->vb, 0, jpgsize);
+			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, jpgsize);
 			memcpy(vbuf, tmpbuf, jpgsize);
 			break;
 		case V4L2_PIX_FMT_YUV422P:
@@ -674,7 +675,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2_queue);
-	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct s2255_buffer *buf = container_of(vbuf, struct s2255_buffer, vb);
 	int w = vc->width;
 	int h = vc->height;
 	unsigned long size;
@@ -696,13 +698,14 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 	return 0;
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct s2255_buffer *buf = container_of(vbuf, struct s2255_buffer, vb);
 	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long flags = 0;
 	dprintk(vc->dev, 1, "%s\n", __func__);
@@ -1116,9 +1119,9 @@ static void stop_streaming(struct vb2_queue *vq)
 	spin_lock_irqsave(&vc->qlock, flags);
 	list_for_each_entry_safe(buf, node, &vc->buf_list, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		dprintk(vc->dev, 2, "[%p/%d] done\n",
-			buf, buf->vb.v4l2_buf.index);
+			buf, buf->vb.vb2_buf.index);
 	}
 	spin_unlock_irqrestore(&vc->qlock, flags);
 }
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index e12b103..10e35e6 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -695,8 +695,9 @@ static void buffer_queue(struct vb2_buffer *vb)
 {
 	unsigned long flags;
 	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct stk1160_buffer *buf =
-		container_of(vb, struct stk1160_buffer, vb);
+		container_of(vbuf, struct stk1160_buffer, vb);
 
 	spin_lock_irqsave(&dev->buf_lock, flags);
 	if (!dev->udev) {
@@ -704,7 +705,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		 * If the device is disconnected return the buffer to userspace
 		 * directly. The next QBUF call will fail with -ENODEV.
 		 */
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	} else {
 
 		buf->mem = vb2_plane_vaddr(vb, 0);
@@ -717,7 +718,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		 * the buffer to userspace directly.
 		 */
 		if (buf->length < dev->width * dev->height * 2)
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		else
 			list_add_tail(&buf->list, &dev->avail_bufs);
 
@@ -769,9 +770,9 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = list_first_entry(&dev->avail_bufs,
 			struct stk1160_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		stk1160_dbg("buffer [%p/%d] aborted\n",
-			    buf, buf->vb.v4l2_buf.index);
+			    buf, buf->vb.vb2_buf.index);
 	}
 
 	/* It's important to release the current buffer */
@@ -779,9 +780,9 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = dev->isoc_ctl.buf;
 		dev->isoc_ctl.buf = NULL;
 
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		stk1160_dbg("buffer [%p/%d] aborted\n",
-			    buf, buf->vb.v4l2_buf.index);
+			    buf, buf->vb.vb2_buf.index);
 	}
 	spin_unlock_irqrestore(&dev->buf_lock, flags);
 }
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 940c3ea..75654e6 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -96,13 +96,13 @@ void stk1160_buffer_done(struct stk1160 *dev)
 {
 	struct stk1160_buffer *buf = dev->isoc_ctl.buf;
 
-	buf->vb.v4l2_buf.sequence = dev->sequence++;
-	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
-	buf->vb.v4l2_buf.bytesused = buf->bytesused;
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	buf->vb.sequence = dev->sequence++;
+	buf->vb.field = V4L2_FIELD_INTERLACED;
+	buf->vb.vb2_buf.planes[0].bytesused = buf->bytesused;
+	v4l2_get_timestamp(&buf->vb.timestamp);
 
-	vb2_set_plane_payload(&buf->vb, 0, buf->bytesused);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->bytesused);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
 	dev->isoc_ctl.buf = NULL;
 }
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index 047131b..1ed1cc4 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -77,7 +77,7 @@
 /* Buffer for one video frame */
 struct stk1160_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	void *mem;
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index a46766c..ce5d502 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -306,7 +306,7 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 
 	/* First available buffer. */
 	buf = list_first_entry(&usbtv->bufs, struct usbtv_buf, list);
-	frame = vb2_plane_vaddr(&buf->vb, 0);
+	frame = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 
 	/* Copy the chunk data. */
 	usbtv_chunk_to_vbuf(frame, &chunk[1], chunk_no, odd);
@@ -314,17 +314,17 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 
 	/* Last chunk in a frame, signalling an end */
 	if (odd && chunk_no == usbtv->n_chunks-1) {
-		int size = vb2_plane_size(&buf->vb, 0);
+		int size = vb2_plane_size(&buf->vb.vb2_buf, 0);
 		enum vb2_buffer_state state = usbtv->chunks_done ==
 						usbtv->n_chunks ?
 						VB2_BUF_STATE_DONE :
 						VB2_BUF_STATE_ERROR;
 
-		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
-		buf->vb.v4l2_buf.sequence = usbtv->sequence++;
-		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-		vb2_set_plane_payload(&buf->vb, 0, size);
-		vb2_buffer_done(&buf->vb, state);
+		buf->vb.field = V4L2_FIELD_INTERLACED;
+		buf->vb.sequence = usbtv->sequence++;
+		v4l2_get_timestamp(&buf->vb.timestamp);
+		vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
 		list_del(&buf->list);
 	}
 
@@ -422,7 +422,7 @@ static void usbtv_stop(struct usbtv *usbtv)
 	while (!list_empty(&usbtv->bufs)) {
 		struct usbtv_buf *buf = list_first_entry(&usbtv->bufs,
 						struct usbtv_buf, list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&buf->list);
 	}
 	spin_unlock_irqrestore(&usbtv->buflock, flags);
@@ -617,8 +617,9 @@ static int usbtv_queue_setup(struct vb2_queue *vq,
 
 static void usbtv_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct usbtv *usbtv = vb2_get_drv_priv(vb->vb2_queue);
-	struct usbtv_buf *buf = container_of(vb, struct usbtv_buf, vb);
+	struct usbtv_buf *buf = container_of(vbuf, struct usbtv_buf, vb);
 	unsigned long flags;
 
 	if (usbtv->udev == NULL) {
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
index 9681195..19cb8bf 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -24,6 +24,7 @@
 #include <linux/usb.h>
 
 #include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
 /* Hardware. */
@@ -61,7 +62,7 @@ struct usbtv_norm_params {
 
 /* A single videobuf2 frame buffer. */
 struct usbtv_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index f16b9b4..b49bcab 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -20,6 +20,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
 #include "uvcvideo.h"
@@ -60,7 +61,7 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
 							  queue);
 		list_del(&buf->queue);
 		buf->state = state;
-		vb2_buffer_done(&buf->buf, vb2_state);
+		vb2_buffer_done(&buf->buf.vb2_buf, vb2_state);
 	}
 }
 
@@ -89,10 +90,11 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int uvc_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 
-	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
 	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
 		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
 		return -EINVAL;
@@ -105,7 +107,7 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	buf->error = 0;
 	buf->mem = vb2_plane_vaddr(vb, 0);
 	buf->length = vb2_plane_size(vb, 0);
-	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
 	else
 		buf->bytesused = vb2_get_plane_payload(vb, 0);
@@ -115,8 +117,9 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 
 static void uvc_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 	unsigned long flags;
 
 	spin_lock_irqsave(&queue->irqlock, flags);
@@ -127,7 +130,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 		 * directly. The next QBUF call will fail with -ENODEV.
 		 */
 		buf->state = UVC_BUF_STATE_ERROR;
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&queue->irqlock, flags);
@@ -135,12 +138,13 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 
 static void uvc_buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 
 	if (vb->state == VB2_BUF_STATE_DONE)
-		uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
+		uvc_video_clock_update(stream, vbuf, buf);
 }
 
 static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -398,7 +402,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		buf->error = 0;
 		buf->state = UVC_BUF_STATE_QUEUED;
 		buf->bytesused = 0;
-		vb2_set_plane_payload(&buf->buf, 0, 0);
+		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
 		return buf;
 	}
 
@@ -412,8 +416,8 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
 	buf->state = buf->error ? VB2_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
-	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
-	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
+	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
+	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return nextbuf;
 }
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index f839654..4160212 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -606,7 +606,7 @@ static u16 uvc_video_clock_host_sof(const struct uvc_clock_sample *sample)
  * timestamp of the sliding window to 1s.
  */
 void uvc_video_clock_update(struct uvc_streaming *stream,
-			    struct v4l2_buffer *v4l2_buf,
+			    struct vb2_v4l2_buffer *vbuf,
 			    struct uvc_buffer *buf)
 {
 	struct uvc_clock *clock = &stream->clock;
@@ -696,14 +696,14 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 		  stream->dev->name,
 		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
 		  y, ts.tv_sec, ts.tv_nsec / NSEC_PER_USEC,
-		  v4l2_buf->timestamp.tv_sec,
-		  (unsigned long)v4l2_buf->timestamp.tv_usec,
+		  vbuf->timestamp.tv_sec,
+		  (unsigned long)vbuf->timestamp.tv_usec,
 		  x1, first->host_sof, first->dev_sof,
 		  x2, last->host_sof, last->dev_sof, y1, y2);
 
 	/* Update the V4L2 buffer. */
-	v4l2_buf->timestamp.tv_sec = ts.tv_sec;
-	v4l2_buf->timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	vbuf->timestamp.tv_sec = ts.tv_sec;
+	vbuf->timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 
 done:
 	spin_unlock_irqrestore(&stream->clock.lock, flags);
@@ -1029,10 +1029,10 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 
 		uvc_video_get_ts(&ts);
 
-		buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
-		buf->buf.v4l2_buf.sequence = stream->sequence;
-		buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
-		buf->buf.v4l2_buf.timestamp.tv_usec =
+		buf->buf.field = V4L2_FIELD_NONE;
+		buf->buf.sequence = stream->sequence;
+		buf->buf.timestamp.tv_sec = ts.tv_sec;
+		buf->buf.timestamp.tv_usec =
 			ts.tv_nsec / NSEC_PER_USEC;
 
 		/* TODO: Handle PTS and SCR. */
@@ -1305,7 +1305,7 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
 		if (buf->bytesused == stream->queue.buf_used) {
 			stream->queue.buf_used = 0;
 			buf->state = UVC_BUF_STATE_READY;
-			buf->buf.v4l2_buf.sequence = ++stream->sequence;
+			buf->buf.sequence = ++stream->sequence;
 			uvc_queue_next_buffer(&stream->queue, buf);
 			stream->last_fid ^= UVC_STREAM_FID;
 		}
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 53e6484..94bc7a8 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -354,7 +354,7 @@ enum uvc_buffer_state {
 };
 
 struct uvc_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
 	enum uvc_buffer_state state;
@@ -673,7 +673,7 @@ extern int uvc_probe_video(struct uvc_streaming *stream,
 extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 		__u8 intfnum, __u8 cs, void *data, __u16 size);
 void uvc_video_clock_update(struct uvc_streaming *stream,
-			    struct v4l2_buffer *v4l2_buf,
+			    struct vb2_v4l2_buffer *vbuf,
 			    struct uvc_buffer *buf);
 
 /* Status */
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 38703bd..d3b7192 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -773,13 +773,15 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
  *
  * Call from buf_queue(), videobuf_queue_ops callback.
  */
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb)
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
+		struct vb2_v4l2_buffer *vbuf)
 {
-	struct v4l2_m2m_buffer *b = container_of(vb, struct v4l2_m2m_buffer, vb);
+	struct v4l2_m2m_buffer *b = container_of(vbuf,
+				struct v4l2_m2m_buffer, vb);
 	struct v4l2_m2m_queue_ctx *q_ctx;
 	unsigned long flags;
 
-	q_ctx = get_queue_ctx(m2m_ctx, vb->vb2_queue->type);
+	q_ctx = get_queue_ctx(m2m_ctx, vbuf->vb2_buf.vb2_queue->type);
 	if (!q_ctx)
 		return;
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 87048a1..fbcc1c3 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -428,8 +428,8 @@ vpfe_video_get_next_buffer(struct vpfe_video_device *video)
 			   struct vpfe_cap_buffer, list);
 
 	list_del(&video->next_frm->list);
-	video->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
-	return vb2_dma_contig_plane_dma_addr(&video->next_frm->vb, 0);
+	video->next_frm->vb.vb2_buf.state = VB2_BUF_STATE_ACTIVE;
+	return vb2_dma_contig_plane_dma_addr(&video->next_frm->vb.vb2_buf, 0);
 }
 
 /* schedule the next buffer which is available on dma queue */
@@ -448,8 +448,8 @@ void vpfe_video_schedule_next_buffer(struct vpfe_video_device *video)
 		video->cur_frm = video->next_frm;
 
 	list_del(&video->next_frm->list);
-	video->next_frm->vb.state = VB2_BUF_STATE_ACTIVE;
-	addr = vb2_dma_contig_plane_dma_addr(&video->next_frm->vb, 0);
+	video->next_frm->vb.vb2_buf.state = VB2_BUF_STATE_ACTIVE;
+	addr = vb2_dma_contig_plane_dma_addr(&video->next_frm->vb.vb2_buf, 0);
 	video->ops->queue(vpfe_dev, addr);
 	video->state = VPFE_VIDEO_BUFFER_QUEUED;
 }
@@ -460,7 +460,7 @@ void vpfe_video_schedule_bottom_field(struct vpfe_video_device *video)
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	unsigned long addr;
 
-	addr = vb2_dma_contig_plane_dma_addr(&video->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&video->cur_frm->vb.vb2_buf, 0);
 	addr += video->field_off;
 	video->ops->queue(vpfe_dev, addr);
 }
@@ -470,8 +470,8 @@ void vpfe_video_process_buffer_complete(struct vpfe_video_device *video)
 {
 	struct vpfe_pipeline *pipe = &video->pipe;
 
-	v4l2_get_timestamp(&video->cur_frm->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&video->cur_frm->vb.timestamp);
+	vb2_buffer_done(&video->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
 		video->cur_frm = video->next_frm;
 }
@@ -1138,12 +1138,13 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 
 static void vpfe_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	/* Get the file handle object and device object */
 	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpfe_video_device *video = fh->video;
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	struct vpfe_pipeline *pipe = &video->pipe;
-	struct vpfe_cap_buffer *buf = container_of(vb,
+	struct vpfe_cap_buffer *buf = container_of(vbuf,
 				struct vpfe_cap_buffer, vb);
 	unsigned long flags;
 	unsigned long empty;
@@ -1203,10 +1204,10 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Remove buffer from the buffer queue */
 	list_del(&video->cur_frm->list);
 	/* Mark state of the current frame to active */
-	video->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+	video->cur_frm->vb.vb2_buf.state = VB2_BUF_STATE_ACTIVE;
 	/* Initialize field_id and started member */
 	video->field_id = 0;
-	addr = vb2_dma_contig_plane_dma_addr(&video->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&video->cur_frm->vb.vb2_buf, 0);
 	video->ops->queue(vpfe_dev, addr);
 	video->state = VPFE_VIDEO_BUFFER_QUEUED;
 
@@ -1214,10 +1215,12 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret) {
 		struct vpfe_cap_buffer *buf, *tmp;
 
-		vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&video->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_QUEUED);
 		list_for_each_entry_safe(buf, tmp, &video->dma_queue, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 		goto unlock_out;
 	}
@@ -1234,7 +1237,8 @@ streamoff:
 
 static int vpfe_buffer_init(struct vb2_buffer *vb)
 {
-	struct vpfe_cap_buffer *buf = container_of(vb,
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vpfe_cap_buffer *buf = container_of(vbuf,
 						   struct vpfe_cap_buffer, vb);
 
 	INIT_LIST_HEAD(&buf->list);
@@ -1249,13 +1253,14 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 
 	/* release all active buffers */
 	if (video->cur_frm == video->next_frm) {
-		vb2_buffer_done(&video->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&video->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	} else {
 		if (video->cur_frm != NULL)
-			vb2_buffer_done(&video->cur_frm->vb,
+			vb2_buffer_done(&video->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 		if (video->next_frm != NULL)
-			vb2_buffer_done(&video->next_frm->vb,
+			vb2_buffer_done(&video->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -1263,16 +1268,18 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 		video->next_frm = list_entry(video->dma_queue.next,
 						struct vpfe_cap_buffer, list);
 		list_del(&video->next_frm->list);
-		vb2_buffer_done(&video->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&video->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 }
 
 static void vpfe_buf_cleanup(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpfe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpfe_video_device *video = fh->video;
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
-	struct vpfe_cap_buffer *buf = container_of(vb,
+	struct vpfe_cap_buffer *buf = container_of(vbuf,
 					struct vpfe_cap_buffer, vb);
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buf_cleanup\n");
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
index 1b1b6c4..673cefe 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
@@ -22,6 +22,7 @@
 #ifndef _DAVINCI_VPFE_VIDEO_H
 #define _DAVINCI_VPFE_VIDEO_H
 
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 struct vpfe_device;
@@ -72,7 +73,7 @@ struct vpfe_pipeline {
 	container_of(vdev, struct vpfe_video_device, video_dev)
 
 struct vpfe_cap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 40405d8..e0cf499 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -311,7 +311,8 @@ static int iss_video_queue_setup(struct vb2_queue *vq,
 
 static void iss_video_buf_cleanup(struct vb2_buffer *vb)
 {
-	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct iss_buffer *buffer = container_of(vbuf, struct iss_buffer, vb);
 
 	if (buffer->iss_addr)
 		buffer->iss_addr = 0;
@@ -319,8 +320,9 @@ static void iss_video_buf_cleanup(struct vb2_buffer *vb)
 
 static int iss_video_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct iss_video_fh *vfh = vb2_get_drv_priv(vb->vb2_queue);
-	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
+	struct iss_buffer *buffer = container_of(vbuf, struct iss_buffer, vb);
 	struct iss_video *video = vfh->video;
 	unsigned long size = vfh->format.fmt.pix.sizeimage;
 	dma_addr_t addr;
@@ -342,9 +344,10 @@ static int iss_video_buf_prepare(struct vb2_buffer *vb)
 
 static void iss_video_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct iss_video_fh *vfh = vb2_get_drv_priv(vb->vb2_queue);
 	struct iss_video *video = vfh->video;
-	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
+	struct iss_buffer *buffer = container_of(vbuf, struct iss_buffer, vb);
 	struct iss_pipeline *pipe = to_iss_pipeline(&video->video.entity);
 	unsigned long flags;
 	bool empty;
@@ -434,8 +437,8 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	spin_unlock_irqrestore(&video->qlock, flags);
 
 	ktime_get_ts(&ts);
-	buf->vb.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
-	buf->vb.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	buf->vb.timestamp.tv_sec = ts.tv_sec;
+	buf->vb.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
@@ -444,12 +447,12 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	 * first, so the input number might lag behind by 1 in some cases.
 	 */
 	if (video == pipe->output && !pipe->do_propagation)
-		buf->vb.v4l2_buf.sequence =
+		buf->vb.sequence =
 			atomic_inc_return(&pipe->frame_number);
 	else
-		buf->vb.v4l2_buf.sequence = atomic_read(&pipe->frame_number);
+		buf->vb.sequence = atomic_read(&pipe->frame_number);
 
-	vb2_buffer_done(&buf->vb, pipe->error ?
+	vb2_buffer_done(&buf->vb.vb2_buf, pipe->error ?
 			VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 	pipe->error = false;
 
@@ -480,7 +483,7 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	buf = list_first_entry(&video->dmaqueue, struct iss_buffer,
 			       list);
 	spin_unlock_irqrestore(&video->qlock, flags);
-	buf->vb.state = VB2_BUF_STATE_ACTIVE;
+	buf->vb.vb2_buf.state = VB2_BUF_STATE_ACTIVE;
 	return buf;
 }
 
@@ -503,7 +506,7 @@ void omap4iss_video_cancel_stream(struct iss_video *video)
 		buf = list_first_entry(&video->dmaqueue, struct iss_buffer,
 				       list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	vb2_queue_error(video->queue);
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index f11fce2..41532ed 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -18,7 +18,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
-#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
 #define ISS_VIDEO_DRIVER_NAME		"issvideo"
@@ -117,12 +117,12 @@ static inline int iss_pipeline_ready(struct iss_pipeline *pipe)
  */
 struct iss_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 	dma_addr_t iss_addr;
 };
 
-#define to_iss_buffer(buf)	container_of(buf, struct iss_buffer, buffer)
+#define to_iss_buffer(buf)	container_of(buf, struct iss_buffer, vb)
 
 enum iss_video_dmaqueue_flags {
 	/* Set if DMA queue becomes empty when ISS_PIPELINE_STREAM_CONTINUOUS */
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index d617c39..3628938 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -61,9 +61,10 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static int uvc_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 
-	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
 	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
 		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
 		return -EINVAL;
@@ -75,7 +76,7 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	buf->state = UVC_BUF_STATE_QUEUED;
 	buf->mem = vb2_plane_vaddr(vb, 0);
 	buf->length = vb2_plane_size(vb, 0);
-	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
 	else
 		buf->bytesused = vb2_get_plane_payload(vb, 0);
@@ -86,7 +87,8 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 static void uvc_buffer_queue(struct vb2_buffer *vb)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 	unsigned long flags;
 
 	spin_lock_irqsave(&queue->irqlock, flags);
@@ -98,7 +100,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 		 * directly. The next QBUF call will fail with -ENODEV.
 		 */
 		buf->state = UVC_BUF_STATE_ERROR;
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&queue->irqlock, flags);
@@ -242,7 +244,7 @@ void uvcg_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 				       queue);
 		list_del(&buf->queue);
 		buf->state = UVC_BUF_STATE_ERROR;
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_queue_buffer and the disconnection event that
@@ -314,7 +316,7 @@ struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
 	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
 	     buf->length != buf->bytesused) {
 		buf->state = UVC_BUF_STATE_QUEUED;
-		vb2_set_plane_payload(&buf->buf, 0, 0);
+		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
 		return buf;
 	}
 
@@ -325,12 +327,12 @@ struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
 	else
 		nextbuf = NULL;
 
-	buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
-	buf->buf.v4l2_buf.sequence = queue->sequence++;
-	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
+	buf->buf.field = V4L2_FIELD_NONE;
+	buf->buf.sequence = queue->sequence++;
+	v4l2_get_timestamp(&buf->buf.timestamp);
 
-	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
-	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
+	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
+	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return nextbuf;
 }
diff --git a/drivers/usb/gadget/function/uvc_queue.h b/drivers/usb/gadget/function/uvc_queue.h
index 0ffe498..ac461a9 100644
--- a/drivers/usb/gadget/function/uvc_queue.h
+++ b/drivers/usb/gadget/function/uvc_queue.h
@@ -26,7 +26,7 @@ enum uvc_buffer_state {
 };
 
 struct uvc_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
 	enum uvc_buffer_state state;
diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
index fa0247a..e14a937 100644
--- a/include/media/davinci/vpbe_display.h
+++ b/include/media/davinci/vpbe_display.h
@@ -17,6 +17,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-fh.h>
+#include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/davinci/vpbe_types.h>
 #include <media/davinci/vpbe_osd.h>
@@ -64,7 +65,7 @@ struct display_layer_info {
 };
 
 struct vpbe_disp_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 5c60da9..5a9597d 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -90,7 +90,7 @@ struct v4l2_m2m_ctx {
 };
 
 struct v4l2_m2m_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 };
 
@@ -105,9 +105,9 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx);
 
 static inline void
-v4l2_m2m_buf_done(struct vb2_buffer *buf, enum vb2_buffer_state state)
+v4l2_m2m_buf_done(struct vb2_v4l2_buffer *buf, enum vb2_buffer_state state)
 {
-	vb2_buffer_done(buf, state);
+	vb2_buffer_done(&buf->vb2_buf, state);
 }
 
 int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
@@ -160,7 +160,8 @@ static inline void v4l2_m2m_set_dst_buffered(struct v4l2_m2m_ctx *m2m_ctx,
 
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
 
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
+			struct vb2_v4l2_buffer *vbuf);
 
 /**
  * v4l2_m2m_num_src_bufs_ready() - return the number of source buffers ready for
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index dbf017b..b015b38 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -202,27 +202,28 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 	),
 
 	TP_fast_assign(
+		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 		__entry->minor = q->owner ? q->owner->vdev->minor : -1;
 		__entry->queued_count = q->queued_count;
 		__entry->owned_by_drv_count =
 			atomic_read(&q->owned_by_drv_count);
-		__entry->index = vb->v4l2_buf.index;
-		__entry->type = vb->v4l2_buf.type;
-		__entry->bytesused = vb->v4l2_planes[0].bytesused;
-		__entry->flags = vb->v4l2_buf.flags;
-		__entry->field = vb->v4l2_buf.field;
-		__entry->timestamp = timeval_to_ns(&vb->v4l2_buf.timestamp);
-		__entry->timecode_type = vb->v4l2_buf.timecode.type;
-		__entry->timecode_flags = vb->v4l2_buf.timecode.flags;
-		__entry->timecode_frames = vb->v4l2_buf.timecode.frames;
-		__entry->timecode_seconds = vb->v4l2_buf.timecode.seconds;
-		__entry->timecode_minutes = vb->v4l2_buf.timecode.minutes;
-		__entry->timecode_hours = vb->v4l2_buf.timecode.hours;
-		__entry->timecode_userbits0 = vb->v4l2_buf.timecode.userbits[0];
-		__entry->timecode_userbits1 = vb->v4l2_buf.timecode.userbits[1];
-		__entry->timecode_userbits2 = vb->v4l2_buf.timecode.userbits[2];
-		__entry->timecode_userbits3 = vb->v4l2_buf.timecode.userbits[3];
-		__entry->sequence = vb->v4l2_buf.sequence;
+		__entry->index = vb->index;
+		__entry->type = vb->type;
+		__entry->bytesused = vb->planes[0].bytesused;
+		__entry->flags = vbuf->flags;
+		__entry->field = vbuf->field;
+		__entry->timestamp = timeval_to_ns(&vbuf->timestamp);
+		__entry->timecode_type = vbuf->timecode.type;
+		__entry->timecode_flags = vbuf->timecode.flags;
+		__entry->timecode_frames = vbuf->timecode.frames;
+		__entry->timecode_seconds = vbuf->timecode.seconds;
+		__entry->timecode_minutes = vbuf->timecode.minutes;
+		__entry->timecode_hours = vbuf->timecode.hours;
+		__entry->timecode_userbits0 = vbuf->timecode.userbits[0];
+		__entry->timecode_userbits1 = vbuf->timecode.userbits[1];
+		__entry->timecode_userbits2 = vbuf->timecode.userbits[2];
+		__entry->timecode_userbits3 = vbuf->timecode.userbits[3];
+		__entry->sequence = vbuf->sequence;
 	),
 
 	TP_printk("minor = %d, queued = %u, owned_by_drv = %d, index = %u, "
-- 
1.7.9.5

