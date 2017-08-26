Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34557 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbdHZGQD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 02:16:03 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, laurent.pinchart@ideasonboard.com,
        gregkh@linuxfoundation.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] staging: omap4iss: make v4l2_file_operations const
Date: Sat, 26 Aug 2017 11:45:53 +0530
Message-Id: <1503728153-2954-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only stored in a const field of a
video_device structure.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 0bac582..9e2f042 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -1199,7 +1199,7 @@ static int iss_video_mmap(struct file *file, struct vm_area_struct *vma)
 	return vb2_mmap(&vfh->queue, vma);
 }
 
-static struct v4l2_file_operations iss_video_fops = {
+static const struct v4l2_file_operations iss_video_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = video_ioctl2,
 	.open = iss_video_open,
-- 
1.9.1
