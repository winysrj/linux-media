Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42518 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1KVT3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 14:29:22 -0500
Received: by bke11 with SMTP id 11so632742bke.19
        for <linux-media@vger.kernel.org>; Tue, 22 Nov 2011 11:29:21 -0800 (PST)
Message-ID: <4ECBF80C.20701@gmail.com>
Date: Tue, 22 Nov 2011 20:29:16 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de
Subject: Re: [PATCH v2 1/2] MX2: Add platform definitions for eMMa-PrP device.
References: <1321963316-9058-1-git-send-email-javier.martin@vista-silicon.com> <1321963316-9058-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1321963316-9058-2-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On 11/22/2011 01:01 PM, Javier Martin wrote:
> eMMa-PrP device included in Freescale i.MX2 chips can also
> be used separately to process memory buffers.
> 
> Signed-off-by: Javier Martin<javier.martin@vista-silicon.com>
> ---
>   arch/arm/mach-imx/devices-imx27.h               |    2 +
>   arch/arm/plat-mxc/devices/platform-mx2-camera.c |   33 +++++++++++++++++++++++
>   arch/arm/plat-mxc/include/mach/devices-common.h |    2 +
>   3 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/devices-imx27.h b/arch/arm/mach-imx/devices-imx27.h
> index 2f727d7..519aa36 100644
> --- a/arch/arm/mach-imx/devices-imx27.h
> +++ b/arch/arm/mach-imx/devices-imx27.h
> @@ -50,6 +50,8 @@ extern const struct imx_imx_uart_1irq_data imx27_imx_uart_data[];
>   extern const struct imx_mx2_camera_data imx27_mx2_camera_data;
>   #define imx27_add_mx2_camera(pdata)	\
>   	imx_add_mx2_camera(&imx27_mx2_camera_data, pdata)
> +#define imx27_alloc_mx2_emmaprp(pdata)	\
> +	imx_alloc_mx2_emmaprp(&imx27_mx2_camera_data)
> 
>   extern const struct imx_mxc_ehci_data imx27_mxc_ehci_otg_data;
>   #define imx27_add_mxc_ehci_otg(pdata)	\
> diff --git a/arch/arm/plat-mxc/devices/platform-mx2-camera.c b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
> index b3f4828..4a8bd73 100644
> --- a/arch/arm/plat-mxc/devices/platform-mx2-camera.c
> +++ b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
> @@ -6,6 +6,7 @@
>    * the terms of the GNU General Public License version 2 as published by the
>    * Free Software Foundation.
>    */
> +#include<linux/dma-mapping.h>
>   #include<mach/hardware.h>
>   #include<mach/devices-common.h>
> 
> @@ -62,3 +63,35 @@ struct platform_device *__init imx_add_mx2_camera(
>   			res, data->iobaseemmaprp ? 4 : 2,
>   			pdata, sizeof(*pdata), DMA_BIT_MASK(32));
>   }
> +
> +struct platform_device *__init imx_alloc_mx2_emmaprp(
> +		const struct imx_mx2_camera_data *data)
> +{
> +	struct resource res[] = {
> +		{
> +			.start = data->iobaseemmaprp,
> +			.end = data->iobaseemmaprp + data->iosizeemmaprp - 1,
> +			.flags = IORESOURCE_MEM,
> +		}, {
> +			.start = data->irqemmaprp,
> +			.end = data->irqemmaprp,
> +			.flags = IORESOURCE_IRQ,
> +		},
> +	};
> +	struct platform_device *pdev;
> +	int ret = -ENOMEM;
> +
> +	pdev = platform_device_alloc("m2m-emmaprp", 0);
> +	if (!pdev)
> +		goto err;
> +
> +	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
> +	if (ret)
> +		goto err;
> +
> +	return pdev;
> +err:
> +	platform_device_put(pdev);
> +	return ERR_PTR(-ENODEV);

I guess you intended to have
 
+	return ERR_PTR(ret);

here ?

--
Regards,
Sylwester








