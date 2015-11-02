Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43702 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbbKBEnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2015 23:43:51 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NX6034X77T0YTC0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Nov 2015 13:43:48 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v8 1/6] media: videobuf2: Move timestamp to vb2_buffer
Date: Mon, 02 Nov 2015 13:43:40 +0900
Message-id: <1446439425-13242-2-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1446439425-13242-1-git-send-email-jh1009.sung@samsung.com>
References: <1446439425-13242-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move timestamp from struct vb2_v4l2_buffer to struct vb2_buffer
for common use, and change its type to struct timespec in order to handling
y2038 problem. This patch also includes all device drivers' changes related to
this restructuring.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/input/touchscreen/sur40.c                  |    2 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    2 +-
 drivers/media/pci/cobalt/cobalt-irq.c              |    2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    2 +-
 drivers/media/pci/cx88/cx88-core.c                 |    2 +-
 drivers/media/pci/dt3155/dt3155.c                  |    2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    4 ++--
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/pci/tw68/tw68-video.c                |    2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    2 +-
 drivers/media/platform/coda/coda-bit.c             |    6 +++---
 drivers/media/platform/coda/coda.h                 |    2 +-
 drivers/media/platform/davinci/vpbe_display.c      |    2 +-
 drivers/media/platform/davinci/vpif_capture.c      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |    6 +++---
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    4 ++--
 drivers/media/platform/exynos4-is/fimc-capture.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    2 +-
 drivers/media/platform/m2m-deinterlace.c           |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |    2 +-
 drivers/media/platform/mx2_emmaprp.c               |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    2 +-
 drivers/media/platform/rcar_jpu.c                  |    2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    4 ++--
 drivers/media/platform/sh_veu.c                    |    2 +-
 drivers/media/platform/sh_vou.c                    |    2 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    4 ++--
 drivers/media/platform/ti-vpe/vpe.c                |    2 +-
 drivers/media/platform/vim2m.c                     |    2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |    6 +++---
 drivers/media/platform/vivid/vivid-kthread-out.c   |    8 ++++----
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    5 +++--
 drivers/media/platform/vivid/vivid-vbi-cap.c       |    8 ++++----
 drivers/media/platform/vsp1/vsp1_video.c           |    2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |    2 +-
 drivers/media/usb/airspy/airspy.c                  |    2 +-
 drivers/media/usb/au0828/au0828-video.c            |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    2 +-
 drivers/media/usb/go7007/go7007-driver.c           |    2 +-
 drivers/media/usb/hackrf/hackrf.c                  |    4 ++--
 drivers/media/usb/pwc/pwc-if.c                     |    3 +--
 drivers/media/usb/s2255/s2255drv.c                 |    2 +-
 drivers/media/usb/stk1160/stk1160-video.c          |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    2 +-
 drivers/media/usb/uvc/uvc_video.c                  |   11 ++++-------
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   14 +++++++++-----
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    2 +-
 drivers/staging/media/omap4iss/iss_video.c         |    2 +-
 drivers/usb/gadget/function/uvc_queue.c            |    2 +-
 include/media/videobuf2-core.h                     |    2 ++
 include/media/videobuf2-v4l2.h                     |    2 --
 include/trace/events/v4l2.h                        |    2 +-
 include/trace/events/vb2.h                         |    7 +++++--
 69 files changed, 104 insertions(+), 100 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index d214f22..7c3a812 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -444,7 +444,7 @@ static void sur40_process_video(struct sur40_state *sur40)
 		goto err_poll;
 
 	/* mark as finished */
-	v4l2_get_timestamp(&new_buf->vb.timestamp);
+	ktime_get_ts(&new_buf->vb.vb2_buf.timestamp);
 	new_buf->vb.sequence = sur40->sequence++;
 	new_buf->vb.field = V4L2_FIELD_NONE;
 	vb2_buffer_done(&new_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index dcd8d94..e3f146b 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -310,7 +310,7 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		len = rtl2832_sdr_convert_stream(dev, ptr, urb->transfer_buffer,
 				urb->actual_length);
 		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
-		v4l2_get_timestamp(&fbuf->vb.timestamp);
+		ktime_get_ts(&fbuf->vb.vb2_buf.timestamp);
 		fbuf->vb.sequence = dev->sequence++;
 		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index 3de26d0..5703172 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -134,7 +134,7 @@ done:
 		skip = true;
 		s->skip_first_frames--;
 	}
-	v4l2_get_timestamp(&cb->vb.timestamp);
+	ktime_get_ts(&cb->vb.vb2_buf.timestamp);
 	/* TODO: the sequence number should be read from the FPGA so we
 	   also know about dropped frames. */
 	cb->vb.sequence = s->sequence++;
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index bc1c960..e4a94a1 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -427,7 +427,7 @@ static void cx23885_wakeup(struct cx23885_tsport *port,
 	buf = list_entry(q->active.next,
 			 struct cx23885_buffer, queue);
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 	buf->vb.sequence = q->count++;
 	dprintk(1, "[%p/%d] wakeup reg=%d buf=%d\n", buf,
 		buf->vb.vb2_buf.index,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 71a80e2..07baa74 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -105,7 +105,7 @@ void cx23885_video_wakeup(struct cx23885_dev *dev,
 			struct cx23885_buffer, queue);
 
 	buf->vb.sequence = q->count++;
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 	dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf,
 			buf->vb.vb2_buf.index, count, q->count);
 	list_del(&buf->queue);
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 26e3e29..805e35b 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -130,7 +130,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 			buf = list_entry(dmaq->active.next,
 					 struct cx25821_buffer, queue);
 
-			v4l2_get_timestamp(&buf->vb.timestamp);
+			ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 			buf->vb.sequence = dmaq->count++;
 			list_del(&buf->queue);
 			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 9a43c78..c81dd34 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -518,7 +518,7 @@ void cx88_wakeup(struct cx88_core *core,
 
 	buf = list_entry(q->active.next,
 			 struct cx88_buffer, list);
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 	buf->vb.field = core->field;
 	buf->vb.sequence = q->count++;
 	list_del(&buf->list);
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index d84abde..72e79c5 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -271,7 +271,7 @@ static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 
 	spin_lock(&ipd->lock);
 	if (ipd->curr_buf && !list_empty(&ipd->dmaq)) {
-		v4l2_get_timestamp(&ipd->curr_buf->timestamp);
+		ktime_get_ts(&ipd->curr_buf->vb2_buf.timestamp);
 		ipd->curr_buf->sequence = ipd->sequence++;
 		ipd->curr_buf->field = V4L2_FIELD_NONE;
 		vb2_buffer_done(&ipd->curr_buf->vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 83c90d3..be72ddd 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -580,7 +580,7 @@ static void netup_unidvb_dma_worker(struct work_struct *work)
 			dev_dbg(&ndev->pci_dev->dev,
 				"%s(): buffer %p done, size %d\n",
 				__func__, buf, buf->size);
-			v4l2_get_timestamp(&buf->vb.timestamp);
+			ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->size);
 			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 		}
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 87f39f9..4b93268 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -309,7 +309,7 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 	core_dbg("buffer_finish %p\n", q->curr);
 
 	/* finish current buffer */
-	v4l2_get_timestamp(&q->curr->vb2.timestamp);
+	ktime_get_ts(&q->curr->vb2.vb2_buf.timestamp);
 	q->curr->vb2.sequence = q->seq_nr++;
 	vb2_buffer_done(&q->curr->vb2.vb2_buf, state);
 	q->curr = NULL;
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 1bd2fd4..f2e0e78 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -531,8 +531,8 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 
 	if (!ret) {
 		vbuf->sequence = solo_enc->sequence++;
-		vbuf->timestamp.tv_sec = vop_sec(vh);
-		vbuf->timestamp.tv_usec = vop_usec(vh);
+		vb->timestamp.tv_sec = vop_sec(vh);
+		vb->timestamp.tv_nsec = vop_usec(vh) * NSEC_PER_USEC;
 
 		/* Check for motion flags */
 		if (solo_is_motion_on(solo_enc) && enc_buf->motion) {
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 26df903..681e65b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -225,7 +225,7 @@ finish_buf:
 		vb2_set_plane_payload(vb, 0,
 			solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
 		vbuf->sequence = solo_dev->sequence++;
-		v4l2_get_timestamp(&vbuf->timestamp);
+		ktime_get_ts(&vb->timestamp);
 	}
 
 	vb2_buffer_done(vb, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 6367b45..e071be3 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -817,7 +817,7 @@ static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
 		/* Disable acquisition */
 		reg_write(vip, DVP_CTL, reg_read(vip, DVP_CTL) & ~DVP_CTL_ENA);
 		/* Remove the active buffer from the list */
-		v4l2_get_timestamp(&vip->active->vb.timestamp);
+		ktime_get_ts(&vip->active->vb.vb2_buf.timestamp);
 		vip->active->vb.sequence = vip->sequence++;
 		vb2_buffer_done(&vip->active->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 4c3293d..56e0899 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -1016,7 +1016,7 @@ void tw68_irq_video_done(struct tw68_dev *dev, unsigned long status)
 		buf = list_entry(dev->active.next, struct tw68_buf, list);
 		list_del(&buf->list);
 		spin_unlock(&dev->slock);
-		v4l2_get_timestamp(&buf->vb.timestamp);
+		ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 		buf->vb.field = dev->field;
 		buf->vb.sequence = dev->seqnr++;
 		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index f0480d6..33a2820 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1281,7 +1281,7 @@ static inline void vpfe_schedule_bottom_field(struct vpfe_device *vpfe)
  */
 static inline void vpfe_process_buffer_complete(struct vpfe_device *vpfe)
 {
-	v4l2_get_timestamp(&vpfe->cur_frm->vb.timestamp);
+	ktime_get_ts(&vpfe->cur_frm->vb.vb2_buf.timestamp);
 	vpfe->cur_frm->vb.field = vpfe->fmt.fmt.pix.field;
 	vpfe->cur_frm->vb.sequence = vpfe->sequence++;
 	vb2_buffer_done(&vpfe->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 7764b9c..c15f3ee 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -406,7 +406,7 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 	spin_lock(&bcap_dev->lock);
 
 	if (!list_empty(&bcap_dev->dma_queue)) {
-		v4l2_get_timestamp(&vbuf->timestamp);
+		ktime_get_ts(&vb->timestamp);
 		if (ppi->err) {
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 			ppi->err = false;
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 654e964..21beb97 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -279,7 +279,7 @@ void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 			if (meta) {
 				meta->sequence = src_buf->sequence;
 				meta->timecode = src_buf->timecode;
-				meta->timestamp = src_buf->timestamp;
+				meta->timestamp = src_buf->vb2_buf.timestamp;
 				meta->start = start;
 				meta->end = ctx->bitstream_fifo.kfifo.in &
 					    ctx->bitstream_fifo.kfifo.mask;
@@ -1364,7 +1364,7 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 		dst_buf->flags &= ~V4L2_BUF_FLAG_KEYFRAME;
 	}
 
-	dst_buf->timestamp = src_buf->timestamp;
+	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
 	dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst_buf->flags |=
 		src_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
@@ -2040,7 +2040,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		dst_buf->flags |= ctx->frame_types[ctx->display_idx];
 		meta = &ctx->frame_metas[ctx->display_idx];
 		dst_buf->timecode = meta->timecode;
-		dst_buf->timestamp = meta->timestamp;
+		dst_buf->vb2_buf.timestamp = meta->timestamp;
 
 		trace_coda_dec_rot_done(ctx, dst_buf, meta);
 
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 96532b0..fc21362 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -138,7 +138,7 @@ struct coda_buffer_meta {
 	struct list_head	list;
 	u32			sequence;
 	struct v4l2_timecode	timecode;
-	struct timeval		timestamp;
+	struct timespec		timestamp;
 	u32			start;
 	u32			end;
 };
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 6d91422..6031e02 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -74,7 +74,7 @@ static void vpbe_isr_even_field(struct vpbe_display *disp_obj,
 	if (layer->cur_frm == layer->next_frm)
 		return;
 
-	v4l2_get_timestamp(&layer->cur_frm->vb.timestamp);
+	ktime_get_ts(&layer->cur_frm->vb.vb2_buf.timestamp);
 	vb2_buffer_done(&layer->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	/* Make cur_frm pointing to next_frm */
 	layer->cur_frm = layer->next_frm;
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index c1e573b..87c6eaa 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -331,7 +331,7 @@ static struct vb2_ops video_qops = {
  */
 static void vpif_process_buffer_complete(struct common_obj *common)
 {
-	v4l2_get_timestamp(&common->cur_frm->vb.timestamp);
+	ktime_get_ts(&common->cur_frm->vb.vb2_buf.timestamp);
 	vb2_buffer_done(&common->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	/* Make curFrm pointing to nextFrm */
 	common->cur_frm = common->next_frm;
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index fd27803..4390f54 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -330,7 +330,7 @@ static void process_interlaced_mode(int fid, struct common_obj *common)
 		/* one frame is displayed If next frame is
 		 *  available, release cur_frm and move on */
 		/* Copy frame display time */
-		v4l2_get_timestamp(&common->cur_frm->vb.timestamp);
+		ktime_get_ts(&common->cur_frm->vb.vb2_buf.timestamp);
 		/* Change status of the cur_frm */
 		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_DONE);
@@ -386,8 +386,8 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 			if (!channel_first_int[i][channel_id]) {
 				/* Mark status of the cur_frm to
 				 * done and unlock semaphore on it */
-				v4l2_get_timestamp(
-					&common->cur_frm->vb.timestamp);
+				ktime_get_ts(
+					&common->cur_frm->vb.vb2_buf.timestamp);
 				vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 						VB2_BUF_STATE_DONE);
 				/* Make cur_frm pointing to next_frm */
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index d82e717..70bf10f 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -86,7 +86,7 @@ void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
 	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
 	if (src_vb && dst_vb) {
-		dst_vb->timestamp = src_vb->timestamp;
+		dst_vb->vb2_buf.timestamp = src_vb->vb2_buf.timestamp;
 		dst_vb->timecode = src_vb->timecode;
 		dst_vb->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 		dst_vb->flags |=
@@ -125,7 +125,7 @@ static int gsc_get_bufs(struct gsc_ctx *ctx)
 	if (ret)
 		return ret;
 
-	dst_vb->timestamp = src_vb->timestamp;
+	dst_vb->vb2_buf.timestamp = src_vb->vb2_buf.timestamp;
 
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 99e5732..b5cfe80 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -193,7 +193,7 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 	    test_bit(ST_CAPT_RUN, &fimc->state) && deq_buf) {
 		v_buf = fimc_active_queue_pop(cap);
 
-		v4l2_get_timestamp(&v_buf->vb.timestamp);
+		ktime_get_ts(&v_buf->vb.vb2_buf.timestamp);
 		v_buf->vb.sequence = cap->frame_count++;
 
 		vb2_buffer_done(&v_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 6e66484..18609ab 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -254,7 +254,7 @@ void fimc_isp_video_irq_handler(struct fimc_is *is)
 	buf_index = (is->i2h_cmd.args[1] - 1) % video->buf_count;
 	vbuf = &video->buffers[buf_index]->vb;
 
-	v4l2_get_timestamp(&vbuf->timestamp);
+	ktime_get_ts(&vbuf->vb2_buf.timestamp);
 	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 
 	video->buf_mask &= ~BIT(buf_index);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 60660c3..f91c550 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -292,7 +292,7 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 	    test_bit(ST_FLITE_RUN, &fimc->state) &&
 	    !list_empty(&fimc->active_buf_q)) {
 		vbuf = fimc_lite_active_queue_pop(fimc);
-		v4l2_get_timestamp(&vbuf->vb.timestamp);
+		ktime_get_ts(&vbuf->vb.vb2_buf.timestamp);
 		vbuf->vb.sequence = fimc->frame_count++;
 		flite_hw_mask_dma_buffer(fimc, vbuf->index);
 		vb2_buffer_done(&vbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 4d1d64a4..0d72b50 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -132,7 +132,7 @@ static void fimc_device_run(void *priv)
 	if (ret)
 		goto dma_unlock;
 
-	dst_vb->timestamp = src_vb->timestamp;
+	dst_vb->vb2_buf.timestamp = src_vb->vb2_buf.timestamp;
 	dst_vb->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst_vb->flags |=
 		src_vb->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 29973f9..e27fb82 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -207,7 +207,7 @@ static void dma_callback(void *data)
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
-	dst_vb->timestamp = src_vb->timestamp;
+	dst_vb->vb2_buf.timestamp = src_vb->vb2_buf.timestamp;
 	dst_vb->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst_vb->flags |=
 		src_vb->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index aa2b440..9f0f85c 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -226,7 +226,7 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
 	vbuf->vb2_buf.planes[0].bytesused = cam->pix_format.sizeimage;
 	vbuf->sequence = cam->buf_seq[frame];
 	vbuf->field = V4L2_FIELD_NONE;
-	v4l2_get_timestamp(&vbuf->timestamp);
+	ktime_get_ts(&vbuf->vb2_buf.timestamp);
 	vb2_set_plane_payload(&vbuf->vb2_buf, 0, cam->pix_format.sizeimage);
 	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 }
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 03a1b60..e0e36ea 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -375,7 +375,7 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 			src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 			dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
-			dst_vb->timestamp = src_vb->timestamp;
+			dst_vb->vb2_buf.timestamp = src_vb->vb2_buf.timestamp;
 			dst_vb->flags &=
 				~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 			dst_vb->flags |=
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index f4f5916..81a74a5 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -467,7 +467,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	list_del(&buf->irqlist);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index f8e3e83..6e0871b 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1560,7 +1560,7 @@ static irqreturn_t jpu_irq_handler(int irq, void *dev_id)
 		}
 
 		dst_buf->field = src_buf->field;
-		dst_buf->timestamp = src_buf->timestamp;
+		dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
 		if (src_buf->flags & V4L2_BUF_FLAG_TIMECODE)
 			dst_buf->timecode = src_buf->timecode;
 		dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 537b858..6921fb3 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -338,7 +338,7 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
 
 		if (!WARN_ON(vbuf == NULL)) {
 			/* Dequeue a filled buffer */
-			v4l2_get_timestamp(&vbuf->vb.timestamp);
+			ktime_get_ts(&vbuf->vb.vb2_buf.timestamp);
 			vbuf->vb.sequence = vp->frame_sequence++;
 			vb2_buffer_done(&vbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index e1936d9..658e091 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -552,7 +552,7 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 	BUG_ON(dst == NULL);
 
 	dst->timecode = src->timecode;
-	dst->timestamp = src->timestamp;
+	dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
 	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst->flags |=
 		src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 4a608cb..e9b0e32 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2621,7 +2621,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 	}
 
 	dst_buf->timecode = src_buf->timecode;
-	dst_buf->timestamp = src_buf->timestamp;
+	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
 	dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst_buf->flags |=
 		src_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
@@ -2752,7 +2752,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
 
 	dst_buf->timecode = src_buf->timecode;
-	dst_buf->timestamp = src_buf->timestamp;
+	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
 
 	v4l2_m2m_buf_done(src_buf, state);
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3ffe2ec..0effb2f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -233,8 +233,8 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 				== dec_y_addr) {
 			dst_buf->b->timecode =
 						src_buf->b->timecode;
-			dst_buf->b->timestamp =
-						src_buf->b->timestamp;
+			dst_buf->b->vb2_buf.timestamp =
+						src_buf->b->vb2_buf.timestamp;
 			dst_buf->b->flags &=
 				~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 			dst_buf->b->flags |=
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index d6ab33e..720e40c 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -1107,7 +1107,7 @@ static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 	if (!src || !dst)
 		return IRQ_NONE;
 
-	dst->timestamp = src->timestamp;
+	dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
 	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst->flags |=
 		src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 2231f89..ee880cc 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1071,7 +1071,7 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 
 	list_del(&vb->list);
 
-	v4l2_get_timestamp(&vb->vb.timestamp);
+	ktime_get_ts(&vb->vb.vb2_buf.timestamp);
 	vb->vb.sequence = vou_dev->sequence++;
 	vb->vb.field = V4L2_FIELD_INTERLACED;
 	vb2_buffer_done(&vb->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 454f68f..06a2663 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -165,7 +165,7 @@ static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 		struct frame_buffer *buf = isi->active;
 
 		list_del_init(&buf->list);
-		v4l2_get_timestamp(&vbuf->timestamp);
+		ktime_get_ts(&vbuf->vb2_buf.timestamp);
 		vbuf->sequence = isi->sequence++;
 		vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 	}
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 1f28d21..ffa417b 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1351,7 +1351,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 				vb2_get_plane_payload(vb, 0));
 
 		list_del_init(&buf->internal.queue);
-		v4l2_get_timestamp(&vbuf->timestamp);
+		ktime_get_ts(&vb->timestamp);
 		vbuf->sequence = pcdev->frame_count;
 		if (err)
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 49c3a25..80a0e45 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -155,7 +155,7 @@ static void mx3_cam_dma_done(void *arg)
 		struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 
 		list_del_init(&buf->queue);
-		v4l2_get_timestamp(&vb->timestamp);
+		ktime_get_ts(&vb->vb2_buf.timestamp);
 		vb->field = mx3_cam->field;
 		vb->sequence = mx3_cam->sequence++;
 		vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index efe57b2..1dad8db 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -912,7 +912,7 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
 
 		priv->queue_buf[slot]->field = priv->field;
 		priv->queue_buf[slot]->sequence = priv->sequence++;
-		v4l2_get_timestamp(&priv->queue_buf[slot]->timestamp);
+		ktime_get_ts(&priv->queue_buf[slot]->vb2_buf.timestamp);
 		vb2_buffer_done(&priv->queue_buf[slot]->vb2_buf,
 				VB2_BUF_STATE_DONE);
 		priv->queue_buf[slot] = NULL;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 67a669d..13107c8 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -533,7 +533,7 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 		pcdev->active = NULL;
 
 	ret = sh_mobile_ceu_capture(pcdev);
-	v4l2_get_timestamp(&vbuf->timestamp);
+	ktime_get_ts(&vbuf->vb2_buf.timestamp);
 	if (!ret) {
 		vbuf->field = pcdev->field;
 		vbuf->sequence = pcdev->sequence++;
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index a0d267e..ad122cc 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -191,7 +191,7 @@ static void bdisp_job_finish(struct bdisp_ctx *ctx, int vb_state)
 	dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 
 	if (src_vb && dst_vb) {
-		dst_vb->timestamp = src_vb->timestamp;
+		dst_vb->vb2_buf.timestamp = src_vb->vb2_buf.timestamp;
 		dst_vb->timecode = src_vb->timecode;
 		dst_vb->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 		dst_vb->flags |= src_vb->flags &
@@ -297,7 +297,7 @@ static int bdisp_get_bufs(struct bdisp_ctx *ctx)
 	if (ret)
 		return ret;
 
-	dst_vb->timestamp = src_vb->timestamp;
+	dst_vb->vb2_buf.timestamp = src_vb->vb2_buf.timestamp;
 
 	return 0;
 }
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index de24eff..83acb83 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1288,7 +1288,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	d_vb = ctx->dst_vb;
 
 	d_vb->flags = s_vb->flags;
-	d_vb->timestamp = s_vb->timestamp;
+	d_vb->vb2_buf.timestamp = s_vb->vb2_buf.timestamp;
 
 	if (s_vb->flags & V4L2_BUF_FLAG_TIMECODE)
 		d_vb->timecode = s_vb->timecode;
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e18fb9f..06a0e04 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -235,7 +235,7 @@ static int device_process(struct vim2m_ctx *ctx,
 	out_vb->sequence =
 		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
 	in_vb->sequence = q_data->sequence++;
-	out_vb->timestamp = in_vb->timestamp;
+	out_vb->vb2_buf.timestamp = in_vb->vb2_buf.timestamp;
 
 	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
 		out_vb->timecode = in_vb->timecode;
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 83cc6d3..9b39257 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -441,7 +441,7 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	 * "Start of Exposure".
 	 */
 	if (dev->tstamp_src_is_soe)
-		v4l2_get_timestamp(&buf->vb.timestamp);
+		ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
 		/*
 		 * 60 Hz standards start with the bottom field, 50 Hz standards
@@ -558,8 +558,8 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	 * the timestamp now.
 	 */
 	if (!dev->tstamp_src_is_soe)
-		v4l2_get_timestamp(&buf->vb.timestamp);
-	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		ktime_get_ts(&buf->vb.vb2_buf.timestamp);
+	buf->vb.vb2_buf.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
 /*
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index c2c46dc..705764a 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -95,8 +95,8 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 			 */
 			vid_out_buf->vb.sequence /= 2;
 		}
-		v4l2_get_timestamp(&vid_out_buf->vb.timestamp);
-		vid_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		ktime_get_ts(&vid_out_buf->vb.vb2_buf.timestamp);
+		vid_out_buf->vb.vb2_buf.timestamp.tv_sec += dev->time_wrap_offset;
 		vb2_buffer_done(&vid_out_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_out buffer %d done\n",
@@ -108,8 +108,8 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 			vivid_sliced_vbi_out_process(dev, vbi_out_buf);
 
 		vbi_out_buf->vb.sequence = dev->vbi_out_seq_count;
-		v4l2_get_timestamp(&vbi_out_buf->vb.timestamp);
-		vbi_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		ktime_get_ts(&vbi_out_buf->vb.vb2_buf.timestamp);
+		vbi_out_buf->vb.vb2_buf.timestamp.tv_sec += dev->time_wrap_offset;
 		vb2_buffer_done(&vbi_out_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_out buffer %d done\n",
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 082c401..6e4796e 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -117,8 +117,9 @@ static void vivid_thread_sdr_cap_tick(struct vivid_dev *dev)
 	if (sdr_cap_buf) {
 		sdr_cap_buf->vb.sequence = dev->sdr_cap_seq_count;
 		vivid_sdr_cap_process(dev, sdr_cap_buf);
-		v4l2_get_timestamp(&sdr_cap_buf->vb.timestamp);
-		sdr_cap_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		ktime_get_ts(&sdr_cap_buf->vb.vb2_buf.timestamp);
+		sdr_cap_buf->vb.vb2_buf.timestamp.tv_sec +=
+					dev->time_wrap_offset;
 		vb2_buffer_done(&sdr_cap_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dev->dqbuf_error = false;
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index e903d02..40c67c8 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -108,8 +108,8 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
 		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
-	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
+	buf->vb.vb2_buf.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
 
@@ -133,8 +133,8 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev,
 			vbuf[i] = dev->vbi_gen.data[i];
 	}
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
-	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
+	buf->vb.vb2_buf.timestamp.tv_sec += dev->time_wrap_offset;
 }
 
 static int vbi_cap_queue_setup(struct vb2_queue *vq, const void *parg,
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 5ce88e1..bd88c73 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -611,7 +611,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
 	done->buf.sequence = video->sequence++;
-	v4l2_get_timestamp(&done->buf.timestamp);
+	ktime_get_ts(&done->buf.vb2_buf.timestamp);
 	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
 		vb2_set_plane_payload(&done->buf.vb2_buf, i, done->length[i]);
 	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index d11cc70..61f5fab 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -303,7 +303,7 @@ static void xvip_dma_complete(void *param)
 
 	buf->buf.field = V4L2_FIELD_NONE;
 	buf->buf.sequence = dma->sequence++;
-	v4l2_get_timestamp(&buf->buf.timestamp);
+	ktime_get_ts(&buf->buf.vb2_buf.timestamp);
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, dma->format.sizeimage);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 }
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index fcbb497..d1613ff 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -316,7 +316,7 @@ static void airspy_urb_complete(struct urb *urb)
 		len = airspy_convert_stream(s, ptr, urb->transfer_buffer,
 				urb->actual_length);
 		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
-		v4l2_get_timestamp(&fbuf->vb.timestamp);
+		ktime_get_ts(&fbuf->vb.vb2_buf.timestamp);
 		fbuf->vb.sequence = s->sequence++;
 		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 45c622e..a4c4691 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -314,7 +314,7 @@ static inline void buffer_filled(struct au0828_dev *dev,
 		vb->sequence = dev->vbi_frame_count++;
 
 	vb->field = V4L2_FIELD_INTERLACED;
-	v4l2_get_timestamp(&vb->timestamp);
+	ktime_get_ts(&vb->vb2_buf.timestamp);
 	vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 }
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6a3cf34..dd48e16 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -438,7 +438,7 @@ static inline void finish_buffer(struct em28xx *dev,
 		buf->vb.field = V4L2_FIELD_NONE;
 	else
 		buf->vb.field = V4L2_FIELD_INTERLACED;
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 
 	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index ae1cfa7..e885941 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -466,7 +466,7 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
 	else
 		go7007_set_motion_regions(go, vb, 0);
 
-	v4l2_get_timestamp(&vb->vb.timestamp);
+	ktime_get_ts(&vb->vb.vb2_buf.timestamp);
 	vb_tmp = vb;
 	spin_lock(&go->spinlock);
 	list_del(&vb->list);
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index e05bfec..b20d9aa6a 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -517,7 +517,7 @@ static void hackrf_urb_complete_in(struct urb *urb)
 		    urb->transfer_buffer, len);
 	vb2_set_plane_payload(&buffer->vb.vb2_buf, 0, len);
 	buffer->vb.sequence = dev->sequence++;
-	v4l2_get_timestamp(&buffer->vb.timestamp);
+	ktime_get_ts(&buffer->vb.vb2_buf.timestamp);
 	vb2_buffer_done(&buffer->vb.vb2_buf, VB2_BUF_STATE_DONE);
 exit_usb_submit_urb:
 	usb_submit_urb(urb, GFP_ATOMIC);
@@ -562,7 +562,7 @@ static void hackrf_urb_complete_out(struct urb *urb)
 			   vb2_plane_vaddr(&buffer->vb.vb2_buf, 0), len);
 	urb->actual_length = len;
 	buffer->vb.sequence = dev->sequence++;
-	v4l2_get_timestamp(&buffer->vb.timestamp);
+	ktime_get_ts(&buffer->vb.vb2_buf.timestamp);
 	vb2_buffer_done(&buffer->vb.vb2_buf, VB2_BUF_STATE_DONE);
 exit_usb_submit_urb:
 	usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index b79c36f..614c74b 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -316,8 +316,7 @@ static void pwc_isoc_handler(struct urb *urb)
 			struct pwc_frame_buf *fbuf = pdev->fill_buf;
 
 			if (pdev->vsync == 1) {
-				v4l2_get_timestamp(
-					&fbuf->vb.timestamp);
+				ktime_get_ts(&fbuf->vb.vb2_buf.timestamp);
 				pdev->vsync = 2;
 			}
 
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index e7acb12..1bc3a70 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -574,7 +574,7 @@ static void s2255_got_frame(struct s2255_vc *vc, int jpgsize)
 	buf = list_entry(vc->buf_list.next,
 			 struct s2255_buffer, list);
 	list_del(&buf->list);
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 	buf->vb.field = vc->field;
 	buf->vb.sequence = vc->frame_count;
 	spin_unlock_irqrestore(&vc->qlock, flags);
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 75654e6..eb1abd6 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -99,7 +99,7 @@ void stk1160_buffer_done(struct stk1160 *dev)
 	buf->vb.sequence = dev->sequence++;
 	buf->vb.field = V4L2_FIELD_INTERLACED;
 	buf->vb.vb2_buf.planes[0].bytesused = buf->bytesused;
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 
 	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index e645c9d..cb4486ca 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -322,7 +322,7 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 
 		buf->vb.field = V4L2_FIELD_INTERLACED;
 		buf->vb.sequence = usbtv->sequence++;
-		v4l2_get_timestamp(&buf->vb.timestamp);
+		ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 		vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 		vb2_buffer_done(&buf->vb.vb2_buf, state);
 		list_del(&buf->list);
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 2b276ab..1cb766c 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -699,14 +699,13 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 		  stream->dev->name,
 		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
 		  y, ts.tv_sec, ts.tv_nsec / NSEC_PER_USEC,
-		  vbuf->timestamp.tv_sec,
-		  (unsigned long)vbuf->timestamp.tv_usec,
+		  vbuf->vb2_buf.timestamp.tv_sec,
+		  (unsigned long)vbuf->vb2_buf.timestamp.tv_nsec,
 		  x1, first->host_sof, first->dev_sof,
 		  x2, last->host_sof, last->dev_sof, y1, y2);
 
 	/* Update the V4L2 buffer. */
-	vbuf->timestamp.tv_sec = ts.tv_sec;
-	vbuf->timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	vbuf->vb2_buf.timestamp = ts;
 
 done:
 	spin_unlock_irqrestore(&stream->clock.lock, flags);
@@ -1034,9 +1033,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 
 		buf->buf.field = V4L2_FIELD_NONE;
 		buf->buf.sequence = stream->sequence;
-		buf->buf.timestamp.tv_sec = ts.tv_sec;
-		buf->buf.timestamp.tv_usec =
-			ts.tv_nsec / NSEC_PER_USEC;
+		buf->buf.vb2_buf.timestamp = ts;
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 27b4b9e..2552250 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -119,8 +119,11 @@ static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
 		 * and the timecode field and flag if needed.
 		 */
 		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
-				V4L2_BUF_FLAG_TIMESTAMP_COPY)
-			vbuf->timestamp = b->timestamp;
+				V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+			vb->timestamp.tv_sec = b->timestamp.tv_sec;
+			vb->timestamp.tv_nsec
+				= b->timestamp.tv_usec * NSEC_PER_USEC;
+		}
 		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
 			vbuf->timecode = b->timecode;
@@ -191,7 +194,8 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 
 	b->flags = vbuf->flags;
 	b->field = vbuf->field;
-	b->timestamp = vbuf->timestamp;
+	b->timestamp.tv_sec = vb->timestamp.tv_sec;
+	b->timestamp.tv_usec = vb->timestamp.tv_nsec / NSEC_PER_USEC;
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
 	b->reserved2 = 0;
@@ -308,8 +312,8 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 					"for an output buffer\n");
 		return -EINVAL;
 	}
-	vbuf->timestamp.tv_sec = 0;
-	vbuf->timestamp.tv_usec = 0;
+	vb->timestamp.tv_sec = 0;
+	vb->timestamp.tv_nsec = 0;
 	vbuf->sequence = 0;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 0fdff91..d7577eb 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -470,7 +470,7 @@ void vpfe_video_process_buffer_complete(struct vpfe_video_device *video)
 {
 	struct vpfe_pipeline *pipe = &video->pipe;
 
-	v4l2_get_timestamp(&video->cur_frm->vb.timestamp);
+	ktime_get_ts(&video->cur_frm->vb.vb2_buf.timestamp);
 	vb2_buffer_done(&video->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
 		video->cur_frm = video->next_frm;
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 28c067d..91e0074 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -435,7 +435,7 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	list_del(&buf->list);
 	spin_unlock_irqrestore(&video->qlock, flags);
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	ktime_get_ts(&buf->vb.vb2_buf.timestamp);
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 51d4a17..34525dc 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -329,7 +329,7 @@ struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
 
 	buf->buf.field = V4L2_FIELD_NONE;
 	buf->buf.sequence = queue->sequence++;
-	v4l2_get_timestamp(&buf->buf.timestamp);
+	ktime_get_ts(&buf->buf.vb2_buf.timestamp);
 
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 647ebfe..3fe6600 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -211,6 +211,7 @@ struct vb2_queue;
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue
  * @planes:		private per-plane information; do not change
+ * @timestamp:		frame timestamp
  */
 struct vb2_buffer {
 	struct vb2_queue	*vb2_queue;
@@ -219,6 +220,7 @@ struct vb2_buffer {
 	unsigned int		memory;
 	unsigned int		num_planes;
 	struct vb2_plane	planes[VB2_MAX_PLANES];
+	struct timespec		timestamp;
 
 	/* private: internal use only
 	 *
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 5abab1e..110062e 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -28,7 +28,6 @@
  * @vb2_buf:	video buffer 2
  * @flags:	buffer informational flags
  * @field:	enum v4l2_field; field order of the image in the buffer
- * @timestamp:	frame timestamp
  * @timecode:	frame timecode
  * @sequence:	sequence count of this frame
  * Should contain enough information to be able to cover all the fields
@@ -39,7 +38,6 @@ struct vb2_v4l2_buffer {
 
 	__u32			flags;
 	__u32			field;
-	struct timeval		timestamp;
 	struct v4l2_timecode	timecode;
 	__u32			sequence;
 };
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index 22afa26..e37f8ec 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -205,7 +205,7 @@ DECLARE_EVENT_CLASS(vb2_v4l2_event_class,
 		__entry->minor = owner ? owner->vdev->minor : -1;
 		__entry->flags = vbuf->flags;
 		__entry->field = vbuf->field;
-		__entry->timestamp = timeval_to_ns(&vbuf->timestamp);
+		__entry->timestamp = timespec_to_ns(&vb->timestamp);
 		__entry->timecode_type = vbuf->timecode.type;
 		__entry->timecode_flags = vbuf->timecode.flags;
 		__entry->timecode_frames = vbuf->timecode.frames;
diff --git a/include/trace/events/vb2.h b/include/trace/events/vb2.h
index bfeceeb..f449f81 100644
--- a/include/trace/events/vb2.h
+++ b/include/trace/events/vb2.h
@@ -18,6 +18,7 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 		__field(u32, index)
 		__field(u32, type)
 		__field(u32, bytesused)
+		__field(s64, timestamp)
 	),
 
 	TP_fast_assign(
@@ -28,14 +29,16 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 		__entry->index = vb->index;
 		__entry->type = vb->type;
 		__entry->bytesused = vb->planes[0].bytesused;
+		__entry->timestamp = timespec_to_ns(&vb->timestamp);
 	),
 
 	TP_printk("owner = %p, queued = %u, owned_by_drv = %d, index = %u, "
-		  "type = %u, bytesused = %u", __entry->owner,
+		  "type = %u, bytesused = %u, timestamp = %llu", __entry->owner,
 		  __entry->queued_count,
 		  __entry->owned_by_drv_count,
 		  __entry->index, __entry->type,
-		  __entry->bytesused
+		  __entry->bytesused,
+		  __entry->timestamp
 	)
 )
 
-- 
1.7.9.5

