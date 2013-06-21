Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51787 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945951Ab3FUU1C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 16:27:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] V4L2: add documentation for V4L2 clock helpers and asynchronous probing
Date: Fri, 21 Jun 2013 22:27:19 +0200
Message-ID: <2339459.YydjCFIDl7@avalon>
In-Reply-To: <201306212025.38448.hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1306170801590.22409@axis700.grange> <201306212025.38448.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 21 June 2013 20:25:38 Hans Verkuil wrote:
> Hi Guennadi,
> 
> I had hoped to review this earlier this week, but I didn't get around it.
> But better late than never...
> 
> Comments below.
> 
> On Mon June 17 2013 08:04:10 Guennadi Liakhovetski wrote:
> > Add documentation for the V4L2 clock and V4L2 asynchronous probing APIs
> > to v4l2-framework.txt.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > Hopefully we can commit the actual patches now, while we refine the
> > documentation.
> > 
> >  Documentation/video4linux/v4l2-framework.txt |   62
> >  +++++++++++++++++++++++++- 1 files changed, 60 insertions(+), 2
> >  deletions(-)
> > 
> > diff --git a/Documentation/video4linux/v4l2-framework.txt
> > b/Documentation/video4linux/v4l2-framework.txt index a300b28..159a83a
> > 100644
> > --- a/Documentation/video4linux/v4l2-framework.txt
> > +++ b/Documentation/video4linux/v4l2-framework.txt

[snip]

> > @@ -394,6 +413,25 @@ controlled through GPIO pins. This distinction is
> > only relevant when setting up the device, but once the subdev is
> > registered it is completely transparent.
> >
> > +In the asynchronous case subdevices register themselves using the
> > +v4l2_async_register_subdev() function. Unregistration is performed, using
> > +the v4l2_async_unregister_subdev() call. Subdevices registered this way
> > +are stored on a global list of subdevices, ready to be picked up by
> > +bridge drivers.
> > +
> > +Bridge drivers in turn have to register a notifier object with an array
> > +of subdevice descriptors, that the bridge device needs for its operation.
> > +This is performed using the v4l2_async_notifier_register() call. To
> > +unregister the notifier the driver has to call
> > +v4l2_async_notifier_unregister(). The former of the two functions takes
> > +two arguments: a pointer to struct v4l2_device and a pointer to struct
> > +v4l2_async_notifier. The latter contains a pointer to an array of
> > +pointers to subdevice descriptors of type struct v4l2_async_subdev type.
> > +The V4L2 core will then use these descriptors to match asynchronously
> > +registered subdevices to them. If a match is detected the .bound()
> > +notifier callback is called. After all subdevices have been located the
> > +.complete() callback is called. When a subdevice is removed from the
> > +system the .unbind() method is called. All three callbacks are optional.
> 
> Is that true? Don't you need at least a bound or a complete callback?

A driver should implement at least either bound or complete, so in a sense all 
three callbacks are optional. This should probably be made a bit more 
explicit.

-- 
Regards,

Laurent Pinchart

