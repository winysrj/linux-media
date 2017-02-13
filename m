Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60223 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752981AbdBMMEH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 07:04:07 -0500
Subject: Re: [RFCv4 PATCH 1/1] hdpvr: fix interrupted recording
To: Jonathan Sims <jonathan.625266@earthlink.net>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        kpyle@austin.rr.com, ryleyjangus@gmail.com
References: <20170209195439.4e9f89d1@earthlink.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7de9ca91-de80-aa5d-c080-83a6b639aea3@xs4all.nl>
Date: Mon, 13 Feb 2017 13:03:57 +0100
MIME-Version: 1.0
In-Reply-To: <20170209195439.4e9f89d1@earthlink.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

It appears the v3 was merged and not this v4.

It would be nice if you can make a new diff on top of the latest media_tree master code
that does this code cleanup, because this v4 is much nicer with regard to error handling.

Regards,

	Hans

On 02/10/2017 01:54 AM, Jonathan Sims wrote:
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
> Changes in v4:
> - Code cleanups.
> 
>  drivers/media/usb/hdpvr/hdpvr-video.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 474c11e1d495..f8ba28cb40eb 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -458,9 +458,20 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
>  				goto err;
>  			}
>  
> -			if (wait_event_interruptible(dev->wait_data,
> -					      buf->status == BUFSTAT_READY))
> -				return -ERESTARTSYS;
> +			ret = wait_event_interruptible_timeout(dev->wait_data,
> +				buf->status == BUFSTAT_READY,
> +				msecs_to_jiffies(1000));
> +			if (ret < 0)
> +				goto err;
> +			if (!ret) {
> +				v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
> +					"timeout: restart streaming\n");
> +				hdpvr_stop_streaming(dev);
> +				msleep(4000);
> +				ret = hdpvr_start_streaming(dev);
> +				if (ret)
> +					goto err;
> +			}
>  		}
>  
>  		if (buf->status != BUFSTAT_READY)
> 
