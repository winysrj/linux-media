Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52120 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0EEGBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 02:01:03 -0400
Received: by fxm10 with SMTP id 10so3900873fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 23:01:02 -0700 (PDT)
Date: Wed, 5 May 2010 08:00:47 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch -next 2/2] media/s2255drv: remove dead code
Message-ID: <20100505060047.GF27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My concern initially was we dereference "dev" in the parameter list to
s2255_dev_err() but it turns out that code path is never used.  
The s2255_stop_readpipe() is only called from one place and "dev" is 
never null.  So this patch just removes the whole condition here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index ac9c40c..3c7a79f 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -2524,10 +2528,7 @@ static int s2255_stop_acquire(struct s2255_dev *dev, unsigned long chn)
 static void s2255_stop_readpipe(struct s2255_dev *dev)
 {
 	struct s2255_pipeinfo *pipe = &dev->pipe;
-	if (dev == NULL) {
-		s2255_dev_err(&dev->udev->dev, "invalid device\n");
-		return;
-	}
+
 	pipe->state = 0;
 	if (pipe->stream_urb) {
 		/* cancel urb */
