Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:22374 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaGWAxM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 20:53:12 -0400
From: Zhaowei Yuan <zhaowei.yuan@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org,
	Zhaowei Yuan <zhaowei.yuan@samsung.com>
Subject: [PATCH] media: s5p_mfc: remove unnecessary calling to function
 video_devdata()
Date: Wed, 23 Jul 2014 08:49:32 +0800
Message-id: <1406076572-5719-1-git-send-email-zhaowei.yuan@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since we have get vdev by calling video_devdata() at the beginning of
s5p_mfc_open(), we should just use vdev instead of calling video_devdata()
again in the following code.

Change-Id: I869051762d33b50a7c0dbc8149b072e70b89c6b9
Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d57b306..d508cbc 100755
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -709,7 +709,7 @@ static int s5p_mfc_open(struct file *file)
 		ret = -ENOMEM;
 		goto err_alloc;
 	}
-	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	v4l2_fh_init(&ctx->fh, vdev);
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 	ctx->dev = dev;
--
1.7.9.5

