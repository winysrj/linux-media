Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54028 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbcIGWY5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 18:24:57 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH v3 10/10] v4l: fdp1: Store buffer information in vb2 buffer
Date: Thu,  8 Sep 2016 01:25:10 +0300
Message-Id: <1473287110-780-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct fdp1_buffer instances are allocated separately from the vb2
buffers, with one instance per field. Simplify the allocation by
splitting the fdp1_buffer structure in per-buffer and per-field data,
and let vb2 allocate the the fdp1_buffer structure.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar_fdp1.c | 437 ++++++++++++++++++-------------------
 1 file changed, 210 insertions(+), 227 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index c25531a919db..d4101a4fd114 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -473,12 +473,12 @@ static const u8 fdp1_mdet[] = {
 
 /* Per-queue, driver-specific private data */
 struct fdp1_q_data {
-	const struct fdp1_fmt	*fmt;
-	struct v4l2_pix_format_mplane format;
+	const struct fdp1_fmt		*fmt;
+	struct v4l2_pix_format_mplane	format;
 
-	unsigned int		vsize;
-	unsigned int		stride_y;
-	unsigned int		stride_c;
+	unsigned int			vsize;
+	unsigned int			stride_y;
+	unsigned int			stride_c;
 };
 
 static const struct fdp1_fmt *fdp1_find_format(u32 pixelformat)
@@ -519,91 +519,102 @@ enum fdp1_deint_mode {
  * from the VB buffers using this context structure.
  * Will always be a field or a full frame, never two fields.
  */
-struct fdp1_buffer {
-	struct vb2_v4l2_buffer	*vb;
-	dma_addr_t		addrs[3];
+struct fdp1_field_buffer {
+	struct vb2_v4l2_buffer		*vb;
+	dma_addr_t			addrs[3];
 
 	/* Should be NONE:TOP:BOTTOM only */
-	enum v4l2_field		field;
+	enum v4l2_field			field;
 
 	/* Flag to indicate this is the last field in the vb */
-	bool			last_field;
+	bool				last_field;
 
 	/* Buffer queue lists */
-	struct list_head	list;
+	struct list_head		list;
+};
+
+struct fdp1_buffer {
+	struct v4l2_m2m_buffer		m2m_buf;
+	struct fdp1_field_buffer	fields[2];
+	unsigned int			num_fields;
 };
 
+static inline struct fdp1_buffer *to_fdp1_buffer(struct vb2_v4l2_buffer *vb)
+{
+	return container_of(vb, struct fdp1_buffer, m2m_buf.vb);
+}
+
 struct fdp1_job {
 	/* These could be pointers to save 'memory' and copying */
-	struct fdp1_buffer	*previous;
-	struct fdp1_buffer	*active;
-	struct fdp1_buffer	*next;
-	struct fdp1_buffer	dst;
+	struct fdp1_field_buffer	*previous;
+	struct fdp1_field_buffer	*active;
+	struct fdp1_field_buffer	*next;
+	struct fdp1_field_buffer	*dst;
 
 	/* A job can only be on one list at a time */
-	struct list_head	list;
+	struct list_head		list;
 };
 
 struct fdp1_dev {
-	struct v4l2_device	v4l2_dev;
-	struct video_device	vfd;
+	struct v4l2_device		v4l2_dev;
+	struct video_device		vfd;
 
-	struct mutex		dev_mutex;
-	spinlock_t		irqlock;
-	spinlock_t		device_process_lock;
+	struct mutex			dev_mutex;
+	spinlock_t			irqlock;
+	spinlock_t			device_process_lock;
 
-	void __iomem		*regs;
-	unsigned int		irq;
-	struct device		*dev;
+	void __iomem			*regs;
+	unsigned int			irq;
+	struct device			*dev;
 
 	/* Job Queues */
-	struct fdp1_job		jobs[FDP1_NUMBER_JOBS];
-	struct list_head	free_job_list;
-	struct list_head	queued_job_list;
-	struct list_head	hw_job_list;
+	struct fdp1_job			jobs[FDP1_NUMBER_JOBS];
+	struct list_head		free_job_list;
+	struct list_head		queued_job_list;
+	struct list_head		hw_job_list;
 
-	unsigned int		clk_rate;
+	unsigned int			clk_rate;
 
-	struct rcar_fcp_device	*fcp;
-	struct v4l2_m2m_dev	*m2m_dev;
+	struct rcar_fcp_device		*fcp;
+	struct v4l2_m2m_dev		*m2m_dev;
 };
 
 struct fdp1_ctx {
-	struct v4l2_fh		fh;
-	struct fdp1_dev		*fdp1;
+	struct v4l2_fh			fh;
+	struct fdp1_dev			*fdp1;
 
-	struct v4l2_ctrl_handler hdl;
-	unsigned int		sequence;
+	struct v4l2_ctrl_handler	hdl;
+	unsigned int			sequence;
 
 	/* Processed buffers in this transaction */
-	u8			num_processed;
+	u8				num_processed;
 
 	/* Transaction length (i.e. how many buffers per transaction) */
-	u32			translen;
+	u32				translen;
 
 	/* Abort requested by m2m */
-	int			aborting;
+	int				aborting;
 
 	/* Deinterlace processing mode */
-	enum fdp1_deint_mode	deint_mode;
+	enum fdp1_deint_mode		deint_mode;
 
 	/*
 	 * Adaptive 2d 3d mode uses a shared mask
 	 * This is allocated at streamon, if the ADAPT2D3D mode
 	 * is requested
 	 */
-	unsigned int		smsk_size;
-	dma_addr_t		smsk_addr[2];
-	void			*smsk_cpu;
+	unsigned int			smsk_size;
+	dma_addr_t			smsk_addr[2];
+	void				*smsk_cpu;
 
 	/* Capture pipeline, can specify an alpha value
 	 * for supported formats. 0-255 only
 	 */
-	unsigned char		alpha;
+	unsigned char			alpha;
 
 	/* Source and destination queue data */
-	struct fdp1_q_data	out_q; /* HW Source */
-	struct fdp1_q_data	cap_q; /* HW Destination */
+	struct fdp1_q_data		out_q; /* HW Source */
+	struct fdp1_q_data		cap_q; /* HW Destination */
 
 	/*
 	 * Field Queues
@@ -613,16 +624,14 @@ struct fdp1_ctx {
 	 * V4L2 Buffers are tracked inside the fdp1_buffer
 	 * and released when the last 'field' completes
 	 */
-	struct fdp1_buffer	buffers[FDP1_NUMBER_BUFFERS];
-	struct list_head	free_buffers;
-	struct list_head	fdp1_buffer_queue;
-	unsigned int		buffers_queued;
+	struct list_head		fields_queue;
+	unsigned int			buffers_queued;
 
 	/*
 	 * For de-interlacing we need to track our previous buffer
 	 * while preparing our job lists.
 	 */
-	struct fdp1_buffer	*previous;
+	struct fdp1_field_buffer	*previous;
 };
 
 static inline struct fdp1_ctx *fh_to_ctx(struct v4l2_fh *fh)
@@ -711,90 +720,61 @@ static struct fdp1_job *get_hw_queued_job(struct fdp1_dev *fdp1)
 /*
  * Buffer lists handling
  */
-static struct fdp1_buffer *list_remove_buffer(struct fdp1_dev *fdp1,
-					       struct list_head *list)
+static void fdp1_field_complete(struct fdp1_ctx *ctx,
+				struct fdp1_field_buffer *fbuf)
 {
-	struct fdp1_buffer *buf;
-	unsigned long flags;
-
-	spin_lock_irqsave(&fdp1->irqlock, flags);
-	buf = list_first_entry_or_null(list, struct fdp1_buffer, list);
-	if (buf)
-		list_del(&buf->list);
-	spin_unlock_irqrestore(&fdp1->irqlock, flags);
+	/* job->previous may be on the first field */
+	if (!fbuf)
+		return;
 
-	return buf;
+	if (fbuf->last_field)
+		v4l2_m2m_buf_done(fbuf->vb, VB2_BUF_STATE_DONE);
 }
 
-/*
- * list_add_buffer: Add a buffer to the specified list
- *
- * Returns: void - always succeeds
- */
-static void list_add_buffer(struct fdp1_dev *fdp1,
-			    struct list_head *list,
-			    struct fdp1_buffer *buf)
+static void fdp1_queue_field(struct fdp1_ctx *ctx,
+			     struct fdp1_field_buffer *fbuf)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&fdp1->irqlock, flags);
-	list_add_tail(&buf->list, list);
-	spin_unlock_irqrestore(&fdp1->irqlock, flags);
-}
+	spin_lock_irqsave(&ctx->fdp1->irqlock, flags);
+	list_add_tail(&fbuf->list, &ctx->fields_queue);
+	spin_unlock_irqrestore(&ctx->fdp1->irqlock, flags);
 
-/*
- * fdp1_buffer_alloc: Retrieve a buffer to track a single field/frame
- *
- * Must always return a buffer, and should block if necessary.
- */
-static struct fdp1_buffer *fdp1_buffer_alloc(struct fdp1_ctx *ctx)
-{
-	return list_remove_buffer(ctx->fdp1, &ctx->free_buffers);
+	ctx->buffers_queued++;
 }
 
-static void fdp1_buffer_free(struct fdp1_ctx *ctx,
-			struct fdp1_buffer *buf)
+static struct fdp1_field_buffer *fdp1_dequeue_field(struct fdp1_ctx *ctx)
 {
-	/* job->previous may be on the first field */
-	if (!buf)
-		return;
-
-	if (buf->last_field)
-		v4l2_m2m_buf_done(buf->vb, VB2_BUF_STATE_DONE);
-
-	memset(buf, 0, sizeof(struct fdp1_buffer));
+	struct fdp1_field_buffer *fbuf;
+	unsigned long flags;
 
-	list_add_buffer(ctx->fdp1, &ctx->free_buffers, buf);
-}
+	ctx->buffers_queued--;
 
-static void queue_buffer(struct fdp1_ctx *ctx, struct fdp1_buffer *buf)
-{
-	list_add_buffer(ctx->fdp1, &ctx->fdp1_buffer_queue, buf);
-	ctx->buffers_queued++;
-}
+	spin_lock_irqsave(&ctx->fdp1->irqlock, flags);
+	fbuf = list_first_entry_or_null(&ctx->fields_queue,
+					struct fdp1_field_buffer, list);
+	if (fbuf)
+		list_del(&fbuf->list);
+	spin_unlock_irqrestore(&ctx->fdp1->irqlock, flags);
 
-static struct fdp1_buffer *dequeue_buffer(struct fdp1_ctx *ctx)
-{
-	ctx->buffers_queued--;
-	return list_remove_buffer(ctx->fdp1, &ctx->fdp1_buffer_queue);
+	return fbuf;
 }
 
 /*
- * Return the next buffer in the queue - or NULL,
+ * Return the next field in the queue - or NULL,
  * without removing the item from the list
  */
-static struct fdp1_buffer *peek_queued_buffer(struct fdp1_ctx *ctx)
+static struct fdp1_field_buffer *fdp1_peek_queued_field(struct fdp1_ctx *ctx)
 {
-	struct fdp1_dev *fdp1 = ctx->fdp1;
+	struct fdp1_field_buffer *fbuf;
 	unsigned long flags;
-	struct fdp1_buffer *buf;
 
-	spin_lock_irqsave(&fdp1->irqlock, flags);
-	buf = list_first_entry_or_null(&ctx->fdp1_buffer_queue,
-			struct fdp1_buffer, list);
-	spin_unlock_irqrestore(&fdp1->irqlock, flags);
+	spin_lock_irqsave(&ctx->fdp1->irqlock, flags);
+	fbuf = list_first_entry_or_null(&ctx->fields_queue,
+					struct fdp1_field_buffer, list);
+	spin_unlock_irqrestore(&ctx->fdp1->irqlock, flags);
 
-	return buf;
+	return fbuf;
 }
 
 static u32 fdp1_read(struct fdp1_dev *fdp1, unsigned int reg)
@@ -1015,9 +995,9 @@ static void fdp1_configure_wpf(struct fdp1_ctx *ctx,
 	fdp1_write(fdp1, swap, FD1_WPF_SWAP);
 	fdp1_write(fdp1, pstride, FD1_WPF_PSTRIDE);
 
-	fdp1_write(fdp1, job->dst.addrs[0], FD1_WPF_ADDR_Y);
-	fdp1_write(fdp1, job->dst.addrs[1], FD1_WPF_ADDR_C0);
-	fdp1_write(fdp1, job->dst.addrs[2], FD1_WPF_ADDR_C1);
+	fdp1_write(fdp1, job->dst->addrs[0], FD1_WPF_ADDR_Y);
+	fdp1_write(fdp1, job->dst->addrs[1], FD1_WPF_ADDR_C0);
+	fdp1_write(fdp1, job->dst->addrs[2], FD1_WPF_ADDR_C1);
 }
 
 static void fdp1_configure_deint_mode(struct fdp1_ctx *ctx,
@@ -1196,80 +1176,15 @@ static void fdp1_m2m_job_abort(void *priv)
 }
 
 /*
- * prepare_buffer: Prepare an fdp1_buffer, from a vb2_v4l2_buffer
- *
- * This helps us serialise buffers containing two fields into
- * sequential top and bottom fields.
- * Destination buffers also go through this function to
- * set the vb and addrs in the same manner.
- */
-static void prepare_buffer(struct fdp1_ctx *ctx,
-			   struct fdp1_buffer *buf,
-			   struct vb2_v4l2_buffer *vb,
-			   bool next_field, bool last_field)
-{
-	struct fdp1_q_data *q_data = get_q_data(ctx, vb->vb2_buf.type);
-	unsigned int i;
-
-	buf->vb = vb;
-	buf->last_field = last_field;
-
-	for (i = 0; i < vb->vb2_buf.num_planes; ++i)
-		buf->addrs[i] = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, i);
-
-	switch (vb->field) {
-	case V4L2_FIELD_INTERLACED:
-		/*
-		 * Interlaced means bottom-top for 60Hz TV standards (NTSC) and
-		 * top-bottom for 50Hz. As TV standards are not applicable to
-		 * the mem-to-mem API, use the height as a heuristic.
-		 */
-		buf->field = (q_data->format.height < 576) == next_field
-			   ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
-		break;
-	case V4L2_FIELD_INTERLACED_TB:
-	case V4L2_FIELD_SEQ_TB:
-		buf->field = next_field ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
-		break;
-	case V4L2_FIELD_INTERLACED_BT:
-	case V4L2_FIELD_SEQ_BT:
-		buf->field = next_field ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
-		break;
-	default:
-		buf->field = vb->field;
-		break;
-	}
-
-	/* Buffer is completed */
-	if (next_field == false)
-		return;
-
-	/* Adjust buffer addresses for second field */
-	switch (vb->field) {
-	case V4L2_FIELD_INTERLACED:
-	case V4L2_FIELD_INTERLACED_TB:
-	case V4L2_FIELD_INTERLACED_BT:
-		for (i = 0; i < vb->vb2_buf.num_planes; i++)
-			buf->addrs[i] +=
-				(i == 0 ? q_data->stride_y : q_data->stride_c);
-		break;
-	case V4L2_FIELD_SEQ_TB:
-	case V4L2_FIELD_SEQ_BT:
-		for (i = 0; i < vb->vb2_buf.num_planes; i++)
-			buf->addrs[i] += q_data->vsize *
-				(i == 0 ? q_data->stride_y : q_data->stride_c);
-		break;
-	}
-}
-
-/*
- * prepare_job: Prepare and queue a new job for a single action of work
+ * fdp1_prepare_job: Prepare and queue a new job for a single action of work
  *
  * Prepare the next field, (or frame in progressive) and an output
  * buffer for the hardware to perform a single operation.
  */
-static struct fdp1_job *prepare_job(struct fdp1_ctx *ctx)
+static struct fdp1_job *fdp1_prepare_job(struct fdp1_ctx *ctx)
 {
+	struct vb2_v4l2_buffer *vbuf;
+	struct fdp1_buffer *fbuf;
 	struct fdp1_dev *fdp1 = ctx->fdp1;
 	struct fdp1_job *job;
 	unsigned int buffers_required = 1;
@@ -1280,7 +1195,7 @@ static struct fdp1_job *prepare_job(struct fdp1_ctx *ctx)
 		buffers_required = 2;
 
 	if (ctx->buffers_queued < buffers_required)
-		return 0;
+		return NULL;
 
 	job = fdp1_job_alloc(fdp1);
 	if (!job) {
@@ -1288,7 +1203,7 @@ static struct fdp1_job *prepare_job(struct fdp1_ctx *ctx)
 		return NULL;
 	}
 
-	job->active = dequeue_buffer(ctx);
+	job->active = fdp1_dequeue_field(ctx);
 	if (!job->active) {
 		/* Buffer check should prevent this ever happening */
 		dprintk(fdp1, "No input buffers currently available\n");
@@ -1302,11 +1217,12 @@ static struct fdp1_job *prepare_job(struct fdp1_ctx *ctx)
 	/* Source buffers have been prepared on our buffer_queue
 	 * Prepare our Output buffer
 	 */
-	job->dst.vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-	prepare_buffer(ctx, &job->dst, job->dst.vb, false, true);
+	vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	fbuf = to_fdp1_buffer(vbuf);
+	job->dst = &fbuf->fields[0];
 
 	job->active->vb->sequence = ctx->sequence;
-	job->dst.vb->sequence = ctx->sequence;
+	job->dst->vb->sequence = ctx->sequence;
 	ctx->sequence++;
 
 	if (FDP1_DEINT_MODE_USES_PREV(ctx->deint_mode)) {
@@ -1318,14 +1234,14 @@ static struct fdp1_job *prepare_job(struct fdp1_ctx *ctx)
 
 	if (FDP1_DEINT_MODE_USES_NEXT(ctx->deint_mode)) {
 		/* Must be called after 'active' is dequeued */
-		job->next = peek_queued_buffer(ctx);
+		job->next = fdp1_peek_queued_field(ctx);
 	}
 
 	/* Transfer timestamps and flags from src->dst */
 
-	job->dst.vb->vb2_buf.timestamp = job->active->vb->vb2_buf.timestamp;
+	job->dst->vb->vb2_buf.timestamp = job->active->vb->vb2_buf.timestamp;
 
-	job->dst.vb->flags = job->active->vb->flags &
+	job->dst->vb->flags = job->active->vb->flags &
 				V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 	/* Ideally, the frame-end function will just 'check' to see
@@ -1351,9 +1267,8 @@ static void fdp1_m2m_device_run(void *priv)
 {
 	struct fdp1_ctx *ctx = priv;
 	struct fdp1_dev *fdp1 = ctx->fdp1;
-	struct fdp1_q_data *src_q_data = &ctx->out_q;
 	struct vb2_v4l2_buffer *src_vb;
-	int fields = V4L2_FIELD_HAS_BOTH(src_q_data->format.field) ? 2 : 1;
+	struct fdp1_buffer *buf;
 	unsigned int i;
 
 	dprintk(fdp1, "+\n");
@@ -1362,19 +1277,18 @@ static void fdp1_m2m_device_run(void *priv)
 
 	/* Get our incoming buffer of either one or two fields, or one frame */
 	src_vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	buf = to_fdp1_buffer(src_vb);
 
-	for (i = 0; i < fields; i++) {
-		struct fdp1_buffer *buf = fdp1_buffer_alloc(ctx);
-		bool last_field = (i+1 == fields);
+	for (i = 0; i < buf->num_fields; i++) {
+		struct fdp1_field_buffer *fbuf = &buf->fields[i];
 
-		prepare_buffer(ctx, buf, src_vb, i, last_field);
-		queue_buffer(ctx, buf);
+		fdp1_queue_field(ctx, fbuf);
 		dprintk(fdp1, "Queued Buffer [%d] last_field:%d\n",
-				i, last_field);
+				i, fbuf->last_field);
 	}
 
 	/* Queue as many jobs as our data provides for */
-	while (prepare_job(ctx))
+	while (fdp1_prepare_job(ctx))
 		;
 
 	if (ctx->translen == 0) {
@@ -1412,16 +1326,17 @@ static void device_frame_end(struct fdp1_dev *fdp1,
 	ctx->num_processed++;
 
 	/*
-	 * fdp1_buffer_free will call buf_done only when the last vb2_buffer
+	 * fdp1_field_complete will call buf_done only when the last vb2_buffer
 	 * reference is complete
 	 */
 	if (FDP1_DEINT_MODE_USES_PREV(ctx->deint_mode))
-		fdp1_buffer_free(ctx, job->previous);
+		fdp1_field_complete(ctx, job->previous);
 	else
-		fdp1_buffer_free(ctx, job->active);
+		fdp1_field_complete(ctx, job->active);
 
 	spin_lock_irqsave(&fdp1->irqlock, flags);
-	v4l2_m2m_buf_done(job->dst.vb, state);
+	v4l2_m2m_buf_done(job->dst->vb, state);
+	job->dst = NULL;
 	spin_unlock_irqrestore(&fdp1->irqlock, flags);
 
 	/* Move this job back to the free job list */
@@ -1875,15 +1790,84 @@ static int fdp1_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
+/*
+ * prepare_buffer: Prepare an fdp1_buffer, from a vb2_v4l2_buffer
+ *
+ * This helps us serialise buffers containing two fields into
+ * sequential top and bottom fields.
+ * Destination buffers also go through this function to
+ * set the vb and addrs in the same manner.
+ */
+static void fdp1_buf_prepare_field(struct fdp1_q_data *q_data,
+				   struct vb2_v4l2_buffer *vbuf,
+				   unsigned int field_num)
+{
+	struct fdp1_buffer *buf = to_fdp1_buffer(vbuf);
+	struct fdp1_field_buffer *fbuf = &buf->fields[field_num];
+	unsigned int num_fields;
+	unsigned int i;
+
+	num_fields = V4L2_FIELD_HAS_BOTH(vbuf->field) ? 2 : 1;
+
+	fbuf->vb = vbuf;
+	fbuf->last_field = (field_num + 1) == num_fields;
+
+	for (i = 0; i < vbuf->vb2_buf.num_planes; ++i)
+		fbuf->addrs[i] = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, i);
+
+	switch (vbuf->field) {
+	case V4L2_FIELD_INTERLACED:
+		/*
+		 * Interlaced means bottom-top for 60Hz TV standards (NTSC) and
+		 * top-bottom for 50Hz. As TV standards are not applicable to
+		 * the mem-to-mem API, use the height as a heuristic.
+		 */
+		fbuf->field = (q_data->format.height < 576) == field_num
+			    ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
+		break;
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_SEQ_TB:
+		fbuf->field = field_num ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
+		break;
+	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_SEQ_BT:
+		fbuf->field = field_num ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
+		break;
+	default:
+		fbuf->field = vbuf->field;
+		break;
+	}
+
+	/* Buffer is completed */
+	if (!field_num)
+		return;
+
+	/* Adjust buffer addresses for second field */
+	switch (vbuf->field) {
+	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+		for (i = 0; i < vbuf->vb2_buf.num_planes; i++)
+			fbuf->addrs[i] +=
+				(i == 0 ? q_data->stride_y : q_data->stride_c);
+		break;
+	case V4L2_FIELD_SEQ_TB:
+	case V4L2_FIELD_SEQ_BT:
+		for (i = 0; i < vbuf->vb2_buf.num_planes; i++)
+			fbuf->addrs[i] += q_data->vsize *
+				(i == 0 ? q_data->stride_y : q_data->stride_c);
+		break;
+	}
+}
+
 static int fdp1_buf_prepare(struct vb2_buffer *vb)
 {
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct fdp1_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct fdp1_q_data *q_data;
+	struct fdp1_q_data *q_data = get_q_data(ctx, vb->vb2_queue->type);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct fdp1_buffer *buf = to_fdp1_buffer(vbuf);
 	unsigned int i;
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
-
 	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
 		bool field_valid = true;
 
@@ -1936,6 +1920,10 @@ static int fdp1_buf_prepare(struct vb2_buffer *vb)
 		vb2_set_plane_payload(vb, i, size);
 	}
 
+	buf->num_fields = V4L2_FIELD_HAS_BOTH(vbuf->field) ? 2 : 1;
+	for (i = 0; i < buf->num_fields; ++i)
+		fdp1_buf_prepare_field(q_data, vbuf, i);
+
 	return 0;
 }
 
@@ -2007,13 +1995,13 @@ static void fdp1_stop_streaming(struct vb2_queue *q)
 	/* Empty Output queues */
 	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
 		/* Empty our internal queues */
-		struct fdp1_buffer *b;
+		struct fdp1_field_buffer *fbuf;
 
 		/* Free any queued buffers */
-		b = dequeue_buffer(ctx);
-		while (b != NULL) {
-			fdp1_buffer_free(ctx, b);
-			b = dequeue_buffer(ctx);
+		fbuf = fdp1_dequeue_field(ctx);
+		while (fbuf != NULL) {
+			fdp1_field_complete(ctx, fbuf);
+			fbuf = fdp1_dequeue_field(ctx);
 		}
 
 		/* Free smsk_data */
@@ -2024,7 +2012,7 @@ static void fdp1_stop_streaming(struct vb2_queue *q)
 			ctx->smsk_cpu = NULL;
 		}
 
-		WARN(!list_empty(&ctx->fdp1_buffer_queue),
+		WARN(!list_empty(&ctx->fields_queue),
 				"Buffer queue not empty");
 	} else {
 		/* Empty Capture queues (Jobs) */
@@ -2033,17 +2021,18 @@ static void fdp1_stop_streaming(struct vb2_queue *q)
 		job = get_queued_job(ctx->fdp1);
 		while (job) {
 			if (FDP1_DEINT_MODE_USES_PREV(ctx->deint_mode))
-				fdp1_buffer_free(ctx, job->previous);
+				fdp1_field_complete(ctx, job->previous);
 			else
-				fdp1_buffer_free(ctx, job->active);
+				fdp1_field_complete(ctx, job->active);
 
-			v4l2_m2m_buf_done(job->dst.vb, VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(job->dst->vb, VB2_BUF_STATE_ERROR);
+			job->dst = NULL;
 
 			job = get_queued_job(ctx->fdp1);
 		}
 
 		/* Free any held buffer in the ctx */
-		fdp1_buffer_free(ctx, ctx->previous);
+		fdp1_field_complete(ctx, ctx->previous);
 
 		WARN(!list_empty(&ctx->fdp1->queued_job_list),
 				"Queued Job List not empty");
@@ -2072,7 +2061,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	src_vq->drv_priv = ctx;
-	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->buf_struct_size = sizeof(struct fdp1_buffer);
 	src_vq->ops = &fdp1_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
@@ -2086,7 +2075,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	dst_vq->drv_priv = ctx;
-	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->buf_struct_size = sizeof(struct fdp1_buffer);
 	dst_vq->ops = &fdp1_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
@@ -2105,7 +2094,6 @@ static int fdp1_open(struct file *file)
 	struct v4l2_pix_format_mplane format;
 	struct fdp1_ctx *ctx = NULL;
 	struct v4l2_ctrl *ctrl;
-	unsigned int i;
 	int ret = 0;
 
 	if (mutex_lock_interruptible(&fdp1->dev_mutex))
@@ -2122,12 +2110,7 @@ static int fdp1_open(struct file *file)
 	ctx->fdp1 = fdp1;
 
 	/* Initialise Queues */
-	INIT_LIST_HEAD(&ctx->free_buffers);
-	INIT_LIST_HEAD(&ctx->fdp1_buffer_queue);
-
-	/* Initialise the buffers on the free list */
-	for (i = 0; i < ARRAY_SIZE(ctx->buffers); i++)
-		list_add(&ctx->buffers[i].list, &ctx->free_buffers);
+	INIT_LIST_HEAD(&ctx->fields_queue);
 
 	ctx->translen = 1;
 	ctx->sequence = 0;
-- 
Regards,

Laurent Pinchart

