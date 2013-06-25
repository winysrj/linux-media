Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3FYJXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 05:23:03 -0400
Date: Tue, 25 Jun 2013 11:22:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] V4L2: add documentation for V4L2 clock helpers and
 asynchronous probing
In-Reply-To: <51C8B2FC.8040200@gmail.com>
Message-ID: <Pine.LNX.4.64.1306251121030.30321@axis700.grange>
References: <Pine.LNX.4.64.1306241311420.19735@axis700.grange>
 <51C8B2FC.8040200@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Mon, 24 Jun 2013, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 06/24/2013 01:20 PM, Guennadi Liakhovetski wrote:
> > Add documentation for the V4L2 clock and V4L2 asynchronous probing APIs
> > to v4l2-framework.txt.
> > 
> > Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> > ---
> > 
> > v2: addressed comments by Hans and Laurent (thanks), including
> > (a) language clean up
> > (b) extended the V4L2 clock API section with an explanation, what special
> > requirements V4L2 has and a mention of it being temporary until CCF is
> > used by all
> > (c) added an explanation of the use of -EPROBE_DEFER
> 
> Looks pretty good.
> 
>  Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Thanks

> 
> Just one remark below...
> 
> >   Documentation/video4linux/v4l2-framework.txt |   73
> > +++++++++++++++++++++++++-
> >   1 files changed, 71 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/video4linux/v4l2-framework.txt
> > b/Documentation/video4linux/v4l2-framework.txt
> > index b5e6347..00a9d21 100644
> > --- a/Documentation/video4linux/v4l2-framework.txt
> > +++ b/Documentation/video4linux/v4l2-framework.txt
> > @@ -325,8 +325,27 @@ that width, height and the media bus pixel code are
> > equal on both source and
> >   sink of the link. Subdev drivers are also free to use this function to
> >   perform the checks mentioned above in addition to their own checks.
> > 
> > -A device (bridge) driver needs to register the v4l2_subdev with the
> > -v4l2_device:
> > +There are currently two ways to register subdevices with the V4L2 core. The
> > +first (traditional) possibility is to have subdevices registered by bridge
> > +drivers. This can be done when the bridge driver has the complete
> > information
> > +about subdevices connected to it and knows exactly when to register them.
> > This
> > +is typically the case for internal subdevices, like video data processing
> > units
> > +within SoCs or complex PCI(e) boards, camera sensors in USB cameras or
> > connected
> > +to SoCs, which pass information about them to bridge drivers, usually in
> > their
> > +platform data.
> > +
> > +There are however also situations where subdevices have to be registered
> > +asynchronously to bridge devices. An example of such a configuration is a
> > Device
> > +Tree based systems where information about subdevices is made available to
> > the
> 
> I think you need to substitute "is a Device Tree based systems" with either:
> "are Device Tree based systems" or
> "is a Device Tree based system".

Oops, sure, thanks for spotting, I'll s/systems/system/ when pushing this 
up.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
