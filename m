Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34945 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932528AbeCSNLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 09:11:42 -0400
Received: by mail-wm0-f67.google.com with SMTP id r82so5014155wme.0
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 06:11:41 -0700 (PDT)
Subject: Re: [PATCH 2/3] drm: bridge: dw-hdmi: check the cec-disable property
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180319114345.29837-1-hverkuil@xs4all.nl>
 <20180319114345.29837-3-hverkuil@xs4all.nl>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <7ec5ea06-92ab-59e6-898c-57b3e5cdf83d@baylibre.com>
Date: Mon, 19 Mar 2018 14:11:39 +0100
MIME-Version: 1.0
In-Reply-To: <20180319114345.29837-3-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/03/2018 12:43, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If the cec-disable property was set, then disable the DW CEC
> controller. This is needed for boards that have their own
> CEC controller.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> index a38db40ce990..597220e40541 100644
> --- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> @@ -2508,7 +2508,8 @@ __dw_hdmi_probe(struct platform_device *pdev,
>  		hdmi->audio = platform_device_register_full(&pdevinfo);
>  	}
>  
> -	if (config0 & HDMI_CONFIG0_CEC) {
> +	if ((config0 & HDMI_CONFIG0_CEC) &&
> +	    !of_property_read_bool(np, "cec-disable")) {
>  		cec.hdmi = hdmi;
>  		cec.ops = &dw_hdmi_cec_ops;
>  		cec.irq = irq;
> 

I suspected the bit was off for the Amlogic GX SoCs, I was wrong...

Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
