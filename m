Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35079 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbZIBB2q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2009 21:28:46 -0400
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
From: Andy Walls <awalls@radix.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org,
	Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <200909011019.35798.jarod@redhat.com>
References: <200909011019.35798.jarod@redhat.com>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 21:30:51 -0400
Message-Id: <1251855051.3926.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-09-01 at 10:19 -0400, Jarod Wilson wrote:
> Patch is against http://hg.jannau.net/hdpvr/
> 
> 1) Adds support for building hdpvr i2c support when i2c is built as a
> module (based on work by David Engel on the mythtv-users list)
> 
> 2) Refines the hdpvr_i2c_write() success check (based on a thread in
> the sagetv forums)
> 
> With this patch in place, and the latest lirc_zilog driver in my lirc
> git tree, the IR part in my hdpvr works perfectly, both for reception
> and transmitting.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Jarod,

I recall a problem Brandon Jenkins had from last year, that when I2C was
enabled in hdpvr, his machine with multiple HVR-1600s and an HD-PVR
would produce a kernel oops.

Have you tested this on a machine with both an HVR-1600 and HD-PVR
installed?

Regards,
Andy


> ---
>  Makefile     |    4 +---
>  hdpvr-core.c |    4 ++--
>  hdpvr-i2c.c  |    5 ++++-
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff -r d49772394029 linux/drivers/media/video/hdpvr/Makefile
> --- a/linux/drivers/media/video/hdpvr/Makefile	Sun Apr 05 21:15:57 2009 +0200
> +++ b/linux/drivers/media/video/hdpvr/Makefile	Tue Sep 01 10:12:59 2009 -0400
> @@ -1,6 +1,4 @@
> -hdpvr-objs	:= hdpvr-control.o hdpvr-core.o hdpvr-video.o
> -
> -hdpvr-$(CONFIG_I2C) += hdpvr-i2c.o
> +hdpvr-objs	:= hdpvr-control.o hdpvr-core.o hdpvr-i2c.o hdpvr-video.o
>  
>  obj-$(CONFIG_VIDEO_HDPVR) += hdpvr.o
>  
> diff -r d49772394029 linux/drivers/media/video/hdpvr/hdpvr-core.c
> --- a/linux/drivers/media/video/hdpvr/hdpvr-core.c	Sun Apr 05 21:15:57 2009 +0200
> +++ b/linux/drivers/media/video/hdpvr/hdpvr-core.c	Tue Sep 01 10:12:59 2009 -0400
> @@ -362,7 +362,7 @@
>  		goto error;
>  	}
>  
> -#ifdef CONFIG_I2C
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
>  	retval = hdpvr_register_i2c_adapter(dev);
>  	if (retval < 0) {
>  		v4l2_err(&dev->v4l2_dev, "registering i2c adapter failed\n");
> @@ -413,7 +413,7 @@
>  	mutex_unlock(&dev->io_mutex);
>  
>  	/* deregister I2C adapter */
> -#ifdef CONFIG_I2C
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
>  	mutex_lock(&dev->i2c_mutex);
>  	if (dev->i2c_adapter)
>  		i2c_del_adapter(dev->i2c_adapter);
> diff -r d49772394029 linux/drivers/media/video/hdpvr/hdpvr-i2c.c
> --- a/linux/drivers/media/video/hdpvr/hdpvr-i2c.c	Sun Apr 05 21:15:57 2009 +0200
> +++ b/linux/drivers/media/video/hdpvr/hdpvr-i2c.c	Tue Sep 01 10:12:59 2009 -0400
> @@ -10,6 +10,7 @@
>   *
>   */
>  
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
>  #include <linux/i2c.h>
>  
>  #include "hdpvr.h"
> @@ -67,7 +68,7 @@
>  			      REQTYPE_I2C_WRITE_STAT, CTRL_READ_REQUEST,
>  			      0, 0, buf, 2, 1000);
>  
> -	if (ret == 2)
> +	if ((ret == 2) && (buf[1] == (len - 1)))
>  		ret = 0;
>  	else if (ret >= 0)
>  		ret = -EIO;
> @@ -164,3 +165,5 @@
>  error:
>  	return retval;
>  }
> +
> +#endif /* CONFIG_I2C */
> 

