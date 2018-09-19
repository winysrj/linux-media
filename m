Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42984 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbeITAmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 20:42:32 -0400
MIME-Version: 1.0
In-Reply-To: <20180914224849.27173-6-lolivei@synopsys.com>
References: <20180914224849.27173-1-lolivei@synopsys.com> <20180914224849.27173-6-lolivei@synopsys.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 19 Sep 2018 16:03:13 -0300
Message-ID: <CAOMZO5BU1myguEppOH4FfB_wOGBuFjAzrNQ-eu1hYWthLHBAvA@mail.gmail.com>
Subject: Re: [PATCH 5/5] media: platform: dwc: Add MIPI CSI-2 controller driver
To: Luis Oliveira <Luis.Oliveira@synopsys.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        all-jpinto-org-pt02@synopsys.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thierry Reding <treding@nvidia.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luis,

On Fri, Sep 14, 2018 at 7:48 PM, Luis Oliveira
<Luis.Oliveira@synopsys.com> wrote:

> +++ b/drivers/media/platform/dwc/dw-csi-plat.c
> @@ -0,0 +1,508 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later

According to Documentation/process/license-rules.rst this should be:
// SPDX-License-Identifier: GPL-2.0+

> +static int
> +dw_mipi_csi_parse_dt(struct platform_device *pdev, struct mipi_csi_dev *dev)
> +{
> +       struct device_node *node = pdev->dev.of_node;
> +       struct v4l2_fwnode_endpoint endpoint;
> +       int ret = 0;

No need to assign ret to 0.

> +
> +       ret = of_property_read_u32(node, "snps,output-type", &dev->hw.output);

> --- /dev/null
> +++ b/drivers/media/platform/dwc/dw-csi-plat.h
> @@ -0,0 +1,76 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */

Same as before.

> diff --git a/drivers/media/platform/dwc/dw-mipi-csi.c b/drivers/media/platform/dwc/dw-mipi-csi.c
> new file mode 100644
> index 0000000..926b287
> --- /dev/null
> +++ b/drivers/media/platform/dwc/dw-mipi-csi.c
> @@ -0,0 +1,491 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later

Ditto.

> +void dw_mipi_csi_fill_timings(struct mipi_csi_dev *dev,
> +                          const struct v4l2_bt_timings *bt)
> +{
> +

No need for this empty line.

> +       if (bt == NULL)

> diff --git a/drivers/media/platform/dwc/dw-mipi-csi.h b/drivers/media/platform/dwc/dw-mipi-csi.h
> new file mode 100644
> index 0000000..eca0e48
> --- /dev/null
> +++ b/drivers/media/platform/dwc/dw-mipi-csi.h
> @@ -0,0 +1,202 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */

Ditto.
