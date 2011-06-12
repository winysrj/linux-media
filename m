Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:35173 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab1FLVSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 17:18:16 -0400
Date: Sun, 12 Jun 2011 16:20:01 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Felipe Balbi <balbi@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
In-Reply-To: <4DF4A662.5090705@redhat.com>
Message-ID: <alpine.LNX.2.00.1106121554090.13986@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1106101023330.1921-100000@iolanthe.rowland.org> <4DF3324E.3050506@redhat.com> <alpine.LNX.2.00.1106111058170.12801@banach.math.auburn.edu> <4DF4A662.5090705@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Sun, 12 Jun 2011, Hans de Goede wrote:

> Hi,
> 
> On 06/11/2011 06:19 PM, Theodore Kilgore wrote:
> > 
> > 
> > On Sat, 11 Jun 2011, Hans de Goede wrote:
> > 
> > > Hi,
> > > 
> > > Given the many comments in this thread, I'm just
> > > going reply to this one, and try to also answer any
> > > other ones in this mail.
> > > 
> > > As far as the dual mode camera is involved, I agree
> > > that that should be fixed in the existing v4l2
> > > drivers + libgphoto. I think that Felipe's solution
> > > to also handle the stillcam part in kernel space for
> > > dual mode cameras (and add a libgphoto cam driver which
> > > knows how to talk the new kernel API for this), is
> > > the best solution. Unfortunately this will involve
> > > quite a bit of work, but so be it.
> > 
> > Hans,
> > 
> > It appears to me that the solution ought to be at hand, actually.
> > 
> > I was not aware of the recent changes in libusb, which I understand are
> > supposed to allow a kernel driver to be hooked up again.
> > 
> > To review the situation:
> > 
> > 1. As of approximately 2 years ago, libusb already was so configured as to
> > suspend the kernel module for a dual-mode device if a userspace-based
> > program tried to claim the device.
> > 
> > 2. At this point with the more recent versions of libusb (see the last
> > message from yesterday, from Xiaofan Chen), we are supposed to be able to
> > re-activate the kernel module for the device when it is relinquished by
> > userspace.
> > 
> > This ought to take care of the problems completely, provided that the new
> > capabilities of libusb are actually used and called upon in libgphoto2.
> > 
> > I have checked on what is happening, just now, on my own machine. I have
> > libusb version 1.08 which ought to be recent enough. The advertised
> > abilities did not work, however. Presumably, what is missing is on the
> > other end of the problem, most likely in the functions in libgphoto2 which
> > hook up a camera. That code would presumably need to call upon the new
> > functionality of libusb. My currently installed version of libgphoto2
> > (from svn, but several months old) clearly does not contain the needed
> > functionality. But it might have been put in recently and I did not
> > notice. I guess that the first thing to do is to update my gphoto tree and
> > then to see what happens. If things still don't work, then something needs
> > to be updated and then things ought to work.
> > 
> > I will try to see that something gets done about this. Thank you for
> > raising the old issue of dual-mode devices yet again, and thanks to
> > Xiaofan Chen for pointing out that the needed missing half of the
> > functionality is supposed to exist now in libusb. That had escaped my
> > attention.
> 
> Actually libusb and libgphoto have been using the rebind orginal driver
> functionality of the code for quite a while now, 

Oh? I can see that libusb is doing that, and I can also see that there is 
a "public" function for _unbinding_ a kernel driver, namely 

int usb_detach_kernel_driver_np()

found in usb.h

and it is used in libgphoto, as well.

I am not sure that there is any corresponding rebind function which is 
public. Is it perhaps

int usb_get_driver_np()

???

By context (looking at libgphoto2-port/usb/libusb.c) I would think that 
this function is not the rebind function, but is only checking whether or 
not there is any potential conflict with a kernel driver. If I am right, 
then where is the publicly exported rebind function, and where does it 
currently get used in libgphoto2? 

So frankly after my eagerness yesterday I do not see how it can easily be 
made to work, after all.

unfortunately this
> does not solve the problem, unless we somehow move to 1 central
> coordinator for the device the user experience will stay subpar.
> 
> Example, user downloads pictures from the camera using shotwell,
> gthumb, fspot or whatever, keeps the app in question open and the app
> in question keeps the gphoto2 device handle open.
> 
> User wants to do some skyping with video chat, skype complains it
> cannot find the device, since the kernel driver currently is unbound.
> 
> -> Poor user experience.

Poor user experience, or merely poor user? The user ought to know better. 
Of course, I do agree that there are lots of such people, and it is a good 
idea to try to put up warning signs. 


> 
> With having both functions in the kernel, the kernel could actually
> allow skype to use the dual mode cameras as video source, and if
> the user then were to switch to f-spot and try to import more photo's
> then he will get an -ebusy in f-spot. If he finishes skyping and
> then returns to f-spot everything will just continue working.
> 
> This is the kind of "seamless" user experience I'm aiming for here.
> 
> Regards,
> 
> Hans

Yes, I can see where you are coming from. But if the camera really will 
not let you run skype and fspot at the same time, which I do not believe 
it would allow on _any_ operating system, then each app should give an 
error message which says it cannot be run unless and until the other app 
has been closed. If that has to happen at the kernel level, then OK.

Theodore Kilgore
