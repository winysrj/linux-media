Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38148 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932253Ab2KNVNu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 16:13:50 -0500
Date: Wed, 14 Nov 2012 23:13:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, laurent.pinchart@ideasonboard.com,
	broonie@opensource.wolfsonmicro.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 1/1] media: Entities with sink pads must have at least
 one enabled link
Message-ID: <20121114211344.GU25623@valkosipuli.retiisi.org.uk>
References: <1351280777-4936-1-git-send-email-sakari.ailus@iki.fi>
 <20121113142409.GR25623@valkosipuli.retiisi.org.uk>
 <50A36307.50502@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A36307.50502@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the comments.

On Wed, Nov 14, 2012 at 10:23:19AM +0100, Sylwester Nawrocki wrote:
> On 11/13/2012 03:24 PM, Sakari Ailus wrote:
> > Hi all,
> > 
> > Comments would be appreciated, either positive or negative. The omap3isp
> > driver does the same check itself currently, but I think this is more
> > generic than that.
> > 
> > Thanks.
> > 
> > On Fri, Oct 26, 2012 at 10:46:17PM +0300, Sakari Ailus wrote:
> >> If an entity has sink pads, at least one of them must be connected to
> >> another pad with an enabled link. If a driver with multiple sink pads has
> >> more strict requirements the check should be done in the driver itself.
> >>
> >> Just requiring one sink pad is connected with an enabled link is enough
> >> API-wise: entities with sink pads with only disabled links should not be
> >> allowed to stream in the first place, but also in a different operation mode
> >> a device might require only one of its pads connected with an active link.
> >>
> >> If an entity has an ability to function as a source entity another logical
> >> entity connected to the aforementioned one should be used for the purpose.
> 
> Why not leave it to individual drivers ? I'm not sure if it is a good idea
> not to allow an entity with sink pads to be used as a source only. It might
> be appropriate for most of the cases but likely not all. I'm inclined not to
> add this requirement in the API. Just my opinion though.

I'm just wondering what would be the use case for that.

What comes closest is generating a test pattern, but even that should be a
separate subdev: the test pattern can be enabled by enabling the link from
the test pattern generator subdev.

As it seems not everyone is outright happy about the idea of making this
mandatory, then how about making it optional?

I'd hate having a link validate function for each subdev e.g. in the OMAP 3
ISP driver that just checks that its sink pad is actually connected with an
enabled link. That'd be lots of mostly useless code. If this is done in the
framework, the drivers will be spared from copying this code in a number of
places. Which was why I originally wrote this patch. The alternative is to
re-parse the whole graph in the driver which I'd also like to avoid.

One opion I can think of is to call link_validate op of struct
media_entity_operations also for disabled links on entities that are
connected through active links (on V4L2 to a video node right before
streaming, for example).

That'd make it easy to perform the check in the drivers.

What do you think?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
