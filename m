Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38380 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbcLAEsA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 23:48:00 -0500
From: Shailendra Verma <shailendra.v@samsung.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: vidushi.koul@samsung.com
Subject: [PATCH] V4l: omap3isp: Clean up file handle in open() and release().
Date: Thu, 01 Dec 2016 10:15:40 +0530
Message-id: <1480567540-13119-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both functions initialize the file handle with v4l2_fh_init()
and thus need to call clean up with v4l2_fh_exit() as appropriate.

Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 drivers/media/platform/omap3isp/ispvideo.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 7354469..9f966e8 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1350,6 +1350,7 @@ static int isp_video_open(struct file *file)
 done:
 	if (ret < 0) {
 		v4l2_fh_del(&handle->vfh);
+		v4l2_fh_exit(&handle->vfh);
 		kfree(handle);
 	}
 
@@ -1373,6 +1374,7 @@ static int isp_video_release(struct file *file)
 
 	/* Release the file handle. */
 	v4l2_fh_del(vfh);
+	v4l2_fh_exit(vfh);
 	kfree(handle);
 	file->private_data = NULL;
 
-- 
1.7.9.5

