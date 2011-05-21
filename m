Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab1EUKqp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 06:46:45 -0400
Message-ID: <4DD79810.7090300@redhat.com>
Date: Sat, 21 May 2011 07:46:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH v2] tm6000: fix uninitialized field, change prink to dprintk
References: <1305957938-5830-1-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1305957938-5830-1-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-05-2011 03:05, stefan.ringel@arcor.de escreveu:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> fix uninitialized field, change prink to dprintk

Applied, thanks.

A quick note: please don't repeat the patch subject at the
first line of the body. It requires me to manually drop it
when importing the patch. Instead, put an useful description
about why and how are you doing such change.

Thanks,
Mauro.
> 
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-usb-isoc.h |    2 +-
>  drivers/staging/tm6000/tm6000-video.c    |    5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
> index a9e61d9..084c2a8 100644
> --- a/drivers/staging/tm6000/tm6000-usb-isoc.h
> +++ b/drivers/staging/tm6000/tm6000-usb-isoc.h
> @@ -39,7 +39,7 @@ struct usb_isoc_ctl {
>  	int				pos, size, pktsize;
>  
>  		/* Last field: ODD or EVEN? */
> -	int				vfield;
> +	int				vfield, field;
>  
>  		/* Stores incomplete commands */
>  	u32				tmp_buf;
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index 4802396..4264064 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -334,6 +334,7 @@ static int copy_streams(u8 *data, unsigned long len,
>  			size = dev->isoc_ctl.size;
>  			pos = dev->isoc_ctl.pos;
>  			pktsize = dev->isoc_ctl.pktsize;
> +			field = dev->isoc_ctl.field;
>  		}
>  		cpysize = (endp - ptr > size) ? size : endp - ptr;
>  		if (cpysize) {
> @@ -359,7 +360,8 @@ static int copy_streams(u8 *data, unsigned long len,
>  				/* Need some code to copy pts */
>  				u32 pts;
>  				pts = *(u32 *)ptr;
> -				printk(KERN_INFO "%s: field %d, PTS %x", dev->name, field, pts);
> +				dprintk(dev, V4L2_DEBUG_ISOC, "field %d, PTS %x",
> +					field, pts);
>  				break;
>  			}
>  			}
> @@ -371,6 +373,7 @@ static int copy_streams(u8 *data, unsigned long len,
>  			dev->isoc_ctl.pos = pos + cpysize;
>  			dev->isoc_ctl.size = size - cpysize;
>  			dev->isoc_ctl.cmd = cmd;
> +			dev->isoc_ctl.field = field;
>  			dev->isoc_ctl.pktsize = pktsize - (endp - ptr);
>  			ptr += endp - ptr;
>  		} else {

