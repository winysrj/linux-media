Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52914 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752281AbeBIS6N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 13:58:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] media: dvb: add continuity error indicators for memory mapped buffers
Date: Fri,  9 Feb 2018 16:58:03 -0200
Message-Id: <fc8eaff29d67ff9aa9488942caa92448eb6cfb8a.1518202672.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While userspace can detect discontinuity errors, it is useful to
also let Kernelspace reporting discontinuity, as it can help to
identify if the data loss happened either at Kernel or userspace side.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/uapi/linux/dvb/dmx.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index 5f3c5a918f00..471c4afe738c 100644
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
+	DMX_BUFFER_FLAG_HAD_CRC32_DISCARD,
+	DMX_BUFFER_FLAG_TEI,
+	DMX_BUFFER_PKT_COUNTER_MISMATCH,
+	DMX_BUFFER_FLAG_DISCONTINUITY_DETECTED,
+	DMX_BUFFER_FLAG_DISCONTINUITY_INDICATOR,
+};
+
 /**
  * struct dmx_buffer - dmx buffer info
  *
@@ -220,6 +246,11 @@ struct dmx_stc {
  *		offset from the start of the device memory for this plane,
  *		(or a "cookie" that should be passed to mmap() as offset)
  * @length:	size in bytes of the buffer
+ * @flags:	buffer flags as defined by &enum dmx_buffer_flags.
+ *		Filled only at &DMX_DQBUF. &DMX_QBUF should zero this field.
+ * @count:	monotonic counter for filled buffers. Helps to identify
+ *		data stream loses. Filled only at &DMX_DQBUF. &DMX_QBUF should
+ *		zero this field.
  *
  * Contains data exchanged by application and driver using one of the streaming
  * I/O methods.
@@ -229,6 +260,8 @@ struct dmx_buffer {
 	__u32			bytesused;
 	__u32			offset;
 	__u32			length;
+	__u32			flags;
+	__u32			count;
 };
 
 /**
-- 
2.14.3
