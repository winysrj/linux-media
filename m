Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:41841 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751846Ab1HGXTK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2011 19:19:10 -0400
Date: Sun, 7 Aug 2011 19:19:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <201108072330.33981.linux@baker-net.org.uk>
Message-ID: <Pine.LNX.4.44L0.1108071914440.17195-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 7 Aug 2011, Adam Baker wrote:

> I've addec Hans de Geode and linux-usb to the CC as this response picks up on 
> a related discussion about the usb mini summit.
> 
> On Friday 05 August 2011, Theodore Kilgore wrote:
> > > If you can solve the locking problem between devices in the kernel then
> > > it  shouldn't matter if one of the kernel devices is the generic device
> > > that is used to support libusb.
> > 
> > Hmmm. Perhaps not. While we are on the topic, what exactly do you mean by 
> > "the generic device that is used to support libusb." Which device is that, 
> > exactly?
> 
> The file drivers/usb/core/devio.c registers itself as a driver called 
> usb_device which is used to provide all of the device drivers that live under 
> /proc/bus/usb

Let's get things correct.  The driver is called usbfs, not usb_device.  
The things that live under /proc/bus/usb are files representing USB
devices, not device drivers.

> If you look in there for the code to handle the ioctl() USBDEVFS_DISCONNECT 
> then you will find the code that is called when you make a 
> usb_detach_kernel_driver_np() call through libusb. That code, according to the 
> documentation and my testing needs to acquire a lock before it calls 
> usb_driver_release_interface(). Based on my testing to date (using cheese to 
> start a camera streaming and then gphoto2 -L to trigger the disconnect ioctl) 
> I would suggest that the fact it doesn't is a kernel bug that needs fixing 

What makes you think the code doesn't acquire the lock?  (Hint: Look at 
usbdev_do_ioctl() instead of proc_ioctl().)

> regardless of whether there is any user space solution to camera mode 
> switching because that code could potentially get called on any in use USB 
> device and if it does even thing like lsusb don't work correctly afterwards 
> and completely unrelated devices don't work if they are later plugged into the 
> same USB port.

That's a rather incomprehensible run-on sentence, but as near as I can 
tell, it is wrong.

Alan Stern

