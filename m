Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:18881 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3ARQCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 11:02:47 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGT00C3PWKJDEY0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 19 Jan 2013 01:02:45 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGT008T3WKC6W30@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 19 Jan 2013 01:02:45 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, dh09.lee@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyugmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] s5p-fimc: fimc-lite: Prevent deadlock at STREAMON/OFF
 ioctls
Date: Fri, 18 Jan 2013 17:02:32 +0100
Message-id: <1358524952-25156-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1358524952-25156-1-git-send-email-s.nawrocki@samsung.com>
References: <1358524952-25156-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes regression introduced in commit 6319d6a002beb26631
'[media] fimc-lite: Add ISP FIFO output support'.

In case of a configuration where video is captured at the video node
exposed by the FIMC-LITE driver there is a following video pipeline:

sensor -> MIPI-CSIS.n -> FIMC-LITE.n subdev -> FIMC-LITE.n video node

In this situation s_stream() handler of the FIMC-LITE.n is called
back from within VIDIOC_STREAMON/OFF ioctl of the FIMC-LITE.n video
node, through vb2_stream_on/off(), start/stop_streaming and
fimc_pipeline_call(set_stream). The fimc->lock mutex is already held
then, before invoking vidioc_streamon/off. So it must not be taken
again in the s_stream() callback in this case, to avoid a deadlock.

This patch makes fimc->out_path atomic_t so the mutex don't need
to be taken in the FIMC-LITE subdev s_stream() callback in the DMA
output case.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    2 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c     |   35 ++++++++++++-----------
 drivers/media/platform/s5p-fimc/fimc-lite.h     |    2 +-
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
index aa7466a..f0af075 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
@@ -65,7 +65,7 @@ void flite_hw_set_interrupt_mask(struct fimc_lite *dev)
 	u32 cfg, intsrc;

 	/* Select interrupts to be enabled for each output mode */
-	if (dev->out_path == FIMC_IO_DMA) {
+	if (atomic_read(&dev->out_path) == FIMC_IO_DMA) {
 		intsrc = FLITE_REG_CIGCTRL_IRQ_OVFEN |
 			 FLITE_REG_CIGCTRL_IRQ_LASTEN |
 			 FLITE_REG_CIGCTRL_IRQ_STARTEN;
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 15db03e2..be7e6f1 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -261,7 +261,7 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 		wake_up(&fimc->irq_queue);
 	}

-	if (fimc->out_path != FIMC_IO_DMA)
+	if (atomic_read(&fimc->out_path) != FIMC_IO_DMA)
 		goto done;

 	if ((intsrc & FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART) &&
@@ -466,7 +466,7 @@ static int fimc_lite_open(struct file *file)
 	mutex_lock(&me->parent->graph_mutex);

 	mutex_lock(&fimc->lock);
-	if (fimc->out_path != FIMC_IO_DMA) {
+	if (atomic_read(&fimc->out_path) != FIMC_IO_DMA) {
 		ret = -EBUSY;
 		goto done;
 	}
@@ -480,7 +480,8 @@ static int fimc_lite_open(struct file *file)
 	if (ret < 0)
 		goto done;

-	if (++fimc->ref_count == 1 && fimc->out_path == FIMC_IO_DMA) {
+	if (++fimc->ref_count == 1 &&
+	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
 		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
 					 &fimc->vfd.entity, true);
 		if (ret < 0) {
@@ -505,7 +506,8 @@ static int fimc_lite_close(struct file *file)

 	mutex_lock(&fimc->lock);

-	if (--fimc->ref_count == 0 && fimc->out_path == FIMC_IO_DMA) {
+	if (--fimc->ref_count == 0 &&
+	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
 		fimc_lite_stop_capture(fimc, false);
 		fimc_pipeline_call(fimc, close, &fimc->pipeline);
@@ -1035,18 +1037,18 @@ static int fimc_lite_link_setup(struct media_entity *entity,

 	case FLITE_SD_PAD_SOURCE_DMA:
 		if (!(flags & MEDIA_LNK_FL_ENABLED))
-			fimc->out_path = FIMC_IO_NONE;
+			atomic_set(&fimc->out_path, FIMC_IO_NONE);
 		else if (remote_ent_type == MEDIA_ENT_T_DEVNODE)
-			fimc->out_path = FIMC_IO_DMA;
+			atomic_set(&fimc->out_path, FIMC_IO_DMA);
 		else
 			ret = -EINVAL;
 		break;

 	case FLITE_SD_PAD_SOURCE_ISP:
 		if (!(flags & MEDIA_LNK_FL_ENABLED))
-			fimc->out_path = FIMC_IO_NONE;
+			atomic_set(&fimc->out_path, FIMC_IO_NONE);
 		else if (remote_ent_type == MEDIA_ENT_T_V4L2_SUBDEV)
-			fimc->out_path = FIMC_IO_ISP;
+			atomic_set(&fimc->out_path, FIMC_IO_ISP);
 		else
 			ret = -EINVAL;
 		break;
@@ -1055,6 +1057,7 @@ static int fimc_lite_link_setup(struct media_entity *entity,
 		v4l2_err(sd, "Invalid pad index\n");
 		ret = -EINVAL;
 	}
+	mb();

 	mutex_unlock(&fimc->lock);
 	return ret;
@@ -1124,8 +1127,10 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
 	mutex_lock(&fimc->lock);

-	if ((fimc->out_path == FIMC_IO_ISP && sd->entity.stream_count > 0) ||
-	    (fimc->out_path == FIMC_IO_DMA && vb2_is_busy(&fimc->vb_queue))) {
+	if ((atomic_read(&fimc->out_path) == FIMC_IO_ISP &&
+	    sd->entity.stream_count > 0) ||
+	    (atomic_read(&fimc->out_path) == FIMC_IO_DMA &&
+	    vb2_is_busy(&fimc->vb_queue))) {
 		mutex_unlock(&fimc->lock);
 		return -EBUSY;
 	}
@@ -1248,12 +1253,10 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 	 */
 	fimc->sensor = __find_remote_sensor(&sd->entity);

-	mutex_lock(&fimc->lock);
-	if (fimc->out_path != FIMC_IO_ISP) {
-		mutex_unlock(&fimc->lock);
+	if (atomic_read(&fimc->out_path) != FIMC_IO_ISP)
 		return -ENOIOCTLCMD;
-	}

+	mutex_lock(&fimc->lock);
 	if (on) {
 		flite_hw_reset(fimc);
 		ret = fimc_lite_hw_init(fimc, true);
@@ -1299,7 +1302,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 	memset(vfd, 0, sizeof(*vfd));

 	fimc->fmt = &fimc_lite_formats[0];
-	fimc->out_path = FIMC_IO_DMA;
+	atomic_set(&fimc->out_path, FIMC_IO_DMA);

 	snprintf(vfd->name, sizeof(vfd->name), "fimc-lite.%d.capture",
 		 fimc->index);
@@ -1606,7 +1609,7 @@ static int fimc_lite_resume(struct device *dev)
 	INIT_LIST_HEAD(&fimc->active_buf_q);
 	fimc_pipeline_call(fimc, open, &fimc->pipeline,
 			   &fimc->vfd.entity, false);
-	fimc_lite_hw_init(fimc, fimc->out_path == FIMC_IO_ISP);
+	fimc_lite_hw_init(fimc, atomic_read(&fimc->out_path) == FIMC_IO_ISP);
 	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);

 	for (i = 0; i < fimc->reqbufs_count; i++) {
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
index 4576922..7085761 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.h
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
@@ -159,7 +159,7 @@ struct fimc_lite {
 	unsigned long		payload[FLITE_MAX_PLANES];
 	struct flite_frame	inp_frame;
 	struct flite_frame	out_frame;
-	enum fimc_datapath	out_path;
+	atomic_t		out_path;
 	unsigned int		source_subdev_grp_id;

 	unsigned long		state;
--
1.7.9.5

