Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56862 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937116AbcIHVhs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 08/15] [media] videobuf2-core.h: document enum vb2_memory
Date: Thu,  8 Sep 2016 18:37:34 -0300
Message-Id: <4fb634acfd16e6e0f0ba79a97af55b1d111713e9.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enum was not documented. Document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-core.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 68f93dacb38f..65eeca83687a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -20,6 +20,20 @@
 #define VB2_MAX_FRAME	(32)
 #define VB2_MAX_PLANES	(8)
 
+/**
+ * enum vb2_memory - type of memory model used to make the buffers visible
+ *	on userspace.
+ *
+ * @VB2_MEMORY_UNKNOWN:	Buffer status is unknown or it is not used yet on
+ *			userspace.
+ * @VB2_MEMORY_MMAP:	The buffers are allocated by the Kernel and it is
+ *			memory mapped via mmap() ioctl. This model is
+ *			also used when the user is using the buffers via
+ *			read() or write() system calls.
+ * @VB2_MEMORY_USERPTR:	The buffers was allocated in userspace and it is
+ *			memory mapped via mmap() ioctl.
+ * @VB2_MEMORY_DMABUF:	The buffers are passed to userspace via DMA buffer.
+ */
 enum vb2_memory {
 	VB2_MEMORY_UNKNOWN	= 0,
 	VB2_MEMORY_MMAP		= 1,
-- 
2.7.4


