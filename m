Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54594 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405697AbeKTD3b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 22:29:31 -0500
Date: Mon, 19 Nov 2018 19:05:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
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
Subject: Re: [PATCH v2 6/9] phy: Move Allwinner A31 D-PHY driver to
 drivers/phy/
Message-ID: <20181119170511.4yhvpfa7uiybgvty@valkosipuli.retiisi.org.uk>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <c3fe50ce10d514c15eb4b3e4abec94a7ef15538c.1541516029.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3fe50ce10d514c15eb4b3e4abec94a7ef15538c.1541516029.git-series.maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Tue, Nov 06, 2018 at 03:54:18PM +0100, Maxime Ripard wrote:
> Now that our MIPI D-PHY driver has been converted to the phy framework,
> let's move it into the drivers/phy directory.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/gpu/drm/sun4i/Kconfig               |  10 +-
>  drivers/gpu/drm/sun4i/Makefile              |   1 +-
>  drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c     | 318 +---------------------
>  drivers/phy/allwinner/Kconfig               |  12 +-
>  drivers/phy/allwinner/Makefile              |   1 +-
>  drivers/phy/allwinner/phy-sun6i-mipi-dphy.c | 318 +++++++++++++++++++++-
>  6 files changed, 332 insertions(+), 328 deletions(-)
>  delete mode 100644 drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
>  create mode 100644 drivers/phy/allwinner/phy-sun6i-mipi-dphy.c

Could you use git format-patch -M option on the next time, please?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
