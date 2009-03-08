Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:50054 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbZCHBbH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 20:31:07 -0500
Date: Sat, 7 Mar 2009 17:31:02 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] zoran: Drop the lock_norm module parameter
In-Reply-To: <20090307110729.37230310@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0903071729520.24268@shell2.speakeasy.net>
References: <20090307110729.37230310@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 7 Mar 2009, Jean Delvare wrote:
> The lock_norm module parameter doesn't look terribly useful. If you
> don't want to change the norm, just don't change it. As a matter of
> fact, no other v4l driver has such a parameter.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Trent Piepho <xyzzy@speakeasy.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  linux/Documentation/video4linux/Zoran          |    3 +--
>  linux/drivers/media/video/zoran/zoran_driver.c |   20 --------------------
>  2 files changed, 1 insertion(+), 22 deletions(-)

I have a tree with some more zoran changes, so I'll take this patch and the
other one and work them in.

>
> --- v4l-dvb-zoran.orig/linux/Documentation/video4linux/Zoran	2009-02-20 09:42:36.000000000 +0100
> +++ v4l-dvb-zoran/linux/Documentation/video4linux/Zoran	2009-02-20 09:45:42.000000000 +0100
> @@ -401,8 +401,7 @@ Additional notes for software developers
>     first set the correct norm. Well, it seems logically correct: TV
>     standard is "more constant" for current country than geometry
>     settings of a variety of TV capture cards which may work in ITU or
> -   square pixel format. Remember that users now can lock the norm to
> -   avoid any ambiguity.
> +   square pixel format.
>  --
>  Please note that lavplay/lavrec are also included in the MJPEG-tools
>  (http://mjpeg.sf.net/).
> --- v4l-dvb-zoran.orig/linux/drivers/media/video/zoran/zoran_driver.c	2009-02-20 09:42:47.000000000 +0100
> +++ v4l-dvb-zoran/linux/drivers/media/video/zoran/zoran_driver.c	2009-02-20 09:45:42.000000000 +0100
> @@ -163,10 +163,6 @@ const struct zoran_format zoran_formats[
>  };
>  #define NUM_FORMATS ARRAY_SIZE(zoran_formats)
>
> -static int lock_norm;	/* 0 = default 1 = Don't change TV standard (norm) */
> -module_param(lock_norm, int, 0644);
> -MODULE_PARM_DESC(lock_norm, "Prevent norm changes (1 = ignore, >1 = fail)");
> -
>  	/* small helper function for calculating buffersizes for v4l2
>  	 * we calculate the nearest higher power-of-two, which
>  	 * will be the recommended buffersize */
> @@ -1497,22 +1493,6 @@ zoran_set_norm (struct zoran *zr,
>  		return -EBUSY;
>  	}
>
> -	if (lock_norm && norm != zr->norm) {
> -		if (lock_norm > 1) {
> -			dprintk(1,
> -				KERN_WARNING
> -				"%s: set_norm() - TV standard is locked, can not switch norm\n",
> -				ZR_DEVNAME(zr));
> -			return -EPERM;
> -		} else {
> -			dprintk(1,
> -				KERN_WARNING
> -				"%s: set_norm() - TV standard is locked, norm was not changed\n",
> -				ZR_DEVNAME(zr));
> -			norm = zr->norm;
> -		}
> -	}
> -
>  	if (!(norm & zr->card.norms)) {
>  		dprintk(1,
>  			KERN_ERR "%s: set_norm() - unsupported norm %llx\n",
>
>
> --
> Jean Delvare
>
