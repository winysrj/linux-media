Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3DZVHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 17:07:52 -0400
Date: Fri, 26 Apr 2013 23:07:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v9 02/20] V4L2: support asynchronous subdevice registration
In-Reply-To: <20130426084422.GB16843@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1304262302500.5698@axis700.grange>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
 <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
 <20130426084422.GB16843@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha

On Fri, 26 Apr 2013, Sascha Hauer wrote:

> Hi Guennadi,
> 
> On Fri, Apr 12, 2013 at 05:40:22PM +0200, Guennadi Liakhovetski wrote:
> > +
> > +static bool match_i2c(struct device *dev, struct v4l2_async_hw_info *hw_dev)
> > +{
> > +	struct i2c_client *client = i2c_verify_client(dev);
> > +	return client &&
> > +		hw_dev->bus_type == V4L2_ASYNC_BUS_I2C &&
> > +		hw_dev->match.i2c.adapter_id == client->adapter->nr &&
> > +		hw_dev->match.i2c.address == client->addr;
> > +}
> > +
> > +static bool match_platform(struct device *dev, struct v4l2_async_hw_info *hw_dev)
> > +{
> > +	return hw_dev->bus_type == V4L2_ASYNC_BUS_PLATFORM &&
> > +		!strcmp(hw_dev->match.platform.name, dev_name(dev));
> > +}
> 
> I recently solved the same problem without being aware of your series.
> 
> How about registering the asynchronous subdevices with a 'void *key'
> instead of a bus specific matching function?

Personally I don't think adding dummy data is a good idea. You can of 
course use pointers to real data, even just to the device object itself. 
But I really was trying to unbind host and subdevice devices, similar how 
clocks or pinmux entries or regulators are matched to their users. In the 
DT case we already use phandles to bind entities / pads / in whatever 
terms you prefer to think;-)

Thanks
Guennadi

> With platform based devices
> the key could simply be a pointer to some dummy value which is used by
> both the subdevice and the device in its platform_data. for the shmobile
> patch you have later in this series this would become:
> 
> static int csi2_r2025sd_key;
> 
> static struct r2025sd_platform_data r2025sd_pdata {
> 	.key = &csi2_r2025sd_key,
> };
> 
> static struct i2c_board_info i2c1_devices[] = {
> 	{
> 		I2C_BOARD_INFO("r2025sd", 0x32),
> 		.platform_data = &r2025sd_pdata,
> 	},
> };
> 
> static struct sh_csi2_pdata csi2_info = {
>  	.flags		= SH_CSI2_ECC | SH_CSI2_CRC,
> 	.key = &csi2_r2025sd_key,
> };
> 
> For devicetree based devices the pointer to the subdevices devicenode
> could be used as key.
> 
> I think this would make your matching code easier and also bus type
> agnostic.
> 
> Sascha
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
