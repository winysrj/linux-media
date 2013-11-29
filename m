Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:22558 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3K2Huc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 02:50:32 -0500
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MX000IBRLS2YS10@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 29 Nov 2013 16:50:26 +0900 (KST)
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	m.chehab@samsung.com
Cc: pawel@osciak.com, sw0312.kim@samsung.com
Subject: [PATCH] [media] videobuf2: Add log for size checking error in
 __qbuf_dmabuf
Date: Fri, 29 Nov 2013 16:50:29 +0900
Message-id: <1385711429-5442-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

__qbuf_dmabuf checks whether size of provided dmabuf is large
enough, and it returns error without any log. So this patch adds
error log in the case.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index b19b306..5faf10c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1116,6 +1116,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		if (planes[plane].length < planes[plane].data_offset +
 		    q->plane_sizes[plane]) {
+			dprintk(1, "qbuf: invalid dmabuf length for plane %d\n",
+				plane);
 			ret = -EINVAL;
 			goto err;
 		}
-- 
1.7.4.1

