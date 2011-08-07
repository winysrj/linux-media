Return-path: <linux-media-owner@vger.kernel.org>
Received: from anakin.london.02.net ([87.194.255.134]:34252 "EHLO
	anakin.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1HGWaj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2011 18:30:39 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Date: Sun, 7 Aug 2011 23:30:33 +0100
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <4E398381.4080505@redhat.com> <201108050004.55659.linux@baker-net.org.uk> <alpine.LNX.2.00.1108041847210.17969@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108041847210.17969@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108072330.33981.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've addec Hans de Geode and linux-usb to the CC as this response picks up on 
a related discussion about the usb mini summit.

On Friday 05 August 2011, Theodore Kilgore wrote:
> > If you can solve the locking problem between devices in the kernel then
> > it  shouldn't matter if one of the kernel devices is the generic device
> > that is used to support libusb.
> 
> Hmmm. Perhaps not. While we are on the topic, what exactly do you mean by 
> "the generic device that is used to support libusb." Which device is that, 
> exactly?

The file drivers/usb/core/devio.c registers itself as a driver called 
usb_device which is used to provide all of the device drivers that live under 
/proc/bus/usb

If you look in there for the code to handle the ioctl() USBDEVFS_DISCONNECT 
then you will find the code that is called when you make a 
usb_detach_kernel_driver_np() call through libusb. That code, according to the 
documentation and my testing needs to acquire a lock before it calls 
usb_driver_release_interface(). Based on my testing to date (using cheese to 
start a camera streaming and then gphoto2 -L to trigger the disconnect ioctl) 
I would suggest that the fact it doesn't is a kernel bug that needs fixing 
regardless of whether there is any user space solution to camera mode 
switching because that code could potentially get called on any in use USB 
device and if it does even thing like lsusb don't work correctly afterwards 
and completely unrelated devices don't work if they are later plugged into the 
same USB port.

With regard to userspace then stealing the device, 

Hans de Geode wrote
> Getting a bit offtopic here, but no a try_disconnect will fix the
> userspace stillcam mode driver being able to disconnect the device
> while the webcam function is active. If the webcam is not active
> userspace will still "win", and possibly never return the device
> back to the kernel driver (this already happens today with
> gvfs-gphoto creating a fuse mount and keeping the device open
> indefinitely, locking out the webcam function

With the current design gvfs-photo doesn't even need to keep the device open. 
The kernel provides an ioctl (USBDEVFS_CONNECT) that needs to be called before 
the kernel mode driver can use the interface again but libusb 0.1 doesn't 
expose it. Even if you use gphoto2 rather than gvfs that will cleanly close 
all the devices it used when it has finished with them it doesn't release the 
device back to the kernel but that is a failure of user space to call the 
provided API. I did once hack libgphoto to call USBDEVFS_CONNECT and it does 
then hand the device back correctly but it was a messy hack as it needed 
knowledge of the internals of libusb.

Regards

Adam
