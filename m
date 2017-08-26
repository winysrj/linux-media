Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35756 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdHZInx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:43:53 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org, edubezval@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] radio: make video_device const
Date: Sat, 26 Aug 2017 14:13:43 +0530
Message-Id: <1503737023-15550-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/radio/radio-tea5764.c                | 2 +-
 drivers/media/radio/radio-wl1273.c                 | 2 +-
 drivers/media/radio/si4713/radio-platform-si4713.c | 2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 9db8331..bc7e69e 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -414,7 +414,7 @@ static int tea5764_s_ctrl(struct v4l2_ctrl *ctrl)
 };
 
 /* V4L2 interface */
-static struct video_device tea5764_radio_template = {
+static const struct video_device tea5764_radio_template = {
 	.name		= "TEA5764 FM-Radio",
 	.fops           = &tea5764_fops,
 	.ioctl_ops 	= &tea5764_ioctl_ops,
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 17e82a9..903fcd5 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1982,7 +1982,7 @@ static void wl1273_vdev_release(struct video_device *dev)
 	.vidioc_log_status      = wl1273_fm_vidioc_log_status,
 };
 
-static struct video_device wl1273_viddev_template = {
+static const struct video_device wl1273_viddev_template = {
 	.fops			= &wl1273_fops,
 	.ioctl_ops		= &wl1273_ioctl_ops,
 	.name			= WL1273_FM_DRIVER_NAME,
diff --git a/drivers/media/radio/si4713/radio-platform-si4713.c b/drivers/media/radio/si4713/radio-platform-si4713.c
index 6f93ef1..27339ec 100644
--- a/drivers/media/radio/si4713/radio-platform-si4713.c
+++ b/drivers/media/radio/si4713/radio-platform-si4713.c
@@ -135,7 +135,7 @@ static long radio_si4713_default(struct file *file, void *p,
 };
 
 /* radio_si4713_vdev_template - video device interface */
-static struct video_device radio_si4713_vdev_template = {
+static const struct video_device radio_si4713_vdev_template = {
 	.fops			= &radio_si4713_fops,
 	.name			= "radio-si4713",
 	.release		= video_device_release_empty,
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 71423f4..fc5a7ab 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -509,7 +509,7 @@ static int fm_v4l2_vidioc_s_modulator(struct file *file, void *priv,
 };
 
 /* V4L2 RADIO device parent structure */
-static struct video_device fm_viddev_template = {
+static const struct video_device fm_viddev_template = {
 	.fops = &fm_drv_fops,
 	.ioctl_ops = &fm_drv_ioctl_ops,
 	.name = FM_DRV_NAME,
-- 
1.9.1
