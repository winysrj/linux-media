Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3439 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3CBXpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/20] solo6x10: move global fields in solo_dev_fh to solo_dev.
Date: Sun,  3 Mar 2013 00:45:26 +0100
Message-Id: <e5f6a7fd0f4961531784c3500d8d14b5342c1cdb.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

All fields in solo_dev_fh do not belong there since they refer to global
properties. After moving all these fields to solo_dev the solo_dev_fh
struct can be removed completely.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10.h |    9 +
 drivers/staging/media/solo6x10/v4l2.c     |  254 ++++++++++++-----------------
 2 files changed, 114 insertions(+), 149 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index ef18abd..fcbe8ecf 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -252,6 +252,15 @@ struct solo_dev {
 	struct snd_pcm		*snd_pcm;
 	atomic_t		snd_users;
 	int			g723_hw_idx;
+
+	/* Buffer handling */
+	struct videobuf_queue	vidq;
+	struct task_struct      *kthread;
+	spinlock_t		slock;
+	int			old_write;
+	struct list_head	vidq_active;
+	struct p2m_desc		desc[SOLO_NR_P2M_DESC];
+	int			desc_idx;
 };
 
 static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index d9298ac..ea9bda0 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -38,19 +38,6 @@
 
 #define MIN_VID_BUFFERS		4
 
-/* Simple file handle */
-struct solo_filehandle {
-	struct v4l2_fh		fh;
-	struct solo_dev		*solo_dev;
-	struct videobuf_queue	vidq;
-	struct task_struct      *kthread;
-	spinlock_t		slock;
-	int			old_write;
-	struct list_head	vidq_active;
-	struct p2m_desc		desc[SOLO_NR_P2M_DESC];
-	int			desc_idx;
-};
-
 unsigned video_nr = -1;
 module_param(video_nr, uint, 0644);
 MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect (default)");
@@ -203,47 +190,46 @@ static int solo_v4l2_set_ch(struct solo_dev *solo_dev, u8 ch)
 	return 0;
 }
 
-static void disp_reset_desc(struct solo_filehandle *fh)
+static void disp_reset_desc(struct solo_dev *solo_dev)
 {
 	/* We use desc mode, which ignores desc 0 */
-	memset(fh->desc, 0, sizeof(*fh->desc));
-	fh->desc_idx = 1;
+	memset(solo_dev->desc, 0, sizeof(*solo_dev->desc));
+	solo_dev->desc_idx = 1;
 }
 
-static int disp_flush_descs(struct solo_filehandle *fh)
+static int disp_flush_descs(struct solo_dev *solo_dev)
 {
 	int ret;
 
-	if (!fh->desc_idx)
+	if (!solo_dev->desc_idx)
 		return 0;
 
-	ret = solo_p2m_dma_desc(fh->solo_dev, SOLO_P2M_DMA_ID_DISP,
-				fh->desc, fh->desc_idx);
-	disp_reset_desc(fh);
+	ret = solo_p2m_dma_desc(solo_dev, SOLO_P2M_DMA_ID_DISP,
+				solo_dev->desc, solo_dev->desc_idx);
+	disp_reset_desc(solo_dev);
 
 	return ret;
 }
 
-static int disp_push_desc(struct solo_filehandle *fh, dma_addr_t dma_addr,
+static int disp_push_desc(struct solo_dev *solo_dev, dma_addr_t dma_addr,
 		      u32 ext_addr, int size, int repeat, int ext_size)
 {
-	if (fh->desc_idx >= SOLO_NR_P2M_DESC) {
-		int ret = disp_flush_descs(fh);
+	if (solo_dev->desc_idx >= SOLO_NR_P2M_DESC) {
+		int ret = disp_flush_descs(solo_dev);
 		if (ret)
 			return ret;
 	}
 
-	solo_p2m_push_desc(&fh->desc[fh->desc_idx], 0, dma_addr, ext_addr,
+	solo_p2m_push_desc(&solo_dev->desc[solo_dev->desc_idx], 0, dma_addr, ext_addr,
 			   size, repeat, ext_size);
-	fh->desc_idx++;
+	solo_dev->desc_idx++;
 
 	return 0;
 }
 
-static void solo_fillbuf(struct solo_filehandle *fh,
+static void solo_fillbuf(struct solo_dev *solo_dev,
 			 struct videobuf_buffer *vb)
 {
-	struct solo_dev *solo_dev = fh->solo_dev;
 	struct videobuf_dmabuf *vbuf;
 	unsigned int fdma_addr;
 	int error = 1;
@@ -274,12 +260,12 @@ static void solo_fillbuf(struct solo_filehandle *fh,
 		goto finish_buf;
 	}
 
-	disp_reset_desc(fh);
+	disp_reset_desc(solo_dev);
 	sg = vbuf->sglist;
 	sg_dma = sg_dma_address(sg);
 	sg_size_left = sg_dma_len(sg);
 
-	fdma_addr = SOLO_DISP_EXT_ADDR + (fh->old_write *
+	fdma_addr = SOLO_DISP_EXT_ADDR + (solo_dev->old_write *
 			(SOLO_HW_BPL * solo_vlines(solo_dev)));
 
 	for (i = 0; i < solo_vlines(solo_dev); i++) {
@@ -311,7 +297,7 @@ static void solo_fillbuf(struct solo_filehandle *fh,
 
 				this_write = min(sg_size_left, line_len);
 
-				if (disp_push_desc(fh, sg_dma, this_addr,
+				if (disp_push_desc(solo_dev, sg_dma, this_addr,
 						   this_write, 0, 0))
 					goto finish_buf;
 
@@ -329,7 +315,7 @@ static void solo_fillbuf(struct solo_filehandle *fh,
 		lines = min(sg_size_left / line_len,
 			    solo_vlines(solo_dev) - i);
 
-		if (disp_push_desc(fh, sg_dma, fdma_addr, line_len,
+		if (disp_push_desc(solo_dev, sg_dma, fdma_addr, line_len,
 				   lines - 1, SOLO_HW_BPL))
 			goto finish_buf;
 
@@ -339,7 +325,7 @@ static void solo_fillbuf(struct solo_filehandle *fh,
 		sg_size_left -= lines * line_len;
 	}
 
-	error = disp_flush_descs(fh);
+	error = disp_flush_descs(solo_dev);
 
 finish_buf:
 	if (error) {
@@ -356,44 +342,43 @@ finish_buf:
 	return;
 }
 
-static void solo_thread_try(struct solo_filehandle *fh)
+static void solo_thread_try(struct solo_dev *solo_dev)
 {
 	struct videobuf_buffer *vb;
 	unsigned int cur_write;
 
 	for (;;) {
-		spin_lock(&fh->slock);
+		spin_lock(&solo_dev->slock);
 
-		if (list_empty(&fh->vidq_active))
+		if (list_empty(&solo_dev->vidq_active))
 			break;
 
-		vb = list_first_entry(&fh->vidq_active, struct videobuf_buffer,
+		vb = list_first_entry(&solo_dev->vidq_active, struct videobuf_buffer,
 				      queue);
 
 		if (!waitqueue_active(&vb->done))
 			break;
 
-		cur_write = SOLO_VI_STATUS0_PAGE(solo_reg_read(fh->solo_dev,
+		cur_write = SOLO_VI_STATUS0_PAGE(solo_reg_read(solo_dev,
 						 SOLO_VI_STATUS0));
-		if (cur_write == fh->old_write)
+		if (cur_write == solo_dev->old_write)
 			break;
 
-		fh->old_write = cur_write;
+		solo_dev->old_write = cur_write;
 		list_del(&vb->queue);
 
-		spin_unlock(&fh->slock);
+		spin_unlock(&solo_dev->slock);
 
-		solo_fillbuf(fh, vb);
+		solo_fillbuf(solo_dev, vb);
 	}
 
-	assert_spin_locked(&fh->slock);
-	spin_unlock(&fh->slock);
+	assert_spin_locked(&solo_dev->slock);
+	spin_unlock(&solo_dev->slock);
 }
 
 static int solo_thread(void *data)
 {
-	struct solo_filehandle *fh = data;
-	struct solo_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = data;
 	DECLARE_WAITQUEUE(wait, current);
 
 	set_freezable();
@@ -403,7 +388,7 @@ static int solo_thread(void *data)
 		long timeout = schedule_timeout_interruptible(HZ);
 		if (timeout == -ERESTARTSYS || kthread_should_stop())
 			break;
-		solo_thread_try(fh);
+		solo_thread_try(solo_dev);
 		try_to_freeze();
 	}
 
@@ -412,26 +397,25 @@ static int solo_thread(void *data)
 	return 0;
 }
 
-static int solo_start_thread(struct solo_filehandle *fh)
+static int solo_start_thread(struct solo_dev *solo_dev)
 {
-	fh->kthread = kthread_run(solo_thread, fh, SOLO6X10_NAME "_disp");
+	solo_dev->kthread = kthread_run(solo_thread, solo_dev, SOLO6X10_NAME "_disp");
 
-	return PTR_RET(fh->kthread);
+	return PTR_RET(solo_dev->kthread);
 }
 
-static void solo_stop_thread(struct solo_filehandle *fh)
+static void solo_stop_thread(struct solo_dev *solo_dev)
 {
-	if (fh->kthread) {
-		kthread_stop(fh->kthread);
-		fh->kthread = NULL;
+	if (solo_dev->kthread) {
+		kthread_stop(solo_dev->kthread);
+		solo_dev->kthread = NULL;
 	}
 }
 
 static int solo_buf_setup(struct videobuf_queue *vq, unsigned int *count,
 			  unsigned int *size)
 {
-	struct solo_filehandle *fh = vq->priv_data;
-	struct solo_dev *solo_dev  = fh->solo_dev;
+	struct solo_dev *solo_dev = vq->priv_data;
 
 	*size = solo_image_size(solo_dev);
 
@@ -444,8 +428,7 @@ static int solo_buf_setup(struct videobuf_queue *vq, unsigned int *count,
 static int solo_buf_prepare(struct videobuf_queue *vq,
 			    struct videobuf_buffer *vb, enum v4l2_field field)
 {
-	struct solo_filehandle *fh  = vq->priv_data;
-	struct solo_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = vq->priv_data;
 
 	vb->size = solo_image_size(solo_dev);
 	if (vb->baddr != 0 && vb->bsize < vb->size)
@@ -475,11 +458,10 @@ static int solo_buf_prepare(struct videobuf_queue *vq,
 static void solo_buf_queue(struct videobuf_queue *vq,
 			   struct videobuf_buffer *vb)
 {
-	struct solo_filehandle *fh = vq->priv_data;
-	struct solo_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = vq->priv_data;
 
 	vb->state = VIDEOBUF_QUEUED;
-	list_add_tail(&vb->queue, &fh->vidq_active);
+	list_add_tail(&vb->queue, &solo_dev->vidq_active);
 	wake_up_interruptible(&solo_dev->disp_thread_wait);
 }
 
@@ -503,81 +485,45 @@ static struct videobuf_queue_ops solo_video_qops = {
 static unsigned int solo_v4l2_poll(struct file *file,
 				   struct poll_table_struct *wait)
 {
-	struct solo_filehandle *fh = file->private_data;
+	struct solo_dev *solo_dev = video_drvdata(file);
 	unsigned long req_events = poll_requested_events(wait);
 	unsigned res = v4l2_ctrl_poll(file, wait);
 
 	if (!(req_events & (POLLIN | POLLRDNORM)))
 		return res;
-	return res | videobuf_poll_stream(file, &fh->vidq, wait);
+	return res | videobuf_poll_stream(file, &solo_dev->vidq, wait);
 }
 
 static int solo_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct solo_filehandle *fh = file->private_data;
-
-	return videobuf_mmap_mapper(&fh->vidq, vma);
-}
-
-static int solo_v4l2_open(struct file *file)
-{
 	struct solo_dev *solo_dev = video_drvdata(file);
-	struct solo_filehandle *fh;
-	int ret;
-
-	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (fh == NULL)
-		return -ENOMEM;
-
-	v4l2_fh_init(&fh->fh, video_devdata(file));
-	spin_lock_init(&fh->slock);
-	INIT_LIST_HEAD(&fh->vidq_active);
-	fh->solo_dev = solo_dev;
-	file->private_data = fh;
-
-	ret = solo_start_thread(fh);
-	if (ret) {
-		kfree(fh);
-		return ret;
-	}
 
-	videobuf_queue_sg_init(&fh->vidq, &solo_video_qops,
-			       &solo_dev->pdev->dev, &fh->slock,
-			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			       V4L2_FIELD_INTERLACED,
-			       sizeof(struct videobuf_buffer), fh, NULL);
-	v4l2_fh_add(&fh->fh);
-	return 0;
+	return videobuf_mmap_mapper(&solo_dev->vidq, vma);
 }
 
 static ssize_t solo_v4l2_read(struct file *file, char __user *data,
 			      size_t count, loff_t *ppos)
 {
-	struct solo_filehandle *fh = file->private_data;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
-	return videobuf_read_stream(&fh->vidq, data, count, ppos, 0,
+	return videobuf_read_stream(&solo_dev->vidq, data, count, ppos, 0,
 				    file->f_flags & O_NONBLOCK);
 }
 
 static int solo_v4l2_release(struct file *file)
 {
-	struct solo_filehandle *fh = file->private_data;
-
-	videobuf_stop(&fh->vidq);
-	videobuf_mmap_free(&fh->vidq);
-	solo_stop_thread(fh);
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
-	kfree(fh);
+	struct solo_dev *solo_dev = video_drvdata(file);
 
-	return 0;
+	videobuf_stop(&solo_dev->vidq);
+	videobuf_mmap_free(&solo_dev->vidq);
+	solo_stop_thread(solo_dev);
+	return v4l2_fh_release(file);
 }
 
 static int solo_querycap(struct file *file, void  *priv,
 			 struct v4l2_capability *cap)
 {
-	struct solo_filehandle  *fh  = priv;
-	struct solo_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
 	strcpy(cap->driver, SOLO6X10_NAME);
 	strcpy(cap->card, "Softlogic 6x10");
@@ -618,8 +564,7 @@ static int solo_enum_ext_input(struct solo_dev *solo_dev,
 static int solo_enum_input(struct file *file, void *priv,
 			   struct v4l2_input *input)
 {
-	struct solo_filehandle *fh  = priv;
-	struct solo_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
 	if (input->index >= solo_dev->nr_chans) {
 		int ret = solo_enum_ext_input(solo_dev, input);
@@ -646,16 +591,16 @@ static int solo_enum_input(struct file *file, void *priv,
 
 static int solo_set_input(struct file *file, void *priv, unsigned int index)
 {
-	struct solo_filehandle *fh = priv;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
-	return solo_v4l2_set_ch(fh->solo_dev, index);
+	return solo_v4l2_set_ch(solo_dev, index);
 }
 
 static int solo_get_input(struct file *file, void *priv, unsigned int *index)
 {
-	struct solo_filehandle *fh = priv;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
-	*index = fh->solo_dev->cur_disp_ch;
+	*index = solo_dev->cur_disp_ch;
 
 	return 0;
 }
@@ -675,8 +620,7 @@ static int solo_enum_fmt_cap(struct file *file, void *priv,
 static int solo_try_fmt_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
-	struct solo_filehandle *fh = priv;
-	struct solo_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = video_drvdata(file);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int image_size = solo_image_size(solo_dev);
 
@@ -696,9 +640,9 @@ static int solo_try_fmt_cap(struct file *file, void *priv,
 static int solo_set_fmt_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
-	struct solo_filehandle *fh = priv;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
-	if (videobuf_queue_is_busy(&fh->vidq))
+	if (videobuf_queue_is_busy(&solo_dev->vidq))
 		return -EBUSY;
 
 	/* For right now, if it doesn't match our running config,
@@ -709,8 +653,7 @@ static int solo_set_fmt_cap(struct file *file, void *priv,
 static int solo_get_fmt_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
-	struct solo_filehandle *fh = priv;
-	struct solo_dev *solo_dev = fh->solo_dev;
+	struct solo_dev *solo_dev = video_drvdata(file);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	pix->width = solo_dev->video_hsize;
@@ -728,50 +671,55 @@ static int solo_get_fmt_cap(struct file *file, void *priv,
 static int solo_reqbufs(struct file *file, void *priv,
 			struct v4l2_requestbuffers *req)
 {
-	struct solo_filehandle *fh = priv;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
-	return videobuf_reqbufs(&fh->vidq, req);
+	return videobuf_reqbufs(&solo_dev->vidq, req);
 }
 
 static int solo_querybuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct solo_filehandle *fh = priv;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
-	return videobuf_querybuf(&fh->vidq, buf);
+	return videobuf_querybuf(&solo_dev->vidq, buf);
 }
 
 static int solo_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct solo_filehandle *fh = priv;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
-	return videobuf_qbuf(&fh->vidq, buf);
+	return videobuf_qbuf(&solo_dev->vidq, buf);
 }
 
 static int solo_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct solo_filehandle *fh = priv;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
-	return videobuf_dqbuf(&fh->vidq, buf, file->f_flags & O_NONBLOCK);
+	return videobuf_dqbuf(&solo_dev->vidq, buf, file->f_flags & O_NONBLOCK);
 }
 
 static int solo_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	struct solo_filehandle *fh = priv;
+	struct solo_dev *solo_dev = video_drvdata(file);
+	int ret;
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	return videobuf_streamon(&fh->vidq);
+	ret = solo_start_thread(solo_dev);
+	if (ret)
+		return ret;
+
+	return videobuf_streamon(&solo_dev->vidq);
 }
 
 static int solo_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	struct solo_filehandle *fh = priv;
+	struct solo_dev *solo_dev = video_drvdata(file);
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	return videobuf_streamoff(&fh->vidq);
+	return videobuf_streamoff(&solo_dev->vidq);
 }
 
 static int solo_s_std(struct file *file, void *priv, v4l2_std_id *i)
@@ -810,7 +758,7 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 
 static const struct v4l2_file_operations solo_v4l2_fops = {
 	.owner			= THIS_MODULE,
-	.open			= solo_v4l2_open,
+	.open			= v4l2_fh_open,
 	.release		= solo_v4l2_release,
 	.read			= solo_v4l2_read,
 	.poll			= solo_v4l2_poll,
@@ -886,25 +834,16 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 		return solo_dev->disp_hdl.error;
 	solo_dev->vfd->ctrl_handler = &solo_dev->disp_hdl;
 	set_bit(V4L2_FL_USE_FH_PRIO, &solo_dev->vfd->flags);
-
-	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, video_nr);
-	if (ret < 0) {
-		video_device_release(solo_dev->vfd);
-		solo_dev->vfd = NULL;
-		return ret;
-	}
-
 	video_set_drvdata(solo_dev->vfd, solo_dev);
 
-	snprintf(solo_dev->vfd->name, sizeof(solo_dev->vfd->name), "%s (%i)",
-		 SOLO6X10_NAME, solo_dev->vfd->num);
-
-	if (video_nr != -1)
-		video_nr++;
+	spin_lock_init(&solo_dev->slock);
+	INIT_LIST_HEAD(&solo_dev->vidq_active);
 
-	dev_info(&solo_dev->pdev->dev, "Display as /dev/video%d with "
-		 "%d inputs (%d extended)\n", solo_dev->vfd->num,
-		 solo_dev->nr_chans, solo_dev->nr_ext);
+	videobuf_queue_sg_init(&solo_dev->vidq, &solo_video_qops,
+			       &solo_dev->pdev->dev, &solo_dev->slock,
+			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			       V4L2_FIELD_INTERLACED,
+			       sizeof(struct videobuf_buffer), solo_dev, NULL);
 
 	/* Cycle all the channels and clear */
 	for (i = 0; i < solo_dev->nr_chans; i++) {
@@ -920,6 +859,23 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 
 	solo_irq_on(solo_dev, SOLO_IRQ_VIDEO_IN);
 
+	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, video_nr);
+	if (ret < 0) {
+		video_device_release(solo_dev->vfd);
+		solo_dev->vfd = NULL;
+		return ret;
+	}
+
+	snprintf(solo_dev->vfd->name, sizeof(solo_dev->vfd->name), "%s (%i)",
+		 SOLO6X10_NAME, solo_dev->vfd->num);
+
+	if (video_nr != -1)
+		video_nr++;
+
+	dev_info(&solo_dev->pdev->dev, "Display as /dev/video%d with "
+		 "%d inputs (%d extended)\n", solo_dev->vfd->num,
+		 solo_dev->nr_chans, solo_dev->nr_ext);
+
 	return 0;
 }
 
-- 
1.7.10.4

