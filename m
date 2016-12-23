Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40158 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932617AbcLWRsR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Dec 2016 12:48:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references as needed
Date: Fri, 23 Dec 2016 19:48:47 +0200
Message-ID: <6154152.CashzThSvr@avalon>
In-Reply-To: <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl>
References: <20161109154608.1e578f9e@vento.lan> <fa996ec5-0650-9774-7baf-5eaca60d76c7@osg.samsung.com> <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 15 Dec 2016 16:26:19 Hans Verkuil wrote:
> On 15/12/16 15:45, Shuah Khan wrote:
> > On 12/15/2016 07:03 AM, Hans Verkuil wrote:

[snip]

> >> In my view the main problem is that the media core is bound to a struct
> >> device set by the driver that creates the MC. But since the MC gives an
> >> overview of lots of other (sub)devices the refcount of the media device
> >> should be increased for any (sub)device that adds itself to the MC and
> >> decreased for any (sub)device that is removed. Only when the very last
> >> user goes away can the MC memory be released.
> > 
> > Correct. Media Device Allocator API work I did allows creating media
> > device on parent USB device to allow media sound driver share the media
> > device. It does ref-counting on media device and media device is
> > unregistered only when the last driver unregisters it.
> > 
> > There is another aspect to explore regarding media device and the graph.
> > 
> > Should all the entities stick around until all references to media
> > device are gone? If an application has /dev/media open, does that
> > mean all entities should not be free'd until this app. exits? What
> > should happen if an app. is streaming? Should the graph stay intact
> > until the app. exits?
> 
> Yes, everything must stay around until the last user has disappeared.
> 
> In general unplugs can happen at any time. So applications can be in the
> middle of an ioctl, and removing memory during that time is just
> impossible.
> 
> On unplug you:
> 
> 1) stop any HW DMA (highly device dependent)
> 2) wake up any filehandles that wait for an event
> 3) unregister any device nodes

Shouldn't 2 and 3 be switched ? We also need to return all buffers to vb2 
without any race condition, so I would say the sequence of events should be as 
follows.

1. Mark the device as being disconnected. This condition should be tested by 
the .buf_queue() handler that will then return the buffer immediately to vb2 
with the state set to VB2_BUF_STATE_ERROR.
2. Stop hardware operation (DMA, interrupts, ...).
3. Unregister the devnodes. This shall result in all new ioctl calls being 
blocked by the core.
4. Wake up all waiters.

There's still a race between 2 and 3, as new hardware operations could be 
started. We need to decide how to handle that.

The uvcvideo driver handles this in a reasonably clean way (at least for the 
video devnodes, there are races related to the media controller devnode), but 
the driver-side implementation is a bit complex (look at the comment in 
uvc_queue_cancel(), and how uvc_unregister_video() has to increase the 
refcount temporarily for instance) even if the fact that the USB core stops 
hardware access simplifies step 2 above. It would be nice if we could move 
some of the code to the core.

> Then just sit back and wait for refcounts to go down as filehandles are
> closed by the application.

Sit back doesn't mean that the unbind handler (.remove for platform devices, 
.disconnect for USB devices, ...) blocks, right ? It should return after 
completing the steps above, 

> Note: the v4l2/media/cec/IR/whatever core is typically responsible for
> rejecting any ioctls/mmap/etc. once the device node has been unregistered.
> The only valid file operation is release().

That's a very good start. The hard part is then the handling of ioctls in 
progress.

> >    If yes, this would pose problems when we have multiple drivers bound
> >    to the media device. When audio driver goes away for example, it should
> >    be allowed to delete its entities.
> 
> Only if you can safely remove it from the topology data structures while
> being 100% certain that nobody can ever access it. I'm not sure if that is
> the case.

In some cases it might be, but I don't think we can build anything on top of 
that assumption.

> Actually, looking at e.g. adv7604.c it does
> media_entity_cleanup(&sd->entity); in remove() which is an empty function,
> so there doesn't appear any attempt to safely clean up an entity (i.e. make
> sure no running media ioctl can access it or call ops).
> 
> This probably will need to be serialized with the graph_mutex lock.

In the worst case, but we should try to minimize lock contention with proper 
refcounting.

> > The approach current mc-core takes is that the media_device and
> > media_devnode stick around, but entities can be added and removed during
> > media_device lifetime.
> 
> Seems reasonable. But the removal needs to be done carefully, and that
> doesn't seem to be the case now (unless adv7604.c is just buggy).
> 
> > If an app. is still running when media_device is unregistered,
> > media_device isn't released until the last reference goes away and ioctls
> > can check if media_device is registered or not.
> > 
> > We have to decide on the larger lifetime question surrounding media_device
> > and graph as well.
> 
> I don't think there is any choice but to keep it all alive until the last
> reference goes away.

I agree with this as a general principle. Now we'll have to analyse the 
problem in details and see where references can be borrowed, which could 
simplify the implementation. For instance I don't think we'll need to refcount 
pad objects.

-- 
Regards,

Laurent Pinchart

