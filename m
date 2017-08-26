Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34214 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbdHZGN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 02:13:56 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] usbtv: make v4l2_file_operations const
Date: Sat, 26 Aug 2017 11:43:46 +0530
Message-Id: <1503728026-2893-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only stored in a const field of a
video_device structure.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/usbtv/usbtv-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 8135614..95b5f43 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -629,7 +629,7 @@ static int usbtv_s_input(struct file *file, void *priv, unsigned int i)
 	.vidioc_streamoff = vb2_ioctl_streamoff,
 };
 
-static struct v4l2_file_operations usbtv_fops = {
+static const struct v4l2_file_operations usbtv_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = video_ioctl2,
 	.mmap = vb2_fop_mmap,
-- 
1.9.1
