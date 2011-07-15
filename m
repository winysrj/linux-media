Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46401 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1GONvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 09:51:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Teresa Gamez <T.Gamez@phytec.de>
Subject: Re: Migrate from soc_camera to v4l2
Date: Fri, 15 Jul 2011 15:51:44 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LBM <lbm9527@qq.com>, "linux-media" <linux-media@vger.kernel.org>
References: <tencent_0C81805C0261B60E5643A744@qq.com> <Pine.LNX.4.64.1107130902070.30737@axis700.grange> <1310737039.2366.394.camel@lws-gamez>
In-Reply-To: <1310737039.2366.394.camel@lws-gamez>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107151551.44802.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Teresa,

On Friday 15 July 2011 15:37:19 Teresa Gamez wrote:
> Am Mittwoch, den 13.07.2011, 09:14 +0200 schrieb Guennadi Liakhovetski:
> > On Wed, 13 Jul 2011, LBM wrote:
> > > my dear Guennadi
> > > 
> > >      I'm wrong about that "v4l2-int-device",maybe it just "V4L2".
> > >      
> > >        Now i have a board of OMAP3530 and a cmos camera MT9M111,so i
> > >        want to get the image from the mt9m111.
> > >  
> > >  and ,I want to use the V4L2 API. But in the linux kernel 2.6.38,the
> > >  driver of the mt9m111 is  a soc_camera.I see some thing about how to
> > >  convert the soc_camera to V4L2,like "soc-camera: (partially) convert
> > >  to v4l2-(sub)dev API".
> > >  
> > >       Can you tell me how to migrate from soc_camera to v4l2,and
> > >      
> > >      or do you tell me some experience about that?
> > 
> > Currently there's no standard way to make a driver to work with both
> > soc-camera and (pure) v4l2-subdev APIs. It is being worked on:
> > 
> > http://www.spinics.net/lists/linux-media/msg34878.html
> > 
> > and, hopefully, beginning with the next kernel version 3.1 it will become
> > at least theoretically possible. For now you just have to hack the driver
> > yourself for your local uses by removing all soc-camera specific code and
> 
> > replacing it with your own glue, something along these lines:
> We are also interested in the support of the MT9M111 and MT9V022 for
> OMAP-4460/OMAP-4430/OMAP-3525. I have not taken a deeper look at it yet.
> But what do you mean by theoretically possible? Could it work out of the
> box? Or is there more work to do?

The OMAP4 has unfortunately no V4L2 driver, so OMAP4 support is pretty much 
impossible today. The situation might change, but unless someone is willing to 
fund a couple of developers to work on this full time, I don't expect a proper 
OMAP4 V4L2 driver before at least one year.

-- 
Regards,

Laurent Pinchart
