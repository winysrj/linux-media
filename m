Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1400 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab3E1G7U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 02:59:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] hdpvr: Simplify the logic that checks for error
Date: Tue, 28 May 2013 08:58:48 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	leo@lumanate.com
References: <1369656269-11444-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1369656269-11444-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305280858.48478.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 27 2013 14:04:29 Mauro Carvalho Chehab wrote:
> At get_video_info, there's a somewhat complex logic that checks
> for error.
> 
> That logic can be highly simplified, as usb_control_msg will
> only return a negative value, or the buffer length, as it does
> the transfers via DMA.
> 
> While here, document why this particular driver is returning -EFAULT,
> instead of the USB error code.

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

The EFAULT comment is wrong. The way it is done today is that the error
return of this function is never passed on to userspace.

It's getting messy, so I think it is best if I make two patches based on this
patch and on Leo's fourth patch and post those. If everyone agrees on my solution,
then they can be merged.

Sorry Leo, I wasn't aware when we discussed the usb_control_msg return values
before that usb_control_msg() will either return an error or the buffer length,
and nothing else.

Your fourth patch introduced some bugs which I hadn't realized until yesterday.
Which is why it wasn't merged. The main problem with your fourth patch was that
it passed on the get_video_info error code to userspace, but that error code was
for internal use only, and -EFAULT is an inappropriate error code to pass on.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/usb/hdpvr/hdpvr-control.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
> index d1a3d84..a015a24 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-control.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-control.c
> @@ -56,12 +56,6 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
>  			      0x1400, 0x0003,
>  			      dev->usbc_buf, 5,
>  			      1000);
> -	if (ret == 5) {
> -		vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
> -		vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
> -		vidinf->fps	= dev->usbc_buf[4];
> -	}
> -
>  #ifdef HDPVR_DEBUG
>  	if (hdpvr_debug & MSG_INFO) {
>  		char print_buf[15];
> @@ -73,11 +67,20 @@ int get_video_info(struct hdpvr_device *dev, struct hdpvr_video_info *vidinf)
>  #endif
>  	mutex_unlock(&dev->usbc_mutex);
>  
> -	if (ret > 0 && ret != 5) { /* fail if unexpected byte count returned */
> -		ret = -EFAULT;
> -	}
> +	/*
> +	 * Returning EFAULT is wrong. Unfortunately, MythTV hdpvr
> +	 * handling code was written to expect this specific error,
> +	 * instead of accepting any error code. So, we can't fix it
> +	 * in Kernel without breaking userspace.
> +	 */
> +	if (ret < 0)
> +		return -EFAULT;
>  
> -	return ret < 0 ? ret : 0;
> +	vidinf->width	= dev->usbc_buf[1] << 8 | dev->usbc_buf[0];
> +	vidinf->height	= dev->usbc_buf[3] << 8 | dev->usbc_buf[2];
> +	vidinf->fps	= dev->usbc_buf[4];
> +
> +	return 0;
>  }
>  
>  int get_input_lines_info(struct hdpvr_device *dev)
> 
