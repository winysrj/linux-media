Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51948 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933154Ab0CMSxT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 13:53:19 -0500
Subject: Re: [patch 1/5] drivers/media/video/cx23885 needs kfifo conversion
From: Andy Walls <awalls@radix.net>
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	stefani@seibold.net, stoth@kernellabs.com
In-Reply-To: <201003112202.o2BM2FgS013122@imap1.linux-foundation.org>
References: <201003112202.o2BM2FgS013122@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 13 Mar 2010 13:52:14 -0500
Message-Id: <1268506334.3084.85.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-03-11 at 14:02 -0800, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> linux-next:
> 
> drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_irq_handler':
> drivers/media/video/cx23885/cx23888-ir.c:597: error: implicit declaration of function 'kfifo_put'
> drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_rx_read':
> drivers/media/video/cx23885/cx23888-ir.c:660: error: implicit declaration of function 'kfifo_get'
> drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_probe':
> drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1172: warning: assignment makes pointer from integer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
> drivers/media/video/cx23885/cx23888-ir.c:1178: warning: assignment makes pointer from integer without a cast
> 
> Cc: Stefani Seibold <stefani@seibold.net>
> DESC
> drivers/media/video/cx23885: needs kfifo updates
> EDESC
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> linux-next again.
> 
> Cc: Stefani Seibold <stefani@seibold.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/media/video/cx231xx/Kconfig |    1 +
>  drivers/media/video/cx23885/Kconfig |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff -puN drivers/media/video/cx231xx/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion drivers/media/video/cx231xx/Kconfig
> --- a/drivers/media/video/cx231xx/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion
> +++ a/drivers/media/video/cx231xx/Kconfig
> @@ -1,6 +1,7 @@
>  config VIDEO_CX231XX
>  	tristate "Conexant cx231xx USB video capture support"
>  	depends on VIDEO_DEV && I2C && INPUT
> +	depends on BROKEN
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
>  	select VIDEO_IR

NAck.

What does the cx231xx driver have to do with a cx23885 driver build
problem?


> diff -puN drivers/media/video/cx23885/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion drivers/media/video/cx23885/Kconfig
> --- a/drivers/media/video/cx23885/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion
> +++ a/drivers/media/video/cx23885/Kconfig
> @@ -1,6 +1,7 @@
>  config VIDEO_CX23885
>  	tristate "Conexant cx23885 (2388x successor) support"
>  	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
> +	depends on BROKEN
>  	select I2C_ALGOBIT
>  	select VIDEO_BTCX
>  	select VIDEO_TUNER
> _

You should also Cc: Steve Toth if you are proposing disabling the
cx23885 driver.


Steve,

To bring you up to speed, it looks like someone errantly reverted some
cx23888-ir.c changes for kfifo from linux-next, when the code in 2.6.33
was correct.

Regards,
Andy

