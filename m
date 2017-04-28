Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:44237 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162860AbdD1Exh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 00:53:37 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stable@vger.kernel.org
Subject: [PATCH v2] [media] vb2: Fix an off by one error in 'vb2_plane_vaddr'
Date: Fri, 28 Apr 2017 06:51:40 +0200
Message-Id: <20170428045140.20870-1-christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should ensure that 'plane_no' is '< vb->num_planes' as done in
'vb2_plane_cookie' just a few lines below.

Cc: stable@vger.kernel.org
Fixes: e23ccc0ad925 ("[media] v4l: add videobuf2 Video for Linux 2 driver framework")

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: add CC and Fixes tags
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
