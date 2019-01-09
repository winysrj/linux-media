Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E65C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C9E4206B6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbfAIMkW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 07:40:22 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47518 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729919AbfAIMkV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 07:40:21 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 57F4C634C7F;
        Wed,  9 Jan 2019 14:39:02 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ghD8P-0002ZH-N5; Wed, 09 Jan 2019 14:39:01 +0200
Date:   Wed, 9 Jan 2019 14:39:01 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH v4 7/9] dt-bindings: phy: Move the Cadence D-PHY bindings
Message-ID: <20190109123901.u7oqb65rykanh543@valkosipuli.retiisi.org.uk>
References: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
 <0c38b838f08b741b5b24a65886134104c5bdc69a.1547026369.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c38b838f08b741b5b24a65886134104c5bdc69a.1547026369.git-series.maxime.ripard@bootlin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Maxime,

On Wed, Jan 09, 2019 at 10:33:24AM +0100, Maxime Ripard wrote:
> The Cadence D-PHY bindings was defined as part of the DSI block so far.
> However, since it's now going to be a separate driver, we need to move the
> binding to a file of its own.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Could you also send this to the devicetree list, please?

> ---
>  Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt | 21 +-------
>  Documentation/devicetree/bindings/phy/cdns,dphy.txt           | 20 +++++++-
>  2 files changed, 20 insertions(+), 21 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/cdns,dphy.txt
> 
> diff --git a/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt b/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt
> index f5725bb6c61c..525a4bfd8634 100644
> --- a/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt
> +++ b/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt
> @@ -31,28 +31,7 @@ Required subnodes:
>  - one subnode per DSI device connected on the DSI bus. Each DSI device should
>    contain a reg property encoding its virtual channel.
>  
> -Cadence DPHY
> -============
> -
> -Cadence DPHY block.
> -
> -Required properties:
> -- compatible: should be set to "cdns,dphy".
> -- reg: physical base address and length of the DPHY registers.
> -- clocks: DPHY reference clocks.
> -- clock-names: must contain "psm" and "pll_ref".
> -- #phy-cells: must be set to 0.
> -
> -
>  Example:
> -	dphy0: dphy@fd0e0000{
> -		compatible = "cdns,dphy";
> -		reg = <0x0 0xfd0e0000 0x0 0x1000>;
> -		clocks = <&psm_clk>, <&pll_ref_clk>;
> -		clock-names = "psm", "pll_ref";
> -		#phy-cells = <0>;
> -	};
> -
>  	dsi0: dsi@fd0c0000 {
>  		compatible = "cdns,dsi";
>  		reg = <0x0 0xfd0c0000 0x0 0x1000>;
> diff --git a/Documentation/devicetree/bindings/phy/cdns,dphy.txt b/Documentation/devicetree/bindings/phy/cdns,dphy.txt
> new file mode 100644
> index 000000000000..1095bc4e72d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/cdns,dphy.txt
> @@ -0,0 +1,20 @@
> +Cadence DPHY
> +============
> +
> +Cadence DPHY block.
> +
> +Required properties:
> +- compatible: should be set to "cdns,dphy".
> +- reg: physical base address and length of the DPHY registers.
> +- clocks: DPHY reference clocks.
> +- clock-names: must contain "psm" and "pll_ref".
> +- #phy-cells: must be set to 0.
> +
> +Example:
> +	dphy0: dphy@fd0e0000{
> +		compatible = "cdns,dphy";
> +		reg = <0x0 0xfd0e0000 0x0 0x1000>;
> +		clocks = <&psm_clk>, <&pll_ref_clk>;
> +		clock-names = "psm", "pll_ref";
> +		#phy-cells = <0>;
> +	};
> -- 
> git-series 0.9.1

-- 
Sakari Ailus
