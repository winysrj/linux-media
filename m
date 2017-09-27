Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35081 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdI0Q7b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 12:59:31 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] vb2: make vb2_ops const
Date: Wed, 27 Sep 2017 22:29:06 +0530
Message-Id: <1506531546-6570-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make vb2_ops const as they are only stored in the const field of a
vb2_queue structure. Make the declarations const too.

Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-vbi.c | 2 +-
 drivers/media/pci/cx23885/cx23885.h     | 2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c | 2 +-
 drivers/media/pci/saa7134/saa7134.h     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index 369e545..70f9f13 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -254,7 +254,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 }
 
 
-struct vb2_ops cx23885_vbi_qops = {
+const struct vb2_ops cx23885_vbi_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index cb714ab..6aab713 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -591,7 +591,7 @@ extern void cx23885_video_wakeup(struct cx23885_dev *dev,
 extern int cx23885_vbi_fmt(struct file *file, void *priv,
 	struct v4l2_format *f);
 extern void cx23885_vbi_timeout(unsigned long data);
-extern struct vb2_ops cx23885_vbi_qops;
+extern const struct vb2_ops cx23885_vbi_qops;
 extern int cx23885_vbi_irq(struct cx23885_dev *dev, u32 status);
 
 /* cx23885-i2c.c                                                */
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index bcad9b2..07a397b 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -165,7 +165,7 @@ static int buffer_init(struct vb2_buffer *vb2)
 	return 0;
 }
 
-struct vb2_ops saa7134_vbi_qops = {
+const struct vb2_ops saa7134_vbi_qops = {
 	.queue_setup	= queue_setup,
 	.buf_init	= buffer_init,
 	.buf_prepare	= buffer_prepare,
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 816b528..545f7ad 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -870,7 +870,7 @@ int saa7134_ts_queue_setup(struct vb2_queue *q,
 /* ----------------------------------------------------------- */
 /* saa7134-vbi.c                                               */
 
-extern struct vb2_ops saa7134_vbi_qops;
+extern const struct vb2_ops saa7134_vbi_qops;
 extern struct video_device saa7134_vbi_template;
 
 int saa7134_vbi_init1(struct saa7134_dev *dev);
-- 
1.9.1
