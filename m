Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41893 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IYV6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 17:58:04 -0400
Received: by bkcjk13 with SMTP id jk13so1534346bkc.19
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 14:58:03 -0700 (PDT)
Message-ID: <506228E8.1040704@gmail.com>
Date: Tue, 25 Sep 2012 23:58:00 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	mchehab@infradead.org, patches@linaro.org
Subject: Re: [PATCH] [media] s5k6aa: Fix possible NULL pointer dereference
References: <1348298907-20791-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1348298907-20791-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 09/22/2012 09:28 AM, Sachin Kamat wrote:
> It is previously assumed that 'rect' could be NULL.
> Hence add a check to print the members of 'rect' only when it is not
> NULL.
> 
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/i2c/s5k6aa.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
> index 045ca7f..7531edb 100644
> --- a/drivers/media/i2c/s5k6aa.c
> +++ b/drivers/media/i2c/s5k6aa.c
> @@ -1177,8 +1177,9 @@ static int s5k6aa_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> 
>   	mutex_unlock(&s5k6aa->lock);
> 
> -	v4l2_dbg(1, debug, sd, "Current crop rectangle: (%d,%d)/%dx%d\n",
> -		 rect->left, rect->top, rect->width, rect->height);
> +	if (rect)
> +		v4l2_dbg(1, debug, sd, "Current crop rectangle: (%d,%d)/%dx%d\n",
> +			 rect->left, rect->top, rect->width, rect->height);
> 
>   	return 0;
>   }

Thank you for the patch. I would attack this problem form slightly 
different angle though, i.e. I would make sure __s5k6aa_get_crop_rect() 
always returns valid pointer. There is similar issue in s5k6aa_set_crop(). 
Since crop->which is already validated in 
drivers/media/v4l2-core/v4l2-subdev.c and can have only values: 
V4L2_SUBDEV_FORMAT_TRY, V4L2_SUBDEV_FORMAT_ACTIVE it's safe to do 
something like:

8<-------------------------------------------------------------------------
>From 724aa5f1fefcaca2dee4f75ba960a1f620400e1a Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Date: Tue, 25 Sep 2012 23:53:27 +0200
Subject: [PATCH] s5k6aa: Fix potential null pointer dereference

Make sure __s5k6aa_get_crop_rect() always returns valid pointer,
as it is assumed at the callers.

crop->which is already validated when subdev set_crop and get_crop
callbacks are called from within the v4l2-core. If it ever happens
the crop operations are called directly for some reason in kernel
space, with incorrect crop->which argument, just log it with WARN
and return reference to the TRY crop.

Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/i2c/s5k6aa.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 045ca7f..57cd4fa 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1061,10 +1061,9 @@ __s5k6aa_get_crop_rect(struct s5k6aa *s5k6aa, struct v4l2_subdev_fh *fh,
 {
 	if (which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		return &s5k6aa->ccd_rect;
-	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_crop(fh, 0);
 
-	return NULL;
+	WARN_ON(which != V4L2_SUBDEV_FORMAT_TRY);
+	return v4l2_subdev_get_try_crop(fh, 0);
 }
 
 static void s5k6aa_try_format(struct s5k6aa *s5k6aa,
@@ -1169,12 +1168,10 @@ static int s5k6aa_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	struct v4l2_rect *rect;
 
 	memset(crop->reserved, 0, sizeof(crop->reserved));
-	mutex_lock(&s5k6aa->lock);
 
+	mutex_lock(&s5k6aa->lock);
 	rect = __s5k6aa_get_crop_rect(s5k6aa, fh, crop->which);
-	if (rect)
-		crop->rect = *rect;
-
+	crop->rect = *rect;
 	mutex_unlock(&s5k6aa->lock);
 
 	v4l2_dbg(1, debug, sd, "Current crop rectangle: (%d,%d)/%dx%d\n",
-- 
1.7.4.1
8<-------------------------------------------------------------------------

I'm going to queue this patch for 3.7.

--

Thanks,
Sylwester
