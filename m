Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59325 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750774AbdFOIxk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 04:53:40 -0400
Subject: Re: [PATCH 1/6] v4l: vsp1: Remove WPF vertical flip support on
 VSP2-B[CD] and VSP2-D
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170615082409.9523-2-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <01747c5c-bb5e-77ff-c46d-9589c606cef7@xs4all.nl>
Date: Thu, 15 Jun 2017 10:53:33 +0200
MIME-Version: 1.0
In-Reply-To: <20170615082409.9523-2-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/17 10:24, Laurent Pinchart wrote:
> The WPF vertical flip is only supported on Gen3 SoCs on the VSP2-I.
> Don't enable it on other VSP2 instances.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Should this go to older kernels as well? Or is that not needed?

Regards,

	Hans

> ---
>  drivers/media/platform/vsp1/vsp1_drv.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 048446af5ae7..239996cf882e 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -690,7 +690,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.version = VI6_IP_VERSION_MODEL_VSPBD_GEN3,
>  		.model = "VSP2-BD",
>  		.gen = 3,
> -		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
> +		.features = VSP1_HAS_BRU,
>  		.rpf_count = 5,
>  		.wpf_count = 1,
>  		.num_bru_inputs = 5,
> @@ -700,7 +700,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.model = "VSP2-BC",
>  		.gen = 3,
>  		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
> -			  | VSP1_HAS_LUT | VSP1_HAS_WPF_VFLIP,
> +			  | VSP1_HAS_LUT,
>  		.rpf_count = 5,
>  		.wpf_count = 1,
>  		.num_bru_inputs = 5,
> @@ -709,7 +709,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
>  		.model = "VSP2-D",
>  		.gen = 3,
> -		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP,
> +		.features = VSP1_HAS_BRU | VSP1_HAS_LIF,
>  		.rpf_count = 5,
>  		.wpf_count = 2,
>  		.num_bru_inputs = 5,
> 
