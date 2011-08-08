Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:60900 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab1HHTxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 15:53:45 -0400
Date: Mon, 8 Aug 2011 14:58:40 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Adam Baker <linux@baker-net.org.uk>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <Pine.LNX.4.44L0.1108081411460.1944-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1108081435340.21636@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1108081411460.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 8 Aug 2011, Alan Stern wrote:

> On Mon, 8 Aug 2011, Theodore Kilgore wrote:
> 
> > On Mon, 8 Aug 2011, Alan Stern wrote:
> > 
> > > On Sun, 7 Aug 2011, Theodore Kilgore wrote:
> > > 
> > > > This indirectly answers my question, above, about whatever device there 
> > > > may or may not be. What I get from this, and also from a bit of snooping 
> > > > around, is that there is not any dev that gets created in order to be 
> > > > accessed by libusb. Just an entry under /proc/bus/usb, which AFAICT is at 
> > > > most a pseudo-device. Thanks.
> > > 
> > > Nowadays, most distributions create device nodes under /dev/bus/usb.  A 
> > > few also support the old /proc/bus/usb files.
> > 
> > What does this mean, exactly, in practice? You are right that I have the 
> > /dev/bus/usb/ files but does everybody have them, these days?
> 
> Pretty much everybody using udev should have them, which means pretty 
> much every desktop system.

OK, so far so good.

> 
> ...
> 
> > > Maybe a good compromise would be to create a kind of stub driver that
> > > could negotiate the device access while still delegating most of the
> > > real work to userspace.
> > 
> > Hooray. This appears to me to be a very good solution.
> 
> I'm not so sure.  It would require vast changes to the userspace
> program, for example.

Such as?

> 
> > I agree approximately 120% with this. Let's think of a more clever way. If 
> > we get the basic idea right, it really ought not to be too terribly 
> > difficult.
> 
> The method Hans suggested was rather clunky.  

If it involves moving practically all of the gory details of the support 
of stillcam mode for individual dual-mode cameras into the kernel, then it 
certainly appears clunky to me, too. 

It also required drivers
> to know when the device was in use, which may be okay for a video
> driver but is not so practical for usb-storage (although to be fair, I
> suspect usb-storage wouldn't need to be involved).  

Yes, I can see that. Usb-storage is, essentially, "in use" while the 
device is attached, and that has to be true because the device is a 
storage device. And alas, not all storage devices even get mounted, so one 
cannot decide whether the device is "in use" just by checking whether or 
not something on it is mounted ...

And it required
> kernel drivers to inform user programs somehow when they want to get
> control of the device back, 

Why, exactly? I mean, fundamentally we have two functionalities of the 
device which are accessed, at the user level, by two userspace programs. 
One of them gets the still photos off the camera, and the other one gets 
the video stream. Perhaps we just need a method for saying "No!" to either 
one of those apps if the other one is using the camera?

> which is not the sort of thing drivers
> normally have to do.
> 
> Even if we could come up with a way to let the video driver somehow 
> "share" ownership of the device with usbfs, we'd still have to set up a 
> protocol for deciding who was in charge at any given time.  Would it be 
> okay for the userspace program simply to say "I want control now" and 
> "I'm done, you can have control back"?

Actually, I would expect that if one program is accessing the device then 
the other one can't, and this works the same in both directions. Unless 
you think that what you described is better?

> 
> For that matter, what should the video driver do if the user program 
> crashes or hangs while in charge of the device?

Good one. Commit seppuku?

Seriously, though, what should it do if a video streaming userspace 
program crashes or hangs? Probably, the same thing should happen as it 
should if a photo-getting program crashes or hangs. Namely whatever needs 
to be done in order to prevent some kind of catastrophe ought to be 
implemented.

Incidentally, I think that in some respects the fact that webcam support 
is in the kernel and stillcam support is in userspace is a red herring. 
The fundamental problem is a piece of hardware which does two different 
kinds of things which require two different kinds of support. Further to 
narrow this, though, it is hardware which needs to be usable for either 
function at any time, which does distinguish it from such things as a 
one-shot loading of firmware as happens with mass storage USB modems.

Theodore Kilgore
