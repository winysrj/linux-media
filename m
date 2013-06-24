Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41173 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3FXKpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 06:45:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L2: add documentation for V4L2 clock helpers and asynchronous probing
Date: Mon, 24 Jun 2013 12:45:21 +0200
Message-ID: <1734874.uLI0ndNzZS@avalon>
In-Reply-To: <Pine.LNX.4.64.1306241051060.19735@axis700.grange>
References: <Pine.LNX.4.64.1306170801590.22409@axis700.grange> <3036701.8xleOKapCa@avalon> <Pine.LNX.4.64.1306241051060.19735@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 24 June 2013 10:53:35 Guennadi Liakhovetski wrote:
> On Mon, 17 Jun 2013, Laurent Pinchart wrote:
> 
> [snip]
> 
> > > +drivers. 
> > > +
> > > +Bridge drivers in turn have to register a notifier object with an array
> > > +of subdevice descriptors, that the bridge device needs for its
> > > +operation. This
> >
> > s/descriptors,/descriptors/
> > 
> > > +is performed using the v4l2_async_notifier_register() call. To
> > > +unregister the notifier the driver has to call
> > > +v4l2_async_notifier_unregister(). The
> > > +former of the two functions takes two arguments: a pointer to struct
> > > +v4l2_device and a pointer to struct v4l2_async_notifier. The latter
> > > +contains a pointer to an array of pointers to subdevice descriptors of
> > > +type struct v4l2_async_subdev type.
> > 
> > Isn't it the other way around ?
> 
> I don't think I see anything above, that needs to be swapped. What exactly
> do you mean?

My bad. I got confused by "the latter" (which should be "the later" ;-)) and 
thought it was referring to the later of the two functions, given that the 
previous sentence starts with "the former of the two functions".

Maybe s/The format of the two functions/The first function/ and s/The 
latter/The second structure/ ?

-- 
Regards,

Laurent Pinchart

