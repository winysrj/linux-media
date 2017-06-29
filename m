Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36279 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751855AbdF2Ixz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 04:53:55 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, scott.jiang.linux@gmail.com,
        mchehab@kernel.org, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, adi-buildroot-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] media/platform: add const to v4l2_file_operations structures
Date: Thu, 29 Jun 2017 14:21:24 +0530
Message-Id: <1498726284-10182-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare v4l2_file_operations structures as const as they are only stored
in the fops field of video_device structures. This field is of type
const, so declare v4l2_file_operations structures with similar properties
as const.

Cross compiled bfin_capture.o for blackfin arch. vpbe_display.o file did
not cross compile for arm. Could not find any architecture matching the
configuraion symbol for fsl-viu.c file.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 2 +-
 drivers/media/platform/davinci/vpbe_display.c  | 2 +-
 drivers/media/platform/davinci/vpif_capture.c  | 2 +-
 drivers/media/platform/fsl-viu.c               | 2 +-
 drivers/media/platform/soc_camera/soc_camera.c | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 1c5166d..294d696 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -769,7 +769,7 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_log_status       = bcap_log_status,
 };
 
-static struct v4l2_file_operations bcap_fops = {
+static const struct v4l2_file_operations bcap_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l2_fh_open,
 	.release = vb2_fop_release,
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index a9bc017..ca2adfa 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1275,7 +1275,7 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_enum_dv_timings	 = vpbe_display_enum_dv_timings,
 };
 
-static struct v4l2_file_operations vpbe_fops = {
+static const struct v4l2_file_operations vpbe_fops = {
 	.owner = THIS_MODULE,
 	.open = vpbe_display_open,
 	.release = vpbe_display_release,
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index d78580f..fbdc196 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1344,7 +1344,7 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
 };
 
 /* vpif file operations */
-static struct v4l2_file_operations vpif_fops = {
+static const struct v4l2_file_operations vpif_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l2_fh_open,
 	.release = vb2_fop_release,
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 97e164b..f7b88e5 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1340,7 +1340,7 @@ static int viu_mmap(struct file *file, struct vm_area_struct *vma)
 	return ret;
 }
 
-static struct v4l2_file_operations viu_fops = {
+static const struct v4l2_file_operations viu_fops = {
 	.owner		= THIS_MODULE,
 	.open		= viu_open,
 	.release	= viu_release,
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 45a0429..dd349ef 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -820,7 +820,7 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 	return res;
 }
 
-static struct v4l2_file_operations soc_camera_fops = {
+static const struct v4l2_file_operations soc_camera_fops = {
 	.owner		= THIS_MODULE,
 	.open		= soc_camera_open,
 	.release	= soc_camera_close,
-- 
2.7.4
