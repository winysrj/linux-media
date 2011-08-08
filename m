Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:38738 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1HHRe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 13:34:59 -0400
Date: Mon, 8 Aug 2011 12:39:56 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Adam Baker <linux@baker-net.org.uk>,
	Hans de Goede <hdegoede@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <4E3FE86A.5030908@redhat.com>
Message-ID: <alpine.LNX.2.00.1108081208080.21409@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 8 Aug 2011, Mauro Carvalho Chehab wrote:

> Em 07-08-2011 23:26, Theodore Kilgore escreveu:
> > 
> > (first of two replies to Adam's message; second reply deals with other 
> > topics)
> > 
> > On Sun, 7 Aug 2011, Adam Baker wrote:
> > 
> >> On Friday 05 August 2011, Hans de Goede wrote:
> >>>> This sounds to be a good theme for the Workshop, or even to KS/2011.
> >>>
> >>> Agreed, although we don't need to talk about this for very long, the
> >>> solution is basically:
> >>> 1) Define a still image retrieval API for v4l2 devices (there is only 1
> >>>    interface for both functions on these devices, so only 1 driver, and to
> >>>    me it makes sense to extend the existing drivers to also do still image
> >>>    retrieval).
> >>> 2) Modify existing kernel v4l2 drivers to provide this API
> >>> 3) Write a new libgphoto driver which talks this interface (only need to
> >>>    do one driver since all dual mode cams will export the same API).
> >>>
> >>> 1) is something to discuss at the workshop.
> >>>
> >> This approach sounds fine as long as you can come up with a definition for the 
> >> API that covers the existing needs and is extensible when new cameras come 
> >> along and doesn't create horrible inefficiencies by not matching the way some 
> >> cameras work. I've only got one example of such a camera and it is a fairly 
> >> basic one but things I can imagine the API needing to provide are
> >>
> >> 1) Report number of images on device
> >> 2) Select an image to read (for some cameras selecting next may be much more 
> >> efficient than selecting at random although whether that inefficiency occurs 
> >> when selecting, when reading image info or when reading image data may vary)
> >> 3) Read image information for selected image (resolution, compression type, 
> >> FOURCC)
> >> 4) Read raw image data for selected image
> >> 5) Delete individual image (not supported by all cameras)
> >> 6) Delete all images (sometimes supported on cameras that don't support 
> >> individual delete)
> >>
> >> I'm not sure if any of these cameras support tethered capture but if they do 
> >> then add
> >> Take photo
> >> Set resolution
> >>
> >> I doubt if any of them support EXIF data, thumbnail images, the ability to 
> >> upload images to the camera or any sound recording but if they do then those 
> >> are additional things that gphoto2 would want to be able to do.
> > 
> > 
> > Adam,
> > 
> > Yipe. This looks to me like one inglorious mess. I do not know if it is 
> > feasible, or not, but I would wish for something much more simple. Namely, 
> > if the camera is not a dual-mode camera then nothing of this is necessary, 
> > of course. But if it is a dual-mode camera then the kernel driver is able 
> > to "hand off" the camera to a (libgphoto2-based) userspace driver which 
> > can handle all of the gory details of what the camera can do in its role 
> > as a still camera. This would imply that there is a device which 
> > libgphoto2 can access, presumably another device which is distinct from 
> > /dev/videoX, lets call it right now /dev/camX just to give it a name 
> > during the discussion.
> > 
> > So then what happens ought to be something like the following:
> > 
> > 1. Camera is plugged in, detected, and kernel module is fired up. Then 
> > either
> > 
> > 2a. A streaming app is started. Then, upon request from outside the 
> > kernel, the /dev/videoX is locked in and /dev/camX is locked out. The 
> > camera streams until told to quit streaming, and in the meantime any 
> > access to /dev/camX is not permitted. When the streaming is turned off, 
> > the lock is released.
> > 
> > or
> > 
> > 2b. A stillcam app is started. Then similar to 2a, but the locking is 
> > reversed.
> > 
> > I think that this kind of thing would keep life simple. As I understand 
> > what Hans is envisioning, it is pretty much along the same lines, too. It 
> > would mean, of course, that the way that libgphoto2 would access one of 
> > these cameras would be directly to access the /dev/camX provided by the 
> > kernel, and not to use libusb. But that can be done, I think. As I 
> > mentioned before, Hans has written several libgphoto2 drivers for digital 
> > picture frames which are otherwise seen as USB mass storage devices. 
> > Something similar would have to be done with dual-mode cameras.
> > 
> > 
> > I will send a second reply to this message, which deals in particular with 
> > the list of abilities you outlined above. The point is, the situation as 
> > to that list of abilities is more chaotic than is generally realized. And 
> > when people are laying plans they really need to be aware of that.
> 
> >From what I understood from your proposal, "/dev/camX" would be providing a
> libusb-like interface, right?
> 
> If so, then, I'd say that we should just use the current libusb infrastructure.
> All we need is a way to lock libusb access when another driver is using the same
> USB interface.
> 
> Hans and Adam's proposal is to actually create a "/dev/camX" node that will give
> fs-like access to the pictures. As the data access to the cameras generally use
> PTP (or a PTP-like protocol), probably one driver will handle several different
> types of cameras, so, we'll end by having one different driver for PTP than the
> V4L driver.
> 
> In other words, part of libgphoto2 code will be moved into the Kernel, to allow 
> abstracting the webcam differences into a common interface.
> 
> In summary, there are currently two proposals:
> 
> 1) a resource lock for USB interface between V4L and libusb;
> 
> 2) a PTP-like USB driver, plus a resource lock between V4L and the PTP-like driver.
> The same resource lock may also be implemented at libusb, in order to avoid
> concurrency.
> 
> As you said that streaming on some cameras may delete all pictures from it,
> I suspect that (2) is the best alternative.
> 
> Thanks,
> Mauro
> 

Mauro,

In fact none of the currently known and supported cameras are using PTP. 
All of them are proprietary. They have a rather intimidating set of 
differences in functionality, too. Namely, some of them have an 
isochronous endpoint, and some of them rely exclusively upon bulk 
transport. Some of them have a well developed set of internal capabilities 
as far as handling still photos are concerned. I mean, such things as the 
ability to download a single photo, selected at random from the set of 
photos on the camera, and some do not, requiring that the "ability" to do 
this is emulated in software -- by first downloading all previously listed 
photos and sending the data to /dev/null, then downloading the desired 
photo and saving it. Some of them permit deletion of individual photos, or 
all photos, and some do not. For some of them it is even true, as I have 
previously mentioned, that the USB command string which will delete all 
photos is the same command used for starting the camera in streaming mode.

But the point here is that these cameras are all different from one 
another, depending upon chipset and even, sometimes, upon firmware 
or chipset version. The still camera abilities and limitations of all of 
them are pretty much worked out in libgphoto2. My suggestion would be that 
the libgphoto2 support libraries for these cameras ought to be left the 
hell alone, except for some changes in, for example, how the camera is 
accessed in the first place (through libusb or through a kernel device) in 
order to address adequately the need to support both modes. I know what is 
in those libgphoto2 drivers because I wrote them. I can definitely promise 
that to move all of that functionality over into kernel modules would be a 
nightmare and would moreover greatly contribute to kernel bloat. You 
really don't want to go there.

As to whether to use libusb or not to use libusb:

It would be very nice to be able to keep using libusb to get access to 
these cameras, as then no change in the existing stillcam drivers would be 
required at all. Furthermore, if it were possible to solve all of the 
associated locking problems and to do it this way, it would be something 
that could be generalized to any analogous situation. 

This would be very nice. I can also imagine, of course, that such an 
approach might require changes in libusb. For example, the current ability 
of libusb itself to switch off a kernel device might possibly be a step in 
the wrong direction, and it might possibly be needed to move that 
function, somehow, out of libusb and into the kernel support for affected 
hardware. 

In the alternative, it ought to be possible for a libgphoto2 driver to 
hook up directly to a kernel-created device without going through libusb, 
and, as I have said in earlier messages, some of our driver code (for 
digital picture frames in particular) does just that. Then, whatever /dev 
entries and associated locking problems are needed could be handled by the 
kernel, and libgphoto2 talks to the device. But if things are done this 
way I strongly suggest that as little of the internals of the libgphoto2 
driver are put in the kernel as it is possible to do. Be very economical 
about that, else there will be a big mess. 

Theodore Kilgore
