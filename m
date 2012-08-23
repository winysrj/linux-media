Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36090 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2HWNIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 09:08:40 -0400
Received: by yhmm54 with SMTP id m54so166064yhm.19
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2012 06:08:39 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 01/10] stk1160: Remove unneeded struct vb2_queue clearing
Date: Thu, 23 Aug 2012 10:08:22 -0300
Message-Id: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct vb2_queue is allocated through kzalloc as part of a larger struct,
there's no need to clear it.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-v4l.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index cc5a95f..fe6e857 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -676,7 +676,6 @@ int stk1160_vb2_setup(struct stk1160 *dev)
 	struct vb2_queue *q;
 
 	q = &dev->vb_vidq;
-	memset(q, 0, sizeof(dev->vb_vidq));
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
 	q->drv_priv = dev;
-- 
1.7.8.6

