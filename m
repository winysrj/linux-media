Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:41811 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZJTWcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 18:32:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 00/14] Media controller update based on Hans' v4l-dvb-mc tree
Date: Wed, 21 Oct 2009 00:32:11 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <20091020011210.623421213@ideasonboard.com> <dddd6ede1d034513603028f90a8c0395.squirrel@webmail.xs4all.nl>
In-Reply-To: <dddd6ede1d034513603028f90a8c0395.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910210032.11418.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 October 2009 00:15:37 Hans Verkuil wrote:
> Hi Laurent,
> 
> > Hi everybody,
> >
> > here's a set of patches to clean up and extend Hans' initial media
> > controller implementation.
> >
> > Patches prefixed by v4l deal with the v4l core code and update existing
> > drivers when required by an API change. The core now offers two functions
> > to deal with entities and links:
> >
> > - v4l2_entity_init() will initialize an entity. For subdevices the
> > v4l2_subdev_init() performs part of the entity initialization as well,
> > which leads me to believe that the API is currently ill-defined.
> >
> > - v4l2_entity_connect() creates a link between two entities. All possible
> > links should be created using that function before the subdevice is
> > registered.
> >
> > As I don't own any ivtv hardware the media controller code was difficult
> > to test so I've implemented media controller support in the UVC driver for
> > testing purpose. The code can be found in patches prefixed by uvc.
> >
> > This is mostly playground code. There are known and unknown bugs
> > (especially in the ivtv driver as I haven't been able to test that code;
> > v4l2_entity_connect is definitely called with bad parameters in there) as
> > well as design issues. There's a lot of code missing. I'm mostly
> > interested in getting feedback on the changes, especially the new
> > v4l2_entity_pad and v4l2_entity_link objects. Feel free to comment on the
> > public userspace API too, I realized after changing it to mimic the new
> > kernel API that the way the previous API exposed "local" and "remote" pads
> > instead of pads and links is probably more space efficient.
> >
> > I'll keep playing with the code and I'll start porting the OMAP3 camera
> > driver to the in-progress media controller API. I'll discover problems
> > (and hopefully solutions) along the way so another round of patches can be
> > expected later, maybe in a week. Of course I'll appreciate comments before
> > that, as the earlier I get feedback the easier it will be to incorporate
> > it in the code. No pressure though, I know that a few developers have left
> > for the kernel summit in Japan.
> 
> While I haven't been able to do an in-depth review

Thanks for the early feedback.

> it is clear to me that the switch to 'pads' is definitely the right
> direction. That leads to much cleaner code.
> 
> With regards to the code kernel API to set up all these relationships: I
> expect we'll end up with a few generic core functions that do all the hard
> work, and a bunch of static inline convenience functions on top of that.
> That tends to work quite well.

That's what I predict as well.

> One tip: it might be useful to have a tree ready with just a single driver
> that is converted to use mc, links and pads (e.g. uvc). That makes it easy
> to experiment with different data structures and APIs. It's much harder to
> do this if you have a lot of dependencies on your code.

Good point. I'll setup a tree on linuxtv.org. Next step is the implementation 
of device nodes for subdevs. I'd like to reorganise the videodev core code for 
that, as we will have a dirty structures dependency otherwise (the v4l2_subdev 
structure will have two v4l2_entity fields, one as a direct child as 
v4l2_subdev inherits from v4l2_entity, and one through the video_device 
structure used for the subdev device node).

-- 
Regards,

Laurent Pinchart
