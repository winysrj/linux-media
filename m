Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43642 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752562AbcL2MBp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Dec 2016 07:01:45 -0500
Date: Thu, 29 Dec 2016 14:01:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Augusto Mecking Caringi <augustocaringi@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] smiapp: Fix build warnings when !CONFIG_PM_SLEEP
Message-ID: <20161229120137.GB3958@valkosipuli.retiisi.org.uk>
References: <1483011924-10787-1-git-send-email-augustocaringi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1483011924-10787-1-git-send-email-augustocaringi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Augusto,

On Thu, Dec 29, 2016 at 11:45:07AM +0000, Augusto Mecking Caringi wrote:
> Fix the following build warnings when CONFIG_PM is set but
> CONFIG_PM_SLEEP is not:
> 
> drivers/media/i2c/smiapp/smiapp-core.c:2746:12: warning:
> ‘smiapp_suspend’ defined but not used [-Wunused-function]
> static int smiapp_suspend(struct device *dev)
>             ^
> drivers/media/i2c/smiapp/smiapp-core.c:2771:12: warning: ‘smiapp_resume’
> defined but not used [-Wunused-function]
> static int smiapp_resume(struct device *dev)
>             ^
> 
> Signed-off-by: Augusto Mecking Caringi <augustocaringi@gmail.com>

Thanks for the patch.

I believe this is already fixed by the following patch:

commit 4bfb934b0067b7f6a24470682c5f7254fd4d8282
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Sat Nov 19 19:50:10 2016 -0200

    [media] smiapp: Make suspend and resume functions __maybe_unused
    
    The smiapp_suspend() and smiapp_resume() functions will end up being unused
    if CONFIG_PM is enabled but CONFIG_PM_SLEEP is disabled, causing a
    compiler warning from both of the function definitions. Fix this by
    marking the functions with __maybe_unused.
    
    Suggested-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 620f8ce..f4e92bd 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2741,7 +2741,7 @@ static const struct v4l2_subdev_internal_ops smiapp_internal_ops = {
  * I2C Driver
  */
 
-static int smiapp_suspend(struct device *dev)
+static int __maybe_unused smiapp_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
@@ -2766,7 +2766,7 @@ static int smiapp_suspend(struct device *dev)
 	return 0;
 }
 
-static int smiapp_resume(struct device *dev)
+static int __maybe_unused smiapp_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
