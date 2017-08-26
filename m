Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33822 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752480AbdHZNLp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 09:11:45 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip.fr, crope@iki.fi, mchehab@kernel.org,
        hans.verkuil@cisco.com, isely@pobox.com,
        ezequiel@vanguardiasur.com.ar, royale@zerezo.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH v2] [media] usb: make video_device const
Date: Sat, 26 Aug 2017 18:41:30 +0530
Message-Id: <1503753090-19987-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used during a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
Changes in v2:
* Combine the patch series sent for drivers/media/usb/ into a
single patch.

 drivers/media/usb/airspy/airspy.c        | 2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c      | 2 +-
 drivers/media/usb/go7007/go7007-v4l2.c   | 2 +-
 drivers/media/usb/hackrf/hackrf.c        | 2 +-
 drivers/media/usb/msi2500/msi2500.c      | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 2 +-
 drivers/media/usb/pwc/pwc-if.c           | 2 +-
 drivers/media/usb/s2255/s2255drv.c       | 2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c  | 2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c | 2 +-
 drivers/media/usb/zr364xx/zr364xx.c      | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 07f3f4e..e70c9e2 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -859,7 +859,7 @@ static int airspy_enum_freq_bands(struct file *file, void *priv,
 	.unlocked_ioctl           = video_ioctl2,
 };
 
-static struct video_device airspy_template = {
+static const struct video_device airspy_template = {
 	.name                     = "AirSpy SDR",
 	.release                  = video_device_release_empty,
 	.fops                     = &airspy_fops,
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 7122023..3dedd83 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -1075,7 +1075,7 @@ static void reset_camera_struct_v4l(struct camera_data *cam)
 	.mmap		= cpia2_mmap,
 };
 
-static struct video_device cpia2_template = {
+static const struct video_device cpia2_template = {
 	/* I could not find any place for the old .initialize initializer?? */
 	.name =		"CPiA2 Camera",
 	.fops =		&cpia2_fops,
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 445f17b..98cd57e 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -901,7 +901,7 @@ static int go7007_s_ctrl(struct v4l2_ctrl *ctrl)
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static struct video_device go7007_template = {
+static const struct video_device go7007_template = {
 	.name		= "go7007",
 	.fops		= &go7007_fops,
 	.release	= video_device_release_empty,
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index a41b305..7eb5351 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -1263,7 +1263,7 @@ static int hackrf_enum_freq_bands(struct file *file, void *priv,
 	.unlocked_ioctl           = video_ioctl2,
 };
 
-static struct video_device hackrf_template = {
+static const struct video_device hackrf_template = {
 	.name                     = "HackRF One",
 	.release                  = video_device_release_empty,
 	.fops                     = &hackrf_fops,
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 79bfd2d..a097d3d 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1143,7 +1143,7 @@ static int msi2500_enum_freq_bands(struct file *file, void *priv,
 	.unlocked_ioctl           = video_ioctl2,
 };
 
-static struct video_device msi2500_template = {
+static const struct video_device msi2500_template = {
 	.name                     = "Mirics MSi3101 SDR Dongle",
 	.release                  = video_device_release_empty,
 	.fops                     = &msi2500_fops,
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 8f13c60..4320bda 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -1226,7 +1226,7 @@ static unsigned int pvr2_v4l2_poll(struct file *file, poll_table *wait)
 };
 
 
-static struct video_device vdev_template = {
+static const struct video_device vdev_template = {
 	.fops       = &vdev_fops,
 };
 
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 22420c1..eb6921d 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -146,7 +146,7 @@
 	.mmap =		vb2_fop_mmap,
 	.unlocked_ioctl = video_ioctl2,
 };
-static struct video_device pwc_template = {
+static const struct video_device pwc_template = {
 	.name =		"Philips Webcam",	/* Filled in later */
 	.release =	video_device_release_empty,
 	.fops =         &pwc_fops,
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 23f606e..b2f239c 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1590,7 +1590,7 @@ static void s2255_video_device_release(struct video_device *vdev)
 	return;
 }
 
-static struct video_device template = {
+static const struct video_device template = {
 	.name = "s2255v",
 	.fops = &s2255_fops_v4l,
 	.ioctl_ops = &s2255_ioctl_ops,
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index a132faa..77b759a 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -751,7 +751,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	.wait_finish		= vb2_ops_wait_finish,
 };
 
-static struct video_device v4l_template = {
+static const struct video_device v4l_template = {
 	.name = "stk1160",
 	.tvnorms = V4L2_STD_525_60 | V4L2_STD_625_50,
 	.fops = &stk1160_fops,
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 39abb58..c0bba77 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1244,7 +1244,7 @@ static void stk_v4l_dev_release(struct video_device *vd)
 	kfree(dev);
 }
 
-static struct video_device stk_v4l_data = {
+static const struct video_device stk_v4l_data = {
 	.name = "stkwebcam",
 	.fops = &v4l_stk_fops,
 	.ioctl_ops = &v4l_stk_ioctl_ops,
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index d4bb56b..4ff8d0a 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1335,7 +1335,7 @@ static unsigned int zr364xx_poll(struct file *file,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static struct video_device zr364xx_template = {
+static const struct video_device zr364xx_template = {
 	.name = DRIVER_DESC,
 	.fops = &zr364xx_fops,
 	.ioctl_ops = &zr364xx_ioctl_ops,
-- 
1.9.1
