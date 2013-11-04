Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52821 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3KDOV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 09:21:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv2 11/29] uvc/lirc_serial: Fix some warnings on parisc arch
Date: Mon, 04 Nov 2013 15:22:26 +0100
Message-ID: <2429755.EyGbY6tqJF@avalon>
In-Reply-To: <1383399097-11615-12-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com> <1383399097-11615-12-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Saturday 02 November 2013 11:31:19 Mauro Carvalho Chehab wrote:
> On this arch, usec is not unsigned long. So, we need to typecast,
> in order to remove those warnings:
> 
> 	drivers/media/usb/uvc/uvc_video.c: In function 'uvc_video_clock_update':
> 	drivers/media/usb/uvc/uvc_video.c:678:2: warning: format '%lu' expects
> argument of type 'long unsigned int', but argument 9 has type
> '__kernel_suseconds_t' [-Wformat] drivers/staging/media/lirc/lirc_serial.c:
> In function 'irq_handler': drivers/staging/media/lirc/lirc_serial.c:707:5:
> warning: format '%lx' expects argument of type 'long unsigned int', but
> argument 6 has type '__kernel_suseconds_t' [-Wformat]
> drivers/staging/media/lirc/lirc_serial.c:707:5: warning: format '%lx'
> expects argument of type 'long unsigned int', but argument 7 has type
> '__kernel_suseconds_t' [-Wformat]
> drivers/staging/media/lirc/lirc_serial.c:719:5: warning: format '%lx'
> expects argument of type 'long unsigned int', but argument 6 has type
> '__kernel_suseconds_t' [-Wformat]
> drivers/staging/media/lirc/lirc_serial.c:719:5: warning: format '%lx'
> expects argument of type 'long unsigned int', but argument 7 has type
> '__kernel_suseconds_t' [-Wformat]
> drivers/staging/media/lirc/lirc_serial.c:728:6: warning: format '%lx'
> expects argument of type 'long unsigned int', but argument 6 has type
> '__kernel_suseconds_t' [-Wformat]
> drivers/staging/media/lirc/lirc_serial.c:728:6: warning: format '%lx'
> expects argument of type 'long unsigned int', but argument 7 has type
> '__kernel_suseconds_t' [-Wformat]
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I don't like this much, but I guess we won't get parisc to switch 
__kernel_suseconds from int to unsigned long any time soon. So,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

By the way, what about defining a macro similar to the PRI* macros (from 
inttypes.h) for kernel types ? We could then get rid of the cast.

I expect you to apply the patch directly to your tree, please let me know if I 
should take it in mine instead.

> ---
>  drivers/media/usb/uvc/uvc_video.c        | 3 ++-
>  drivers/staging/media/lirc/lirc_serial.c | 9 ++++++---
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 3394c3432011..899cb6d1c4a4 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -680,7 +680,8 @@ void uvc_video_clock_update(struct uvc_streaming
> *stream, stream->dev->name,
>  		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
>  		  y, ts.tv_sec, ts.tv_nsec / NSEC_PER_USEC,
> -		  v4l2_buf->timestamp.tv_sec, v4l2_buf->timestamp.tv_usec,
> +		  v4l2_buf->timestamp.tv_sec,
> +		  (unsigned long)v4l2_buf->timestamp.tv_usec,
>  		  x1, first->host_sof, first->dev_sof,
>  		  x2, last->host_sof, last->dev_sof, y1, y2);
> 
> diff --git a/drivers/staging/media/lirc/lirc_serial.c
> b/drivers/staging/media/lirc/lirc_serial.c index af08e677b60f..7b3be2346b4b
> 100644
> --- a/drivers/staging/media/lirc/lirc_serial.c
> +++ b/drivers/staging/media/lirc/lirc_serial.c
> @@ -707,7 +707,8 @@ static irqreturn_t irq_handler(int i, void *blah)
>  				pr_warn("ignoring spike: %d %d %lx %lx %lx %lx\n",
>  					dcd, sense,
>  					tv.tv_sec, lasttv.tv_sec,
> -					tv.tv_usec, lasttv.tv_usec);
> +					(unsigned long)tv.tv_usec,
> +					(unsigned long)lasttv.tv_usec);
>  				continue;
>  			}
> 
> @@ -719,7 +720,8 @@ static irqreturn_t irq_handler(int i, void *blah)
>  				pr_warn("%d %d %lx %lx %lx %lx\n",
>  					dcd, sense,
>  					tv.tv_sec, lasttv.tv_sec,
> -					tv.tv_usec, lasttv.tv_usec);
> +					(unsigned long)tv.tv_usec,
> +					(unsigned long)lasttv.tv_usec);
>  				data = PULSE_MASK;
>  			} else if (deltv > 15) {
>  				data = PULSE_MASK; /* really long time */
> @@ -728,7 +730,8 @@ static irqreturn_t irq_handler(int i, void *blah)
>  					pr_warn("AIEEEE: %d %d %lx %lx %lx %lx\n",
>  						dcd, sense,
>  						tv.tv_sec, lasttv.tv_sec,
> -						tv.tv_usec, lasttv.tv_usec);
> +						(unsigned long)tv.tv_usec,
> +						(unsigned long)lasttv.tv_usec);
>  					/*
>  					 * detecting pulse while this
>  					 * MUST be a space!
-- 
Regards,

Laurent Pinchart

