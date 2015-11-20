Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:42333 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760712AbbKTQeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:34:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Geunyoung Kim <nenggun.kim@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv10 03/15] media: videobuf2: Move timestamp to vb2_buffer
Date: Fri, 20 Nov 2015 17:34:06 +0100
Message-Id: <1448037258-36305-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Junghak Sung <jh1009.sung@samsung.com>

Move timestamp from struct vb2_v4l2_buffer to struct vb2_buffer
for common use, and change its type to u64 in order to handling
y2038 problem. This patch also includes all device drivers' changes related to
this restructuring.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/input/touchscreen/sur40.c                        |  2 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c                |  2 +-
 drivers/media/pci/cobalt/cobalt-irq.c                    |  2 +-
 drivers/media/pci/cx23885/cx23885-core.c                 |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c                |  2 +-
 drivers/media/pci/cx25821/cx25821-video.c                |  2 +-
 drivers/media/pci/cx88/cx88-core.c                       |  2 +-
 drivers/media/pci/dt3155/dt3155.c                        |  2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c       |  2 +-
 drivers/media/pci/saa7134/saa7134-core.c                 |  2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c           |  2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c               |  2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c                  |  2 +-
 drivers/media/pci/tw68/tw68-video.c                      |  2 +-
 drivers/media/platform/am437x/am437x-vpfe.c              |  2 +-
 drivers/media/platform/blackfin/bfin_capture.c           |  2 +-
 drivers/media/platform/coda/coda-bit.c                   |  6 +++---
 drivers/media/platform/coda/coda.h                       |  2 +-
 drivers/media/platform/davinci/vpbe_display.c            |  2 +-
 drivers/media/platform/davinci/vpif_capture.c            |  2 +-
 drivers/media/platform/davinci/vpif_display.c            |  6 +++---
 drivers/media/platform/exynos-gsc/gsc-m2m.c              |  4 ++--
 drivers/media/platform/exynos4-is/fimc-capture.c         |  2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c       |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c            |  2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c             |  2 +-
 drivers/media/platform/m2m-deinterlace.c                 |  2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c          |  2 +-
 drivers/media/platform/mx2_emmaprp.c                     |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c               |  2 +-
 drivers/media/platform/rcar_jpu.c                        |  2 +-
 drivers/media/platform/s3c-camif/camif-capture.c         |  2 +-
 drivers/media/platform/s5p-g2d/g2d.c                     |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c              |  4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc.c                 |  4 ++--
 drivers/media/platform/sh_veu.c                          |  2 +-
 drivers/media/platform/sh_vou.c                          |  2 +-
 drivers/media/platform/soc_camera/atmel-isi.c            |  2 +-
 drivers/media/platform/soc_camera/mx2_camera.c           |  2 +-
 drivers/media/platform/soc_camera/mx3_camera.c           |  2 +-
 drivers/media/platform/soc_camera/rcar_vin.c             |  2 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c            |  4 ++--
 drivers/media/platform/ti-vpe/vpe.c                      |  2 +-
 drivers/media/platform/vim2m.c                           |  2 +-
 drivers/media/platform/vivid/vivid-core.h                |  2 +-
 drivers/media/platform/vivid/vivid-ctrls.c               | 14 +++++++++++---
 drivers/media/platform/vivid/vivid-kthread-cap.c         |  6 +++---
 drivers/media/platform/vivid/vivid-kthread-out.c         |  8 ++++----
 drivers/media/platform/vivid/vivid-sdr-cap.c             |  4 ++--
 drivers/media/platform/vivid/vivid-vbi-cap.c             |  6 ++----
 drivers/media/platform/vsp1/vsp1_video.c                 |  2 +-
 drivers/media/platform/xilinx/xilinx-dma.c               |  2 +-
 drivers/media/usb/airspy/airspy.c                        |  2 +-
 drivers/media/usb/au0828/au0828-video.c                  |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c                  |  2 +-
 drivers/media/usb/go7007/go7007-driver.c                 |  2 +-
 drivers/media/usb/hackrf/hackrf.c                        |  4 ++--
 drivers/media/usb/pwc/pwc-if.c                           |  3 +--
 drivers/media/usb/s2255/s2255drv.c                       |  2 +-
 drivers/media/usb/stk1160/stk1160-video.c                |  2 +-
 drivers/media/usb/usbtv/usbtv-video.c                    |  2 +-
 drivers/media/usb/uvc/uvc_video.c                        | 15 +++++----------
 drivers/media/v4l2-core/videobuf2-v4l2.c                 |  7 +++----
 drivers/staging/media/davinci_vpfe/vpfe_video.c          |  2 +-
 drivers/staging/media/omap4iss/iss_video.c               |  2 +-
 drivers/usb/gadget/function/uvc_queue.c                  |  2 +-
 include/media/videobuf2-core.h                           |  2 ++
 include/media/videobuf2-v4l2.h                           |  2 --
 include/trace/events/v4l2.h                              |  4 ++--
 include/trace/events/vb2.h                               |  7 +++++--
 71 files changed, 108 insertions(+), 106 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 3f3e2b1..b6c4d03 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -444,7 +444,7 @@ static void sur40_process_video(struct sur40_state *sur40)
 		goto err_poll;
 
 	/* mark as finished */
-	v4l2_get_timestamp(&new_buf->vb.timestamp);
+	new_buf->vb.vb2_buf.timestamp = ktime_get_ns();
 	new_buf->vb.sequence = sur40->sequence++;
 	new_buf->vb.field = V4L2_FIELD_NONE;
 	vb2_buffer_done(&new_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 238191d..b860f02 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -310,7 +310,7 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		len = rtl2832_sdr_convert_stream(dev, ptr, urb->transfer_buffer,
 				urb->actual_length);
 		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
-		v4l2_get_timestamp(&fbuf->vb.timestamp);
+		fbuf->vb.vb2_buf.timestamp = ktime_get_ns();
 		fbuf->vb.sequence = dev->sequence++;
 		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index c30748e..b190d4f 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -134,7 +134,7 @@ done:
 		skip = true;
 		s->skip_first_frames--;
 	}
-	v4l2_get_timestamp(&cb->vb.timestamp);
+	cb->vb.vb2_buf.timestamp = ktime_get_ns();
 	/* TODO: the sequence number should be read from the FPGA so we
 	   also know about dropped frames. */
 	cb->vb.sequence = s->sequence++;
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 35759a9..477778e 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -427,7 +427,7 @@ static void cx23885_wakeup(struct cx23885_tsport *port,
 	buf = list_entry(q->active.next,
 			 struct cx23885_buffer, queue);
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
 	buf->vb.sequence = q->count++;
 	dprintk(1, "[%p/%d] wakeup reg=%d buf=%d\n", buf,
 		buf->vb.vb2_buf.index,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 3cbee4c..90af327 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -105,7 +105,7 @@ void cx23885_video_wakeup(struct cx23885_dev *dev,
 			struct cx23885_buffer, queue);
 
 	buf->vb.sequence = q->count++;
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
 	dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf,
 			buf->vb.vb2_buf.index, count, q->count);
 	list_del(&buf->queue);
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 644373d..c48bba9 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -130,7 +130,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 			buf = list_entry(dmaq->active.next,
 					 struct cx25821_buffer, queue);
 
-			v4l2_get_timestamp(&buf->vb.timestamp);
+			buf->vb.vb2_buf.timestamp = ktime_get_ns();
 			buf->vb.sequence = dmaq->count++;
 			list_del(&buf->queue);
 			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 9a43c78..46fe8c1 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -518,7 +518,7 @@ void cx88_wakeup(struct cx88_core *core,
 
 	buf = list_entry(q->active.next,
 			 struct cx88_buffer, list);
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
 	buf->vb.field = core->field;
 	buf->vb.sequence = q->count++;
 	list_del(&buf->list);
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index f09bd73..568c0c8 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -270,7 +270,7 @@ static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 
 	spin_lock(&ipd->lock);
 	if (ipd->curr_buf && !list_empty(&ipd->dmaq)) {
-		v4l2_get_timestamp(&ipd->curr_buf->timestamp);
+		ipd->curr_buf->vb2_buf.timestamp = ktime_get_ns();
 		ipd->curr_buf->sequence = ipd->sequence++;
 		ipd->curr_buf->field = V4L2_FIELD_NONE;
 		vb2_buffer_done(&ipd->curr_buf->vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 2b20432..e7f0fda 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -579,7 +579,7 @@ static void netup_unidvb_dma_worker(struct work_struct *work)
 			dev_dbg(&ndev->pci_dev->dev,
 				"%s(): buffer %p done, size %d\n",
 				__func__, buf, buf->size);
-			v4l2_get_timestamp(&buf->vb.timestamp);
+			buf->vb.vb2_buf.timestamp = ktime_get_ns();
 			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->size);
 			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 		}
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index e79d63e..b41557d 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -309,7 +309,7 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 	core_dbg("buffer_finish %p\n", q->curr);
 
 	/* finish current buffer */
-	v4l2_get_timestamp(&q->curr->vb2.timestamp);
+	q->curr->vb2.vb2_buf.timestamp = ktime_get_ns();
 	q->curr->vb2.sequence = q->seq_nr++;
 	vb2_buffer_done(&q->curr->vb2.vb2_buf, state);
 	q->curr = NULL;
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 5b7853b..67a14c4 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -531,7 +531,7 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 
 	if (!ret) {
 		vbuf->sequence = solo_enc->sequence++;
-		v4l2_get_timestamp(&vbuf->timestamp);
+		vb->timestamp = ktime_get_ns();
 
 		/* Check for motion flags */
 		if (solo_is_motion_on(solo_enc) && enc_buf->motion) {
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 212d15e..721ff53 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -225,7 +225,7 @@ finish_buf:
 		vb2_set_plane_payload(vb, 0,
 			solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
 		vbuf->sequence = solo_dev->sequence++;
-		v4l2_get_timestamp(&vbuf->timestamp);
+		vb->timestamp = ktime_get_ns();
 	}
 
 	vb2_buffer_done(vb, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index b8b06fb..753411c 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -817,7 +817,7 @@ static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
 		/* Disable acquisition */
 		reg_write(vip, DVP_CTL, reg_read(vip, DVP_CTL) & ~DVP_CTL_ENA);
 		/* Remove the active buffer from the list */
-		v4l2_get_timestamp(&vip->active->vb.timestamp);
+		vip->active->vb.vb2_buf.timestamp = ktime_get_ns();
 		vip->active->vb.sequence = vip->sequence++;
 		vb2_buffer_done(&vip->active->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 2e71af1..07116a8 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -1016,7 +1016,7 @@ void tw68_irq_video_done(struct tw68_dev *dev, unsigned long status)
 		buf = list_entry(dev->active.next, struct tw68_buf, list);
 		list_del(&buf->list);
 		spin_unlock(&dev->slock);
-		v4l2_get_timestamp(&buf->vb.timestamp);
+		buf->vb.vb2_buf.timestamp = ktime_get_ns();
 		buf->vb.field = dev->field;
 		buf->vb.sequence = dev->seqnr++;
 		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index e434c8e..de32e3a 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1281,7 +1281,7 @@ static inline void vpfe_schedule_bottom_field(struct vpfe_device *vpfe)
  */
 static inline void vpfe_process_buffer_complete(struct vpfe_device *vpfe)
 {
-	v4l2_get_timestamp(&vpfe->cur_frm->vb.timestamp);
+	vpfe->cur_frm->vb.vb2_buf.timestamp = ktime_get_ns();
 	vpfe->cur_frm->vb.field = vpfe->fmt.fmt.pix.field;
 	vpfe->cur_frm->vb.sequence = vpfe->sequence++;
 	vb2_buffer_done(&vpfe->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 8ecc05a..d0092da 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -404,7 +404,7 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 	spin_lock(&bcap_dev->lock);
 
 	if (!list_empty(&bcap_dev->dma_queue)) {
-		v4l2_get_timestamp(&vbuf->timestamp);
+		vb->timestamp = ktime_get_ns();
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
index 96532b0..6cda81e 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -138,7 +138,7 @@ struct coda_buffer_meta {
 	struct list_head	list;
 	u32			sequence;
 	struct v4l2_timecode	timecode;
-	struct timeval		timestamp;
+	u64			timestamp;
 	u32			start;
 	u32			end;
 };
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 3fc2176..0abcdfe 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -74,7 +74,7 @@ static void vpbe_isr_even_field(struct vpbe_display *disp_obj,
 	if (layer->cur_frm == layer->next_frm)
 		return;
 
-	v4l2_get_timestamp(&layer->cur_frm->vb.timestamp);
+	layer->cur_frm->vb.vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&layer->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	/* Make cur_frm pointing to next_frm */
 	layer->cur_frm = layer->next_frm;
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index fad5b38..08f7028 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -330,7 +330,7 @@ static struct vb2_ops video_qops = {
  */
 static void vpif_process_buffer_complete(struct common_obj *common)
 {
-	v4l2_get_timestamp(&common->cur_frm->vb.timestamp);
+	common->cur_frm->vb.vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&common->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	/* Make curFrm pointing to nextFrm */
 	common->cur_frm = common->next_frm;
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 534b50a..f40755c 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -331,7 +331,7 @@ static void process_interlaced_mode(int fid, struct common_obj *common)
 		/* one frame is displayed If next frame is
 		 *  available, release cur_frm and move on */
 		/* Copy frame display time */
-		v4l2_get_timestamp(&common->cur_frm->vb.timestamp);
+		common->cur_frm->vb.vb2_buf.timestamp = ktime_get_ns();
 		/* Change status of the cur_frm */
 		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_DONE);
@@ -387,8 +387,8 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 			if (!channel_first_int[i][channel_id]) {
 				/* Mark status of the cur_frm to
 				 * done and unlock semaphore on it */
-				v4l2_get_timestamp(
-					&common->cur_frm->vb.timestamp);
+				common->cur_frm->vb.vb2_buf.timestamp =
+						ktime_get_ns();
 				vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 						VB2_BUF_STATE_DONE);
 				/* Make cur_frm pointing to next_frm */
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index ea9230e..93782f1 100644
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
index beadccb..0d549a6 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -193,7 +193,7 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 	    test_bit(ST_CAPT_RUN, &fimc->state) && deq_buf) {
 		v_buf = fimc_active_queue_pop(cap);
 
-		v4l2_get_timestamp(&v_buf->vb.timestamp);
+		v_buf->vb.vb2_buf.timestamp = ktime_get_ns();
 		v_buf->vb.sequence = cap->frame_count++;
 
 		vb2_buffer_done(&v_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 273e7a5..0dd22ec 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -251,7 +251,7 @@ void fimc_isp_video_irq_handler(struct fimc_is *is)
 	buf_index = (is->i2h_cmd.args[1] - 1) % video->buf_count;
 	vbuf = &video->buffers[buf_index]->vb;
 
-	v4l2_get_timestamp(&vbuf->timestamp);
+	vbuf->vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 
 	video->buf_mask &= ~BIT(buf_index);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 15d6fc9..639ee71 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -292,7 +292,7 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 	    test_bit(ST_FLITE_RUN, &fimc->state) &&
 	    !list_empty(&fimc->active_buf_q)) {
 		vbuf = fimc_lite_active_queue_pop(fimc);
-		v4l2_get_timestamp(&vbuf->vb.timestamp);
+		vbuf->vb.vb2_buf.timestamp = ktime_get_ns();
 		vbuf->vb.sequence = fimc->frame_count++;
 		flite_hw_mask_dma_buffer(fimc, vbuf->index);
 		vb2_buffer_done(&vbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 4c04b59..5aa857c 100644
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
index 652eebd..7383818 100644
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
index 7080a88..9b878de 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -226,7 +226,7 @@ static void mcam_buffer_done(struct mcam_camera *cam, int frame,
 	vbuf->vb2_buf.planes[0].bytesused = cam->pix_format.sizeimage;
 	vbuf->sequence = cam->buf_seq[frame];
 	vbuf->field = V4L2_FIELD_NONE;
-	v4l2_get_timestamp(&vbuf->timestamp);
+	vbuf->vb2_buf.timestamp = ktime_get_ns();
 	vb2_set_plane_payload(&vbuf->vb2_buf, 0, cam->pix_format.sizeimage);
 	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 }
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index cb7d4b5..3c4012d 100644
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
index 9cc4878..ecadca3 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -466,7 +466,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	list_del(&buf->irqlist);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 23dadae..3a9f512 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1565,7 +1565,7 @@ static irqreturn_t jpu_irq_handler(int irq, void *dev_id)
 		}
 
 		dst_buf->field = src_buf->field;
-		dst_buf->timestamp = src_buf->timestamp;
+		dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
 		if (src_buf->flags & V4L2_BUF_FLAG_TIMECODE)
 			dst_buf->timecode = src_buf->timecode;
 		dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 68e6512..ec3abbe 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -338,7 +338,7 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
 
 		if (!WARN_ON(vbuf == NULL)) {
 			/* Dequeue a filled buffer */
-			v4l2_get_timestamp(&vbuf->vb.timestamp);
+			vbuf->vb.vb2_buf.timestamp = ktime_get_ns();
 			vbuf->vb.sequence = vp->frame_sequence++;
 			vb2_buffer_done(&vbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 12b4415..74bd46c 100644
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
index 30440b0..c3b13a6 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2620,7 +2620,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 	}
 
 	dst_buf->timecode = src_buf->timecode;
-	dst_buf->timestamp = src_buf->timestamp;
+	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
 	dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst_buf->flags |=
 		src_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
@@ -2751,7 +2751,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
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
index 82c39f3..82b5d69 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -1094,7 +1094,7 @@ static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 	if (!src || !dst)
 		return IRQ_NONE;
 
-	dst->timestamp = src->timestamp;
+	dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
 	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst->flags |=
 		src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index fd0524e..1157404 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1070,7 +1070,7 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 
 	list_del(&vb->list);
 
-	v4l2_get_timestamp(&vb->vb.timestamp);
+	vb->vb.vb2_buf.timestamp = ktime_get_ns();
 	vb->vb.sequence = vou_dev->sequence++;
 	vb->vb.field = V4L2_FIELD_INTERLACED;
 	vb2_buffer_done(&vb->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index b78aa02..c398b28 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -214,7 +214,7 @@ static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 		struct frame_buffer *buf = isi->active;
 
 		list_del_init(&buf->list);
-		v4l2_get_timestamp(&vbuf->timestamp);
+		vbuf->vb2_buf.timestamp = ktime_get_ns();
 		vbuf->sequence = isi->sequence++;
 		vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 	}
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 4738048..05cb8ab 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1345,7 +1345,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 				vb2_get_plane_payload(vb, 0));
 
 		list_del_init(&buf->internal.queue);
-		v4l2_get_timestamp(&vbuf->timestamp);
+		vb->timestamp = ktime_get_ns();
 		vbuf->sequence = pcdev->frame_count;
 		if (err)
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 81895b7..eea069b 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -155,7 +155,7 @@ static void mx3_cam_dma_done(void *arg)
 		struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 
 		list_del_init(&buf->queue);
-		v4l2_get_timestamp(&vb->timestamp);
+		vb->vb2_buf.timestamp = ktime_get_ns();
 		vb->field = mx3_cam->field;
 		vb->sequence = mx3_cam->sequence++;
 		vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 068eaf7..6897328 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -884,7 +884,7 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
 
 		priv->queue_buf[slot]->field = priv->field;
 		priv->queue_buf[slot]->sequence = priv->sequence++;
-		v4l2_get_timestamp(&priv->queue_buf[slot]->timestamp);
+		priv->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
 		vb2_buffer_done(&priv->queue_buf[slot]->vb2_buf,
 				VB2_BUF_STATE_DONE);
 		priv->queue_buf[slot] = NULL;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 4e9bc04..90c87f2 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -510,7 +510,7 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 		pcdev->active = NULL;
 
 	ret = sh_mobile_ceu_capture(pcdev);
-	v4l2_get_timestamp(&vbuf->timestamp);
+	vbuf->vb2_buf.timestamp = ktime_get_ns();
 	if (!ret) {
 		vbuf->field = pcdev->field;
 		vbuf->sequence = pcdev->sequence++;
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 81871d6..d12a419 100644
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
index e8ed265..1fa00c2 100644
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
index 93e1d25..418113c 100644
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
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 8c7a5ba..751c1ba 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -286,7 +286,7 @@ struct vivid_dev {
 	bool				dqbuf_error;
 	bool				seq_wrap;
 	bool				time_wrap;
-	__kernel_time_t			time_wrap_offset;
+	u64				time_wrap_offset;
 	unsigned			perc_dropped_buffers;
 	enum vivid_signal_mode		std_signal_mode;
 	unsigned			query_std_last;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 4ab7c4b..b98089c 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -954,7 +954,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_has_scaler_out = {
 static int vivid_streaming_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vivid_dev *dev = container_of(ctrl->handler, struct vivid_dev, ctrl_hdl_streaming);
-	struct timeval tv;
+	u64 rem;
 
 	switch (ctrl->id) {
 	case VIVID_CID_DQBUF_ERROR:
@@ -993,8 +993,16 @@ static int vivid_streaming_s_ctrl(struct v4l2_ctrl *ctrl)
 			dev->time_wrap_offset = 0;
 			break;
 		}
-		v4l2_get_timestamp(&tv);
-		dev->time_wrap_offset = -tv.tv_sec - 16;
+		/*
+		 * We want to set the time 16 seconds before the 32 bit tv_sec
+		 * value of struct timeval would wrap around. So first we
+		 * calculate ktime_get_ns() % ((1 << 32) * NSEC_PER_SEC), and
+		 * then we set the offset to ((1 << 32) - 16) * NSEC_PER_SEC).
+		 */
+		div64_u64_rem(ktime_get_ns(),
+			0x100000000ULL * NSEC_PER_SEC, &rem);
+		dev->time_wrap_offset =
+			(0x100000000ULL - 16) * NSEC_PER_SEC - rem;
 		break;
 	}
 	return 0;
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 83cc6d3..9034281 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -441,7 +441,7 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	 * "Start of Exposure".
 	 */
 	if (dev->tstamp_src_is_soe)
-		v4l2_get_timestamp(&buf->vb.timestamp);
+		buf->vb.vb2_buf.timestamp = ktime_get_ns();
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
 		/*
 		 * 60 Hz standards start with the bottom field, 50 Hz standards
@@ -558,8 +558,8 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	 * the timestamp now.
 	 */
 	if (!dev->tstamp_src_is_soe)
-		v4l2_get_timestamp(&buf->vb.timestamp);
-	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		buf->vb.vb2_buf.timestamp = ktime_get_ns();
+	buf->vb.vb2_buf.timestamp += dev->time_wrap_offset;
 }
 
 /*
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index c2c46dc..98eed58 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -95,8 +95,8 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 			 */
 			vid_out_buf->vb.sequence /= 2;
 		}
-		v4l2_get_timestamp(&vid_out_buf->vb.timestamp);
-		vid_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		vid_out_buf->vb.vb2_buf.timestamp =
+			ktime_get_ns() + dev->time_wrap_offset;
 		vb2_buffer_done(&vid_out_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vid_out buffer %d done\n",
@@ -108,8 +108,8 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
 			vivid_sliced_vbi_out_process(dev, vbi_out_buf);
 
 		vbi_out_buf->vb.sequence = dev->vbi_out_seq_count;
-		v4l2_get_timestamp(&vbi_out_buf->vb.timestamp);
-		vbi_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		vbi_out_buf->vb.vb2_buf.timestamp =
+			ktime_get_ns() + dev->time_wrap_offset;
 		vb2_buffer_done(&vbi_out_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dprintk(dev, 2, "vbi_out buffer %d done\n",
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 6eeeff9..3d1604c 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -117,8 +117,8 @@ static void vivid_thread_sdr_cap_tick(struct vivid_dev *dev)
 	if (sdr_cap_buf) {
 		sdr_cap_buf->vb.sequence = dev->sdr_cap_seq_count;
 		vivid_sdr_cap_process(dev, sdr_cap_buf);
-		v4l2_get_timestamp(&sdr_cap_buf->vb.timestamp);
-		sdr_cap_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+		sdr_cap_buf->vb.vb2_buf.timestamp =
+			ktime_get_ns() + dev->time_wrap_offset;
 		vb2_buffer_done(&sdr_cap_buf->vb.vb2_buf, dev->dqbuf_error ?
 				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 		dev->dqbuf_error = false;
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index d6d12e1..cda45a5 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -108,8 +108,7 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
 		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
-	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+	buf->vb.vb2_buf.timestamp = ktime_get_ns() + dev->time_wrap_offset;
 }
 
 
@@ -133,8 +132,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev,
 			vbuf[i] = dev->vbi_gen.data[i];
 	}
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
-	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
+	buf->vb.vb2_buf.timestamp = ktime_get_ns() + dev->time_wrap_offset;
 }
 
 static int vbi_cap_queue_setup(struct vb2_queue *vq,
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 1eebf58..45eb65f 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -582,7 +582,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
 	done->buf.sequence = video->sequence++;
-	v4l2_get_timestamp(&done->buf.timestamp);
+	done->buf.vb2_buf.timestamp = ktime_get_ns();
 	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
 		vb2_set_plane_payload(&done->buf.vb2_buf, i, done->length[i]);
 	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 8532cab..722758f 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -303,7 +303,7 @@ static void xvip_dma_complete(void *param)
 
 	buf->buf.field = V4L2_FIELD_NONE;
 	buf->buf.sequence = dma->sequence++;
-	v4l2_get_timestamp(&buf->buf.timestamp);
+	buf->buf.vb2_buf.timestamp = ktime_get_ns();
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, dma->format.sizeimage);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 }
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 518d511..b5595ca 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -316,7 +316,7 @@ static void airspy_urb_complete(struct urb *urb)
 		len = airspy_convert_stream(s, ptr, urb->transfer_buffer,
 				urb->actual_length);
 		vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0, len);
-		v4l2_get_timestamp(&fbuf->vb.timestamp);
+		fbuf->vb.vb2_buf.timestamp = ktime_get_ns();
 		fbuf->vb.sequence = s->sequence++;
 		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 427d58e..0a725a1 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -314,7 +314,7 @@ static inline void buffer_filled(struct au0828_dev *dev,
 		vb->sequence = dev->vbi_frame_count++;
 
 	vb->field = V4L2_FIELD_INTERLACED;
-	v4l2_get_timestamp(&vb->timestamp);
+	vb->vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&vb->vb2_buf, VB2_BUF_STATE_DONE);
 }
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 235a038..0e86ff4 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -438,7 +438,7 @@ static inline void finish_buffer(struct em28xx *dev,
 		buf->vb.field = V4L2_FIELD_NONE;
 	else
 		buf->vb.field = V4L2_FIELD_INTERLACED;
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
 
 	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 }
diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index ae1cfa7..05b1126 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -466,7 +466,7 @@ static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buf
 	else
 		go7007_set_motion_regions(go, vb, 0);
 
-	v4l2_get_timestamp(&vb->vb.timestamp);
+	vb->vb.vb2_buf.timestamp = ktime_get_ns();
 	vb_tmp = vb;
 	spin_lock(&go->spinlock);
 	list_del(&vb->list);
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index d0c416d..d7a3aa2 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -517,7 +517,7 @@ static void hackrf_urb_complete_in(struct urb *urb)
 		    urb->transfer_buffer, len);
 	vb2_set_plane_payload(&buffer->vb.vb2_buf, 0, len);
 	buffer->vb.sequence = dev->sequence++;
-	v4l2_get_timestamp(&buffer->vb.timestamp);
+	buffer->vb.vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&buffer->vb.vb2_buf, VB2_BUF_STATE_DONE);
 exit_usb_submit_urb:
 	usb_submit_urb(urb, GFP_ATOMIC);
@@ -562,7 +562,7 @@ static void hackrf_urb_complete_out(struct urb *urb)
 			   vb2_plane_vaddr(&buffer->vb.vb2_buf, 0), len);
 	urb->actual_length = len;
 	buffer->vb.sequence = dev->sequence++;
-	v4l2_get_timestamp(&buffer->vb.timestamp);
+	buffer->vb.vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&buffer->vb.vb2_buf, VB2_BUF_STATE_DONE);
 exit_usb_submit_urb:
 	usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index e90e494..086cf1c 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -316,8 +316,7 @@ static void pwc_isoc_handler(struct urb *urb)
 			struct pwc_frame_buf *fbuf = pdev->fill_buf;
 
 			if (pdev->vsync == 1) {
-				v4l2_get_timestamp(
-					&fbuf->vb.timestamp);
+				fbuf->vb.vb2_buf.timestamp = ktime_get_ns();
 				pdev->vsync = 2;
 			}
 
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 82bdd42..9acdaa3 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -574,7 +574,7 @@ static void s2255_got_frame(struct s2255_vc *vc, int jpgsize)
 	buf = list_entry(vc->buf_list.next,
 			 struct s2255_buffer, list);
 	list_del(&buf->list);
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
 	buf->vb.field = vc->field;
 	buf->vb.sequence = vc->frame_count;
 	spin_unlock_irqrestore(&vc->qlock, flags);
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 75654e6..46191d5 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -99,7 +99,7 @@ void stk1160_buffer_done(struct stk1160 *dev)
 	buf->vb.sequence = dev->sequence++;
 	buf->vb.field = V4L2_FIELD_INTERLACED;
 	buf->vb.vb2_buf.planes[0].bytesused = buf->bytesused;
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
 
 	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 05cbd2f..4ebb339 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -322,7 +322,7 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 
 		buf->vb.field = V4L2_FIELD_INTERLACED;
 		buf->vb.sequence = usbtv->sequence++;
-		v4l2_get_timestamp(&buf->vb.timestamp);
+		buf->vb.vb2_buf.timestamp = ktime_get_ns();
 		vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
 		vb2_buffer_done(&buf->vb.vb2_buf, state);
 		list_del(&buf->list);
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 2b276ab..f126859 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -694,19 +694,16 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 		ts.tv_nsec -= NSEC_PER_SEC;
 	}
 
-	uvc_trace(UVC_TRACE_CLOCK, "%s: SOF %u.%06llu y %llu ts %lu.%06lu "
-		  "buf ts %lu.%06lu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
+	uvc_trace(UVC_TRACE_CLOCK, "%s: SOF %u.%06llu y %llu ts %llu "
+		  "buf ts %llu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
 		  stream->dev->name,
 		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
-		  y, ts.tv_sec, ts.tv_nsec / NSEC_PER_USEC,
-		  vbuf->timestamp.tv_sec,
-		  (unsigned long)vbuf->timestamp.tv_usec,
+		  y, timespec_to_ns(&ts), vbuf->vb2_buf.timestamp,
 		  x1, first->host_sof, first->dev_sof,
 		  x2, last->host_sof, last->dev_sof, y1, y2);
 
 	/* Update the V4L2 buffer. */
-	vbuf->timestamp.tv_sec = ts.tv_sec;
-	vbuf->timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	vbuf->vb2_buf.timestamp = timespec_to_ns(&ts);
 
 done:
 	spin_unlock_irqrestore(&stream->clock.lock, flags);
@@ -1034,9 +1031,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 
 		buf->buf.field = V4L2_FIELD_NONE;
 		buf->buf.sequence = stream->sequence;
-		buf->buf.timestamp.tv_sec = ts.tv_sec;
-		buf->buf.timestamp.tv_usec =
-			ts.tv_nsec / NSEC_PER_USEC;
+		buf->buf.vb2_buf.timestamp = timespec_to_ns(&ts);
 
 		/* TODO: Handle PTS and SCR. */
 		buf->state = UVC_BUF_STATE_ACTIVE;
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 1b5c695..bfd7e34 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -120,7 +120,7 @@ static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
 		 */
 		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
 				V4L2_BUF_FLAG_TIMESTAMP_COPY)
-			vbuf->timestamp = b->timestamp;
+			vb->timestamp = timeval_to_ns(&b->timestamp);
 		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
 			vbuf->timecode = b->timecode;
@@ -191,7 +191,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 
 	b->flags = vbuf->flags;
 	b->field = vbuf->field;
-	b->timestamp = vbuf->timestamp;
+	b->timestamp = ns_to_timeval(vb->timestamp);
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
 	b->reserved2 = 0;
@@ -308,8 +308,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 					"for an output buffer\n");
 		return -EINVAL;
 	}
-	vbuf->timestamp.tv_sec = 0;
-	vbuf->timestamp.tv_usec = 0;
+	vb->timestamp = 0;
 	vbuf->sequence = 0;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 77b4fc6..adb2bc8 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -470,7 +470,7 @@ void vpfe_video_process_buffer_complete(struct vpfe_video_device *video)
 {
 	struct vpfe_pipeline *pipe = &video->pipe;
 
-	v4l2_get_timestamp(&video->cur_frm->vb.timestamp);
+	video->cur_frm->vb.vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&video->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
 		video->cur_frm = video->next_frm;
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 17741e3..e9aeca0 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -433,7 +433,7 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	list_del(&buf->list);
 	spin_unlock_irqrestore(&video->qlock, flags);
 
-	v4l2_get_timestamp(&buf->vb.timestamp);
+	buf->vb.vb2_buf.timestamp = ktime_get_ns();
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index f592198..912694f 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -329,7 +329,7 @@ struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
 
 	buf->buf.field = V4L2_FIELD_NONE;
 	buf->buf.sequence = queue->sequence++;
-	v4l2_get_timestamp(&buf->buf.timestamp);
+	buf->buf.vb2_buf.timestamp = ktime_get_ns();
 
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index b47d1e2..0774bf3 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -211,6 +211,7 @@ struct vb2_queue;
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue
  * @planes:		private per-plane information; do not change
+ * @timestamp:		frame timestamp in ns
  */
 struct vb2_buffer {
 	struct vb2_queue	*vb2_queue;
@@ -219,6 +220,7 @@ struct vb2_buffer {
 	unsigned int		memory;
 	unsigned int		num_planes;
 	struct vb2_plane	planes[VB2_MAX_PLANES];
+	u64			timestamp;
 
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
index 22afa26..ee7754c 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -184,7 +184,7 @@ DECLARE_EVENT_CLASS(vb2_v4l2_event_class,
 		__field(int, minor)
 		__field(u32, flags)
 		__field(u32, field)
-		__field(s64, timestamp)
+		__field(u64, timestamp)
 		__field(u32, timecode_type)
 		__field(u32, timecode_flags)
 		__field(u8, timecode_frames)
@@ -205,7 +205,7 @@ DECLARE_EVENT_CLASS(vb2_v4l2_event_class,
 		__entry->minor = owner ? owner->vdev->minor : -1;
 		__entry->flags = vbuf->flags;
 		__entry->field = vbuf->field;
-		__entry->timestamp = timeval_to_ns(&vbuf->timestamp);
+		__entry->timestamp = vb->timestamp;
 		__entry->timecode_type = vbuf->timecode.type;
 		__entry->timecode_flags = vbuf->timecode.flags;
 		__entry->timecode_frames = vbuf->timecode.frames;
diff --git a/include/trace/events/vb2.h b/include/trace/events/vb2.h
index bfeceeb..c1a2241 100644
--- a/include/trace/events/vb2.h
+++ b/include/trace/events/vb2.h
@@ -18,6 +18,7 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 		__field(u32, index)
 		__field(u32, type)
 		__field(u32, bytesused)
+		__field(u64, timestamp)
 	),
 
 	TP_fast_assign(
@@ -28,14 +29,16 @@ DECLARE_EVENT_CLASS(vb2_event_class,
 		__entry->index = vb->index;
 		__entry->type = vb->type;
 		__entry->bytesused = vb->planes[0].bytesused;
+		__entry->timestamp = vb->timestamp;
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
2.6.2

