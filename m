Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55886 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbeJSC5G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 22:57:06 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] media: Rename vb2_m2m_request_queue -> v4l2_m2m_request_queue
Date: Thu, 18 Oct 2018 15:54:29 -0300
Message-Id: <20181018185429.10790-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To be consistent with the rest of the mem2mem helpers,
rename vb2_m2m_request_queue to v4l2_m2m_request_queue.

This is just a cosmetic change.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/vim2m.c              | 2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c      | 4 ++--
 drivers/staging/media/sunxi/cedrus/cedrus.c | 2 +-
 include/media/v4l2-mem2mem.h                | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index af150a0395df..d82db738f174 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1009,7 +1009,7 @@ static const struct v4l2_m2m_ops m2m_ops = {
 
 static const struct media_device_ops m2m_media_ops = {
 	.req_validate = vb2_request_validate,
-	.req_queue = vb2_m2m_request_queue,
+	.req_queue = v4l2_m2m_request_queue,
 };
 
 static int vim2m_probe(struct platform_device *pdev)
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index d7806db222d8..1ed2465972ac 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -953,7 +953,7 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
 
-void vb2_m2m_request_queue(struct media_request *req)
+void v4l2_m2m_request_queue(struct media_request *req)
 {
 	struct media_request_object *obj, *obj_safe;
 	struct v4l2_m2m_ctx *m2m_ctx = NULL;
@@ -997,7 +997,7 @@ void vb2_m2m_request_queue(struct media_request *req)
 	if (m2m_ctx)
 		v4l2_m2m_try_schedule(m2m_ctx);
 }
-EXPORT_SYMBOL_GPL(vb2_m2m_request_queue);
+EXPORT_SYMBOL_GPL(v4l2_m2m_request_queue);
 
 /* Videobuf2 ioctl helpers */
 
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index 82558455384a..dd121f66fa2d 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -253,7 +253,7 @@ static const struct v4l2_m2m_ops cedrus_m2m_ops = {
 
 static const struct media_device_ops cedrus_m2m_media_ops = {
 	.req_validate	= cedrus_request_validate,
-	.req_queue	= vb2_m2m_request_queue,
+	.req_queue	= v4l2_m2m_request_queue,
 };
 
 static int cedrus_probe(struct platform_device *pdev)
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 58c1ecf3d648..5467264771ec 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -624,7 +624,7 @@ v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
 
 /* v4l2 request helper */
 
-void vb2_m2m_request_queue(struct media_request *req);
+void v4l2_m2m_request_queue(struct media_request *req);
 
 /* v4l2 ioctl helpers */
 
-- 
2.19.1
