Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58642 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbeKUVEO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 16:04:14 -0500
Subject: Re: [PATCH v2 8/9] phy: Add Cadence D-PHY support
To: Maxime Ripard <maxime.ripard@bootlin.com>
CC: Boris Brezillon <boris.brezillon@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <4ec9e47fb5aa9794f69a8e75a04108055094c056.1541516029.git-series.maxime.ripard@bootlin.com>
 <5f5bcc06-51b2-d565-56a0-083c66c1f01a@ti.com>
 <8536050b-40ab-1ec4-d325-e59bb3a92e73@ti.com>
 <20181121101121.7rhe2hz2mnmc72cu@flea>
From: Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <20c0fd85-95f6-9849-c10b-998a1e0f527d@ti.com>
Date: Wed, 21 Nov 2018 15:59:43 +0530
MIME-Version: 1.0
In-Reply-To: <20181121101121.7rhe2hz2mnmc72cu@flea>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On 21/11/18 3:41 PM, Maxime Ripard wrote:
> Hi Kishon,
> 
> On Tue, Nov 20, 2018 at 11:02:34AM +0530, Kishon Vijay Abraham I wrote:
>>>> +static int cdns_dphy_config_from_opts(struct phy *phy,
>>>> +				      struct phy_configure_opts_mipi_dphy *opts,
>>>> +				      struct cdns_dphy_cfg *cfg)
>>>> +{
>>>> +	struct cdns_dphy *dphy = phy_get_drvdata(phy);
>>>> +	unsigned int dsi_hfp_ext = 0;
>>>> +	int ret;
>>>> +
>>>> +	ret = phy_mipi_dphy_config_validate(opts);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	ret = cdns_dsi_get_dphy_pll_cfg(dphy, cfg,
>>>> +					opts, &dsi_hfp_ext);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	opts->wakeup = cdns_dphy_get_wakeup_time_ns(dphy);
>>
>> Is the wakeup populated here used by the consumer driver?
> 
> It's supposed to, if it can yes.

But I guess right now it's not using. I'm thinking the usefulness of validate
callback (only from this series point of view). Why should a consumer driver
invoke validate if it doesn't intend to configure the PHY?

The 3 steps required are
	* The consumer driver gets the default config
	* The consumer driver changes some of the configuration and
	* The consumer driver invokes phy configure callback.

phy_configure anyways can validate the config before actually configuring the phy.

Thanks
Kishon
