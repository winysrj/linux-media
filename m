Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38001 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbbEWV7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2015 17:59:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	j.anaszewski@samsung.com, cooloney@gmail.com,
	g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	mchehab@osg.samsung.com
Subject: Re: [PATCH 2/5] v4l: flash: Make v4l2_flash_init() and v4l2_flash_release() functions always
Date: Sat, 23 May 2015 21:40:51 +0300
Message-ID: <2401592.2Lzj5V7eWH@avalon>
In-Reply-To: <1432076645-4799-3-git-send-email-sakari.ailus@iki.fi>
References: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi> <1432076645-4799-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Wednesday 20 May 2015 02:04:02 Sakari Ailus wrote:
> If CONFIG_V4L2_FLASH_LED_CLASS wasn't defined, v4l2_flash_init() and
> v4l2_flash_release() were empty macros. This will lead to compiler warnings
> in form of unused variables if the variables are not used for other
> purposes.
> 
> Instead, implement v4l2_flash_init() and v4l2_flash_release() as static
> inline functions.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/media/v4l2-flash.h |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
> index 945fa08..67a2cbf 100644
> --- a/include/media/v4l2-flash.h
> +++ b/include/media/v4l2-flash.h
> @@ -138,8 +138,16 @@ struct v4l2_flash *v4l2_flash_init(struct
> led_classdev_flash *fled_cdev, void v4l2_flash_release(struct v4l2_flash
> *v4l2_flash);
> 
>  #else
> -#define v4l2_flash_init(fled_cdev, ops, config) (NULL)
> -#define v4l2_flash_release(v4l2_flash)
> +static inline struct v4l2_flash *v4l2_flash_init(
> +	struct led_classdev_flash *fled_cdev, const struct v4l2_flash_ops *ops,
> +	struct v4l2_flash_config *config)
> +{
> +	return NULL;
> +}
> +
> +static inline void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
> +{
> +}
>  #endif /* CONFIG_V4L2_FLASH_LED_CLASS */
> 
>  #endif /* _V4L2_FLASH_H */

-- 
Regards,

Laurent Pinchart

