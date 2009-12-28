Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53972 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZL1RAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2009 12:00:01 -0500
Received: by fxm25 with SMTP id 25so4696309fxm.21
        for <linux-media@vger.kernel.org>; Mon, 28 Dec 2009 09:00:00 -0800 (PST)
Date: Mon, 28 Dec 2009 18:59:46 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch] cx25821: fix double unlock in medusa_video_init()
Message-ID: <20091228165946.GD17645@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

medusa_set_videostandard() takes the lock but it always drops it before
returning.

This was found with a static checker and compile tested only.  :/

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/staging/cx25821/cx25821-medusa-video.c	2009-12-28 09:13:01.000000000 +0200
+++ devel/drivers/staging/cx25821/cx25821-medusa-video.c	2009-12-28 09:13:55.000000000 +0200
@@ -860,10 +860,8 @@ int medusa_video_init(struct cx25821_dev
 
 	ret_val = medusa_set_videostandard(dev);
 
-	if (ret_val < 0) {
-		mutex_unlock(&dev->lock);
+	if (ret_val < 0)
 		return -EINVAL;
-	}
 
 	return 1;
 }
