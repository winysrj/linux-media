Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 25/39] [media] videobuf2-core: Add it to device-drivers DocBook
Date: Sat, 22 Aug 2015 14:28:10 -0300
Message-Id: <92f8477bd1a069e552698b08d23a0639ef42b696.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the stuff at videobuf2-core are ok for adding it to
DocBook.

Two notes here:
1) As videobuf2-core will be soon be changed, better to
   not spend too much efforts right now, as things will
   change soon;

2) struct vb2_queue has a number of private elements that are
   documented. As Kernel nano documentation format handles
   "private:" arguments, we need to put them on a separate
   comment block or to remove. Keeping the comments is
   obviously better ;)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 30ba2cf2735a..e636bbd41933 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -234,10 +234,10 @@ X!Isound/sound_firmware.c
 !Iinclude/media/v4l2-ctrls.h
 !Iinclude/media/v4l2-event.h
 !Iinclude/media/v4l2-dv-timings.h
+!Iinclude/media/videobuf2-core.h
 <!-- FIXME: Removed for now due to document generation inconsistency
 X!Iinclude/media/v4l2-mediabus.h
 X!Iinclude/media/videobuf2-memops.h
-X!Iinclude/media/videobuf2-core.h
 -->
 
   </chapter>
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 22a44c2f5963..4f7f7aed9157 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -362,7 +362,9 @@ struct v4l2_fh;
  *		start_streaming() can be called. Used when a DMA engine
  *		cannot be started unless at least this number of buffers
  *		have been queued into the driver.
- *
+ */
+/*
+ * Private elements (won't appear at the DocBook):
  * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
  * @memory:	current memory type used
  * @bufs:	videobuf buffer structures
@@ -405,7 +407,7 @@ struct vb2_queue {
 	gfp_t				gfp_flags;
 	u32				min_buffers_needed;
 
-/* private: internal use only */
+	/* private: internal use only */
 	struct mutex			mmap_lock;
 	enum v4l2_memory		memory;
 	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
@@ -482,7 +484,8 @@ size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
 size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
-/**
+
+/*
  * vb2_thread_fnc - callback function for use with vb2_thread
  *
  * This is called whenever a buffer is dequeued in the thread.
@@ -575,7 +578,6 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
  * vb2_get_plane_payload() - get bytesused for the plane plane_no
  * @vb:		buffer for which plane payload should be set
  * @plane_no:	plane number for which payload should be set
- * @size:	payload in bytes
  */
 static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
 				 unsigned int plane_no)
-- 
2.4.3

