Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34318 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbeHHRNB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 13:13:01 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 3/6] media: s3c-camif: fix return code for the polling routine
Date: Wed,  8 Aug 2018 10:52:53 -0400
Message-Id: <5840115d72dcbf018f48f180a13e87212cc76ca3.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All poll handlers should return a poll flag, and not error codes. So,
instead of returning an error, do the right thing here,
e. g. to return EPOLERR on errors, just like the V4L2 VB2 code.

Solves the following sparse warning:
    drivers/media/platform/s3c-camif/camif-capture.c:604:21: warning: incorrect type in assignment (different base types)
    drivers/media/platform/s3c-camif/camif-capture.c:604:21:    expected restricted __poll_t [usertype] ret
    drivers/media/platform/s3c-camif/camif-capture.c:604:21:    got int

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/s3c-camif/camif-capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index b1d9f3857d3d..c02dce8b4c6c 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -601,7 +601,7 @@ static __poll_t s3c_camif_poll(struct file *file,
 
 	mutex_lock(&camif->lock);
 	if (vp->owner && vp->owner != file->private_data)
-		ret = -EBUSY;
+		ret = EPOLLERR;
 	else
 		ret = vb2_poll(&vp->vb_queue, file, wait);
 
-- 
2.17.1
