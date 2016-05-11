Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47131 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbcEKQWz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 12:22:55 -0400
Subject: Re: [PATCH] [media] v4l2-async: Always unregister the subdev on
 failure
To: Alban Bedel <alban.bedel@avionic-design.de>,
	linux-media@vger.kernel.org
References: <1462981201-14768-1-git-send-email-alban.bedel@avionic-design.de>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <429cc087-85e3-7bfa-b0b6-ab9434e5d47c@osg.samsung.com>
Date: Wed, 11 May 2016 12:22:44 -0400
MIME-Version: 1.0
In-Reply-To: <1462981201-14768-1-git-send-email-alban.bedel@avionic-design.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Alban,

On 05/11/2016 11:40 AM, Alban Bedel wrote:
> In v4l2_async_test_notify() if the registered_async callback or the
> complete notifier returns an error the subdev is not unregistered.
> This leave paths where v4l2_async_register_subdev() can fail but
> leave the subdev still registered.
> 
> Add the required calls to v4l2_device_unregister_subdev() to plug
> these holes.
> 
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index ceb28d4..43393f8 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -121,13 +121,19 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>  
>  	ret = v4l2_subdev_call(sd, core, registered_async);
>  	if (ret < 0 && ret != -ENOIOCTLCMD) {
> +		v4l2_device_unregister_subdev(sd);
>  		if (notifier->unbind)
>  			notifier->unbind(notifier, sd, asd);
>  		return ret;
>  	}
>  
> -	if (list_empty(&notifier->waiting) && notifier->complete)
> -		return notifier->complete(notifier);
> +	if (list_empty(&notifier->waiting) && notifier->complete) {
> +		ret = notifier->complete(notifier);
> +		if (ret < 0) {
> +			v4l2_device_unregister_subdev(sd);

Isn't a call to notifier->unbind() missing here as well?

Also, I think the error path is becoming too duplicated and complex, so
maybe we can have a single error path and use goto labels as is common
in Linux? For example something like the following (not tested) can be
squashed on top of your change:

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 43393f8c1312..abe512d0b4cb 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -113,29 +113,28 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 	list_move(&sd->async_list, &notifier->done);
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
-	if (ret < 0) {
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, asd);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_subdev_register;
 
 	ret = v4l2_subdev_call(sd, core, registered_async);
-	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		v4l2_device_unregister_subdev(sd);
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, asd);
-		return ret;
-	}
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto err_subdev_call;
 
 	if (list_empty(&notifier->waiting) && notifier->complete) {
 		ret = notifier->complete(notifier);
-		if (ret < 0) {
-			v4l2_device_unregister_subdev(sd);
-			return ret;
-		}
+		if (ret < 0)
+			goto err_subdev_call;
 	}
 
 	return 0;
+
+err_subdev_call:
+	v4l2_device_unregister_subdev(sd);
+err_subdev_register:
+	if (notifier->unbind)
+		notifier->unbind(notifier, sd, asd);
+
+	return ret;
 }
 
 static void v4l2_async_cleanup(struct v4l2_subdev *sd)

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
