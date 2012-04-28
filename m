Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43403 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2D1MGr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 08:06:47 -0400
Message-ID: <4F9BDD54.1010106@gmail.com>
Date: Sat, 28 Apr 2012 14:06:44 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	patches@linaro.org, Ajay Kumar <ajaykumar.rs@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3] [media] s5p-g2d: Add support for FIMG2D v4.1 H/W logic
References: <1335263906-16174-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1335263906-16174-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 04/24/2012 12:38 PM, Sachin Kamat wrote:
> From: Ajay Kumar<ajaykumar.rs@samsung.com>
> 
> Modify the G2D driver(which initially supported only FIMG2D v3 style H/W)
> to support FIMG2D v4.1 style hardware present on Exynos4x12 and Exynos52x0 SOC.
> 
> 	-- Set the SRC and DST type to 'memory' instead of using reset values.
> 	-- FIMG2D v4.1 H/W uses different logic for stretching(scaling).
> 	-- Use CACHECTL_REG only with FIMG2D v3.
> 
> Signed-off-by: Ajay Kumar<ajaykumar.rs@samsung.com>
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/video/s5p-g2d/g2d-hw.c   |   17 +++++++++++++----
>   drivers/media/video/s5p-g2d/g2d-regs.h |    6 ++++++
>   drivers/media/video/s5p-g2d/g2d.c      |   23 +++++++++++++++++++++--
>   drivers/media/video/s5p-g2d/g2d.h      |    9 ++++++++-
>   4 files changed, 48 insertions(+), 7 deletions(-)
> 
...
> @@ -783,6 +788,8 @@ static int g2d_probe(struct platform_device *pdev)
> 
>   	def_frame.stride = (def_frame.width * def_frame.fmt->depth)>>  3;
> 
> +	dev->device_type = platform_get_device_id(pdev)->driver_data;
> +
>   	return 0;
> 
>   unreg_video_dev:
> @@ -832,9 +839,21 @@ static int g2d_remove(struct platform_device *pdev)
>   	return 0;
>   }
> 
> +static struct platform_device_id g2d_driver_ids[] = {
> +	{
> +		.name		= "s5p-g2d",
> +		.driver_data	= TYPE_G2D_3X,

IMHO it would be better to define a separate data structure describing
the quirks. For an example please see http://patchwork.linuxtv.org/patch/10869
and the code using struct flite_variant. There was some lengthy 
discussion recently on linux-i2c mailing list, where someone tried
to add more quirks to the i2c-s3c2440 driver which uses 'driver_data'
like it is done in this patch. To avoid wasting time in future, 
I would suggest to make 'driver_data' right away holding a pointer 
to a data structure, rather than simple integer.

We could start, for example, with something like:

struct g2d_variant {
	unsigned short hw_rev;
};

> +	}, {
> +		.name		= "s5p-g2d41x",
> +		.driver_data	= TYPE_G2D_41X,
> +	}, { },

How about marking the last empty entry e.g.

	{ /* sentinel */ }

? Or just putting it in new line ?

> +};
> +MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);

Hmm, should be g2d_driver_ids. This isn't going to fly when you 
compile this driver as a module. You would get an error like:

error: ‘__mod_platform_device_table’ aliased to undefined symbol ‘s3c24xx_driver_ids’


Regards,
Sylwester
