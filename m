Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34783 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbdHZLdI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:33:08 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] Staging: media: radio-bcm2048: make video_device const
Date: Sat, 26 Aug 2017 17:02:53 +0530
Message-Id: <1503747173-19161-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 86d7fc2..58adaea 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2564,7 +2564,7 @@ static int bcm2048_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 /*
  * bcm2048_viddev_template - video device interface
  */
-static struct video_device bcm2048_viddev_template = {
+static const struct video_device bcm2048_viddev_template = {
 	.fops			= &bcm2048_fops,
 	.name			= BCM2048_DRIVER_NAME,
 	.release		= video_device_release_empty,
-- 
1.9.1
