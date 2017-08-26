Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33140 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdHZGMS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 02:12:18 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] v4l: omap3isp: make v4l2_file_operations const
Date: Sat, 26 Aug 2017 11:42:07 +0530
Message-Id: <1503727927-2838-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only stored in a const field of a
video_device structure.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 218e6d7..b96f344 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1403,7 +1403,7 @@ static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
 	return vb2_mmap(&vfh->queue, vma);
 }
 
-static struct v4l2_file_operations isp_video_fops = {
+static const struct v4l2_file_operations isp_video_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = video_ioctl2,
 	.open = isp_video_open,
-- 
1.9.1
