Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42395 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754480AbdDFJoT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 05:44:19 -0400
Message-ID: <1491471814.2392.11.camel@pengutronix.de>
Subject: Re: [PATCH v6 19/39] media: Add i.MX media core driver
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
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 06 Apr 2017 11:43:34 +0200
In-Reply-To: <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
         <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-03-27 at 17:40 -0700, Steve Longerbeam wrote:
> Add the core media driver for i.MX SOC.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
[...]
> diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
> new file mode 100644
> index 0000000..b383be4
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-of.c
> @@ -0,0 +1,267 @@
[...]
> +/*
> + * find the remote device node and remote port id (remote pad #)
> + * given local endpoint node
> + */
> +static void of_get_remote_pad(struct device_node *epnode,
> +			      struct device_node **remote_node,
> +			      int *remote_pad)
> +{
> +	struct device_node *rp, *rpp;
> +	struct device_node *remote;
> +
> +	rp = of_graph_get_remote_port(epnode);
> +	rpp = of_graph_get_remote_port_parent(epnode);
> +
> +	if (of_device_is_compatible(rpp, "fsl,imx6q-ipu")) {
> +		/* the remote is one of the CSI ports */
> +		remote = rp;
> +		*remote_pad = 0;
> +		of_node_put(rpp);
> +	} else {
> +		remote = rpp;
> +		of_property_read_u32(rp, "reg", remote_pad);

If this fails because there is no reg property, *remote_pad will keep
the previous value. It should be set to 0 in this case.

----------8<----------
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -85,7 +85,9 @@ static void of_get_remote_pad(struct device_node *epnode,
                of_node_put(rpp);
        } else {
                remote = rpp;
-               of_property_read_u32(rp, "reg", remote_pad);
+               /* FIXME port number and pad index are not the same */
+               if (of_property_read_u32(rp, "reg", remote_pad))
+                       *remote_pad = 0;
                of_node_put(rp);
        }
 
---------->8----------

regards
Philipp
