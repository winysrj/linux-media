Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40317 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761949AbcLWSM6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Dec 2016 13:12:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references as needed
Date: Fri, 23 Dec 2016 20:13:29 +0200
Message-ID: <123545704.YXsQANS9kg@avalon>
In-Reply-To: <ea29010f-ffdc-f10f-8b4f-fb1337320863@osg.samsung.com>
References: <20161109154608.1e578f9e@vento.lan> <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl> <ea29010f-ffdc-f10f-8b4f-fb1337320863@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thursday 15 Dec 2016 09:06:41 Shuah Khan wrote:
> On 12/15/2016 08:26 AM, Hans Verkuil wrote:
> > On 15/12/16 15:45, Shuah Khan wrote:
> >> On 12/15/2016 07:03 AM, Hans Verkuil wrote:
> >>> On 15/12/16 13:56, Laurent Pinchart wrote:
> >>>> On Thursday 15 Dec 2016 13:30:41 Sakari Ailus wrote:
> >>>>> On Tue, Dec 13, 2016 at 10:24:47AM -0200, Mauro Carvalho Chehab wrote:
> >>>>>> Em Tue, 13 Dec 2016 12:53:05 +0200 Sakari Ailus escreveu:
> >>>>>>> On Tue, Nov 29, 2016 at 09:13:05AM -0200, Mauro Carvalho Chehab 
wrote:

[snip]

> >>> In my view the main problem is that the media core is bound to a struct
> >>> device set by the driver that creates the MC. But since the MC gives an
> >>> overview of lots of other (sub)devices the refcount of the media device
> >>> should be increased for any (sub)device that adds itself to the MC and
> >>> decreased for any (sub)device that is removed. Only when the very last
> >>> user goes away can the MC memory be released.
> >> 
> >> Correct. Media Device Allocator API work I did allows creating media
> >> device on parent USB device to allow media sound driver share the media
> >> device. It does ref-counting on media device and media device is
> >> unregistered only when the last driver unregisters it.
> >> 
> >> There is another aspect to explore regarding media device and the graph.
> >> 
> >> Should all the entities stick around until all references to media
> >> device are gone? If an application has /dev/media open, does that
> >> mean all entities should not be free'd until this app. exits? What
> >> should happen if an app. is streaming? Should the graph stay intact
> >> until the app. exits?
> > 
> > Yes, everything must stay around until the last user has disappeared.
> > 
> > In general unplugs can happen at any time. So applications can be in the
> > middle of an ioctl, and removing memory during that time is just
> > impossible.
> > 
> > On unplug you:
> > 
> > 1) stop any HW DMA (highly device dependent)
> > 2) wake up any filehandles that wait for an event
> > 3) unregister any device nodes
> > 
> > Then just sit back and wait for refcounts to go down as filehandles are
> > closed by the application.
> > 
> > Note: the v4l2/media/cec/IR/whatever core is typically responsible for
> > rejecting any ioctls/mmap/etc. once the device node has been
> > unregistered. The only valid file operation is release().
> > 
> >>    If yes, this would pose problems when we have multiple drivers bound
> >>    to the media device. When audio driver goes away for example, it
> >>    should
> >>    be allowed to delete its entities.
> > 
> > Only if you can safely remove it from the topology data structures while
> > being 100% certain that nobody can ever access it. I'm not sure if that is
> > the case. Actually, looking at e.g. adv7604.c it does
> > media_entity_cleanup(&sd->entity); in remove() which is an empty
> > function, so there doesn't appear any attempt to safely clean up an
> > entity (i.e. make sure no running media ioctl can access it or call ops).
> 
> Right. media_entity_cleanup() nothing at the moment. Also if it gets called
> after media_device_unregister_entity(), it could pose problems. I wonder if
> we have drivers that are calling media_entity_cleanup() after unregistering
> the entity?
> 
> > This probably will need to be serialized with the graph_mutex lock.
> > 
> >> The approach current mc-core takes is that the media_device and
> >> media_devnode stick around, but entities can be added and removed during
> >> media_device lifetime.
> > 
> > Seems reasonable. But the removal needs to be done carefully, and that
> > doesn't seem to be the case now (unless adv7604.c is just buggy).
> 
> Correct. It is possible media_device is embedded in this driver.

I assume you mean the private data structure instantiated by the adv7604 
driver. That can't be the case, as adv7604 is a subdev.

> When driver that embeds is unbound, media_device goes away. I needed to make
> the media device refcounted and sharable for audio work and that is what the
> Media Device Allocator API does.
> 
> Maybe we have more cases than this audio case that requires media_device
> refcounted. If we have to keep entities that are in use until all the
> references go away, we have to ref-count them as well.

I think we're converging towards refcounting media_device to manage its 
lifetime, so there's more cases, yes. That's why I propose first making 
media_device refcounted, and then adding the allocator API on top of that 
given that the allocator API requires refcounting. That seems to me to be the 
cleanest approach.

> >> If an app. is still running when media_device is unregistered,
> >> media_device isn't released until the last reference goes away and ioctls
> >> can check if media_device is registered or not.
> >> 
> >> We have to decide on the larger lifetime question surrounding
> >> media_device and graph as well.
> > 
> > I don't think there is any choice but to keep it all alive until the last
> > reference goes away.
> 
> If you mean "all alive" entities as well, we have to ref-count them. Because
> drivers can unregister entities during run-time now. I am looking at the
> use-case where, a driver that has dvb and video and what should happen when
> dvb is unbound for example. Should dvb entities go away or should they stay
> until all the drivers are unbound?

I believe they'll have to stay until they're not referenced anymore, which 
could (and likely should) be earlier than the the other drivers are unbound.

> v4l2-core registers and unregisters entities and so does dvb-core. So when a
> driver unregisters video and dvb, these entities get deleted.

Not if we refcount entities, deletion won't be synchronous with unregistration 
in that case.

> So we have a distributed mode of registering and unregistering entities. We
> also have ioctls (video, dvb, and media) accessing these entities. So where
> do we make changes to ensure entities stick around until all users exit?
> 
> Ref-counting entities won't work if they are embedded - like in the case of
> struct video_device which embeds the media entity. When struct video goes
> away then entity will disappear.

Why is that ? If the entity is referenced it should certainly prevent 
video_device from disappearing.

> So we do have a complex lifetime model here that we need to figure out how
> to fix.

-- 
Regards,

Laurent Pinchart

