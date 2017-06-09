Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43625 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751677AbdFINQQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 09:16:16 -0400
Message-ID: <1497014135.20356.12.camel@pengutronix.de>
Subject: Re: [PATCH v8 19/34] media: Add i.MX media core driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Date: Fri, 09 Jun 2017 15:15:35 +0200
In-Reply-To: <1496860453-6282-20-git-send-email-steve_longerbeam@mentor.com>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
         <1496860453-6282-20-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-06-07 at 11:33 -0700, Steve Longerbeam wrote:
> Add the core media driver for i.MX SOC.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> 
> Switch from the v4l2_of_ APIs to the v4l2_fwnode_ APIs.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Add the bayer formats to imx-media's list of supported pixel and bus
> formats.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
[...]
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> new file mode 100644
> index 0000000..da694f6
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -0,0 +1,666 @@
[...]
> +/*
> + * adds given video device to given imx-media source pad vdev list.
> + * Continues upstream from the pad entity's sink pads.
> + */
> +static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
> +				     struct imx_media_video_dev *vdev,
> +				     struct media_pad *srcpad)
> +{
> +	struct media_entity *entity = srcpad->entity;
> +	struct imx_media_subdev *imxsd;
> +	struct imx_media_pad *imxpad;
> +	struct media_link *link;
> +	struct v4l2_subdev *sd;
> +	int i, vdev_idx, ret;
> +
> +	if (!is_media_entity_v4l2_subdev(entity))
> +		return -EINVAL;

Could we make this return 0, to just skip non-v4l2_subdev entities?
Currently, imx_media_probe_complete silently fails with this -EINVAL if
there is a tvp5150 connected due to the separate media entities that the
tvp5150 driver creates for the input connectors (Composite0, for
example).

regards
Philipp
