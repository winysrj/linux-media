Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37060 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751364AbdB0UzK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 15:55:10 -0500
Date: Mon, 27 Feb 2017 22:54:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH 1/4] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170227205420.GF16975@valkosipuli.retiisi.org.uk>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225221255.GA6411@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170225221255.GA6411@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Please find my comments below.

On Sat, Feb 25, 2017 at 11:12:55PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > On Mon 2017-02-20 15:56:36, Sakari Ailus wrote:
> > > > On Mon, Feb 20, 2017 at 03:09:13PM +0200, Sakari Ailus wrote:
> > > > > I've tested ACPI, will test DT soon...
> > > > 
> > > > DT case works, too (Nokia N9).
> > > 
> > > Hmm. Good to know. Now to figure out how to get N900 case to work...
> > > 
> > > AFAICT N9 has CSI2, not CSI1 support, right? Some of the core changes
> > > seem to be in, so I'll need to figure out which, and will still need
> > > omap3isp modifications...
> > 
> > Indeed, I've only tested for CSI-2 as I have no functional CSI-1 devices.
> > 
> > It's essentially the functionality in the four patches. The data-lane and
> > clock-name properties have been renamed as data-lanes and clock-lanes (i.e.
> > plural) to match the property documentation.
> 
> Yes, it seems to work.
> 
> Here's a patch. It has checkpatch issues, I can fix them.  More
> support is needed on the ispcsiphy.c side... Could you take (fixed)
> version of this to your fwnode branch?
> 
> Thanks,
> 									Pavel
> 
> 
> 
> 
> ---
> 
> omap3isp: add support for CSI1 bus
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>     
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 245225a..4b10cfe 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2032,6 +2034,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwn,
>  	struct v4l2_fwnode_endpoint vfwn;
>  	unsigned int i;
>  	int ret;
> +	int csi1 = 0;
>  
>  	ret = v4l2_fwnode_endpoint_parse(fwn, &vfwn);
>  	if (ret)
> @@ -2059,38 +2062,82 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwn,
>  
>  	case ISP_OF_PHY_CSIPHY1:
>  	case ISP_OF_PHY_CSIPHY2:
> -		/* FIXME: always assume CSI-2 for now. */
> +		switch (vfwn.bus_type) {
> +		case V4L2_MBUS_CSI2:
> +			dev_dbg(dev, "csi2 configuration\n");
> +			csi1 = 0;
> +			break;
> +		case V4L2_MBUS_CCP2:
> +		case V4L2_MBUS_CSI1:
> +			dev_dbg(dev, "csi1 configuration\n");
> +			csi1 = 1;
> +			break;
> +		default:
> +			dev_err(dev, "unkonwn bus type\n");
> +		}
> +
>  		switch (vfwn.base.port) {
>  		case ISP_OF_PHY_CSIPHY1:
> -			buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
> +			if (csi1)

You could compare vfwn.bus_type == V4L2_MBUS_CSI2 for this. But if you
choose the local variable, please make it bool instead.

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
> +		default:
> +			dev_err(dev, "bad port\n");
>  		}
> -		buscfg->bus.csi2.lanecfg.clk.pos = vfwn.bus.mipi_csi2.clock_lane;
> -		buscfg->bus.csi2.lanecfg.clk.pol =
> -			vfwn.bus.mipi_csi2.lane_polarities[0];
> -		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> -			buscfg->bus.csi2.lanecfg.clk.pol,
> -			buscfg->bus.csi2.lanecfg.clk.pos);
> -
> -		for (i = 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
> -			buscfg->bus.csi2.lanecfg.data[i].pos =
> -				vfwn.bus.mipi_csi2.data_lanes[i];
> -			buscfg->bus.csi2.lanecfg.data[i].pol =
> -				vfwn.bus.mipi_csi2.lane_polarities[i + 1];
> +		if (csi1) {
> +			buscfg->bus.ccp2.lanecfg.clk.pos = vfwn.bus.mipi_csi1.clock_lane;

Wrap after "="?

> +			buscfg->bus.ccp2.lanecfg.clk.pol =
> +				vfwn.bus.mipi_csi1.lane_polarity[0];
> +			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> +				buscfg->bus.ccp2.lanecfg.clk.pol,
> +				buscfg->bus.ccp2.lanecfg.clk.pos);
> +
> +			buscfg->bus.ccp2.lanecfg.data[0].pos = 1;

Shouldn't this be vfwn.bus.mipi_csi1.data_lane ?

> +			buscfg->bus.ccp2.lanecfg.data[0].pol = 0;

And this one is vfwn.bus.mipi_csi1.lane_polarity[1] .

> +
>  			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> -				buscfg->bus.csi2.lanecfg.data[i].pol,
> -				buscfg->bus.csi2.lanecfg.data[i].pos);
> +				buscfg->bus.ccp2.lanecfg.data[0].pol,
> +				buscfg->bus.ccp2.lanecfg.data[0].pos);
> +
> +			buscfg->bus.ccp2.strobe_clk_pol = vfwn.bus.mipi_csi1.clock_inv;
> +			buscfg->bus.ccp2.phy_layer = vfwn.bus.mipi_csi1.strobe;
> +			buscfg->bus.ccp2.ccp2_mode = vfwn.bus_type == V4L2_MBUS_CCP2;

The lines over 80 characters should be wrapped.

> +			buscfg->bus.ccp2.vp_clk_pol = 1;
> +			
> +			buscfg->bus.ccp2.crc = 1;		
> +		} else {
> +			buscfg->bus.csi2.lanecfg.clk.pos = vfwn.bus.mipi_csi2.clock_lane;
> +			buscfg->bus.csi2.lanecfg.clk.pol =
> +				vfwn.bus.mipi_csi2.lane_polarities[0];
> +			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> +				buscfg->bus.csi2.lanecfg.clk.pol,
> +				buscfg->bus.csi2.lanecfg.clk.pos);
> +
> +			for (i = 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
> +				buscfg->bus.csi2.lanecfg.data[i].pos =
> +					vfwn.bus.mipi_csi2.data_lanes[i];
> +				buscfg->bus.csi2.lanecfg.data[i].pol =
> +					vfwn.bus.mipi_csi2.lane_polarities[i + 1];
> +				dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> +					buscfg->bus.csi2.lanecfg.data[i].pol,
> +					buscfg->bus.csi2.lanecfg.data[i].pos);
> +			}
> +			/*
> +			 * FIXME: now we assume the CRC is always there.
> +			 * Implement a way to obtain this information from the
> +			 * sensor. Frame descriptors, perhaps?
> +			 */
> +
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
> 
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
