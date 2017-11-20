Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46118 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751152AbdKTMae (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 07:30:34 -0500
Subject: Re: [PATCH v3] drm: bridge: synopsys/dw-hdmi: Enable cec clock
To: Pierre-Hugues Husson <phh@phh.me>,
        linux-rockchip@lists.infradead.org
Cc: heiko@sntech.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux@armlinux.org.uk, Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        dri-devel@lists.freedesktop.org
References: <20171026181942.9516-1-phh@phh.me>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <75adf743-18a2-2c55-b4bb-95d83bd26f03@xs4all.nl>
Date: Mon, 20 Nov 2017 13:30:27 +0100
MIME-Version: 1.0
In-Reply-To: <20171026181942.9516-1-phh@phh.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I didn't see this merged for 4.15, is it too late to include this?
All other changes needed to get CEC to work on rk3288 and rk3399 are all merged.

Regards,

	Hans

On 10/26/2017 08:19 PM, Pierre-Hugues Husson wrote:
> The documentation already mentions "cec" optional clock, but
> currently the driver doesn't enable it.
> 
> Changes:
> v3:
> - Drop useless braces
> 
> v2:
> - Separate ENOENT errors from others
> - Propagate other errors (especially -EPROBE_DEFER)
> 
> Signed-off-by: Pierre-Hugues Husson <phh@phh.me>
> ---
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> index bf14214fa464..d82b9747a979 100644
> --- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> @@ -138,6 +138,7 @@ struct dw_hdmi {
>  	struct device *dev;
>  	struct clk *isfr_clk;
>  	struct clk *iahb_clk;
> +	struct clk *cec_clk;
>  	struct dw_hdmi_i2c *i2c;
>  
>  	struct hdmi_data_info hdmi_data;
> @@ -2382,6 +2383,26 @@ __dw_hdmi_probe(struct platform_device *pdev,
>  		goto err_isfr;
>  	}
>  
> +	hdmi->cec_clk = devm_clk_get(hdmi->dev, "cec");
> +	if (PTR_ERR(hdmi->cec_clk) == -ENOENT) {
> +		hdmi->cec_clk = NULL;
> +	} else if (IS_ERR(hdmi->cec_clk)) {
> +		ret = PTR_ERR(hdmi->cec_clk);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(hdmi->dev, "Cannot get HDMI cec clock: %d\n",
> +					ret);
> +
> +		hdmi->cec_clk = NULL;
> +		goto err_iahb;
> +	} else {
> +		ret = clk_prepare_enable(hdmi->cec_clk);
> +		if (ret) {
> +			dev_err(hdmi->dev, "Cannot enable HDMI cec clock: %d\n",
> +					ret);
> +			goto err_iahb;
> +		}
> +	}
> +
>  	/* Product and revision IDs */
>  	hdmi->version = (hdmi_readb(hdmi, HDMI_DESIGN_ID) << 8)
>  		      | (hdmi_readb(hdmi, HDMI_REVISION_ID) << 0);
> @@ -2518,6 +2539,8 @@ __dw_hdmi_probe(struct platform_device *pdev,
>  		cec_notifier_put(hdmi->cec_notifier);
>  
>  	clk_disable_unprepare(hdmi->iahb_clk);
> +	if (hdmi->cec_clk)
> +		clk_disable_unprepare(hdmi->cec_clk);
>  err_isfr:
>  	clk_disable_unprepare(hdmi->isfr_clk);
>  err_res:
> @@ -2541,6 +2564,8 @@ static void __dw_hdmi_remove(struct dw_hdmi *hdmi)
>  
>  	clk_disable_unprepare(hdmi->iahb_clk);
>  	clk_disable_unprepare(hdmi->isfr_clk);
> +	if (hdmi->cec_clk)
> +		clk_disable_unprepare(hdmi->cec_clk);
>  
>  	if (hdmi->i2c)
>  		i2c_del_adapter(&hdmi->i2c->adap);
> 
