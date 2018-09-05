Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:57122 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbeIESSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 14:18:41 -0400
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
Subject: Re: [PATCH 09/10] phy: Add Cadence D-PHY support
Date: Wed, 05 Sep 2018 16:48:27 +0300
Message-ID: <1838745.9zNmGlpGXc@avalon>
In-Reply-To: <d50a5f0750647dcc09ef52411641b628161b362e.1536138624.git-series.maxime.ripard@bootlin.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com> <d50a5f0750647dcc09ef52411641b628161b362e.1536138624.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thank you for the patch.

On Wednesday, 5 September 2018 12:16:40 EEST Maxime Ripard wrote:
> Cadence has designed a D-PHY that can be used by the, currently in tree,
> DSI bridge (DRM), CSI Transceiver and CSI Receiver (v4l2) drivers.
> 
> Only the DSI driver has an ad-hoc driver for that phy at the moment, while
> the v4l2 drivers are completely missing any phy support. In order to make
> that phy support available to all these drivers, without having to
> duplicate that code three times, let's create a generic phy framework
> driver.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/phy/Kconfig             |   1 +-
>  drivers/phy/Makefile            |   1 +-
>  drivers/phy/cadence/Kconfig     |  13 +-
>  drivers/phy/cadence/Makefile    |   1 +-
>  drivers/phy/cadence/cdns-dphy.c | 499 +++++++++++++++++++++++++++++++++-

Should the DT bindings be split from Documentation/devicetree/bindings/
display/bridge/cdns,dsi.txt ?

>  5 files changed, 515 insertions(+)
>  create mode 100644 drivers/phy/cadence/Kconfig
>  create mode 100644 drivers/phy/cadence/Makefile
>  create mode 100644 drivers/phy/cadence/cdns-dphy.c

[snip]

-- 
Regards,

Laurent Pinchart
