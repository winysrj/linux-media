Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40083 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbdL2NiB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 08:38:01 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/4] media: dvb kAPI docs: document dvb_vb2.h
Date: Fri, 29 Dec 2017 08:37:55 -0500
Message-Id: <9f577d6db5bf7d76fb9e26894a92fcb4ecb4c832.1514554610.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514554610.git.mchehab@s-opensource.com>
References: <cover.1514554610.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514554610.git.mchehab@s-opensource.com>
References: <cover.1514554610.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the data structures and functions inside this kAPI header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-common.rst |   5 +
 include/media/dmxdev.h                  |   2 +
 include/media/dvb_vb2.h                 | 183 ++++++++++++++++++++++++++++++--
 3 files changed, 184 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/kapi/dtv-common.rst b/Documentation/media/kapi/dtv-common.rst
index c47843b6c81d..7a9574f03190 100644
--- a/Documentation/media/kapi/dtv-common.rst
+++ b/Documentation/media/kapi/dtv-common.rst
@@ -53,3 +53,8 @@ copy it from/to userspace.
      Two or more writers must be locked against each other.
 
 .. kernel-doc:: include/media/dvb_ringbuffer.h
+
+Digital TV VB2 handler
+~~~~~~~~~~~~~~~~~~~~~~
+
+.. kernel-doc:: include/media/dvb_vb2.h
diff --git a/include/media/dmxdev.h b/include/media/dmxdev.h
index d5bef0da2e6e..2f5cb2c7b6a7 100644
--- a/include/media/dmxdev.h
+++ b/include/media/dmxdev.h
@@ -112,6 +112,7 @@ struct dmxdev_feed {
  * @state:	state of the dmxdev filter, as defined by &enum dmxdev_state.
  * @dev:	pointer to &struct dmxdev.
  * @buffer:	an embedded &struct dvb_ringbuffer buffer.
+ * @vb2_ctx:	control struct for VB2 handler
  * @mutex:	protects the access to &struct dmxdev_filter.
  * @timer:	&struct timer_list embedded timer, used to check for
  *		feed timeouts.
@@ -165,6 +166,7 @@ struct dmxdev_filter {
  * @exit:		flag to indicate that the demux is being released.
  * @dvr_orig_fe:	pointer to &struct dmx_frontend.
  * @dvr_buffer:		embedded &struct dvb_ringbuffer for DVB output.
+ * @dvr_vb2_ctx:	control struct for VB2 handler
  * @mutex:		protects the usage of this structure.
  * @lock:		protects access to &dmxdev->filter->data.
  */
diff --git a/include/media/dvb_vb2.h b/include/media/dvb_vb2.h
index ef4a802f7435..5431e5a7e140 100644
--- a/include/media/dvb_vb2.h
+++ b/include/media/dvb_vb2.h
@@ -22,22 +22,72 @@
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-vmalloc.h>
 
+/**
+ * enum dvb_buf_type - types of Digital TV memory-mapped buffers
+ *
+ * @DVB_BUF_TYPE_CAPTURE: buffer is filled by the Kernel,
+ *			  with a received Digital TV stream
+ */
 enum dvb_buf_type {
 	DVB_BUF_TYPE_CAPTURE        = 1,
 };
 
-#define DVB_VB2_STATE_NONE (0x0)
-#define DVB_VB2_STATE_INIT (0x1)
-#define DVB_VB2_STATE_REQBUFS (0x2)
-#define DVB_VB2_STATE_STREAMON (0x4)
+/**
+ * enum dvb_vb2_states - states to control VB2 state machine
+ * @DVB_VB2_STATE_NONE:
+ *	VB2 engine not initialized yet, init failed or VB2 was released.
+ * @DVB_VB2_STATE_INIT:
+ *	VB2 engine initialized.
+ * @DVB_VB2_STATE_REQBUFS:
+ *	Buffers were requested
+ * @DVB_VB2_STATE_STREAMON:
+ *	VB2 is streaming. Callers should not check it directly. Instead,
+ *	they should use dvb_vb2_is_streaming().
+ *
+ * Note:
+ *
+ * Callers should not touch at the state machine directly. This
+ * is handled inside dvb_vb2.c.
+ */
+enum dvb_vb2_states {
+	DVB_VB2_STATE_NONE	= 0x0,
+	DVB_VB2_STATE_INIT	= 0x1,
+	DVB_VB2_STATE_REQBUFS	= 0x2,
+	DVB_VB2_STATE_STREAMON	= 0x4,
+};
 
 #define DVB_VB2_NAME_MAX (20)
 
+/**
+ * struct dvb_buffer - video buffer information for v4l2.
+ *
+ * @vb:		embedded struct &vb2_buffer.
+ * @list:	list of &struct dvb_buffer.
+ */
 struct dvb_buffer {
 	struct vb2_buffer	vb;
 	struct list_head	list;
 };
 
+/**
+ * struct dvb_vb2_ctx - control struct for VB2 handler
+ * @vb_q:	pointer to &struct vb2_queue with videobuf2 queue.
+ * @mutex:	mutex to serialize vb2 operations. Used by
+ *		vb2 core %wait_prepare and %wait_finish operations.
+ * @slock:	spin lock used to protect buffer filling at dvb_vb2.c.
+ * @dvb_q:	List of buffers that are not filled yet.
+ * @buf:	Pointer to the buffer that are currently being filled.
+ * @offset:	index to the next position at the @buf to be filled.
+ * @remain:	How many bytes are left to be filled at @buf.
+ * @state:	bitmask of buffer states as defined by &enum dvb_vb2_states.
+ * @buf_siz:	size of each VB2 buffer.
+ * @buf_cnt:	number of VB2 buffers.
+ * @nonblocking:
+ *		If different than zero, device is operating on non-blocking
+ *		mode.
+ * @name:	name of the device type. Currently, it can either be
+ *		"dvr" or "demux_filter".
+ */
 struct dvb_vb2_ctx {
 	struct vb2_queue	vb_q;
 	struct mutex		mutex;
@@ -53,8 +103,6 @@ struct dvb_vb2_ctx {
 	char	name[DVB_VB2_NAME_MAX + 1];
 };
 
-int dvb_vb2_stream_on(struct dvb_vb2_ctx *ctx);
-int dvb_vb2_stream_off(struct dvb_vb2_ctx *ctx);
 #ifndef DVB_MMAP
 static inline int dvb_vb2_init(struct dvb_vb2_ctx *ctx,
 			       const char *name, int non_blocking)
@@ -75,21 +123,144 @@ static inline unsigned int dvb_vb2_poll(struct dvb_vb2_ctx *ctx,
 	return 0;
 }
 #else
+/**
+ * dvb_vb2_init - initializes VB2 handler
+ *
+ * @ctx:	control struct for VB2 handler
+ * @name:	name for the VB2 handler
+ * @non_blocking:
+ *		if not zero, it means that the device is at non-blocking mode
+ */
 int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int non_blocking);
+
+/**
+ * dvb_vb2_release - Releases the VB2 handler allocated resources and
+ *	put @ctx at DVB_VB2_STATE_NONE state.
+ * @ctx:	control struct for VB2 handler
+ */
 int dvb_vb2_release(struct dvb_vb2_ctx *ctx);
+
+/**
+ * dvb_vb2_is_streaming - checks if the VB2 handler is streaming
+ * @ctx:	control struct for VB2 handler
+ *
+ * Return: 0 if not streaming, 1 otherwise.
+ */
 int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx);
+
+/**
+ * dvb_vb2_fill_buffer - fills a VB2 buffer
+ * @ctx:	control struct for VB2 handler
+ * @src:	place where the data is stored
+ * @len:	number of bytes to be copied from @src
+ */
 int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
 			const unsigned char *src, int len);
+
+/**
+ * dvb_vb2_poll - Wrapper to vb2_core_streamon() for Digital TV
+ *      buffer handling.
+ *
+ * @ctx:	control struct for VB2 handler
+ * @file:	&struct file argument passed to the poll
+ *		file operation handler.
+ * @wait:	&poll_table wait argument passed to the poll
+ *		file operation handler.
+ *
+ * Implements poll syscall() logic.
+ */
 unsigned int dvb_vb2_poll(struct dvb_vb2_ctx *ctx, struct file *file,
 			  poll_table *wait);
 #endif
 
+/**
+ * dvb_vb2_stream_on() - Wrapper to vb2_core_streamon() for Digital TV
+ *	buffer handling.
+ *
+ * @ctx:	control struct for VB2 handler
+ *
+ * Starts dvb streaming
+ */
+int dvb_vb2_stream_on(struct dvb_vb2_ctx *ctx);
+/**
+ * dvb_vb2_stream_off() - Wrapper to vb2_core_streamoff() for Digital TV
+ *	buffer handling.
+ *
+ * @ctx:	control struct for VB2 handler
+ *
+ * Stops dvb streaming
+ */
+int dvb_vb2_stream_off(struct dvb_vb2_ctx *ctx);
 
+/**
+ * dvb_vb2_reqbufs() - Wrapper to vb2_core_reqbufs() for Digital TV
+ *	buffer handling.
+ *
+ * @ctx:	control struct for VB2 handler
+ * @req:	&struct dmx_requestbuffers passed from userspace in
+ *		order to handle &DMX_REQBUFS.
+ *
+ * Initiate streaming by requesting a number of buffers. Also used to
+ * free previously requested buffers, is ``req->count`` is zero.
+ */
 int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req);
+
+/**
+ * dvb_vb2_querybuf() - Wrapper to vb2_core_querybuf() for Digital TV
+ *	buffer handling.
+ *
+ * @ctx:	control struct for VB2 handler
+ * @b:		&struct dmx_buffer passed from userspace in
+ *		order to handle &DMX_QUERYBUF.
+ *
+ * 
+ */
 int dvb_vb2_querybuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
+
+/**
+ * dvb_vb2_expbuf() - Wrapper to vb2_core_expbuf() for Digital TV
+ *	buffer handling.
+ *
+ * @ctx:	control struct for VB2 handler
+ * @exp:	&struct dmx_exportbuffer passed from userspace in
+ *		order to handle &DMX_EXPBUF.
+ *
+ * Export a buffer as a file descriptor.
+ */
 int dvb_vb2_expbuf(struct dvb_vb2_ctx *ctx, struct dmx_exportbuffer *exp);
+
+/**
+ * dvb_vb2_qbuf() - Wrapper to vb2_core_qbuf() for Digital TV buffer handling.
+ *
+ * @ctx:	control struct for VB2 handler
+ * @b:		&struct dmx_buffer passed from userspace in
+ *		order to handle &DMX_QBUF.
+ *
+ * Queue a Digital TV buffer as requested by userspace
+ */
 int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
+
+/**
+ * dvb_vb2_dqbuf() - Wrapper to vb2_core_dqbuf() for Digital TV
+ *	buffer handling.
+ *
+ * @ctx:	control struct for VB2 handler
+ * @b:		&struct dmx_buffer passed from userspace in
+ *		order to handle &DMX_DQBUF.
+ *
+ * Dequeue a Digital TV buffer to the userspace
+ */
 int dvb_vb2_dqbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
+
+/**
+ * dvb_vb2_mmap() - Wrapper to vb2_mmap() for Digital TV buffer handling.
+ *
+ * @ctx:	control struct for VB2 handler
+ * @vma:        pointer to &struct vm_area_struct with the vma passed
+ *              to the mmap file operation handler in the driver.
+ *
+ * map Digital TV video buffers into application address space.
+ */
 int dvb_vb2_mmap(struct dvb_vb2_ctx *ctx, struct vm_area_struct *vma);
 
 #endif /* _DVB_VB2_H */
-- 
2.14.3
