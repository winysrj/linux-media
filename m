Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:24893 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1046091AbdDWVk5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Apr 2017 17:40:57 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] [media] vb2: Fix an off by one error in 'vb2_plane_vaddr'
Date: Sun, 23 Apr 2017 23:32:57 +0200
Message-Id: <20170423213257.14773-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should ensure that 'plane_no' is '< vb->num_planes' as done in
'vb2_plane_cookie' just a few lines below.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 94afbbf92807..c0175ea7e7ad 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -868,7 +868,7 @@ EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
 
 void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
 {
-	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
 	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
-- 
2.11.0
