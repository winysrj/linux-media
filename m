Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59168 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757044AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Antti Palosaari <crope@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Nick Dyer <nick@shmanahar.org>, Shuah Khan <shuah@kernel.org>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH 51/57] [media] v4l2-core: don't break long lines
Date: Fri, 14 Oct 2016 17:20:39 -0300
Message-Id: <504799c0dc3bffcbbc6c646e0ce96b3e55e34724.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c        | 90 ++++++++---------------------
 drivers/media/v4l2-core/videobuf-core.c     |  3 +-
 drivers/media/v4l2-core/videobuf2-core.c    | 21 +++----
 drivers/media/v4l2-core/videobuf2-v4l2.c    |  9 +--
 drivers/media/v4l2-core/videobuf2-vmalloc.c |  3 +-
 5 files changed, 37 insertions(+), 89 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index c52d94c018bb..13b589a8955e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -174,8 +174,7 @@ static void v4l_print_querycap(const void *arg, bool write_only)
 {
 	const struct v4l2_capability *p = arg;
 
-	pr_cont("driver=%.*s, card=%.*s, bus=%.*s, version=0x%08x, "
-		"capabilities=0x%08x, device_caps=0x%08x\n",
+	pr_cont("driver=%.*s, card=%.*s, bus=%.*s, version=0x%08x, capabilities=0x%08x, device_caps=0x%08x\n",
 		(int)sizeof(p->driver), p->driver,
 		(int)sizeof(p->card), p->card,
 		(int)sizeof(p->bus_info), p->bus_info,
@@ -186,8 +185,7 @@ static void v4l_print_enuminput(const void *arg, bool write_only)
 {
 	const struct v4l2_input *p = arg;
 
-	pr_cont("index=%u, name=%.*s, type=%u, audioset=0x%x, tuner=%u, "
-		"std=0x%08Lx, status=0x%x, capabilities=0x%x\n",
+	pr_cont("index=%u, name=%.*s, type=%u, audioset=0x%x, tuner=%u, std=0x%08Lx, status=0x%x, capabilities=0x%x\n",
 		p->index, (int)sizeof(p->name), p->name, p->type, p->audioset,
 		p->tuner, (unsigned long long)p->std, p->status,
 		p->capabilities);
@@ -197,8 +195,7 @@ static void v4l_print_enumoutput(const void *arg, bool write_only)
 {
 	const struct v4l2_output *p = arg;
 
-	pr_cont("index=%u, name=%.*s, type=%u, audioset=0x%x, "
-		"modulator=%u, std=0x%08Lx, capabilities=0x%x\n",
+	pr_cont("index=%u, name=%.*s, type=%u, audioset=0x%x, modulator=%u, std=0x%08Lx, capabilities=0x%x\n",
 		p->index, (int)sizeof(p->name), p->name, p->type, p->audioset,
 		p->modulator, (unsigned long long)p->std, p->capabilities);
 }
@@ -256,11 +253,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		pix = &p->fmt.pix;
-		pr_cont(", width=%u, height=%u, "
-			"pixelformat=%c%c%c%c, field=%s, "
-			"bytesperline=%u, sizeimage=%u, colorspace=%d, "
-			"flags=0x%x, ycbcr_enc=%u, quantization=%u, "
-			"xfer_func=%u\n",
+		pr_cont(", width=%u, height=%u, pixelformat=%c%c%c%c, field=%s, bytesperline=%u, sizeimage=%u, colorspace=%d, flags=0x%x, ycbcr_enc=%u, quantization=%u, xfer_func=%u\n",
 			pix->width, pix->height,
 			(pix->pixelformat & 0xff),
 			(pix->pixelformat >>  8) & 0xff,
@@ -274,10 +267,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		mp = &p->fmt.pix_mp;
-		pr_cont(", width=%u, height=%u, "
-			"format=%c%c%c%c, field=%s, "
-			"colorspace=%d, num_planes=%u, flags=0x%x, "
-			"ycbcr_enc=%u, quantization=%u, xfer_func=%u\n",
+		pr_cont(", width=%u, height=%u, format=%c%c%c%c, field=%s, colorspace=%d, num_planes=%u, flags=0x%x, ycbcr_enc=%u, quantization=%u, xfer_func=%u\n",
 			mp->width, mp->height,
 			(mp->pixelformat & 0xff),
 			(mp->pixelformat >>  8) & 0xff,
@@ -306,8 +296,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
 		vbi = &p->fmt.vbi;
-		pr_cont(", sampling_rate=%u, offset=%u, samples_per_line=%u, "
-			"sample_format=%c%c%c%c, start=%u,%u, count=%u,%u\n",
+		pr_cont(", sampling_rate=%u, offset=%u, samples_per_line=%u, sample_format=%c%c%c%c, start=%u,%u, count=%u,%u\n",
 			vbi->sampling_rate, vbi->offset,
 			vbi->samples_per_line,
 			(vbi->sample_format & 0xff),
@@ -343,9 +332,7 @@ static void v4l_print_framebuffer(const void *arg, bool write_only)
 {
 	const struct v4l2_framebuffer *p = arg;
 
-	pr_cont("capability=0x%x, flags=0x%x, base=0x%p, width=%u, "
-		"height=%u, pixelformat=%c%c%c%c, "
-		"bytesperline=%u, sizeimage=%u, colorspace=%d\n",
+	pr_cont("capability=0x%x, flags=0x%x, base=0x%p, width=%u, height=%u, pixelformat=%c%c%c%c, bytesperline=%u, sizeimage=%u, colorspace=%d\n",
 			p->capability, p->flags, p->base,
 			p->fmt.width, p->fmt.height,
 			(p->fmt.pixelformat & 0xff),
@@ -368,8 +355,7 @@ static void v4l_print_modulator(const void *arg, bool write_only)
 	if (write_only)
 		pr_cont("index=%u, txsubchans=0x%x\n", p->index, p->txsubchans);
 	else
-		pr_cont("index=%u, name=%.*s, capability=0x%x, "
-			"rangelow=%u, rangehigh=%u, txsubchans=0x%x\n",
+		pr_cont("index=%u, name=%.*s, capability=0x%x, rangelow=%u, rangehigh=%u, txsubchans=0x%x\n",
 			p->index, (int)sizeof(p->name), p->name, p->capability,
 			p->rangelow, p->rangehigh, p->txsubchans);
 }
@@ -381,9 +367,7 @@ static void v4l_print_tuner(const void *arg, bool write_only)
 	if (write_only)
 		pr_cont("index=%u, audmode=%u\n", p->index, p->audmode);
 	else
-		pr_cont("index=%u, name=%.*s, type=%u, capability=0x%x, "
-			"rangelow=%u, rangehigh=%u, signal=%u, afc=%d, "
-			"rxsubchans=0x%x, audmode=%u\n",
+		pr_cont("index=%u, name=%.*s, type=%u, capability=0x%x, rangelow=%u, rangehigh=%u, signal=%u, afc=%d, rxsubchans=0x%x, audmode=%u\n",
 			p->index, (int)sizeof(p->name), p->name, p->type,
 			p->capability, p->rangelow,
 			p->rangehigh, p->signal, p->afc,
@@ -402,8 +386,7 @@ static void v4l_print_standard(const void *arg, bool write_only)
 {
 	const struct v4l2_standard *p = arg;
 
-	pr_cont("index=%u, id=0x%Lx, name=%.*s, fps=%u/%u, "
-		"framelines=%u\n", p->index,
+	pr_cont("index=%u, id=0x%Lx, name=%.*s, fps=%u/%u, framelines=%u\n", p->index,
 		(unsigned long long)p->id, (int)sizeof(p->name), p->name,
 		p->frameperiod.numerator,
 		p->frameperiod.denominator,
@@ -419,8 +402,7 @@ static void v4l_print_hw_freq_seek(const void *arg, bool write_only)
 {
 	const struct v4l2_hw_freq_seek *p = arg;
 
-	pr_cont("tuner=%u, type=%u, seek_upward=%u, wrap_around=%u, spacing=%u, "
-		"rangelow=%u, rangehigh=%u\n",
+	pr_cont("tuner=%u, type=%u, seek_upward=%u, wrap_around=%u, spacing=%u, rangelow=%u, rangehigh=%u\n",
 		p->tuner, p->type, p->seek_upward, p->wrap_around, p->spacing,
 		p->rangelow, p->rangehigh);
 }
@@ -442,8 +424,7 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 	const struct v4l2_plane *plane;
 	int i;
 
-	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, "
-		"flags=0x%08x, field=%s, sequence=%d, memory=%s",
+	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, flags=0x%08x, field=%s, sequence=%d, memory=%s",
 			p->timestamp.tv_sec / 3600,
 			(int)(p->timestamp.tv_sec / 60) % 60,
 			(int)(p->timestamp.tv_sec % 60),
@@ -458,8 +439,7 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 		for (i = 0; i < p->length; ++i) {
 			plane = &p->m.planes[i];
 			printk(KERN_DEBUG
-				"plane %d: bytesused=%d, data_offset=0x%08x, "
-				"offset/userptr=0x%lx, length=%d\n",
+				"plane %d: bytesused=%d, data_offset=0x%08x, offset/userptr=0x%lx, length=%d\n",
 				i, plane->bytesused, plane->data_offset,
 				plane->m.userptr, plane->length);
 		}
@@ -468,8 +448,7 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 			p->bytesused, p->m.userptr, p->length);
 	}
 
-	printk(KERN_DEBUG "timecode=%02d:%02d:%02d type=%d, "
-		"flags=0x%08x, frames=%d, userbits=0x%08x\n",
+	printk(KERN_DEBUG "timecode=%02d:%02d:%02d type=%d, flags=0x%08x, frames=%d, userbits=0x%08x\n",
 			tc->hours, tc->minutes, tc->seconds,
 			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
 }
@@ -503,8 +482,7 @@ static void v4l_print_streamparm(const void *arg, bool write_only)
 	    p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		const struct v4l2_captureparm *c = &p->parm.capture;
 
-		pr_cont(", capability=0x%x, capturemode=0x%x, timeperframe=%d/%d, "
-			"extendedmode=%d, readbuffers=%d\n",
+		pr_cont(", capability=0x%x, capturemode=0x%x, timeperframe=%d/%d, extendedmode=%d, readbuffers=%d\n",
 			c->capability, c->capturemode,
 			c->timeperframe.numerator, c->timeperframe.denominator,
 			c->extendedmode, c->readbuffers);
@@ -512,8 +490,7 @@ static void v4l_print_streamparm(const void *arg, bool write_only)
 		   p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		const struct v4l2_outputparm *c = &p->parm.output;
 
-		pr_cont(", capability=0x%x, outputmode=0x%x, timeperframe=%d/%d, "
-			"extendedmode=%d, writebuffers=%d\n",
+		pr_cont(", capability=0x%x, outputmode=0x%x, timeperframe=%d/%d, extendedmode=%d, writebuffers=%d\n",
 			c->capability, c->outputmode,
 			c->timeperframe.numerator, c->timeperframe.denominator,
 			c->extendedmode, c->writebuffers);
@@ -526,8 +503,7 @@ static void v4l_print_queryctrl(const void *arg, bool write_only)
 {
 	const struct v4l2_queryctrl *p = arg;
 
-	pr_cont("id=0x%x, type=%d, name=%.*s, min/max=%d/%d, "
-		"step=%d, default=%d, flags=0x%08x\n",
+	pr_cont("id=0x%x, type=%d, name=%.*s, min/max=%d/%d, step=%d, default=%d, flags=0x%08x\n",
 			p->id, p->type, (int)sizeof(p->name), p->name,
 			p->minimum, p->maximum,
 			p->step, p->default_value, p->flags);
@@ -537,9 +513,7 @@ static void v4l_print_query_ext_ctrl(const void *arg, bool write_only)
 {
 	const struct v4l2_query_ext_ctrl *p = arg;
 
-	pr_cont("id=0x%x, type=%d, name=%.*s, min/max=%lld/%lld, "
-		"step=%lld, default=%lld, flags=0x%08x, elem_size=%u, elems=%u, "
-		"nr_of_dims=%u, dims=%u,%u,%u,%u\n",
+	pr_cont("id=0x%x, type=%d, name=%.*s, min/max=%lld/%lld, step=%lld, default=%lld, flags=0x%08x, elem_size=%u, elems=%u, nr_of_dims=%u, dims=%u,%u,%u,%u\n",
 			p->id, p->type, (int)sizeof(p->name), p->name,
 			p->minimum, p->maximum,
 			p->step, p->default_value, p->flags,
@@ -583,9 +557,7 @@ static void v4l_print_cropcap(const void *arg, bool write_only)
 {
 	const struct v4l2_cropcap *p = arg;
 
-	pr_cont("type=%s, bounds wxh=%dx%d, x,y=%d,%d, "
-		"defrect wxh=%dx%d, x,y=%d,%d, "
-		"pixelaspect %d/%d\n",
+	pr_cont("type=%s, bounds wxh=%dx%d, x,y=%d,%d, defrect wxh=%dx%d, x,y=%d,%d, pixelaspect %d/%d\n",
 		prt_names(p->type, v4l2_type_names),
 		p->bounds.width, p->bounds.height,
 		p->bounds.left, p->bounds.top,
@@ -618,8 +590,7 @@ static void v4l_print_jpegcompression(const void *arg, bool write_only)
 {
 	const struct v4l2_jpegcompression *p = arg;
 
-	pr_cont("quality=%d, APPn=%d, APP_len=%d, "
-		"COM_len=%d, jpeg_markers=0x%x\n",
+	pr_cont("quality=%d, APPn=%d, APP_len=%d, COM_len=%d, jpeg_markers=0x%x\n",
 		p->quality, p->APPn, p->APP_len,
 		p->COM_len, p->jpeg_markers);
 }
@@ -686,14 +657,7 @@ static void v4l_print_dv_timings(const void *arg, bool write_only)
 
 	switch (p->type) {
 	case V4L2_DV_BT_656_1120:
-		pr_cont("type=bt-656/1120, interlaced=%u, "
-			"pixelclock=%llu, "
-			"width=%u, height=%u, polarities=0x%x, "
-			"hfrontporch=%u, hsync=%u, "
-			"hbackporch=%u, vfrontporch=%u, "
-			"vsync=%u, vbackporch=%u, "
-			"il_vfrontporch=%u, il_vsync=%u, "
-			"il_vbackporch=%u, standards=0x%x, flags=0x%x\n",
+		pr_cont("type=bt-656/1120, interlaced=%u, pixelclock=%llu, width=%u, height=%u, polarities=0x%x, hfrontporch=%u, hsync=%u, hbackporch=%u, vfrontporch=%u, vsync=%u, vbackporch=%u, il_vfrontporch=%u, il_vsync=%u, il_vbackporch=%u, standards=0x%x, flags=0x%x\n",
 				p->bt.interlaced, p->bt.pixelclock,
 				p->bt.width, p->bt.height,
 				p->bt.polarities, p->bt.hfrontporch,
@@ -723,8 +687,7 @@ static void v4l_print_dv_timings_cap(const void *arg, bool write_only)
 
 	switch (p->type) {
 	case V4L2_DV_BT_656_1120:
-		pr_cont("type=bt-656/1120, width=%u-%u, height=%u-%u, "
-			"pixelclock=%llu-%llu, standards=0x%x, capabilities=0x%x\n",
+		pr_cont("type=bt-656/1120, width=%u-%u, height=%u-%u, pixelclock=%llu-%llu, standards=0x%x, capabilities=0x%x\n",
 			p->bt.min_width, p->bt.max_width,
 			p->bt.min_height, p->bt.max_height,
 			p->bt.min_pixelclock, p->bt.max_pixelclock,
@@ -805,8 +768,7 @@ static void v4l_print_event(const void *arg, bool write_only)
 	const struct v4l2_event *p = arg;
 	const struct v4l2_event_ctrl *c;
 
-	pr_cont("type=0x%x, pending=%u, sequence=%u, id=%u, "
-		"timestamp=%lu.%9.9lu\n",
+	pr_cont("type=0x%x, pending=%u, sequence=%u, id=%u, timestamp=%lu.%9.9lu\n",
 			p->type, p->pending, p->sequence, p->id,
 			p->timestamp.tv_sec, p->timestamp.tv_nsec);
 	switch (p->type) {
@@ -822,8 +784,7 @@ static void v4l_print_event(const void *arg, bool write_only)
 			pr_cont("value64=%lld, ", c->value64);
 		else
 			pr_cont("value=%d, ", c->value);
-		pr_cont("flags=0x%x, minimum=%d, maximum=%d, step=%d, "
-			"default_value=%d\n",
+		pr_cont("flags=0x%x, minimum=%d, maximum=%d, step=%d, default_value=%d\n",
 			c->flags, c->minimum, c->maximum,
 			c->step, c->default_value);
 		break;
@@ -859,8 +820,7 @@ static void v4l_print_freq_band(const void *arg, bool write_only)
 {
 	const struct v4l2_frequency_band *p = arg;
 
-	pr_cont("tuner=%u, type=%u, index=%u, capability=0x%x, "
-		"rangelow=%u, rangehigh=%u, modulation=0x%x\n",
+	pr_cont("tuner=%u, type=%u, index=%u, capability=0x%x, rangelow=%u, rangehigh=%u, modulation=0x%x\n",
 			p->tuner, p->type, p->index,
 			p->capability, p->rangelow,
 			p->rangehigh, p->modulation);
diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index def84753c4c3..1dbf6f7785bb 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -572,8 +572,7 @@ int videobuf_qbuf(struct videobuf_queue *q, struct v4l2_buffer *b)
 	switch (b->memory) {
 	case V4L2_MEMORY_MMAP:
 		if (0 == buf->baddr) {
-			dprintk(1, "qbuf: mmap requested "
-				   "but buffer addr is zero!\n");
+			dprintk(1, "qbuf: mmap requested but buffer addr is zero!\n");
 			goto done;
 		}
 		if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 21900202ff83..52d8b5388f56 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -358,8 +358,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		if (memory == VB2_MEMORY_MMAP) {
 			ret = __vb2_buf_mem_alloc(vb);
 			if (ret) {
-				dprintk(1, "failed allocating memory for "
-						"buffer %d\n", buffer);
+				dprintk(1, "failed allocating memory for buffer %d\n", buffer);
 				q->bufs[vb->index] = NULL;
 				kfree(vb);
 				break;
@@ -372,8 +371,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			 */
 			ret = call_vb_qop(vb, buf_init, vb);
 			if (ret) {
-				dprintk(1, "buffer %d %p initialization"
-					" failed\n", buffer, vb);
+				dprintk(1, "buffer %d %p initialization failed\n", buffer, vb);
 				__vb2_buf_mem_free(vb);
 				q->bufs[vb->index] = NULL;
 				kfree(vb);
@@ -997,13 +995,11 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 			&& vb->planes[plane].length == planes[plane].length)
 			continue;
 
-		dprintk(3, "userspace address for plane %d changed, "
-				"reacquiring memory\n", plane);
+		dprintk(3, "userspace address for plane %d changed, reacquiring memory\n", plane);
 
 		/* Check if the provided plane buffer is large enough */
 		if (planes[plane].length < vb->planes[plane].min_length) {
-			dprintk(1, "provided buffer size %u is less than "
-						"setup size %u for plane %d\n",
+			dprintk(1, "provided buffer size %u is less than setup size %u for plane %d\n",
 						planes[plane].length,
 						vb->planes[plane].min_length,
 						plane);
@@ -1032,8 +1028,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 				planes[plane].m.userptr,
 				planes[plane].length, dma_dir);
 		if (IS_ERR(mem_priv)) {
-			dprintk(1, "failed acquiring userspace "
-						"memory for plane %d\n", plane);
+			dprintk(1, "failed acquiring userspace memory for plane %d\n", plane);
 			ret = PTR_ERR(mem_priv);
 			goto err;
 		}
@@ -1123,8 +1118,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 			planes[plane].length = dbuf->size;
 
 		if (planes[plane].length < vb->planes[plane].min_length) {
-			dprintk(1, "invalid dmabuf length %u for plane %d, "
-				"minimum length %u\n",
+			dprintk(1, "invalid dmabuf length %u for plane %d, minimum length %u\n",
 				planes[plane].length, plane,
 				vb->planes[plane].min_length);
 			dma_buf_put(dbuf);
@@ -1472,8 +1466,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		}
 
 		if (nonblocking) {
-			dprintk(1, "nonblocking and no buffers to dequeue, "
-								"will not wait\n");
+			dprintk(1, "nonblocking and no buffers to dequeue, will not wait\n");
 			return -EAGAIN;
 		}
 
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 52ef8833f6b6..2586e40f5e60 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -60,14 +60,12 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 
 	/* Is memory for copying plane information present? */
 	if (b->m.planes == NULL) {
-		dprintk(1, "multi-planar buffer passed but "
-			   "planes array not provided\n");
+		dprintk(1, "multi-planar buffer passed but planes array not provided\n");
 		return -EINVAL;
 	}
 
 	if (b->length < vb->num_planes || b->length > VB2_MAX_PLANES) {
-		dprintk(1, "incorrect planes array length, "
-			   "expected %d, got %d\n", vb->num_planes, b->length);
+		dprintk(1, "incorrect planes array length, expected %d, got %d\n", vb->num_planes, b->length);
 		return -EINVAL;
 	}
 
@@ -316,8 +314,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 		 * that just says that it is either a top or a bottom field,
 		 * but not which of the two it is.
 		 */
-		dprintk(1, "the field is incorrectly set to ALTERNATE "
-					"for an output buffer\n");
+		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
 		return -EINVAL;
 	}
 	vb->timestamp = 0;
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index ab3227b75c84..3f778147cdef 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -151,8 +151,7 @@ static void *vb2_vmalloc_vaddr(void *buf_priv)
 	struct vb2_vmalloc_buf *buf = buf_priv;
 
 	if (!buf->vaddr) {
-		pr_err("Address of an unallocated plane requested "
-		       "or cannot map user pointer\n");
+		pr_err("Address of an unallocated plane requested or cannot map user pointer\n");
 		return NULL;
 	}
 
-- 
2.7.4


