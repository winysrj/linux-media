Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab1ETXQG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 19:16:06 -0400
Message-ID: <4DD6F62E.7000704@redhat.com>
Date: Fri, 20 May 2011 20:15:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 14/16] tm6000: add pts logging
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de> <1304970844-20955-14-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-14-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-05-2011 16:54, stefan.ringel@arcor.de escreveu:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> add pts logging
> 
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-video.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index 2d83204..4802396 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -355,10 +355,14 @@ static int copy_streams(u8 *data, unsigned long len,
>  			case TM6000_URB_MSG_VBI:
>  				/* Need some code to copy vbi buffer */
>  				break;
> -			case TM6000_URB_MSG_PTS:
> +			case TM6000_URB_MSG_PTS: {
>  				/* Need some code to copy pts */
> +				u32 pts;
> +				pts = *(u32 *)ptr;
> +				printk(KERN_INFO "%s: field %d, PTS %x", dev->name, field, pts);

Hmm... field may be unititialized... Please fix.

drivers/staging/tm6000/tm6000-video.c: In function ‘copy_streams’:
drivers/staging/tm6000/tm6000-video.c:231: warning: ‘field’ may be used uninitialized in this function

Also, it is not a good idea of just logging it. Instead, use enable logging only if debug is enabled
seems more appropriate.

Please send a patch fixing it.

Thanks,
Mauro.

>  				break;
>  			}
> +			}
>  		}
>  		if (ptr + pktsize > endp) {
>  			/* End of URB packet, but cmd processing is not

