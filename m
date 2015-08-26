Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56185 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933218AbbHZL7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 07:59:39 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NTO016FUUNBAQ30@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Aug 2015 20:59:35 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	jh1009.sung@samsung.com, rany.kwon@samsung.com
Subject: [RFC PATCH v3 3/5] media: videobuf2: Modify all device drivers
Date: Wed, 26 Aug 2015 20:59:30 +0900
Message-id: <1440590372-2377-4-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
References: <1440590372-2377-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify all device drivers related with previous change that restructures
vb2_buffer for common use.
Actually, not all device drivers, yet. So, it required to modifiy more file
to complete this patch.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/input/touchscreen/sur40.c                  |   17 +++---
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   14 ++---
 drivers/media/pci/cobalt/cobalt-driver.h           |    2 +-
 drivers/media/pci/cobalt/cobalt-irq.c              |    8 +--
 drivers/media/pci/cobalt/cobalt-v4l2.c             |    8 +--
 drivers/media/pci/cx23885/cx23885-417.c            |   11 ++--
 drivers/media/pci/cx23885/cx23885-core.c           |   24 +++++----
 drivers/media/pci/cx23885/cx23885-dvb.c            |    9 ++--
 drivers/media/pci/cx23885/cx23885-vbi.c            |   16 +++---
 drivers/media/pci/cx23885/cx23885-video.c          |   27 +++++-----
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |   21 ++++----
 drivers/media/pci/cx25821/cx25821.h                |    3 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   13 +++--
 drivers/media/pci/cx88/cx88-core.c                 |    8 +--
 drivers/media/pci/cx88/cx88-dvb.c                  |   11 ++--
 drivers/media/pci/cx88/cx88-mpeg.c                 |   14 ++---
 drivers/media/pci/cx88/cx88-vbi.c                  |   17 +++---
 drivers/media/pci/cx88/cx88-video.c                |   19 ++++---
 drivers/media/pci/cx88/cx88.h                      |    2 +-
 drivers/media/pci/dt3155/dt3155.c                  |   17 +++---
 drivers/media/pci/dt3155/dt3155.h                  |    3 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |   19 ++++---
 drivers/media/pci/saa7134/saa7134-core.c           |   14 ++---
 drivers/media/pci/saa7134/saa7134-ts.c             |   14 +++--
 drivers/media/pci/saa7134/saa7134-vbi.c            |   10 ++--
 drivers/media/pci/saa7134/saa7134-video.c          |   21 +++++---
 drivers/media/pci/saa7134/saa7134.h                |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    2 +-
 drivers/media/pci/solo6x10/solo6x10.h              |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   12 ++---
 drivers/media/pci/tw68/tw68-video.c                |   10 ++--
 drivers/media/pci/tw68/tw68.h                      |    2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   20 ++++----
 drivers/media/platform/am437x/am437x-vpfe.h        |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   10 ++--
 drivers/media/platform/davinci/vpif_capture.c      |   17 +++---
 drivers/media/platform/davinci/vpif_capture.h      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |   27 +++++-----
 drivers/media/platform/davinci/vpif_display.h      |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   13 ++---
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   10 ++--
 drivers/media/platform/exynos4-is/fimc-lite.h      |    2 +-
 drivers/media/platform/m2m-deinterlace.c           |   23 +++++----
 drivers/media/platform/marvell-ccic/mcam-core.c    |   43 +++++++++-------
 drivers/media/platform/omap3isp/ispvideo.c         |   19 +++----
 drivers/media/platform/omap3isp/ispvideo.h         |    2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   10 ++--
 drivers/media/platform/s3c-camif/camif-core.h      |    2 +-
 drivers/media/platform/s5p-tv/mixer.h              |    2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c          |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    8 +--
 drivers/media/platform/sh_veu.c                    |   19 +++----
 drivers/media/platform/sh_vou.c                    |   15 +++---
 drivers/media/platform/soc_camera/atmel-isi.c      |    6 +--
 drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    4 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 drivers/media/platform/vivid/vivid-core.h          |    2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   54 ++++++++++----------
 drivers/media/platform/vivid/vivid-kthread-out.c   |   34 ++++++------
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   15 +++---
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   23 +++++----
 drivers/media/platform/vivid/vivid-vbi-out.c       |    3 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |    3 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |    3 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   10 ++--
 drivers/media/platform/vsp1/vsp1_video.h           |    2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   18 +++----
 drivers/media/usb/airspy/airspy.c                  |   17 +++---
 drivers/media/usb/au0828/au0828-vbi.c              |    6 +--
 drivers/media/usb/au0828/au0828-video.c            |   45 ++++++++--------
 drivers/media/usb/au0828/au0828.h                  |    3 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   22 ++++----
 drivers/media/usb/em28xx/em28xx.h                  |    3 +-
 drivers/media/usb/go7007/go7007-driver.c           |   24 ++++-----
 drivers/media/usb/go7007/go7007-priv.h             |    2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   20 ++++----
 drivers/media/usb/hackrf/hackrf.c                  |   15 +++---
 drivers/media/usb/msi2500/msi2500.c                |   10 ++--
 drivers/media/usb/pwc/pwc-if.c                     |   29 ++++++-----
 drivers/media/usb/pwc/pwc-uncompress.c             |    8 +--
 drivers/media/usb/pwc/pwc.h                        |    3 +-
 drivers/media/usb/s2255/s2255drv.c                 |   27 +++++-----
 drivers/media/usb/stk1160/stk1160-v4l.c            |   15 +++---
 drivers/media/usb/stk1160/stk1160-video.c          |   12 ++---
 drivers/media/usb/stk1160/stk1160.h                |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   19 +++----
 drivers/media/usb/usbtv/usbtv.h                    |    3 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   26 ++++++----
 drivers/media/usb/uvc/uvc_video.c                  |   20 ++++----
 drivers/media/usb/uvc/uvcvideo.h                   |    4 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |    8 +--
 drivers/usb/gadget/function/uvc_queue.c            |   26 +++++-----
 drivers/usb/gadget/function/uvc_queue.h            |    2 +-
 include/media/v4l2-mem2mem.h                       |    9 ++--
 include/trace/events/v4l2.h                        |   35 +++++++------
 102 files changed, 670 insertions(+), 560 deletions(-)

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
index d5b994f..3501215 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -107,7 +107,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct rtl2832_sdr_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -307,10 +307,10 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
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
@@ -464,7 +464,7 @@ static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_dev *dev)
 		buf = list_entry(dev->queued_bufs.next,
 				struct rtl2832_sdr_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -525,7 +525,7 @@ static void rtl2832_sdr_buf_queue(struct vb2_buffer *vb)
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (!dev->udev) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index c206df9..b184be0 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -206,7 +206,7 @@ struct sg_dma_desc_info {
 #define COBALT_STREAM_FL_ADV_IRQ		1
 
 struct cobalt_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index dd4bff9..cecadd0 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -134,12 +134,12 @@ done:
 		skip = true;
 		s->skip_first_frames--;
 	}
-	v4l2_get_timestamp(&cb->vb.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&cb->vb.timestamp);
 	/* TODO: the sequence number should be read from the FPGA so we
 	   also know about dropped frames. */
-	cb->vb.v4l2_buf.sequence = s->sequence++;
-	vb2_buffer_done(&cb->vb, (skip || s->unstable_frame) ?
-			VB2_BUF_STATE_QUEUED : VB2_BUF_STATE_DONE);
+	cb->vb.sequence = s->sequence++;
+	vb2_buffer_done(&cb->vb.vb2_buf,
+			(skip || s->unstable_frame) ? VB2_BUF_STATE_QUEUED : VB2_BUF_STATE_DONE);
 }
 
 irqreturn_t cobalt_irq_handler(int irq, void *dev_id)
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 9756fd3..e72480a 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -128,7 +128,7 @@ static void chain_all_buffers(struct cobalt_stream *s)
 
 	list_for_each(p, &s->bufs) {
 		cb = list_entry(p, struct cobalt_buffer, list);
-		desc[i] = &s->dma_desc_info[cb->vb.v4l2_buf.index];
+		desc[i] = &s->dma_desc_info[cb->vb.vb2_buf.index];
 		if (i > 0)
 			descriptor_list_chain(desc[i-1], desc[i]);
 		i++;
@@ -284,7 +284,7 @@ static void cobalt_dma_start_streaming(struct cobalt_stream *s)
 			  &vo->control);
 	}
 	cb = list_first_entry(&s->bufs, struct cobalt_buffer, list);
-	omni_sg_dma_start(s, &s->dma_desc_info[cb->vb.v4l2_buf.index]);
+	omni_sg_dma_start(s, &s->dma_desc_info[cb->vb.vb2_buf.index]);
 	spin_unlock_irqrestore(&s->irqlock, flags);
 }
 
@@ -381,7 +381,7 @@ static void cobalt_dma_stop_streaming(struct cobalt_stream *s)
 	spin_lock_irqsave(&s->irqlock, flags);
 	list_for_each(p, &s->bufs) {
 		cb = list_entry(p, struct cobalt_buffer, list);
-		desc = &s->dma_desc_info[cb->vb.v4l2_buf.index];
+		desc = &s->dma_desc_info[cb->vb.vb2_buf.index];
 		/* Stop DMA after this descriptor chain */
 		descriptor_list_end_of_chain(desc);
 	}
@@ -416,7 +416,7 @@ static void cobalt_stop_streaming(struct vb2_queue *q)
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
index 53fff54..fb71f2f 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -734,7 +734,7 @@ static void solo_enc_stop_streaming(struct vb2_queue *q)
 				struct solo_vb2_buf, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&solo_enc->av_lock, flags);
 }
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
index 8355e55..ae06535 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -528,7 +528,7 @@ static void tw68_stop_streaming(struct vb2_queue *q)
 			container_of(dev->active.next, struct tw68_buf, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 }
 
@@ -1012,10 +1012,10 @@ void tw68_irq_video_done(struct tw68_dev *dev, unsigned long status)
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
index ef51e4d..9e713ef 100644
--- a/drivers/media/pci/tw68/tw68.h
+++ b/drivers/media/pci/tw68/tw68.h
@@ -118,7 +118,7 @@ struct tw68_dev;	/* forward delclaration */
 
 /* buffer for one video/vbi/ts frame */
 struct tw68_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	unsigned int   size;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index c8447fa..85649ca 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1280,10 +1280,10 @@ static inline void vpfe_schedule_bottom_field(struct vpfe_device *vpfe)
  */
 static inline void vpfe_process_buffer_complete(struct vpfe_device *vpfe)
 {
-	v4l2_get_timestamp(&vpfe->cur_frm->vb.v4l2_buf.timestamp);
-	vpfe->cur_frm->vb.v4l2_buf.field = vpfe->fmt.fmt.pix.field;
-	vpfe->cur_frm->vb.v4l2_buf.sequence = vpfe->sequence++;
-	vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&vpfe->cur_frm->vb.timestamp);
+	vpfe->cur_frm->vb.field = vpfe->fmt.fmt.pix.field;
+	vpfe->cur_frm->vb.sequence = vpfe->sequence++;
+	vb2_buffer_done(&vpfe->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	vpfe->cur_frm = vpfe->next_frm;
 }
 
@@ -2023,7 +2023,7 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &vpfe->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 
 	return ret;
@@ -2055,13 +2055,14 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
 	if (vpfe->cur_frm == vpfe->next_frm) {
-		vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&vpfe->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	} else {
 		if (vpfe->cur_frm != NULL)
-			vb2_buffer_done(&vpfe->cur_frm->vb,
+			vb2_buffer_done(&vpfe->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 		if (vpfe->next_frm != NULL)
-			vb2_buffer_done(&vpfe->next_frm->vb,
+			vb2_buffer_done(&vpfe->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -2069,7 +2070,8 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 		vpfe->next_frm = list_entry(vpfe->dma_queue.next,
 						struct vpfe_cap_buffer, list);
 		list_del(&vpfe->next_frm->list);
-		vb2_buffer_done(&vpfe->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&vpfe->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
 }
diff --git a/drivers/media/platform/am437x/am437x-vpfe.h b/drivers/media/platform/am437x/am437x-vpfe.h
index 5bfb356..587a09f 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.h
+++ b/drivers/media/platform/am437x/am437x-vpfe.h
@@ -104,7 +104,7 @@ struct vpfe_config {
 };
 
 struct vpfe_cap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index b7e70fb..4bb3208 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -54,7 +54,7 @@ struct bcap_format {
 };
 
 struct bcap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -344,7 +344,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &bcap_dev->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 
 	return ret;
@@ -367,13 +367,15 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 
 	/* release all active buffers */
 	if (bcap_dev->cur_frm)
-		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&bcap_dev->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 
 	while (!list_empty(&bcap_dev->dma_queue)) {
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 						struct bcap_buffer, list);
 		list_del_init(&bcap_dev->cur_frm->list);
-		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&bcap_dev->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 }
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a5f5481..d7ddc7d 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -243,7 +243,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
@@ -286,13 +286,14 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
 	if (common->cur_frm == common->next_frm) {
-		vb2_buffer_done(&common->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	} else {
 		if (common->cur_frm != NULL)
-			vb2_buffer_done(&common->cur_frm->vb,
+			vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 		if (common->next_frm != NULL)
-			vb2_buffer_done(&common->next_frm->vb,
+			vb2_buffer_done(&common->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -300,7 +301,8 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_cap_buffer, list);
 		list_del(&common->next_frm->list);
-		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
@@ -325,9 +327,8 @@ static struct vb2_ops video_qops = {
  */
 static void vpif_process_buffer_complete(struct common_obj *common)
 {
-	v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&common->cur_frm->vb.timestamp);
+	vb2_buffer_done(&common->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	/* Make curFrm pointing to nextFrm */
 	common->cur_frm = common->next_frm;
 }
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 8b8a663..4a76009 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -52,7 +52,7 @@ struct video_obj {
 };
 
 struct vpif_cap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 682e5d5..f641bc0 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -77,7 +77,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 		return -EINVAL;
 
-	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
+	vb->field = common->fmt.fmt.pix.field;
 
 	if (vb->vb2_queue->type != V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
 		unsigned long addr = vb2_dma_contig_plane_dma_addr(vb, 0);
@@ -229,7 +229,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
@@ -264,13 +264,14 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
 	if (common->cur_frm == common->next_frm) {
-		vb2_buffer_done(&common->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	} else {
 		if (common->cur_frm != NULL)
-			vb2_buffer_done(&common->cur_frm->vb,
+			vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 		if (common->next_frm != NULL)
-			vb2_buffer_done(&common->next_frm->vb,
+			vb2_buffer_done(&common->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
 
@@ -278,7 +279,8 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_disp_buffer, list);
 		list_del(&common->next_frm->list);
-		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
@@ -324,10 +326,10 @@ static void process_interlaced_mode(int fid, struct common_obj *common)
 		/* one frame is displayed If next frame is
 		 *  available, release cur_frm and move on */
 		/* Copy frame display time */
-		v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
+		v4l2_get_timestamp(&common->cur_frm->vb.timestamp);
 		/* Change status of the cur_frm */
-		vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
+					VB2_BUF_STATE_DONE);
 		/* Make cur_frm pointing to next_frm */
 		common->cur_frm = common->next_frm;
 
@@ -380,10 +382,9 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 			if (!channel_first_int[i][channel_id]) {
 				/* Mark status of the cur_frm to
 				 * done and unlock semaphore on it */
-				v4l2_get_timestamp(&common->cur_frm->vb.
-						   v4l2_buf.timestamp);
-				vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
+				v4l2_get_timestamp(&common->cur_frm->vb.timestamp);
+				vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
+						VB2_BUF_STATE_DONE);
 				/* Make cur_frm pointing to next_frm */
 				common->cur_frm = common->next_frm;
 			}
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 849e0e3..e7a1723 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -62,7 +62,7 @@ struct video_obj {
 };
 
 struct vpif_disp_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 769ff50..e93a233 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -136,7 +136,7 @@ struct gsc_fmt {
  * @idx : index of G-Scaler input buffer
  */
 struct gsc_input_buf {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head	list;
 	int			idx;
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index d0ceae3..3844d6c 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -103,7 +103,7 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 	/* Release unused buffers */
 	while (!suspend && !list_empty(&cap->pending_buf_q)) {
 		buf = fimc_pending_queue_pop(cap);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	/* If suspending put unused buffers onto pending queue */
 	while (!list_empty(&cap->active_buf_q)) {
@@ -111,7 +111,7 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 		if (suspend)
 			fimc_pending_queue_add(cap, buf);
 		else
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	fimc_hw_reset(fimc);
@@ -197,12 +197,12 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 
 		v_buf = fimc_active_queue_pop(cap);
 
-		tv = &v_buf->vb.v4l2_buf.timestamp;
+		tv = &v_buf->vb.timestamp;
 		tv->tv_sec = ts.tv_sec;
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-		v_buf->vb.v4l2_buf.sequence = cap->frame_count++;
+		v_buf->vb.sequence = cap->frame_count++;
 
-		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&v_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (!list_empty(&cap->pending_buf_q)) {
@@ -1472,7 +1472,8 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 		if (!list_empty(&fimc->vid_cap.active_buf_q)) {
 			buf = list_entry(fimc->vid_cap.active_buf_q.next,
 					 struct fimc_vid_buffer, list);
-			vb2_set_plane_payload(&buf->vb, 0, *((u32 *)arg));
+			vb2_set_plane_payload(&buf->vb.vb2_buf, 0,
+					      *((u32 *)arg));
 		}
 		fimc_capture_irq_handler(fimc, 1);
 		fimc_deactivate_capture(fimc);
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index ccb5d91..d336fa2 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -224,7 +224,7 @@ struct fimc_addr {
  * @index: buffer index for the output DMA engine
  */
 struct fimc_vid_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head	list;
 	struct fimc_addr	paddr;
 	int			index;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index ad9908b..c2d25df 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -102,7 +102,7 @@ struct fimc_isp_ctrls {
 };
 
 struct isp_video_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	dma_addr_t dma_addr[FIMC_ISP_MAX_PLANES];
 	unsigned int index;
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 7e37c9a..21527cf 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -200,7 +200,7 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 	/* Release unused buffers */
 	while (!suspend && !list_empty(&fimc->pending_buf_q)) {
 		buf = fimc_lite_pending_queue_pop(fimc);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	/* If suspending put unused buffers onto pending queue */
 	while (!list_empty(&fimc->active_buf_q)) {
@@ -208,7 +208,7 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 		if (suspend)
 			fimc_lite_pending_queue_add(fimc, buf);
 		else
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -295,12 +295,12 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 	    !list_empty(&fimc->active_buf_q)) {
 		vbuf = fimc_lite_active_queue_pop(fimc);
 		ktime_get_ts(&ts);
-		tv = &vbuf->vb.v4l2_buf.timestamp;
+		tv = &vbuf->vb.timestamp;
 		tv->tv_sec = ts.tv_sec;
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
+		vbuf->vb.sequence = fimc->frame_count++;
 		flite_hw_mask_dma_buffer(fimc, vbuf->index);
-		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (test_bit(ST_FLITE_CONFIG, &fimc->state))
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 7e4c708..b302305 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -100,7 +100,7 @@ struct flite_frame {
  * @index: DMA start address register's index
  */
 struct flite_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 	dma_addr_t paddr;
 	unsigned short index;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index c07f367..bdd8f11 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -200,18 +200,18 @@ static void dma_callback(void *data)
 {
 	struct deinterlace_ctx *curr_ctx = data;
 	struct deinterlace_dev *pcdev = curr_ctx->dev;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	atomic_set(&pcdev->busy, 0);
 
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
-	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
-	dst_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst_vb->v4l2_buf.flags |=
-		src_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
+	dst_vb->timestamp = src_vb->timestamp;
+	dst_vb->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_vb->flags |=
+		src_vb->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_vb->timecode = src_vb->timecode;
 
 	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
@@ -225,7 +225,7 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 				  int do_callback)
 {
 	struct deinterlace_q_data *s_q_data;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct deinterlace_dev *pcdev = ctx->dev;
 	struct dma_chan *chan = pcdev->dma_chan;
 	struct dma_device *dmadev = chan->device;
@@ -243,8 +243,9 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 	s_height = s_q_data->height;
 	s_size = s_width * s_height;
 
-	p_in = (dma_addr_t)vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	p_out = (dma_addr_t)vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	p_in = (dma_addr_t)vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	p_out = (dma_addr_t)vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf,
+							  0);
 	if (!p_in || !p_out) {
 		v4l2_err(&pcdev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
@@ -849,8 +850,10 @@ static int deinterlace_buf_prepare(struct vb2_buffer *vb)
 
 static void deinterlace_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
 }
 
 static struct vb2_ops deinterlace_qops = {
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 5e2b4df..1d95842 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -201,18 +201,18 @@ struct mcam_dma_desc {
 
 /*
  * Our buffer type for working with videobuf2.  Note that the vb2
- * developers have decreed that struct vb2_buffer must be at the
+ * developers have decreed that struct vb2_v4l2_buffer must be at the
  * beginning of this structure.
  */
 struct mcam_vb_buffer {
-	struct vb2_buffer vb_buf;
+	struct vb2_v4l2_buffer vb_buf;
 	struct list_head queue;
 	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
 	int dma_desc_nent;		/* Number of mapped descriptors */
 };
 
-static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
+static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct mcam_vb_buffer, vb_buf);
 }
@@ -221,14 +221,14 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
  * Hand a completed buffer back to user space.
  */
 static void mcam_buffer_done(struct mcam_camera *cam, int frame,
-		struct vb2_buffer *vbuf)
+		struct vb2_v4l2_buffer *vbuf)
 {
-	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
-	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
-	vbuf->v4l2_buf.field = V4L2_FIELD_NONE;
-	v4l2_get_timestamp(&vbuf->v4l2_buf.timestamp);
-	vb2_set_plane_payload(vbuf, 0, cam->pix_format.sizeimage);
-	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
+	vbuf->vb2_buf.planes[0].bytesused = cam->pix_format.sizeimage;
+	vbuf->sequence = cam->buf_seq[frame];
+	vbuf->field = V4L2_FIELD_NONE;
+	v4l2_get_timestamp(&vbuf->timestamp);
+	vb2_set_plane_payload(&vbuf->vb2_buf, 0, cam->pix_format.sizeimage);
+	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 
@@ -482,7 +482,8 @@ static void mcam_frame_tasklet(unsigned long data)
 		 * Drop the lock during the big copy.  This *should* be safe...
 		 */
 		spin_unlock_irqrestore(&cam->dev_lock, flags);
-		memcpy(vb2_plane_vaddr(&buf->vb_buf, 0), cam->dma_bufs[bufno],
+		memcpy(vb2_plane_vaddr(&buf->vb_buf.vb2_buf, 0),
+				cam->dma_bufs[bufno],
 				cam->pix_format.sizeimage);
 		mcam_buffer_done(cam, bufno, &buf->vb_buf);
 		spin_lock_irqsave(&cam->dev_lock, flags);
@@ -548,7 +549,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 {
 	struct mcam_vb_buffer *buf;
 	dma_addr_t dma_handle;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 
 	/*
 	 * If there are no available buffers, go into single mode
@@ -570,7 +571,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 	cam->vb_bufs[frame] = buf;
 	vb = &buf->vb_buf;
 
-	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
+	dma_handle = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	mcam_write_yuv_bases(cam, frame, dma_handle);
 }
 
@@ -1071,7 +1072,8 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 
 static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 {
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vbuf);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long flags;
 	int start;
@@ -1096,14 +1098,14 @@ static void mcam_vb_requeue_bufs(struct vb2_queue *vq,
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	list_for_each_entry_safe(buf, node, &cam->buffers, queue) {
-		vb2_buffer_done(&buf->vb_buf, state);
+		vb2_buffer_done(&buf->vb_buf.vb2_buf, state);
 		list_del(&buf->queue);
 	}
 	for (i = 0; i < MAX_DMA_BUFS; i++) {
 		buf = cam->vb_bufs[i];
 
 		if (buf) {
-			vb2_buffer_done(&buf->vb_buf, state);
+			vb2_buffer_done(&buf->vb_buf.vb2_buf, state);
 			cam->vb_bufs[i] = NULL;
 		}
 	}
@@ -1198,7 +1200,8 @@ static const struct vb2_ops mcam_vb2_ops = {
  */
 static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 {
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vbuf);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
@@ -1214,7 +1217,8 @@ static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 
 static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 {
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vbuf);
 	struct sg_table *sg_table = vb2_dma_sg_plane_desc(vb, 0);
 	struct mcam_dma_desc *desc = mvb->dma_desc;
 	struct scatterlist *sg;
@@ -1230,8 +1234,9 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 
 static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
-	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vbuf);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
 	dma_free_coherent(cam->dev, ndesc * sizeof(struct mcam_dma_desc),
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 41bb8df..08c9f62 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -363,7 +363,8 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buffer->vb, 0, vfh->format.fmt.pix.sizeimage);
+	vb2_set_plane_payload(&buffer->vb.vb2_buf, 0,
+			      vfh->format.fmt.pix.sizeimage);
 	buffer->dma = addr;
 
 	return 0;
@@ -392,7 +393,7 @@ static void isp_video_buffer_queue(struct vb2_buffer *buf)
 	spin_lock_irqsave(&video->irqlock, flags);
 
 	if (unlikely(video->error)) {
-		vb2_buffer_done(&buffer->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buffer->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&video->irqlock, flags);
 		return;
 	}
@@ -464,7 +465,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	list_del(&buf->irqlist);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&buf->vb.timestamp);
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
@@ -473,15 +474,15 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	 * first, so the input number might lag behind by 1 in some cases.
 	 */
 	if (video == pipe->output && !pipe->do_propagation)
-		buf->vb.v4l2_buf.sequence =
+		buf->vb.sequence =
 			atomic_inc_return(&pipe->frame_number);
 	else
-		buf->vb.v4l2_buf.sequence = atomic_read(&pipe->frame_number);
+		buf->vb.sequence = atomic_read(&pipe->frame_number);
 
 	if (pipe->field != V4L2_FIELD_NONE)
-		buf->vb.v4l2_buf.sequence /= 2;
+		buf->vb.sequence /= 2;
 
-	buf->vb.v4l2_buf.field = pipe->field;
+	buf->vb.field = pipe->field;
 
 	/* Report pipeline errors to userspace on the capture device side. */
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->error) {
@@ -491,7 +492,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 		state = VB2_BUF_STATE_DONE;
 	}
 
-	vb2_buffer_done(&buf->vb, state);
+	vb2_buffer_done(&buf->vb.vb2_buf, state);
 
 	spin_lock_irqsave(&video->irqlock, flags);
 
@@ -546,7 +547,7 @@ void omap3isp_video_cancel_stream(struct isp_video *video)
 		buf = list_first_entry(&video->dmaqueue,
 				       struct isp_buffer, irqlist);
 		list_del(&buf->irqlist);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	video->error = true;
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 31c2445..bcf0e0a 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -122,7 +122,7 @@ static inline int isp_pipeline_ready(struct isp_pipeline *pipe)
  * @dma: DMA address
  */
 struct isp_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head irqlist;
 	dma_addr_t dma;
 };
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index bb01eaa..dc67c4ec 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -164,12 +164,12 @@ static int camif_reinitialize(struct camif_vp *vp)
 	/* Release unused buffers */
 	while (!list_empty(&vp->pending_buf_q)) {
 		buf = camif_pending_queue_pop(vp);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	while (!list_empty(&vp->active_buf_q)) {
 		buf = camif_active_queue_pop(vp);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&camif->slock, flags);
@@ -342,11 +342,11 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
 
 		if (!WARN_ON(vbuf == NULL)) {
 			/* Dequeue a filled buffer */
-			tv = &vbuf->vb.v4l2_buf.timestamp;
+			tv = &vbuf->vb.timestamp;
 			tv->tv_sec = ts.tv_sec;
 			tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-			vbuf->vb.v4l2_buf.sequence = vp->frame_sequence++;
-			vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+			vbuf->vb.sequence = vp->frame_sequence++;
+			vb2_buffer_done(&vbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
 			/* Set up an empty buffer at the DMA engine */
 			vbuf = camif_pending_queue_pop(vp);
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index 8ef6f26..adaf196 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -322,7 +322,7 @@ struct camif_addr {
  * @index: an identifier of this buffer at the DMA engine
  */
 struct camif_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 	struct camif_addr paddr;
 	unsigned int index;
diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index 855b723..42cd270 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -113,7 +113,7 @@ struct mxr_geometry {
 /** instance of a buffer */
 struct mxr_buffer {
 	/** common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	/** node for layer's lists */
 	struct list_head	list;
 };
diff --git a/drivers/media/platform/s5p-tv/mixer_reg.c b/drivers/media/platform/s5p-tv/mixer_reg.c
index 5127acb..a0ec14a 100644
--- a/drivers/media/platform/s5p-tv/mixer_reg.c
+++ b/drivers/media/platform/s5p-tv/mixer_reg.c
@@ -279,7 +279,7 @@ static void mxr_irq_layer_handle(struct mxr_layer *layer)
 	layer->ops.buffer_set(layer, layer->update_buf);
 
 	if (done && done != layer->shadow_buf)
-		vb2_buffer_done(&done->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&done->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
 done:
 	spin_unlock(&layer->enq_slock);
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 751f3b6..5347a6c 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -963,11 +963,13 @@ static void mxr_watchdog(unsigned long arg)
 	if (layer->update_buf == layer->shadow_buf)
 		layer->update_buf = NULL;
 	if (layer->update_buf) {
-		vb2_buffer_done(&layer->update_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->update_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		layer->update_buf = NULL;
 	}
 	if (layer->shadow_buf) {
-		vb2_buffer_done(&layer->shadow_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&layer->shadow_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		layer->shadow_buf = NULL;
 	}
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
@@ -991,7 +993,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* set all buffer to be done */
 	list_for_each_entry_safe(buf, buf_tmp, &layer->enq_list, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index f5e3eb3a..6455cb9 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -931,9 +931,10 @@ static int sh_veu_buf_prepare(struct vb2_buffer *vb)
 
 static void sh_veu_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct sh_veu_dev *veu = vb2_get_drv_priv(vb->vb2_queue);
-	dev_dbg(veu->dev, "%s(%d)\n", __func__, vb->v4l2_buf.type);
-	v4l2_m2m_buf_queue(veu->m2m_ctx, vb);
+	dev_dbg(veu->dev, "%s(%d)\n", __func__, vb->type);
+	v4l2_m2m_buf_queue(veu->m2m_ctx, vbuf);
 }
 
 static const struct vb2_ops sh_veu_qops = {
@@ -1084,8 +1085,8 @@ static irqreturn_t sh_veu_bh(int irq, void *dev_id)
 static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 {
 	struct sh_veu_dev *veu = dev_id;
-	struct vb2_buffer *dst;
-	struct vb2_buffer *src;
+	struct vb2_v4l2_buffer *dst;
+	struct vb2_v4l2_buffer *src;
 	u32 status = sh_veu_reg_read(veu, VEU_EVTR);
 
 	/* bundle read mode not used */
@@ -1105,11 +1106,11 @@ static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 	if (!src || !dst)
 		return IRQ_NONE;
 
-	dst->v4l2_buf.timestamp = src->v4l2_buf.timestamp;
-	dst->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst->v4l2_buf.flags |=
-		src->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst->v4l2_buf.timecode = src->v4l2_buf.timecode;
+	dst->timestamp = src->timestamp;
+	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->flags |=
+		src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->timecode = src->timecode;
 
 	spin_lock(&veu->lock);
 	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index fe5c8ab..7014f2e 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -62,7 +62,7 @@ enum sh_vou_status {
 #define VOU_MIN_IMAGE_HEIGHT	16
 
 struct sh_vou_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -302,7 +302,8 @@ static int sh_vou_start_streaming(struct vb2_queue *vq, unsigned int count)
 					 video, s_stream, 1);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
 		list_for_each_entry_safe(buf, node, &vou_dev->buf_list, list) {
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 			list_del(&buf->list);
 		}
 		vou_dev->active = NULL;
@@ -353,7 +354,7 @@ static void sh_vou_stop_streaming(struct vb2_queue *vq)
 	msleep(50);
 	spin_lock_irqsave(&vou_dev->lock, flags);
 	list_for_each_entry_safe(buf, node, &vou_dev->buf_list, list) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&buf->list);
 	}
 	vou_dev->active = NULL;
@@ -1066,10 +1067,10 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 
 	list_del(&vb->list);
 
-	v4l2_get_timestamp(&vb->vb.v4l2_buf.timestamp);
-	vb->vb.v4l2_buf.sequence = vou_dev->sequence++;
-	vb->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
-	vb2_buffer_done(&vb->vb, VB2_BUF_STATE_DONE);
+	v4l2_get_timestamp(&vb->vb.timestamp);
+	vb->vb.sequence = vou_dev->sequence++;
+	vb->vb.field = V4L2_FIELD_INTERLACED;
+	vb2_buffer_done(&vb->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
 	vou_dev->active = list_entry(vou_dev->buf_list.next,
 				     struct sh_vou_buffer, list);
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 9070172..6b312a4 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -59,7 +59,7 @@ struct isi_dma_desc {
 
 /* Frame buffer data */
 struct frame_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct isi_dma_desc *p_dma_desc;
 	struct list_head list;
 };
@@ -292,7 +292,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 
 	if (!buf->p_dma_desc) {
 		if (list_empty(&isi->dma_desc_head)) {
@@ -422,7 +422,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* Release all active buffers */
 	list_for_each_entry_safe(buf, node, &isi->video_buffer_list, list) {
 		list_del_init(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irq(&isi->lock);
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 6e41335..f4398bb 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -225,7 +225,7 @@ struct mx2_buf_internal {
 /* buffer for one video frame */
 struct mx2_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer		vb;
+	struct vb2_v4l2_buffer vb;
 	struct mx2_buf_internal		internal;
 };
 
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index ace41f5..dcd7dc1 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -63,7 +63,7 @@
 
 struct mx3_camera_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer			vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head			queue;
 
 	/* One descriptot per scatterlist (per frame) */
@@ -424,7 +424,7 @@ static void mx3_stop_streaming(struct vb2_queue *q)
 
 	list_for_each_entry_safe(buf, tmp, &mx3_cam->capture, queue) {
 		list_del_init(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 71dd71c..cd45fa9 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -492,7 +492,7 @@ struct rcar_vin_priv {
 #define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM)
 
 struct rcar_vin_buffer {
-	struct vb2_buffer		vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head		list;
 };
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index efdeea4..161b614 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -93,7 +93,7 @@
 
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
-	struct vb2_buffer vb; /* v4l buffer must be first */
+	struct vb2_v4l2_buffer vb; /* v4l buffer must be first */
 	struct list_head queue;
 };
 
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 5f1b1da..b039103 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -93,7 +93,7 @@ extern struct vivid_fmt vivid_formats[];
 /* buffer for one video frame */
 struct vivid_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head	list;
 };
 
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 1727f54..d9e7df2 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -246,7 +246,7 @@ static void *plane_vaddr(struct tpg_data *tpg, struct vivid_buffer *buf,
 static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 		struct vivid_buffer *vid_cap_buf)
 {
-	bool blank = dev->must_blank[vid_cap_buf->vb.v4l2_buf.index];
+	bool blank = dev->must_blank[vid_cap_buf->vb.vb2_buf.index];
 	struct tpg_data *tpg = &dev->tpg;
 	struct vivid_buffer *vid_out_buf = NULL;
 	unsigned vdiv = dev->fmt_out->vdownsampling[p];
@@ -283,7 +283,7 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 	if (vid_out_buf == NULL)
 		return -ENODATA;
 
-	vid_cap_buf->vb.v4l2_buf.field = vid_out_buf->vb.v4l2_buf.field;
+	vid_cap_buf->vb.field = vid_out_buf->vb.field;
 
 	voutbuf = plane_vaddr(tpg, vid_out_buf, p,
 			      dev->bytesperline_out, dev->fmt_out_rect.height);
@@ -433,13 +433,13 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	     (vivid_is_hdmi_cap(dev) && !VIVID_INVALID_SIGNAL(dev->dv_timings_signal_mode))))
 		is_loop = true;
 
-	buf->vb.v4l2_buf.sequence = dev->vid_cap_seq_count;
+	buf->vb.sequence = dev->vid_cap_seq_count;
 	/*
 	 * Take the timestamp now if the timestamp source is set to
 	 * "Start of Exposure".
 	 */
 	if (dev->tstamp_src_is_soe)
-		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+		v4l2_get_timestamp(&buf->vb.timestamp);
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
 		/*
 		 * 60 Hz standards start with the bottom field, 50 Hz standards
@@ -447,19 +447,19 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 		 * then the field is TOP for 50 Hz and BOTTOM for 60 Hz
 		 * standards.
 		 */
-		buf->vb.v4l2_buf.field = ((dev->vid_cap_seq_count & 1) ^ is_60hz) ?
+		buf->vb.field = ((dev->vid_cap_seq_count & 1) ^ is_60hz) ?
 			V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
 		/*
 		 * The sequence counter counts frames, not fields. So divide
 		 * by two.
 		 */
-		buf->vb.v4l2_buf.sequence /= 2;
+		buf->vb.sequence /= 2;
 	} else {
-		buf->vb.v4l2_buf.field = dev->field_cap;
+		buf->vb.field = dev->field_cap;
 	}
-	tpg_s_field(tpg, buf->vb.v4l2_buf.field,
+	tpg_s_field(tpg, buf->vb.field,
 		    dev->field_cap == V4L2_FIELD_ALTERNATE);
-	tpg_s_perc_fill_blank(tpg, dev->must_blank[buf->vb.v4l2_buf.index]);
+	tpg_s_perc_fill_blank(tpg, dev->must_blank[buf->vb.vb2_buf.index]);
 
 	vivid_precalc_copy_rects(dev);
 
@@ -481,10 +481,10 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 		if (!is_loop || vivid_copy_buffer(dev, p, vbuf, buf))
 			tpg_fill_plane_buffer(tpg, vivid_get_std_cap(dev), p, vbuf);
 	}
-	dev->must_blank[buf->vb.v4l2_buf.index] = false;
+	dev->must_blank[buf->vb.vb2_buf.index] = false;
 
 	/* Updates stream time, only update at the start of a new frame. */
-	if (dev->field_cap != V4L2_FIELD_ALTERNATE || (buf->vb.v4l2_buf.sequence & 1) == 0)
+	if (dev->field_cap != V4L2_FIELD_ALTERNATE || (buf->vb.sequence & 1) == 0)
 		dev->ms_vid_cap = jiffies_to_msecs(jiffies - dev->jiffies_vid_cap);
 
 	ms = dev->ms_vid_cap;
@@ -494,9 +494,9 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 				(ms / (60 * 1000)) % 60,
 				(ms / 1000) % 60,
 				ms % 1000,
-				buf->vb.v4l2_buf.sequence,
+				buf->vb.sequence,
 				(dev->field_cap == V4L2_FIELD_ALTERNATE) ?
-					(buf->vb.v4l2_buf.field == V4L2_FIELD_TOP ?
+					(buf->vb.field == V4L2_FIELD_TOP ?
 					 " top" : " bottom") : "");
 		tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 	}
@@ -553,8 +553,8 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	 * the timestamp now.
 	 */
 	if (!dev->tstamp_src_is_soe)
-		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
+		v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
 /*
@@ -616,7 +616,7 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
 		return;
 	if ((dev->overlay_cap_field == V4L2_FIELD_TOP ||
 	     dev->overlay_cap_field == V4L2_FIELD_BOTTOM) &&
-	    dev->overlay_cap_field != buf->vb.v4l2_buf.field)
+	    dev->overlay_cap_field != buf->vb.field)
 		return;
 
 	vbuf += dev->compose_cap.left * pixsize + dev->compose_cap.top * stride;
@@ -699,17 +699,17 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 		/* Fill buffer */
 		vivid_fillbuff(dev, vid_cap_buf);
 		dprintk(dev, 1, "filled buffer %d\n",
-			vid_cap_buf->vb.v4l2_buf.index);
+			vid_cap_buf->vb.vb2_buf.index);
 
 		/* Handle overlay */
 		if (dev->overlay_cap_owner && dev->fb_cap.base &&
 				dev->fb_cap.fmt.pixelformat == dev->fmt_cap->fourcc)
 			vivid_overlay(dev, vid_cap_buf);
 
-		vb2_buffer_done(&vid_cap_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vid_cap_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_cap buffer %d done\n",
-				vid_cap_buf->vb.v4l2_buf.index);
+				vid_cap_buf->vb.vb2_buf.index);
 	}
 
 	if (vbi_cap_buf) {
@@ -717,10 +717,10 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 			vivid_sliced_vbi_cap_process(dev, vbi_cap_buf);
 		else
 			vivid_raw_vbi_cap_process(dev, vbi_cap_buf);
-		vb2_buffer_done(&vbi_cap_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vbi_cap_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_cap %d done\n",
-				vbi_cap_buf->vb.v4l2_buf.index);
+				vbi_cap_buf->vb.vb2_buf.index);
 	}
 	dev->dqbuf_error = false;
 
@@ -884,9 +884,9 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_cap buffer %d done\n",
-				buf->vb.v4l2_buf.index);
+				buf->vb.vb2_buf.index);
 		}
 	}
 
@@ -897,9 +897,9 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_cap buffer %d done\n",
-				buf->vb.v4l2_buf.index);
+				buf->vb.vb2_buf.index);
 		}
 	}
 
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index d9f36cc..e5155d9f 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -87,33 +87,33 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 		return;
 
 	if (vid_out_buf) {
-		vid_out_buf->vb.v4l2_buf.sequence = dev->vid_out_seq_count;
+		vid_out_buf->vb.sequence = dev->vid_out_seq_count;
 		if (dev->field_out == V4L2_FIELD_ALTERNATE) {
 			/*
 			 * The sequence counter counts frames, not fields. So divide
 			 * by two.
 			 */
-			vid_out_buf->vb.v4l2_buf.sequence /= 2;
+			vid_out_buf->vb.sequence /= 2;
 		}
-		v4l2_get_timestamp(&vid_out_buf->vb.v4l2_buf.timestamp);
-		vid_out_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&vid_out_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		v4l2_get_timestamp(&vid_out_buf->vb.timestamp);
+		vid_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		vb2_buffer_done(&vid_out_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_out buffer %d done\n",
-			vid_out_buf->vb.v4l2_buf.index);
+			vid_out_buf->vb.vb2_buf.index);
 	}
 
 	if (vbi_out_buf) {
 		if (dev->stream_sliced_vbi_out)
 			vivid_sliced_vbi_out_process(dev, vbi_out_buf);
 
-		vbi_out_buf->vb.v4l2_buf.sequence = dev->vbi_out_seq_count;
-		v4l2_get_timestamp(&vbi_out_buf->vb.v4l2_buf.timestamp);
-		vbi_out_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&vbi_out_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		vbi_out_buf->vb.sequence = dev->vbi_out_seq_count;
+		v4l2_get_timestamp(&vbi_out_buf->vb.timestamp);
+		vbi_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		vb2_buffer_done(&vbi_out_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_out buffer %d done\n",
-			vbi_out_buf->vb.v4l2_buf.index);
+			vbi_out_buf->vb.vb2_buf.index);
 	}
 	dev->dqbuf_error = false;
 }
@@ -274,9 +274,9 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_out buffer %d done\n",
-				buf->vb.v4l2_buf.index);
+				buf->vb.vb2_buf.index);
 		}
 	}
 
@@ -287,9 +287,9 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_out buffer %d done\n",
-				buf->vb.v4l2_buf.index);
+				buf->vb.vb2_buf.index);
 		}
 	}
 
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index d2f2188..bae5b8a 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -114,12 +114,12 @@ static void vivid_thread_sdr_cap_tick(struct vivid_dev *dev)
 	spin_unlock(&dev->slock);
 
 	if (sdr_cap_buf) {
-		sdr_cap_buf->vb.v4l2_buf.sequence = dev->sdr_cap_seq_count;
+		sdr_cap_buf->vb.sequence = dev->sdr_cap_seq_count;
 		vivid_sdr_cap_process(dev, sdr_cap_buf);
-		v4l2_get_timestamp(&sdr_cap_buf->vb.v4l2_buf.timestamp);
-		sdr_cap_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&sdr_cap_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		v4l2_get_timestamp(&sdr_cap_buf->vb.timestamp);
+		sdr_cap_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		vb2_buffer_done(&sdr_cap_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dev->dqbuf_error = false;
 	}
 }
@@ -282,7 +282,8 @@ static int sdr_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->sdr_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
@@ -301,7 +302,7 @@ static void sdr_cap_stop_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(dev->sdr_cap_active.next, struct vivid_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	/* shutdown control thread */
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index ef81b01..73e9c0b 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -97,19 +97,19 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 
 	vivid_g_fmt_vbi_cap(dev, &vbi);
-	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
+	buf->vb.sequence = dev->vbi_cap_seq_count;
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
-		buf->vb.v4l2_buf.sequence /= 2;
+		buf->vb.sequence /= 2;
 
-	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
+	vivid_sliced_vbi_cap_fill(dev, buf->vb.sequence);
 
 	memset(vbuf, 0x10, vb2_plane_size(&buf->vb, 0));
 
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
 		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
 
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
+	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
 
@@ -117,11 +117,11 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *bu
 {
 	struct v4l2_sliced_vbi_data *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 
-	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
+	buf->vb.sequence = dev->vbi_cap_seq_count;
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
-		buf->vb.v4l2_buf.sequence /= 2;
+		buf->vb.sequence /= 2;
 
-	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
+	vivid_sliced_vbi_cap_fill(dev, buf->vb.sequence);
 
 	memset(vbuf, 0, vb2_plane_size(&buf->vb, 0));
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode)) {
@@ -131,8 +131,8 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *bu
 			vbuf[i] = dev->vbi_gen.data[i];
 	}
 
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
+	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
 static int vbi_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
@@ -215,7 +215,8 @@ static int vbi_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 4e4c70e..1333f96 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -107,7 +107,8 @@ static int vbi_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_out_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index ed0b878..4572709 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -268,7 +268,8 @@ static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index c404e27..73c8f97 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -186,7 +186,8 @@ static int vid_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_out_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index dfd45c7..5837bc1 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -610,11 +610,11 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	done->buf.v4l2_buf.sequence = video->sequence++;
-	v4l2_get_timestamp(&done->buf.v4l2_buf.timestamp);
+	done->buf.sequence = video->sequence++;
+	v4l2_get_timestamp(&done->buf.timestamp);
 	for (i = 0; i < done->buf.num_planes; ++i)
-		vb2_set_plane_payload(&done->buf, i, done->length[i]);
-	vb2_buffer_done(&done->buf, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&done->buf.vb2_buf, i, done->length[i]);
+	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return next;
 }
@@ -954,7 +954,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	/* Remove all buffers from the IRQ queue. */
 	spin_lock_irqsave(&video->irqlock, flags);
 	list_for_each_entry(buffer, &video->irqqueue, queue)
-		vb2_buffer_done(&buffer->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	INIT_LIST_HEAD(&video->irqqueue);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index d808301..ab56f30 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -94,7 +94,7 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 }
 
 struct vsp1_video_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
 	dma_addr_t addr[3];
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index d9dcd4b..3b6112e 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -285,7 +285,7 @@ done:
  * @dma: DMA channel that uses the buffer
  */
 struct xvip_dma_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 	struct xvip_dma *dma;
 };
@@ -301,11 +301,11 @@ static void xvip_dma_complete(void *param)
 	list_del(&buf->queue);
 	spin_unlock(&dma->queued_lock);
 
-	buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
-	buf->buf.v4l2_buf.sequence = dma->sequence++;
-	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
-	vb2_set_plane_payload(&buf->buf, 0, dma->format.sizeimage);
-	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
+	buf->buf.field = V4L2_FIELD_NONE;
+	buf->buf.sequence = dma->sequence++;
+	v4l2_get_timestamp(&buf->buf.timestamp);
+	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, dma->format.sizeimage);
+	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 static int
@@ -367,7 +367,7 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
 	desc = dmaengine_prep_interleaved_dma(dma->dma, &dma->xt, flags);
 	if (!desc) {
 		dev_err(dma->xdev->dev, "Failed to prepare DMA transfer\n");
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 	desc->callback = xvip_dma_complete;
@@ -434,7 +434,7 @@ error:
 	/* Give back all queued buffers to videobuf2. */
 	spin_lock_irq(&dma->queued_lock);
 	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_QUEUED);
 		list_del(&buf->queue);
 	}
 	spin_unlock_irq(&dma->queued_lock);
@@ -461,7 +461,7 @@ static void xvip_dma_stop_streaming(struct vb2_queue *vq)
 	/* Give back all queued buffers to videobuf2. */
 	spin_lock_irq(&dma->queued_lock);
 	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&buf->queue);
 	}
 	spin_unlock_irq(&dma->queued_lock);
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 8f2e1c2..bc45104 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -97,7 +97,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct airspy_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -313,10 +313,10 @@ static void airspy_urb_complete(struct urb *urb)
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
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
@@ -459,7 +459,7 @@ static void airspy_cleanup_queued_bufs(struct airspy *s)
 		buf = list_entry(s->queued_bufs.next,
 				struct airspy_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
 }
@@ -512,7 +512,7 @@ static void airspy_buf_queue(struct vb2_buffer *vb)
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (unlikely(!s->udev)) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
@@ -571,7 +571,8 @@ err_clear_bit:
 
 		list_for_each_entry_safe(buf, tmp, &s->queued_bufs, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index f67247c..44d1d46 100644
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
@@ -71,7 +70,8 @@ static void
 vbi_buffer_queue(struct vb2_buffer *vb)
 {
 	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct au0828_buffer *buf = container_of(vbuf, struct au0828_buffer, vb);
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
index 744e7ed..a4d7f41 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -71,7 +71,7 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 		       __func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 
 	return 0;
 }
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4397ce5..5b6fdd2 100644
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
@@ -914,7 +914,7 @@ buffer_prepare(struct vb2_buffer *vb)
 				__func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 
 	return 0;
 }
@@ -995,7 +995,8 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->usb_ctl.vid_buf != NULL) {
-		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vid_buf = NULL;
 	}
 	while (!list_empty(&vidq->active)) {
@@ -1003,7 +1004,7 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vidq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -1026,7 +1027,8 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->usb_ctl.vbi_buf != NULL) {
-		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vbi_buf = NULL;
 	}
 	while (!list_empty(&vbiq->active)) {
@@ -1034,7 +1036,7 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vbiq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
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
index 0ab81ec..f0ee44d 100644
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
@@ -458,15 +458,15 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
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
@@ -476,7 +476,7 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
 		vb = list_first_entry(&go->vidq_active, struct go7007_buffer, list);
 	go->active_buf = vb;
 	spin_unlock(&go->spinlock);
-	vb2_buffer_done(&vb_tmp->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb_tmp->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	return vb;
 }
 
@@ -519,9 +519,9 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 	}
 
 	for (i = 0; i < length; ++i) {
-		if (vb && vb->vb.v4l2_planes[0].bytesused >= GO7007_BUF_SIZE - 3) {
+		if (vb && vb->vb.vb2_buf.planes[0].bytesused >= GO7007_BUF_SIZE - 3) {
 			v4l2_info(&go->v4l2_dev, "dropping oversized frame\n");
-			vb->vb.v4l2_planes[0].bytesused = 0;
+			vb->vb.vb2_buf.planes[0].bytesused = 0;
 			vb->frame_offset = 0;
 			vb->modet_active = 0;
 			vb = go->active_buf = NULL;
@@ -601,7 +601,7 @@ void go7007_parse_video_stream(struct go7007 *go, u8 *buf, int length)
 					vb = frame_boundary(go, vb);
 				go->seen_frame = buf[i] == frame_start_code;
 				if (vb && go->seen_frame)
-					vb->frame_offset = vb->vb.v4l2_planes[0].bytesused;
+					vb->frame_offset = vb->vb.vb2_buf.planes[0].bytesused;
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
index fd1fa41..e932f0b 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -85,7 +85,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct hackrf_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -290,10 +290,10 @@ static void hackrf_urb_complete(struct urb *urb)
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
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
@@ -437,7 +437,7 @@ static void hackrf_cleanup_queued_bufs(struct hackrf_dev *dev)
 		buf = list_entry(dev->queued_bufs.next,
 				struct hackrf_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -539,7 +539,8 @@ err:
 
 		list_for_each_entry_safe(buf, tmp, &dev->queued_bufs, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 3f276d9..6ba87d0 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -112,7 +112,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct msi2500_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -433,8 +433,8 @@ static void msi2500_isoc_handler(struct urb *urb)
 		/* fill framebuffer */
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
 		flen = msi2500_convert_stream(dev, ptr, iso_buf, flen);
-		vb2_set_plane_payload(&fbuf->vb, 0, flen);
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, flen);
+		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 handler_end:
@@ -569,7 +569,7 @@ static void msi2500_cleanup_queued_bufs(struct msi2500_dev *dev)
 		buf = list_entry(dev->queued_bufs.next,
 				 struct msi2500_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -641,7 +641,7 @@ static void msi2500_buf_queue(struct vb2_buffer *vb)
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (unlikely(!dev->udev)) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 702267e..a33ce99 100644
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
@@ -594,7 +594,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int buffer_init(struct vb2_buffer *vb)
 {
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf = container_of(vbuf, struct pwc_frame_buf, vb);
 
 	/* need vmalloc since frame buffer > 128K */
 	buf->data = vzalloc(PWC_FRAME_SIZE);
@@ -618,7 +619,8 @@ static int buffer_prepare(struct vb2_buffer *vb)
 static void buffer_finish(struct vb2_buffer *vb)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf = container_of(vbuf, struct pwc_frame_buf, vb);
 
 	if (vb->state == VB2_BUF_STATE_DONE) {
 		/*
@@ -633,7 +635,8 @@ static void buffer_finish(struct vb2_buffer *vb)
 
 static void buffer_cleanup(struct vb2_buffer *vb)
 {
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf = container_of(vbuf, struct pwc_frame_buf, vb);
 
 	vfree(buf->data);
 }
@@ -641,12 +644,13 @@ static void buffer_cleanup(struct vb2_buffer *vb)
 static void buffer_queue(struct vb2_buffer *vb)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf = container_of(vbuf, struct pwc_frame_buf, vb);
 	unsigned long flags = 0;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (!pdev->udev) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
@@ -695,7 +699,8 @@ static void stop_streaming(struct vb2_queue *vq)
 
 	pwc_cleanup_queued_bufs(pdev, VB2_BUF_STATE_ERROR);
 	if (pdev->fill_buf)
-		vb2_buffer_done(&pdev->fill_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&pdev->fill_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	mutex_unlock(&pdev->v4l2_lock);
 }
 
diff --git a/drivers/media/usb/pwc/pwc-uncompress.c b/drivers/media/usb/pwc/pwc-uncompress.c
index b65903f..58b5518 100644
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
-			pdev->frame_size + sizeof(struct pwc_raw_frame));
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
+				      pdev->frame_size + sizeof(struct pwc_raw_frame));
 		return 0;
 	}
 
-	vb2_set_plane_payload(&fbuf->vb, 0,
+	vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
 			      pdev->width * pdev->height * 3 / 2);
 
 	if (pdev->vbandlength == 0) {
diff --git a/drivers/media/usb/pwc/pwc.h b/drivers/media/usb/pwc/pwc.h
index 81b017a..e0d9125 100644
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
@@ -210,7 +211,7 @@ struct pwc_raw_frame {
 /* intermediate buffers with raw data from the USB cam */
 struct pwc_frame_buf
 {
-	struct vb2_buffer vb;	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;	/* common v4l buffer stuff -- must be first */
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

