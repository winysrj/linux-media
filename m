Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54221 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaDOA2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 20:28:25 -0400
Message-id: <534C7D2F.2060504@samsung.com>
Date: Tue, 15 Apr 2014 09:28:31 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	t.figa@samsung.com, b.zolnierkie@samsung.com,
	rahul.sharma@samsung.com, pawel.moll@arm.com
Subject: Re: [PATCH 3/4] drm: exynos: add compatibles for HDMI and Mixer chips
 and exynos4210 SoC
References: <1397487622-3577-1-git-send-email-t.stanislaws@samsung.com>
 <1397487622-3577-4-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1397487622-3577-4-git-send-email-t.stanislaws@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 04/15/2014 12:00 AM, Tomasz Stanislawski wrote:
> This patch add proper compatibles for Mixer and HDMI chip
> available on exynos4210 SoCs.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>   drivers/gpu/drm/exynos/exynos_hdmi.c  |    3 +++
>   drivers/gpu/drm/exynos/exynos_mixer.c |    3 +++
>   2 files changed, 6 insertions(+)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
> index d2d6e2e..6fa63ea 100644
> --- a/drivers/gpu/drm/exynos/exynos_hdmi.c
> +++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
> @@ -2032,6 +2032,9 @@ static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
>   
>   static struct of_device_id hdmi_match_types[] = {
>   	{
> +		.compatible = "samsung,exynos4210-hdmi",
> +		.data	= (void	*)HDMI_TYPE13,

It's consistent with others to use struct hdmi_driver_data like
exynos5_hdmi_driver_data.

> +	}, {
>   		.compatible = "samsung,exynos5-hdmi",
>   		.data = &exynos5_hdmi_driver_data,
>   	}, {
> diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
> index e3306c8..fd8a9a0 100644
> --- a/drivers/gpu/drm/exynos/exynos_mixer.c
> +++ b/drivers/gpu/drm/exynos/exynos_mixer.c
> @@ -1187,6 +1187,9 @@ static struct platform_device_id mixer_driver_types[] = {
>   
>   static struct of_device_id mixer_match_types[] = {
>   	{
> +		.compatible = "samsung,exynos4210-mixer",
> +		.data	= &exynos4210_mxr_drv_data,
> +	}, {
>   		.compatible = "samsung,exynos5-mixer",
>   		.data	= &exynos5250_mxr_drv_data,
>   	}, {

