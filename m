Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:64484 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3EMFsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 01:48:46 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf3so2182194bkc.7
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 22:48:45 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 May 2013 13:48:45 +0800
Message-ID: <CAPgLHd9ydkkQ_yOmhnU1awN08kBhiM-ZryGBqq8S0qisHkYvqA@mail.gmail.com>
Subject: [PATCH] [media] v4l: vb2: fix error return code in __vb2_init_fileio()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -EINVAL in the get kernel address error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/v4l2-core/videobuf2-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7d833ee..7bd3ee6 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2193,8 +2193,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 	 */
 	for (i = 0; i < q->num_buffers; i++) {
 		fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
-		if (fileio->bufs[i].vaddr == NULL)
+		if (fileio->bufs[i].vaddr == NULL) {
+			ret = -EINVAL;
 			goto err_reqbufs;
+		}
 		fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
 	}
 

