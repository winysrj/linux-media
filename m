Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56952 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751896AbdJIKTi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 18/24] media: vb2-core: use bitops for bits
Date: Mon,  9 Oct 2017 07:19:24 -0300
Message-Id: <28954c09c38082fdc7d538ece5192606ccdc7ea5.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the existing macros to identify vb2_io_modes bits.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/videobuf2-core.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5f4df060affb..0308d8439049 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/dma-buf.h>
+#include <linux/bitops.h>
 
 #define VB2_MAX_FRAME	(32)
 #define VB2_MAX_PLANES	(8)
@@ -191,11 +192,11 @@ struct vb2_plane {
  * @VB2_DMABUF:		driver supports DMABUF with streaming API
  */
 enum vb2_io_modes {
-	VB2_MMAP	= (1 << 0),
-	VB2_USERPTR	= (1 << 1),
-	VB2_READ	= (1 << 2),
-	VB2_WRITE	= (1 << 3),
-	VB2_DMABUF	= (1 << 4),
+	VB2_MMAP	= BIT(0),
+	VB2_USERPTR	= BIT(1),
+	VB2_READ	= BIT(2),
+	VB2_WRITE	= BIT(3),
+	VB2_DMABUF	= BIT(4),
 };
 
 /**
-- 
2.13.6
