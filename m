Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49249 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752150Ab1HHTWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 15:22:42 -0400
Date: Mon, 8 Aug 2011 15:22:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
cc: Adam Baker <linux@baker-net.org.uk>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <alpine.LNX.2.00.1108081241380.21409@banach.math.auburn.edu>
Message-ID: <Pine.LNX.4.44L0.1108081411460.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Aug 2011, Theodore Kilgore wrote:

> On Mon, 8 Aug 2011, Alan Stern wrote:
> 
> > On Sun, 7 Aug 2011, Theodore Kilgore wrote:
> > 
> > > This indirectly answers my question, above, about whatever device there 
> > > may or may not be. What I get from this, and also from a bit of snooping 
> > > around, is that there is not any dev that gets created in order to be 
> > > accessed by libusb. Just an entry under /proc/bus/usb, which AFAICT is at 
> > > most a pseudo-device. Thanks.
> > 
> > Nowadays, most distributions create device nodes under /dev/bus/usb.  A 
> > few also support the old /proc/bus/usb files.
> 
> What does this mean, exactly, in practice? You are right that I have the 
> /dev/bus/usb/ files but does everybody have them, these days?

Pretty much everybody using udev should have them, which means pretty 
much every desktop system.

...

> > Maybe a good compromise would be to create a kind of stub driver that
> > could negotiate the device access while still delegating most of the
> > real work to userspace.
> 
> Hooray. This appears to me to be a very good solution.

I'm not so sure.  It would require vast changes to the userspace
program, for example.

> I agree approximately 120% with this. Let's think of a more clever way. If 
> we get the basic idea right, it really ought not to be too terribly 
> difficult.

The method Hans suggested was rather clunky.  It also required drivers
to know when the device was in use, which may be okay for a video
driver but is not so practical for usb-storage (although to be fair, I
suspect usb-storage wouldn't need to be involved).  And it required
kernel drivers to inform user programs somehow when they want to get
control of the device back, which is not the sort of thing drivers
normally have to do.

Even if we could come up with a way to let the video driver somehow 
"share" ownership of the device with usbfs, we'd still have to set up a 
protocol for deciding who was in charge at any given time.  Would it be 
okay for the userspace program simply to say "I want control now" and 
"I'm done, you can have control back"?

For that matter, what should the video driver do if the user program 
crashes or hangs while in charge of the device?

Alan Stern

