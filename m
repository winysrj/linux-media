Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39527 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab0EETbh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 15:31:37 -0400
Received: by fxm10 with SMTP id 10so4561153fxm.19
        for <linux-media@vger.kernel.org>; Wed, 05 May 2010 12:31:36 -0700 (PDT)
Date: Wed, 5 May 2010 21:31:28 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-media@vger.kernel.org
Subject: Re: -next: staging/cx25821: please revert 7a02f549fcc
Message-ID: <20100505193128.GI27064@bicker>
References: <20100505072738.GH27064@bicker> <4BE18EF9.9010502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE18EF9.9010502@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 05, 2010 at 12:30:01PM -0300, Mauro Carvalho Chehab wrote:
> This simplifies the code a little bit, and, instead of just return -EINVAL,
> it will return the error condition reported by the called functions.
> 

Thanks for that.

There was one return that got missed.  Probably you can fold it into
your patch?

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index 7545314..34616dc 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -849,10 +849,8 @@ int medusa_video_init(struct cx25821_dev *dev)
 
 	value |= 7;
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], PIN_OE_CTRL, value);
-	if (ret_val < 0) {
-		mutex_unlock(&dev->lock);
-		return -EINVAL;
-	}
+	if (ret_val < 0)
+		goto error;
 
 	mutex_unlock(&dev->lock);
 
