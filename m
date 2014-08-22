Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17220 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaHVCcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 22:32:12 -0400
From: Zhaowei Yuan <zhaowei.yuan@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, hverkuil@xs4all.nl
Subject: [PATCH V2] vb2: fix plane index sanity check in vb2_plane_cookie()
Date: Fri, 22 Aug 2014 10:28:21 +0800
Message-id: <1408674501-25336-1-git-send-email-zhaowei.yuan@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's also invalid that plane_no equals to vb->num_planes

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c359006..1ae4e57 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1130,7 +1130,7 @@ EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
  */
 void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 {
-	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
+	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;

 	return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
--
1.7.9.5

