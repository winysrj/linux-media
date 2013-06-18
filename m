Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57754 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab3FRRTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 13:19:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Add query/get/set matrix ioctls
Date: Tue, 18 Jun 2013 19:19:25 +0200
Message-ID: <1776767.eJmWcNdIu3@avalon>
In-Reply-To: <201306171357.05047.hverkuil@xs4all.nl>
References: <201306031414.49392.hverkuil@xs4all.nl> <20130616220958.GA2064@valkosipuli.retiisi.org.uk> <201306171357.05047.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 17 June 2013 13:57:04 Hans Verkuil wrote:
> On Mon 17 June 2013 00:09:59 Sakari Ailus wrote:
> > On Wed, Jun 12, 2013 at 02:57:21PM +0200, Hans Verkuil wrote:
> > > On Wed 12 June 2013 14:26:27 Sakari Ailus wrote:
> > > > On Wed, Jun 12, 2013 at 10:35:07AM +0200, Hans Verkuil wrote:
> > > > > On Tue 11 June 2013 23:33:42 Sylwester Nawrocki wrote:

[snip]

> > > > > > This is even more nice than your previous proposal ;) Quite
> > > > > > generic - but I was wondering, what if we went one step further
> > > > > > and defined QUERY/GET/SET_PROPERTY ioctls, where the type (matrix
> > > > > > or anything else) would be also configurable ? :-) Just
> > > > > > brainstorming, if memory serves me well few people suggested
> > > > > > something like this in the past.
> > > > 
> > > > Interesting idea. This approach could be used on the Media controller
> > > > interface as well.
> > > 
> > > What is needed for the MC (if memory serves) is something simple to list
> > > what effectively are capabilities of entities. Basically just a list of
> > > integers. That's quite different from this highly generic proposal.
> > 
> > I think I should have said "property API" instead. That's what I meant.
> > This could be prototyped and discussed. Which device nodes that API could
> > eventually use is another matter.
> > 
> > From API design point of view it's somewhat odd that a device (especially
> > when it comes to embedded systems) is visible in the system as a large
> > number of device nodes. I know there are a huge number of reasons why it's
> > so currently but if I were to create a new API, that's one thing I would
> > correct.
> > 
> > But in the context of matrix IOCTLs, this begins to be off-topic.
> > 
> > > > > The problem with that is that you basically create a meta-ioctl. Why
> > > > > not just create an ioctl for whatever you want to do? After all, an
> > > > > ioctl is basically a type (the command number) and a pointer. And
> > > > > with a property ioctl you really just wrap that into another ioctl.
> > > > 
> > > > Is this a problem?
> > > 
> > > I think so, yes. It seems to me that this just adds an unnecessary
> > > indirection that everyone (userspace and kernelspace) has to cope with.
> > > 
> > > I don't see any advantage of going in this direction.
> > 
> > To some extent one could claim the controls API does exactly that: it
> > provides a generic way to access properties of certain kind. I like
> > controls and extended controls even more: the standard API makes many
> > other things easier in user space, including enumeration.
> > 
> > > > One of the benefits is that you could send multiple IOCTL commands to
> > > > the device at one go (if the interface is designed as such, and I
> > > > think it should be).
> > > 
> > > There are other ways this can be done (we discussed that in the past)
> > > without introducing complex new ioctls. And the reality is that this
> > > doesn't really
> >
> > Could you refresh my memory a bit?
> 
> I can't remember whether we discussed that during a meeting or via an RFC.
> Anyway, the idea was to have something transaction based: e.g. queue up a
> number of ioctls, then 'commit' or 'execute' them. I seem to remember I
> wrote an RFC on that topic, but it was probably 1-2 years ago.

I remember discussing that with you, but the whereabouts escape me as well. I 
don't think this will fly though, as it wouldn't offer a way to commit across 
multiple entities

> > I remember synchronisation of applying configurations being discussed,
> > and, well, most of the time that certainly isn't an issue, but if you wish
> > to ensure two configuration parameters on different subdevs take effect at
> > the same time, there's no fully generic way to do that in the API: you
> > have to rely on timing to some extent.
> 
> You cannot sync two different pieces of hardware at the same time anyway.
> Which is why the extended controls API makes a 'best-effort' only in
> setting controls.

You can if the hardware allows for that, otherwise you will need a "best-
effort" implementation. That's how atomic mode setting has been designed in 
KMS, basically if the commit operation comes too close to vsync it will be 
delayed until the next frame.

> If you need to configure a device at a specific time, then that requires
> some sort of hardware support to trigger a new configuration or you need to
> use a real-time OS/firmware to do that.
> 
> > > help you much: the real complexity will be in handling such ioctl sets
> > > in a driver.
> > 
> > Very, very true. I still maintain there are cases where this a) could be
> > done and b) would be nice and useful. The configuration of different
> > omap3isp blocks, for instance, now passed to the driver using private
> > ioctls.
> >
> > > > It would be easier to model extensions to the V4L2 API using that kind
> > > > of model; currently we have a bunch of IOCTLs that certainly do show
> > > > the age of the API. With the property API, everything will be...
> > > > properties you can access using set and get operations, and probably
> > > > enum as well.
> > > 
> > > It's easy to model extension today as well: just add a new ioctl. How is
> > > that any different than adding a new property type, except instead of
> > > just filling in one struct to pass with the ioctl, I now have to fill
> > > in two: one for the property encapsulation struct, one for the actual
> > > payload struct. Yes, it looks like you have just a few property ioctls,
> > > but the reality is that the complexity has just been moved to the
> > > property side of things.
> > 
> > I'm not claiming it'd magically fixed everything, but it'd be worth
> > prototyping. I wish I had time for that (and well, to do a bunch of other
> > pending things as well). :-P
> > 
> > > > I think this is a logical extension of the V4L2 control API.
> > > > 
> > > > I have to admit designing that kind of an API isn't trivial either:
> > > > more focus will be needed on what the properties are attached to: is
> > > > that a device or a subdev pad, for instance. This way it might be
> > > > possible to address such things at generic level rather than at the
> > > > level of a single IOCTL as we're doing (or rather avoid doing) right
> > > > now.
> > > 
> > > That's a problem that is unrelated to 'property' usage. Actually, that's
> > > easier for 'non-property' ioctls since there you know how it is going to
> > > be used, so there is no need to be generic.
> > > 
> > > BTW, I've been making the assumption that a property can hold any type
> > > of data, not just 'simple' types. So it can hold a v4l2_format struct
> > > for example (or something of similar complexity).
> > 
> > I don't think properties should --- instead they should contain
> > information related to the fields of the struct. The structs combine
> > together information which is valid for a certain use case, and are
> > unchangeable from then on. There are many upsides from this but also
> > downsides. The full picture is not visible without at least prototyping a
> > property-based API.
>
> I agree, this would require prototyping. As you can tell, I'm skeptical
> about this :-), so I don't think I will work on that myself.

[snip]

> > > > > > > Each matrix has a type (which describes the meaning of the
> > > > > > > matrix) and an index (allowing for multiple matrices of the same
> > > > > > > type).
> > > > > > 
> > > > > > I'm just wondering how this could be used to specify coefficients
> > > > > > associated with selection rectangles for auto focus ?
> > > > > 
> > > > > I've been thinking about this. The problem is that sometimes you
> > > > > want to associate a matrix with some other object (a selection
> > > > > rectangle, a video input, perhaps a video buffer, etc.). A simple
> > > > > index may not be> enough. So how about replacing the index field
> > > > > with a union:
> > > > >
> > > > > 	union {
> > > > > 		__u32 reserved[4];
> > > > > 	} ref;
> > > > 
> > > > ...which is a proof of what I wrote above. :-)
> > > 
> > > Is it?
> > 
> > Indeed to be more precise, to some of that: here, we do have the same
> > problem locally that the property API would need to resolve globally. But
> > the problem itself is the same.
> > 
> > That said, a property API would and could not fix any issues today, and
> > not even next year. To be more practical, the question in the meantime is:
> > should V4L2 be extended to provide functionality that would match better
> > with the idea of the property-based API or not? The difficulty in that
> > approach would more likely be in defining an object model that would make
> > sense in the general case.
> 
> I think I would need to see a more concrete proposal for a property-based
> API. It's a bit too abstract for me right now.
> 
> > I'm not against adding a partial implementation of a property-based API to
> > V4L2 (i.e. what you're proposing in thie RFC) but I think we need to go
> > through the content thoroughly (I'll reply again to the original RFC).
> 
> Yes, please. This discussion drifted fairly far from my original RFC :-)
> Right now I am just trying to solve the specific problem of how to set a
> vector/matrix of integers.
> 
> > I'd like to get Laurent's opinion, too.
> 
> Indeed.

Done :-) Sorry once again for the delay.

-- 
Regards,

Laurent Pinchart

