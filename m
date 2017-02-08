Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43289
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932087AbdBHLxe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 06:53:34 -0500
Date: Wed, 8 Feb 2017 09:42:43 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Sims <jonathan.625266@earthlink.net>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, kpyle@austin.rr.com, ryleyjangus@gmail.com
Subject: Re: [RFCv3 PATCH 1/1] hdpvr: fix interrupted recording
Message-ID: <20170208094243.1df4a0f0@vento.lan>
In-Reply-To: <20170126071722.0f2683cd@earthlink.net>
References: <20170126071722.0f2683cd@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 26 Jan 2017 07:17:22 -0500
Jonathan Sims <jonathan.625266@earthlink.net> escreveu:

> This is a reworking of a patch originally submitted by Ryley Angus, modified by Hans Verkuil and then seemingly forgotten before changes suggested by Keith Pyle here:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg75163.html
> 
> were made and tested.
> 
> I have implemented the suggested changes and have been testing for several months. I am no longer experiencing lockups while recording (with blue light on, requiring power cycling) which had been a long standing problem with the HD-PVR. I have not noticed any other problems since applying the patch.
> 
> Signed-off-by: Jonathan Sims <jonathan.625266@earthlink.net>
> ---
> 
> Changes in v3:
> - Actually sleep for 4 seconds after the hdpvr_stop_streaming call.
> 
>  drivers/media/usb/hdpvr/hdpvr-video.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 2a3a8b4..dec8496 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -454,6 +454,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
>  
>  		if (buf->status != BUFSTAT_READY &&
>  		    dev->status != STATUS_DISCONNECTED) {
> +			int err;

Are there any reason why not using "ret" var, instead of creating
another return variable here?

>  			/* return nonblocking */
>  			if (file->f_flags & O_NONBLOCK) {
>  				if (!ret)
> @@ -461,9 +462,27 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
>  				goto err;
>  			}
>  
> -			if (wait_event_interruptible(dev->wait_data,
> -					      buf->status == BUFSTAT_READY))
> -				return -ERESTARTSYS;
> +			err = wait_event_interruptible_timeout(dev->wait_data,
> +				buf->status == BUFSTAT_READY,
> +				msecs_to_jiffies(1000));
> +			if (err < 0) {
> +				ret = err;
> +				goto err;
> +			}
> +			if (!err) {
> +				int delay;
> +
> +				v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
> +					"timeout: restart streaming\n");
> +				hdpvr_stop_streaming(dev);
> +				delay = msecs_to_jiffies(4000);
> +				schedule_timeout(delay);

Why don't you just call:
	msleep(4000);

> +				err = hdpvr_start_streaming(dev);
> +				if (err) {
> +					ret = err;
> +					goto err;
> +				}
> +			}
>  		}
>  
>  		if (buf->status != BUFSTAT_READY)



Thanks,
Mauro
