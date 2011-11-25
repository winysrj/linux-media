Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2237 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1KYLuM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 06:50:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: More missing module.h includes
Date: Fri, 25 Nov 2011 12:50:05 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201111251237.58993.hverkuil@xs4all.nl>
In-Reply-To: <201111251237.58993.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251250.05742.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 25, 2011 12:37:58 Hans Verkuil wrote:
> While compiling the very latest for_v3.3 branch with the very latest media_build
> on a 3.1 kernel I got more compile errors for a missing module.h header.

I spoke too soon, I was actually using a different source tree than I expected.

I need to do some more digging in order to understand why I get these compile
errors...

Regards,

	Hans

> 
> Add these includes.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Regards,
> 
> 	Hans
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 6edc9ba..b826867 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -21,6 +21,7 @@
>   */
>  
>  #include <linux/types.h>
> +#include <linux/module.h>
>  #include <linux/ioctl.h>
>  #include <linux/media.h>
>  #include <linux/export.h>
> diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
> index 82e819f..48cf133 100644
> --- a/drivers/media/video/hdpvr/hdpvr-i2c.c
> +++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
> @@ -15,6 +15,7 @@
>  
>  #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
>  
> +#include <linux/module.h>
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  #include <linux/export.h>
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index 65ade5f..5c3abc5 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -20,6 +20,7 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
>  
> +#include <linux/module.h>
>  #include <linux/ioctl.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
