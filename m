Return-path: <mchehab@pedra>
Received: from netrider.rowland.org ([192.131.102.5]:58564 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751850Ab1FKQ5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 12:57:54 -0400
Date: Sat, 11 Jun 2011 12:57:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	<linux-media@vger.kernel.org>,
	<libusb-devel@lists.sourceforge.net>,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, <hector@marcansoft.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	<pbonzini@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Felipe Balbi <balbi@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
In-Reply-To: <4DF3324E.3050506@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1106111250390.3439-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 11 Jun 2011, Hans de Goede wrote:

> >> So what do we need to make this situation better:
> >> 1) A usb_driver callback alternative to the disconnect callback,
> >>      I propose to call this soft_disconnect. This serves 2 purposes
> >>      a) It will allow the driver to tell the caller that that is not
> >>         a good idea by returning an error code (think usb mass storage
> >>         driver and mounted filesystem
> >
> > Not feasible.  usb-storage has no idea whether or not a device it
> > controls has a mounted filesystem.  (All it does is send SCSI commands
> > to a device and get back the results.)  Since that's the main use
> > case you're interested in, this part of the proposal seems destined to
> > fail.
> >
> 
> This is not completely true, I cannot rmmod usb-storage as long as
> disks using it are mounted. I know this is done through the global
> module usage count, so this is not per usb-storage device. But extending
> the ref counting to be per usb-storage device should not be hard.
> 
> All the accounting is already done for this.

It would be harder than you think.  All the accounting is _not_ already
being done.  What you're talking about would amount to a significant
change in the driver model core and the SCSI core.  It isn't just a USB
thing.

> > But userspace _does_ know where the mounted filesystems are.
> > Therefore userspace should be responsible for avoiding programs that
> > want to take control of devices holding these filesystems.  That's the
> > reason why usbfs device nodes are owned by root and have 0644 mode;
> > there're can be written to only by programs with superuser privileges
> > -- and such programs are supposed to be careful about what they do.
> >
> 
> Yes, and what I'm asking for is for an easy way for these programs to
> be careful. A way for them to ask the kernel, which in general is
> responsible for things like this and traditionally does resource
> management and things which come with that like refcounting: "unbind
> the driver from this device unless the device is currently in use".

Sure.  At the moment the kernel does not keep track of whether a device 
is currently in use -- at least, not in the way you mean.

I'm not saying this can't be done.  But it would be a bigger job than 
you think, and this isn't the appropriate thread to discuss it.

Alan Stern

