Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43796 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdKZMq3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 07:46:29 -0500
Subject: Re: [PATCH v4] drm: bridge: synopsys/dw-hdmi: Enable cec clock
To: Pierre-Hugues Husson <phh@phh.me>,
        linux-rockchip@lists.infradead.org
Cc: heiko@sntech.de, linux@armlinux.org.uk,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20171125201844.11353-1-phh@phh.me>
From: Archit Taneja <architt@codeaurora.org>
Message-ID: <bc8b4aea-eb0d-4d96-0e55-62afce664dc4@codeaurora.org>
Date: Sun, 26 Nov 2017 18:16:23 +0530
MIME-Version: 1.0
In-Reply-To: <20171125201844.11353-1-phh@phh.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/26/2017 01:48 AM, Pierre-Hugues Husson wrote:
> Support the "cec" optional clock. The documentation already mentions "cec"
> optional clock and it is used by several boards, but currently the driver
> doesn't enable it, thus preventing cec from working on those boards.
> 
> And even worse: a /dev/cecX device will appear for those boards, but it
> won't be functioning without configuring this clock.

Thanks for the updating the commit message. I will queue this to drm-misc-fixes once
it's updated with the 4.15-rc1 tag.

Thanks,
Archit

> 
> Changes:
> v4:
> - Change commit message to stress the importance of this patch
> 
> v3:
> - Drop useless braces
> 
> v2:
> - Separate ENOENT errors from others
> - Propagate other errors (especially -EPROBE_DEFER)
> 
> Signed-off-by: Pierre-Hugues Husson <phh@phh.me>
> ---
>   drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> index bf14214fa464..d82b9747a979 100644
> --- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> @@ -138,6 +138,7 @@ struct dw_hdmi {
>   	struct device *dev;
>   	struct clk *isfr_clk;
>   	struct clk *iahb_clk;
> +	struct clk *cec_clk;
>   	struct dw_hdmi_i2c *i2c;
>   
>   	struct hdmi_data_info hdmi_data;
> @@ -2382,6 +2383,26 @@ __dw_hdmi_probe(struct platform_device *pdev,
>   		goto err_isfr;
>   	}
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
>   	/* Product and revision IDs */
>   	hdmi->version = (hdmi_readb(hdmi, HDMI_DESIGN_ID) << 8)
>   		      | (hdmi_readb(hdmi, HDMI_REVISION_ID) << 0);
> @@ -2518,6 +2539,8 @@ __dw_hdmi_probe(struct platform_device *pdev,
>   		cec_notifier_put(hdmi->cec_notifier);
>   
>   	clk_disable_unprepare(hdmi->iahb_clk);
> +	if (hdmi->cec_clk)
> +		clk_disable_unprepare(hdmi->cec_clk);
>   err_isfr:
>   	clk_disable_unprepare(hdmi->isfr_clk);
>   err_res:
> @@ -2541,6 +2564,8 @@ static void __dw_hdmi_remove(struct dw_hdmi *hdmi)
>   
>   	clk_disable_unprepare(hdmi->iahb_clk);
>   	clk_disable_unprepare(hdmi->isfr_clk);
> +	if (hdmi->cec_clk)
> +		clk_disable_unprepare(hdmi->cec_clk);
>   
>   	if (hdmi->i2c)
>   		i2c_del_adapter(&hdmi->i2c->adap);
> 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
