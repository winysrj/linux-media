Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38747 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdI0RIl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 13:08:41 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] vb2: make vb2_ops
Date: Wed, 27 Sep 2017 22:38:19 +0530
Message-Id: <1506532099-8114-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make vb2_ops const as they are only stored in the const field of a
vb2_queue structure. Make the declarations const too.

Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/au0828/au0828-vbi.c | 2 +-
 drivers/media/usb/au0828/au0828.h     | 2 +-
 drivers/media/usb/em28xx/em28xx-v4l.h | 2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index e0930ce..9dd6bdb 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -79,7 +79,7 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-struct vb2_ops au0828_vbi_qops = {
+const struct vb2_ops au0828_vbi_qops = {
 	.queue_setup     = vbi_queue_setup,
 	.buf_prepare     = vbi_buffer_prepare,
 	.buf_queue       = vbi_buffer_queue,
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 05e445f..f6f37e8 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -358,7 +358,7 @@ static inline int au0828_analog_unregister(struct au0828_dev *dev)
 void au0828_dvb_resume(struct au0828_dev *dev);
 
 /* au0828-vbi.c */
-extern struct vb2_ops au0828_vbi_qops;
+extern const struct vb2_ops au0828_vbi_qops;
 
 #define dprintk(level, fmt, arg...)\
 	do { if (au0828_debug & level)\
diff --git a/drivers/media/usb/em28xx/em28xx-v4l.h b/drivers/media/usb/em28xx/em28xx-v4l.h
index 8dfcb56..9c411aa 100644
--- a/drivers/media/usb/em28xx/em28xx-v4l.h
+++ b/drivers/media/usb/em28xx/em28xx-v4l.h
@@ -16,4 +16,4 @@
 
 int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count);
 void em28xx_stop_vbi_streaming(struct vb2_queue *vq);
-extern struct vb2_ops em28xx_vbi_qops;
+extern const struct vb2_ops em28xx_vbi_qops;
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 0bac552..f512365 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -93,7 +93,7 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-struct vb2_ops em28xx_vbi_qops = {
+const struct vb2_ops em28xx_vbi_qops = {
 	.queue_setup    = vbi_queue_setup,
 	.buf_prepare    = vbi_buffer_prepare,
 	.buf_queue      = vbi_buffer_queue,
-- 
1.9.1
