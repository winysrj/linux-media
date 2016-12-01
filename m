Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:48466 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755599AbcLAEzZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 23:55:25 -0500
From: Shailendra Verma <shailendra.v@samsung.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: vidushi.koul@samsung.com
Subject: [PATCH] V4l: omap4iss: Clean up file handle in open() and release().
Date: Thu, 01 Dec 2016 10:22:52 +0530
Message-id: <1480567972-13510-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both functions initialize the file handle with v4l2_fh_init()
and thus need to call clean up with v4l2_fh_exit() as appropriate.

Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 drivers/staging/media/omap4iss/iss_video.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index c16927a..077c9f8 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -1141,6 +1141,7 @@ static int iss_video_open(struct file *file)
 done:
 	if (ret < 0) {
 		v4l2_fh_del(&handle->vfh);
+		v4l2_fh_exit(&handle->vfh);
 		kfree(handle);
 	}
 
@@ -1162,6 +1163,7 @@ static int iss_video_release(struct file *file)
 	vb2_queue_release(&handle->queue);
 
 	v4l2_fh_del(vfh);
+	v4l2_fh_exit(vfh);
 	kfree(handle);
 	file->private_data = NULL;
 
-- 
1.7.9.5

