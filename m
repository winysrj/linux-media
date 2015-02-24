Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38056 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbbBXWDU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 17:03:20 -0500
Date: Tue, 24 Feb 2015 19:03:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: em28xx replace printk in dprintk macros
Message-ID: <20150224190315.124b71f3@recife.lan>
In-Reply-To: <1424804027-7790-1-git-send-email-shuahkh@osg.samsung.com>
References: <1424804027-7790-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 24 Feb 2015 11:53:47 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Replace printk macro in dprintk macros in em28xx audio, dvb,
> and input files with pr_* equivalent routines.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-audio.c | 3 +--
>  drivers/media/usb/em28xx/em28xx-dvb.c   | 2 +-
>  drivers/media/usb/em28xx/em28xx-input.c | 2 +-
>  3 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index 49a5f95..93d89f2 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -55,8 +55,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
>  
>  #define dprintk(fmt, arg...) do {					\
>  	    if (debug)							\
> -		printk(KERN_INFO "em28xx-audio %s: " fmt,		\
> -				  __func__, ##arg);		\
> +		pr_info("em28xx-audio %s: " fmt, __func__, ##arg);	\
>  	} while (0)
>  
>  static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index aee70d4..8826054 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -71,7 +71,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
>  #define dprintk(level, fmt, arg...) do {			\
>  if (debug >= level)						\
> -	printk(KERN_DEBUG "%s/2-dvb: " fmt, dev->name, ## arg);	\
> +	pr_debug("%s/2-dvb: " fmt, dev->name, ## arg);		\
>  } while (0)
>  
>  struct em28xx_dvb {
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 4007356..e99108b 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -43,7 +43,7 @@ MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
>  
>  #define dprintk(fmt, arg...) \
>  	if (ir_debug) { \
> -		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
> +		pr_debug("%s/ir: " fmt, ir->name, ## arg); \

NACK.

This is the worse of two words, as it would require both to enable
each debug line via dynamic printk setting and to enable ir_debug.

Regards,
Mauro
>  	}
>  
>  /**********************************************************
