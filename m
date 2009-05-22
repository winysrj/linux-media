Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56653 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZEVFsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 01:48:54 -0400
Date: Fri, 22 May 2009 14:48:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH -next] v4l2: handle unregister for non-I2C builds
Message-ID: <20090522054847.GB14059@linux-sh.org>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au> <4A085455.5040108@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A085455.5040108@oracle.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 11, 2009 at 09:37:41AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Build fails when CONFIG_I2C=n, so handle that case in the if block:
> 
> drivers/built-in.o: In function `v4l2_device_unregister':
> (.text+0x157821): undefined reference to `i2c_unregister_device'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

This patch still has not been applied as far as I can tell, and builds
are still broken as a result, almost 2 weeks after the fact.

> ---
>  drivers/media/video/v4l2-device.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next-20090511.orig/drivers/media/video/v4l2-device.c
> +++ linux-next-20090511/drivers/media/video/v4l2-device.c
> @@ -85,6 +85,7 @@ void v4l2_device_unregister(struct v4l2_
>  	/* Unregister subdevs */
>  	list_for_each_entry_safe(sd, next, &v4l2_dev->subdevs, list) {
>  		v4l2_device_unregister_subdev(sd);
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
>  		if (sd->flags & V4L2_SUBDEV_FL_IS_I2C) {
>  			struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
> @@ -95,6 +96,7 @@ void v4l2_device_unregister(struct v4l2_
>  			if (client)
>  				i2c_unregister_device(client);
>  		}
> +#endif
>  	}
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_unregister);
> 
> 
> -- 
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
