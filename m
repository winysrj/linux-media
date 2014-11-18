Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41593 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbaKRMvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 07:51:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv7 PATCH 04/12] vb2: don't free alloc context if it is ERR_PTR
Date: Tue, 18 Nov 2014 13:51:00 +0100
Message-Id: <1416315068-22936-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't try to free a pointer containing an ERR_PTR().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index c4305bf..0bfc488 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -854,7 +854,8 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
 
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
 {
-	kfree(alloc_ctx);
+	if (!IS_ERR_OR_NULL(alloc_ctx))
+		kfree(alloc_ctx);
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
 
-- 
2.1.1

