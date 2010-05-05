Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60929 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab0EEGBi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 02:01:38 -0400
Received: by fxm10 with SMTP id 10so3901101fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 23:01:37 -0700 (PDT)
Date: Wed, 5 May 2010 08:01:30 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch -next 1/2] media/s2255drv: return if vdev not found
Message-ID: <20100505060130.GG27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original code didn't handle the case where vdev was not found so I
added a check for that.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index ac9c40c..1f9a49e 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -1716,11 +1716,15 @@ static int s2255_open(struct file *file)
 	dprintk(1, "s2255: open called (dev=%s)\n",
 		video_device_node_name(vdev));
 
-	for (i = 0; i < MAX_CHANNELS; i++)
+	for (i = 0; i < MAX_CHANNELS; i++) {
 		if (&dev->vdev[i] == vdev) {
 			cur_channel = i;
 			break;
 		}
+	}
+	if (i == MAX_CHANNELS)
+		return -ENODEV;
+
 	/*
 	 * open lock necessary to prevent multiple instances
 	 * of v4l-conf (or other programs) from simultaneously
