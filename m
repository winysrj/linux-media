Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43073 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbcDVNaR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 09:30:17 -0400
Date: Fri, 22 Apr 2016 10:30:11 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: <laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: fix media_open() to not release lock too soon
Message-ID: <20160422103011.7c84c59c@recife.lan>
In-Reply-To: <1461185290-6540-1-git-send-email-shuahkh@osg.samsung.com>
References: <1461185290-6540-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Apr 2016 14:48:10 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> media_open() releases media_devnode_lock before open is complete. Hold
> the lock to call mdev->fops->open and release at the end.

This patch looks scary on my eyes, as it has potential of causing
dead locks, if the code, depending on the code implemented at the
mdev->fops->open callback.

I suspect that the main reason for it to be like that is to call
mdev->fops-open() without any locks.

Right now, media_device_fops has an open that does nothing, but I'm not
sure if some driver change it to something else. On such case, we could
be taking media_devnode lock first, and then media_device on such open
callback, but, on other parts of the code, the code could be taking
media_device lock first, and than this one.

Did you check if such bad locks are not present in the code after
your changes at the platform drivers?

Regards,
Mauro

>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/media-devnode.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index 29409f4..0934789 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -155,7 +155,7 @@ static long media_compat_ioctl(struct file *filp, unsigned int cmd,
>  static int media_open(struct inode *inode, struct file *filp)
>  {
>  	struct media_devnode *mdev;
> -	int ret;
> +	int ret = 0;
>  
>  	/* Check if the media device is available. This needs to be done with
>  	 * the media_devnode_lock held to prevent an open/unregister race:
> @@ -173,7 +173,6 @@ static int media_open(struct inode *inode, struct file *filp)
>  	}
>  	/* and increase the device refcount */
>  	get_device(&mdev->dev);
> -	mutex_unlock(&media_devnode_lock);
>  
>  	filp->private_data = mdev;
>  
> @@ -182,11 +181,12 @@ static int media_open(struct inode *inode, struct file *filp)
>  		if (ret) {
>  			put_device(&mdev->dev);
>  			filp->private_data = NULL;
> -			return ret;
> +			goto done;
>  		}
>  	}
> -
> -	return 0;
> +done:
> +	mutex_unlock(&media_devnode_lock);
> +	return ret;
>  }
>  
>  /* Override for the release function */


-- 
Thanks,
Mauro
