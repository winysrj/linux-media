Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22603 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758088Ab0EKBUd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 21:20:33 -0400
Date: Mon, 10 May 2010 18:20:12 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Status of the patches under review (85 patches) and some misc
 notes about the devel procedures
Message-ID: <20100511012012.GB4290@xanatos>
References: <20100507093916.2e2ef8e3@pedra>
 <20100508083127.73a72af7@tele>
 <4BE5E995.4070003@redhat.com>
 <20100510134520.GA6213@xanatos>
 <4BE8335C.3050602@redhat.com>
 <20100510193937.5df925d0@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510193937.5df925d0@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 10, 2010 at 07:39:37PM +0200, Jean-Francois Moine wrote:
> On Mon, 10 May 2010 13:25:00 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > Sarah Sharp wrote:
> > > On Sat, May 08, 2010 at 03:45:41PM -0700, Mauro Carvalho Chehab
> > > wrote:
> > >> Jean-Francois Moine wrote:
> > >>> On Fri, 7 May 2010 09:39:16 -0300
> > >>> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > >>>
> > >>>> 		== Gspca patches - Waiting Jean-Francois Moine
> > >>>> <moinejf@free.fr> submission/review == 
> > >>>>
> > >>>> Feb,24 2010: gspca pac7302: add USB PID range based on
> > >>>> heuristics
> > >>>> http://patchwork.kernel.org/patch/81612 May, 3 2010: gspca: Try
> > >>>> a less bandwidth-intensive alt setting.
> > >>>> http://patchwork.kernel.org/patch/96514
> > >>> Hello Mauro,
> > >>>
> > >>> I don't think the patch about pac7302 should be applied.
> > >>> The patch about the gspca main is in my last git pull request.
> > >> (c/c Sarah)
> > >>
> > >> I also didn't like this patch strategy. It seems a sort of
> > >> workaround for xHCI, instead of a proper fix.
> > >>
> > >> I'll mark this patch as rejected, and wait for a proper fix.
> > > 
> > > This isn't a work around for a bug in the xHCI host.  The bandwidth
> > > checking is a feature.  It allows the host to reject a new
> > > interface if other devices are already taking up too much of the
> > > bus bandwidth.  I expect that all drivers that use interrupt or
> > > isochronous will have to fall back to a different alternate
> > > interface setting if they can.
> > > 
> > > Now, Alan Stern and I have been talking about making a different
> > > API for drivers to request a specific polling rate and frame list
> > > length for an endpoint.  However, I expect that the call would have
> > > to be either before or part of the call to usb_set_interface(),
> > > because of how the xHCI hardware tracks endpoints.  So even if we
> > > had the ideal interface, the drivers would still need code like
> > > this to fall back to less-bandwidth intensive alternate settings.
> > > 
> > > Is there a different way you think we should handle running out of
> > > bandwidth?
> > 
> > Sarah,
> > 
> > A loop like the above doesn't work for video streams. The point is
> > that the hardware got programmed to some resolution and frame rate.
> > For example, a typical case is to program the hardware to do
> > 640x480x30fps. Assuming a device with 16 bits per pixel, this means a
> > bandwidth of 18.432 Mbps.

The raw bandwidth number (18.432 Mbps) isn't useful to the xHCI
hardware.  It wants to know the maximum packet size the driver needs,
along with the number of additional opportunities per microframe the
device can handle and the periodic interval to poll the endpoint at.

> > With V4L API, the resolution is configured before starting stream 
> > (so, before the place where usb_set_interface is called).

Are you talking about programming the USB device to have a specific
resolution and frame rate?  If so, is that done through control
transfers or some other method?

> > After
> > having all video stream parameters configured via several different
> > ioctls, a call to VIDIOC_REQBUFS is done, causing the allocation of
> > the streaming buffers and the corresponding USB interface setup. On
> > that moment, it is too late to negotiate the bandwidth. So, if xHCI
> > is not capable of supporting at least 18.432 Mbps (assuming my
> > example), the call should simply fail.
> >
> > In thesis, all V4L/DVB USB drivers have a code where it plays with
> > USB interface alternates, until they found the minimum alternate that
> > is capable of handing the bandwidth needed by the stream. As there's
> > no standard way, at USB core, to set an isoc bandwidth [1], each
> > driver has its own logic for doing that, and maybe some strategies
> > are better than the others.
> > 
> > I'm not sure if it would be simpler or possible, but an alternative
> > way would be to have something like usb_request_bandwidth(), where
> > the USB core would have the logic to set the interface alternates to
> > fulfill the bandwidth needs, or return -EINVAL if it is not possible.
> > The advantage is that you won't need to fix all the different logics
> > used by the V4L/DVB drivers.

That could be do-able.

Can you guarantee that the drivers won't attempt to use the old
alternate setting between a call to usb_request_bandwidth() in V4L and a
call to usb_set_interface() in the drivers?  The problem is that we
actually need to install the new alternate interface in the xHCI
hardware to find out if we have enough bandwidth.  Drivers can't
issue URBs to the old alternate setting after this bandwidth check.

> > [1] On some devices, even needing a constant bandwitdh, they only
> > support bulk transfers, due to hardware limitation, but, from the
> > driver's perspective, the seek for the alternate has an identical
> > need.

Bulk transfers can't have guaranteed bandwidth under xHCI.  The xHCI
host controller driver has no control over when the bulk transfers are
scheduled, since it is all done in hardware.

> Hi Mauro,
> 
> Contrary to other webcam drivers, gspca already has a fallback to a
> different altsetting. Actually, this is done at URB submit time and it
> works correctly, mainly with USB-1.1. It seems that the bandwidth may be
> now checked when setting the altsetting. The proposed patch does not
> change the gspca logic at all. Maybe it could be done in a clearer way.
> 
> A first problem with webcams is that the bandwidth is not fully known
> when starting the capture. The frame rate may be changed during
> streaming either by direct video control (rare) or by changing the
> exposure time (manual or automatic - AEC). Also, the video stream is
> often compressed and the compression ratio is not well known (some
> webcams automatically change the JPEG quality).

Hmm, can you give an accurate estimate of the maximum bandwidth you'll
use?  For example, if you don't know whether compression is used, just
assume it won't and calculate the max bandwidth with that assumption.

If there was an API to change the required bandwidth during capture (say
when the exposure time is changed), what kind of latencies could the
user tolerate?  Could they tolerate dropping a couple frames of data?

I ask because it takes some time to check whether the hardware can
support the new bandwidth requirements.  The xHCI driver must stop all
transfers to the effected endpoints, issue a command, and wait for it to
be processed (which takes a variable length of time, based on how many
commands are already being processed).  It's probably better to allocate
the maximum bandwidth possible instead.

> The second problem is the USB interface. If a driver could calculate a
> good estimation of the needed bandwidth, it cannot actually tell it to
> the USB subsystem. The USB subsystem uses the packet length and the
> message interval to calculate the bandwidth that the device will use.
> This is indeed not correct because the device does not send data at the
> full interface speed.

How does it differ?  Is the length in each usb_iso_packet_descriptor
consistently smaller than the max packet size the endpoint advertises?
Or are there bursts of the maximum packet size and then zero length
transfers?

> In an other way, a driver could search the
> alternate setting which matches the best its estimated bandwidth, but I
> am not sure that this will not slow down the frame rate (more USB
> packets for the same data volume).

Can you explain what you mean by this?  I understand that there's more
bus bandwidth overhead for transferring many small packets versus
transferring few big packets, but I'm not sure what you're getting at.

> Hi Sarah,
> 
> Your patch should be changed to follow the global altsetting fallback
> mechanism. This mechanism is inside the function gspca_init_transfer().
> If usb_set_interface() returns an error when the bandwidth is not wide
> enough (BTW, which is this error?), it should called inside the loop
> and, so, removed from get_ep().

I'll look at how gspca_init_transfer() does the fallback and try to
update the patch.  I'm fine with it being dropped, now that the reasons
have been explained.

Sarah Sharp
