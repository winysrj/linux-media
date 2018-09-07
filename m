Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39512 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729773AbeIGTHe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 15:07:34 -0400
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
Subject: Re: [PATCH 04/10] phy: dphy: Add configuration helpers
Date: Fri, 07 Sep 2018 17:26:29 +0300
Message-ID: <1923627.Ifno3EcWVN@avalon>
In-Reply-To: <20180907133739.6lvlw7wsdk4ffeua@flea>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com> <3617916.Vq2Smf1hnZ@avalon> <20180907133739.6lvlw7wsdk4ffeua@flea>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Friday, 7 September 2018 16:37:39 EEST Maxime Ripard wrote:
> On Wed, Sep 05, 2018 at 04:46:05PM +0300, Laurent Pinchart wrote:
> > On Wednesday, 5 September 2018 12:16:35 EEST Maxime Ripard wrote:
> >> The MIPI D-PHY spec defines default values and boundaries for most of
> >> the parameters it defines. Introduce helpers to help drivers get
> >> meaningful values based on their current parameters, and validate the
> >> boundaries of these parameters if needed.
> >> 
> >> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> >> ---
> >> 
> >>  drivers/phy/Kconfig               |   8 ++-
> >>  drivers/phy/Makefile              |   1 +-
> >>  drivers/phy/phy-core-mipi-dphy.c  | 160 ++++++++++++++++++++++++++++++-
> >>  include/linux/phy/phy-mipi-dphy.h |   6 +-
> >>  4 files changed, 175 insertions(+)
> >>  create mode 100644 drivers/phy/phy-core-mipi-dphy.c

[snip]

> >> diff --git a/drivers/phy/phy-core-mipi-dphy.c
> >> b/drivers/phy/phy-core-mipi-dphy.c new file mode 100644
> >> index 000000000000..6c1ddc7734a2
> >> --- /dev/null
> >> +++ b/drivers/phy/phy-core-mipi-dphy.c
> >> @@ -0,0 +1,160 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +/*
> >> + * Copyright (C) 2013 NVIDIA Corporation
> >> + * Copyright (C) 2018 Cadence Design Systems Inc.
> >> + */
> >> +
> >> +#include <linux/errno.h>
> >> +#include <linux/export.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/time64.h>
> >> +
> >> +#include <linux/phy/phy.h>
> >> +#include <linux/phy/phy-mipi-dphy.h>
> >> +
> >> +/*
> >> + * Default D-PHY timings based on MIPI D-PHY specification. Derived
> >> from the
> >> + * valid ranges specified in Section 6.9, Table 14, Page 40 of the
> >> D-PHY
> >> + * specification (v1.2) with minor adjustments.
> > 
> > Could you list those adjustments ?
> 
> I will. This was taken from the Tegra DSI driver, so I'm not sure what
> these are exactly, but that should be addressed.
> 
> >> + */
> >> +int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
> >> +				     unsigned int bpp,
> >> +				     unsigned int lanes,
> >> +				     struct phy_configure_opts_mipi_dphy *cfg)
> >> +{
> >> +	unsigned long hs_clk_rate;
> >> +	unsigned long ui;
> >> +
> >> +	if (!cfg)
> >> +		return -EINVAL;
> > 
> > Should we really expect cfg to be NULL ?
> 
> It avoids a kernel panic and it's not in a hot patch, so I'd say yes?

A few line below you divide by the lanes parameter without checking whether it 
is equal to 0 first, which would also cause issues.

I believe that invalid values in input parameters should only be handled 
explicitly when considered acceptable for the caller to pass such values. In 
this case a NULL cfg pointer is a bug in the caller, which would get noticed 
during development if the kernel panics.

-- 
Regards,

Laurent Pinchart
