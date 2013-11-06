Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53222 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756366Ab3KFO7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 09:59:12 -0500
Date: Wed, 6 Nov 2013 16:58:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:SMIA AND SMIA++ I..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH] smiapp: Fix BUG_ON() on an impossible condition
Message-ID: <20131106145839.GE24988@valkosipuli.retiisi.org.uk>
References: <1383747690-20003-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383747690-20003-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thanks for the patch.

I've removed LKML from cc since I don't think this is anything but noise
there.

On Wed, Nov 06, 2013 at 03:21:30PM +0100, Ricardo Ribalda Delgado wrote:
> internal_csi_format_idx and csi_format_idx are unsigned integers,
> therefore they can never be nevative.
> 
> CC      drivers/media/i2c/smiapp/smiapp-core.o
> In file included from include/linux/err.h:4:0,
>                  from include/linux/clk.h:15,
>                  from drivers/media/i2c/smiapp/smiapp-core.c:29:
> drivers/media/i2c/smiapp/smiapp-core.c: In function ‘smiapp_update_mbus_formats’:
> include/linux/kernel.h:669:20: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>  #define min(x, y) ({    \
>                     ^
> include/linux/compiler.h:153:42: note: in definition of macro ‘unlikely’
>  # define unlikely(x) __builtin_expect(!!(x), 0)
>                                           ^
> drivers/media/i2c/smiapp/smiapp-core.c:402:2: note: in expansion of macro ‘BUG_ON’
>   BUG_ON(min(internal_csi_format_idx, csi_format_idx) < 0);
>   ^
> drivers/media/i2c/smiapp/smiapp-core.c:402:9: note: in expansion of macro ‘min’
>   BUG_ON(min(internal_csi_format_idx, csi_format_idx) < 0);
>          ^
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index ae66d91..fbd48f0 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -399,7 +399,6 @@ static void smiapp_update_mbus_formats(struct smiapp_sensor *sensor)
>  
>  	BUG_ON(max(internal_csi_format_idx, csi_format_idx) + pixel_order
>  	       >= ARRAY_SIZE(smiapp_csi_data_formats));
> -	BUG_ON(min(internal_csi_format_idx, csi_format_idx) < 0);
>  
>  	dev_dbg(&client->dev, "new pixel order %s\n",
>  		pixel_order_str[pixel_order]);

I wonder how this hasn't been noticed before. :-) No harm done, though.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Should I take the patch to my tree? I don't think I have other pending
patches for smiapp so I'm fine that you have it in yours, too.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
