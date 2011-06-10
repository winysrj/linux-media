Return-path: <mchehab@pedra>
Received: from iolanthe.rowland.org ([192.131.102.54]:34484 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756035Ab1FJOsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 10:48:43 -0400
Date: Fri, 10 Jun 2011 10:48:41 -0400 (EDT)
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
In-Reply-To: <4DF1CDE1.4080303@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1106101023330.1921-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 10 Jun 2011, Hans de Goede wrote:

> Hi all,
> 
> The current API for managing kernel -> userspace is a bit
> rough around the edges, so I would like to discuss extending
> the API.
> 
> First of all an example use case scenarios where the current API
> falls short.
> 
> 1) Redirection of USB devices to a virtual machine, qemu, vbox, etc.
> all have the ability to redirect a USB device to the virtual machine,
> and they all use usbfs for this. The first thing which will happen
> here when the user selects a device to redirect is a
> IOCTL_USBFS_DISCONNECT. This causes the kernel driver to see a
> device unplug, with no chances for the kernel driver to do anything
> against this.
> 
> Now lets say the user does the following:
> -write a file to a usb flash disk
> -redirect the flash disk to a vm
> 
> Currently this will cause the usb mass storage driver to see a
> disconnect, and any possible still pending writes are lost ...
> 
> This is IMHO unacceptable, but currently there is nothing we can
> do to avoid this.

You haven't given a proper description of the problem.  See below.

> 2) So called dual mode cameras are (cheap) stillcams often even
> without an lcdscreen viewfinder, and battery backed sram instead
> of flash, which double as a webcam. We have drivers for both the
> stillcam function of these (in libgphoto2, so using usbfs) as
> well as for the webcam function (v4l2 kernel drivers).
> 
> These drivers work well, and are mature. Yet the user experience
> is rather poor. Under gnome the still-cam contents will be
> automatically be made available as a "drive" using a gvfs-gphoto2 fuse
> mount. This however involves sending a disconnect to the v4l2 kernel
> driver, and thus the /dev/video# node disappearing. So if a user
> wants to use the device as a webcam he/she needs to first go to
> nautilus and unmount the gvfs mount. Until that is done the user will
> simply get a message from an app like cheese that he has no webcam,
> not even an ebusy error, just that he has no such device.
> 
> Again not good.

As Felipe has mentioned, this sounds like the sort of problem that 
can better be solved in userspace.  A dual-mode device like the one 
you describe really is either a still-cam or a webcam, never both at 
the same time.  Hence what users need is a utility program to switch 
modes (by loading/unloading the appropriate programs or drivers).  Or 
maybe a desktop daemon that could accomplish the same result 
automatically, based on requests from user programs.

> ###
> 
> So what do we need to make this situation better:
> 1) A usb_driver callback alternative to the disconnect callback,
>     I propose to call this soft_disconnect. This serves 2 purposes
>     a) It will allow the driver to tell the caller that that is not
>        a good idea by returning an error code (think usb mass storage
>        driver and mounted filesystem

Not feasible.  usb-storage has no idea whether or not a device it
controls has a mounted filesystem.  (All it does is send SCSI commands
to a device and get back the results.)  Since that's the main use
case you're interested in, this part of the proposal seems destined to
fail.

But userspace _does_ know where the mounted filesystems are.  
Therefore userspace should be responsible for avoiding programs that
want to take control of devices holding these filesystems.  That's the
reason why usbfs device nodes are owned by root and have 0644 mode;
there're can be written to only by programs with superuser privileges
-- and such programs are supposed to be careful about what they do.

>     b) It will allow for example a v4l2 driver to keep its /dev/video
>        node around
>     Note that b) means that the normal disconnect handler should still
>     be called after a soft reconnect on a real disconnect.

In some sense the disconnect callback for usb-storage already _is_
"soft".  Although the driver cannot refuse the disconnect, it _can_
continue to communicate with the device until the callback returns.

(As it happens, usb-storage _doesn't_ do any further communication with
the device.  This is mostly for historical reasons, to compensate for
shortcomings in the SCSI stack in earlier kernel versions.  On the
other hand, there really isn't much that you would want to send to a
mass-storage device during a soft disconnect.  Perhaps tell it to flush
its cache out to the storage medium -- but if there are no open file 
handles for the device and no mounted filesystems then the cache 
will already be flushed.)

> 2) A usb_driver soft_reconnect callback to match the soft_disconnect
> 3) A mechanism for a usb_driver to signal a usbfs fd owner of the device
>     it would like the device back. So for example the gvfs mount can be
>     automatically unmounted (if not busy).

This also should be handled in userspace.  USB drivers never "want
back" a device they are no longer bound to -- in fact, the device model
used throughout the kernel makes this whole idea meaningless.  Device
drivers don't want devices back.  Rather, _users_ want to turn control
of devices over to specific drivers.  That's why this problem needs to
be handled in userspace.

> 4) A IOCTL_USBFS_SOFT_DISCONNECT ioctl which will call the drivers
>     soft_disconnect if it has one, and otherwise fall back to the
>     regular disconnect.
> 5) A method for a usbfs fd owning app to know the device driver would
>     like the device back. I suggest using poll with POLLIN to signal this.

It seems as if you're trying to implement some notion of allowing a 
device to have more than one driver at the same time.  This is so far 
out from the way the kernel behaves now, adopting it would be very 
difficult if not impossible.  Certainly the USB stack isn't the place 
to start.

Alan Stern

