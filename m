Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:65018 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760509Ab3BNCAI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 21:00:08 -0500
Message-id: <511C4529.8030800@samsung.com>
Date: Thu, 14 Feb 2013 11:00:09 +0900
From: Donghwa Lee <dh09.lee@samsung.com>
MIME-version: 1.0
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, inki.dae@samsung.com, l.krishna@samsung.com,
	joshi@samsung.com, aditya.ps@samsung.com, tom.gall@linaro.org,
	patches@linaro.org, linux-samsung-soc@vger.kernel.org,
	ragesh.r@linaro.org, jesse.barker@linaro.org, robdclark@gmail.com,
	sumit.semwal@linaro.org
Subject: Re: [RFC v2 3/3] video: exynos: Making s6e8ax0 panel driver compliant
 with CDF
References: <1360749667-12028-1-git-send-email-vikas.sajjan@linaro.org>
 <1360749667-12028-4-git-send-email-vikas.sajjan@linaro.org>
In-reply-to: <1360749667-12028-4-git-send-email-vikas.sajjan@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 13, 2013 at 19:01, Vikas Sajjan wrote:
> Made necessary changes in s6e8ax0 panel driver as per the  CDF-T.
> It also removes the dependency on backlight and lcd framework
>
> Signed-off-by: Vikas Sajjan<vikas.sajjan@linaro.org>
> ---
>   drivers/video/exynos/s6e8ax0.c |  848 +++++++++++++++++++++-------------------
>   1 file changed, 444 insertions(+), 404 deletions(-)
>
> diff --git a/drivers/video/exynos/s6e8ax0.c b/drivers/video/exynos/s6e8ax0.c
> index 7f7b25f..5a17e3c 100644
> --- a/drivers/video/exynos/s6e8ax0.c
> +++ b/drivers/video/exynos/s6e8ax0.c
> @@ -25,6 +25,7 @@
>   #include <linux/backlight.h>
>   #include <linux/regulator/consumer.h>
>   
> +#include <video/display.h>
>   #include <video/mipi_display.h>
>   #include <video/exynos_mipi_dsim.h>
>   
> @@ -38,8 +39,7 @@
>   #define POWER_IS_OFF(pwr)	((pwr) == FB_BLANK_POWERDOWN)
>   #define POWER_IS_NRM(pwr)	((pwr) == FB_BLANK_NORMAL)
>   
> -#define lcd_to_master(a)	(a->dsim_dev->master)
> -#define lcd_to_master_ops(a)	((lcd_to_master(a))->master_ops)
> +#define to_panel(p) container_of(p, struct s6e8ax0, entity)
>   
>   enum {
>   	DSIM_NONE_STATE = 0,
> @@ -47,20 +47,34 @@ enum {
>   	DSIM_FRAME_DONE = 2,
>   };
>   
> +/* This structure defines all the properties of a backlight */
> +struct backlight_prop {
> +	/* Current User requested brightness (0 - max_brightness) */
> +	int brightness;
> +	/* Maximal value for brightness (read-only) */
> +	int max_brightness;
> +};
> +
> +struct panel_platform_data {
> +	unsigned int	reset_delay;
> +	unsigned int	power_on_delay;
> +	unsigned int	power_off_delay;
> +	const char	*video_source_name;
> +};
> +
>   struct s6e8ax0 {
> -	struct device	*dev;
> -	unsigned int			power;
> -	unsigned int			id;
> -	unsigned int			gamma;
> -	unsigned int			acl_enable;
> -	unsigned int			cur_acl;
> -
> -	struct lcd_device	*ld;
> -	struct backlight_device	*bd;
> -
> -	struct mipi_dsim_lcd_device	*dsim_dev;
> -	struct lcd_platform_data	*ddi_pd;
> +	struct platform_device	*pdev;
> +	struct video_source	*src;
> +	struct display_entity	entity;
> +	unsigned int		power;
> +	unsigned int		id;
> +	unsigned int		gamma;
> +	unsigned int		acl_enable;
> +	unsigned int		cur_acl;
> +	bool			panel_reverse;
> +	struct lcd_platform_data	*plat_data;
>   	struct mutex			lock;
> +	struct backlight_prop		bl_prop;
>   	bool  enabled;
>   };
>   
Could this panel driver use only CDF?
Does not consider the compatibility with backlight and lcd framework?
> -static const unsigned char s6e8ax0_22_gamma_30[] = {
> +static unsigned char s6e8ax0_22_gamma_30[] = {
>   	0xfa, 0x01, 0x60, 0x10, 0x60, 0xf5, 0x00, 0xff, 0xad, 0xaf,
>   	0xbA, 0xc3, 0xd8, 0xc5, 0x9f, 0xc6, 0x9e, 0xc1, 0xdc, 0xc0,
>   	0x00, 0x61, 0x00, 0x5a, 0x00, 0x74,
>   };
In all case, you had changed data type to 'static unsigned char'.
Is it need to change all case? Otherwise, for the unity of the code?


Thank you,
Donghwa Lee


