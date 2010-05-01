Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36942 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0EAIvM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 May 2010 04:51:12 -0400
Received: by gwj19 with SMTP id 19so488207gwj.19
        for <linux-media@vger.kernel.org>; Sat, 01 May 2010 01:51:11 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 1 May 2010 16:51:11 +0800
Message-ID: <u2s6e8e83e21005010151ie123c8e5o45e7d0a3bbc8aa64@mail.gmail.com>
Subject: [PATCH] tm6000: Prevent Kernel Oops changing channel when stream is
	still on.
From: Bee Hock Goh <beehock@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

do a streamoff before setting standard to prevent kernel oops by
irq_callback if changing of channel is done while streaming is still
on-going.


Signed-off-by: Bee Hock Goh <beehock@gmail.com>

diff --git a/drivers/staging/tm6000/tm6000-video.c
b/drivers/staging/tm6000/tm6000-video.c
index c53de47..32f625d 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c

@@ -1081,8 +1086,8 @@ static int vidioc_s_std (struct file *file, void
*priv, v4l2_std_id *norm)
 	struct tm6000_fh   *fh=priv;
 	struct tm6000_core *dev = fh->dev;

+	vidioc_streamoff(file, priv, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	rc=tm6000_set_standard (dev, norm);
-
 	fh->width  = dev->width;
 	fh->height = dev->height;
