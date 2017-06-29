Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34711 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdF2G5k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 02:57:40 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org, hans.verkuil@cisco.com,
        ezequiel@vanguardiasur.com.ar, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media]: usb: add const to v4l2_file_operations structures
Date: Thu, 29 Jun 2017 12:25:23 +0530
Message-Id: <1498719323-32586-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare v4l2_file_operations structures as const as they are only stored
in the fops field of video_device structures. This field is of type
const, so declare v4l2_file_operations structures with similar properties
as const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/au0828/au0828-video.c  | 2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c  | 2 +-
 drivers/media/usb/go7007/go7007-v4l2.c   | 2 +-
 drivers/media/usb/gspca/gspca.c          | 2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c  | 2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c | 2 +-
 drivers/media/usb/tm6000/tm6000-video.c  | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 2a255bd..9342402 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1740,7 +1740,7 @@ void au0828_v4l2_resume(struct au0828_dev *dev)
 	}
 }
 
-static struct v4l2_file_operations au0828_v4l_fops = {
+static const struct v4l2_file_operations au0828_v4l_fops = {
 	.owner      = THIS_MODULE,
 	.open       = au0828_v4l2_open,
 	.release    = au0828_v4l2_close,
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 509d971..8d5eb99 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1843,7 +1843,7 @@ static int mpeg_mmap(struct file *file, struct vm_area_struct *vma)
 	return videobuf_mmap_mapper(&fh->vidq, vma);
 }
 
-static struct v4l2_file_operations mpeg_fops = {
+static const struct v4l2_file_operations mpeg_fops = {
 	.owner	       = THIS_MODULE,
 	.open	       = mpeg_open,
 	.release       = mpeg_release,
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index ed5ec97..445f17b 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -857,7 +857,7 @@ static int go7007_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static struct v4l2_file_operations go7007_fops = {
+static const struct v4l2_file_operations go7007_fops = {
 	.owner		= THIS_MODULE,
 	.open		= v4l2_fh_open,
 	.release	= vb2_fop_release,
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 16bc1dd..0f14176 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1964,7 +1964,7 @@ static ssize_t dev_read(struct file *file, char __user *data,
 	return ret;
 }
 
-static struct v4l2_file_operations dev_fops = {
+static const struct v4l2_file_operations dev_fops = {
 	.owner = THIS_MODULE,
 	.open = dev_open,
 	.release = dev_close,
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index a005d26..a132faa 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -326,7 +326,7 @@ static int stk1160_stop_streaming(struct stk1160 *dev)
 	return 0;
 }
 
-static struct v4l2_file_operations stk1160_fops = {
+static const struct v4l2_file_operations stk1160_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l2_fh_open,
 	.release = vb2_fop_release,
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 90d4a08..93330be 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1202,7 +1202,7 @@ static const struct v4l2_ctrl_ops stk_ctrl_ops = {
 	.s_ctrl = stk_s_ctrl,
 };
 
-static struct v4l2_file_operations v4l_stk_fops = {
+static const struct v4l2_file_operations v4l_stk_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l_stk_open,
 	.release = v4l_stk_release,
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 7e960d0..cec1321 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1532,7 +1532,7 @@ static int tm6000_mmap(struct file *file, struct vm_area_struct * vma)
 	return res;
 }
 
-static struct v4l2_file_operations tm6000_fops = {
+static const struct v4l2_file_operations tm6000_fops = {
 	.owner = THIS_MODULE,
 	.open = tm6000_open,
 	.release = tm6000_release,
-- 
2.7.4
