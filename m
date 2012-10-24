Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58288 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757623Ab2JXSQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 14:16:28 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [RFC 3/4] v4l: Convert drivers to use monotonic timestamps
Date: Wed, 24 Oct 2012 21:16:22 +0300
Message-Id: <1351102583-682-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121024181602.GD23933@valkosipuli.retiisi.org.uk>
References: <20121024181602.GD23933@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert drivers using wall clock time (CLOCK_REALTIME) to timestamp from the
monotonic timer (CLOCK_MONOTONIC).

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/common/saa7146/saa7146_fops.c        |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    6 +++---
 drivers/media/pci/cx23885/cx23885-core.c           |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    2 +-
 drivers/media/pci/cx88/cx88-core.c                 |    2 +-
 drivers/media/pci/meye/meye.c                      |    4 ++--
 drivers/media/pci/saa7134/saa7134-core.c           |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/pci/zoran/zoran_device.c             |    4 ++--
 drivers/media/platform/blackfin/bfin_capture.c     |    4 +---
 drivers/media/platform/davinci/vpfe_capture.c      |    5 +----
 drivers/media/platform/davinci/vpif_capture.c      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |    6 +++---
 drivers/media/platform/fsl-viu.c                   |    2 +-
 drivers/media/platform/omap/omap_vout.c            |    2 +-
 drivers/media/platform/omap24xxcam.c               |    2 +-
 drivers/media/platform/omap3isp/ispstat.c          |    2 +-
 drivers/media/platform/sh_vou.c                    |    2 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    2 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    4 ++--
 drivers/media/platform/soc_camera/mx3_camera.c     |    2 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |    2 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |    2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 drivers/media/platform/timblogiw.c                 |    2 +-
 drivers/media/platform/vino.c                      |    8 ++++----
 drivers/media/platform/vivi.c                      |    6 ++----
 drivers/media/usb/au0828/au0828-video.c            |    4 ++--
 drivers/media/usb/cpia2/cpia2_usb.c                |    2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |    4 ++--
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    4 ++--
 drivers/media/usb/pwc/pwc-if.c                     |    3 ++-
 drivers/media/usb/s2255/s2255drv.c                 |    5 ++---
 drivers/media/usb/sn9c102/sn9c102_core.c           |    3 ++-
 drivers/media/usb/stk1160/stk1160-video.c          |    2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |    2 +-
 drivers/media/usb/tlg2300/pd-video.c               |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |    2 +-
 drivers/media/usb/usbvision/usbvision-core.c       |    2 +-
 drivers/media/usb/zr364xx/zr364xx.c                |    6 ++----
 44 files changed, 62 insertions(+), 70 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index b3890bd..2652f91 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -105,7 +105,7 @@ void saa7146_buffer_finish(struct saa7146_dev *dev,
 	}
 
 	q->curr->vb.state = state;
-	do_gettimeofday(&q->curr->vb.ts);
+	v4l2_get_timestamp(&q->curr->vb.ts);
 	wake_up(&q->curr->vb.done);
 
 	q->curr = NULL;
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 56c6c77..3f03b6b 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3836,7 +3836,7 @@ bttv_irq_wakeup_video(struct bttv *btv, struct bttv_buffer_set *wakeup,
 {
 	struct timeval ts;
 
-	do_gettimeofday(&ts);
+	v4l2_get_timestamp(&ts);
 
 	if (wakeup->top == wakeup->bottom) {
 		if (NULL != wakeup->top && curr->top != wakeup->top) {
@@ -3879,7 +3879,7 @@ bttv_irq_wakeup_vbi(struct bttv *btv, struct bttv_buffer *wakeup,
 	if (NULL == wakeup)
 		return;
 
-	do_gettimeofday(&ts);
+	v4l2_get_timestamp(&ts);
 	wakeup->vb.ts = ts;
 	wakeup->vb.field_count = btv->field_count;
 	wakeup->vb.state = state;
@@ -3950,7 +3950,7 @@ bttv_irq_wakeup_top(struct bttv *btv)
 	btv->curr.top = NULL;
 	bttv_risc_hook(btv, RISC_SLOT_O_FIELD, NULL, 0);
 
-	do_gettimeofday(&wakeup->vb.ts);
+	v4l2_get_timestamp(&wakeup->vb.ts);
 	wakeup->vb.field_count = btv->field_count;
 	wakeup->vb.state = VIDEOBUF_DONE;
 	wake_up(&wakeup->vb.done);
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 697728f..990b8af 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -439,7 +439,7 @@ void cx23885_wakeup(struct cx23885_tsport *port,
 		if ((s16) (count - buf->count) < 0)
 			break;
 
-		do_gettimeofday(&buf->vb.ts);
+		v4l2_get_timestamp(&buf->vb.ts);
 		dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.i,
 			count, buf->count);
 		buf->vb.state = VIDEOBUF_DONE;
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 1a21926..8397531 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -300,7 +300,7 @@ void cx23885_video_wakeup(struct cx23885_dev *dev,
 		if ((s16) (count - buf->count) < 0)
 			break;
 
-		do_gettimeofday(&buf->vb.ts);
+		v4l2_get_timestamp(&buf->vb.ts);
 		dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.i,
 			count, buf->count);
 		buf->vb.state = VIDEOBUF_DONE;
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 0a80245..b2e51af 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -130,7 +130,7 @@ void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
 		if ((s16) (count - buf->count) < 0)
 			break;
 
-		do_gettimeofday(&buf->vb.ts);
+		v4l2_get_timestamp(&buf->vb.ts);
 		buf->vb.state = VIDEOBUF_DONE;
 		list_del(&buf->vb.queue);
 		wake_up(&buf->vb.done);
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index c97b174..f0710e0 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -549,7 +549,7 @@ void cx88_wakeup(struct cx88_core *core,
 		 * up to 32767 buffers in flight... */
 		if ((s16) (count - buf->count) < 0)
 			break;
-		do_gettimeofday(&buf->vb.ts);
+		v4l2_get_timestamp(&buf->vb.ts);
 		dprintk(2,"[%p/%d] wakeup reg=%d buf=%d\n",buf,buf->vb.i,
 			count, buf->count);
 		buf->vb.state = VIDEOBUF_DONE;
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index e5a76da..86713e0 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -811,7 +811,7 @@ again:
 				      mchip_hsize() * mchip_vsize() * 2);
 		meye.grab_buffer[reqnr].size = mchip_hsize() * mchip_vsize() * 2;
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
-		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
+		v4l2_get_timestamp(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
 		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
@@ -832,7 +832,7 @@ again:
 		       size);
 		meye.grab_buffer[reqnr].size = size;
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
-		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
+		v4l2_get_timestamp(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
 		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index f2b37e0..e92d025 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -308,7 +308,7 @@ void saa7134_buffer_finish(struct saa7134_dev *dev,
 
 	/* finish current buffer */
 	q->curr->vb.state = state;
-	do_gettimeofday(&q->curr->vb.ts);
+	v4l2_get_timestamp(&q->curr->vb.ts);
 	wake_up(&q->curr->vb.done);
 	q->curr = NULL;
 }
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 4c10205..ed1337a 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -1088,7 +1088,7 @@ static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
 
 	REG_WRITE(vip, DVP_CTL, REG_READ(vip, DVP_CTL) & ~DVP_CTL_ENA);
 	if (vip->active) {
-		do_gettimeofday(&vip->active->ts);
+		v4l2_get_timestamp(&vip->active->ts);
 		vip->active->field_count++;
 		vip->active->state = VIDEOBUF_DONE;
 		wake_up(&vip->active->done);
diff --git a/drivers/media/pci/zoran/zoran_device.c b/drivers/media/pci/zoran/zoran_device.c
index a4cd504..519164c 100644
--- a/drivers/media/pci/zoran/zoran_device.c
+++ b/drivers/media/pci/zoran/zoran_device.c
@@ -1169,7 +1169,7 @@ zoran_reap_stat_com (struct zoran *zr)
 		}
 		frame = zr->jpg_pend[zr->jpg_dma_tail & BUZ_MASK_FRAME];
 		buffer = &zr->jpg_buffers.buffer[frame];
-		do_gettimeofday(&buffer->bs.timestamp);
+		v4l2_get_timestamp(&buffer->bs.timestamp);
 
 		if (zr->codec_mode == BUZ_MODE_MOTION_COMPRESS) {
 			buffer->bs.length = (stat_com & 0x7fffff) >> 1;
@@ -1407,7 +1407,7 @@ zoran_irq (int             irq,
 
 						zr->v4l_buffers.buffer[zr->v4l_grab_frame].state = BUZ_STATE_DONE;
 						zr->v4l_buffers.buffer[zr->v4l_grab_frame].bs.seq = zr->v4l_grab_seq;
-						do_gettimeofday(&zr->v4l_buffers.buffer[zr->v4l_grab_frame].bs.timestamp);
+						v4l2_get_timestamp(&zr->v4l_buffers.buffer[zr->v4l_grab_frame].bs.timestamp);
 						zr->v4l_grab_frame = NO_GRAB_ACTIVE;
 						zr->v4l_pend_tail++;
 					}
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index cb2eb26..d2035f1 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -484,15 +484,13 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 {
 	struct ppi_if *ppi = dev_id;
 	struct bcap_device *bcap_dev = ppi->priv;
-	struct timeval timevalue;
 	struct vb2_buffer *vb = &bcap_dev->cur_frm->vb;
 	dma_addr_t addr;
 
 	spin_lock(&bcap_dev->lock);
 
 	if (bcap_dev->cur_frm != bcap_dev->next_frm) {
-		do_gettimeofday(&timevalue);
-		vb->v4l2_buf.timestamp = timevalue;
+		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 		bcap_dev->cur_frm = bcap_dev->next_frm;
 	}
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 8be492c..65f4264 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -560,10 +560,7 @@ static void vpfe_schedule_bottom_field(struct vpfe_device *vpfe_dev)
 
 static void vpfe_process_buffer_complete(struct vpfe_device *vpfe_dev)
 {
-	struct timeval timevalue;
-
-	do_gettimeofday(&timevalue);
-	vpfe_dev->cur_frm->ts = timevalue;
+	v4l2_get_timestamp(&vpfe_dev->cur_frm->ts);
 	vpfe_dev->cur_frm->state = VIDEOBUF_DONE;
 	vpfe_dev->cur_frm->size = vpfe_dev->fmt.fmt.pix.sizeimage;
 	wake_up_interruptible(&vpfe_dev->cur_frm->done);
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index fcabc02..1f12640 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -401,7 +401,7 @@ static struct vb2_ops video_qops = {
  */
 static void vpif_process_buffer_complete(struct common_obj *common)
 {
-	do_gettimeofday(&common->cur_frm->vb.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
 	vb2_buffer_done(&common->cur_frm->vb,
 					    VB2_BUF_STATE_DONE);
 	/* Make curFrm pointing to nextFrm */
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index b716fbd..2bc6eef 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -390,7 +390,7 @@ static void process_interlaced_mode(int fid, struct common_obj *common)
 		/* one frame is displayed If next frame is
 		 *  available, release cur_frm and move on */
 		/* Copy frame display time */
-		do_gettimeofday(&common->cur_frm->vb.v4l2_buf.timestamp);
+		v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
 		/* Change status of the cur_frm */
 		vb2_buffer_done(&common->cur_frm->vb,
 					    VB2_BUF_STATE_DONE);
@@ -444,8 +444,8 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 			if (!channel_first_int[i][channel_id]) {
 				/* Mark status of the cur_frm to
 				 * done and unlock semaphore on it */
-				do_gettimeofday(&common->cur_frm->vb.
-						v4l2_buf.timestamp);
+				v4l2_get_timestamp(&common->cur_frm->vb.
+						   v4l2_buf.timestamp);
 				vb2_buffer_done(&common->cur_frm->vb,
 					    VB2_BUF_STATE_DONE);
 				/* Make cur_frm pointing to next_frm */
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 31ac4dc..ee1e6b0 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1183,7 +1183,7 @@ static void viu_capture_intr(struct viu_dev *dev, u32 status)
 
 		if (waitqueue_active(&buf->vb.done)) {
 			list_del(&buf->vb.queue);
-			do_gettimeofday(&buf->vb.ts);
+			v4l2_get_timestamp(&buf->vb.ts);
 			buf->vb.state = VIDEOBUF_DONE;
 			buf->vb.field_count++;
 			wake_up(&buf->vb.done);
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index a3b1a34..148e770 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -597,7 +597,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 		return;
 
 	spin_lock(&vout->vbq_lock);
-	do_gettimeofday(&timevalue);
+	v4l2_get_timestamp(&timevalue);
 
 	switch (cur_display->type) {
 	case OMAP_DISPLAY_TYPE_DSI:
diff --git a/drivers/media/platform/omap24xxcam.c b/drivers/media/platform/omap24xxcam.c
index 70f45c3..eda3274 100644
--- a/drivers/media/platform/omap24xxcam.c
+++ b/drivers/media/platform/omap24xxcam.c
@@ -402,7 +402,7 @@ static void omap24xxcam_vbq_complete(struct omap24xxcam_sgdma *sgdma,
 		omap24xxcam_core_disable(cam);
 	spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
 
-	do_gettimeofday(&vb->ts);
+	v4l2_get_timestamp(&vb->ts);
 	vb->field_count = atomic_add_return(2, &fh->field_count);
 	if (csr & csr_error) {
 		vb->state = VIDEOBUF_ERROR;
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index d7ac76b..90c7572 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -256,7 +256,7 @@ static int isp_stat_buf_queue(struct ispstat *stat)
 	if (!stat->active_buf)
 		return STAT_NO_BUF;
 
-	do_gettimeofday(&stat->active_buf->ts);
+	v4l2_get_timestamp(&stat->active_buf->ts);
 
 	stat->active_buf->buf_size = stat->buf_size;
 	if (isp_stat_buf_check_magic(stat, stat->active_buf)) {
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 85fd312..520740b 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1090,7 +1090,7 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 	list_del(&vb->queue);
 
 	vb->state = VIDEOBUF_DONE;
-	do_gettimeofday(&vb->ts);
+	v4l2_get_timestamp(&vb->ts);
 	vb->field_count++;
 	wake_up(&vb->done);
 
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 6274a91..c8d748a 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -166,7 +166,7 @@ static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 		struct frame_buffer *buf = isi->active;
 
 		list_del_init(&buf->list);
-		do_gettimeofday(&vb->v4l2_buf.timestamp);
+		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.sequence = isi->sequence++;
 		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 	}
diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
index bbe7099..8e33ca1 100644
--- a/drivers/media/platform/soc_camera/mx1_camera.c
+++ b/drivers/media/platform/soc_camera/mx1_camera.c
@@ -307,7 +307,7 @@ static void mx1_camera_wakeup(struct mx1_camera_dev *pcdev,
 	/* _init is used to debug races, see comment in mx1_camera_reqbufs() */
 	list_del_init(&vb->queue);
 	vb->state = VIDEOBUF_DONE;
-	do_gettimeofday(&vb->ts);
+	v4l2_get_timestamp(&vb->ts);
 	vb->field_count++;
 	wake_up(&vb->done);
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 9fd9d1c..e474a38 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -516,7 +516,7 @@ static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
 	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__,
 		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
-	do_gettimeofday(&vb->v4l2_buf.timestamp);
+	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 	vb->v4l2_buf.sequence++;
 	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 
@@ -1552,7 +1552,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 				vb2_get_plane_payload(vb, 0));
 
 		list_del_init(&buf->internal.queue);
-		do_gettimeofday(&vb->v4l2_buf.timestamp);
+		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.sequence = pcdev->frame_count;
 		if (err)
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 3557ac9..dea1ad0 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -156,7 +156,7 @@ static void mx3_cam_dma_done(void *arg)
 		struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 
 		list_del_init(&buf->queue);
-		do_gettimeofday(&vb->v4l2_buf.timestamp);
+		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.field = mx3_cam->field;
 		vb->v4l2_buf.sequence = mx3_cam->sequence++;
 		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index fa08c76..f4aaaeb 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -591,7 +591,7 @@ static void videobuf_done(struct omap1_cam_dev *pcdev,
 			suspend_capture(pcdev);
 		}
 		vb->state = result;
-		do_gettimeofday(&vb->ts);
+		v4l2_get_timestamp(&vb->ts);
 		if (result != VIDEOBUF_ERROR)
 			vb->field_count++;
 		wake_up(&vb->done);
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 1e3776d..108e2d2 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -681,7 +681,7 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
 	list_del_init(&vb->queue);
 	vb->state = VIDEOBUF_DONE;
-	do_gettimeofday(&vb->ts);
+	v4l2_get_timestamp(&vb->ts);
 	vb->field_count++;
 	wake_up(&vb->done);
 	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s dequeud buffer (vb=0x%p)\n",
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 0a24253..1786338 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -516,7 +516,7 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 		pcdev->active = NULL;
 
 	ret = sh_mobile_ceu_capture(pcdev);
-	do_gettimeofday(&vb->v4l2_buf.timestamp);
+	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 	if (!ret) {
 		vb->v4l2_buf.field = pcdev->field;
 		vb->v4l2_buf.sequence = pcdev->sequence++;
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 02194c0..9de0141 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -130,7 +130,7 @@ static void timblogiw_dma_cb(void *data)
 
 	if (vb->state != VIDEOBUF_ERROR) {
 		list_del(&vb->queue);
-		do_gettimeofday(&vb->ts);
+		v4l2_get_timestamp(&vb->ts);
 		vb->field_count = fh->frame_count * 2;
 		vb->state = VIDEOBUF_DONE;
 
diff --git a/drivers/media/platform/vino.c b/drivers/media/platform/vino.c
index 70b0bf4..28350e7 100644
--- a/drivers/media/platform/vino.c
+++ b/drivers/media/platform/vino.c
@@ -2474,8 +2474,8 @@ static irqreturn_t vino_interrupt(int irq, void *dev_id)
 
 		if ((!handled_a) && (done_a || skip_a)) {
 			if (!skip_a) {
-				do_gettimeofday(&vino_drvdata->
-						a.int_data.timestamp);
+				v4l2_get_timestamp(
+					&vino_drvdata->a.int_data.timestamp);
 				vino_drvdata->a.int_data.frame_counter = fc_a;
 			}
 			vino_drvdata->a.int_data.skip = skip_a;
@@ -2489,8 +2489,8 @@ static irqreturn_t vino_interrupt(int irq, void *dev_id)
 
 		if ((!handled_b) && (done_b || skip_b)) {
 			if (!skip_b) {
-				do_gettimeofday(&vino_drvdata->
-						b.int_data.timestamp);
+				v4l2_get_timestamp(
+					&vino_drvdata->b.int_data.timestamp);
 				vino_drvdata->b.int_data.frame_counter = fc_b;
 			}
 			vino_drvdata->b.int_data.skip = skip_b;
diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index b366b05..d813fd8 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -560,7 +560,6 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 {
 	int wmax = dev->width;
 	int hmax = dev->height;
-	struct timeval ts;
 	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 	unsigned ms;
 	char str[100];
@@ -628,8 +627,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	dev->field_count++;
 	buf->vb.v4l2_buf.sequence = dev->field_count >> 1;
-	do_gettimeofday(&ts);
-	buf->vb.v4l2_buf.timestamp = ts;
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 }
 
 static void vivi_thread_tick(struct vivi_dev *dev)
@@ -651,7 +649,7 @@ static void vivi_thread_tick(struct vivi_dev *dev)
 	list_del(&buf->list);
 	spin_unlock_irqrestore(&dev->slock, flags);
 
-	do_gettimeofday(&buf->vb.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
 	/* Fill buffer */
 	vivi_fillbuff(dev, buf);
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 8705855..d8568a0 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -304,7 +304,7 @@ static inline void buffer_filled(struct au0828_dev *dev,
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	do_gettimeofday(&buf->vb.ts);
+	v4l2_get_timestamp(&buf->vb.ts);
 
 	dev->isoc_ctl.buf = NULL;
 
@@ -321,7 +321,7 @@ static inline void vbi_buffer_filled(struct au0828_dev *dev,
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	do_gettimeofday(&buf->vb.ts);
+	v4l2_get_timestamp(&buf->vb.ts);
 
 	dev->isoc_ctl.vbi_buf = NULL;
 
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 95b5d6e..be17192 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -328,7 +328,7 @@ static void cpia2_usb_complete(struct urb *urb)
 				continue;
 			}
 			DBG("Start of frame pattern found\n");
-			do_gettimeofday(&cam->workbuff->timestamp);
+			v4l2_get_timestamp(&cam->workbuff->timestamp);
 			cam->workbuff->seq = cam->frame_count++;
 			cam->workbuff->data[0] = 0xFF;
 			cam->workbuff->data[1] = 0xD8;
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index b024e51..28688db 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1291,7 +1291,7 @@ static void buffer_copy(struct cx231xx *dev, char *data, int len, struct urb *ur
 
 			buf->vb.state = VIDEOBUF_DONE;
 			buf->vb.field_count++;
-			do_gettimeofday(&buf->vb.ts);
+			v4l2_get_timestamp(&buf->vb.ts);
 			list_del(&buf->vb.queue);
 			wake_up(&buf->vb.done);
 			dma_q->mpeg_buffer_completed = 0;
@@ -1327,7 +1327,7 @@ static void buffer_filled(char *data, int len, struct urb *urb,
 		memcpy(vbuf, data, len);
 		buf->vb.state = VIDEOBUF_DONE;
 		buf->vb.field_count++;
-		do_gettimeofday(&buf->vb.ts);
+		v4l2_get_timestamp(&buf->vb.ts);
 		list_del(&buf->vb.queue);
 		wake_up(&buf->vb.done);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index ac7db52..46e3892 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -530,7 +530,7 @@ static inline void vbi_buffer_filled(struct cx231xx *dev,
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	do_gettimeofday(&buf->vb.ts);
+	v4l2_get_timestamp(&buf->vb.ts);
 
 	dev->vbi_mode.bulk_ctl.buf = NULL;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index fedf785..239cb91 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -235,7 +235,7 @@ static inline void buffer_filled(struct cx231xx *dev,
 	cx231xx_isocdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	do_gettimeofday(&buf->vb.ts);
+	v4l2_get_timestamp(&buf->vb.ts);
 
 	if (dev->USE_ISO)
 		dev->video_mode.isoc_ctl.buf = NULL;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 1e553d3..766ad12 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -163,7 +163,7 @@ static inline void buffer_filled(struct em28xx *dev,
 	em28xx_isocdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	do_gettimeofday(&buf->vb.ts);
+	v4l2_get_timestamp(&buf->vb.ts);
 
 	dev->isoc_ctl.vid_buf = NULL;
 
@@ -180,7 +180,7 @@ static inline void vbi_buffer_filled(struct em28xx *dev,
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	do_gettimeofday(&buf->vb.ts);
+	v4l2_get_timestamp(&buf->vb.ts);
 
 	dev->isoc_ctl.vbi_buf = NULL;
 
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 42e36ba..96fbb35 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -316,7 +316,8 @@ static void pwc_isoc_handler(struct urb *urb)
 			struct pwc_frame_buf *fbuf = pdev->fill_buf;
 
 			if (pdev->vsync == 1) {
-				do_gettimeofday(&fbuf->vb.v4l2_buf.timestamp);
+				v4l2_get_timestamp(
+					&fbuf->vb.v4l2_buf.timestamp);
 				pdev->vsync = 2;
 			}
 
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 2191f6d..c4f8b86 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -593,7 +593,7 @@ static int s2255_got_frame(struct s2255_channel *channel, int jpgsize)
 	buf = list_entry(dma_q->active.next,
 			 struct s2255_buffer, vb.queue);
 	list_del(&buf->vb.queue);
-	do_gettimeofday(&buf->vb.ts);
+	v4l2_get_timestamp(&buf->vb.ts);
 	s2255_fillbuff(channel, buf, jpgsize);
 	wake_up(&buf->vb.done);
 	dprintk(2, "%s: [buf/i] [%p/%d]\n", __func__, buf, buf->vb.i);
@@ -674,8 +674,7 @@ static void s2255_fillbuff(struct s2255_channel *channel,
 	/* tell v4l buffer was filled */
 
 	buf->vb.field_count = channel->frame_count * 2;
-	do_gettimeofday(&ts);
-	buf->vb.ts = ts;
+	v4l2_get_timestamp(&buf->vb.ts);
 	buf->vb.state = VIDEOBUF_DONE;
 }
 
diff --git a/drivers/media/usb/sn9c102/sn9c102_core.c b/drivers/media/usb/sn9c102/sn9c102_core.c
index 5bfc8e2..843fadc 100644
--- a/drivers/media/usb/sn9c102/sn9c102_core.c
+++ b/drivers/media/usb/sn9c102/sn9c102_core.c
@@ -773,7 +773,8 @@ end_of_frame:
 				       img);
 
 				if ((*f)->buf.bytesused == 0)
-					do_gettimeofday(&(*f)->buf.timestamp);
+					v4l2_get_timestamp(
+						&(*f)->buf.timestamp);
 
 				(*f)->buf.bytesused += img;
 
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 8bdfb02..cbdb7de 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -101,7 +101,7 @@ void stk1160_buffer_done(struct stk1160 *dev)
 	buf->vb.v4l2_buf.sequence = dev->field_count >> 1;
 	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	buf->vb.v4l2_buf.bytesused = buf->bytesused;
-	do_gettimeofday(&buf->vb.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
 	vb2_set_plane_payload(&buf->vb, 0, buf->bytesused);
 	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 86a0fc5..c22a4d0 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1116,7 +1116,7 @@ static int stk_vidioc_dqbuf(struct file *filp,
 	sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_QUEUED;
 	sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_DONE;
 	sbuf->v4lbuf.sequence = ++dev->sequence;
-	do_gettimeofday(&sbuf->v4lbuf.timestamp);
+	v4l2_get_timestamp(&sbuf->v4lbuf.timestamp);
 
 	*buf = sbuf->v4lbuf;
 	return 0;
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 1f448ac..ee9cae6 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -212,7 +212,7 @@ static void submit_frame(struct front_face *front)
 	front->curr_frame	= NULL;
 	vb->state		= VIDEOBUF_DONE;
 	vb->field_count++;
-	do_gettimeofday(&vb->ts);
+	v4l2_get_timestamp(&vb->ts);
 
 	wake_up(&vb->done);
 }
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 4342cd4..f2b06a1 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -191,7 +191,7 @@ static inline void buffer_filled(struct tm6000_core *dev,
 	dprintk(dev, V4L2_DEBUG_ISOC, "[%p/%d] wakeup\n", buf, buf->vb.i);
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	do_gettimeofday(&buf->vb.ts);
+	v4l2_get_timestamp(&buf->vb.ts);
 
 	list_del(&buf->vb.queue);
 	wake_up(&buf->vb.done);
diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index c9b2042..816b1cf 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1169,7 +1169,7 @@ static void usbvision_parse_data(struct usb_usbvision *usbvision)
 
 	if (newstate == parse_state_next_frame) {
 		frame->grabstate = frame_state_done;
-		do_gettimeofday(&(frame->timestamp));
+		v4l2_get_timestamp(&(frame->timestamp));
 		frame->sequence = usbvision->frame_num;
 
 		spin_lock_irqsave(&usbvision->queue_lock, lock_flags);
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 9afab35..63de652 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -501,7 +501,6 @@ static void zr364xx_fillbuff(struct zr364xx_camera *cam,
 			     int jpgsize)
 {
 	int pos = 0;
-	struct timeval ts;
 	const char *tmpbuf;
 	char *vbuf = videobuf_to_vmalloc(&buf->vb);
 	unsigned long last_frame;
@@ -530,8 +529,7 @@ static void zr364xx_fillbuff(struct zr364xx_camera *cam,
 	/* tell v4l buffer was filled */
 
 	buf->vb.field_count = cam->frame_count * 2;
-	do_gettimeofday(&ts);
-	buf->vb.ts = ts;
+	v4l2_get_timestamp(&buf->vb.ts);
 	buf->vb.state = VIDEOBUF_DONE;
 }
 
@@ -559,7 +557,7 @@ static int zr364xx_got_frame(struct zr364xx_camera *cam, int jpgsize)
 		goto unlock;
 	}
 	list_del(&buf->vb.queue);
-	do_gettimeofday(&buf->vb.ts);
+	v4l2_get_timestamp(&buf->vb.ts);
 	DBG("[%p/%d] wakeup\n", buf, buf->vb.i);
 	zr364xx_fillbuff(cam, buf, jpgsize);
 	wake_up(&buf->vb.done);
-- 
1.7.2.5

