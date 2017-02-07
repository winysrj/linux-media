Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46792 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932379AbdBGVj5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 16:39:57 -0500
Date: Tue, 7 Feb 2017 23:38:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        Helen Koike <helen.koike@collabora.co.uk>
Subject: Re: [ANN] Media object lifetime management meeting report from Oslo
Message-ID: <20170207213808.GF13854@valkosipuli.retiisi.org.uk>
References: <20170127100822.GJ7139@valkosipuli.retiisi.org.uk>
 <20170127093831.6d1e7361@vento.lan>
 <20170127220252.GM7139@valkosipuli.retiisi.org.uk>
 <4573885.tx4flxcHHQ@avalon>
 <1627ee1c-a66b-8ea5-9094-91e60d531328@xs4all.nl>
 <20170130095646.412985dc@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170130095646.412985dc@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Jan 30, 2017 at 09:56:46AM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 30 Jan 2017 09:39:21 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On 28/01/17 16:35, Laurent Pinchart wrote:
> > > Hi Sakari,
> > >
> > > On Saturday 28 Jan 2017 00:02:53 Sakari Ailus wrote:  
> > >> On Fri, Jan 27, 2017 at 09:38:31AM -0200, Mauro Carvalho Chehab wrote:  
> > >>> Hi Sakari/Hans/Laurent,
> > >>>
> > >>> First of all, thanks for looking into those issues. Unfortunately, I was
> > >>> in vacations, and were not able to be with you there for such discussions.
> > >>>
> > >>> While I have a somewhat different view on some of the introductory points
> > >>> of this RFC, what really matters is the "proposal" part of it. So, based
> > >>> on the experiments I did when I addressed the hotplug issues with the
> > >>> media controller on USB drivers, I'm adding a few comments below.
> > >>>
> > >>> Em Fri, 27 Jan 2017 12:08:22 +0200 Sakari Ailus escreveu:  
> > >>>> Allocating struct media_devnode separately from struct media_device
> > >>>> -------------------------------------------------------------------
> > >>>>
> > >>>> The current codebase allocates struct media_devnode dynamically. This
> > >>>> was done in order to reduce the time window during which unallocated
> > >>>> kernel memory could be accessed. However, there is no specific need for
> > >>>> such a separation as the entire data structure, including the media
> > >>>> device which used to contain struct media_devnode, will have the same
> > >>>> lifetime. Thus the struct media_devnode should be allocated as part of
> > >>>> struct media_device. Later on, struct media_devnode may be merged with
> > >>>> struct media_device if so decided.  
> > >>>
> > >>> There is one issue merging struct media_devnode at struct media_device.
> > >>> The problem is that, if the same struct device is used for two different
> > >>> APIs (like V4L2 and media_controller) , e. g. if the cdev parent points
> > >>> to the same struct device, you may end by having a double free when the
> > >>> device is unregistered on the second core. That's basically why
> > >>> currently struct cdev is at struct media_devnode: this way, it has its own
> > >>> struct device.  
> > >>
> > >> One of the conclusions of the memorandum I wrote is that the data structures
> > >> that are involved in executing a system call (including IOCTLs) must stay
> > >> intact during that system call. (Well, the alternative I can think of is
> > >> using an rw_semaphore but I certainly do not advocate that solution.)
> > >>
> > >> Otherwise, we will continue to have serialisation issues: kernel memory that
> > >> may be released at any point of time independently of a system call in
> > >> progress:
> > >>
> > >> <URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg106390.html  
> > >>>  
> > >>
> > >> That one is a NULL pointer dereference but released kernel memory can be
> > >> accessed as well.
> > >>  
> 
> There's an alternative approach: to have a flag to indicate that the
> device got disconnected and denying access to the device-specific data
> if the device was already hot-unplugged. The V4L USB drivers do that
> already. See, for example, the em28xx driver:
> 
> int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
> 			    char *buf, int len)
> {
> ...
> 	if (dev->disconnected)
> 		return -ENODEV;
> ...
> }
> 
> /* Processes and copies the URB data content (video and VBI data) */
> static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
> {
> ...
> 	if (dev->disconnected)
> 		return 0;
> 
> The same logic exists on multiple places along the driver. Some of
> such checks could be moved to the core, but, if I remember well when
> such code was written, several such checks should be inside the driver,
> as the USB core doesn't allow any calls to their functions after the
> disconnect callback is called. That's why it was opted to not move
> it to the core.
> 
> In the case of DVB, the core has a similar logic to handle disconnected
> devices, with prevents it to call driver-specific code when a device is
> removed. That's why there are just 2 checks if dev->disconnected at
> drivers/media/usb/em28xx/em28xx-dvb.c: one at the IRQ logic, and the
> second one to avoid a race issue with the suspend code.
> 
> Due to that, on real hot-plug devices (USB drivers) that don't have
> hot-unplug issues with the V4L2 API, it should be safe to free some of
> their data structs at the .disconnect callback. Of course, the struct
> that embeds the struct device used as the cdev's parent can't be freed
> there.

I agree there's a need to prevent devices from accessing the hardware ---
please also see "Stopping the hardware safely at device unbind" below ---
but that's unrelated to accessing the media device or the media graph from
the user space and from other users in the kernel space.

The USB devices are a bit special as the framework does ensure that
accessing a device does not lead to catastrophic results if it's no longer
there. For other busses, accessing the hardware is no longer allowed once
the driver's remove() function has completed.

The purpose here is just to ensure that the media device itself will stay
around while it's being accessed. For instance, issuing a system call on a
file handle open to a sub-device device node quite probably does require
accessing to the media device as well.

> 
> > >>> IMHO, it also makes sense to embeed struct cdev at the V4L2 side, as I
> > >>> detected some race issues at the V4L2 side when I ran the bind/unbind
> > >>> race tests, when we tried to merge the snd-usb-audio MC support patch.
> > >>> I remember Shuah reported something similar on that time.
> > >>>  
> > >>>> Allocating struct media_device dynamically
> > >>>> ------------------------------------------
> > >>>>
> > >>>> Traditionally the media device has been allocated as part of drivers'
> > >>>> own structures. This is certainly fine as such, but many drivers have
> > >>>> allocated the driver private struct using the devm_() family of
> > >>>> functions. This causes such memory to be released at the time of device
> > >>>> removal rather than at the time when the memory is no longer accessible
> > >>>> by e.g. user space processes or interrupt handlers. Besides the media
> > >>>> device, the driver's own data structure is very likely to have the
> > >>>> precisely same lifetime issue: it may also be accessed through IOCTLs
> > >>>> after the device has been removed from the system.
> > >>>>
> > >>>> Instead, the memory needs to be released as part of the release()
> > >>>> callback of the media device which is called when the last reference to
> > >>>> the media device is gone. Still, allocating the media device outside
> > >>>> another containing driver specific struct will be required in some cases:
> > >>>> sharing the media device mandates that. Implementing this can certainly
> > >>>> be postponed until sharing the media device is otherwise supported as
> > >>>> well.  
> > >>>
> > >>> The patches adding MC support for snd-usb-audio, pending since Kernel
> > >>> 4.7 (I guess) require such functionatilty. Last year, on the audio
> > >>> summit, they asked about its status, as they're needing MC suppor there.
> > >>>
> > >>> So, whatever solution taken, this should be part of the solution.
> > >>>
> > >>> (c/c Shuah, as she is the one working on it)  
> > >>
> > >> I think we should postpone that, or at least resolve that in a separate
> > >> patchset. This is already getting very big. The refcounting problems will be
> > >> harder to fix, should we extend the MC framework with media device sharing
> > >> without considering the object lifetime issues first. So the order should
> > >> be: first fix object lifetime issues, then add more features.  
> > >
> > > I strongly second that, continuing to build on top of a totally broken base
> > > can only lead to disaster. Given that we have given the lifetime management
> > > problem lots of thoughts already, with a patch series out to fix it and work
> > > ongoing to rework that series, I don't see a reason to order development in a
> > > different way.  
> > 
> > I agree with that as well.
> 
> Ok. When do you expect to have a patchset ready for tests covering the
> hot-plug issue without causing regressions to the USB drivers?

I've been adjusting my existing patchset to conform to the meeting notes
without making additional driver changes. The changes include removal of the
functions used to allocate the media device, i.e. embedding it into another
struct is the way to proceed. This means that fewer driver changes will be
needed. There's definitely some amount of work there left. Some review time
will need to be allocated as well.

I'd guesstimate that, if we will roughly agree on the proposed changes and
few iterations will be needed, we should be able to have that in the
mediatree.git master around the end of the month, depending a bit on easy it
is to make the necessary changes to the DVB USB drivers.

It'll likely take another month or two to add refcounting and help drivers
not to access hardware once they've been unbound. I presume there will be a
lot of details I can't foresee now that won't be trivial to handle. I might
be that my assumption on the complexity of the task at hand is too
pessimistic and it's actually easier that I foresee but I doubt it.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
