Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:38208 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3FVMDT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 08:03:19 -0400
From: Emil Goode <emilgoode@gmail.com>
To: mchehab@redhat.com, hans.verkuil@cisco.com,
	linux@rainbow-software.org, prabhakar.csengg@gmail.com,
	crope@iki.fi
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] [media] saa7134: Fix sparse warnings by adding __user annotation
Date: Sat, 22 Jun 2013 14:02:52 +0200
Message-Id: <1371902572-7925-1-git-send-email-emilgoode@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding a __user annotation fixes the following sparse warnings.

drivers/media/pci/saa7134/saa7134-video.c:1578:45: warning:
        incorrect type in initializer (different address spaces)
        drivers/media/pci/saa7134/saa7134-video.c:1578:45:
        expected struct v4l2_clip *clips
        drivers/media/pci/saa7134/saa7134-video.c:1578:45:
        got struct v4l2_clip [noderef] <asn:1>*clips

drivers/media/pci/saa7134/saa7134-video.c:1589:26: warning:
        incorrect type in assignment (different address spaces)
        drivers/media/pci/saa7134/saa7134-video.c:1589:26:
        expected struct v4l2_clip [noderef] <asn:1>*clips
        drivers/media/pci/saa7134/saa7134-video.c:1589:26:
        got struct v4l2_clip *clips

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/media/pci/saa7134/saa7134-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index e3457ae..e12bbd8 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1575,7 +1575,7 @@ static int saa7134_g_fmt_vid_overlay(struct file *file, void *priv,
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
-	struct v4l2_clip *clips = f->fmt.win.clips;
+	struct v4l2_clip __user *clips = f->fmt.win.clips;
 	u32 clipcount = f->fmt.win.clipcount;
 	int err = 0;
 	int i;
-- 
1.7.10.4

