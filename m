Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:57084 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbeIESQq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 14:16:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH 01/10] phy: Add MIPI D-PHY mode
Date: Wed, 05 Sep 2018 16:46:33 +0300
Message-ID: <2567966.N4s79vZLWV@avalon>
In-Reply-To: <00e3d5da1ca3c03ba60350c1cf78ab44693ff493.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com> <00e3d5da1ca3c03ba60350c1cf78ab44693ff493.1536138624.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thank you for the patch.

On Wednesday, 5 September 2018 12:16:32 EEST Maxime Ripard wrote:
> MIPI D-PHY is a MIPI standard meant mostly for display and cameras in
> embedded systems. Add a mode for it.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/linux/phy/phy.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index 9713aebdd348..9cba7fe16c23 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -40,6 +40,7 @@ enum phy_mode {
>  	PHY_MODE_10GKR,
>  	PHY_MODE_UFS_HS_A,
>  	PHY_MODE_UFS_HS_B,
> +	PHY_MODE_MIPI_DPHY,
>  };
> 
>  /**

-- 
Regards,

Laurent Pinchart
