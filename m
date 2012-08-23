Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55121 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2HWNIx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 09:08:53 -0400
Received: by ghrr11 with SMTP id r11so169562ghr.19
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2012 06:08:53 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 03/10] vivi: Remove unneeded struct vb2_queue clearing
Date: Thu, 23 Aug 2012 10:08:24 -0300
Message-Id: <1345727311-27478-3-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
References: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct vb2_queue is allocated through kzalloc as part of a larger struct,
there's no need to clear it.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/vivi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index a6351c4..fca8019 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -1306,7 +1306,6 @@ static int __init vivi_create_instance(int inst)
 
 	/* initialize queue */
 	q = &dev->vb_vidq;
-	memset(q, 0, sizeof(dev->vb_vidq));
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 	q->drv_priv = dev;
-- 
1.7.8.6

