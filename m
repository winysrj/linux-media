Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2579 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbZCNVjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 17:39:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] Update remaining references to old video4linux list
Date: Sat, 14 Mar 2009 22:39:35 +0100
Cc: LMML <linux-media@vger.kernel.org>
References: <20090314222514.7a2b44f6@hyperion.delvare>
In-Reply-To: <20090314222514.7a2b44f6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142239.35484.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 March 2009 22:25:14 Jean Delvare wrote:
> The video4linux-list@redhat.com list is deprecated, point the users to
> the new linux-media list instead.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  linux/Documentation/video4linux/bttv/README  |    4 ++--
>  linux/drivers/media/radio/radio-si470x.c     |    4 ++--
>  linux/drivers/media/video/bt8xx/bttv-cards.c |    2 +-
>  v4l/scripts/make_kconfig.pl                  |    4 ++--
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> --- v4l-dvb.orig/linux/Documentation/video4linux/bttv/README	2009-03-01 16:09:08.000000000 +0100
> +++ v4l-dvb/linux/Documentation/video4linux/bttv/README	2009-03-14 22:13:43.000000000 +0100
> @@ -63,8 +63,8 @@ If you have some knowledge and spare tim
>  yourself (patches very welcome of course...)  You know: The linux
>  slogan is "Do it yourself".
>  
> -There is a mailing list: video4linux-list@redhat.com.
> -https://listman.redhat.com/mailman/listinfo/video4linux-list
> +There is a mailing list: linux-media@vger.kernel.org.
> +http://vger.kernel.org/vger-lists.html#linux-media
>  
>  If you have trouble with some specific TV card, try to ask there
>  instead of mailing me directly.  The chance that someone with the
> --- v4l-dvb.orig/linux/drivers/media/radio/radio-si470x.c	2009-03-04 09:52:51.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/radio/radio-si470x.c	2009-03-14 22:12:55.000000000 +0100
> @@ -1713,8 +1713,8 @@ static int si470x_usb_driver_probe(struc
>  		printk(KERN_WARNING DRIVER_NAME
>  			": If you have some trouble using this driver,\n");
>  		printk(KERN_WARNING DRIVER_NAME
> -			": please report to V4L ML at "
> -			"video4linux-list@redhat.com\n");
> +			": please report to linux-media ML at "
> +			"linux-media@vger.kernel.org\n");
>  	}
>  
>  	/* set initial frequency */
> --- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttv-cards.c	2009-03-13 09:59:49.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/video/bt8xx/bttv-cards.c	2009-03-14 22:13:08.000000000 +0100
> @@ -2953,7 +2953,7 @@ void __devinit bttv_idcard(struct bttv *
>  			       btv->c.nr, btv->cardid & 0xffff,
>  			       (btv->cardid >> 16) & 0xffff);
>  			printk(KERN_DEBUG "please mail id, board name and "
> -			       "the correct card= insmod option to video4linux-list@redhat.com\n");
> +			       "the correct card= insmod option to linux-media@vger.kernel.org\n");
>  		}
>  	}
>  
> --- v4l-dvb.orig/v4l/scripts/make_kconfig.pl	2009-03-14 19:57:47.000000000 +0100
> +++ v4l-dvb/v4l/scripts/make_kconfig.pl	2009-03-14 22:14:28.000000000 +0100
> @@ -576,8 +576,8 @@ config VIDEO_KERNEL_VERSION
>  	  requiring a newer kernel is that no one has tested them with an
>  	  older one yet.
>  
> -	   If the driver works, please post a report at V4L mailing list:
> -			video4linux-list\@redhat.com.
> +	  If the driver works, please post a report at linux-media mailing
> +	  list: linux-media\@vger.kernel.org.
>  
>  	  Unless you know what you are doing, you should answer N.
>  
> 
> 

I've already done this in my tree. It's probably easier for Mauro to just
pull from my v4l-dvb tree.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
