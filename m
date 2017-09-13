Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35430 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbdIMTiI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 15:38:08 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, hverkuil@xs4all.nl, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] saa7146: make saa7146_use_ops const
Date: Thu, 14 Sep 2017 01:07:50 +0530
Message-Id: <1505331470-28925-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are not modified in the file referencing them.
They are only used when their function pointer fields invokes a
function and therefore none of the structure fields are getting modified.
Also, add a const to the declaration in the header.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/common/saa7146/saa7146_vbi.c   | 2 +-
 drivers/media/common/saa7146/saa7146_video.c | 2 +-
 include/media/drv-intf/saa7146_vv.h          | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
index d79e4d7..69525ca 100644
--- a/drivers/media/common/saa7146/saa7146_vbi.c
+++ b/drivers/media/common/saa7146/saa7146_vbi.c
@@ -488,7 +488,7 @@ static ssize_t vbi_read(struct file *file, char __user *data, size_t count, loff
 	return ret;
 }
 
-struct saa7146_use_ops saa7146_vbi_uops = {
+const struct saa7146_use_ops saa7146_vbi_uops = {
 	.init		= vbi_init,
 	.open		= vbi_open,
 	.release	= vbi_close,
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 37b4654..51eeed8 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -1303,7 +1303,7 @@ static ssize_t video_read(struct file *file, char __user *data, size_t count, lo
 	return ret;
 }
 
-struct saa7146_use_ops saa7146_video_uops = {
+const struct saa7146_use_ops saa7146_video_uops = {
 	.init = video_init,
 	.open = video_open,
 	.release = video_close,
diff --git a/include/media/drv-intf/saa7146_vv.h b/include/media/drv-intf/saa7146_vv.h
index 0da6ccc..736f4f2 100644
--- a/include/media/drv-intf/saa7146_vv.h
+++ b/include/media/drv-intf/saa7146_vv.h
@@ -202,14 +202,14 @@ void saa7146_dma_free(struct saa7146_dev* dev,struct videobuf_queue *q,
 /* from saa7146_video.c */
 extern const struct v4l2_ioctl_ops saa7146_video_ioctl_ops;
 extern const struct v4l2_ioctl_ops saa7146_vbi_ioctl_ops;
-extern struct saa7146_use_ops saa7146_video_uops;
+extern const struct saa7146_use_ops saa7146_video_uops;
 int saa7146_start_preview(struct saa7146_fh *fh);
 int saa7146_stop_preview(struct saa7146_fh *fh);
 long saa7146_video_do_ioctl(struct file *file, unsigned int cmd, void *arg);
 int saa7146_s_ctrl(struct v4l2_ctrl *ctrl);
 
 /* from saa7146_vbi.c */
-extern struct saa7146_use_ops saa7146_vbi_uops;
+extern const struct saa7146_use_ops saa7146_vbi_uops;
 
 /* resource management functions */
 int saa7146_res_get(struct saa7146_fh *fh, unsigned int bit);
-- 
1.9.1
