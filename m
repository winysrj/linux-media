Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41949 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZEONBu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 09:01:50 -0400
Received: from dflp53.itg.ti.com ([128.247.5.6])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4FD1kO8013650
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 08:01:51 -0500
Received: from tidmzi-ftp.india.ext.ti.com (localhost [127.0.0.1])
	by dflp53.itg.ti.com (8.13.8/8.13.8) with SMTP id n4FD1ilK005952
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 08:01:45 -0500 (CDT)
Received: from symphonyindia.ti.com (symphony-ftp [192.168.247.11])
	by tidmzi-ftp.india.ext.ti.com (Postfix) with SMTP id E58D33886B
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 18:29:09 +0530 (IST)
Received: from SYMX0103697 ([192.168.247.41])
	by symphonyindia.ti.com (8.12.10/8.12.10) with ESMTP id n4FCrOSX005408
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 18:23:31 +0530
From: "chaithrika" <chaithrika@ti.com>
To: "'Andy Walls'" <awalls@radix.net>, <david.ward@gatech.edu>
Cc: <linux-media@vger.kernel.org>
References: <1242345230.3169.49.camel@palomino.walls.org>
In-Reply-To: <1242345230.3169.49.camel@palomino.walls.org>
Subject: RE: v4l-dvb rev 11757 broke building under Ubuntu Hardy
Date: Fri, 15 May 2009 18:31:17 +0530
Message-ID: <027f01c9d55d$3beea460$b3cbed20$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy,

Thanks for the patch. Please see my response below.

> -----Original Message-----
> From: Andy Walls [mailto:awalls@radix.net]
> Sent: Friday, May 15, 2009 5:24 AM
> To: david.ward@gatech.edu
> Cc: Chaithrika U S; linux-media@vger.kernel.org
> Subject: Re: v4l-dvb rev 11757 broke building under Ubuntu Hardy
> 
> 
> David Ward wrote:
> 
> > I am using v4l-dvb in order to add the cx18 driver under Ubuntu Hardy
> > (8.04).
> >
> > The build is currently broken under Hardy, which uses kernel 2.6.24.
> I
> > have traced the origin of the problem to revision 11757. As seen in
> > the latest cron job output, the build produces the error when trying
> > to compile adv7343.c:
> >
> > /usr/local/src/v4l-dvb/v4l/adv7343.c:506: error: array type has
> incomplete element type
> > /usr/local/src/v4l-dvb/v4l/adv7343.c:518: warning: initialization
> from incompatible pointer type
> > /usr/local/src/v4l-dvb/v4l/adv7343.c:520: error: unknown field
> 'id_table' specified in initializer
> >
> > Thanks for resolving this.
> >
> > David Ward
> 
> David,
> 
> Please try the patch below.
> 
> Chaithrika,
> 
> Please review (and test if it is OK) the patch below.  It modifies
> adv7343.c to what the cs5345.c file does for backward compatability.
> 
> It adds some checks against kernel version, which would not go into the
> actual kernel, and changes some code to use the v4l2 i2c module
> template
> from v4l2-i2c-drv.h, which *would* go into the actual kenrel.
> 
> 
> Regards,
> Andy
> 
> 
> Signed-off-by: Andy Walls <awalls@radix.net>
> 
> diff -r 0018ed9bbca3 linux/drivers/media/video/adv7343.c
> --- a/linux/drivers/media/video/adv7343.c	Tue May 12 16:13:13 2009
> +0000
> +++ b/linux/drivers/media/video/adv7343.c	Thu May 14 19:51:10 2009 -
> 0400
> @@ -29,6 +29,8 @@
>  #include <media/adv7343.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-i2c-drv.h>
> +#include "compat.h"
> 
>  #include "adv7343_regs.h"
> 
> @@ -503,6 +505,7 @@
>  	return 0;
>  }
> 
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
>  static const struct i2c_device_id adv7343_id[] = {
>  	{"adv7343", 0},
>  	{},
> @@ -510,25 +513,12 @@
> 
>  MODULE_DEVICE_TABLE(i2c, adv7343_id);
> 
> -static struct i2c_driver adv7343_driver = {
> -	.driver = {
> -		.owner	= THIS_MODULE,
> -		.name	= "adv7343",
> -	},
> +#endif
> +static struct v4l2_i2c_driver_data v4l2_i2c_data = {
> +	.name		= "adv7343",
>  	.probe		= adv7343_probe,
>  	.remove		= adv7343_remove,
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
>  	.id_table	= adv7343_id,
> +#endif
>  };
> -
> -static __init int init_adv7343(void)
> -{
> -	return i2c_add_driver(&adv7343_driver);
> -}
> -
> -static __exit void exit_adv7343(void)
> -{
> -	i2c_del_driver(&adv7343_driver);
> -}
> -
> -module_init(init_adv7343);
> -module_exit(exit_adv7343);
> 

During my initial implementations, I did follow the v4l2_i2c_driver_data
procedure.
But after the review comment I got, I changed it. Please refer to the link
below.

http://www.mail-archive.com/linux-media@vger.kernel.org/msg02973.html

Was wondering if this is related to kernel version and is there a
possibility that in the
above patch, the module init and exit functions can be included in kernel
version checks 
instead of removing them altogether.

Regards,
Chaithrika







