Return-path: <linux-media-owner@vger.kernel.org>
Received: from april.london.02.net ([87.194.255.143]:56718 "EHLO
	april.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1HDXFB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 19:05:01 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Date: Fri, 5 Aug 2011 00:04:55 +0100
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E398381.4080505@redhat.com> <201108042135.15972.linux@baker-net.org.uk> <alpine.LNX.2.00.1108041624220.17734@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108041624220.17734@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108050004.55659.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 04 August 2011, Theodore Kilgore wrote:
> On Thu, 4 Aug 2011, Adam Baker wrote:
> > On Thursday 04 August 2011, Theodore Kilgore wrote:
> > > As far as I know, /dev/sdx signifies a device which is accessible by
> > > something like the USB mass storage protocols, at the very least. So,
> > > if that fits the camera, fine. But most of the cameras in question are
> > > Class Proprietary. Thus, not in any way standard mass storage devices.
> > > Then it is probably better not to call the new device by that name
> > > unless that name really fits. Probably, it would be better to have
> > > /dev/cam or /dev/stillcam, or something like that.
> > 
> > Correct and that is why this idea doesn't work - /dev/sdx needs to be a
> > block device that can have a file system on it. These cameras don't have
> > a traditional file system and there is a lot of code in gphoto to
> > support all the different types of camera.
> > 
> > There does exist the possibility of a relatively simple fix - If libusb
> > include a usb_reattach_kernel_driver_np call to go with the
> > usb_detach_kernel_driver_np then once gphoto had finished with the device
> > it could restore the kernel driver and webcam mode would work.
> > Unfortunately the libusb devs don't want to support it in the 0.1
> > version of libusb that everyone uses and the reattach function needs
> > knowledge of libusb internals to work reliably.
> > 
> > I did come up with a hack that sort of worked but I never worked out how
> > to clean it up to be acceptable to go upstream.
> > 
> > http://old.nabble.com/Re-attaching-USB-kernel-drivers-detached-by-libgpho
> > to2- td22978838.html
> > 
> > http://libusb.6.n5.nabble.com/re-attaching-after-usb-detach-kernel-driver
> > -np- td6068.html
> > 
> > Adam Baker
> 
> Adam,
> 
> (without looking at the details of your code) I agree that something like
> fixing libusb to reattach a kernel driver would partially alleviate the
> immediate problem of dual-mode cameras.
> 
> 1. It would provide immediate relief to those people who are afflicted
> with the shortsightedness of some of the "user friendly" distros,
> which have set up a "rule" that every camera supported by Gphoto will be
> opened for download of photos as soon as it ls plugged in and the result
> is that no dual-mode camera can be used in webcam mode -- unless the user
> knows how to go and fix the mess.
> 
> 2. It would solve a lot of existing problems for lots of other people.
> 
> Therefore, I have favored this approach myself, sometimes in the past. The
> problems, as I see it (partly after some education from people like Hans
> de Goede), are the following:
> 
> 1. No locking, and no error-handling.
> 	-- What if the user is downloading photos and gets a
> videoconference telephone call? What if the user, just for fun, starts up
> a webcam app, at the same time? Well, you might say, it can't start up
> because the /dev/video is disabled so we are home free on that one. But
> then
> 	-- What if it is the other way around, and the webcam interface is
> active, and the user (or some idiot automated software like what I
> mentioned above!) decides to start up the stillcam apps? What then? Does
> libusb just cut off the /dev/videoX device in the middle of things?
> 

It does look as though there might be an issue here - the IOCTL that libusb 
uses calls usb_driver_release_interface in drivers/core/usb/devio.c, the 
definition of that function says "Callers must own the device lock" but as far 
as I can see it won't and a quick test running gphoto2 -L while streaming 
video does indicate it is making a severe mess of things.

> 2. This adaptation to libusb solves the specific problem of handling
> dual-mode hardware for which one of the modes is handled by the kernel and
> the other mode is handled in userspace, through libusb. The further
> refinement of libusb addresses only this problem, not the general problem
> of dual-mode or triple-mode hardware, in the case that all functionality
> of the hardware is addressed through the kernel. Therefore, your solution
> ends up being a partial cure to a general problem, not a general cure for
> a general problem. Further, it is much easier to solve the locking issues
> which arise if the basic access to the hardware is through the kernel for
> all of its functionality.

If you can solve the locking problem between devices in the kernel then it 
shouldn't matter if one of the kernel devices is the generic device that is 
used to support libusb. 

> 
> Thus, while originally favoring your approach, my position is at this
> point more in the direction that something needs to be done about this at
> the level of the kernel. As I said, others have convinced me of this,
> mainly Hans, because at first I thought your way of doing it was plenty
> good enough.
> 
> Thanks for joining the debate, Adam, even though I just gave an opinion
> that you don't have the most optimal solution. I think that this problem
> has gone on long enough, and we all need to get together and fix it.

That it has gone on long enough is something I can't argue with, my original 
posts on the subject were 2 years ago. I don't have time to actually work on 
this so while I'll try to review what is happening whoever does work on it 
gets to choose what is the best solution from the suggestions that are made.

Adam
