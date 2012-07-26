Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61372 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2GZUTW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 16:19:22 -0400
Received: by ghrr11 with SMTP id r11so2452113ghr.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 13:19:22 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] v4l-dev.c: Use 'ret' variable to return release() exit code
Date: Thu, 26 Jul 2012 17:19:06 -0300
Message-Id: <1343333946-9893-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 65d9ff9c85d3c2e06d22aed78efee8404563eff6:
"V4L/DVB (11390): 2-dev.c: return 0 for NULL open and release callbacks",
introduced this bug.

The bug this patch fixes is almost innocuous because nobody
really cares about release() exit code.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/v4l2-dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index d13c47f..337c370 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -496,7 +496,7 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	if (vdev->fops->release) {
 		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 			mutex_lock(vdev->lock);
-		vdev->fops->release(filp);
+		ret = vdev->fops->release(filp);
 		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 			mutex_unlock(vdev->lock);
 	}
-- 
1.7.8.6

