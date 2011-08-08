Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:56500 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1HHVBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 17:01:19 -0400
Date: Mon, 8 Aug 2011 16:06:16 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <201108082133.00340.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.1108081543490.21785@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com> <201108082133.00340.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 8 Aug 2011, Adam Baker wrote:

> On Monday 08 August 2011, Mauro Carvalho Chehab wrote:
> > > I will send a second reply to this message, which deals in particular
> > > with  the list of abilities you outlined above. The point is, the
> > > situation as to that list of abilities is more chaotic than is generally
> > > realized. And when people are laying plans they really need to be aware
> > > of that.
> > 
> > From what I understood from your proposal, "/dev/camX" would be providing a
> > libusb-like interface, right?
> > 
> > If so, then, I'd say that we should just use the current libusb
> > infrastructure. All we need is a way to lock libusb access when another
> > driver is using the same USB interface.
> > 
> 
> I think adding the required features to libusb is in general the correct 
> approach however some locking may be needed in the kernel regardless to ensure 
> a badly behaved libusb or libusb user can't corrupt kernel state.
> 
> > Hans and Adam's proposal is to actually create a "/dev/camX" node that will
> > give fs-like access to the pictures. As the data access to the cameras
> > generally use PTP (or a PTP-like protocol), probably one driver will
> > handle several different types of cameras, so, we'll end by having one
> > different driver for PTP than the V4L driver.
> 
> I'm not advocating this approach, my post was intended as a "straw man" to 
> allow the advantages and disadvantages of such an approach to be considered by 
> all concerned. I suspected it would be excessively complex but I don't know 
> enough about the various cameras to be certain.

Fair enough. Go and have a look at the code in the various subdirectories 
of libgphoto2/camlibs, and you will see. Also consider that some of those 
subdirectories do not support currently-supported dual-mode cameras, but 
some of the ways of doing things that are present there could be applied 
to any dual-mode camera in the future.

A prime example of what I mean can be seen in camlibs/aox. Those cameras 
are very old now and they probably will never be fully supported. They can 
download plain bitmap photos, or they can use some kind of compression 
which is not figured out. They can, as I recall, be run as webcams, too, 
and then they will presumably use that weird compression. But what is 
immediately interesting is that in still mode there is no allocation 
table, or at least none is downloaded. Everything about how many images 
and what kind of images and what size are they can be read out of a 
downloaded allocation table on most cameras, but not on these. No. One has 
to send a sequence of commands and parse the responses to them in order to 
get the information.

I merely mention this example in order to point up the actual complexity 
of the situation, and the necessity not to make sweeping assumptions about 
how the camera is supposed to work. Be assured, that already happened when 
Gphoto was set up, and it made some of these cameras rather hard to 
support. Why? Well, it was set up with the assumption that all still 
cameras will do X, and Y, and Z. But be assured that someone either has or 
will design a still camera which is not capable of doing X, nor Y, nor Z, 
nor, even, all three of them, at least not in the way envisioned in 
someone's grand design.

OK, another example. The cameras supported in camlibs/jl2005c do not have 
webcam ability, but someone could at any time design and market a dualmode 
which has in stillcam mode the same severe limitation. What limitation? 
Well, the entire memory of the camera must be dumped, or else the camera 
jams itself. You can stop dumping in the middle of the operation, but you 
must continue after that. Suppose that you had ten pictures on the camera 
and you only wanted to download the first one. Then you can do that and 
temporarily stop downloading the rest. But while exiting you have to check 
whether the rest are downloaded or not. And if they are not, then it has 
to be done, with the data simply thrown in the trash, and then the 
camera's memory pointer reset before the camera is released. How, one 
might ask, did anyone produce something so primitive? Well, it is done. 
Perhaps the money saved thereby was at least in part devoted to producing 
better optics for the camera. At least, one can hope so. But people did 
produce those cameras, and people have bought them. But does anyone want 
to reproduce the code to support this kind of crap in the kernel? And go 
through all of the hoops required in order to fake the behavior which one 
woulld "expect" from a "real" still camera? It has already been done in 
camlibs/jl2005c and isn't that enough?

Theodore Kilgore
