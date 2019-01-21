Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09658C2F3A6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C0F20870
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbfAUNci (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:32:38 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:49897 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728768AbfAUNcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 08:32:36 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lZgjgZ95MBDyIlZgngPCJi; Mon, 21 Jan 2019 14:32:34 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 2/8] videobuf: use u64 for the timestamp internally
Date:   Mon, 21 Jan 2019 14:32:23 +0100
Message-Id: <20190121133229.33893-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
References: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfLCc4LSPtCzjj1Jpt5J1F2BsvjVcGofCt5IGbRz4tSP5BF6j9PKsTnJ9i8upeV2fXYDVhVqEtTcr5d91bBVuA4zg3zFKov2OiNIDnoXAuACZ6esTJSfK
 uXaTmhj8jYyNacVbiOiRnsNk5GR3FwGa/N+DI3dmDSRJbTrwX2UDFkr1JF2C+nmpWLevoJoYzU2zTSz9/ub/GRqAVd414SGLH2Aeoh8oYfPo1TIBw2mwcTln
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Just like vb2 does, use u64 internally to store the timestamps
of the buffers. Only convert to timeval when interfacing with
userspace.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/saa7146/saa7146_fops.c   |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c         |  8 +++-----
 drivers/media/pci/cx18/cx18-mailbox.c         |  2 +-
 drivers/media/platform/davinci/vpfe_capture.c |  2 +-
 drivers/media/platform/fsl-viu.c              |  2 +-
 drivers/media/platform/omap/omap_vout.c       | 12 ++++++------
 drivers/media/usb/cx231xx/cx231xx-417.c       |  4 ++--
 drivers/media/usb/cx231xx/cx231xx-vbi.c       |  2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |  2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |  2 +-
 drivers/media/usb/zr364xx/zr364xx.c           |  4 ++--
 drivers/media/v4l2-core/videobuf-core.c       |  4 ++--
 include/media/videobuf-core.h                 |  2 +-
 13 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index c790ae264464..be4355a4c126 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -105,7 +105,7 @@ void saa7146_buffer_finish(struct saa7146_dev *dev,
 	}
 
 	q->curr->vb.state = state;
-	v4l2_get_timestamp(&q->curr->vb.ts);
+	q->curr->vb.ts = ktime_get_ns();
 	wake_up(&q->curr->vb.done);
 
 	q->curr = NULL;
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index d09785fd37a8..5e769c09dbd0 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3600,9 +3600,7 @@ static void
 bttv_irq_wakeup_video(struct bttv *btv, struct bttv_buffer_set *wakeup,
 		      struct bttv_buffer_set *curr, unsigned int state)
 {
-	struct timeval ts;
-
-	v4l2_get_timestamp(&ts);
+	u64 ts = ktime_get_ns();
 
 	if (wakeup->top == wakeup->bottom) {
 		if (NULL != wakeup->top && curr->top != wakeup->top) {
@@ -3643,7 +3641,7 @@ bttv_irq_wakeup_vbi(struct bttv *btv, struct bttv_buffer *wakeup,
 	if (NULL == wakeup)
 		return;
 
-	v4l2_get_timestamp(&wakeup->vb.ts);
+	wakeup->vb.ts = ktime_get_ns();
 	wakeup->vb.field_count = btv->field_count;
 	wakeup->vb.state = state;
 	wake_up(&wakeup->vb.done);
@@ -3713,7 +3711,7 @@ bttv_irq_wakeup_top(struct bttv *btv)
 	btv->curr.top = NULL;
 	bttv_risc_hook(btv, RISC_SLOT_O_FIELD, NULL, 0);
 
-	v4l2_get_timestamp(&wakeup->vb.ts);
+	wakeup->vb.ts = ktime_get_ns();
 	wakeup->vb.field_count = btv->field_count;
 	wakeup->vb.state = VIDEOBUF_DONE;
 	wake_up(&wakeup->vb.done);
diff --git a/drivers/media/pci/cx18/cx18-mailbox.c b/drivers/media/pci/cx18/cx18-mailbox.c
index f66dd63e1994..0ffd2196a980 100644
--- a/drivers/media/pci/cx18/cx18-mailbox.c
+++ b/drivers/media/pci/cx18/cx18-mailbox.c
@@ -197,7 +197,7 @@ static void cx18_mdl_send_to_videobuf(struct cx18_stream *s,
 	}
 
 	if (dispatch) {
-		v4l2_get_timestamp(&vb_buf->vb.ts);
+		vb_buf->vb.ts = ktime_get_ns();
 		list_del(&vb_buf->vb.queue);
 		vb_buf->vb.state = VIDEOBUF_DONE;
 		wake_up(&vb_buf->vb.done);
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 9996bab98fe3..26dadbba930f 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -518,7 +518,7 @@ static void vpfe_schedule_bottom_field(struct vpfe_device *vpfe_dev)
 
 static void vpfe_process_buffer_complete(struct vpfe_device *vpfe_dev)
 {
-	v4l2_get_timestamp(&vpfe_dev->cur_frm->ts);
+	vpfe_dev->cur_frm->ts = ktime_get_ns();
 	vpfe_dev->cur_frm->state = VIDEOBUF_DONE;
 	vpfe_dev->cur_frm->size = vpfe_dev->fmt.fmt.pix.sizeimage;
 	wake_up_interruptible(&vpfe_dev->cur_frm->done);
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index ca6d0317ab42..cffebcaacb90 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1090,7 +1090,7 @@ static void viu_capture_intr(struct viu_dev *dev, u32 status)
 
 		if (waitqueue_active(&buf->vb.done)) {
 			list_del(&buf->vb.queue);
-			v4l2_get_timestamp(&buf->vb.ts);
+			buf->vb.ts = ktime_get_ns();
 			buf->vb.state = VIDEOBUF_DONE;
 			buf->vb.field_count++;
 			wake_up(&buf->vb.done);
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index f447ae3bb465..ff3de2dce5a2 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -513,7 +513,7 @@ static int omapvid_apply_changes(struct omap_vout_device *vout)
 }
 
 static int omapvid_handle_interlace_display(struct omap_vout_device *vout,
-		unsigned int irqstatus, struct timeval timevalue)
+		unsigned int irqstatus, u64 ts)
 {
 	u32 fid;
 
@@ -537,7 +537,7 @@ static int omapvid_handle_interlace_display(struct omap_vout_device *vout,
 		if (vout->cur_frm == vout->next_frm)
 			goto err;
 
-		vout->cur_frm->ts = timevalue;
+		vout->cur_frm->ts = ts;
 		vout->cur_frm->state = VIDEOBUF_DONE;
 		wake_up_interruptible(&vout->cur_frm->done);
 		vout->cur_frm = vout->next_frm;
@@ -557,7 +557,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 	int ret, fid, mgr_id;
 	u32 addr, irq;
 	struct omap_overlay *ovl;
-	struct timeval timevalue;
+	u64 ts;
 	struct omapvideo_info *ovid;
 	struct omap_dss_device *cur_display;
 	struct omap_vout_device *vout = (struct omap_vout_device *)arg;
@@ -577,7 +577,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 		return;
 
 	spin_lock(&vout->vbq_lock);
-	v4l2_get_timestamp(&timevalue);
+	ts = ktime_get_ns();
 
 	switch (cur_display->type) {
 	case OMAP_DISPLAY_TYPE_DSI:
@@ -595,7 +595,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 		break;
 	case OMAP_DISPLAY_TYPE_VENC:
 		fid = omapvid_handle_interlace_display(vout, irqstatus,
-				timevalue);
+				ts);
 		if (!fid)
 			goto vout_isr_err;
 		break;
@@ -608,7 +608,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
 	}
 
 	if (!vout->first_int && (vout->cur_frm != vout->next_frm)) {
-		vout->cur_frm->ts = timevalue;
+		vout->cur_frm->ts = ts;
 		vout->cur_frm->state = VIDEOBUF_DONE;
 		wake_up_interruptible(&vout->cur_frm->done);
 		vout->cur_frm = vout->next_frm;
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 1c48c497bd6a..0f8ae81f4820 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1316,7 +1316,7 @@ static void buffer_copy(struct cx231xx *dev, char *data, int len, struct urb *ur
 
 		buf->vb.state = VIDEOBUF_DONE;
 		buf->vb.field_count++;
-		v4l2_get_timestamp(&buf->vb.ts);
+		buf->vb.ts = ktime_get_ns();
 		list_del(&buf->vb.queue);
 		wake_up(&buf->vb.done);
 		dma_q->mpeg_buffer_completed = 0;
@@ -1347,7 +1347,7 @@ static void buffer_filled(char *data, int len, struct urb *urb,
 	memcpy(vbuf, data, len);
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	v4l2_get_timestamp(&buf->vb.ts);
+	buf->vb.ts = ktime_get_ns();
 	list_del(&buf->vb.queue);
 	wake_up(&buf->vb.done);
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 10b2eb7338ad..d16b73c04445 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -528,7 +528,7 @@ static inline void vbi_buffer_filled(struct cx231xx *dev,
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	v4l2_get_timestamp(&buf->vb.ts);
+	buf->vb.ts = ktime_get_ns();
 
 	dev->vbi_mode.bulk_ctl.buf = NULL;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 0d451c4ea3b9..aebbaf9d92a6 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -182,7 +182,7 @@ static inline void buffer_filled(struct cx231xx *dev,
 	cx231xx_isocdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	v4l2_get_timestamp(&buf->vb.ts);
+	buf->vb.ts = ktime_get_ns();
 
 	if (dev->USE_ISO)
 		dev->video_mode.isoc_ctl.buf = NULL;
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index ee7b5318b351..5127be71dd03 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -106,7 +106,7 @@ static inline void buffer_filled(struct tm6000_core *dev,
 	dprintk(dev, V4L2_DEBUG_ISOC, "[%p/%d] wakeup\n", buf, buf->vb.i);
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
-	v4l2_get_timestamp(&buf->vb.ts);
+	buf->vb.ts = ktime_get_ns();
 
 	list_del(&buf->vb.queue);
 	wake_up(&buf->vb.done);
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index ab35554cbffa..51aad2cf742f 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -521,7 +521,7 @@ static void zr364xx_fillbuff(struct zr364xx_camera *cam,
 	/* tell v4l buffer was filled */
 
 	buf->vb.field_count = cam->frame_count * 2;
-	v4l2_get_timestamp(&buf->vb.ts);
+	buf->vb.ts = ktime_get_ns();
 	buf->vb.state = VIDEOBUF_DONE;
 }
 
@@ -549,7 +549,7 @@ static int zr364xx_got_frame(struct zr364xx_camera *cam, int jpgsize)
 		goto unlock;
 	}
 	list_del(&buf->vb.queue);
-	v4l2_get_timestamp(&buf->vb.ts);
+	buf->vb.ts = ktime_get_ns();
 	DBG("[%p/%d] wakeup\n", buf, buf->vb.i);
 	zr364xx_fillbuff(cam, buf, jpgsize);
 	wake_up(&buf->vb.done);
diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index 7491b337002c..d1bcfa91aaf8 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -367,7 +367,7 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 	}
 
 	b->field     = vb->field;
-	b->timestamp = vb->ts;
+	b->timestamp = ns_to_timeval(vb->ts);
 	b->bytesused = vb->size;
 	b->sequence  = vb->field_count >> 1;
 }
@@ -581,7 +581,7 @@ int videobuf_qbuf(struct videobuf_queue *q, struct v4l2_buffer *b)
 		    || q->type == V4L2_BUF_TYPE_SDR_OUTPUT) {
 			buf->size = b->bytesused;
 			buf->field = b->field;
-			buf->ts = b->timestamp;
+			buf->ts = v4l2_timeval_to_ns(&b->timestamp);
 		}
 		break;
 	case V4L2_MEMORY_USERPTR:
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 60a664febba0..5684dc6f0d0d 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -80,7 +80,7 @@ struct videobuf_buffer {
 	struct list_head        queue;
 	wait_queue_head_t       done;
 	unsigned int            field_count;
-	struct timeval          ts;
+	u64			ts;
 
 	/* Memory type */
 	enum v4l2_memory        memory;
-- 
2.20.1

