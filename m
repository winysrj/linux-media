Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:21643 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZIUGFO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 02:05:14 -0400
Date: Mon, 21 Sep 2009 09:05:02 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Huang Weiyi <weiyi.huang@gmail.com>
Cc: "mchehab@infradead.org" <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/9] V4L/DVB: si4713: remove unused #include
 <linux/version.h>
Message-ID: <20090921060502.GA27861@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1253106375-2636-1-git-send-email-weiyi.huang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253106375-2636-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wed, Sep 16, 2009 at 03:06:15PM +0200, ext Huang Weiyi wrote:
> Remove unused #include <linux/version.h>('s) in
>   drivers/media/radio/radio-si4713.c
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

This might be late, but I'm add my ack here.

Acked-by: Eduardo Valentin <eduardo.valentin@nokia.com>

> ---
>  drivers/media/radio/radio-si4713.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
> index 65c14b7..170bbe5 100644
> --- a/drivers/media/radio/radio-si4713.c
> +++ b/drivers/media/radio/radio-si4713.c
> @@ -24,7 +24,6 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> -#include <linux/version.h>
>  #include <linux/platform_device.h>
>  #include <linux/i2c.h>
>  #include <linux/videodev2.h>
> -- 
> 1.6.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Eduardo Valentin
