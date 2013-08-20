Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:25516 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3HTIsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 04:48:00 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MRT00ETVN3V8N50@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Aug 2013 17:47:55 +0900 (KST)
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	m.chehab@samsung.com
Cc: pawel@osciak.com, sw0312.kim@samsung.com, heejin.woo@samsung.com
Subject: [PATCH] media: vb2: add log for size checking error in __qbuf_userptr
Date: Tue, 20 Aug 2013 17:48:06 +0900
Message-id: <1376988486-17512-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

__qbuf_userptr checks whether provided buffer is large enough, and
it returns error without any log.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Heejin Woo <heejin.woo@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 9fc4bab..96827e8 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -978,6 +978,10 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 		/* Check if the provided plane buffer is large enough */
 		if (planes[plane].length < q->plane_sizes[plane]) {
+			dprintk(1, "qbuf: provided buffer size %u is less than "
+						"setup size %u for plane %d\n",
+						planes[plane].length,
+						q->plane_sizes[plane], plane);
 			ret = -EINVAL;
 			goto err;
 		}
-- 
1.7.4.1

