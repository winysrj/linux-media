Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40119 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755607AbcLWR1P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Dec 2016 12:27:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references as needed
Date: Fri, 23 Dec 2016 19:27:45 +0200
Message-ID: <3326659.fIzREYY4Ly@avalon>
In-Reply-To: <fa996ec5-0650-9774-7baf-5eaca60d76c7@osg.samsung.com>
References: <20161109154608.1e578f9e@vento.lan> <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl> <fa996ec5-0650-9774-7baf-5eaca60d76c7@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thursday 15 Dec 2016 07:45:29 Shuah Khan wrote:
> On 12/15/2016 07:03 AM, Hans Verkuil wrote:
> > On 15/12/16 13:56, Laurent Pinchart wrote:
> >> On Thursday 15 Dec 2016 13:30:41 Sakari Ailus wrote:
> >>> On Tue, Dec 13, 2016 at 10:24:47AM -0200, Mauro Carvalho Chehab wrote:
> >>>> Em Tue, 13 Dec 2016 12:53:05 +0200 Sakari Ailus escreveu:
> >>>>> On Tue, Nov 29, 2016 at 09:13:05AM -0200, Mauro Carvalho Chehab wrote:

[snip]

> >> There's plenty of way to try and work around the problem in drivers, some
> >> more racy than others, but if we require changes to all platform drivers
> >> to fix this we need to ensure that we get it right, not as half-baked
> >> hacks spread around the whole subsystem.
> > 
> > Why on earth do we want this for the omap3 driver? It is not a
> > hot-pluggable device and I see no reason whatsoever to start modifying
> > platform drivers just because you can do an unbind. I know there are real
> > hot-pluggable devices, and getting this right for those is of course
> > important.
> 
> This was my first reaction when I saw this RFC series. None of the platform
> drivers are designed to be unbound. Making core changes based on such as
> driver would make the core very complex.
>
> We can't even reproduce the problem on other drivers.
> 
> > If the omap3 is used as a testbed, then that's fine by me, but even then I
> > probably wouldn't want the omap3 code that makes this possible in the
> > kernel. It's just additional code for no purpose.
> 
> I agree with Hans. Why are we using the most complex case as a reference
> driver


The omap3isp driver is a very good test case, as it registers a media 
controller device node, multiple video device nodes and multiple subdev device 
nodes. This is not an exceptional situation (and is actually simpler than a 
driver that would also register an audio device, as we would span multiple 
subsystems there). If we can't design a clean lifetime management solution for 
MC and V4L2 objects that fixes the unbind problem with omap3isp then we could 
as well give up on kernel development completely.

> and basing that driver to make core changes which will force changes to all
> the driver that use mc-core?

Making changes to all drivers isn't a goal. My goal is to fix the objects 
lifetime management problem cleanly. If there's a way to do so that minimizes 
changes to drivers, great. Otherwise, we'll have to bite the bullet. The MC 
and V4L2 core code is the foundation on top of which everything is built, it 
has to be fail-proof and clean.

> >>>> That could be done by overwriting the dev.release() callback at
> >>>> omap3 driver, as I discussed on my past e-mails, and flagging the
> >>>> driver that it should not accept streamon anymore, as the hardware
> >>>> is being disconnecting.
> >>> 
> >>> A mutex will be needed to serialise the this with starting streaming.
> >>> 
> >>>> Btw, that explains a lot why Shuah can't reproduce the stuff you're
> >>>> complaining on her USB hardware.
> >>>> 
> >>>> The USB subsystem has a a .disconnect() callback that notifies
> >>>> the drivers that a device was unbound (likely physically removed).
> >>>> The way USB media drivers handle it is by returning -ENODEV to any
> >>>> V4L2 call that would try to touch at the hardware after unbound.
> > 
> > In my view the main problem is that the media core is bound to a struct
> > device set by the driver that creates the MC. But since the MC gives an
> > overview of lots of other (sub)devices the refcount of the media device
> > should be increased for any (sub)device that adds itself to the MC and
> > decreased for any (sub)device that is removed. Only when the very last
> > user goes away can the MC memory be released.
> 
> Correct. Media Device Allocator API work I did allows creating media device
> on parent USB device to allow media sound driver share the media device. It
> does ref-counting on media device and media device is unregistered only when
> the last driver unregisters it.

It doesn't address references taken to the media_device from v4l2_subdev and 
video_device though. I believe we need one reference counting implementation 
that can cover both references from other objects and media_device sharing.

> There is another aspect to explore regarding media device and the graph.
> 
> Should all the entities stick around until all references to media
> device are gone? If an application has /dev/media open, does that
> mean all entities should not be free'd until this app. exits?

Probably not, as we need to target dynamic updates of the media graph.

> What should happen if an app. is streaming? Should the graph stay intact
> until the app. exits?

I'll need to give this more thought, but I'd say yes.

>    If yes, this would pose problems when we have multiple drivers bound
>    to the media device. When audio driver goes away for example, it should
>    be allowed to delete its entities.

There's two parts to "driver goes away". When the device is unbound from the 
driver, entities should probably not be deleted immediately but should instead 
be reference-counted. Module removal should be blocked by taking a reference 
to the module until all related entities have been freed.

> The approach current mc-core takes is that the media_device and
> media_devnode stick around, but entities can be added and removed during
> media_device lifetime.

Adding and removing entities during the lifetime of media_device is needed, 
but it doesn't mean that removal should release the entity synchronously.

> If an app. is still running when media_device is unregistered, media_device
> isn't released until the last reference goes away and ioctls can check if
> media_device is registered or not.
> 
> We have to decide on the larger lifetime question surrounding media_device
> and graph as well.
> 
> > The memory/refcounting associated with device nodes is unrelated to this:
> > once a devnode is unregistered it will be removed in /dev, and once the
> > last open fh closes any memory associated with the devnode can be
> > released. That will also decrease the refcount to its parent device.
> > 
> > This also means that it is a bad idea to embed devnodes in a larger
> > struct. They should be allocated and freed when the devnode is
> > unregistered and the last open filehandle is closed.
> > 
> > Then the parent's device refcount is decreased, and that may now call its
> > release callback if the refcount reaches 0.
> > 
> > For the media controller's device: any other device driver that needs
> > access to it needs to increase that device's refcount, and only when
> > those devices are released will they decrease the MC device's refcount.
> > 
> > And when that refcount goes to 0 can we finally free everything.
> > 
> > With regards to the opposition to reverting those initial patches, I'm
> > siding with Greg KH. Just revert the bloody patches. It worked most of the
> > time before those patches, so reverting really won't cause bisect
> > problems.
> > 
> > Just revert and build up things as they should.
> > 
> > Note that v4l2-dev.c doesn't do things correctly (it doesn't set the cdev
> > parent pointer for example) and many drivers (including omap3isp) embed
> > video_device, which is wrong and can lead to complications.
> > 
> > I'm to blame for the embedding since I thought that was a good idea at one
> > time. I now realized that it isn't. Sorry about that...
> > 
> > And because the cdev of the video_device doesn't know about the parent
> > device it is (I think) possible that the parent device is released before
> > the cdev is released. Which can result in major problems.

-- 
Regards,

Laurent Pinchart

