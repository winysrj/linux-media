Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56453 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbdGRJHw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 05:07:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: pavel@ucw.cz, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/7] omap3isp: Parse CSI1 configuration from the device tree
Date: Tue, 18 Jul 2017 12:07:59 +0300
Message-ID: <1746594.69D4hAlVNH@avalon>
In-Reply-To: <20170717220116.17886-3-sakari.ailus@linux.intel.com>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com> <20170717220116.17886-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 18 Jul 2017 01:01:11 Sakari Ailus wrote:
> From: Pavel Machek <pavel@ucw.cz>
> 
> Add support for parsing CSI1 configuration.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/omap3isp/isp.c      | 106 ++++++++++++++++++--------
>  drivers/media/platform/omap3isp/omap3isp.h |   1 +
>  2 files changed, 80 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 441eba1e02eb..80ed5a5f862a
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2017,6 +2017,7 @@ static int isp_fwnode_parse(struct device *dev, struct
> fwnode_handle *fwnode, struct v4l2_fwnode_endpoint vep;
>  	unsigned int i;
>  	int ret;
> +	bool csi1 = false;
> 
>  	ret = v4l2_fwnode_endpoint_parse(fwnode, &vep);
>  	if (ret)
> @@ -2045,41 +2046,92 @@ static int isp_fwnode_parse(struct device *dev,
> struct fwnode_handle *fwnode,
> 
>  	case ISP_OF_PHY_CSIPHY1:
>  	case ISP_OF_PHY_CSIPHY2:
> -		/* FIXME: always assume CSI-2 for now. */
> +		switch (vep.bus_type) {
> +		case V4L2_MBUS_CCP2:
> +		case V4L2_MBUS_CSI1:
> +			dev_dbg(dev, "csi1/ccp2 configuration\n");

Nitpicking, I would write it "CSI1/CCP2".

> +			csi1 = true;
> +			break;
> +		case V4L2_MBUS_CSI2:
> +			dev_dbg(dev, "csi2 configuration\n");

And "CSI2" here.

> +			csi1 = false;
> +			break;
> +		default:
> +			dev_err(dev, "unsupported bus type %u\n",
> +				vep.bus_type);
> +			return -EINVAL;
> +		}
> +
>  		switch (vep.base.port) {
>  		case ISP_OF_PHY_CSIPHY1:
> -			buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
> +			if (csi1)
> +				buscfg->interface = ISP_INTERFACE_CCP2B_PHY1;
> +			else
> +				buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
>  			break;
>  		case ISP_OF_PHY_CSIPHY2:
> -			buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
> +			if (csi1)
> +				buscfg->interface = ISP_INTERFACE_CCP2B_PHY2;
> +			else
> +				buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
>  			break;
>  		}
> -		buscfg->bus.csi2.lanecfg.clk.pos = 
vep.bus.mipi_csi2.clock_lane;
> -		buscfg->bus.csi2.lanecfg.clk.pol =
> -			vep.bus.mipi_csi2.lane_polarities[0];
> -		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> -			buscfg->bus.csi2.lanecfg.clk.pol,
> -			buscfg->bus.csi2.lanecfg.clk.pos);
> -
> -		buscfg->bus.csi2.num_data_lanes =
> -			vep.bus.mipi_csi2.num_data_lanes;
> -
> -		for (i = 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
> -			buscfg->bus.csi2.lanecfg.data[i].pos =
> -				vep.bus.mipi_csi2.data_lanes[i];
> -			buscfg->bus.csi2.lanecfg.data[i].pol =
> -				vep.bus.mipi_csi2.lane_polarities[i + 1];
> +		if (csi1) {
> +			buscfg->bus.ccp2.lanecfg.clk.pos =
> +				vep.bus.mipi_csi1.clock_lane;
> +			buscfg->bus.ccp2.lanecfg.clk.pol =
> +				vep.bus.mipi_csi1.lane_polarity[0];
> +			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> +				buscfg->bus.ccp2.lanecfg.clk.pol,
> +				buscfg->bus.ccp2.lanecfg.clk.pos);
> +
> +			buscfg->bus.ccp2.lanecfg.data[0].pos =
> +				vep.bus.mipi_csi1.data_lane;
> +			buscfg->bus.ccp2.lanecfg.data[0].pol =
> +				vep.bus.mipi_csi1.lane_polarity[1];
> +
>  			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> -				buscfg->bus.csi2.lanecfg.data[i].pol,
> -				buscfg->bus.csi2.lanecfg.data[i].pos);
> +				buscfg->bus.ccp2.lanecfg.data[0].pol,
> +				buscfg->bus.ccp2.lanecfg.data[0].pos);
> +
> +			buscfg->bus.ccp2.strobe_clk_pol =
> +				vep.bus.mipi_csi1.clock_inv;
> +			buscfg->bus.ccp2.phy_layer = vep.bus.mipi_csi1.strobe;
> +			buscfg->bus.ccp2.ccp2_mode =
> +				vep.bus_type == V4L2_MBUS_CCP2;
> +			buscfg->bus.ccp2.vp_clk_pol = 1;
> +
> +			buscfg->bus.ccp2.crc = 1;
> +		} else {
> +			buscfg->bus.csi2.lanecfg.clk.pos =
> +				vep.bus.mipi_csi2.clock_lane;
> +			buscfg->bus.csi2.lanecfg.clk.pol =
> +				vep.bus.mipi_csi2.lane_polarities[0];
> +			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> +				buscfg->bus.csi2.lanecfg.clk.pol,
> +				buscfg->bus.csi2.lanecfg.clk.pos);
> +
> +			buscfg->bus.csi2.num_data_lanes =
> +				vep.bus.mipi_csi2.num_data_lanes;
> +
> +			for (i = 0; i < buscfg->bus.csi2.num_data_lanes; i++) 
{
> +				buscfg->bus.csi2.lanecfg.data[i].pos =
> +					vep.bus.mipi_csi2.data_lanes[i];
> +				buscfg->bus.csi2.lanecfg.data[i].pol =
> +					vep.bus.mipi_csi2.lane_polarities[i + 
1];
> +				dev_dbg(dev,
> +					"data lane %u polarity %u, pos %u\n", 
i,
> +					buscfg->bus.csi2.lanecfg.data[i].pol,
> +					buscfg->bus.csi2.lanecfg.data[i].pos);
> +			}
> +			/*
> +			 * FIXME: now we assume the CRC is always there.
> +			 * Implement a way to obtain this information from the
> +			 * sensor. Frame descriptors, perhaps?
> +			 */
> +

Extra blank line. I would move it right before the comment.

With these small issues fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +			buscfg->bus.csi2.crc = 1;
>  		}
> -
> -		/*
> -		 * FIXME: now we assume the CRC is always there.
> -		 * Implement a way to obtain this information from the
> -		 * sensor. Frame descriptors, perhaps?
> -		 */
> -		buscfg->bus.csi2.crc = 1;
>  		break;
> 
>  	default:
> diff --git a/drivers/media/platform/omap3isp/omap3isp.h
> b/drivers/media/platform/omap3isp/omap3isp.h index
> 3c26f9a3f508..672a9cf5aa4d 100644
> --- a/drivers/media/platform/omap3isp/omap3isp.h
> +++ b/drivers/media/platform/omap3isp/omap3isp.h
> @@ -108,6 +108,7 @@ struct isp_ccp2_cfg {
>  	unsigned int ccp2_mode:1;
>  	unsigned int phy_layer:1;
>  	unsigned int vpclk_div:2;
> +	unsigned int vp_clk_pol:1;
>  	struct isp_csiphy_lanes_cfg lanecfg;
>  };

-- 
Regards,

Laurent Pinchart
