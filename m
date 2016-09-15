Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout06.plus.net ([212.159.14.18]:50849 "EHLO
        avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754029AbcIOUXr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 16:23:47 -0400
Date: Thu, 15 Sep 2016 21:23:43 +0100
From: Nick Dyer <nick@shmanahar.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] Input: atmel_mxt: disallow impossible
 configuration
Message-ID: <20160915202343.GB18925@lava.h.shmanahar.org>
References: <20160912153105.3035940-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160912153105.3035940-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 12, 2016 at 05:30:32PM +0200, Arnd Bergmann wrote:
> The newnly added debug mode for the atmel_mxt_ts driver relies on
> the v4l2 interface and vb2_vmalloc, but those might be configured
> as loadable modules when the driver itself is built-in, resulting
> in a link failure:
> 
> drivers/input/touchscreen/atmel_mxt_ts.o: In function `mxt_vidioc_querycap':
> atmel_mxt_ts.c:(.text.mxt_vidioc_querycap+0x10): undefined reference to `video_devdata'
> drivers/input/touchscreen/atmel_mxt_ts.o: In function `mxt_buffer_queue':
> atmel_mxt_ts.c:(.text.mxt_buffer_queue+0x20): undefined reference to `vb2_plane_vaddr'
> atmel_mxt_ts.c:(.text.mxt_buffer_queue+0x164): undefined reference to `vb2_buffer_done'
> drivers/input/touchscreen/atmel_mxt_ts.o: In function `mxt_free_object_table':
> atmel_mxt_ts.c:(.text.mxt_free_object_table+0x18): undefined reference to `video_unregister_device'
> atmel_mxt_ts.c:(.text.mxt_free_object_table+0x20): undefined reference to `v4l2_device_unregister'
> 
> The best workaround I could come up with is to disallow the debug
> mode unless it's actually possible to call it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: ecfdd7e2660e ("[media] Input: atmel_mxt_ts - output diagnostic debug via V4L2 device")

Acked-by: Nick Dyer <nick@shmanahar.org>

> ---
>  drivers/input/touchscreen/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index fce1e41ffe8b..ccf933969587 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -117,7 +117,8 @@ config TOUCHSCREEN_ATMEL_MXT
>  
>  config TOUCHSCREEN_ATMEL_MXT_T37
>  	bool "Support T37 Diagnostic Data"
> -	depends on TOUCHSCREEN_ATMEL_MXT && VIDEO_V4L2
> +	depends on TOUCHSCREEN_ATMEL_MXT
> +	depends on VIDEO_V4L2=y || (TOUCHSCREEN_ATMEL_MXT=m && VIDEO_V4L2=m)
>  	select VIDEOBUF2_VMALLOC
>  	help
>  	  Say Y here if you want support to output data from the T37
> -- 
> 2.9.0
> 
