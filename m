Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454Ab0FEAEx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 20:04:53 -0400
Message-ID: <4C099486.50908@redhat.com>
Date: Fri, 04 Jun 2010 21:04:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH] tm6000: bugfix unkown symbol tm6000_debug
References: <1275580158-18878-1-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1275580158-18878-1-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-06-2010 12:49, stefan.ringel@arcor.de escreveu:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> May 30 07:54:09 linux-v5dy kernel: [ 2555.727426] tm6000: Unknown symbol
> tm6000_debug

This won't work, since the same module will have diferent tm6000_debug vars.

I'll write a proper fix and submit shortly, together with some patches I've made
for alsa.

> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-core.c  |    2 ++
>  drivers/staging/tm6000/tm6000-dvb.c   |    4 ++--
>  drivers/staging/tm6000/tm6000-video.c |    2 +-
>  drivers/staging/tm6000/tm6000.h       |    2 --
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
> index 2fbf4f6..350770e 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -29,6 +29,8 @@
>  #include <media/v4l2-common.h>
>  #include <media/tuner.h>
>  
> +static int tm6000_debug;
> +
>  #define USB_TIMEOUT	5*HZ /* ms */
>  
>  int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
> diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
> index 3ccc466..34dc8e5 100644
> --- a/drivers/staging/tm6000/tm6000-dvb.c
> +++ b/drivers/staging/tm6000/tm6000-dvb.c
> @@ -38,9 +38,9 @@ MODULE_SUPPORTED_DEVICE("{{Trident, tm5600},"
>  			"{{Trident, tm6000},"
>  			"{{Trident, tm6010}");
>  
> -static int debug
> +static int tm6000_debug;
>  
> -module_param(debug, int, 0644);
> +module_param_named(debug, tm6000_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "enable debug message");
>  
>  static inline void print_err_status(struct tm6000_core *dev,
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index 1e348ac..1663dd2 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -55,7 +55,7 @@ static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
>  static int video_nr = -1;		/* /dev/videoN, -1 for autodetect */
>  
>  /* Debug level */
> -int tm6000_debug;
> +static int tm6000_debug;
>  
>  /* supported controls */
>  static struct v4l2_queryctrl tm6000_qctrl[] = {
> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
> index 4b65094..ed7fece 100644
> --- a/drivers/staging/tm6000/tm6000.h
> +++ b/drivers/staging/tm6000/tm6000.h
> @@ -318,8 +318,6 @@ int tm6000_queue_init(struct tm6000_core *dev);
>  
>  /* Debug stuff */
>  
> -extern int tm6000_debug;
> -
>  #define dprintk(dev, level, fmt, arg...) do {\
>  	if (tm6000_debug & level) \
>  		printk(KERN_INFO "(%lu) %s %s :"fmt, jiffies, \

