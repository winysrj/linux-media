Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55806 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752153AbeDSLZh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 07:25:37 -0400
Subject: Re: [PATCH RESEND 2/6] media: omap3isp: Enable driver compilation on
 ARM with COMPILE_TEST
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>
References: <cover.1524136402.git.mchehab@s-opensource.com>
 <77f908bbbbe6d180db73cc354f26e9f9ae647b3a.1524136402.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f0e586fe-893c-ee52-9d7e-ea40b40a5885@xs4all.nl>
Date: Thu, 19 Apr 2018 13:25:29 +0200
MIME-Version: 1.0
In-Reply-To: <77f908bbbbe6d180db73cc354f26e9f9ae647b3a.1524136402.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/18 13:15, Mauro Carvalho Chehab wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> The omap3isp driver can't be compiled on non-ARM platforms but has no
> compile-time dependency on OMAP. It however requires common clock
> framework support, which isn't provided by all ARM platforms.
> 
> Drop the OMAP dependency when COMPILE_TEST is set and add ARM and
> COMMON_CLK dependencies.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/Kconfig | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 91b0c7324afb..1ee915b794c0 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -62,7 +62,10 @@ config VIDEO_MUX
>  
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support"
> -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> +	depends on ARCH_OMAP3 || COMPILE_TEST
> +	depends on ARM
> +	depends on COMMON_CLK
>  	depends on HAS_DMA && OF
>  	depends on OMAP_IOMMU
>  	select ARM_DMA_USE_IOMMU
> 
