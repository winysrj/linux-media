Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:54775 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZG3XrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 19:47:17 -0400
Date: Thu, 30 Jul 2009 16:39:00 -0400
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH repost2 1/2] V4L: hdpvr, fix lock imbalances
Message-ID: <20090730163900.1a643c3a@gmail.com>
In-Reply-To: <1248990589-25005-1-git-send-email-jirislaby@gmail.com>
References: <1248990589-25005-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jiri,

On Thu, 30 Jul 2009 23:49:48 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hrm, nobody picked these up, twice. Maybe this time :)?
> --

Thanks for this email. Both patches are applied to devel tree.

Cheers,
Douglas
 
> There are many lock imbalances in this driver. Fix all found.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/media/video/hdpvr/hdpvr-core.c  |   12 ++++++------
>  drivers/media/video/hdpvr/hdpvr-video.c |    6 ++++--
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/hdpvr/hdpvr-core.c
> b/drivers/media/video/hdpvr/hdpvr-core.c index 188bd5a..1c9bc94 100644
> --- a/drivers/media/video/hdpvr/hdpvr-core.c
> +++ b/drivers/media/video/hdpvr/hdpvr-core.c
> @@ -126,7 +126,7 @@ static int device_authorization(struct
> hdpvr_device *dev) char *print_buf = kzalloc(5*buf_size+1,
> GFP_KERNEL); if (!print_buf) {
>  		v4l2_err(&dev->v4l2_dev, "Out of memory\n");
> -		goto error;
> +		return retval;
>  	}
>  #endif
>  
> @@ -140,7 +140,7 @@ static int device_authorization(struct
> hdpvr_device *dev) if (ret != 46) {
>  		v4l2_err(&dev->v4l2_dev,
>  			 "unexpected answer of status request, len
> %d\n", ret);
> -		goto error;
> +		goto unlock;
>  	}
>  #ifdef HDPVR_DEBUG
>  	else {
> @@ -163,7 +163,7 @@ static int device_authorization(struct
> hdpvr_device *dev) v4l2_err(&dev->v4l2_dev, "unknown firmware version
> 0x%x\n", dev->usbc_buf[1]);
>  		ret = -EINVAL;
> -		goto error;
> +		goto unlock;
>  	}
>  
>  	response = dev->usbc_buf+38;
> @@ -188,10 +188,10 @@ static int device_authorization(struct
> hdpvr_device *dev) 10000);
>  	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
>  		 "magic request returned %d\n", ret);
> -	mutex_unlock(&dev->usbc_mutex);
>  
>  	retval = ret != 8;
> -error:
> +unlock:
> +	mutex_unlock(&dev->usbc_mutex);
>  	return retval;
>  }
>  
> @@ -350,6 +350,7 @@ static int hdpvr_probe(struct usb_interface
> *interface, 
>  	mutex_lock(&dev->io_mutex);
>  	if (hdpvr_alloc_buffers(dev, NUM_BUFFERS)) {
> +		mutex_unlock(&dev->io_mutex);
>  		v4l2_err(&dev->v4l2_dev,
>  			 "allocating transfer buffers failed\n");
>  		goto error;
> @@ -381,7 +382,6 @@ static int hdpvr_probe(struct usb_interface
> *interface, 
>  error:
>  	if (dev) {
> -		mutex_unlock(&dev->io_mutex);
>  		/* this frees allocated memory */
>  		hdpvr_delete(dev);
>  	}
> diff --git a/drivers/media/video/hdpvr/hdpvr-video.c
> b/drivers/media/video/hdpvr/hdpvr-video.c index ccd47f5..5937de2
> 100644 --- a/drivers/media/video/hdpvr/hdpvr-video.c
> +++ b/drivers/media/video/hdpvr/hdpvr-video.c
> @@ -375,6 +375,7 @@ static int hdpvr_open(struct file *file)
>  	 * in resumption */
>  	mutex_lock(&dev->io_mutex);
>  	dev->open_count++;
> +	mutex_unlock(&dev->io_mutex);
>  
>  	fh->dev = dev;
>  
> @@ -383,7 +384,6 @@ static int hdpvr_open(struct file *file)
>  
>  	retval = 0;
>  err:
> -	mutex_unlock(&dev->io_mutex);
>  	return retval;
>  }
>  
> @@ -519,8 +519,10 @@ static unsigned int hdpvr_poll(struct file
> *filp, poll_table *wait) 
>  	mutex_lock(&dev->io_mutex);
>  
> -	if (video_is_unregistered(dev->video_dev))
> +	if (video_is_unregistered(dev->video_dev)) {
> +		mutex_unlock(&dev->io_mutex);
>  		return -EIO;
> +	}
>  
>  	if (dev->status == STATUS_IDLE) {
>  		if (hdpvr_start_streaming(dev)) {

