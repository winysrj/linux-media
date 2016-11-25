Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:51089 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbcKYEyl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 23:54:41 -0500
From: Shailendra Verma <shailendra.v@samsung.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: vidushi.koul@samsung.com
Subject: [PATCH] Staging: media: platform: davinci: - Fix for memory leak
Date: Fri, 25 Nov 2016 10:22:04 +0530
Message-id: <1480049524-20460-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix to avoid possible memory leak if the decoder initialization got failed.
Free the allocated memory for file handle object before return in case
decoder initialization fails.

Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 drivers/media/platform/davinci/vpfe_capture.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 6efb2f1..188b333 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -526,6 +526,8 @@ static int vpfe_open(struct file *file)
 	if (!vpfe_dev->initialized) {
 		if (vpfe_initialize_device(vpfe_dev)) {
 			mutex_unlock(&vpfe_dev->lock);
+			v4l2_fh_exit(&fh->fh);
+			kfree(fh);
 			return -ENODEV;
 		}
 	}
-- 
1.7.9.5

