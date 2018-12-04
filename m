Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelv0142.ext.ti.com ([198.47.23.249]:36504 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbeLDF7j (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 00:59:39 -0500
Subject: Re: [PATCH v2 4/9] phy: dphy: Add configuration helpers
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
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
 <4d44460c4ecbd47f4cbd9141c6bf2632b6c21e1e.1541516029.git-series.maxime.ripard@bootlin.com>
 <20181119134357.743nskpkqqfkrjux@valkosipuli.retiisi.org.uk>
 <20181121093353.p3gnj4ebel4h4ya4@flea>
From: Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <01829f2e-871e-cdea-afab-0ae1360464a4@ti.com>
Date: Tue, 4 Dec 2018 11:28:37 +0530
MIME-Version: 1.0
In-Reply-To: <20181121093353.p3gnj4ebel4h4ya4@flea>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On 21/11/18 3:03 PM, Maxime Ripard wrote:
> Hi Sakari,
> 
> Thanks for your review.
> 
> On Mon, Nov 19, 2018 at 03:43:57PM +0200, Sakari Ailus wrote:
>>> +/*
>>> + * Minimum D-PHY timings based on MIPI D-PHY specification. Derived
>>> + * from the valid ranges specified in Section 6.9, Table 14, Page 41
>>> + * of the D-PHY specification (v2.1).
>>
>> I assume these values are compliant with the earlier spec releases.
> 
> I have access to the versions 1.2 and 2.1 of the spec and as far as I
> can tell, they match here. I can't really say for other releases, but
> I wouldn't expect any changes (and it can always be adjusted later on
> if needed).
> 
>>> + */
>>> +int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
>>
>> How about using the bus frequency instead of the pixel clock? Chances are
>> that the caller already has that information, instead of calculating it
>> here?
> 
> I went for the pixel clock since it's something that all drivers will
> have access too without any computation. The bus frequency can be
> available as well in v4l2, but won't be in DRM, and that would require
> for all drivers to duplicate that computation, which doesn't seem like
> a good choice.
> 
>>> +				     unsigned int bpp,
>>> +				     unsigned int lanes,
>>> +				     struct phy_configure_opts_mipi_dphy *cfg)
>>> +{
>>> +	unsigned long hs_clk_rate;
>>> +	unsigned long ui;
>>> +
>>> +	if (!cfg)
>>> +		return -EINVAL;
>>> +
>>> +	hs_clk_rate = pixel_clock * bpp / lanes;
>>> +	ui = DIV_ROUND_UP(NSEC_PER_SEC, hs_clk_rate);
>>
>> Nanoseconds may not be precise enough for practical computations on these
>> values. At 1 GHz, this ends up being precisely 1. At least Intel hardware
>> has some more precision, I presume others do, too. How about using
>> picoseconds instead?
> 
> Sounds like a good idea.

Would you be fixing this? Or this can be a later patch?

Thanks
Kishon
> 
>>> +
>>> +	cfg->clk_miss = 0;
>>> +	cfg->clk_post = 60 + 52 * ui;
>>> +	cfg->clk_pre = 8;
>>> +	cfg->clk_prepare = 38;
>>> +	cfg->clk_settle = 95;
>>> +	cfg->clk_term_en = 0;
>>> +	cfg->clk_trail = 60;
>>> +	cfg->clk_zero = 262;
>>> +	cfg->d_term_en = 0;
>>> +	cfg->eot = 0;
>>> +	cfg->hs_exit = 100;
>>> +	cfg->hs_prepare = 40 + 4 * ui;
>>> +	cfg->hs_zero = 105 + 6 * ui;
>>> +	cfg->hs_settle = 85 + 6 * ui;
>>> +	cfg->hs_skip = 40;
>>> +
>>> +	/*
>>> +	 * The MIPI D-PHY specification (Section 6.9, v1.2, Table 14, Page 40)
>>> +	 * contains this formula as:
>>> +	 *
>>> +	 *     T_HS-TRAIL = max(n * 8 * ui, 60 + n * 4 * ui)
>>> +	 *
>>> +	 * where n = 1 for forward-direction HS mode and n = 4 for reverse-
>>> +	 * direction HS mode. There's only one setting and this function does
>>> +	 * not parameterize on anything other that ui, so this code will
>>> +	 * assumes that reverse-direction HS mode is supported and uses n = 4.
>>> +	 */
>>> +	cfg->hs_trail = max(4 * 8 * ui, 60 + 4 * 4 * ui);
>>> +
>>> +	cfg->init = 100000;
>>> +	cfg->lpx = 60;
>>> +	cfg->ta_get = 5 * cfg->lpx;
>>> +	cfg->ta_go = 4 * cfg->lpx;
>>> +	cfg->ta_sure = 2 * cfg->lpx;
>>> +	cfg->wakeup = 1000000;
>>> +
>>> +	cfg->hs_clk_rate = hs_clk_rate;
>>
>> How about the LP clock?
>>
>> Frankly, I have worked with MIPI CSI-2 hardware soon a decade, and the very
>> few cases where software has needed to deal with these values has been in
>> form of defaults for a receiver, mostly limiting to clk_settle,
>> clk_term_en, d_term_en as well as hs_settle. On some hardware, the data
>> lane specific values can be at least in theory configured separately on
>> different lanes (but perhaps we could ignore that now).
>>
>> That doesn't say that it'd be useless to convey these values to the PHY
>> though. What I'm a little worried about though is what could be the effect
>> of adding support for this for existing drivers? If you have a new driver,
>> then there is no chance of regressions.
>>
>> I can't help noticing that many of the above values end up being unused in
>> the rest of the patches in the set. I guess that's ok, they come from the
>> standard anyway and some hardware may need them to be configured.
> 
> In order to get these parameters, I went through all the MIPI-DSI and
> MIPI-CSI drivers currently in the tree that could be converted, and
> looked at which parameters they needed to exchange with their PHY.
> 
> I made a summary to Kishon in the previous iteration here:
> https://lwn.net/ml/linux-media/20180919121436.ztjnxofe66quddeq@flea/
> 
> So it looks like the set of parameters on the MIPI-CSI side is indeed
> pretty limited, it really isn't for MIPI-DSI, and the whole point here
> is to support both :/
> 
>> Then there's the question of where should these values originate from.
>> Some drivers appear to have a need to obtain one of these values via
>> firmware, see Documentation/devicetree/bindings/media/samsung-mipi-csis.txt
>> . I presume the defaults should be applicable to most cases, and specific
>> values would need to be defined in the firmware. That means that the
>> defaults have effectively the property of firmware API, meaning that they
>> effectively can never be changed. That suggests we should be pretty sure
>> the defaults are something that should work for the widest possible set of
>> the hardware.
> 
> That function here is made to provide the spec default for those
> values. Any driver is free to change those defaults, as long as they
> remain within the spec boundaries of course. And I'd say that how the
> drivers need to get those non-default values would be driver specific,
> it shouldn't really impact the API here.
> 
> Thanks!
> Maxime
> 
