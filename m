Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61927 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753024AbeBKL04 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Feb 2018 06:26:56 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 3/4] media: dvb: add continuity error indicators for memory mapped buffers
Date: Sun, 11 Feb 2018 09:26:49 -0200
Message-Id: <4c779d0260f0d941d13884351588489110bf1b4a.1518347588.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1518347588.git.mchehab@s-opensource.com>
References: <cover.1518347588.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1518347588.git.mchehab@s-opensource.com>
References: <cover.1518347588.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While userspace can detect discontinuity errors, it is useful to
also let Kernelspace reporting discontinuity, as it can help to
identify if the data loss happened either at Kernel or userspace side.

Update documentation accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dmx.h.rst.exceptions  | 14 +++++++++----
 Documentation/media/uapi/dvb/dmx-qbuf.rst |  7 ++++---
 include/uapi/linux/dvb/dmx.h              | 35 +++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
index 63f55a9ae2b1..a8c4239ed95b 100644
--- a/Documentation/media/dmx.h.rst.exceptions
+++ b/Documentation/media/dmx.h.rst.exceptions
@@ -50,9 +50,15 @@ replace typedef dmx_filter_t :c:type:`dmx_filter`
 replace typedef dmx_pes_type_t :c:type:`dmx_pes_type`
 replace typedef dmx_input_t :c:type:`dmx_input`
 
-ignore symbol DMX_OUT_DECODER
-ignore symbol DMX_OUT_TAP
-ignore symbol DMX_OUT_TS_TAP
-ignore symbol DMX_OUT_TSDEMUX_TAP
+replace symbol DMX_BUFFER_FLAG_HAD_CRC32_DISCARD :c:type:`dmx_buffer_flags`
+replace	symbol DMX_BUFFER_FLAG_TEI :c:type:`dmx_buffer_flags`
+replace	symbol DMX_BUFFER_PKT_COUNTER_MISMATCH :c:type:`dmx_buffer_flags`
+replace	symbol DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED :c:type:`dmx_buffer_flags`
+replace	symbol DMX_BUFFER_FLAG_DISCONTINUITY_INDICATOR :c:type:`dmx_buffer_flags`
+
+replace symbol DMX_OUT_DECODER :c:type:`dmx_output`
+replace symbol DMX_OUT_TAP :c:type:`dmx_output`
+replace symbol DMX_OUT_TS_TAP :c:type:`dmx_output`
+replace symbol DMX_OUT_TSDEMUX_TAP :c:type:`dmx_output`
 
 replace ioctl DMX_DQBUF dmx_qbuf
diff --git a/Documentation/media/uapi/dvb/dmx-qbuf.rst b/Documentation/media/uapi/dvb/dmx-qbuf.rst
index b48c4931658e..be5a4c6f1904 100644
--- a/Documentation/media/uapi/dvb/dmx-qbuf.rst
+++ b/Documentation/media/uapi/dvb/dmx-qbuf.rst
@@ -51,9 +51,10 @@ out to disk. Buffers remain locked until dequeued, until the
 the device is closed.
 
 Applications call the ``DMX_DQBUF`` ioctl to dequeue a filled
-(capturing) buffer from the driver's outgoing queue. They just set the ``reserved`` field array to zero. When ``DMX_DQBUF`` is called with a
-pointer to this structure, the driver fills the remaining fields or
-returns an error code.
+(capturing) buffer from the driver's outgoing queue.
+They just set the ``index`` field withe the buffer ID to be queued.
+When ``DMX_DQBUF`` is called with a pointer to struct :c:type:`dmx_buffer`,
+the driver fills the remaining fields or returns an error code.
 
 By default ``DMX_DQBUF`` blocks when no buffer is in the outgoing
 queue. When the ``O_NONBLOCK`` flag was given to the
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index 5f3c5a918f00..a656b7a66f6e 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -211,6 +211,32 @@ struct dmx_stc {
 	__u64 stc;
 };
 
+/**
+ * enum dmx_buffer_flags - DMX memory-mapped buffer flags
+ *
+ * @DMX_BUFFER_FLAG_HAD_CRC32_DISCARD:
+ *	Indicates that the Kernel discarded one or more frames due to wrong
+ *	CRC32 checksum.
+ * @DMX_BUFFER_FLAG_TEI:
+ * 	Indicates that the Kernel has detected a Transport Error indicator
+ *	(TEI) on a filtered pid.
+ * @DMX_BUFFER_PKT_COUNTER_MISMATCH:
+ * 	Indicates that the Kernel has detected a packet counter mismatch
+ *	on a filtered pid.
+ * @DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED:
+ * 	Indicates that the Kernel has detected one or more frame discontinuity.
+ * @DMX_BUFFER_FLAG_DISCONTINUITY_INDICATOR:
+ * 	Received at least one packet with a frame discontinuity indicator.
+ */
+
+enum dmx_buffer_flags {
+	DMX_BUFFER_FLAG_HAD_CRC32_DISCARD		= 1 << 0,
+	DMX_BUFFER_FLAG_TEI				= 1 << 1,
+	DMX_BUFFER_PKT_COUNTER_MISMATCH			= 1 << 2,
+	DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED		= 1 << 3,
+	DMX_BUFFER_FLAG_DISCONTINUITY_INDICATOR		= 1 << 4,
+};
+
 /**
  * struct dmx_buffer - dmx buffer info
  *
@@ -220,15 +246,24 @@ struct dmx_stc {
  *		offset from the start of the device memory for this plane,
  *		(or a "cookie" that should be passed to mmap() as offset)
  * @length:	size in bytes of the buffer
+ * @flags:	bit array of buffer flags as defined by &enum dmx_buffer_flags.
+ *		Filled only at &DMX_DQBUF.
+ * @count:	monotonic counter for filled buffers. Helps to identify
+ *		data stream loses. Filled only at &DMX_DQBUF.
  *
  * Contains data exchanged by application and driver using one of the streaming
  * I/O methods.
+ *
+ * Please notice that, for &DMX_QBUF, only @index should be filled.
+ * On &DMX_DQBUF calls, all fields will be filled by the Kernel.
  */
 struct dmx_buffer {
 	__u32			index;
 	__u32			bytesused;
 	__u32			offset;
 	__u32			length;
+	__u32			flags;
+	__u32			count;
 };
 
 /**
-- 
2.14.3
