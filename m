Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:45142 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1HHCVi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2011 22:21:38 -0400
Date: Sun, 7 Aug 2011 21:26:29 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <201108072353.42237.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(first of two replies to Adam's message; second reply deals with other 
topics)

On Sun, 7 Aug 2011, Adam Baker wrote:

> On Friday 05 August 2011, Hans de Goede wrote:
> > > This sounds to be a good theme for the Workshop, or even to KS/2011.
> > 
> > Agreed, although we don't need to talk about this for very long, the
> > solution is basically:
> > 1) Define a still image retrieval API for v4l2 devices (there is only 1
> >    interface for both functions on these devices, so only 1 driver, and to
> >    me it makes sense to extend the existing drivers to also do still image
> >    retrieval).
> > 2) Modify existing kernel v4l2 drivers to provide this API
> > 3) Write a new libgphoto driver which talks this interface (only need to
> >    do one driver since all dual mode cams will export the same API).
> > 
> > 1) is something to discuss at the workshop.
> > 
> This approach sounds fine as long as you can come up with a definition for the 
> API that covers the existing needs and is extensible when new cameras come 
> along and doesn't create horrible inefficiencies by not matching the way some 
> cameras work. I've only got one example of such a camera and it is a fairly 
> basic one but things I can imagine the API needing to provide are
> 
> 1) Report number of images on device
> 2) Select an image to read (for some cameras selecting next may be much more 
> efficient than selecting at random although whether that inefficiency occurs 
> when selecting, when reading image info or when reading image data may vary)
> 3) Read image information for selected image (resolution, compression type, 
> FOURCC)
> 4) Read raw image data for selected image
> 5) Delete individual image (not supported by all cameras)
> 6) Delete all images (sometimes supported on cameras that don't support 
> individual delete)
> 
> I'm not sure if any of these cameras support tethered capture but if they do 
> then add
> Take photo
> Set resolution
> 
> I doubt if any of them support EXIF data, thumbnail images, the ability to 
> upload images to the camera or any sound recording but if they do then those 
> are additional things that gphoto2 would want to be able to do.


Adam,

Yipe. This looks to me like one inglorious mess. I do not know if it is 
feasible, or not, but I would wish for something much more simple. Namely, 
if the camera is not a dual-mode camera then nothing of this is necessary, 
of course. But if it is a dual-mode camera then the kernel driver is able 
to "hand off" the camera to a (libgphoto2-based) userspace driver which 
can handle all of the gory details of what the camera can do in its role 
as a still camera. This would imply that there is a device which 
libgphoto2 can access, presumably another device which is distinct from 
/dev/videoX, lets call it right now /dev/camX just to give it a name 
during the discussion.

So then what happens ought to be something like the following:

1. Camera is plugged in, detected, and kernel module is fired up. Then 
either

2a. A streaming app is started. Then, upon request from outside the 
kernel, the /dev/videoX is locked in and /dev/camX is locked out. The 
camera streams until told to quit streaming, and in the meantime any 
access to /dev/camX is not permitted. When the streaming is turned off, 
the lock is released.

or

2b. A stillcam app is started. Then similar to 2a, but the locking is 
reversed.

I think that this kind of thing would keep life simple. As I understand 
what Hans is envisioning, it is pretty much along the same lines, too. It 
would mean, of course, that the way that libgphoto2 would access one of 
these cameras would be directly to access the /dev/camX provided by the 
kernel, and not to use libusb. But that can be done, I think. As I 
mentioned before, Hans has written several libgphoto2 drivers for digital 
picture frames which are otherwise seen as USB mass storage devices. 
Something similar would have to be done with dual-mode cameras.


I will send a second reply to this message, which deals in particular with 
the list of abilities you outlined above. The point is, the situation as 
to that list of abilities is more chaotic than is generally realized. And 
when people are laying plans they really need to be aware of that.

Theodore Kilgore
