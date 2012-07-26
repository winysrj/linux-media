Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:33121 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2GZMGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 08:06:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH for v3.6] v4l2-dev.c: Move video_put() after debug printk
Date: Thu, 26 Jul 2012 14:06:26 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1343303944-2652-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1343303944-2652-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207261406.26725.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 26 July 2012 13:59:04 Ezequiel Garcia wrote:
> It is possible that video_put() releases video_device struct,
> provoking a panic when debug printk wants to get video_device node name.
> 
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Good catch!

Regards,

	Hans

> ---
>  drivers/media/video/v4l2-dev.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index af70f93..3210fd5 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -478,12 +478,12 @@ static int v4l2_open(struct inode *inode, struct file *filp)
>  	}
>  
>  err:
> -	/* decrease the refcount in case of an error */
> -	if (ret)
> -		video_put(vdev);
>  	if (vdev->debug)
>  		printk(KERN_DEBUG "%s: open (%d)\n",
>  			video_device_node_name(vdev), ret);
> +	/* decrease the refcount in case of an error */
> +	if (ret)
> +		video_put(vdev);
>  	return ret;
>  }
>  
> @@ -500,12 +500,12 @@ static int v4l2_release(struct inode *inode, struct file *filp)
>  		if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
>  			mutex_unlock(vdev->lock);
>  	}
> -	/* decrease the refcount unconditionally since the release()
> -	   return value is ignored. */
> -	video_put(vdev);
>  	if (vdev->debug)
>  		printk(KERN_DEBUG "%s: release\n",
>  			video_device_node_name(vdev));
> +	/* decrease the refcount unconditionally since the release()
> +	   return value is ignored. */
> +	video_put(vdev);
>  	return ret;
>  }
>  
> 
