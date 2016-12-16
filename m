Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53046 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934820AbcLPQmZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 11:42:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references as needed
Date: Fri, 16 Dec 2016 18:43:02 +0200
Message-ID: <1993001.UFV7HZSkt6@avalon>
In-Reply-To: <20161215123207.3198d1d2@vento.lan>
References: <20161109154608.1e578f9e@vento.lan> <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl> <20161215123207.3198d1d2@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 15 Dec 2016 12:32:07 Mauro Carvalho Chehab wrote:
> Em Thu, 15 Dec 2016 15:03:36 +0100 Hans Verkuil escreveu:
> > On 15/12/16 13:56, Laurent Pinchart wrote:
> >> On Thursday 15 Dec 2016 13:30:41 Sakari Ailus wrote:
> >>> On Tue, Dec 13, 2016 at 10:24:47AM -0200, Mauro Carvalho Chehab wrote:
> >>>> Em Tue, 13 Dec 2016 12:53:05 +0200 Sakari Ailus escreveu:
> >>>>> On Tue, Nov 29, 2016 at 09:13:05AM -0200, Mauro Carvalho Chehab wrote:
> >>>>>> Hi Sakari,
> >> 
> >> There's plenty of way to try and work around the problem in drivers,
> >> some more racy than others, but if we require changes to all platform
> >> drivers to fix this we need to ensure that we get it right, not as
> >> half-baked hacks spread around the whole subsystem.
> > 
> > Why on earth do we want this for the omap3 driver? It is not a
> > hot-pluggable device and I see no reason whatsoever to start modifying
> > platform drivers just because you can do an unbind. I know there are real
> > hot-pluggable devices, and getting this right for those is of course
> > important.
> 
> That's indeed a very good point. If unbind is not needed by any usecase,
> the better fix for OMAP3 would be to just prevent it to happen in the first
> place.

There are several reasons to implement proper unbind support in the omap3isp 
driver. Sakari has outlined them in another e-mail in this thread, I won't 
copy them here to avoid splitting the discussion.

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
> > 
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
> 
> You're contradicting yourself here ;)
> 
> The patches that this patch series is reverting are the ones that
> de-embeeds devnode struct and fixes its lifecycle.
>
> Reverting those patches will cause regressions on hot-pluggable drivers,
> preventing them to be unplugged. So, if we're willing to revert, then we
> should also revert MC support on them.
> 
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
> 
> I agree with you here. IMHO, de-embeeding cdev's struct from video_device
> seems to be the right thing to do at V4L2 side too.

I believe Hans' comment about embedded devnodes in larger structures referred 
to embedded video_device and media_device inside driver private structures. 
And even in that case I'm not convinced. I've replied to that in another part 
of the mail thread, let's keep the discussion there.

-- 
Regards,

Laurent Pinchart

