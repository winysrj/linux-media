Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:57313 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbbGaIow (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2015 04:44:52 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NSC015YQGAG9330@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Jul 2015 17:44:40 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, jh1009.sung@samsung.com
Subject: [RFC PATCH v2 2/5] media: videobuf2: Restructurng struct vb2_buffer
 for common use.
Date: Fri, 31 Jul 2015 17:44:34 +0900
Message-id: <1438332277-6542-3-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove v4l2-specific stuff from struct vb2_buffer and create struct
vb2_v4l2_buffer as container buffer for v4l2 use.

struct vb2_v4l2_buffer {
	struct vb2_buffer	vb2_buf;
	struct v4l2_buffer	v4l2_buf;
	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
};

And modify all device drivers related with this change.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/input/touchscreen/sur40.c                  |   13 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   15 ++-
 drivers/media/pci/cx23885/cx23885-417.c            |   11 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   10 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |    9 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |   11 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   13 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |   13 +-
 drivers/media/pci/cx25821/cx25821.h                |    2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   13 +-
 drivers/media/pci/cx88/cx88-core.c                 |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   11 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    6 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |   11 +-
 drivers/media/pci/cx88/cx88-video.c                |    9 +-
 drivers/media/pci/cx88/cx88.h                      |    2 +-
 drivers/media/pci/dt3155/dt3155.c                  |   13 +-
 drivers/media/pci/dt3155/dt3155.h                  |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    9 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |   28 ++--
 drivers/media/pci/saa7134/saa7134-vbi.c            |   22 ++--
 drivers/media/pci/saa7134/saa7134-video.c          |   33 +++--
 drivers/media/pci/saa7134/saa7134.h                |    6 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   30 +++--
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   16 ++-
 drivers/media/pci/solo6x10/solo6x10.h              |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   23 ++--
 drivers/media/pci/tw68/tw68-video.c                |   13 +-
 drivers/media/pci/tw68/tw68.h                      |    2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   30 +++--
 drivers/media/platform/am437x/am437x-vpfe.h        |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   30 +++--
 drivers/media/platform/coda/coda-bit.c             |   60 ++++-----
 drivers/media/platform/coda/coda-common.c          |   17 +--
 drivers/media/platform/coda/coda-jpeg.c            |    6 +-
 drivers/media/platform/coda/coda.h                 |    4 +-
 drivers/media/platform/davinci/vpbe_display.c      |    3 +-
 drivers/media/platform/davinci/vpif_capture.c      |   29 +++--
 drivers/media/platform/davinci/vpif_capture.h      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |   39 +++---
 drivers/media/platform/davinci/vpif_display.h      |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   10 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    4 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    7 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   17 ++-
 drivers/media/platform/exynos4-is/fimc-core.c      |   10 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    4 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    9 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   12 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    8 +-
 drivers/media/platform/m2m-deinterlace.c           |   13 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   31 +++--
 drivers/media/platform/mx2_emmaprp.c               |   12 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   24 ++--
 drivers/media/platform/omap3isp/ispvideo.h         |    2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   14 +-
 drivers/media/platform/s3c-camif/camif-core.h      |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   12 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   40 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   32 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   17 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   61 +++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   28 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   28 ++--
 drivers/media/platform/s5p-tv/mixer.h              |    2 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c    |    2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c          |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   11 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c     |    5 +-
 drivers/media/platform/sh_veu.c                    |   20 +--
 drivers/media/platform/soc_camera/atmel-isi.c      |   22 ++--
 drivers/media/platform/soc_camera/mx2_camera.c     |   25 ++--
 drivers/media/platform/soc_camera/mx3_camera.c     |   19 +--
 drivers/media/platform/soc_camera/rcar_vin.c       |   24 ++--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   27 ++--
 drivers/media/platform/ti-vpe/vpe.c                |   24 ++--
 drivers/media/platform/vim2m.c                     |   26 ++--
 drivers/media/platform/vivid/vivid-core.h          |    2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   20 +--
 drivers/media/platform/vivid/vivid-kthread-out.c   |   14 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   16 ++-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   15 ++-
 drivers/media/platform/vivid/vivid-vbi-out.c       |   11 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   16 ++-
 drivers/media/platform/vivid/vivid-vid-out.c       |   13 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   13 +-
 drivers/media/platform/vsp1/vsp1_video.h           |    4 +-
 drivers/media/usb/airspy/airspy.c                  |   18 +--
 drivers/media/usb/au0828/au0828-vbi.c              |    6 +-
 drivers/media/usb/au0828/au0828-video.c            |   38 +++---
 drivers/media/usb/au0828/au0828.h                  |    2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    8 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   20 +--
 drivers/media/usb/em28xx/em28xx.h                  |    2 +-
 drivers/media/usb/go7007/go7007-driver.c           |    4 +-
 drivers/media/usb/go7007/go7007-priv.h             |    2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   15 ++-
 drivers/media/usb/hackrf/hackrf.c                  |   16 ++-
 drivers/media/usb/msi2500/msi2500.c                |   18 +--
 drivers/media/usb/pwc/pwc-if.c                     |   24 ++--
 drivers/media/usb/pwc/pwc-uncompress.c             |    8 +-
 drivers/media/usb/pwc/pwc.h                        |    2 +-
 drivers/media/usb/s2255/s2255drv.c                 |   17 +--
 drivers/media/usb/stk1160/stk1160-v4l.c            |   11 +-
 drivers/media/usb/stk1160/stk1160-video.c          |    4 +-
 drivers/media/usb/stk1160/stk1160.h                |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   13 +-
 drivers/media/usb/usbtv/usbtv.h                    |    2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   25 ++--
 drivers/media/usb/uvc/uvcvideo.h                   |    2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |    6 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  134 ++++++++++++--------
 drivers/usb/gadget/function/uvc_queue.c            |   20 +--
 drivers/usb/gadget/function/uvc_queue.h            |    2 +-
 include/media/v4l2-mem2mem.h                       |    8 +-
 include/media/videobuf2-v4l2.h                     |   70 ++++++----
 include/trace/events/v4l2.h                        |   35 ++---
 121 files changed, 1051 insertions(+), 795 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 8be7b9b..2147a90 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -163,7 +163,7 @@ struct sur40_state {
 };
 
 struct sur40_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -420,7 +420,7 @@ static void sur40_process_video(struct sur40_state *sur40)
 
 	dev_dbg(sur40->dev, "header acquired\n");
 
-	sgt = vb2_dma_sg_plane_desc(&new_buf->vb, 0);
+	sgt = vb2_dma_sg_plane_desc(&new_buf->vb.vb2_buf, 0);
 
 	result = usb_sg_init(&sgr, sur40->usbdev,
 		usb_rcvbulkpipe(sur40->usbdev, VIDEO_ENDPOINT), 0,
@@ -446,12 +446,12 @@ static void sur40_process_video(struct sur40_state *sur40)
 	v4l2_get_timestamp(&new_buf->vb.v4l2_buf.timestamp);
 	new_buf->vb.v4l2_buf.sequence = sur40->sequence++;
 	new_buf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
-	vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&new_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	dev_dbg(sur40->dev, "buffer marked done\n");
 	return;
 
 err_poll:
-	vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_ERROR);
+	vb2_buffer_done(&new_buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 }
 
 /* Initialize input device parameters. */
@@ -685,8 +685,9 @@ static int sur40_buffer_prepare(struct vb2_buffer *vb)
  */
 static void sur40_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct sur40_state *sur40 = vb2_get_drv_priv(vb->vb2_queue);
-	struct sur40_buffer *buf = (struct sur40_buffer *)vb;
+	struct sur40_buffer *buf = (struct sur40_buffer *)vbuf;
 
 	spin_lock(&sur40->qlock);
 	list_add_tail(&buf->list, &sur40->buf_list);
@@ -700,7 +701,7 @@ static void return_all_buffers(struct sur40_state *sur40,
 
 	spin_lock(&sur40->qlock);
 	list_for_each_entry_safe(buf, node, &sur40->buf_list, list) {
-		vb2_buffer_done(&buf->vb, state);
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
 		list_del(&buf->list);
 	}
 	spin_unlock(&sur40->qlock);
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 7edb885..c900185d 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -107,7 +107,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct rtl2832_sdr_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -304,13 +304,13 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
+		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		len = rtl2832_sdr_convert_stream(dev, ptr, urb->transfer_buffer,
 				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb, 0, len);
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
 		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
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
@@ -518,14 +518,15 @@ static int rtl2832_sdr_buf_prepare(struct vb2_buffer *vb)
 
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
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
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
index 7aee76a..bbea734 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -432,7 +432,7 @@ static void cx23885_wakeup(struct cx23885_tsport *port,
 	dprintk(1, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.v4l2_buf.index,
 		count, q->count);
 	list_del(&buf->queue);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 int cx23885_sram_channel_setup(struct cx23885_dev *dev,
@@ -1453,12 +1453,12 @@ int cx23885_buf_prepare(struct cx23885_buffer *buf, struct cx23885_tsport *port)
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
@@ -1530,7 +1530,7 @@ static void do_cancel_buffers(struct cx23885_tsport *port, char *reason)
 		buf = list_entry(q->active.next, struct cx23885_buffer,
 				 queue);
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		dprintk(1, "[%p/%d] %s - dma=0x%08lx\n",
 			buf, buf->vb.v4l2_buf.index, reason, (unsigned long)buf->risc.dma);
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
index d362d38..e84e5bd 100644
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
@@ -190,8 +192,9 @@ static void buffer_finish(struct vb2_buffer *vb)
  */
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
-	struct cx23885_buffer *buf = container_of(vb, struct cx23885_buffer, vb);
+	struct cx23885_buffer *buf = container_of(vbuf, struct cx23885_buffer, vb);
 	struct cx23885_buffer *prev;
 	struct cx23885_dmaqueue *q = &dev->vbiq;
 	unsigned long flags;
@@ -245,7 +248,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 			struct cx23885_buffer, queue);
 
 		list_del(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ec76470..d06fc87 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -109,7 +109,7 @@ void cx23885_video_wakeup(struct cx23885_dev *dev,
 	dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.v4l2_buf.index,
 			count, q->count);
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
index 7bc495e..af0e425 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -133,7 +133,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 			v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 			buf->vb.v4l2_buf.sequence = dmaq->count++;
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
index d81a08a..fb2920c 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -127,7 +127,7 @@ struct cx25821_riscmem {
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
index aab7cf4..38ddfaf 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -522,7 +522,7 @@ void cx88_wakeup(struct cx88_core *core,
 	buf->vb.v4l2_buf.field = core->field;
 	buf->vb.v4l2_buf.sequence = q->count++;
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
index 34f5057..a4f5e1e 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -229,9 +229,9 @@ int cx8802_buf_prepare(struct vb2_queue *q, struct cx8802_dev *dev,
 	struct cx88_riscmem *risc = &buf->risc;
 	int rc;
 
-	if (vb2_plane_size(&buf->vb, 0) < size)
+	if (vb2_plane_size(&buf->vb.vb2_buf, 0) < size)
 		return -EINVAL;
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 
 	rc = cx88_risc_databuffer(dev->pci, risc, sgt->sgl,
 			     dev->ts_packet_size, dev->ts_packet_count, 0);
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
index 7510e80..cd2f3fb 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
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
 
@@ -213,7 +216,7 @@ static void stop_streaming(struct vb2_queue *q)
 			struct cx88_buffer, list);
 
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 400e5ca..fae28e7 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -444,6 +444,7 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_core *core = dev->core;
 	struct cx88_buffer *buf = container_of(vb, struct cx88_buffer, vb);
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
index 8df6345..f4f8355 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -160,11 +160,11 @@ static int dt3155_buf_prepare(struct vb2_buffer *vb)
 static int dt3155_start_streaming(struct vb2_queue *q, unsigned count)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
-	struct vb2_buffer *vb = pd->curr_buf;
+	struct vb2_v4l2_buffer *vb = pd->curr_buf;
 	dma_addr_t dma_addr;
 
 	pd->sequence = 0;
-	dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	dma_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	iowrite32(dma_addr, pd->regs + EVEN_DMA_START);
 	iowrite32(dma_addr + pd->width, pd->regs + ODD_DMA_START);
 	iowrite32(pd->width, pd->regs + EVEN_DMA_STRIDE);
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
 
@@ -272,11 +273,11 @@ static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 		v4l2_get_timestamp(&ipd->curr_buf->v4l2_buf.timestamp);
 		ipd->curr_buf->v4l2_buf.sequence = ipd->sequence++;
 		ipd->curr_buf->v4l2_buf.field = V4L2_FIELD_NONE;
-		vb2_buffer_done(ipd->curr_buf, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&ipd->curr_buf->vb2_buf, VB2_BUF_STATE_DONE);
 
 		ivb = list_first_entry(&ipd->dmaq, typeof(*ivb), done_entry);
 		list_del(&ivb->done_entry);
-		ipd->curr_buf = ivb;
+		ipd->curr_buf = to_vb2_v4l2_buffer(ivb);
 		dma_addr = vb2_dma_contig_plane_dma_addr(ivb, 0);
 		iowrite32(dma_addr, ipd->regs + EVEN_DMA_START);
 		iowrite32(dma_addr + ipd->width, ipd->regs + ODD_DMA_START);
diff --git a/drivers/media/pci/dt3155/dt3155.h b/drivers/media/pci/dt3155/dt3155.h
index 4e1f4d5..73d9d6e 100644
--- a/drivers/media/pci/dt3155/dt3155.h
+++ b/drivers/media/pci/dt3155/dt3155.h
@@ -181,7 +181,7 @@ struct dt3155_priv {
 	struct pci_dev *pdev;
 	struct vb2_queue vidq;
 	struct vb2_alloc_ctx *alloc_ctx;
-	struct vb2_buffer *curr_buf;
+	struct vb2_v4l2_buffer *curr_buf;
 	struct mutex mux;
 	struct list_head dmaq;
 	spinlock_t lock;
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 72d7f99..7d76e59 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -216,13 +216,13 @@ int saa7134_buffer_count(unsigned int size, unsigned int count)
 
 int saa7134_buffer_startpage(struct saa7134_buf *buf)
 {
-	return saa7134_buffer_pages(vb2_plane_size(&buf->vb2, 0)) * buf->vb2.v4l2_buf.index;
+	return saa7134_buffer_pages(vb2_plane_size(&buf->vb2.vb2_buf, 0)) * buf->vb2.v4l2_buf.index;
 }
 
 unsigned long saa7134_buffer_base(struct saa7134_buf *buf)
 {
 	unsigned long base;
-	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2.vb2_buf, 0);
 
 	base  = saa7134_buffer_startpage(buf) * 4096;
 	base += dma->sgl[0].offset;
@@ -310,7 +310,7 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 	/* finish current buffer */
 	v4l2_get_timestamp(&q->curr->vb2.v4l2_buf.timestamp);
 	q->curr->vb2.v4l2_buf.sequence = q->seq_nr++;
-	vb2_buffer_done(&q->curr->vb2, state);
+	vb2_buffer_done(&q->curr->vb2.vb2_buf, state);
 	q->curr = NULL;
 }
 
@@ -375,7 +375,8 @@ void saa7134_stop_streaming(struct saa7134_dev *dev, struct saa7134_dmaqueue *q)
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
index 4b202fa..62b218b 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -77,10 +77,11 @@ static int buffer_activate(struct saa7134_dev *dev,
 	return 0;
 }
 
-int saa7134_ts_buffer_init(struct vb2_buffer *vb2)
+int saa7134_ts_buffer_init(struct vb2_buffer *vb)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
 
 	dmaq->curr = NULL;
 	buf->activate = buffer_activate;
@@ -89,12 +90,13 @@ int saa7134_ts_buffer_init(struct vb2_buffer *vb2)
 }
 EXPORT_SYMBOL_GPL(saa7134_ts_buffer_init);
 
-int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
+int saa7134_ts_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
-	struct sg_table *dma = vb2_dma_sg_plane_desc(vb2, 0);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned int lines, llength, size;
 
 	ts_dbg("buffer_prepare [%p]\n", buf);
@@ -103,11 +105,11 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 	lines = dev->ts.nr_packets;
 
 	size = lines * llength;
-	if (vb2_plane_size(vb2, 0) < size)
+	if (vb2_plane_size(vb, 0) < size)
 		return -EINVAL;
 
-	vb2_set_plane_payload(vb2, 0, size);
-	vb2->v4l2_buf.field = dev->field;
+	vb2_set_plane_payload(vb, 0, size);
+	vbuf->v4l2_buf.field = dev->field;
 
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
index 4d36586..ecc4e61 100644
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
@@ -115,12 +115,13 @@ static int buffer_activate(struct saa7134_dev *dev,
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb2)
+static int buffer_prepare(struct vb2_buffer *vb)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
-	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned int size;
 
 	if (dma->sgl->offset) {
@@ -128,10 +129,10 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 		return -EINVAL;
 	}
 	size = dev->vbi_hlen * dev->vbi_vlen * 2;
-	if (vb2_plane_size(vb2, 0) < size)
+	if (vb2_plane_size(vb, 0) < size)
 		return -EINVAL;
 
-	vb2_set_plane_payload(vb2, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
 
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
@@ -158,10 +159,11 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb2)
+static int buffer_init(struct vb2_buffer *vb)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
 
 	dmaq->curr = NULL;
 	buf->activate = buffer_activate;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 035039c..a03bbb8 100644
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
 
@@ -869,22 +869,24 @@ static int buffer_activate(struct saa7134_dev *dev,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb2)
+static int buffer_init(struct vb2_buffer *vb)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
 
 	dmaq->curr = NULL;
 	buf->activate = buffer_activate;
 	return 0;
 }
 
-static int buffer_prepare(struct vb2_buffer *vb2)
+static int buffer_prepare(struct vb2_buffer *vb)
 {
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
-	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
+	struct saa7134_buf *buf = container_of(vbuf, struct saa7134_buf, vb2);
+	struct sg_table *dma = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned int size;
 
 	if (dma->sgl->offset) {
@@ -892,11 +894,11 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 		return -EINVAL;
 	}
 	size = (dev->width * dev->height * dev->fmt->depth) >> 3;
-	if (vb2_plane_size(vb2, 0) < size)
+	if (vb2_plane_size(vb, 0) < size)
 		return -EINVAL;
 
-	vb2_set_plane_payload(vb2, 0, size);
-	vb2->v4l2_buf.field = dev->field;
+	vb2_set_plane_payload(vb, 0, size);
+	vbuf->v4l2_buf.field = dev->field;
 
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
@@ -930,9 +932,10 @@ static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
  */
 void saa7134_vb2_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct saa7134_dmaqueue *dmaq = vb->vb2_queue->drv_priv;
 	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb, struct saa7134_buf, vb2);
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
index 6b5f6f4..f3f9ba4 100644
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
@@ -817,8 +817,8 @@ void saa7134_video_fini(struct saa7134_dev *dev);
 
 #define TS_PACKET_SIZE 188 /* TS packets 188 bytes */
 
-int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
-int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
+int saa7134_ts_buffer_init(struct vb2_buffer *vb);
+int saa7134_ts_buffer_prepare(struct vb2_buffer *vb);
 int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 53fff54..6238e09 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -456,7 +456,7 @@ static inline u32 vop_usec(const vop_header *vh)
 }
 
 static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
-			  struct vb2_buffer *vb, const vop_header *vh)
+			  struct vb2_v4l2_buffer *vb, const vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
@@ -464,11 +464,12 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 
 	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
 
-	if (vb2_plane_size(vb, 0) < vop_jpeg_size(vh) + solo_enc->jpeg_len)
+	if (vb2_plane_size(&vb->vb2_buf, 0) < vop_jpeg_size(vh) + solo_enc->jpeg_len)
 		return -EIO;
 
 	frame_size = ALIGN(vop_jpeg_size(vh) + solo_enc->jpeg_len, DMA_ALIGN);
-	vb2_set_plane_payload(vb, 0, vop_jpeg_size(vh) + solo_enc->jpeg_len);
+	vb2_set_plane_payload(&vb->vb2_buf, 0,
+			      vop_jpeg_size(vh) + solo_enc->jpeg_len);
 
 	return solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf,
 			     vop_jpeg_offset(vh) - SOLO_JPEG_EXT_ADDR(solo_dev),
@@ -477,14 +478,14 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 }
 
 static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
-		struct vb2_buffer *vb, const vop_header *vh)
+		struct vb2_v4l2_buffer *vb, const vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_off, frame_size;
 	int skip = 0;
 
-	if (vb2_plane_size(vb, 0) < vop_mpeg_size(vh))
+	if (vb2_plane_size(&vb->vb2_buf, 0) < vop_mpeg_size(vh))
 		return -EIO;
 
 	/* If this is a key frame, add extra header */
@@ -493,11 +494,11 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 	if (!vop_type(vh)) {
 		skip = solo_enc->vop_len;
 		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
-		vb2_set_plane_payload(vb, 0, vop_mpeg_size(vh) +
-			solo_enc->vop_len);
+		vb2_set_plane_payload(&vb->vb2_buf, 0,
+				      vop_mpeg_size(vh) + solo_enc->vop_len);
 	} else {
 		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
-		vb2_set_plane_payload(vb, 0, vop_mpeg_size(vh));
+		vb2_set_plane_payload(&vb->vb2_buf, 0, vop_mpeg_size(vh));
 	}
 
 	/* Now get the actual mpeg payload */
@@ -511,7 +512,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 }
 
 static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
-			    struct vb2_buffer *vb, struct solo_enc_buf *enc_buf)
+			    struct vb2_v4l2_buffer *vb, struct solo_enc_buf *enc_buf)
 {
 	const vop_header *vh = enc_buf->vh;
 	int ret;
@@ -546,7 +547,8 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 		}
 	}
 
-	vb2_buffer_done(vb, ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb->vb2_buf,
+			ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 	return ret;
 }
@@ -678,10 +680,11 @@ static int solo_enc_queue_setup(struct vb2_queue *q,
 
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
@@ -734,20 +737,21 @@ static void solo_enc_stop_streaming(struct vb2_queue *q)
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
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 
 	switch (solo_enc->fmt) {
 	case V4L2_PIX_FMT_MPEG4:
 	case V4L2_PIX_FMT_H264:
-		if (vb->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME)
+		if (vbuf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME)
 			sg_copy_from_buffer(vbuf->sgl, vbuf->nents,
 					solo_enc->vop, solo_enc->vop_len);
 		break;
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 63ae8a6..b46196b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -189,19 +189,19 @@ static int solo_v4l2_set_ch(struct solo_dev *solo_dev, u8 ch)
 }
 
 static void solo_fillbuf(struct solo_dev *solo_dev,
-			 struct vb2_buffer *vb)
+			 struct vb2_v4l2_buffer *vb)
 {
 	dma_addr_t vbuf;
 	unsigned int fdma_addr;
 	int error = -1;
 	int i;
 
-	vbuf = vb2_dma_contig_plane_dma_addr(vb, 0);
+	vbuf = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	if (!vbuf)
 		goto finish_buf;
 
 	if (erase_off(solo_dev)) {
-		void *p = vb2_plane_vaddr(vb, 0);
+		void *p = vb2_plane_vaddr(&vb->vb2_buf, 0);
 		int image_size = solo_image_size(solo_dev);
 
 		for (i = 0; i < image_size; i += 2) {
@@ -220,13 +220,14 @@ static void solo_fillbuf(struct solo_dev *solo_dev,
 
 finish_buf:
 	if (!error) {
-		vb2_set_plane_payload(vb, 0,
-			solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
+		vb2_set_plane_payload(&vb->vb2_buf, 0,
+				      solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
 		vb->v4l2_buf.sequence = solo_dev->sequence++;
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 	}
 
-	vb2_buffer_done(vb, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb->vb2_buf,
+			error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 }
 
 static void solo_thread_try(struct solo_dev *solo_dev)
@@ -345,10 +346,11 @@ static void solo_stop_streaming(struct vb2_queue *q)
 
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
index 59b3a36..1edc1f2 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -88,11 +88,11 @@
 
 
 struct vip_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 	dma_addr_t		dma;
 };
-static inline struct vip_buffer *to_vip_buffer(struct vb2_buffer *vb2)
+static inline struct vip_buffer *to_vip_buffer(struct vb2_v4l2_buffer *vb2)
 {
 	return container_of(vb2, struct vip_buffer, vb);
 }
@@ -287,7 +287,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 };
 static int buffer_init(struct vb2_buffer *vb)
 {
-	struct vip_buffer *vip_buf = to_vip_buffer(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vip_buffer *vip_buf = to_vip_buffer(vbuf);
 
 	vip_buf->dma = vb2_dma_contig_plane_dma_addr(vb, 0);
 	INIT_LIST_HEAD(&vip_buf->list);
@@ -296,8 +297,9 @@ static int buffer_init(struct vb2_buffer *vb)
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
-	struct vip_buffer *vip_buf = to_vip_buffer(vb);
+	struct vip_buffer *vip_buf = to_vip_buffer(vbuf);
 	unsigned long size;
 
 	size = vip->format.sizeimage;
@@ -307,14 +309,15 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&vip_buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
-	struct vip_buffer *vip_buf = to_vip_buffer(vb);
+	struct vip_buffer *vip_buf = to_vip_buffer(vbuf);
 
 	spin_lock(&vip->lock);
 	list_add_tail(&vip_buf->list, &vip->buffer_list);
@@ -329,8 +332,9 @@ static void buffer_queue(struct vb2_buffer *vb)
 }
 static void buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
-	struct vip_buffer *vip_buf = to_vip_buffer(vb);
+	struct vip_buffer *vip_buf = to_vip_buffer(vbuf);
 
 	/* Buffer handled, remove it from the list */
 	spin_lock(&vip->lock);
@@ -370,7 +374,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* Release all active buffers */
 	spin_lock(&vip->lock);
 	list_for_each_entry_safe(vip_buf, node, &vip->buffer_list, list) {
-		vb2_buffer_done(&vip_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&vip_buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&vip_buf->list);
 	}
 	spin_unlock(&vip->lock);
@@ -815,7 +819,8 @@ static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
 		/* Remove the active buffer from the list */
 		v4l2_get_timestamp(&vip->active->vb.v4l2_buf.timestamp);
 		vip->active->vb.v4l2_buf.sequence = vip->sequence++;
-		vb2_buffer_done(&vip->active->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vip->active->vb.vb2_buf,
+				VB2_BUF_STATE_DONE);
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 8355e55..a2ecc5c 100644
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
 
@@ -1015,7 +1018,7 @@ void tw68_irq_video_done(struct tw68_dev *dev, unsigned long status)
 		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 		buf->vb.v4l2_buf.field = dev->field;
 		buf->vb.v4l2_buf.sequence = dev->seqnr++;
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 		status &= ~(TW68_DMAPI);
 		if (0 == status)
 			return;
diff --git a/drivers/media/pci/tw68/tw68.h b/drivers/media/pci/tw68/tw68.h
index 93f2335..e23c77c 100644
--- a/drivers/media/pci/tw68/tw68.h
+++ b/drivers/media/pci/tw68/tw68.h
@@ -134,7 +134,7 @@ struct tw68_dev;	/* forward delclaration */
 
 /* buffer for one video/vbi/ts frame */
 struct tw68_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	unsigned int   size;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index c8447fa..794408b 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -307,7 +307,7 @@ static inline struct vpfe_device *to_vpfe(struct vpfe_ccdc *ccdc)
 	return container_of(ccdc, struct vpfe_device, ccdc);
 }
 
-static inline struct vpfe_cap_buffer *to_vpfe_buffer(struct vb2_buffer *vb)
+static inline struct vpfe_cap_buffer *to_vpfe_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vpfe_cap_buffer, vb);
 }
@@ -1257,14 +1257,15 @@ static inline void vpfe_schedule_next_buffer(struct vpfe_device *vpfe)
 	list_del(&vpfe->next_frm->list);
 
 	vpfe_set_sdr_addr(&vpfe->ccdc,
-		       vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb, 0));
+		       vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb.vb2_buf, 0));
 }
 
 static inline void vpfe_schedule_bottom_field(struct vpfe_device *vpfe)
 {
 	unsigned long addr;
 
-	addr = vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb, 0) +
+	addr = vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb.vb2_buf,
+					     0) +
 					vpfe->field_off;
 
 	vpfe_set_sdr_addr(&vpfe->ccdc, addr);
@@ -1283,7 +1284,7 @@ static inline void vpfe_process_buffer_complete(struct vpfe_device *vpfe)
 	v4l2_get_timestamp(&vpfe->cur_frm->vb.v4l2_buf.timestamp);
 	vpfe->cur_frm->vb.v4l2_buf.field = vpfe->fmt.fmt.pix.field;
 	vpfe->cur_frm->vb.v4l2_buf.sequence = vpfe->sequence++;
-	vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vpfe->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	vpfe->cur_frm = vpfe->next_frm;
 }
 
@@ -1942,6 +1943,7 @@ static int vpfe_queue_setup(struct vb2_queue *vq,
  */
 static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2_queue);
 
 	vb2_set_plane_payload(vb, 0, vpfe->fmt.fmt.pix.sizeimage);
@@ -1949,7 +1951,7 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 		return -EINVAL;
 
-	vb->v4l2_buf.field = vpfe->fmt.fmt.pix.field;
+	vbuf->v4l2_buf.field = vpfe->fmt.fmt.pix.field;
 
 	return 0;
 }
@@ -1960,8 +1962,9 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
  */
 static void vpfe_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpfe_cap_buffer *buf = to_vpfe_buffer(vb);
+	struct vpfe_cap_buffer *buf = to_vpfe_buffer(vbuf);
 	unsigned long flags = 0;
 
 	/* add the buffer to the DMA queue */
@@ -2006,7 +2009,8 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	list_del(&vpfe->cur_frm->list);
 	spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
 
-	addr = vb2_dma_contig_plane_dma_addr(&vpfe->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&vpfe->cur_frm->vb.vb2_buf,
+					     0);
 
 	vpfe_set_sdr_addr(&vpfe->ccdc, (unsigned long)(addr));
 
@@ -2023,7 +2027,7 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &vpfe->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 
 	return ret;
@@ -2055,13 +2059,14 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
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
 
@@ -2069,7 +2074,8 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
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
index b7e70fb..2a03c1a 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -54,7 +54,7 @@ struct bcap_format {
 };
 
 struct bcap_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -149,7 +149,7 @@ static const struct bcap_format bcap_formats[] = {
 
 static irqreturn_t bcap_isr(int irq, void *dev_id);
 
-static struct bcap_buffer *to_bcap_vb(struct vb2_buffer *vb)
+static struct bcap_buffer *to_bcap_vb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct bcap_buffer, vb);
 }
@@ -223,6 +223,7 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 
 static int bcap_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size = bcap_dev->fmt.sizeimage;
 
@@ -232,16 +233,16 @@ static int bcap_buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 	vb2_set_plane_payload(vb, 0, size);
-
-	vb->v4l2_buf.field = bcap_dev->fmt.field;
+	vbuf->v4l2_buf.field = bcap_dev->fmt.field;
 
 	return 0;
 }
 
 static void bcap_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct bcap_buffer *buf = to_bcap_vb(vb);
+	struct bcap_buffer *buf = to_bcap_vb(vbuf);
 	unsigned long flags;
 
 	spin_lock_irqsave(&bcap_dev->lock, flags);
@@ -251,8 +252,9 @@ static void bcap_buffer_queue(struct vb2_buffer *vb)
 
 static void bcap_buffer_cleanup(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct bcap_buffer *buf = to_bcap_vb(vb);
+	struct bcap_buffer *buf = to_bcap_vb(vbuf);
 	unsigned long flags;
 
 	spin_lock_irqsave(&bcap_dev->lock, flags);
@@ -344,7 +346,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &bcap_dev->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 
 	return ret;
@@ -367,13 +369,14 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 
 	/* release all active buffers */
 	if (bcap_dev->cur_frm)
-		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&bcap_dev->cur_frm->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 
 	while (!list_empty(&bcap_dev->dma_queue)) {
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 						struct bcap_buffer, list);
 		list_del_init(&bcap_dev->cur_frm->list);
-		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&bcap_dev->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 }
 
@@ -392,7 +395,7 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 {
 	struct ppi_if *ppi = dev_id;
 	struct bcap_device *bcap_dev = ppi->priv;
-	struct vb2_buffer *vb = &bcap_dev->cur_frm->vb;
+	struct vb2_v4l2_buffer *vb = &bcap_dev->cur_frm->vb;
 	dma_addr_t addr;
 
 	spin_lock(&bcap_dev->lock);
@@ -400,11 +403,11 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 	if (!list_empty(&bcap_dev->dma_queue)) {
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		if (ppi->err) {
-			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_ERROR);
 			ppi->err = false;
 		} else {
 			vb->v4l2_buf.sequence = bcap_dev->sequence++;
-			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 		}
 		bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
 				struct bcap_buffer, list);
@@ -420,7 +423,8 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 	if (bcap_dev->stop) {
 		complete(&bcap_dev->comp);
 	} else {
-		addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
+		addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb.vb2_buf,
+						     0);
 		ppi->ops->update_addr(ppi, (unsigned long)addr);
 		ppi->ops->start(ppi);
 	}
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index d058447..1b5e9ae 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -179,12 +179,13 @@ static void coda_kfifo_sync_to_device_write(struct coda_ctx *ctx)
 }
 
 static int coda_bitstream_queue(struct coda_ctx *ctx,
-				struct vb2_buffer *src_buf)
+				struct vb2_v4l2_buffer *src_buf)
 {
-	u32 src_size = vb2_get_plane_payload(src_buf, 0);
+	u32 src_size = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
 	u32 n;
 
-	n = kfifo_in(&ctx->bitstream_fifo, vb2_plane_vaddr(src_buf, 0),
+	n = kfifo_in(&ctx->bitstream_fifo,
+		     vb2_plane_vaddr(&src_buf->vb2_buf, 0),
 		     src_size);
 	if (n < src_size)
 		return -ENOSPC;
@@ -195,15 +196,15 @@ static int coda_bitstream_queue(struct coda_ctx *ctx,
 }
 
 static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
-				     struct vb2_buffer *src_buf)
+				     struct vb2_v4l2_buffer *src_buf)
 {
 	int ret;
 
 	if (coda_get_bitstream_payload(ctx) +
-	    vb2_get_plane_payload(src_buf, 0) + 512 >= ctx->bitstream.size)
+	    vb2_get_plane_payload(&src_buf->vb2_buf, 0) + 512 >= ctx->bitstream.size)
 		return false;
 
-	if (vb2_plane_vaddr(src_buf, 0) == NULL) {
+	if (vb2_plane_vaddr(&src_buf->vb2_buf, 0) == NULL) {
 		v4l2_err(&ctx->dev->v4l2_dev, "trying to queue empty buffer\n");
 		return true;
 	}
@@ -224,7 +225,7 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 
 void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 {
-	struct vb2_buffer *src_buf;
+	struct vb2_v4l2_buffer *src_buf;
 	struct coda_buffer_meta *meta;
 	unsigned long flags;
 	u32 start;
@@ -476,7 +477,7 @@ err:
 	return ret;
 }
 
-static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
+static int coda_encode_header(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 			      int header_code, u8 *header, int *size)
 {
 	struct coda_dev *dev = ctx->dev;
@@ -485,11 +486,11 @@ static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
 	int i;
 
 	if (dev->devtype->product == CODA_960)
-		memset(vb2_plane_vaddr(buf, 0), 0, 64);
+		memset(vb2_plane_vaddr(&buf->vb2_buf, 0), 0, 64);
 
-	coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0),
+	coda_write(dev, vb2_dma_contig_plane_dma_addr(&buf->vb2_buf, 0),
 		   CODA_CMD_ENC_HEADER_BB_START);
-	bufsize = vb2_plane_size(buf, 0);
+	bufsize = vb2_plane_size(&buf->vb2_buf, 0);
 	if (dev->devtype->product == CODA_960)
 		bufsize /= 1024;
 	coda_write(dev, bufsize, CODA_CMD_ENC_HEADER_BB_SIZE);
@@ -502,14 +503,14 @@ static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
 
 	if (dev->devtype->product == CODA_960) {
 		for (i = 63; i > 0; i--)
-			if (((char *)vb2_plane_vaddr(buf, 0))[i] != 0)
+			if (((char *)vb2_plane_vaddr(&buf->vb2_buf, 0))[i] != 0)
 				break;
 		*size = i + 1;
 	} else {
 		*size = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx)) -
 			coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
 	}
-	memcpy(header, vb2_plane_vaddr(buf, 0), *size);
+	memcpy(header, vb2_plane_vaddr(&buf->vb2_buf, 0), *size);
 
 	return 0;
 }
@@ -792,7 +793,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
 	u32 bitstream_buf, bitstream_size;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 	int gamma, ret, value;
 	u32 dst_fourcc;
 	int num_fb;
@@ -803,7 +804,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	dst_fourcc = q_data_dst->fourcc;
 
 	buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
-	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
+	bitstream_buf = vb2_dma_contig_plane_dma_addr(&buf->vb2_buf, 0);
 	bitstream_size = q_data_dst->sizeimage;
 
 	if (!coda_is_initialized(dev)) {
@@ -1178,7 +1179,7 @@ out:
 static int coda_prepare_encode(struct coda_ctx *ctx)
 {
 	struct coda_q_data *q_data_src, *q_data_dst;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	int force_ipicture;
 	int quant_param = 0;
@@ -1219,7 +1220,7 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	 */
 	if (src_buf->v4l2_buf.sequence == 0) {
 		pic_stream_buffer_addr =
-			vb2_dma_contig_plane_dma_addr(dst_buf, 0) +
+			vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0) +
 			ctx->vpu_header_size[0] +
 			ctx->vpu_header_size[1] +
 			ctx->vpu_header_size[2];
@@ -1227,16 +1228,16 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 			ctx->vpu_header_size[0] -
 			ctx->vpu_header_size[1] -
 			ctx->vpu_header_size[2];
-		memcpy(vb2_plane_vaddr(dst_buf, 0),
+		memcpy(vb2_plane_vaddr(&dst_buf->vb2_buf, 0),
 		       &ctx->vpu_header[0][0], ctx->vpu_header_size[0]);
-		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0],
+		memcpy(vb2_plane_vaddr(&dst_buf->vb2_buf, 0) + ctx->vpu_header_size[0],
 		       &ctx->vpu_header[1][0], ctx->vpu_header_size[1]);
-		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0] +
+		memcpy(vb2_plane_vaddr(&dst_buf->vb2_buf, 0) + ctx->vpu_header_size[0] +
 			ctx->vpu_header_size[1], &ctx->vpu_header[2][0],
 			ctx->vpu_header_size[2]);
 	} else {
 		pic_stream_buffer_addr =
-			vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+			vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 		pic_stream_buffer_size = q_data_dst->sizeimage;
 	}
 
@@ -1317,7 +1318,7 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 
 static void coda_finish_encode(struct coda_ctx *ctx)
 {
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	u32 wr_ptr, start_ptr;
 
@@ -1332,12 +1333,11 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 
 	/* Calculate bytesused field */
 	if (dst_buf->v4l2_buf.sequence == 0) {
-		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr +
-					ctx->vpu_header_size[0] +
-					ctx->vpu_header_size[1] +
-					ctx->vpu_header_size[2]);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
+				      wr_ptr - start_ptr + ctx->vpu_header_size[0] + ctx->vpu_header_size[1] + ctx->vpu_header_size[2]);
 	} else {
-		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
+				      wr_ptr - start_ptr);
 	}
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n",
@@ -1709,7 +1709,7 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 
 static int coda_prepare_decode(struct coda_ctx *ctx)
 {
-	struct vb2_buffer *dst_buf;
+	struct vb2_v4l2_buffer *dst_buf;
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_dst;
 	struct coda_buffer_meta *meta;
@@ -1831,7 +1831,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_src;
 	struct coda_q_data *q_data_dst;
-	struct vb2_buffer *dst_buf;
+	struct vb2_v4l2_buffer *dst_buf;
 	struct coda_buffer_meta *meta;
 	unsigned long payload;
 	unsigned long flags;
@@ -2045,7 +2045,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 			payload = width * height * 2;
 			break;
 		}
-		vb2_set_plane_payload(dst_buf, 0, payload);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload);
 
 		coda_m2m_buf_done(ctx, dst_buf, ctx->frame_errors[display_idx] ?
 				  VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6e0c9be..0b84bd3 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -84,9 +84,9 @@ unsigned int coda_read(struct coda_dev *dev, u32 reg)
 }
 
 void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
-		     struct vb2_buffer *buf, unsigned int reg_y)
+		     struct vb2_v4l2_buffer *buf, unsigned int reg_y)
 {
-	u32 base_y = vb2_dma_contig_plane_dma_addr(buf, 0);
+	u32 base_y = vb2_dma_contig_plane_dma_addr(&buf->vb2_buf, 0);
 	u32 base_cb, base_cr;
 
 	switch (q_data->fourcc) {
@@ -684,7 +684,7 @@ static int coda_qbuf(struct file *file, void *priv,
 }
 
 static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
-				      struct vb2_buffer *buf)
+				      struct vb2_v4l2_buffer *buf)
 {
 	struct vb2_queue *src_vq;
 
@@ -694,7 +694,7 @@ static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
 		(buf->v4l2_buf.sequence == (ctx->qsequence - 1)));
 }
 
-void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_buffer *buf,
+void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 		       enum vb2_buffer_state state)
 {
 	const struct v4l2_event eos_event = {
@@ -1175,6 +1175,7 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 
 static void coda_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct coda_q_data *q_data;
@@ -1193,12 +1194,12 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		if (vb2_get_plane_payload(vb, 0) == 0)
 			coda_bit_stream_end_flag(ctx);
 		mutex_lock(&ctx->bitstream_mutex);
-		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 		if (vb2_is_streaming(vb->vb2_queue))
 			coda_fill_bitstream(ctx, true);
 		mutex_unlock(&ctx->bitstream_mutex);
 	} else {
-		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 	}
 }
 
@@ -1247,7 +1248,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 	int ret = 0;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -1338,7 +1339,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct coda_dev *dev = ctx->dev;
-	struct vb2_buffer *buf;
+	struct vb2_v4l2_buffer *buf;
 	unsigned long flags;
 	bool stop;
 
diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index 11e734b..0d09ffd 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -178,12 +178,12 @@ int coda_jpeg_write_tables(struct coda_ctx *ctx)
 	return 0;
 }
 
-bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb)
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_v4l2_buffer *vb)
 {
-	void *vaddr = vb2_plane_vaddr(vb, 0);
+	void *vaddr = vb2_plane_vaddr(&vb->vb2_buf, 0);
 	u16 soi = be16_to_cpup((__be16 *)vaddr);
 	u16 eoi = be16_to_cpup((__be16 *)(vaddr +
-					  vb2_get_plane_payload(vb, 0) - 2));
+					  vb2_get_plane_payload(&vb->vb2_buf, 0) - 2));
 
 	return soi == SOI_MARKER && eoi == EOI_MARKER;
 }
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index feb9671..3684583 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -243,7 +243,7 @@ extern int coda_debug;
 void coda_write(struct coda_dev *dev, u32 data, u32 reg);
 unsigned int coda_read(struct coda_dev *dev, u32 reg);
 void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
-		     struct vb2_buffer *buf, unsigned int reg_y);
+		     struct vb2_v4l2_buffer *buf, unsigned int reg_y);
 
 int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
 		       size_t size, const char *name, struct dentry *parent);
@@ -289,7 +289,7 @@ void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_buffer *buf,
 
 int coda_h264_padding(int size, char *p);
 
-bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb);
+bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_v4l2_buffer *vb);
 int coda_jpeg_write_tables(struct coda_ctx *ctx);
 void coda_set_jpeg_compression_quality(struct coda_ctx *ctx, int quality);
 
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index f69cdd7..bf5bf69 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -260,7 +260,8 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static void vpbe_buffer_queue(struct vb2_buffer *vb)
 {
 	/* Get the file handle object and layer object */
-	struct vpbe_disp_buffer *buf = container_of(vb,
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vpbe_disp_buffer *buf = container_of(vbuf,
 				struct vpbe_disp_buffer, vb);
 	struct vpbe_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpbe_display *disp = layer->disp_dev;
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a5f5481..d0d76e2 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -57,7 +57,7 @@ static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] = { {1, 1} };
 /* Is set to 1 in case of SDTV formats, 2 in case of HDTV formats. */
 static int ycmux_mode;
 
-static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vpif_cap_buffer, vb);
 }
@@ -72,6 +72,7 @@ static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
  */
 static int vpif_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 	struct channel_obj *ch = vb2_get_drv_priv(q);
 	struct common_obj *common;
@@ -85,7 +86,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 		return -EINVAL;
 
-	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
+	vbuf->v4l2_buf.field = common->fmt.fmt.pix.field;
 
 	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	if (!IS_ALIGNED((addr + common->ytop_off), 8) ||
@@ -145,8 +146,9 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
  */
 static void vpif_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
+	struct vpif_cap_buffer *buf = to_vpif_buffer(vbuf);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -214,7 +216,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	list_del(&common->cur_frm->list);
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
-	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb.vb2_buf,
+					     0);
 
 	common->set_addr(addr + common->ytop_off,
 			 addr + common->ybtm_off,
@@ -243,7 +246,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
@@ -286,13 +289,14 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
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
 
@@ -300,7 +304,8 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_cap_buffer, list);
 		list_del(&common->next_frm->list);
-		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
@@ -326,8 +331,7 @@ static struct vb2_ops video_qops = {
 static void vpif_process_buffer_complete(struct common_obj *common)
 {
 	v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&common->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	/* Make curFrm pointing to nextFrm */
 	common->cur_frm = common->next_frm;
 }
@@ -350,7 +354,8 @@ static void vpif_schedule_next_buffer(struct common_obj *common)
 	/* Remove that buffer from the buffer queue */
 	list_del(&common->next_frm->list);
 	spin_unlock(&common->irqlock);
-	addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb.vb2_buf,
+					     0);
 
 	/* Set top and bottom field addresses in VPIF registers */
 	common->set_addr(addr + common->ytop_off,
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
index 682e5d5..46fc783 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -53,7 +53,7 @@ static struct device *vpif_dev;
 static void vpif_calculate_offsets(struct channel_obj *ch);
 static void vpif_config_addr(struct channel_obj *ch, int muxmode);
 
-static inline struct vpif_disp_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+static inline struct vpif_disp_buffer *to_vpif_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vpif_disp_buffer, vb);
 }
@@ -66,21 +66,22 @@ static inline struct vpif_disp_buffer *to_vpif_buffer(struct vb2_buffer *vb)
  * function is called. The buffer is prepared and user space virtual address
  * or user address is converted into  physical address
  */
-static int vpif_buffer_prepare(struct vb2_buffer *vb)
+static int vpif_buffer_prepare(struct vb2_v4l2_buffer *vb)
 {
 	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
 	struct common_obj *common;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
-	vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
-	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+	vb2_set_plane_payload(&vb->vb2_buf, 0, common->fmt.fmt.pix.sizeimage);
+	if (vb2_get_plane_payload(&vb->vb2_buf, 0) > vb2_plane_size(&vb->vb2_buf, 0))
 		return -EINVAL;
 
 	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
 
 	if (vb->vb2_queue->type != V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
-		unsigned long addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+		unsigned long addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf,
+								   0);
 
 		if (!ISALIGNED(addr + common->ytop_off) ||
 			!ISALIGNED(addr + common->ybtm_off) ||
@@ -136,7 +137,7 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
  *
  * This callback fucntion queues the buffer to DMA engine
  */
-static void vpif_buffer_queue(struct vb2_buffer *vb)
+static void vpif_buffer_queue(struct vb2_v4l2_buffer *vb)
 {
 	struct vpif_disp_buffer *buf = to_vpif_buffer(vb);
 	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
@@ -197,7 +198,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	list_del(&common->cur_frm->list);
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
-	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb.vb2_buf,
+					     0);
 	common->set_addr((addr + common->ytop_off),
 			    (addr + common->ybtm_off),
 			    (addr + common->ctop_off),
@@ -229,7 +231,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 err:
 	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 
@@ -264,13 +266,14 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
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
 
@@ -278,7 +281,8 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		common->next_frm = list_entry(common->dma_queue.next,
 						struct vpif_disp_buffer, list);
 		list_del(&common->next_frm->list);
-		vb2_buffer_done(&common->next_frm->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&common->next_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
@@ -306,7 +310,8 @@ static void process_progressive_mode(struct common_obj *common)
 	spin_unlock(&common->irqlock);
 
 	/* Set top and bottom field addrs in VPIF registers */
-	addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&common->next_frm->vb.vb2_buf,
+					     0);
 	common->set_addr(addr + common->ytop_off,
 				 addr + common->ybtm_off,
 				 addr + common->ctop_off,
@@ -326,8 +331,8 @@ static void process_interlaced_mode(int fid, struct common_obj *common)
 		/* Copy frame display time */
 		v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
 		/* Change status of the cur_frm */
-		vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_DONE);
 		/* Make cur_frm pointing to next_frm */
 		common->cur_frm = common->next_frm;
 
@@ -382,8 +387,8 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 				 * done and unlock semaphore on it */
 				v4l2_get_timestamp(&common->cur_frm->vb.
 						   v4l2_buf.timestamp);
-				vb2_buffer_done(&common->cur_frm->vb,
-					    VB2_BUF_STATE_DONE);
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
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 9b9e423..1ac17b4 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -798,7 +798,7 @@ void gsc_ctrls_delete(struct gsc_ctx *ctx)
 }
 
 /* The color format (num_comp, num_planes) must be already configured. */
-int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
+int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_v4l2_buffer *vb,
 			struct gsc_frame *frame, struct gsc_addr *addr)
 {
 	int ret = 0;
@@ -812,7 +812,7 @@ int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
 	pr_debug("num_planes= %d, num_comp= %d, pix_size= %d",
 		frame->fmt->num_planes, frame->fmt->num_comp, pix_size);
 
-	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	addr->y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (frame->fmt->num_planes == 1) {
 		switch (frame->fmt->num_comp) {
@@ -841,10 +841,12 @@ int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
 		}
 	} else {
 		if (frame->fmt->num_planes >= 2)
-			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
+			addr->cb = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf,
+								 1);
 
 		if (frame->fmt->num_planes == 3)
-			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
+			addr->cr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf,
+								 2);
 	}
 
 	if ((frame->fmt->pixelformat == V4L2_PIX_FMT_VYUY) ||
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 769ff50..7dd6aef 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -136,7 +136,7 @@ struct gsc_fmt {
  * @idx : index of G-Scaler input buffer
  */
 struct gsc_input_buf {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 	int			idx;
 };
@@ -408,7 +408,7 @@ int gsc_check_scaler_ratio(struct gsc_variant *var, int sw, int sh, int dw,
 int gsc_set_scaler_info(struct gsc_ctx *ctx);
 int gsc_ctrls_create(struct gsc_ctx *ctx);
 void gsc_ctrls_delete(struct gsc_ctx *ctx);
-int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
+int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_v4l2_buffer *vb,
 		     struct gsc_frame *frame, struct gsc_addr *addr);
 
 static inline void gsc_ctx_state_lock_set(u32 state, struct gsc_ctx *ctx)
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index d5cffef..6003a4f 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -77,7 +77,7 @@ static void gsc_m2m_stop_streaming(struct vb2_queue *q)
 
 void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	if (!ctx || !ctx->m2m_ctx)
 		return;
@@ -109,7 +109,7 @@ static void gsc_m2m_job_abort(void *priv)
 static int gsc_get_bufs(struct gsc_ctx *ctx)
 {
 	struct gsc_frame *s_frame, *d_frame;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	int ret;
 
 	s_frame = &ctx->s_frame;
@@ -255,12 +255,13 @@ static int gsc_m2m_buf_prepare(struct vb2_buffer *vb)
 
 static void gsc_m2m_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
 	pr_debug("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
 
 	if (ctx->m2m_ctx)
-		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
 }
 
 static struct vb2_ops gsc_m2m_qops = {
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index d0ceae3..78133c1 100644
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
@@ -111,7 +111,8 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 		if (suspend)
 			fimc_pending_queue_add(cap, buf);
 		else
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+				        VB2_BUF_STATE_ERROR);
 	}
 
 	fimc_hw_reset(fimc);
@@ -202,7 +203,7 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 		v_buf->vb.v4l2_buf.sequence = cap->frame_count++;
 
-		vb2_buffer_done(&v_buf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&v_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (!list_empty(&cap->pending_buf_q)) {
@@ -233,7 +234,7 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 		list_for_each_entry(v_buf, &cap->active_buf_q, list) {
 			if (v_buf->index != index)
 				continue;
-			vaddr = vb2_plane_vaddr(&v_buf->vb, plane);
+			vaddr = vb2_plane_vaddr(&v_buf->vb.vb2_buf, plane);
 			v4l2_subdev_call(csis, video, s_rx_buffer,
 					 vaddr, &size);
 			break;
@@ -338,7 +339,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 		if (list_empty(&vid_cap->pending_buf_q))
 			break;
 		buf = fimc_pending_queue_pop(vid_cap);
-		buffer_queue(&buf->vb);
+		buffer_queue(&buf->vb.vb2_buf);
 	}
 	return 0;
 
@@ -410,8 +411,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct fimc_vid_buffer *buf
-		= container_of(vb, struct fimc_vid_buffer, vb);
+		= container_of(vbuf, struct fimc_vid_buffer, vb);
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
@@ -1472,7 +1474,8 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 		if (!list_empty(&fimc->vid_cap.active_buf_q)) {
 			buf = list_entry(fimc->vid_cap.active_buf_q.next,
 					 struct fimc_vid_buffer, list);
-			vb2_set_plane_payload(&buf->vb, 0, *((u32 *)arg));
+			vb2_set_plane_payload(&buf->vb.vb2_buf, 0,
+					      *((u32 *)arg));
 		}
 		fimc_capture_irq_handler(fimc, 1);
 		fimc_deactivate_capture(fimc);
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index cef2a7f..779ff35 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -348,7 +348,7 @@ out:
 }
 
 /* The color format (colplanes, memplanes) must be already configured. */
-int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
+int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_v4l2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr)
 {
 	int ret = 0;
@@ -362,7 +362,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 	dbg("memplanes= %d, colplanes= %d, pix_size= %d",
 		frame->fmt->memplanes, frame->fmt->colplanes, pix_size);
 
-	paddr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	paddr->y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (frame->fmt->memplanes == 1) {
 		switch (frame->fmt->colplanes) {
@@ -390,10 +390,12 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		}
 	} else if (!frame->fmt->mdataplanes) {
 		if (frame->fmt->memplanes >= 2)
-			paddr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
+			paddr->cb = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf,
+								  1);
 
 		if (frame->fmt->memplanes == 3)
-			paddr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
+			paddr->cr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf,
+								  2);
 	}
 
 	dbg("PHYS_ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index ccb5d91..042276c 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -224,7 +224,7 @@ struct fimc_addr {
  * @index: buffer index for the output DMA engine
  */
 struct fimc_vid_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 	struct fimc_addr	paddr;
 	int			index;
@@ -634,7 +634,7 @@ int fimc_check_scaler_ratio(struct fimc_ctx *ctx, int sw, int sh,
 			    int dw, int dh, int rotation);
 int fimc_set_scaler_info(struct fimc_ctx *ctx);
 int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
-int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
+int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_v4l2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr);
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f);
 void fimc_set_yuv_order(struct fimc_ctx *ctx);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 195f9b5..52e1d61 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -194,10 +194,11 @@ static int isp_video_capture_buffer_prepare(struct vb2_buffer *vb)
 
 static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct fimc_isp *isp = vb2_get_drv_priv(vb->vb2_queue);
 	struct fimc_is_video *video = &isp->video_capture;
 	struct fimc_is *is = fimc_isp_to_is(isp);
-	struct isp_video_buf *ivb = to_isp_video_buf(vb);
+	struct isp_video_buf *ivb = to_isp_video_buf(vbuf);
 	unsigned long flags;
 	unsigned int i;
 
@@ -220,7 +221,7 @@ static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
 
 			isp_dbg(2, &video->ve.vdev,
 				"dma_buf %pad (%d/%d/%d) addr: %pad\n",
-				&buf_index, ivb->index, i, vb->v4l2_buf.index,
+				&buf_index, ivb->index, i, vbuf->v4l2_buf.index,
 				&ivb->dma_addr[i]);
 		}
 
@@ -242,7 +243,7 @@ static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
 void fimc_isp_video_irq_handler(struct fimc_is *is)
 {
 	struct fimc_is_video *video = &is->isp.video_capture;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int buf_index;
 
 	/* TODO: Ensure the DMA is really stopped in stop_streaming callback */
@@ -253,7 +254,7 @@ void fimc_isp_video_irq_handler(struct fimc_is *is)
 	vb = &video->buffers[buf_index]->vb;
 
 	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 
 	video->buf_mask &= ~BIT(buf_index);
 	fimc_is_hw_set_isp_buf_mask(is, video->buf_mask);
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
index 7e37c9a..316d25b 100644
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
@@ -208,7 +208,8 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 		if (suspend)
 			fimc_lite_pending_queue_add(fimc, buf);
 		else
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -300,7 +301,7 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
 		flite_hw_mask_dma_buffer(fimc, vbuf->index);
-		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (test_bit(ST_FLITE_CONFIG, &fimc->state))
@@ -422,8 +423,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct flite_buffer *buf
-		= container_of(vb, struct flite_buffer, vb);
+		= container_of(vbuf, struct flite_buffer, vb);
 	struct fimc_lite *fimc = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long flags;
 
@@ -1637,7 +1639,7 @@ static int fimc_lite_resume(struct device *dev)
 		if (list_empty(&fimc->pending_buf_q))
 			break;
 		buf = fimc_lite_pending_queue_pop(fimc);
-		buffer_queue(&buf->vb);
+		buffer_queue(&buf->vb.vb2_buf);
 	}
 	return 0;
 }
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
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 9c27335..f6e72b4 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -42,7 +42,7 @@ static unsigned int get_m2m_fmt_flags(unsigned int stream_type)
 
 void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	if (!ctx || !ctx->fh.m2m_ctx)
 		return;
@@ -99,7 +99,7 @@ static void stop_streaming(struct vb2_queue *q)
 
 static void fimc_device_run(void *priv)
 {
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	struct fimc_ctx *ctx = priv;
 	struct fimc_frame *sf, *df;
 	struct fimc_dev *fimc;
@@ -220,8 +220,10 @@ static int fimc_buf_prepare(struct vb2_buffer *vb)
 
 static void fimc_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static struct vb2_ops fimc_qops = {
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index c07f367..475e82d 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -200,7 +200,7 @@ static void dma_callback(void *data)
 {
 	struct deinterlace_ctx *curr_ctx = data;
 	struct deinterlace_dev *pcdev = curr_ctx->dev;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 
 	atomic_set(&pcdev->busy, 0);
 
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
index 5e2b4df..645ebf8 100644
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
 	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
 	vbuf->v4l2_buf.sequence = cam->buf_seq[frame];
 	vbuf->v4l2_buf.field = V4L2_FIELD_NONE;
 	v4l2_get_timestamp(&vbuf->v4l2_buf.timestamp);
-	vb2_set_plane_payload(vbuf, 0, cam->pix_format.sizeimage);
-	vb2_buffer_done(vbuf, VB2_BUF_STATE_DONE);
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
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 87314b7..03072e2 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -289,7 +289,7 @@ static void emmaprp_device_run(void *priv)
 {
 	struct emmaprp_ctx *ctx = priv;
 	struct emmaprp_q_data *s_q_data, *d_q_data;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct emmaprp_dev *pcdev = ctx->dev;
 	unsigned int s_width, s_height;
 	unsigned int d_width, d_height;
@@ -309,8 +309,8 @@ static void emmaprp_device_run(void *priv)
 	d_height = d_q_data->height;
 	d_size = d_width * d_height;
 
-	p_in = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	p_out = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	p_in = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	p_out = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 	if (!p_in || !p_out) {
 		v4l2_err(&pcdev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
@@ -351,7 +351,7 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 {
 	struct emmaprp_dev *pcdev = data;
 	struct emmaprp_ctx *curr_ctx;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
 	u32 irqst;
 
@@ -742,8 +742,10 @@ static int emmaprp_buf_prepare(struct vb2_buffer *vb)
 
 static void emmaprp_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct emmaprp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
 }
 
 static struct vb2_ops emmaprp_qops = {
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index d285af1..09d4c82 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -340,10 +340,11 @@ static int isp_video_queue_setup(struct vb2_queue *queue,
 	return 0;
 }
 
-static int isp_video_buffer_prepare(struct vb2_buffer *buf)
+static int isp_video_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
-	struct isp_buffer *buffer = to_isp_buffer(buf);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct isp_video_fh *vfh = vb2_get_drv_priv(vb->vb2_queue);
+	struct isp_buffer *buffer = to_isp_buffer(vbuf);
 	struct isp_video *video = vfh->video;
 	dma_addr_t addr;
 
@@ -356,14 +357,14 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
 	if (unlikely(video->error))
 		return -EIO;
 
-	addr = vb2_dma_contig_plane_dma_addr(buf, 0);
+	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	if (!IS_ALIGNED(addr, 32)) {
 		dev_dbg(video->isp->dev,
 			"Buffer address must be aligned to 32 bytes boundary.\n");
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buffer->vb, 0, vfh->format.fmt.pix.sizeimage);
+	vb2_set_plane_payload(vb, 0, vfh->format.fmt.pix.sizeimage);
 	buffer->dma = addr;
 
 	return 0;
@@ -378,10 +379,11 @@ static int isp_video_buffer_prepare(struct vb2_buffer *buf)
  * If the pipeline is busy, it will be restarted in the output module interrupt
  * handler.
  */
-static void isp_video_buffer_queue(struct vb2_buffer *buf)
+static void isp_video_buffer_queue(struct vb2_buffer *vb)
 {
-	struct isp_video_fh *vfh = vb2_get_drv_priv(buf->vb2_queue);
-	struct isp_buffer *buffer = to_isp_buffer(buf);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct isp_video_fh *vfh = vb2_get_drv_priv(vb->vb2_queue);
+	struct isp_buffer *buffer = to_isp_buffer(vbuf);
 	struct isp_video *video = vfh->video;
 	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
 	enum isp_pipeline_state state;
@@ -392,7 +394,7 @@ static void isp_video_buffer_queue(struct vb2_buffer *buf)
 	spin_lock_irqsave(&video->irqlock, flags);
 
 	if (unlikely(video->error)) {
-		vb2_buffer_done(&buffer->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buffer->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&video->irqlock, flags);
 		return;
 	}
@@ -491,7 +493,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 		state = VB2_BUF_STATE_DONE;
 	}
 
-	vb2_buffer_done(&buf->vb, state);
+	vb2_buffer_done(&buf->vb.vb2_buf, state);
 
 	spin_lock_irqsave(&video->irqlock, flags);
 
@@ -546,7 +548,7 @@ void omap3isp_video_cancel_stream(struct isp_video *video)
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
index bb01eaa..c8bf624 100644
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
@@ -239,7 +239,7 @@ static int camif_stop_capture(struct camif_vp *vp)
 	return camif_reinitialize(vp);
 }
 
-static int camif_prepare_addr(struct camif_vp *vp, struct vb2_buffer *vb,
+static int camif_prepare_addr(struct camif_vp *vp, struct vb2_v4l2_buffer *vb,
 			      struct camif_addr *paddr)
 {
 	struct camif_frame *frame = &vp->out_frame;
@@ -253,7 +253,7 @@ static int camif_prepare_addr(struct camif_vp *vp, struct vb2_buffer *vb,
 	pr_debug("colplanes: %d, pix_size: %u\n",
 		 vp->out_fmt->colplanes, pix_size);
 
-	paddr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	paddr->y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	switch (vp->out_fmt->colplanes) {
 	case 1:
@@ -346,7 +346,8 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
 			tv->tv_sec = ts.tv_sec;
 			tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 			vbuf->vb.v4l2_buf.sequence = vp->frame_sequence++;
-			vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&vbuf->vb.vb2_buf,
+					VB2_BUF_STATE_DONE);
 
 			/* Set up an empty buffer at the DMA engine */
 			vbuf = camif_pending_queue_pop(vp);
@@ -496,7 +497,8 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
-	struct camif_buffer *buf = container_of(vb, struct camif_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct camif_buffer *buf = container_of(vbuf, struct camif_buffer, vb);
 	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2_queue);
 	struct camif_dev *camif = vp->camif;
 	unsigned long flags;
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
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 81483da..9e50173 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -134,8 +134,10 @@ static int g2d_buf_prepare(struct vb2_buffer *vb)
 
 static void g2d_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct g2d_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static struct vb2_ops g2d_qops = {
@@ -496,7 +498,7 @@ static void device_run(void *prv)
 {
 	struct g2d_ctx *ctx = prv;
 	struct g2d_dev *dev = ctx->dev;
-	struct vb2_buffer *src, *dst;
+	struct vb2_v4l2_buffer *src, *dst;
 	unsigned long flags;
 	u32 cmd = 0;
 
@@ -511,10 +513,10 @@ static void device_run(void *prv)
 	spin_lock_irqsave(&dev->ctrl_lock, flags);
 
 	g2d_set_src_size(dev, &ctx->in);
-	g2d_set_src_addr(dev, vb2_dma_contig_plane_dma_addr(src, 0));
+	g2d_set_src_addr(dev, vb2_dma_contig_plane_dma_addr(&src->vb2_buf, 0));
 
 	g2d_set_dst_size(dev, &ctx->out);
-	g2d_set_dst_addr(dev, vb2_dma_contig_plane_dma_addr(dst, 0));
+	g2d_set_dst_addr(dev, vb2_dma_contig_plane_dma_addr(&dst->vb2_buf, 0));
 
 	g2d_set_rop4(dev, ctx->rop);
 	g2d_set_flip(dev, ctx->flip);
@@ -537,7 +539,7 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 {
 	struct g2d_dev *dev = prv;
 	struct g2d_ctx *ctx = dev->curr;
-	struct vb2_buffer *src, *dst;
+	struct vb2_v4l2_buffer *src, *dst;
 
 	g2d_clear_int(dev);
 	clk_disable(dev->gate);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 712d8c3..2300740 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1762,15 +1762,15 @@ static void s5p_jpeg_device_run(void *priv)
 {
 	struct s5p_jpeg_ctx *ctx = priv;
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long src_addr, dst_addr, flags;
 
 	spin_lock_irqsave(&ctx->jpeg->slock, flags);
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
-	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	src_addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 
 	s5p_jpeg_reset(jpeg->regs);
 	s5p_jpeg_poweron(jpeg->regs);
@@ -1843,8 +1843,9 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr = {};
+
 	u32 pix_size, padding_bytes = 0;
 
 	jpeg_addr.cb = 0;
@@ -1862,7 +1863,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 		vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	}
 
-	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (fmt->colplanes == 2) {
 		jpeg_addr.cb = jpeg_addr.y + pix_size - padding_bytes;
@@ -1880,7 +1881,7 @@ static void exynos4_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -1888,7 +1889,7 @@ static void exynos4_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 	else
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
-	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	exynos4_jpeg_set_stream_buf_address(jpeg->regs, jpeg_addr);
 }
 
@@ -1947,8 +1948,9 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
 	struct s5p_jpeg_fmt *fmt;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct s5p_jpeg_addr jpeg_addr = {};
+
 	u32 pix_size;
 
 	pix_size = ctx->cap_q.w * ctx->cap_q.h;
@@ -1961,7 +1963,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 		fmt = ctx->cap_q.fmt;
 	}
 
-	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr.y = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 
 	if (fmt->colplanes == 2) {
 		jpeg_addr.cb = jpeg_addr.y + pix_size;
@@ -1979,7 +1981,7 @@ static void exynos3250_jpeg_set_img_addr(struct s5p_jpeg_ctx *ctx)
 static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 {
 	struct s5p_jpeg *jpeg = ctx->jpeg;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned int jpeg_addr = 0;
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
@@ -1987,7 +1989,7 @@ static void exynos3250_jpeg_set_jpeg_addr(struct s5p_jpeg_ctx *ctx)
 	else
 		vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
-	jpeg_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	exynos3250_jpeg_jpgadr(jpeg->regs, jpeg_addr);
 }
 
@@ -2170,6 +2172,7 @@ static int s5p_jpeg_buf_prepare(struct vb2_buffer *vb)
 
 static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
 	if (ctx->mode == S5P_JPEG_DECODE &&
@@ -2193,7 +2196,7 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 		q_data->h = tmp.h;
 	}
 
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static int s5p_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
@@ -2264,7 +2267,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 {
 	struct s5p_jpeg *jpeg = dev_id;
 	struct s5p_jpeg_ctx *curr_ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long payload_size = 0;
 	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
 	bool enc_jpeg_too_large = false;
@@ -2306,7 +2309,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 
 	v4l2_m2m_buf_done(src_buf, state);
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		vb2_set_plane_payload(dst_buf, 0, payload_size);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
@@ -2321,7 +2324,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 {
 	unsigned int int_status;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	struct s5p_jpeg *jpeg = priv;
 	struct s5p_jpeg_ctx *curr_ctx;
 	unsigned long payload_size = 0;
@@ -2363,7 +2366,8 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 	if (jpeg->irq_ret == OK_ENC_OR_DEC) {
 		if (curr_ctx->mode == S5P_JPEG_ENCODE) {
 			payload_size = exynos4_jpeg_get_stream_size(jpeg->regs);
-			vb2_set_plane_payload(dst_vb, 0, payload_size);
+			vb2_set_plane_payload(&dst_vb->vb2_buf, 0,
+					      payload_size);
 		}
 		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
@@ -2383,7 +2387,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 {
 	struct s5p_jpeg *jpeg = dev_id;
 	struct s5p_jpeg_ctx *curr_ctx;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	unsigned long payload_size = 0;
 	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
 	bool interrupt_timeout = false;
@@ -2432,7 +2436,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 
 	v4l2_m2m_buf_done(src_buf, state);
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		vb2_set_plane_payload(dst_buf, 0, payload_size);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b3758b8..5baa069 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -200,8 +200,8 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 				     struct s5p_mfc_buf, list);
 		mfc_debug(2, "Cleaning up buffer: %d\n",
 					  dst_buf->b->v4l2_buf.index);
-		vb2_set_plane_payload(dst_buf->b, 0, 0);
-		vb2_set_plane_payload(dst_buf->b, 1, 0);
+		vb2_set_plane_payload(&dst_buf->b->vb2_buf, 0, 0);
+		vb2_set_plane_payload(&dst_buf->b->vb2_buf, 1, 0);
 		list_del(&dst_buf->list);
 		ctx->dst_queue_cnt--;
 		dst_buf->b->v4l2_buf.sequence = (ctx->sequence++);
@@ -214,7 +214,7 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 		dst_buf->b->v4l2_buf.flags |= V4L2_BUF_FLAG_LAST;
 
 		ctx->dec_dst_flag &= ~(1 << dst_buf->b->v4l2_buf.index);
-		vb2_buffer_done(dst_buf->b, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&dst_buf->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 }
 
@@ -235,7 +235,7 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 	   appropriate flags. */
 	src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
-		if (vb2_dma_contig_plane_dma_addr(dst_buf->b, 0) == dec_y_addr) {
+		if (vb2_dma_contig_plane_dma_addr(&dst_buf->b->vb2_buf, 0) == dec_y_addr) {
 			dst_buf->b->v4l2_buf.timecode =
 						src_buf->b->v4l2_buf.timecode;
 			dst_buf->b->v4l2_buf.timestamp =
@@ -296,7 +296,7 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 	 * check which videobuf does it correspond to */
 	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
 		/* Check if this is the buffer we're looking for */
-		if (vb2_dma_contig_plane_dma_addr(dst_buf->b, 0) == dspl_y_addr) {
+		if (vb2_dma_contig_plane_dma_addr(&dst_buf->b->vb2_buf, 0) == dspl_y_addr) {
 			list_del(&dst_buf->list);
 			ctx->dst_queue_cnt--;
 			dst_buf->b->v4l2_buf.sequence = ctx->sequence;
@@ -308,13 +308,15 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 			else
 				dst_buf->b->v4l2_buf.field =
 							V4L2_FIELD_INTERLACED;
-			vb2_set_plane_payload(dst_buf->b, 0, ctx->luma_size);
-			vb2_set_plane_payload(dst_buf->b, 1, ctx->chroma_size);
+			vb2_set_plane_payload(&dst_buf->b->vb2_buf, 0,
+					      ctx->luma_size);
+			vb2_set_plane_payload(&dst_buf->b->vb2_buf, 1,
+					      ctx->chroma_size);
 			clear_bit(dst_buf->b->v4l2_buf.index,
 							&ctx->dec_dst_flag);
 
-			vb2_buffer_done(dst_buf->b,
-				err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&dst_buf->b->vb2_buf,
+					err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 			break;
 		}
@@ -407,9 +409,11 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 			list_del(&src_buf->list);
 			ctx->src_queue_cnt--;
 			if (s5p_mfc_hw_call(dev->mfc_ops, err_dec, err) > 0)
-				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_ERROR);
+				vb2_buffer_done(&src_buf->b->vb2_buf,
+						VB2_BUF_STATE_ERROR);
 			else
-				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_DONE);
+				vb2_buffer_done(&src_buf->b->vb2_buf,
+						VB2_BUF_STATE_DONE);
 		}
 	}
 leave_handle_frame:
@@ -551,7 +555,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 					     struct s5p_mfc_buf, list);
 				list_del(&src_buf->list);
 				ctx->src_queue_cnt--;
-				vb2_buffer_done(src_buf->b,
+				vb2_buffer_done(&src_buf->b->vb2_buf,
 						VB2_BUF_STATE_DONE);
 			}
 			spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -592,8 +596,8 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
 									list);
 		list_del(&mb_entry->list);
 		ctx->dst_queue_cnt--;
-		vb2_set_plane_payload(mb_entry->b, 0, 0);
-		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, 0);
+		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 	spin_unlock(&dev->irqlock);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 10884a7..e8740fa 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -180,7 +180,7 @@ struct s5p_mfc_ctx;
  */
 struct s5p_mfc_buf {
 	struct list_head list;
-	struct vb2_buffer *b;
+	struct vb2_v4l2_buffer *b;
 	union {
 		struct {
 			size_t luma;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 2fd59e7..7d75d8e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -945,6 +945,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 
 static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	unsigned int i;
@@ -964,8 +965,8 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 			mfc_err("Plane buffer (CAPTURE) is too small\n");
 			return -EINVAL;
 		}
-		i = vb->v4l2_buf.index;
-		ctx->dst_bufs[i].b = vb;
+		i = vbuf->v4l2_buf.index;
+		ctx->dst_bufs[i].b = vbuf;
 		ctx->dst_bufs[i].cookie.raw.luma =
 					vb2_dma_contig_plane_dma_addr(vb, 0);
 		ctx->dst_bufs[i].cookie.raw.chroma =
@@ -982,8 +983,8 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 			return -EINVAL;
 		}
 
-		i = vb->v4l2_buf.index;
-		ctx->src_bufs[i].b = vb;
+		i = vbuf->v4l2_buf.index;
+		ctx->src_bufs[i].b = vbuf;
 		ctx->src_bufs[i].cookie.stream =
 					vb2_dma_contig_plane_dma_addr(vb, 0);
 		ctx->src_bufs_cnt++;
@@ -994,6 +995,7 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
+
 static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
@@ -1058,6 +1060,7 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 
 static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -1065,18 +1068,18 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	struct s5p_mfc_buf *mfc_buf;
 
 	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		mfc_buf = &ctx->src_bufs[vbuf->v4l2_buf.index];
 		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		spin_lock_irqsave(&dev->irqlock, flags);
 		list_add_tail(&mfc_buf->list, &ctx->src_queue);
 		ctx->src_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
+		mfc_buf = &ctx->dst_bufs[vbuf->v4l2_buf.index];
 		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		/* Mark destination as available for use by MFC */
 		spin_lock_irqsave(&dev->irqlock, flags);
-		set_bit(vb->v4l2_buf.index, &ctx->dec_dst_flag);
+		set_bit(vbuf->v4l2_buf.index, &ctx->dec_dst_flag);
 		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
 		ctx->dst_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 3fb87ed..e65249a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -773,8 +773,8 @@ static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -796,10 +796,10 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 					struct s5p_mfc_buf, list);
 			list_del(&dst_mb->list);
 			ctx->dst_queue_cnt--;
-			vb2_set_plane_payload(dst_mb->b, 0,
-				s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size,
-						dev));
-			vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
+			vb2_set_plane_payload(&dst_mb->b->vb2_buf, 0,
+					      s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev));
+			vb2_buffer_done(&dst_mb->b->vb2_buf,
+					VB2_BUF_STATE_DONE);
 		}
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
@@ -831,16 +831,16 @@ static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
-	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
+	src_y_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 0);
+	src_c_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 1);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_frame_buffer, ctx,
 							src_y_addr, src_c_addr);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_hw_call_void(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
 			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -869,26 +869,30 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		s5p_mfc_hw_call_void(dev->mfc_ops, get_enc_frame_buffer, ctx,
 				&enc_y_addr, &enc_c_addr);
 		list_for_each_entry(mb_entry, &ctx->src_queue, list) {
-			mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
-			mb_c_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 1);
+			mb_y_addr = vb2_dma_contig_plane_dma_addr(&mb_entry->b->vb2_buf,
+								  0);
+			mb_c_addr = vb2_dma_contig_plane_dma_addr(&mb_entry->b->vb2_buf,
+								  1);
 			if ((enc_y_addr == mb_y_addr) &&
 						(enc_c_addr == mb_c_addr)) {
 				list_del(&mb_entry->list);
 				ctx->src_queue_cnt--;
-				vb2_buffer_done(mb_entry->b,
-							VB2_BUF_STATE_DONE);
+				vb2_buffer_done(&mb_entry->b->vb2_buf,
+						VB2_BUF_STATE_DONE);
 				break;
 			}
 		}
 		list_for_each_entry(mb_entry, &ctx->ref_queue, list) {
-			mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
-			mb_c_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 1);
+			mb_y_addr = vb2_dma_contig_plane_dma_addr(&mb_entry->b->vb2_buf,
+								  0);
+			mb_c_addr = vb2_dma_contig_plane_dma_addr(&mb_entry->b->vb2_buf,
+								  1);
 			if ((enc_y_addr == mb_y_addr) &&
 						(enc_c_addr == mb_c_addr)) {
 				list_del(&mb_entry->list);
 				ctx->ref_queue_cnt--;
-				vb2_buffer_done(mb_entry->b,
-							VB2_BUF_STATE_DONE);
+				vb2_buffer_done(&mb_entry->b->vb2_buf,
+						VB2_BUF_STATE_DONE);
 				break;
 			}
 		}
@@ -921,8 +925,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 			mb_entry->b->v4l2_buf.flags |= V4L2_BUF_FLAG_BFRAME;
 			break;
 		}
-		vb2_set_plane_payload(mb_entry->b, 0, strm_size);
-		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, strm_size);
+		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
@@ -1791,6 +1795,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
 
 static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	int i;
 
 	if (!fmt)
@@ -1806,7 +1811,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 			return -EINVAL;
 		}
 		mfc_debug(2, "index: %d, plane[%d] cookie: %pad\n",
-			  vb->v4l2_buf.index, i, &dma);
+			  vbuf->v4l2_buf.index, i, &dma);
 	}
 	return 0;
 }
@@ -1868,6 +1873,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 
 static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	unsigned int i;
@@ -1877,8 +1883,8 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 		ret = check_vb_with_fmt(ctx->dst_fmt, vb);
 		if (ret < 0)
 			return ret;
-		i = vb->v4l2_buf.index;
-		ctx->dst_bufs[i].b = vb;
+		i = vbuf->v4l2_buf.index;
+		ctx->dst_bufs[i].b = vbuf;
 		ctx->dst_bufs[i].cookie.stream =
 					vb2_dma_contig_plane_dma_addr(vb, 0);
 		ctx->dst_bufs_cnt++;
@@ -1886,8 +1892,8 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 		ret = check_vb_with_fmt(ctx->src_fmt, vb);
 		if (ret < 0)
 			return ret;
-		i = vb->v4l2_buf.index;
-		ctx->src_bufs[i].b = vb;
+		i = vbuf->v4l2_buf.index;
+		ctx->src_bufs[i].b = vbuf;
 		ctx->src_bufs[i].cookie.raw.luma =
 					vb2_dma_contig_plane_dma_addr(vb, 0);
 		ctx->src_bufs[i].cookie.raw.chroma =
@@ -1999,6 +2005,7 @@ static void s5p_mfc_stop_streaming(struct vb2_queue *q)
 
 static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -2011,7 +2018,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 		return;
 	}
 	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
+		mfc_buf = &ctx->dst_bufs[vbuf->v4l2_buf.index];
 		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		/* Mark destination as available for use by MFC */
 		spin_lock_irqsave(&dev->irqlock, flags);
@@ -2019,7 +2026,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 		ctx->dst_queue_cnt++;
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		mfc_buf = &ctx->src_bufs[vbuf->v4l2_buf.index];
 		mfc_buf->flags &= ~MFC_BUF_FLAG_USED;
 		spin_lock_irqsave(&dev->irqlock, flags);
 		list_add_tail(&mfc_buf->list, &ctx->src_queue);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 9a923b1..13aff41 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1206,7 +1206,7 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	temp_vb->flags |= MFC_BUF_FLAG_USED;
 	s5p_mfc_set_dec_stream_buffer_v5(ctx,
-		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
+		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
 		ctx->consumed_stream, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1253,10 +1253,10 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 								dev->bank2);
 			ctx->state = MFCINST_FINISHING;
 		} else {
-			src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b,
-									0);
-			src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b,
-									1);
+			src_y_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf,
+								   0);
+			src_c_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf,
+								   1);
 			s5p_mfc_set_enc_frame_buffer_v5(ctx, src_y_addr,
 								src_c_addr);
 			if (src_mb->flags & MFC_BUF_FLAG_EOS)
@@ -1265,8 +1265,8 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	}
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_mb->flags |= MFC_BUF_FLAG_USED;
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1289,7 +1289,7 @@ static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_dec_desc_buffer(ctx);
 	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
 	s5p_mfc_set_dec_stream_buffer_v5(ctx,
-				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
+				vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
 				0, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1307,8 +1307,8 @@ static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_ref_buffer_v5(ctx);
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1342,7 +1342,7 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
 	s5p_mfc_set_dec_stream_buffer_v5(ctx,
-				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
+				vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
 				0, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1476,9 +1476,9 @@ static void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
 
 	while (!list_empty(lh)) {
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
-		for (i = 0; i < b->b->num_planes; i++)
-			vb2_set_plane_payload(b->b, i, 0);
-		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
+		for (i = 0; i < b->b->vb2_buf.num_planes; i++)
+			vb2_set_plane_payload(&b->b->vb2_buf, i, 0);
+		vb2_buffer_done(&b->b->vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
 	}
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 12497f5..5c7f35a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1560,9 +1560,9 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	temp_vb->flags |= MFC_BUF_FLAG_USED;
 	s5p_mfc_set_dec_stream_buffer_v6(ctx,
-		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
-			ctx->consumed_stream,
-			temp_vb->b->v4l2_planes[0].bytesused);
+		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0),
+		ctx->consumed_stream,
+		temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	dev->curr_ctx = ctx->num;
@@ -1604,8 +1604,8 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 
 	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	src_mb->flags |= MFC_BUF_FLAG_USED;
-	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
-	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
+	src_y_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 0);
+	src_c_addr = vb2_dma_contig_plane_dma_addr(&src_mb->b->vb2_buf, 1);
 
 	mfc_debug(2, "enc src y addr: 0x%08lx\n", src_y_addr);
 	mfc_debug(2, "enc src c addr: 0x%08lx\n", src_c_addr);
@@ -1614,8 +1614,8 @@ static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_mb->flags |= MFC_BUF_FLAG_USED;
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 
 	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
 
@@ -1639,8 +1639,8 @@ static inline void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
 	s5p_mfc_set_dec_stream_buffer_v6(ctx,
-		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), 0,
-			temp_vb->b->v4l2_planes[0].bytesused);
+		vb2_dma_contig_plane_dma_addr(&temp_vb->b->vb2_buf, 0), 0,
+		temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_init_decode_v6(ctx);
@@ -1657,8 +1657,8 @@ static inline void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 	spin_lock_irqsave(&dev->irqlock, flags);
 
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(&dst_mb->b->vb2_buf, 0);
+	dst_size = vb2_plane_size(&dst_mb->b->vb2_buf, 0);
 	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
@@ -1834,9 +1834,9 @@ static void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
 
 	while (!list_empty(lh)) {
 		b = list_entry(lh->next, struct s5p_mfc_buf, list);
-		for (i = 0; i < b->b->num_planes; i++)
-			vb2_set_plane_payload(b->b, i, 0);
-		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
+		for (i = 0; i < b->b->vb2_buf.num_planes; i++)
+			vb2_set_plane_payload(&b->b->vb2_buf, i, 0);
+		vb2_buffer_done(&b->b->vb2_buf, VB2_BUF_STATE_ERROR);
 		list_del(&b->list);
 	}
 }
diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index 855b723..be7ed5f 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -113,7 +113,7 @@ struct mxr_geometry {
 /** instance of a buffer */
 struct mxr_buffer {
 	/** common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	/** node for layer's lists */
 	struct list_head	list;
 };
diff --git a/drivers/media/platform/s5p-tv/mixer_grp_layer.c b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
index 74344c7..db3163b 100644
--- a/drivers/media/platform/s5p-tv/mixer_grp_layer.c
+++ b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
@@ -86,7 +86,7 @@ static void mxr_graph_buffer_set(struct mxr_layer *layer,
 	dma_addr_t addr = 0;
 
 	if (buf)
-		addr = vb2_dma_contig_plane_dma_addr(&buf->vb, 0);
+		addr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
 	mxr_reg_graph_buffer(layer->mdev, layer->idx, addr);
 }
 
diff --git a/drivers/media/platform/s5p-tv/mixer_reg.c b/drivers/media/platform/s5p-tv/mixer_reg.c
index b713403..15be562 100644
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
index 751f3b6..dba92b5 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -914,7 +914,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 
 static void buf_queue(struct vb2_buffer *vb)
 {
-	struct mxr_buffer *buffer = container_of(vb, struct mxr_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct mxr_buffer *buffer = container_of(vbuf, struct mxr_buffer, vb);
 	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
 	struct mxr_device *mdev = layer->mdev;
 	unsigned long flags;
@@ -963,11 +964,13 @@ static void mxr_watchdog(unsigned long arg)
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
@@ -991,7 +994,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* set all buffer to be done */
 	list_for_each_entry_safe(buf, buf_tmp, &layer->enq_list, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&layer->enq_slock, flags);
diff --git a/drivers/media/platform/s5p-tv/mixer_vp_layer.c b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
index c9388c4..459cd2b 100644
--- a/drivers/media/platform/s5p-tv/mixer_vp_layer.c
+++ b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
@@ -97,9 +97,10 @@ static void mxr_vp_buffer_set(struct mxr_layer *layer,
 		mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
 		return;
 	}
-	luma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb, 0);
+	luma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
 	if (layer->fmt->num_subframes == 2) {
-		chroma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb, 1);
+		chroma_addr[0] = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf,
+							       1);
 	} else {
 		/* FIXME: mxr_get_plane_size compute integer division,
 		 * which is slow and should not be performed in interrupt */
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 7bb249c..a0910d9 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -243,10 +243,10 @@ static void sh_veu_job_abort(void *priv)
 }
 
 static void sh_veu_process(struct sh_veu_dev *veu,
-			   struct vb2_buffer *src_buf,
-			   struct vb2_buffer *dst_buf)
+			   struct vb2_v4l2_buffer *src_buf,
+			   struct vb2_v4l2_buffer *dst_buf)
 {
-	dma_addr_t addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	dma_addr_t addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 
 	sh_veu_reg_write(veu, VEU_DAYR, addr + veu->vfmt_out.offset_y);
 	sh_veu_reg_write(veu, VEU_DACR, veu->vfmt_out.offset_c ?
@@ -255,7 +255,7 @@ static void sh_veu_process(struct sh_veu_dev *veu,
 		(unsigned long)addr,
 		veu->vfmt_out.offset_y, veu->vfmt_out.offset_c);
 
-	addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
 	sh_veu_reg_write(veu, VEU_SAYR, addr + veu->vfmt_in.offset_y);
 	sh_veu_reg_write(veu, VEU_SACR, veu->vfmt_in.offset_c ?
 			 addr + veu->vfmt_in.offset_c : 0);
@@ -277,7 +277,7 @@ static void sh_veu_process(struct sh_veu_dev *veu,
 static void sh_veu_device_run(void *priv)
 {
 	struct sh_veu_dev *veu = priv;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 
 	src_buf = v4l2_m2m_next_src_buf(veu->m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(veu->m2m_ctx);
@@ -931,9 +931,11 @@ static int sh_veu_buf_prepare(struct vb2_buffer *vb)
 
 static void sh_veu_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct sh_veu_dev *veu = vb2_get_drv_priv(vb->vb2_queue);
-	dev_dbg(veu->dev, "%s(%d)\n", __func__, vb->v4l2_buf.type);
-	v4l2_m2m_buf_queue(veu->m2m_ctx, vb);
+
+	dev_dbg(veu->dev, "%s(%d)\n", __func__, vbuf->v4l2_buf.type);
+	v4l2_m2m_buf_queue(veu->m2m_ctx, vbuf);
 }
 
 static const struct vb2_ops sh_veu_qops = {
@@ -1082,8 +1084,8 @@ static irqreturn_t sh_veu_bh(int irq, void *dev_id)
 static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 {
 	struct sh_veu_dev *veu = dev_id;
-	struct vb2_buffer *dst;
-	struct vb2_buffer *src;
+	struct vb2_v4l2_buffer *dst;
+	struct vb2_v4l2_buffer *src;
 	u32 status = sh_veu_reg_read(veu, VEU_EVTR);
 
 	/* bundle read mode not used */
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 9070172..621a1a7 100644
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
@@ -151,13 +151,13 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 {
 	if (isi->active) {
-		struct vb2_buffer *vb = &isi->active->vb;
+		struct vb2_v4l2_buffer *vb = &isi->active->vb;
 		struct frame_buffer *buf = isi->active;
 
 		list_del_init(&buf->list);
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.sequence = isi->sequence++;
-		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (list_empty(&isi->video_buffer_list)) {
@@ -267,7 +267,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int buffer_init(struct vb2_buffer *vb)
 {
-	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 
 	buf->p_dma_desc = NULL;
 	INIT_LIST_HEAD(&buf->list);
@@ -277,8 +278,9 @@ static int buffer_init(struct vb2_buffer *vb)
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
+	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	unsigned long size;
@@ -292,7 +294,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
 
 	if (!buf->p_dma_desc) {
 		if (list_empty(&isi->dma_desc_head)) {
@@ -319,10 +321,11 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_cleanup(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
-	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
+	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 
 	/* This descriptor is available now and we add to head list */
 	if (buf->p_dma_desc)
@@ -360,10 +363,11 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
-	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
+	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(&isi->lock, flags);
@@ -422,7 +426,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* Release all active buffers */
 	list_for_each_entry_safe(buf, node, &isi->video_buffer_list, list) {
 		list_del_init(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irq(&isi->lock);
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 6e41335..b250706 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -225,7 +225,7 @@ struct mx2_buf_internal {
 /* buffer for one video frame */
 struct mx2_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer		vb;
+	struct vb2_v4l2_buffer		vb;
 	struct mx2_buf_internal		internal;
 };
 
@@ -530,11 +530,12 @@ out:
 
 static void mx2_videobuf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
-	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
+	struct mx2_buffer *buf = container_of(vbuf, struct mx2_buffer, vb);
 	unsigned long flags;
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
@@ -650,7 +651,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	struct mx2_buffer *buf;
 	unsigned long phys;
 	int bytesperline;
@@ -666,7 +667,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 	buf->internal.bufnum = 0;
 	vb = &buf->vb;
 
-	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
+	phys = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
 	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
@@ -675,7 +676,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 	buf->internal.bufnum = 1;
 	vb = &buf->vb;
 
-	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
+	phys = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	mx27_update_emma_buf(pcdev, phys, buf->internal.bufnum);
 	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
@@ -1306,7 +1307,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 #endif
 	struct mx2_buf_internal *ibuf;
 	struct mx2_buffer *buf;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned long phys;
 
 	ibuf = list_first_entry(&pcdev->active_bufs, struct mx2_buf_internal,
@@ -1325,7 +1326,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 
 		vb = &buf->vb;
 #ifdef DEBUG
-		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
+		phys = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 		if (prp->cfg.channel == 1) {
 			if (readl(pcdev->base_emma + PRP_DEST_RGB1_PTR +
 				4 * bufnum) != phys) {
@@ -1343,16 +1344,16 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		}
 #endif
 		dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
-				vb2_plane_vaddr(vb, 0),
-				vb2_get_plane_payload(vb, 0));
+				vb2_plane_vaddr(&vb->vb2_buf, 0),
+				vb2_get_plane_payload(&vb->vb2_buf, 0));
 
 		list_del_init(&buf->internal.queue);
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.sequence = pcdev->frame_count;
 		if (err)
-			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_ERROR);
 		else
-			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	pcdev->frame_count++;
@@ -1382,7 +1383,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 
 	vb = &buf->vb;
 
-	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
+	phys = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	mx27_update_emma_buf(pcdev, phys, bufnum);
 }
 
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index ace41f5..6c566b8 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -63,7 +63,7 @@
 
 struct mx3_camera_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer			vb;
+	struct vb2_v4l2_buffer			vb;
 	struct list_head			queue;
 
 	/* One descriptot per scatterlist (per frame) */
@@ -133,7 +133,7 @@ static void csi_reg_write(struct mx3_camera_dev *mx3, u32 value, off_t reg)
 	__raw_writel(value, mx3->base + reg);
 }
 
-static struct mx3_camera_buffer *to_mx3_vb(struct vb2_buffer *vb)
+static struct mx3_camera_buffer *to_mx3_vb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct mx3_camera_buffer, vb);
 }
@@ -151,14 +151,14 @@ static void mx3_cam_dma_done(void *arg)
 
 	spin_lock(&mx3_cam->lock);
 	if (mx3_cam->active) {
-		struct vb2_buffer *vb = &mx3_cam->active->vb;
+		struct vb2_v4l2_buffer *vb = &mx3_cam->active->vb;
 		struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 
 		list_del_init(&buf->queue);
 		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.field = mx3_cam->field;
 		vb->v4l2_buf.sequence = mx3_cam->sequence++;
-		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
 	if (list_empty(&mx3_cam->capture)) {
@@ -257,10 +257,11 @@ static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
 
 static void mx3_videobuf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+	struct mx3_camera_buffer *buf = to_mx3_vb(vbuf);
 	struct scatterlist *sg = &buf->sg;
 	struct dma_async_tx_descriptor *txd;
 	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
@@ -357,10 +358,11 @@ error:
 
 static void mx3_videobuf_release(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+	struct mx3_camera_buffer *buf = to_mx3_vb(vbuf);
 	struct dma_async_tx_descriptor *txd = buf->txd;
 	unsigned long flags;
 
@@ -390,10 +392,11 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
 
 static int mx3_videobuf_init(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
+	struct mx3_camera_buffer *buf = to_mx3_vb(vbuf);
 
 	if (!buf->txd) {
 		/* This is for locking debugging only */
@@ -424,7 +427,7 @@ static void mx3_stop_streaming(struct vb2_queue *q)
 
 	list_for_each_entry_safe(buf, tmp, &mx3_cam->capture, queue) {
 		list_del_init(&buf->queue);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index db7700b..afa887e 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -477,7 +477,7 @@ struct rcar_vin_priv {
 	struct soc_camera_host		ici;
 	struct list_head		capture;
 #define MAX_BUFFER_NUM			3
-	struct vb2_buffer		*queue_buf[MAX_BUFFER_NUM];
+	struct vb2_v4l2_buffer		*queue_buf[MAX_BUFFER_NUM];
 	struct vb2_alloc_ctx		*alloc_ctx;
 	enum v4l2_field			field;
 	unsigned int			pdata_flags;
@@ -491,7 +491,7 @@ struct rcar_vin_priv {
 #define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM)
 
 struct rcar_vin_buffer {
-	struct vb2_buffer		vb;
+	struct vb2_v4l2_buffer		vb;
 	struct list_head		list;
 };
 
@@ -738,7 +738,7 @@ static int rcar_vin_hw_ready(struct rcar_vin_priv *priv)
 /* Moves a buffer from the queue to the HW slots */
 static int rcar_vin_fill_hw_slot(struct rcar_vin_priv *priv)
 {
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	dma_addr_t phys_addr_top;
 	int slot;
 
@@ -753,7 +753,7 @@ static int rcar_vin_fill_hw_slot(struct rcar_vin_priv *priv)
 	vb = &list_entry(priv->capture.next, struct rcar_vin_buffer, list)->vb;
 	list_del_init(to_buf_list(vb));
 	priv->queue_buf[slot] = vb;
-	phys_addr_top = vb2_dma_contig_plane_dma_addr(vb, 0);
+	phys_addr_top = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, 0);
 	iowrite32(phys_addr_top, priv->base + VNMB_REG(slot));
 
 	return 1;
@@ -761,6 +761,7 @@ static int rcar_vin_fill_hw_slot(struct rcar_vin_priv *priv)
 
 static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
@@ -770,7 +771,7 @@ static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
 
 	if (vb2_plane_size(vb, 0) < size) {
 		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
-			vb->v4l2_buf.index, vb2_plane_size(vb, 0), size);
+			vbuf->v4l2_buf.index, vb2_plane_size(vb, 0), size);
 		goto error;
 	}
 
@@ -781,14 +782,14 @@ static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
 
 	spin_lock_irq(&priv->lock);
 
-	list_add_tail(to_buf_list(vb), &priv->capture);
+	list_add_tail(to_buf_list(vbuf), &priv->capture);
 	rcar_vin_fill_hw_slot(priv);
 
 	/* If we weren't running, and have enough buffers, start capturing! */
 	if (priv->state != RUNNING && rcar_vin_hw_ready(priv)) {
 		if (rcar_vin_setup(priv)) {
 			/* Submit error */
-			list_del_init(to_buf_list(vb));
+			list_del_init(to_buf_list(vbuf));
 			spin_unlock_irq(&priv->lock);
 			goto error;
 		}
@@ -844,7 +845,7 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 
 	for (i = 0; i < MAX_BUFFER_NUM; i++) {
 		if (priv->queue_buf[i]) {
-			vb2_buffer_done(priv->queue_buf[i],
+			vb2_buffer_done(&priv->queue_buf[i]->vb2_buf,
 					VB2_BUF_STATE_ERROR);
 			priv->queue_buf[i] = NULL;
 		}
@@ -900,7 +901,8 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
 		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
 		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
 		v4l2_get_timestamp(&priv->queue_buf[slot]->v4l2_buf.timestamp);
-		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&priv->queue_buf[slot]->vb2_buf,
+				VB2_BUF_STATE_DONE);
 		priv->queue_buf[slot] = NULL;
 
 		if (priv->state != STOPPING)
@@ -954,7 +956,7 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int i;
 
 	/* disable capture, disable interrupts */
@@ -971,7 +973,7 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 		vb = priv->queue_buf[i];
 		if (vb) {
 			list_del_init(to_buf_list(vb));
-			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_ERROR);
 		}
 	}
 	spin_unlock_irq(&priv->lock);
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index c5c6c4e..b46c3e3 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -93,7 +93,7 @@
 
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
-	struct vb2_buffer vb; /* v4l buffer must be first */
+	struct vb2_v4l2_buffer vb; /* v4l buffer must be first */
 	struct list_head queue;
 };
 
@@ -112,7 +112,7 @@ struct sh_mobile_ceu_dev {
 
 	spinlock_t lock;		/* Protects video buffer lists */
 	struct list_head capture;
-	struct vb2_buffer *active;
+	struct vb2_v4l2_buffer *active;
 	struct vb2_alloc_ctx *alloc_ctx;
 
 	struct sh_mobile_ceu_info *pdata;
@@ -152,7 +152,7 @@ struct sh_mobile_ceu_cam {
 	u32 code;
 };
 
-static struct sh_mobile_ceu_buffer *to_ceu_vb(struct vb2_buffer *vb)
+static struct sh_mobile_ceu_buffer *to_ceu_vb(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct sh_mobile_ceu_buffer, vb);
 }
@@ -334,7 +334,8 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		bottom2	= CDBCR;
 	}
 
-	phys_addr_top = vb2_dma_contig_plane_dma_addr(pcdev->active, 0);
+	phys_addr_top = vb2_dma_contig_plane_dma_addr(&pcdev->active->vb2_buf,
+						      0);
 
 	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV12:
@@ -369,7 +370,8 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 
 static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 {
-	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vbuf);
 
 	/* Added list head initialization on alloc */
 	WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
@@ -379,10 +381,11 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 
 static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vbuf);
 	unsigned long size;
 
 	size = icd->sizeimage;
@@ -429,14 +432,15 @@ error:
 
 static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vbuf);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 
 	spin_lock_irq(&pcdev->lock);
 
-	if (pcdev->active == vb) {
+	if (pcdev->active == vbuf) {
 		/* disable capture (release DMA buffer), reset */
 		ceu_write(pcdev, CAPSR, 1 << 16);
 		pcdev->active = NULL;
@@ -504,7 +508,7 @@ static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
 static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 {
 	struct sh_mobile_ceu_dev *pcdev = data;
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	int ret;
 
 	spin_lock(&pcdev->lock);
@@ -528,7 +532,8 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 		vb->v4l2_buf.field = pcdev->field;
 		vb->v4l2_buf.sequence = pcdev->sequence++;
 	}
-	vb2_buffer_done(vb, ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb->vb2_buf,
+			ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 out:
 	spin_unlock(&pcdev->lock);
@@ -633,7 +638,7 @@ static void sh_mobile_ceu_clock_stop(struct soc_camera_host *ici)
 	spin_lock_irq(&pcdev->lock);
 	if (pcdev->active) {
 		list_del_init(&to_ceu_vb(pcdev->active)->queue);
-		vb2_buffer_done(pcdev->active, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&pcdev->active->vb2_buf, VB2_BUF_STATE_ERROR);
 		pcdev->active = NULL;
 	}
 	spin_unlock_irq(&pcdev->lock);
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index d82c2f2..19fea47 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -384,8 +384,8 @@ struct vpe_ctx {
 	unsigned int		bufs_completed;		/* bufs done in this batch */
 
 	struct vpe_q_data	q_data[2];		/* src & dst queue data */
-	struct vb2_buffer	*src_vbs[VPE_MAX_SRC_BUFS];
-	struct vb2_buffer	*dst_vb;
+	struct vb2_v4l2_buffer	*src_vbs[VPE_MAX_SRC_BUFS];
+	struct vb2_v4l2_buffer	*dst_vb;
 
 	dma_addr_t		mv_buf_dma[2];		/* dma addrs of motion vector in/out bufs */
 	void			*mv_buf[2];		/* virtual addrs of motion vector bufs */
@@ -988,7 +988,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 {
 	struct vpe_q_data *q_data = &ctx->q_data[Q_DATA_DST];
 	const struct vpe_port_data *p_data = &port_data[port];
-	struct vb2_buffer *vb = ctx->dst_vb;
+	struct vb2_v4l2_buffer *vb = ctx->dst_vb;
 	struct vpe_fmt *fmt = q_data->fmt;
 	const struct vpdma_data_format *vpdma_fmt;
 	int mv_buf_selector = !ctx->src_mv_buf_selector;
@@ -1003,7 +1003,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 		int plane = fmt->coplanar ? p_data->vb_part : 0;
 
 		vpdma_fmt = fmt->vpdma_fmt[plane];
-		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+		dma_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, plane);
 		if (!dma_addr) {
 			vpe_err(ctx->dev,
 				"acquiring output buffer(%d) dma_addr failed\n",
@@ -1025,7 +1025,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 {
 	struct vpe_q_data *q_data = &ctx->q_data[Q_DATA_SRC];
 	const struct vpe_port_data *p_data = &port_data[port];
-	struct vb2_buffer *vb = ctx->src_vbs[p_data->vb_index];
+	struct vb2_v4l2_buffer *vb = ctx->src_vbs[p_data->vb_index];
 	struct vpe_fmt *fmt = q_data->fmt;
 	const struct vpdma_data_format *vpdma_fmt;
 	int mv_buf_selector = ctx->src_mv_buf_selector;
@@ -1043,7 +1043,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 
 		vpdma_fmt = fmt->vpdma_fmt[plane];
 
-		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+		dma_addr = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, plane);
 		if (!dma_addr) {
 			vpe_err(ctx->dev,
 				"acquiring input buffer(%d) dma_addr failed\n",
@@ -1222,7 +1222,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	struct vpe_dev *dev = (struct vpe_dev *)data;
 	struct vpe_ctx *ctx;
 	struct vpe_q_data *d_q_data;
-	struct vb2_buffer *s_vb, *d_vb;
+	struct vb2_v4l2_buffer *s_vb, *d_vb;
 	struct v4l2_buffer *s_buf, *d_buf;
 	unsigned long flags;
 	u32 irqst0, irqst1;
@@ -1825,6 +1825,7 @@ static int vpe_queue_setup(struct vb2_queue *vq,
 
 static int vpe_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpe_q_data *q_data;
 	int i, num_planes;
@@ -1836,10 +1837,10 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 
 	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (!(q_data->flags & Q_DATA_INTERLACED)) {
-			vb->v4l2_buf.field = V4L2_FIELD_NONE;
+			vbuf->v4l2_buf.field = V4L2_FIELD_NONE;
 		} else {
-			if (vb->v4l2_buf.field != V4L2_FIELD_TOP &&
-					vb->v4l2_buf.field != V4L2_FIELD_BOTTOM)
+			if (vbuf->v4l2_buf.field != V4L2_FIELD_TOP &&
+					vbuf->v4l2_buf.field != V4L2_FIELD_BOTTOM)
 				return -EINVAL;
 		}
 	}
@@ -1862,9 +1863,10 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 
 static void vpe_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 295fde5..267525a 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -197,8 +197,8 @@ static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
 
 
 static int device_process(struct vim2m_ctx *ctx,
-			  struct vb2_buffer *in_vb,
-			  struct vb2_buffer *out_vb)
+			  struct vb2_v4l2_buffer *in_vb,
+			  struct vb2_v4l2_buffer *out_vb)
 {
 	struct vim2m_dev *dev = ctx->dev;
 	struct vim2m_q_data *q_data;
@@ -213,15 +213,15 @@ static int device_process(struct vim2m_ctx *ctx,
 	height	= q_data->height;
 	bytesperline	= (q_data->width * q_data->fmt->depth) >> 3;
 
-	p_in = vb2_plane_vaddr(in_vb, 0);
-	p_out = vb2_plane_vaddr(out_vb, 0);
+	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
+	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
 	if (!p_in || !p_out) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
 		return -EFAULT;
 	}
 
-	if (vb2_plane_size(in_vb, 0) > vb2_plane_size(out_vb, 0)) {
+	if (vb2_plane_size(&in_vb->vb2_buf, 0) > vb2_plane_size(&out_vb->vb2_buf, 0)) {
 		v4l2_err(&dev->v4l2_dev, "Output buffer is too small\n");
 		return -EINVAL;
 	}
@@ -374,7 +374,7 @@ static void device_run(void *priv)
 {
 	struct vim2m_ctx *ctx = priv;
 	struct vim2m_dev *dev = ctx->dev;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -389,7 +389,7 @@ static void device_isr(unsigned long priv)
 {
 	struct vim2m_dev *vim2m_dev = (struct vim2m_dev *)priv;
 	struct vim2m_ctx *curr_ctx;
-	struct vb2_buffer *src_vb, *dst_vb;
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
 
 	curr_ctx = v4l2_m2m_get_curr_priv(vim2m_dev->m2m_dev);
@@ -747,6 +747,7 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 
 static int vim2m_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct vim2m_q_data *q_data;
 
@@ -754,9 +755,9 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
 	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
-		if (vb->v4l2_buf.field == V4L2_FIELD_ANY)
-			vb->v4l2_buf.field = V4L2_FIELD_NONE;
-		if (vb->v4l2_buf.field != V4L2_FIELD_NONE) {
+		if (vbuf->v4l2_buf.field == V4L2_FIELD_ANY)
+			vbuf->v4l2_buf.field = V4L2_FIELD_NONE;
+		if (vbuf->v4l2_buf.field != V4L2_FIELD_NONE) {
 			dprintk(ctx->dev, "%s field isn't supported\n",
 					__func__);
 			return -EINVAL;
@@ -776,9 +777,10 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 
 static void vim2m_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
-	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
 static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
@@ -793,7 +795,7 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
 static void vim2m_stop_streaming(struct vb2_queue *q)
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
-	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vb;
 	unsigned long flags;
 
 	for (;;) {
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 5f1b1da..ddd84dd 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -93,7 +93,7 @@ extern struct vivid_fmt vivid_formats[];
 /* buffer for one video frame */
 struct vivid_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 };
 
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 1727f54..b472043 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -236,8 +236,8 @@ static void *plane_vaddr(struct tpg_data *tpg, struct vivid_buffer *buf,
 	void *vbuf;
 
 	if (p == 0 || tpg_g_buffers(tpg) > 1)
-		return vb2_plane_vaddr(&buf->vb, p);
-	vbuf = vb2_plane_vaddr(&buf->vb, 0);
+		return vb2_plane_vaddr(&buf->vb.vb2_buf, p);
+	vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	for (i = 0; i < p; i++)
 		vbuf += bpl[i] * h / tpg->vdownsampling[i];
 	return vbuf;
@@ -600,7 +600,7 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
 	struct tpg_data *tpg = &dev->tpg;
 	unsigned pixsize = tpg_g_twopixelsize(tpg, 0) / 2;
 	void *vbase = dev->fb_vbase_cap;
-	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	void *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	unsigned img_width = dev->compose_cap.width;
 	unsigned img_height = dev->compose_cap.height;
 	unsigned stride = tpg->bytesperline[0];
@@ -706,8 +706,8 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 				dev->fb_cap.fmt.pixelformat == dev->fmt_cap->fourcc)
 			vivid_overlay(dev, vid_cap_buf);
 
-		vb2_buffer_done(&vid_cap_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vid_cap_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_cap buffer %d done\n",
 				vid_cap_buf->vb.v4l2_buf.index);
 	}
@@ -717,8 +717,8 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 			vivid_sliced_vbi_cap_process(dev, vbi_cap_buf);
 		else
 			vivid_raw_vbi_cap_process(dev, vbi_cap_buf);
-		vb2_buffer_done(&vbi_cap_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vbi_cap_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_cap %d done\n",
 				vbi_cap_buf->vb.v4l2_buf.index);
 	}
@@ -884,7 +884,8 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_cap buffer %d done\n",
 				buf->vb.v4l2_buf.index);
 		}
@@ -897,7 +898,8 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_cap_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_cap buffer %d done\n",
 				buf->vb.v4l2_buf.index);
 		}
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index d9f36cc..cb436f4 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -97,8 +97,8 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 		}
 		v4l2_get_timestamp(&vid_out_buf->vb.v4l2_buf.timestamp);
 		vid_out_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&vid_out_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vid_out_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_out buffer %d done\n",
 			vid_out_buf->vb.v4l2_buf.index);
 	}
@@ -110,8 +110,8 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 		vbi_out_buf->vb.v4l2_buf.sequence = dev->vbi_out_seq_count;
 		v4l2_get_timestamp(&vbi_out_buf->vb.v4l2_buf.timestamp);
 		vbi_out_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&vbi_out_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&vbi_out_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_out buffer %d done\n",
 			vbi_out_buf->vb.v4l2_buf.index);
 	}
@@ -274,7 +274,8 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vid_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vid_out buffer %d done\n",
 				buf->vb.v4l2_buf.index);
 		}
@@ -287,7 +288,8 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			buf = list_entry(dev->vbi_out_active.next,
 					 struct vivid_buffer, list);
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_ERROR);
 			dprintk(dev, 2, "vbi_out buffer %d done\n",
 				buf->vb.v4l2_buf.index);
 		}
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index d2f2188..2b46175 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -118,8 +118,8 @@ static void vivid_thread_sdr_cap_tick(struct vivid_dev *dev)
 		vivid_sdr_cap_process(dev, sdr_cap_buf);
 		v4l2_get_timestamp(&sdr_cap_buf->vb.v4l2_buf.timestamp);
 		sdr_cap_buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
-		vb2_buffer_done(&sdr_cap_buf->vb, dev->dqbuf_error ?
-				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&sdr_cap_buf->vb.vb2_buf,
+				dev->dqbuf_error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dev->dqbuf_error = false;
 	}
 }
@@ -247,8 +247,9 @@ static int sdr_cap_buf_prepare(struct vb2_buffer *vb)
 
 static void sdr_cap_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+	struct vivid_buffer *buf = container_of(vbuf, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
 
@@ -282,7 +283,8 @@ static int sdr_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->sdr_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
@@ -301,7 +303,7 @@ static void sdr_cap_stop_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(dev->sdr_cap_active.next, struct vivid_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	/* shutdown control thread */
@@ -491,9 +493,9 @@ int vidioc_try_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f)
 
 void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
-	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	u8 *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	unsigned long i;
-	unsigned long plane_size = vb2_plane_size(&buf->vb, 0);
+	unsigned long plane_size = vb2_plane_size(&buf->vb.vb2_buf, 0);
 	s32 src_phase_step;
 	s32 mod_phase_step;
 	s32 fixp_i;
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index ef81b01..0ea990b 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -94,7 +94,7 @@ static void vivid_g_fmt_vbi_cap(struct vivid_dev *dev, struct v4l2_vbi_format *v
 void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
 	struct v4l2_vbi_format vbi;
-	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	u8 *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 
 	vivid_g_fmt_vbi_cap(dev, &vbi);
 	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
@@ -103,7 +103,7 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 
 	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
 
-	memset(vbuf, 0x10, vb2_plane_size(&buf->vb, 0));
+	memset(vbuf, 0x10, vb2_plane_size(&buf->vb.vb2_buf, 0));
 
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
 		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
@@ -115,7 +115,8 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 
 void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
-	struct v4l2_sliced_vbi_data *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	struct v4l2_sliced_vbi_data *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf,
+							    0);
 
 	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
@@ -123,7 +124,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *bu
 
 	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
 
-	memset(vbuf, 0, vb2_plane_size(&buf->vb, 0));
+	memset(vbuf, 0, vb2_plane_size(&buf->vb.vb2_buf, 0));
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode)) {
 		unsigned i;
 
@@ -187,8 +188,9 @@ static int vbi_cap_buf_prepare(struct vb2_buffer *vb)
 
 static void vbi_cap_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+	struct vivid_buffer *buf = container_of(vbuf, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
 
@@ -215,7 +217,8 @@ static int vbi_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 4e4c70e..65097c6 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -79,8 +79,9 @@ static int vbi_out_buf_prepare(struct vb2_buffer *vb)
 
 static void vbi_out_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+	struct vivid_buffer *buf = container_of(vbuf, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
 
@@ -107,7 +108,8 @@ static int vbi_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vbi_out_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
@@ -219,8 +221,9 @@ int vidioc_s_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format
 
 void vivid_sliced_vbi_out_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
-	struct v4l2_sliced_vbi_data *vbi = vb2_plane_vaddr(&buf->vb, 0);
-	unsigned elems = vb2_get_plane_payload(&buf->vb, 0) / sizeof(*vbi);
+	struct v4l2_sliced_vbi_data *vbi = vb2_plane_vaddr(&buf->vb.vb2_buf,
+							   0);
+	unsigned elems = vb2_get_plane_payload(&buf->vb.vb2_buf, 0) / sizeof(*vbi);
 
 	dev->vbi_out_have_cc[0] = false;
 	dev->vbi_out_have_cc[1] = false;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index ed0b878..1828a27 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -169,6 +169,7 @@ static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 
 static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size;
 	unsigned buffers = tpg_g_buffers(&dev->tpg);
@@ -198,7 +199,7 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 		}
 
 		vb2_set_plane_payload(vb, p, size);
-		vb->v4l2_planes[p].data_offset = dev->fmt_cap->data_offset[p];
+		vbuf->v4l2_planes[p].data_offset = dev->fmt_cap->data_offset[p];
 	}
 
 	return 0;
@@ -206,10 +207,11 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 
 static void vid_cap_buf_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct v4l2_timecode *tc = &vb->v4l2_buf.timecode;
+	struct v4l2_timecode *tc = &vbuf->v4l2_buf.timecode;
 	unsigned fps = 25;
-	unsigned seq = vb->v4l2_buf.sequence;
+	unsigned seq = vbuf->v4l2_buf.sequence;
 
 	if (!vivid_is_sdtv_cap(dev))
 		return;
@@ -218,7 +220,7 @@ static void vid_cap_buf_finish(struct vb2_buffer *vb)
 	 * Set the timecode. Rarely used, so it is interesting to
 	 * test this.
 	 */
-	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_TIMECODE;
+	vbuf->v4l2_buf.flags |= V4L2_BUF_FLAG_TIMECODE;
 	if (dev->std_cap & V4L2_STD_525_60)
 		fps = 30;
 	tc->type = (fps == 30) ? V4L2_TC_TYPE_30FPS : V4L2_TC_TYPE_25FPS;
@@ -231,8 +233,9 @@ static void vid_cap_buf_finish(struct vb2_buffer *vb)
 
 static void vid_cap_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+	struct vivid_buffer *buf = container_of(vbuf, struct vivid_buffer, vb);
 
 	dprintk(dev, 1, "%s\n", __func__);
 
@@ -268,7 +271,8 @@ static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_cap_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 0862c1f..de7a076 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -109,6 +109,7 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 
 static int vid_out_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size;
 	unsigned planes;
@@ -131,14 +132,14 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 	}
 
 	if (dev->field_out != V4L2_FIELD_ALTERNATE)
-		vb->v4l2_buf.field = dev->field_out;
-	else if (vb->v4l2_buf.field != V4L2_FIELD_TOP &&
-		 vb->v4l2_buf.field != V4L2_FIELD_BOTTOM)
+		vbuf->v4l2_buf.field = dev->field_out;
+	else if (vbuf->v4l2_buf.field != V4L2_FIELD_TOP &&
+		 vbuf->v4l2_buf.field != V4L2_FIELD_BOTTOM)
 		return -EINVAL;
 
 	for (p = 0; p < planes; p++) {
 		size = dev->bytesperline_out[p] * dev->fmt_out_rect.height +
-			vb->v4l2_planes[p].data_offset;
+			vbuf->v4l2_planes[p].data_offset;
 
 		if (vb2_get_plane_payload(vb, p) < size) {
 			dprintk(dev, 1, "%s the payload is too small for plane %u (%lu < %lu)\n",
@@ -152,6 +153,7 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 
 static void vid_out_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
 
@@ -186,7 +188,8 @@ static int vid_out_start_streaming(struct vb2_queue *vq, unsigned count)
 
 		list_for_each_entry_safe(buf, tmp, &dev->vid_out_active, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 	return err;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index dfd45c7..389fb0b 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -613,8 +613,9 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	done->buf.v4l2_buf.sequence = video->sequence++;
 	v4l2_get_timestamp(&done->buf.v4l2_buf.timestamp);
 	for (i = 0; i < done->buf.num_planes; ++i)
-		vb2_set_plane_payload(&done->buf, i, done->length[i]);
-	vb2_buffer_done(&done->buf, VB2_BUF_STATE_DONE);
+		vb2_set_plane_payload(&done->buf.vb2_buf, i,
+				      done->length[i]);
+	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return next;
 }
@@ -820,8 +821,9 @@ vsp1_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
-	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
+	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vbuf);
 	const struct v4l2_pix_format_mplane *format = &video->format;
 	unsigned int i;
 
@@ -841,9 +843,10 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 
 static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
-	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vb);
+	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vbuf);
 	unsigned long flags;
 	bool empty;
 
@@ -954,7 +957,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	/* Remove all buffers from the IRQ queue. */
 	spin_lock_irqsave(&video->irqlock, flags);
 	list_for_each_entry(buffer, &video->irqqueue, queue)
-		vb2_buffer_done(&buffer->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	INIT_LIST_HEAD(&video->irqqueue);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index d808301..c3af62e 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -94,7 +94,7 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 }
 
 struct vsp1_video_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
 	dma_addr_t addr[3];
@@ -102,7 +102,7 @@ struct vsp1_video_buffer {
 };
 
 static inline struct vsp1_video_buffer *
-to_vsp1_video_buffer(struct vb2_buffer *vb)
+to_vsp1_video_buffer(struct vb2_v4l2_buffer *vb)
 {
 	return container_of(vb, struct vsp1_video_buffer, buf);
 }
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 4069234..253884a 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -97,7 +97,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct airspy_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -310,13 +310,13 @@ static void airspy_urb_complete(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
+		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		len = airspy_convert_stream(s, ptr, urb->transfer_buffer,
 				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb, 0, len);
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
 		fbuf->vb.v4l2_buf.sequence = s->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
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
@@ -505,14 +505,15 @@ static int airspy_queue_setup(struct vb2_queue *vq,
 
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
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
@@ -571,7 +572,8 @@ err_clear_bit:
 
 		list_for_each_entry_safe(buf, tmp, &s->queued_bufs, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index f67247c..5fbf279 100644
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
@@ -70,8 +69,9 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 static void
 vbi_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
+	struct au0828_buffer *buf = container_of(vbuf, struct au0828_buffer, vb);
 	struct au0828_dmaqueue *vbiq = &dev->vbiq;
 	unsigned long flags = 0;
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 1a362a0..28e374e 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -302,8 +302,8 @@ static inline void buffer_filled(struct au0828_dev *dev,
 				 struct au0828_dmaqueue *dma_q,
 				 struct au0828_buffer *buf)
 {
-	struct vb2_buffer *vb = &buf->vb;
-	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_v4l2_buffer *vb = &buf->vb;
+	struct vb2_queue *q = vb->vb2_buf.vb2_queue;
 
 	/* Advice that buffer was filled */
 	au0828_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
@@ -315,7 +315,7 @@ static inline void buffer_filled(struct au0828_dev *dev,
 
 	vb->v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
-	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
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
@@ -573,8 +573,8 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 				if (vbi_buf == NULL)
 					vbioutp = NULL;
 				else
-					vbioutp = vb2_plane_vaddr(
-						&vbi_buf->vb, 0);
+					vbioutp = vb2_plane_vaddr(&vbi_buf->vb.vb2_buf,
+								  0);
 
 				/* Video */
 				if (buf != NULL)
@@ -583,7 +583,8 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 				if (buf == NULL)
 					outp = NULL;
 				else
-					outp = vb2_plane_vaddr(&buf->vb, 0);
+					outp = vb2_plane_vaddr(&buf->vb.vb2_buf,
+							       0);
 
 				/* As long as isoc traffic is arriving, keep
 				   resetting the timer */
@@ -658,7 +659,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static int
 buffer_prepare(struct vb2_buffer *vb)
 {
-	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct au0828_buffer *buf = container_of(vbuf, struct au0828_buffer, vb);
 	struct au0828_dev    *dev = vb2_get_drv_priv(vb->vb2_queue);
 
 	buf->length = dev->height * dev->bytesperline;
@@ -668,14 +670,15 @@ buffer_prepare(struct vb2_buffer *vb)
 			__func__, vb2_plane_size(vb, 0), buf->length);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, buf->length);
+	vb2_set_plane_payload(vb, 0, buf->length);
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
@@ -826,14 +829,15 @@ static void au0828_stop_streaming(struct vb2_queue *vq)
 
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
@@ -853,7 +857,7 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->isoc_ctl.vbi_buf != NULL) {
-		vb2_buffer_done(&dev->isoc_ctl.vbi_buf->vb,
+		vb2_buffer_done(&dev->isoc_ctl.vbi_buf->vb.vb2_buf,
 				VB2_BUF_STATE_ERROR);
 		dev->isoc_ctl.vbi_buf = NULL;
 	}
@@ -862,7 +866,7 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vbiq->active.next, struct au0828_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 
@@ -911,7 +915,7 @@ static void au0828_vid_buffer_timeout(unsigned long data)
 
 	buf = dev->isoc_ctl.buf;
 	if (buf != NULL) {
-		vid_data = vb2_plane_vaddr(&buf->vb, 0);
+		vid_data = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 		memset(vid_data, 0x00, buf->length); /* Blank green frame */
 		buffer_filled(dev, dma_q, buf);
 	}
@@ -935,7 +939,7 @@ static void au0828_vbi_buffer_timeout(unsigned long data)
 
 	buf = dev->isoc_ctl.vbi_buf;
 	if (buf != NULL) {
-		vbi_data = vb2_plane_vaddr(&buf->vb, 0);
+		vbi_data = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 		memset(vbi_data, 0x00, buf->length);
 		buffer_filled(dev, dma_q, buf);
 	}
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 3b48000..270aa47 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -167,7 +167,7 @@ struct au0828_usb_isoc_ctl {
 /* buffer for one video frame */
 struct au0828_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	void *mem;
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 744e7ed..50b33c9 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -59,9 +59,10 @@ static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int vbi_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct em28xx        *dev  = vb2_get_drv_priv(vb->vb2_queue);
 	struct em28xx_v4l2   *v4l2 = dev->v4l2;
-	struct em28xx_buffer *buf  = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer *buf  = container_of(vbuf, struct em28xx_buffer, vb);
 	unsigned long        size;
 
 	size = v4l2->vbi_width * v4l2->vbi_height * 2;
@@ -71,7 +72,7 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 		       __func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -79,8 +80,9 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 static void
 vbi_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct em28xx *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer *buf = container_of(vbuf, struct em28xx_buffer, vb);
 	struct em28xx_dmaqueue *vbiq = &dev->vbiq;
 	unsigned long flags = 0;
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4397ce5..bbccaed 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -440,7 +440,7 @@ static inline void finish_buffer(struct em28xx *dev,
 		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
 
 /*
@@ -900,9 +900,10 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static int
 buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct em28xx        *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct em28xx_v4l2   *v4l2 = dev->v4l2;
-	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer *buf = container_of(vbuf, struct em28xx_buffer, vb);
 	unsigned long size;
 
 	em28xx_videodbg("%s, field=%d\n", __func__, vb->v4l2_buf.field);
@@ -914,7 +915,7 @@ buffer_prepare(struct vb2_buffer *vb)
 				__func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
 
 	return 0;
 }
@@ -995,7 +996,8 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->usb_ctl.vid_buf != NULL) {
-		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vid_buf = NULL;
 	}
 	while (!list_empty(&vidq->active)) {
@@ -1003,7 +1005,7 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vidq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -1026,7 +1028,8 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->usb_ctl.vbi_buf != NULL) {
-		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vbi_buf = NULL;
 	}
 	while (!list_empty(&vbiq->active)) {
@@ -1034,7 +1037,7 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 		buf = list_entry(vbiq->active.next, struct em28xx_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -1042,8 +1045,9 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 static void
 buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct em28xx *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct em28xx_buffer *buf = container_of(vb, struct em28xx_buffer, vb);
+	struct em28xx_buffer *buf = container_of(vbuf, struct em28xx_buffer, vb);
 	struct em28xx_dmaqueue *vidq = &dev->vidq;
 	unsigned long flags = 0;
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e6559c6..e8512c4 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -264,7 +264,7 @@ struct em28xx_fmt {
 /* buffer for one video frame */
 struct em28xx_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 
 	void *mem;
diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 0ab81ec..0814135 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -387,7 +387,7 @@ start_error:
 static inline void store_byte(struct go7007_buffer *vb, u8 byte)
 {
 	if (vb && vb->vb.v4l2_planes[0].bytesused < GO7007_BUF_SIZE) {
-		u8 *ptr = vb2_plane_vaddr(&vb->vb, 0);
+		u8 *ptr = vb2_plane_vaddr(&vb->vb.vb2_buf, 0);
 
 		ptr[vb->vb.v4l2_planes[0].bytesused++] = byte;
 	}
@@ -476,7 +476,7 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
 		vb = list_first_entry(&go->vidq_active, struct go7007_buffer, list);
 	go->active_buf = vb;
 	spin_unlock(&go->spinlock);
-	vb2_buffer_done(&vb_tmp->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&vb_tmp->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	return vb;
 }
 
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
index c57207e..3d4e5db 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -52,7 +52,7 @@ static bool valid_pixelformat(u32 pixelformat)
 
 static u32 get_frame_type_flag(struct go7007_buffer *vb, int format)
 {
-	u8 *ptr = vb2_plane_vaddr(&vb->vb, 0);
+	u8 *ptr = vb2_plane_vaddr(&vb->vb.vb2_buf, 0);
 
 	switch (format) {
 	case V4L2_PIX_FMT_MJPEG:
@@ -384,10 +384,11 @@ static int go7007_queue_setup(struct vb2_queue *q,
 
 static void go7007_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct go7007 *go = vb2_get_drv_priv(vq);
 	struct go7007_buffer *go7007_vb =
-		container_of(vb, struct go7007_buffer, vb);
+		container_of(vbuf, struct go7007_buffer, vb);
 	unsigned long flags;
 
 	spin_lock_irqsave(&go->spinlock, flags);
@@ -397,23 +398,25 @@ static void go7007_buf_queue(struct vb2_buffer *vb)
 
 static int go7007_buf_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct go7007_buffer *go7007_vb =
-		container_of(vb, struct go7007_buffer, vb);
+		container_of(vbuf, struct go7007_buffer, vb);
 
 	go7007_vb->modet_active = 0;
 	go7007_vb->frame_offset = 0;
-	vb->v4l2_planes[0].bytesused = 0;
+	vbuf->v4l2_planes[0].bytesused = 0;
 	return 0;
 }
 
 static void go7007_buf_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct go7007 *go = vb2_get_drv_priv(vq);
 	struct go7007_buffer *go7007_vb =
-		container_of(vb, struct go7007_buffer, vb);
+		container_of(vbuf, struct go7007_buffer, vb);
 	u32 frame_type_flag = get_frame_type_flag(go7007_vb, go->format);
-	struct v4l2_buffer *buf = &vb->v4l2_buf;
+	struct v4l2_buffer *buf = &vbuf->v4l2_buf;
 
 	buf->flags &= ~(V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_BFRAME |
 			V4L2_BUF_FLAG_PFRAME);
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index fd1fa41..935b920 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -85,7 +85,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct hackrf_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -287,13 +287,13 @@ static void hackrf_urb_complete(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
+		ptr = vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0);
 		len = hackrf_convert_stream(dev, ptr, urb->transfer_buffer,
 				urb->actual_length);
-		vb2_set_plane_payload(&fbuf->vb, 0, len);
+		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
 		fbuf->vb.v4l2_buf.sequence = dev->sequence++;
-		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
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
@@ -483,9 +483,10 @@ static int hackrf_queue_setup(struct vb2_queue *vq,
 
 static void hackrf_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct hackrf_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct hackrf_frame_buf *buf =
-			container_of(vb, struct hackrf_frame_buf, vb);
+			container_of(vbuf, struct hackrf_frame_buf, vb);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->queued_bufs_lock, flags);
@@ -539,7 +540,8 @@ err:
 
 		list_for_each_entry_safe(buf, tmp, &dev->queued_bufs, list) {
 			list_del(&buf->list);
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+			vb2_buffer_done(&buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
 		}
 	}
 
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 3f276d9..77cfb7d 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -112,7 +112,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct msi2500_frame_buf {
-	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
@@ -431,10 +431,10 @@ static void msi2500_isoc_handler(struct urb *urb)
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
@@ -569,7 +569,7 @@ static void msi2500_cleanup_queued_bufs(struct msi2500_dev *dev)
 		buf = list_entry(dev->queued_bufs.next,
 				 struct msi2500_frame_buf, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
@@ -633,15 +633,15 @@ static int msi2500_queue_setup(struct vb2_queue *vq,
 
 static void msi2500_buf_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct msi2500_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	struct msi2500_frame_buf *buf = container_of(vb,
-						     struct msi2500_frame_buf,
-						     vb);
+	struct msi2500_frame_buf *buf =
+			container_of(vbuf, struct msi2500_frame_buf, vb);
 	unsigned long flags;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (unlikely(!dev->udev)) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 702267e..2fc3c0f 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -242,7 +242,8 @@ static void pwc_frame_complete(struct pwc_device *pdev)
 		} else {
 			fbuf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
 			fbuf->vb.v4l2_buf.sequence = pdev->vframe_count;
-			vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
+			vb2_buffer_done(&fbuf->vb.vb2_buf,
+					VB2_BUF_STATE_DONE);
 			pdev->fill_buf = NULL;
 			pdev->vsync = 0;
 		}
@@ -287,7 +288,7 @@ static void pwc_isoc_handler(struct urb *urb)
 		{
 			PWC_ERROR("Too many ISOC errors, bailing out.\n");
 			if (pdev->fill_buf) {
-				vb2_buffer_done(&pdev->fill_buf->vb,
+				vb2_buffer_done(&pdev->fill_buf->vb.vb2_buf,
 						VB2_BUF_STATE_ERROR);
 				pdev->fill_buf = NULL;
 			}
@@ -520,7 +521,7 @@ static void pwc_cleanup_queued_bufs(struct pwc_device *pdev,
 		buf = list_entry(pdev->queued_bufs.next, struct pwc_frame_buf,
 				 list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, state);
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
 	}
 	spin_unlock_irqrestore(&pdev->queued_bufs_lock, flags);
 }
@@ -594,7 +595,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int buffer_init(struct vb2_buffer *vb)
 {
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf = container_of(vbuf, struct pwc_frame_buf, vb);
 
 	/* need vmalloc since frame buffer > 128K */
 	buf->data = vzalloc(PWC_FRAME_SIZE);
@@ -617,8 +619,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct pwc_frame_buf *buf = container_of(vbuf, struct pwc_frame_buf, vb);
 
 	if (vb->state == VB2_BUF_STATE_DONE) {
 		/*
@@ -633,20 +636,22 @@ static void buffer_finish(struct vb2_buffer *vb)
 
 static void buffer_cleanup(struct vb2_buffer *vb)
 {
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct pwc_frame_buf *buf = container_of(vbuf, struct pwc_frame_buf, vb);
 
 	vfree(buf->data);
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
+	struct pwc_frame_buf *buf = container_of(vbuf, struct pwc_frame_buf, vb);
 	unsigned long flags = 0;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (!pdev->udev) {
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
@@ -695,7 +700,8 @@ static void stop_streaming(struct vb2_queue *vq)
 
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
index 81b017a..e2c12dc 100644
--- a/drivers/media/usb/pwc/pwc.h
+++ b/drivers/media/usb/pwc/pwc.h
@@ -210,7 +210,7 @@ struct pwc_raw_frame {
 /* intermediate buffers with raw data from the USB cam */
 struct pwc_frame_buf
 {
-	struct vb2_buffer vb;	/* common v4l buffer stuff -- must be first */
+	struct vb2_v4l2_buffer vb;	/* common v4l buffer stuff -- must be first */
 	struct list_head list;
 	void *data;
 	int filled;		/* number of bytes filled */
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 0f3c34d..4284e56 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -293,7 +293,7 @@ struct s2255_fmt {
 /* buffer for one video frame */
 struct s2255_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
@@ -580,7 +580,7 @@ static void s2255_got_frame(struct s2255_vc *vc, int jpgsize)
 
 	s2255_fillbuff(vc, buf, jpgsize);
 	/* tell v4l buffer was filled */
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	dprintk(dev, 2, "%s: [buf] [%p]\n", __func__, buf);
 }
 
@@ -612,7 +612,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 {
 	int pos = 0;
 	const char *tmpbuf;
-	char *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	char *vbuf = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 	unsigned long last_frame;
 	struct s2255_dev *dev = vc->dev;
 
@@ -635,7 +635,8 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 			break;
 		case V4L2_PIX_FMT_JPEG:
 		case V4L2_PIX_FMT_MJPEG:
-			vb2_set_plane_payload(&buf->vb, 0, jpgsize);
+			vb2_set_plane_payload(&buf->vb.vb2_buf, 0,
+					      jpgsize);
 			memcpy(vbuf, tmpbuf, jpgsize);
 			break;
 		case V4L2_PIX_FMT_YUV422P:
@@ -674,7 +675,6 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2_queue);
-	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	int w = vc->width;
 	int h = vc->height;
 	unsigned long size;
@@ -696,13 +696,14 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(&buf->vb, 0, size);
+	vb2_set_plane_payload(vb, 0, size);
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
@@ -1116,7 +1117,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	spin_lock_irqsave(&vc->qlock, flags);
 	list_for_each_entry_safe(buf, node, &vc->buf_list, list) {
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		dprintk(vc->dev, 2, "[%p/%d] done\n",
 			buf, buf->vb.v4l2_buf.index);
 	}
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index e12b103..6e23b2b 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -693,10 +693,11 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
 
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	unsigned long flags;
 	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
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
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 	} else {
 
 		buf->mem = vb2_plane_vaddr(vb, 0);
@@ -717,7 +718,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		 * the buffer to userspace directly.
 		 */
 		if (buf->length < dev->width * dev->height * 2)
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		else
 			list_add_tail(&buf->list, &dev->avail_bufs);
 
@@ -769,7 +770,7 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = list_first_entry(&dev->avail_bufs,
 			struct stk1160_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		stk1160_dbg("buffer [%p/%d] aborted\n",
 			    buf, buf->vb.v4l2_buf.index);
 	}
@@ -779,7 +780,7 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = dev->isoc_ctl.buf;
 		dev->isoc_ctl.buf = NULL;
 
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 		stk1160_dbg("buffer [%p/%d] aborted\n",
 			    buf, buf->vb.v4l2_buf.index);
 	}
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 940c3ea..ff1f327 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -101,8 +101,8 @@ void stk1160_buffer_done(struct stk1160 *dev)
 	buf->vb.v4l2_buf.bytesused = buf->bytesused;
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
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
index a46766c..2f8674d 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -306,7 +306,7 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 
 	/* First available buffer. */
 	buf = list_first_entry(&usbtv->bufs, struct usbtv_buf, list);
-	frame = vb2_plane_vaddr(&buf->vb, 0);
+	frame = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 
 	/* Copy the chunk data. */
 	usbtv_chunk_to_vbuf(frame, &chunk[1], chunk_no, odd);
@@ -314,7 +314,7 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 
 	/* Last chunk in a frame, signalling an end */
 	if (odd && chunk_no == usbtv->n_chunks-1) {
-		int size = vb2_plane_size(&buf->vb, 0);
+		int size = vb2_plane_size(&buf->vb.vb2_buf, 0);
 		enum vb2_buffer_state state = usbtv->chunks_done ==
 						usbtv->n_chunks ?
 						VB2_BUF_STATE_DONE :
@@ -323,8 +323,8 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 		buf->vb.v4l2_buf.sequence = usbtv->sequence++;
 		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-		vb2_set_plane_payload(&buf->vb, 0, size);
-		vb2_buffer_done(&buf->vb, state);
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
index 9681195..a1a4d95 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -61,7 +61,7 @@ struct usbtv_norm_params {
 
 /* A single videobuf2 frame buffer. */
 struct usbtv_buf {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index f16b9b4..2db04b2 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -60,7 +60,7 @@ static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
 							  queue);
 		list_del(&buf->queue);
 		buf->state = state;
-		vb2_buffer_done(&buf->buf, vb2_state);
+		vb2_buffer_done(&buf->buf.vb2_buf, vb2_state);
 	}
 }
 
@@ -89,10 +89,11 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int uvc_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 
-	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	if (vbuf->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
 	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
 		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
 		return -EINVAL;
@@ -105,7 +106,7 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	buf->error = 0;
 	buf->mem = vb2_plane_vaddr(vb, 0);
 	buf->length = vb2_plane_size(vb, 0);
-	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (vbuf->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
 	else
 		buf->bytesused = vb2_get_plane_payload(vb, 0);
@@ -115,8 +116,9 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 
 static void uvc_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 	unsigned long flags;
 
 	spin_lock_irqsave(&queue->irqlock, flags);
@@ -127,7 +129,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 		 * directly. The next QBUF call will fail with -ENODEV.
 		 */
 		buf->state = UVC_BUF_STATE_ERROR;
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 	}
 
 	spin_unlock_irqrestore(&queue->irqlock, flags);
@@ -135,12 +137,13 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 
 static void uvc_buffer_finish(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 
 	if (vb->state == VB2_BUF_STATE_DONE)
-		uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
+		uvc_video_clock_update(stream, &vbuf->v4l2_buf, buf);
 }
 
 static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -398,7 +401,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		buf->error = 0;
 		buf->state = UVC_BUF_STATE_QUEUED;
 		buf->bytesused = 0;
-		vb2_set_plane_payload(&buf->buf, 0, 0);
+		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
 		return buf;
 	}
 
@@ -412,8 +415,8 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
 	buf->state = buf->error ? VB2_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
-	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
-	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
+	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
+	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return nextbuf;
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 53e6484..f5c2e99 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -354,7 +354,7 @@ enum uvc_buffer_state {
 };
 
 struct uvc_buffer {
-	struct vb2_buffer buf;
+	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
 	enum uvc_buffer_state state;
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 95100e3..8ea5de6 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -773,13 +773,13 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
  *
  * Call from buf_queue(), videobuf_queue_ops callback.
  */
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb)
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_v4l2_buffer *vbuf)
 {
-	struct v4l2_m2m_buffer *b = container_of(vb, struct v4l2_m2m_buffer, vb);
+	struct v4l2_m2m_buffer *b = container_of(vbuf, struct v4l2_m2m_buffer, vb);
 	struct v4l2_m2m_queue_ctx *q_ctx;
 	unsigned long flags;
 
-	q_ctx = get_queue_ctx(m2m_ctx, vb->vb2_queue->type);
+	q_ctx = get_queue_ctx(m2m_ctx, vbuf->vb2_buf.vb2_queue->type);
 	if (!q_ctx)
 		return;
 
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index ca15186..7956776 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -53,7 +53,7 @@ module_param(debug, int, 0644);
 
 #define log_memop(vb, op)						\
 	dprintk(2, "call_memop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2_queue, vb2_v4l2_index(vb), #op,		\
 		(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
 
 #define call_memop(vb, op, args...)					\
@@ -115,7 +115,7 @@ module_param(debug, int, 0644);
 
 #define log_vb_qop(vb, op, args...)					\
 	dprintk(2, "call_vb_qop(%p, %d, %s)%s\n",			\
-		(vb)->vb2_queue, (vb)->v4l2_buf.index, #op,		\
+		(vb)->vb2_queue, vb2_v4l2_index(vb), #op,		\
 		(vb)->vb2_queue->ops->op ? "" : " (nop)")
 
 #define call_vb_qop(vb, op, args...)					\
@@ -192,6 +192,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	enum dma_data_direction dma_dir =
 		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
@@ -211,7 +212,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 
 		/* Associate allocator private data with this plane */
 		vb->planes[plane].mem_priv = mem_priv;
-		vb->v4l2_planes[plane].length = q->plane_sizes[plane];
+		vbuf->v4l2_planes[plane].length = q->plane_sizes[plane];
 	}
 
 	return 0;
@@ -236,7 +237,7 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
 		call_void_memop(vb, put, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
 		dprintk(3, "freed plane %d of buffer %d\n", plane,
-			vb->v4l2_buf.index);
+			vb2_v4l2_index(vb));
 	}
 }
 
@@ -292,14 +293,16 @@ static void __setup_lengths(struct vb2_queue *q, unsigned int n)
 {
 	unsigned int buffer, plane;
 	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 
 	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
 		vb = q->bufs[buffer];
 		if (!vb)
 			continue;
+		vbuf = to_vb2_v4l2_buffer(vb);
 
 		for (plane = 0; plane < vb->num_planes; ++plane)
-			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
+			vbuf->v4l2_planes[plane].length = q->plane_sizes[plane];
 	}
 }
 
@@ -311,12 +314,14 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 {
 	unsigned int buffer, plane;
 	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	unsigned long off;
 
 	if (q->num_buffers) {
 		struct v4l2_plane *p;
 		vb = q->bufs[q->num_buffers - 1];
-		p = &vb->v4l2_planes[vb->num_planes - 1];
+		vbuf = to_vb2_v4l2_buffer(vb);
+		p = &vbuf->v4l2_planes[vb->num_planes - 1];
 		off = PAGE_ALIGN(p->m.mem_offset + p->length);
 	} else {
 		off = 0;
@@ -326,14 +331,15 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 		vb = q->bufs[buffer];
 		if (!vb)
 			continue;
+		vbuf = to_vb2_v4l2_buffer(vb);
 
 		for (plane = 0; plane < vb->num_planes; ++plane) {
-			vb->v4l2_planes[plane].m.mem_offset = off;
+			vbuf->v4l2_planes[plane].m.mem_offset = off;
 
 			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
 					buffer, plane, off);
 
-			off += vb->v4l2_planes[plane].length;
+			off += vbuf->v4l2_planes[plane].length;
 			off = PAGE_ALIGN(off);
 		}
 	}
@@ -351,6 +357,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 {
 	unsigned int buffer;
 	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	int ret;
 
 	for (buffer = 0; buffer < num_buffers; ++buffer) {
@@ -361,16 +368,18 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			break;
 		}
 
+		vbuf = to_vb2_v4l2_buffer(vb);
+
 		/* Length stores number of planes for multiplanar buffers */
 		if (V4L2_TYPE_IS_MULTIPLANAR(q->type))
-			vb->v4l2_buf.length = num_planes;
+			vbuf->v4l2_buf.length = num_planes;
 
 		vb->state = VB2_BUF_STATE_DEQUEUED;
 		vb->vb2_queue = q;
 		vb->num_planes = num_planes;
-		vb->v4l2_buf.index = q->num_buffers + buffer;
-		vb->v4l2_buf.type = q->type;
-		vb->v4l2_buf.memory = memory;
+		vbuf->v4l2_buf.index = q->num_buffers + buffer;
+		vbuf->v4l2_buf.type = q->type;
+		vbuf->v4l2_buf.memory = memory;
 
 		/* Allocate video buffer memory for the MMAP type */
 		if (memory == V4L2_MEMORY_MMAP) {
@@ -580,6 +589,7 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
  */
 static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	unsigned int length;
 	unsigned int bytesused;
 	unsigned int plane;
@@ -592,7 +602,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			length = (b->memory == V4L2_MEMORY_USERPTR ||
 				  b->memory == V4L2_MEMORY_DMABUF)
 			       ? b->m.planes[plane].length
-			       : vb->v4l2_planes[plane].length;
+			       : vbuf->v4l2_planes[plane].length;
 			bytesused = b->m.planes[plane].bytesused
 				  ? b->m.planes[plane].bytesused : length;
 
@@ -605,7 +615,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 	} else {
 		length = (b->memory == V4L2_MEMORY_USERPTR)
-		       ? b->length : vb->v4l2_planes[0].length;
+		       ? b->length : vbuf->v4l2_planes[0].length;
 		bytesused = b->bytesused ? b->bytesused : length;
 
 		if (b->bytesused > length)
@@ -657,11 +667,12 @@ static bool __buffers_in_use(struct vb2_queue *q)
 static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
 	/* Copy back data such as timestamp, flags, etc. */
-	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
-	b->reserved2 = vb->v4l2_buf.reserved2;
-	b->reserved = vb->v4l2_buf.reserved;
+	memcpy(b, &vbuf->v4l2_buf, offsetof(struct v4l2_buffer, m));
+	b->reserved2 = vbuf->v4l2_buf.reserved2;
+	b->reserved = vbuf->v4l2_buf.reserved;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
 		/*
@@ -669,21 +680,21 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		 * for it. The caller has already verified memory and size.
 		 */
 		b->length = vb->num_planes;
-		memcpy(b->m.planes, vb->v4l2_planes,
+		memcpy(b->m.planes, vbuf->v4l2_planes,
 			b->length * sizeof(struct v4l2_plane));
 	} else {
 		/*
 		 * We use length and offset in v4l2_planes array even for
 		 * single-planar buffers, but userspace does not.
 		 */
-		b->length = vb->v4l2_planes[0].length;
-		b->bytesused = vb->v4l2_planes[0].bytesused;
+		b->length = vbuf->v4l2_planes[0].length;
+		b->bytesused = vbuf->v4l2_planes[0].bytesused;
 		if (q->memory == V4L2_MEMORY_MMAP)
-			b->m.offset = vb->v4l2_planes[0].m.mem_offset;
+			b->m.offset = vbuf->v4l2_planes[0].m.mem_offset;
 		else if (q->memory == V4L2_MEMORY_USERPTR)
-			b->m.userptr = vb->v4l2_planes[0].m.userptr;
+			b->m.userptr = vbuf->v4l2_planes[0].m.userptr;
 		else if (q->memory == V4L2_MEMORY_DMABUF)
-			b->m.fd = vb->v4l2_planes[0].m.fd;
+			b->m.fd = vbuf->v4l2_planes[0].m.fd;
 	}
 
 	/*
@@ -1195,7 +1206,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	vb->cnt_buf_done++;
 #endif
 	dprintk(4, "done processing on buffer %d, state: %d\n",
-			vb->v4l2_buf.index, state);
+			vb2_v4l2_index(vb), state);
 
 	/* sync buffers */
 	for (plane = 0; plane < vb->num_planes; ++plane)
@@ -1272,6 +1283,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 				struct v4l2_plane *v4l2_planes)
 {
 	unsigned int plane;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		if (b->memory == V4L2_MEMORY_USERPTR) {
@@ -1364,7 +1376,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 	}
 
 	/* Zero flags that the vb2 core handles */
-	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
+	vbuf->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
 	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
 	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
@@ -1372,7 +1384,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		 * their timestamp and timestamp source flags from the
 		 * queue.
 		 */
-		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		vbuf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	}
 
 	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
@@ -1382,11 +1394,11 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		 * The 'field' is valid metadata for this output buffer
 		 * and so that needs to be copied here.
 		 */
-		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
-		vb->v4l2_buf.field = b->field;
+		vbuf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
+		vbuf->v4l2_buf.field = b->field;
 	} else {
 		/* Zero any output buffer flags as this is a capture buffer */
-		vb->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
+		vbuf->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
 	}
 }
 
@@ -1395,7 +1407,9 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
  */
 static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
-	__fill_vb2_buffer(vb, b, vb->v4l2_planes);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	__fill_vb2_buffer(vb, b, vbuf->v4l2_planes);
 	return call_vb_qop(vb, buf_prepare, vb);
 }
 
@@ -1406,6 +1420,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct v4l2_plane planes[VIDEO_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
@@ -1419,9 +1434,9 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		/* Skip the plane if already verified */
-		if (vb->v4l2_planes[plane].m.userptr &&
-		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
-		    && vb->v4l2_planes[plane].length == planes[plane].length)
+		if (vbuf->v4l2_planes[plane].m.userptr &&
+		    vbuf->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
+		    && vbuf->v4l2_planes[plane].length == planes[plane].length)
 			continue;
 
 		dprintk(3, "userspace address for plane %d changed, "
@@ -1447,7 +1462,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		}
 
 		vb->planes[plane].mem_priv = NULL;
-		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
+		memset(&vbuf->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
 
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, get_userptr, q->alloc_ctx[plane],
@@ -1467,7 +1482,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	 * provided by userspace.
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane)
-		vb->v4l2_planes[plane] = planes[plane];
+		vbuf->v4l2_planes[plane] = planes[plane];
 
 	if (reacquired) {
 		/*
@@ -1496,8 +1511,8 @@ err:
 		if (vb->planes[plane].mem_priv)
 			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
 		vb->planes[plane].mem_priv = NULL;
-		vb->v4l2_planes[plane].m.userptr = 0;
-		vb->v4l2_planes[plane].length = 0;
+		vbuf->v4l2_planes[plane].m.userptr = 0;
+		vbuf->v4l2_planes[plane].length = 0;
 	}
 
 	return ret;
@@ -1510,6 +1525,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct v4l2_plane planes[VIDEO_MAX_PLANES];
 	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	void *mem_priv;
 	unsigned int plane;
 	int ret;
@@ -1544,7 +1560,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		/* Skip the plane if already verified */
 		if (dbuf == vb->planes[plane].dbuf &&
-		    vb->v4l2_planes[plane].length == planes[plane].length) {
+		    vbuf->v4l2_planes[plane].length == planes[plane].length) {
 			dma_buf_put(dbuf);
 			continue;
 		}
@@ -1558,7 +1574,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		/* Release previously acquired memory if present */
 		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
-		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
+		memset(&vbuf->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
 
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
@@ -1593,7 +1609,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	 * provided by userspace.
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane)
-		vb->v4l2_planes[plane] = planes[plane];
+		vbuf->v4l2_planes[plane] = planes[plane];
 
 	if (reacquired) {
 		/*
@@ -1645,6 +1661,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	int ret;
 
 	ret = __verify_length(vb, b);
@@ -1672,9 +1689,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	}
 
 	vb->state = VB2_BUF_STATE_PREPARING;
-	vb->v4l2_buf.timestamp.tv_sec = 0;
-	vb->v4l2_buf.timestamp.tv_usec = 0;
-	vb->v4l2_buf.sequence = 0;
+	vbuf->v4l2_buf.timestamp.tv_sec = 0;
+	vbuf->v4l2_buf.timestamp.tv_usec = 0;
+	vbuf->v4l2_buf.sequence = 0;
 
 	switch (q->memory) {
 	case V4L2_MEMORY_MMAP:
@@ -1768,7 +1785,8 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 		/* Fill buffer information for the userspace */
 		__fill_v4l2_buffer(vb, b);
 
-		dprintk(1, "prepare of buffer %d succeeded\n", vb->v4l2_buf.index);
+		dprintk(1, "prepare of buffer %d succeeded\n",
+			vb2_v4l2_index(vb));
 	}
 	return ret;
 }
@@ -1872,16 +1890,18 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
 	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
 		/*
 		 * For output buffers copy the timestamp if needed,
 		 * and the timecode field and flag if needed.
 		 */
 		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
 		    V4L2_BUF_FLAG_TIMESTAMP_COPY)
-			vb->v4l2_buf.timestamp = b->timestamp;
-		vb->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
+			vbuf->v4l2_buf.timestamp = b->timestamp;
+		vbuf->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
-			vb->v4l2_buf.timecode = b->timecode;
+			vbuf->v4l2_buf.timecode = b->timecode;
 	}
 
 	trace_vb2_qbuf(q, vb);
@@ -1909,7 +1929,7 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 			return ret;
 	}
 
-	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
+	dprintk(1, "qbuf of buffer %d succeeded\n", vb2_v4l2_index(vb));
 	return 0;
 }
 
@@ -2102,6 +2122,7 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 {
 	struct vb2_buffer *vb = NULL;
+	struct vb2_v4l2_buffer *vbuf = NULL;
 	int ret;
 
 	if (b->type != q->type) {
@@ -2134,14 +2155,16 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 
 	trace_vb2_dqbuf(q, vb);
 
+	vbuf = to_vb2_v4l2_buffer(vb);
+
 	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
-	    vb->v4l2_buf.flags & V4L2_BUF_FLAG_LAST)
+	    vbuf->v4l2_buf.flags & V4L2_BUF_FLAG_LAST)
 		q->last_buffer_dequeued = true;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
 	dprintk(1, "dqbuf of buffer %d, with state %d\n",
-			vb->v4l2_buf.index, vb->state);
+			vb2_v4l2_index(vb), vb->state);
 
 	return 0;
 }
@@ -2388,6 +2411,7 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 			unsigned int *_buffer, unsigned int *_plane)
 {
 	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	unsigned int buffer, plane;
 
 	/*
@@ -2397,9 +2421,9 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 	 */
 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
 		vb = q->bufs[buffer];
-
+		vbuf = to_vb2_v4l2_buffer(vb);
 		for (plane = 0; plane < vb->num_planes; ++plane) {
-			if (vb->v4l2_planes[plane].m.mem_offset == off) {
+			if (vbuf->v4l2_planes[plane].m.mem_offset == off) {
 				*_buffer = buffer;
 				*_plane = plane;
 				return 0;
@@ -2511,6 +2535,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 {
 	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
 	struct vb2_buffer *vb;
+	struct vb2_v4l2_buffer *vbuf;
 	unsigned int buffer = 0, plane = 0;
 	int ret;
 	unsigned long length;
@@ -2551,13 +2576,14 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 		return ret;
 
 	vb = q->bufs[buffer];
+	vbuf = to_vb2_v4l2_buffer(vb);
 
 	/*
 	 * MMAP requires page_aligned buffers.
 	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
 	 * so, we need to do the same here.
 	 */
-	length = PAGE_ALIGN(vb->v4l2_planes[plane].length);
+	length = PAGE_ALIGN(vbuf->v4l2_planes[plane].length);
 	if (length < (vma->vm_end - vma->vm_start)) {
 		dprintk(1,
 			"MMAP invalid, as it would overflow buffer length\n");
@@ -2762,7 +2788,7 @@ int vb2_queue_init(struct vb2_queue *q)
 	init_waitqueue_head(&q->done_wq);
 
 	if (q->buf_struct_size == 0)
-		q->buf_struct_size = sizeof(struct vb2_buffer);
+		q->buf_struct_size = sizeof(struct vb2_v4l2_buffer);
 
 	return 0;
 }
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index d617c39..d903ece 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -60,10 +60,11 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 static int uvc_buffer_prepare(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
+	struct uvc_buffer *buf = container_of(vbuf, struct uvc_buffer, buf);
 
-	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	if (vbuf->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
 	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
 		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of bounds.\n");
 		return -EINVAL;
@@ -75,7 +76,7 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	buf->state = UVC_BUF_STATE_QUEUED;
 	buf->mem = vb2_plane_vaddr(vb, 0);
 	buf->length = vb2_plane_size(vb, 0);
-	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (vbuf->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
 	else
 		buf->bytesused = vb2_get_plane_payload(vb, 0);
@@ -85,8 +86,9 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 
 static void uvc_buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
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
 
@@ -329,8 +331,8 @@ struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
 	buf->buf.v4l2_buf.sequence = queue->sequence++;
 	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
 
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
index 22f88c7..b59c4ea 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -86,7 +86,7 @@ struct v4l2_m2m_ctx {
 };
 
 struct v4l2_m2m_buffer {
-	struct vb2_buffer	vb;
+	struct vb2_v4l2_buffer	vb;
 	struct list_head	list;
 };
 
@@ -101,9 +101,9 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx);
 
 static inline void
-v4l2_m2m_buf_done(struct vb2_buffer *buf, enum vb2_buffer_state state)
+v4l2_m2m_buf_done(struct vb2_v4l2_buffer *buf, enum vb2_buffer_state state)
 {
-	vb2_buffer_done(buf, state);
+	vb2_buffer_done(&buf->vb2_buf, state);
 }
 
 int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
@@ -156,7 +156,7 @@ static inline void v4l2_m2m_set_dst_buffered(struct v4l2_m2m_ctx *m2m_ctx,
 
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
 
-void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_v4l2_buffer *vbuf);
 
 /**
  * v4l2_m2m_num_src_bufs_ready() - return the number of source buffers ready for
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 021a69c..76500f4 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -9,8 +9,8 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  */
-#ifndef _MEDIA_VIDEOBUF2_CORE_H
-#define _MEDIA_VIDEOBUF2_CORE_H
+#ifndef _MEDIA_VIDEOBUF2_V4L2_H
+#define _MEDIA_VIDEOBUF2_V4L2_H
 
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
@@ -161,17 +161,6 @@ struct vb2_queue;
 
 /**
  * struct vb2_buffer - represents a video buffer
- * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
- *			be read by the driver and relevant entries can be
- *			changed by the driver in case of CAPTURE types
- *			(such as timestamp)
- * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
- *			be read by the driver and relevant entries can be
- *			changed by the driver in case of CAPTURE types
- *			(such as bytesused); NOTE that even for single-planar
- *			types, the v4l2_planes[0] struct should be used
- *			instead of v4l2_buf for filling bytesused - drivers
- *			should use the vb2_set_plane_payload() function for that
  * @vb2_queue:		the queue to which this driver belongs
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue
@@ -183,9 +172,6 @@ struct vb2_queue;
  * @planes:		private per-plane information; do not change
  */
 struct vb2_buffer {
-	struct v4l2_buffer	v4l2_buf;
-	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
-
 	struct vb2_queue	*vb2_queue;
 
 	unsigned int		num_planes;
@@ -231,6 +217,26 @@ struct vb2_buffer {
 };
 
 /**
+ * struct vb2_v4l2_buffer - represents a video buffer for v4l2
+ * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
+ *			be read by the driver and relevant entries can be
+ *			changed by the driver in case of CAPTURE types
+ *			(such as timestamp)
+ * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
+ *			be read by the driver and relevant entries can be
+ *			changed by the driver in case of CAPTURE types
+ *			(such as bytesused); NOTE that even for single-planar
+ *			types, the v4l2_planes[0] struct should be used
+ *			instead of v4l2_buf for filling bytesused - drivers
+ *			should use the vb2_set_plane_payload() function for that
+ */
+struct vb2_v4l2_buffer {
+	struct vb2_buffer	vb2_buf;
+	struct v4l2_buffer	v4l2_buf;
+	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
+};
+
+/**
  * struct vb2_ops - driver-specific callbacks
  *
  * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
@@ -339,7 +345,7 @@ struct v4l2_fh;
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
  * @lock:	pointer to a mutex that protects the vb2_queue struct. The
- *		driver can set this to a mutex to let the v4l2 core serialize
+ *		driver can set this to a mutex to let the vb2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
  *		itself, then this should be set to NULL. This lock is not used
  *		by the videobuf2 core API.
@@ -352,7 +358,7 @@ struct v4l2_fh;
  * @drv_priv:	driver private data
  * @buf_struct_size: size of the driver-specific buffer structure;
  *		"0" indicates the driver doesn't want to use a custom buffer
- *		structure type, so sizeof(struct vb2_buffer) will is used
+ *		structure type, so sizeof(struct vb2_v4l2_buffer) will is used
  * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
  *		V4L2_BUF_FLAG_TSTAMP_SRC_*
  * @gfp_flags:	additional gfp flags used when allocating the buffers.
@@ -444,6 +450,20 @@ struct vb2_queue {
 #endif
 };
 
+/**
+ * to_vb2_v4l2_buffer() - cast to struct vb2_v4l2_buffer *
+ * @vb:		struct vb2_buffer *vb
+ */
+#define to_vb2_v4l2_buffer(vb) \
+	(container_of(vb, struct vb2_v4l2_buffer, vb2_buf))
+
+#define vb2_v4l2_index(vb)						\
+({								\
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);	\
+	int ret = vbuf->v4l2_buf.index;				\
+	ret;							\
+})
+
 void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
 void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
 
@@ -567,8 +587,10 @@ static inline void *vb2_get_drv_priv(struct vb2_queue *q)
 static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no, unsigned long size)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
 	if (plane_no < vb->num_planes)
-		vb->v4l2_planes[plane_no].bytesused = size;
+		vbuf->v4l2_planes[plane_no].bytesused = size;
 }
 
 /**
@@ -580,8 +602,10 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
 static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
 	if (plane_no < vb->num_planes)
-		return vb->v4l2_planes[plane_no].bytesused;
+		return vbuf->v4l2_planes[plane_no].bytesused;
 	return 0;
 }
 
@@ -593,8 +617,10 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
 static inline unsigned long
 vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
 	if (plane_no < vb->num_planes)
-		return vb->v4l2_planes[plane_no].length;
+		return vbuf->v4l2_planes[plane_no].length;
 	return 0;
 }
 
@@ -660,4 +686,4 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 void vb2_ops_wait_prepare(struct vb2_queue *vq);
 void vb2_ops_wait_finish(struct vb2_queue *vq);
 
-#endif /* _MEDIA_VIDEOBUF2_CORE_H */
+#endif /* _MEDIA_VIDEOBUF2_V4L2_H */
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index dbf017b..dabd780 100644
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
+		__entry->index = vbuf->v4l2_buf.index;
+		__entry->type = vbuf->v4l2_buf.type;
+		__entry->bytesused = vbuf->v4l2_planes[0].bytesused;
+		__entry->flags = vbuf->v4l2_buf.flags;
+		__entry->field = vbuf->v4l2_buf.field;
+		__entry->timestamp = timeval_to_ns(&vbuf->v4l2_buf.timestamp);
+		__entry->timecode_type = vbuf->v4l2_buf.timecode.type;
+		__entry->timecode_flags = vbuf->v4l2_buf.timecode.flags;
+		__entry->timecode_frames = vbuf->v4l2_buf.timecode.frames;
+		__entry->timecode_seconds = vbuf->v4l2_buf.timecode.seconds;
+		__entry->timecode_minutes = vbuf->v4l2_buf.timecode.minutes;
+		__entry->timecode_hours = vbuf->v4l2_buf.timecode.hours;
+		__entry->timecode_userbits0 = vbuf->v4l2_buf.timecode.userbits[0];
+		__entry->timecode_userbits1 = vbuf->v4l2_buf.timecode.userbits[1];
+		__entry->timecode_userbits2 = vbuf->v4l2_buf.timecode.userbits[2];
+		__entry->timecode_userbits3 = vbuf->v4l2_buf.timecode.userbits[3];
+		__entry->sequence = vbuf->v4l2_buf.sequence;
 	),
 
 	TP_printk("minor = %d, queued = %u, owned_by_drv = %d, index = %u, "
-- 
1.7.9.5

