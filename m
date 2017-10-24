Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:38926 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751552AbdJXO2P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 10:28:15 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: Pierre-Hugues Husson <phh@phh.me>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH v2] drm: bridge: synopsys/dw-hdmi: Enable cec clock
Date: Tue, 24 Oct 2017 16:28:12 +0200
Message-ID: <2960167.0GRUE104rh@phil>
In-Reply-To: <20171020191838.392-1-phh@phh.me>
References: <20171020191838.392-1-phh@phh.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pierre,

Am Freitag, 20. Oktober 2017, 21:18:38 CEST schrieb Pierre-Hugues Husson:
> The documentation already mentions "cec" optional clock, but
> currently the driver doesn't enable it.
> 
> Changes:
> v2:
> - Separate ENOENT errors from others
> - Propagate other errors (especially -EPROBE_DEFER)
> 
> Signed-off-by: Pierre-Hugues Husson <phh@phh.me>
> ---

it looks like you might be missing some important people in your recipient list.
get_maintainer.pl shows me:
- Archit Taneja <architt@codeaurora.org> (maintainer:DRM DRIVERS FOR BRIDGE CHIPS)
- Andrzej Hajda <a.hajda@samsung.com> (maintainer:DRM DRIVERS FOR BRIDGE CHIPS)
- dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)

So these should definitly be included in your recipients, as they're the
ones that will apply your patch :-)

One further nit below.


>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
> index bf14214fa464..b31fc95d5fef 100644
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
> @@ -2382,6 +2383,27 @@ __dw_hdmi_probe(struct platform_device *pdev,
>  		goto err_isfr;
>  	}
>  
> +	hdmi->cec_clk = devm_clk_get(hdmi->dev, "cec");
> +	if (PTR_ERR(hdmi->cec_clk) == -ENOENT) {
> +		hdmi->cec_clk = NULL;
> +	} else if (IS_ERR(hdmi->cec_clk)) {
> +		ret = PTR_ERR(hdmi->cec_clk);
> +		if (ret != -EPROBE_DEFER) {
> +			dev_err(hdmi->dev, "Cannot get HDMI cec clock: %d\n",
> +					ret);
> +		}

braces around the single dev_err are not necessary.

Heiko
