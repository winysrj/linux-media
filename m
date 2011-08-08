Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:48865 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1HHCvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2011 22:51:46 -0400
Date: Sun, 7 Aug 2011 21:56:43 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <201108072353.42237.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.1108072126390.20613@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(second reply to Adam's message)

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


This reply deals exclusively with an analysis of the following list of 
abilities. Briefly, the situation is more complicated than one might 
expect. Thhe detailed answers below are provided so that people can 
be fully aware of the complexity of the situation, on the grounds that 
such things should be more generally known before plans are made, rather 
than after.

For my analysis of whether it is appropriate or not to do such 
things as are on this list inside the kernel, please look at my previous 
reply.

> 
> 1) Report number of images on device

Mercifully, all dual-mode cameras I know of will do this. A stillcam which 
would not report this would be real trouble, so it is reasonable to expect 
this to work.

> 2) Select an image to read (for some cameras selecting next may be much more 
> efficient than selecting at random although whether that inefficiency occurs 
> when selecting, when reading image info or when reading image data may vary)

Briefly, some cameras will not let one select at random, at all. One has 
to read all previous data and discard it. 

> 3) Read image information for selected image (resolution, compression type, 
> FOURCC)

This kind of information may be contained in the image data itself. In the 
alternative, it may be contained elsewhere, such as in an allocation 
table. It could also be collected, image for image, as responses to a 
sequence of queries. I have seen all of these.


> 4) Read raw image data for selected image

This might require reading the data for all previous images, or might not.

> 5) Delete individual image (not supported by all cameras)

Indeed.

> 6) Delete all images (sometimes supported on cameras that don't support 
> individual delete)

Yes, sometimes. And sometimes not. And sometimes it depends which firmware 
version it is, too.

> 
> I'm not sure if any of these cameras support tethered capture but if they do 

Yes, they all do, in a sense. They will all take a picture and send the 
image down to the computer, which is one kind of tethered capture. AFAIK 
none of them will take a picture and store it on the camera, a second kind 
of tethered capture. Those cameras which use bulk transport for all data 
transfer have this feature supported in libgphoto2. Those which use 
isochronous transport when running in webcam mode have to take tethered 
pictures by way of the webcam functionality.

> then add
> Take photo
> Set resolution
> 
> I doubt if any of them support EXIF data, 

No, they don't

> thumbnail images, 

No

> the ability to 
> upload images to the camera 

No

or any sound recording 

No, with one known exception.
One of the mr97310a cameras has a microphone on it and can be used to 
record sound. AFAICT it cannot be used this way and also take pictures at 
the same time. There is a little toggle switch on the camera which has 
to be pushed either toward "audio" setting or toward "video" setting. 
Downloading of audio (wav) files is therefore supported in 
libgphoto2/camlibs/mars.

but if they do then those 
> are additional things that gphoto2 would want to be able to do.

Yes. And, now, as I said in the previous message, it is far better just to 
figure out a way to let gphoto2 to access the camera in peace when 
legitimately summoned to do so, and not to mess with re-creating all of 
these perplexing variations on camera abilities in various camera drivers 
in the kernel.

Theodore Kilgore
