Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42672 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753521Ab1HHUdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 16:33:18 -0400
Date: Mon, 8 Aug 2011 16:33:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
cc: Adam Baker <linux@baker-net.org.uk>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <alpine.LNX.2.00.1108081435340.21636@banach.math.auburn.edu>
Message-ID: <Pine.LNX.4.44L0.1108081623490.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Aug 2011, Theodore Kilgore wrote:

> > > > Maybe a good compromise would be to create a kind of stub driver that
> > > > could negotiate the device access while still delegating most of the
> > > > real work to userspace.
> > > 
> > > Hooray. This appears to me to be a very good solution.
> > 
> > I'm not so sure.  It would require vast changes to the userspace
> > program, for example.
> 
> Such as?

Such as completely rewriting the USB interface.  You wouldn't be able 
to use libusb, for example.

> > The method Hans suggested was rather clunky.  
> 
> If it involves moving practically all of the gory details of the support 
> of stillcam mode for individual dual-mode cameras into the kernel, then it 
> certainly appears clunky to me, too. 
> 
> It also required drivers
> > to know when the device was in use, which may be okay for a video
> > driver but is not so practical for usb-storage (although to be fair, I
> > suspect usb-storage wouldn't need to be involved).  
> 
> Yes, I can see that. Usb-storage is, essentially, "in use" while the 
> device is attached, and that has to be true because the device is a 
> storage device. And alas, not all storage devices even get mounted, so one 
> cannot decide whether the device is "in use" just by checking whether or 
> not something on it is mounted ...
> 
> And it required
> > kernel drivers to inform user programs somehow when they want to get
> > control of the device back, 
> 
> Why, exactly?

Don't ask me, ask Hans!  :-)

>  I mean, fundamentally we have two functionalities of the 
> device which are accessed, at the user level, by two userspace programs. 
> One of them gets the still photos off the camera, and the other one gets 
> the video stream. Perhaps we just need a method for saying "No!" to either 
> one of those apps if the other one is using the camera?

That's basically what I suggested below.

> > which is not the sort of thing drivers
> > normally have to do.
> > 
> > Even if we could come up with a way to let the video driver somehow 
> > "share" ownership of the device with usbfs, we'd still have to set up a 
> > protocol for deciding who was in charge at any given time.  Would it be 
> > okay for the userspace program simply to say "I want control now" and 
> > "I'm done, you can have control back"?
> 
> Actually, I would expect that if one program is accessing the device then 
> the other one can't, and this works the same in both directions. Unless 
> you think that what you described is better?

When a program uses libgphoto2, how is the kernel supposed to know when
the program is busy accessing the device?  The kernel can't just ask
the program.

> Incidentally, I think that in some respects the fact that webcam support 
> is in the kernel and stillcam support is in userspace is a red herring. 

No, this has some significant implications.  In particular, there's no
good way for the kernel driver to ask the userspace driver if it is
busy.  If both drivers were in the kernel, this would be easy to
arrange.

Alan Stern

