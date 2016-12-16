Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52404 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761967AbcLPQdz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 11:33:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references as needed
Date: Fri, 16 Dec 2016 18:34:32 +0200
Message-ID: <1977235.oankKcQKCR@avalon>
In-Reply-To: <20161216150723.GL16630@valkosipuli.retiisi.org.uk>
References: <20161109154608.1e578f9e@vento.lan> <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl> <20161216150723.GL16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 16 Dec 2016 17:07:23 Sakari Ailus wrote:
> On Thu, Dec 15, 2016 at 03:03:36PM +0100, Hans Verkuil wrote:
> > On 15/12/16 13:56, Laurent Pinchart wrote:
> >> On Thursday 15 Dec 2016 13:30:41 Sakari Ailus wrote:
> >>> On Tue, Dec 13, 2016 at 10:24:47AM -0200, Mauro Carvalho Chehab wrote:

[snip]

> >>>> It is not clear from the logs what the driver tried to do, but
> >>>> that sounds like a driver's bug, with was not prepared to properly
> >>>> handle unbinds.
> >>>>
> >>>> The problem here is that isp_video_release() is called by V4L2
> >>>> release logic, and not by the MC one:
> >>>>
> >>>> static const struct v4l2_file_operations isp_video_fops = {
> >>>>      .owner          = THIS_MODULE,
> >>>>      .open           = isp_video_open,
> >>>>      .release        = isp_video_release,
> >>>>      .poll           = vb2_fop_poll,
> >>>>      .unlocked_ioctl = video_ioctl2,
> >>>>      .mmap           = vb2_fop_mmap,
> >>>>};
> >>>>
> >>>> It seems that the driver's logic allows it to be called before or
> >>>> after destroying the MC.
> >>>>
> >>>> Assuming that, if the OMAP3 driver is not used it works,
> >>>> it means that, if the isp_video_release() is called
> >>>> first, no errors will happen, but if MC is destroyed before
> >>>> V4L2 call to its .release() callback, as there's no logic at the
> >>>> driver that would detect it, isp_video_release() will be calling
> >>>> isp_video_streamoff(), with depends on the MC to work.
> >>>>
> >>>> On a first glance, I can see two ways of fixing it:
> >>>>
> >>>> 1) to increment devnode's device kobject refcount at OMAP3 .probe(),
> >>>> decrementing it only at isp_video_release(). That will ensure that
> >>>> MC will only be removed after V4L2 removal.
> >>
> >> As soon as you have to dig deep in a structure to find a reference
> >> counter and increment it, bypassing all the API layers, you can be
> >> entirely sure that the solution is wrong.
> > 
> > Indeed.
> > 
> >>>> 2) to call isp_video_streamoff() before removing the MC stuff, e. g.
> >>>> inside the MC .release() callback.
> >>>
> >>> This is a fair suggestion, indeed. Let me see what could be done there.
> >>> Albeit this is just *one* of the existing issues. It will not address
> >>> all problems fixed by the patchset.
> >>
> >> We need to stop the hardware at .remove() time. That should not be linked
> >> to a videodev, v4l2_device or media_device .release() callback. When the
> >> .remove() callback returns the driver is not allowed to touch the
> >> hardware anymore. In particular, power domains might clocks or power
> >> supplies, leading to invalid access faults if we try to access hardware
> >> registers.
> > 
> > Correct.
> > 
> >> USB devices get help from the USB core that cancels all USB operations
> >> in progress when they're disconnected. Platform devices don't have it as
> >> easy, and need to implement everything themselves. We thus need to stop
> >> the hardware, but I'm not sure it makes sense to fake a VIDIOC_STREAMOFF
> >> ioctl at .remove() time.
> > 
> > Please don't. This shouldn't be done automatically.
> > 
> >> That could introduce other races between .remove() and the
> >> userspace API. A better solution is to make sure the objects that are
> >> needed at .release() time of the device node are all reference-counted
> >> and only released when the last reference goes away.
> >>
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
> > 
> > If the omap3 is used as a testbed, then that's fine by me, but even then I
> > probably wouldn't want the omap3 code that makes this possible in the
> > kernel. It's just additional code for no purpose.
> 
> The same problems exist on other devices, whether platform, pci or USB, as
> the problems are in the core frameworks rather than (only) in the drivers.
> 
> On platform devices, this happens also when removing the module.
> 
> I've used omap3isp as an example since it demonstrates well the problems and
> a lot of people have the hardware as well. Also, Mauro has requested all
> drivers to be converted to the new API. I'm fine doing that for the
> actually hot-pluggable hardware.
> 
> One additional reason is that as the omap3isp driver has been used as an
> example to write a number of other drivers, people do see what's the right
> way to do these things, instead of copying code from a driver doing it
> wrong.

That's a very important reason in my opinion. If we design core code properly 
it shouldn't be difficult to handle unbind correctly in drivers (I'd argue 
that properly designed core code should make it easier to implement drivers 
correctly than incorrectly, but that's hard to achieve). While we might not 
want to fix all platform device drivers, we need a few good examples, and we 
should push back on new drivers than implement unbind in a racy way.

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
> Agreed.

When storing a pointer to the media device anywhere, we need to make sure we 
hold a reference. There are two ways to do this, either by borrowing a 
reference or taking a new reference. Borrowing a reference is only valid if we 
know it will exist for at least as long as we need to borrow it. In most cases 
I expect we will need to take new references, but borrowing one should in my 
opinion be allowed where applicable. It should, however, always be accompanied 
by a comment that explains why the reference can be borrowed.

> > The memory/refcounting associated with device nodes is unrelated to this:
> > once a devnode is unregistered it will be removed in /dev, and once the
> > last open fh closes any memory associated with the devnode can be
> > released. That will also decrease the refcount to its parent device.
> > 
> > This also means that it is a bad idea to embed devnodes in a larger
> > struct. They should be allocated and freed when the devnode is
> > unregistered and the last open filehandle is closed.
> 
> We do have a release() callback for video_device but not for media_device.
> 
> > Then the parent's device refcount is decreased, and that may now call its
> > release callback if the refcount reaches 0.
> > 
> > For the media controller's device: any other device driver that needs
> > access to it needs to increase that device's refcount, and only when
> > those devices are released will they decrease the MC device's refcount.

I'm not sure to follow you here. What do you mean by media controller's device 
? A struct media_device instance ? The struct device pointer stored in the 
struct media_device instance ? The struct media_devnode associated with the 
struct media_device ? The struct device embedded in that struct media_devnode 
? There's lots of devices, could you please clarify by rewriting the 
explanation using structure and field names ?

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
> > parent pointer for example)

Would you like to submit a patch ? I think it could be merged independently of 
any big rework.

> > and many drivers (including omap3isp) embed video_device, which is wrong
> > and can lead to complications.
> > 
> > I'm to blame for the embedding since I thought that was a good idea at one
> > time. I now realized that it isn't. Sorry about that...

I'm not sure to see why that's wrong. Embedding a struct video_device requires 
the driver to implement a .release() callback (which the omap3isp driver 
doesn't, and that's a bug). Are there other issues ? What is your concern ?

> > And because the cdev of the video_device doesn't know about the parent
> > device it is (I think) possible that the parent device is released before
> > the cdev is released. Which can result in major problems.
> 
> Is embedding cdev really such a problem? Is there a problem you can solve by
> not embedding it?

-- 
Regards,

Laurent Pinchart

