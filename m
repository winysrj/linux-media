Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38694 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1768920Ab2KOUZP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 15:25:15 -0500
Date: Thu, 15 Nov 2012 22:25:10 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 1/1] media: Entities with sink pads must have at least
 one enabled link
Message-ID: <20121115202510.GA29863@valkosipuli.retiisi.org.uk>
References: <1351280777-4936-1-git-send-email-sakari.ailus@iki.fi>
 <50A36307.50502@samsung.com>
 <20121114211344.GU25623@valkosipuli.retiisi.org.uk>
 <2019126.gp1BvLQNQ8@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2019126.gp1BvLQNQ8@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the comments.

On Thu, Nov 15, 2012 at 01:46:23AM +0100, Laurent Pinchart wrote:
> On Wednesday 14 November 2012 23:13:45 Sakari Ailus wrote:
> > On Wed, Nov 14, 2012 at 10:23:19AM +0100, Sylwester Nawrocki wrote:
> > > On 11/13/2012 03:24 PM, Sakari Ailus wrote:
> > > > Hi all,
> > > > 
> > > > Comments would be appreciated, either positive or negative. The omap3isp
> > > > driver does the same check itself currently, but I think this is more
> > > > generic than that.
> > > > 
> > > > Thanks.
> > > > 
> > > > On Fri, Oct 26, 2012 at 10:46:17PM +0300, Sakari Ailus wrote:
> > > >> If an entity has sink pads, at least one of them must be connected to
> > > >> another pad with an enabled link. If a driver with multiple sink pads
> > > >> has more strict requirements the check should be done in the driver
> > > >> itself.
> > > >> 
> > > >> Just requiring one sink pad is connected with an enabled link is enough
> > > >> API-wise: entities with sink pads with only disabled links should not
> > > >> be allowed to stream in the first place, but also in a different
> > > >> operation mode a device might require only one of its pads connected
> > > >> with an active link.
> > > >> 
> > > >> If an entity has an ability to function as a source entity another
> > > >> logical entity connected to the aforementioned one should be used for
> > > >> the purpose.
> > > 
> > > Why not leave it to individual drivers ? I'm not sure if it is a good idea
> > > not to allow an entity with sink pads to be used as a source only. It
> > > might be appropriate for most of the cases but likely not all. I'm
> > > inclined not to add this requirement in the API. Just my opinion though.
> > 
> > I'm just wondering what would be the use case for that.
> > 
> > What comes closest is generating a test pattern, but even that should be a
> > separate subdev: the test pattern can be enabled by enabling the link from
> > the test pattern generator subdev.
> 
> That would force creating a separate subdev just to support test pattern 
> generation, I'm not sure if I want to push for that. There might also be other 

The benefit of standard interfaces and uniform behaviour of those interfaces
is that you can configure test pattern generation using e.g. media-ctl and
yavta. Nothing else; not even private controls are needed.

> use cases not related to V4L (thus the cross-posting).

That's certainly possible.

...

> > One opion I can think of is to call link_validate op of struct
> > media_entity_operations also for disabled links on entities that are
> > connected through active links (on V4L2 to a video node right before
> > streaming, for example).
> > 
> > That'd make it easy to perform the check in the drivers.
> >
> > What do you think?
> 
> I think that would be a bit too complex. Drivers (or the V4L core) would need 
> to gather data from multiple links in some state object to find out if the 
> complete pipeline is valid or not.
> 
> Another option would be to set a flag somewhere to indicate whether the check 
> should be performed by the media core or left to drivers. As different types 
> of drivers might need different types of checks, I think I would prefer for 
> now to walk the graph one more time in the OMAP3 ISP driver, as currently 
> done, and revisit this issue when we will have a couple of drivers 
> implementing pipeline validity checks. I'm just a bit uncomfortable adding 
> core code for a feature that has a single user at the moment without a clear 
> view regarding how it would scale.

Honestly, I think that a driver that has configurable links but does not
require this check to be done is quite probably broken. I'm not really
convinced there is even a use case for a subdev operating its all sink pads
disconnected.

Btw. this "somewhere" could be struct media_pad. It already has a "flags"
field. We could call it MEDIA_PAD_FL_MUST_CONNECT.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
