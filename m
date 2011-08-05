Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:53842 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab1HERIN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 13:08:13 -0400
Date: Fri, 5 Aug 2011 12:13:05 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <4E3B9597.4040307@redhat.com>
Message-ID: <alpine.LNX.2.00.1108051143490.18884@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu> <4E39B150.40108@redhat.com> <alpine.LNX.2.00.1108031750241.16520@banach.math.auburn.edu> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 5 Aug 2011, Hans de Goede wrote:

> Hi all,
> 
> On 08/04/2011 02:34 PM, Mauro Carvalho Chehab wrote:
> > Em 03-08-2011 20:20, Theodore Kilgore escreveu:
> 
> <snip snip>
> 
> > > Yes, that kind of thing is an obvious problem. Actually, though, it may be
> > > that this had just better not happen. For some of the hardware that I know
> > > of, it could be a real problem no matter what approach would be taken. For
> > > example, certain specific dual-mode cameras will delete all data stored on
> > > the camera if the camera is fired up in webcam mode. To drop Gphoto
> > > suddenly in order to do the videoconf call would, on such cameras, result
> > > in the automatic deletion of all photos on the camera even if those photos
> > > had not yet been downloaded. Presumably, one would not want to do that.
> > 
> > So, in other words, the Kernel driver should return -EBUSY if on such
> > cameras, if there are photos stored on them, and someone tries to stream.
> > 
> 
> Agreed.

Here, too. Not only that, but also -EBUSY needs to be returned if 
streaming is being done and someone tries to download photos (cf. 
yesterday's exchange between me and Adam Baker, where it was definitely 
established that this currently leads to bad stuff happening).

> 
> > > > IMO, the right solution is to work on a proper snapshot mode, in
> > > > kernelspace,
> > > > and moving the drivers that have already a kernelspace out of Gphoto.
> > > 
> > > Well, the problem with that is, a still camera and a webcam are entirely
> > > different beasts. Still photos stored in the memory of an external device,
> > > waiting to be downloaded, are not snapshots. Thus, access to those still
> > > photos is not access to snapshots. Things are not that simple.
> > 
> > Yes, stored photos require a different API, as Hans pointed. I think that
> > some cameras
> > just export them as a USB storage.
> 
> Erm, that is not what I tried to say, or do you mean another
> Hans?

For the record, this one didn't come from me, either. :-)

> 
> <snip snip>
> 
> > If I understood you well, there are 4 possible ways:
> > 
> > 1) UVC + USB mass storage;
> > 2) UVC + Vendor Class mass storage;
> > 3) Vendor Class video + USB mass storage;
> > 4) Vendor Class video + Vendor Class mass storage.
> > 
> 
> Actually the cameras Theodore and I are talking about here all
> fall into category 4. 

Currently true, yes.

> I expect devices which do any of 1-3 to
> properly use different interfaces for this, actually the different
> class specifications mandate that they use different interfaces
> for this.

As is well known, *everybody* obeys the class specifications, too. Always 
did, and always will. And Linus says that he got the original kernel from 
the Tooth Fairy, and because he said that we all believe him. The point 
being, trouble will very likely come along. I think Mauro is right at 
least to consider the possibility.

> 
> > This sounds to be a good theme for the Workshop, or even to KS/2011.
> > 
> 
> Agreed, although we don't need to talk about this for very long, the solution
> is basically:
> 1) Define a still image retrieval API for v4l2 devices (there is only 1
>   interface for both functions on these devices, 

True


> so only 1 driver, and to
>   me it makes sense to extend the existing drivers to also do still image
>   retrieval).
> 2) Modify existing kernel v4l2 drivers to provide this API
> 3) Write a new libgphoto driver which talks this interface (only need to
>   do one driver since all dual mode cams will export the same API).

Yes, we pretty much agree that this is probably a good way to proceed. 
However, my curiosity is aroused by something that Adam mentioned 
yesterday. Namely

"If you can solve the locking problem between devices in the kernel then 
it
shouldn't matter if one of the kernel devices is the generic device that 
is
used to support libusb."

I am not completely sure of what he meant here. I am not intimately 
conversant with the internals of libusb. However, is there something here 
which could be used constructively? Could things be set up so that, for 
example, the kernel module hands the "generic device" over to libusb? If 
it were possible to do things that way, it might be the most minimally 
disruptive approach of all, since it might not require much if any changes 
in libgphoto2 access to cameras. 


> 
> 1) is something to discuss at the workshop.
> 
> Regards,
> 
> Hans
> 

Theodore Kilgore
