Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab3AFCgW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jan 2013 21:36:22 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r062aMGO004325
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 5 Jan 2013 21:36:22 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] em28xx: enable DMABUF
Date: Sun,  6 Jan 2013 00:35:50 -0200
Message-Id: <1357439750-7759-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that it uses videobuf2, em28xx can support DMABUF.

Tested with an HVR-950 on analog mode and a 2gen i5core machine
with an i915 graphics adapter.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 75027e3..2eabf2a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -699,7 +699,7 @@ int em28xx_vb2_setup(struct em28xx *dev)
 	/* Setup Videobuf2 for Video capture */
 	q = &dev->vb_vidq;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
+	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	q->drv_priv = dev;
 	q->buf_struct_size = sizeof(struct em28xx_buffer);
 	q->ops = &em28xx_video_qops;
-- 
1.7.11.7

