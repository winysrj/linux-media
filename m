Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55456 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaLKNH1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Dec 2014 08:07:27 -0500
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id sBBD7Q14022750
	for <linux-media@vger.kernel.org>; Thu, 11 Dec 2014 07:07:26 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id sBBD7Qv4013241
	for <linux-media@vger.kernel.org>; Thu, 11 Dec 2014 07:07:26 -0600
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>
CC: Nikhil Devshatwar <nikhil.nd@ti.com>
Subject: [PATCH] [media] videobuf-dma-contig: NULL check for vb2_plane_cookie
Date: Thu, 11 Dec 2014 18:37:22 +0530
Message-ID: <1418303242-8513-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_plane_cookie can return NULL if the plane no is greater than
total no of planes or when mem_ops are absent.

Add NULL check to avoid NULL pointer crash in the kernel.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
---
 include/media/videobuf2-dma-contig.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 8197f87..5efc56e 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -21,7 +21,10 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	dma_addr_t *addr = vb2_plane_cookie(vb, plane_no);
 
-	return *addr;
+	if (addr == NULL)
+		return addr;
+	else
+		return *addr;
 }
 
 void *vb2_dma_contig_init_ctx(struct device *dev);
-- 
1.7.9.5

