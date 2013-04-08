Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59109 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935319Ab3DHKxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:53:55 -0400
Date: Mon, 8 Apr 2013 12:53:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v6 3/7] media: soc-camera: switch I2C subdevice drivers
 to use v4l2-clk
In-Reply-To: <3250836.ovo27np6Xb@avalon>
Message-ID: <Pine.LNX.4.64.1304081250200.29945@axis700.grange>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de>
 <1363382873-20077-4-git-send-email-g.liakhovetski@gmx.de> <3250836.ovo27np6Xb@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 Mar 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thanks for the patch.
> 
> On Friday 15 March 2013 22:27:49 Guennadi Liakhovetski wrote:
> > Instead of centrally enabling and disabling subdevice master clocks in
> > soc-camera core, let subdevice drivers do that themselves, using the
> > V4L2 clock API and soc-camera convenience wrappers.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> [snip]
> 
> > diff --git a/drivers/media/platform/soc_camera/soc_camera.c
> > b/drivers/media/platform/soc_camera/soc_camera.c index 4e626a6..01cd5a0
> > 100644
> > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/vmalloc.h>
> > 
> >  #include <media/soc_camera.h>
> > +#include <media/v4l2-clk.h>
> >  #include <media/v4l2-common.h>
> >  #include <media/v4l2-ioctl.h>
> >  #include <media/v4l2-dev.h>
> > @@ -50,13 +51,19 @@ static LIST_HEAD(hosts);
> >  static LIST_HEAD(devices);
> >  static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
> > 
> > -int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc
> > *ssdd)
> > +int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc
> > *ssdd,
> > +			struct v4l2_clk *clk)
> >  {
> > -	int ret = regulator_bulk_enable(ssdd->num_regulators,
> > +	int ret = clk ? v4l2_clk_enable(clk) : 0;
> > +	if (ret < 0) {
> > +		dev_err(dev, "Cannot enable clock\n");
> > +		return ret;
> > +	}
> 
> Will that work for all devices ? Aren't there devices that would need the 
> clock to be turned on after the power supply is stable ?

Swapping the order would be a functionality change. Let's not do that 
unless proven to be needed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
