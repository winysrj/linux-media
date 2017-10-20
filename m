Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46648 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdJTIMQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 04:12:16 -0400
Date: Fri, 20 Oct 2017 09:12:04 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Pierre-Hugues Husson <phh@phh.me>
Cc: linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org,
        heiko@sntech.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drm: bridge: synopsys/dw-hdmi: Enable cec clock
Message-ID: <20171020081203.GD20805@n2100.armlinux.org.uk>
References: <20171013225337.5196-1-phh@phh.me>
 <20171013225337.5196-2-phh@phh.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013225337.5196-2-phh@phh.me>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 14, 2017 at 12:53:35AM +0200, Pierre-Hugues Husson wrote:
> @@ -2382,6 +2383,18 @@ __dw_hdmi_probe(struct platform_device *pdev,
>  		goto err_isfr;
>  	}
>  
> +	hdmi->cec_clk = devm_clk_get(hdmi->dev, "cec");
> +	if (IS_ERR(hdmi->cec_clk)) {
> +		hdmi->cec_clk = NULL;

What if devm_clk_get() returns EPROBE_DEFER?  Does that really mean the
clock does not exist?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
