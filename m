Return-path: <linux-media-owner@vger.kernel.org>
Received: from april.london.02.net ([87.194.255.143]:52345 "EHLO
	april.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1HHAbJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2011 20:31:09 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Date: Mon, 8 Aug 2011 01:30:57 +0100
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <Pine.LNX.4.44L0.1108071914440.17195-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108071914440.17195-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108080130.57394.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 August 2011, Alan Stern wrote:
> On Sun, 7 Aug 2011, Adam Baker wrote:
> > I've addec Hans de Geode and linux-usb to the CC as this response picks
> > up on a related discussion about the usb mini summit.
> > 
> > On Friday 05 August 2011, Theodore Kilgore wrote:
> > > > If you can solve the locking problem between devices in the kernel
> > > > then it  shouldn't matter if one of the kernel devices is the
> > > > generic device that is used to support libusb.
> > > 
> > > Hmmm. Perhaps not. While we are on the topic, what exactly do you mean
> > > by "the generic device that is used to support libusb." Which device
> > > is that, exactly?
> > 
> > The file drivers/usb/core/devio.c registers itself as a driver called
> > usb_device which is used to provide all of the device drivers that live
> > under /proc/bus/usb
> 
> Let's get things correct.  The driver is called usbfs, not usb_device.
> The things that live under /proc/bus/usb are files representing USB
> devices, not device drivers.

OK, I was taking the name from the register_chrdev_region call which is 
ambiguous as to whether that is a driver name or just a name to associate with 
the devices the driver creates. Hopefully I at least gave enough info to make 
my meaning clear.

> 
> > If you look in there for the code to handle the ioctl()
> > USBDEVFS_DISCONNECT then you will find the code that is called when you
> > make a
> > usb_detach_kernel_driver_np() call through libusb. That code, according
> > to the documentation and my testing needs to acquire a lock before it
> > calls usb_driver_release_interface(). Based on my testing to date (using
> > cheese to start a camera streaming and then gphoto2 -L to trigger the
> > disconnect ioctl) I would suggest that the fact it doesn't is a kernel
> > bug that needs fixing
> 
> What makes you think the code doesn't acquire the lock?  (Hint: Look at
> usbdev_do_ioctl() instead of proc_ioctl().)

My assumption is based on observed behaviour rather than looking at the code. 

> 
> > regardless of whether there is any user space solution to camera mode
> > switching because that code could potentially get called on any in use
> > USB device and if it does even thing like lsusb don't work correctly
> > afterwards and completely unrelated devices don't work if they are later
> > plugged into the same USB port.
> 
> That's a rather incomprehensible run-on sentence, but as near as I can
> tell, it is wrong.

Further testing reveals the situation is more complex than I first thought - 
the behaviour I get depends upon whether what gets plugged in is a full speed 
or a high speed device. After I've run the test of running gphoto whilst 
streaming from a supported dual mode camera, lsusb fails to recognise a high 
speed device plugged into the port the camera was plugged into (it works fine 
if plugged in elsewhere) and lsusb hangs if I plug in a new low speed or full 
speed device. When I get some time I'll see if I can recreate the problem 
using libusb with a totally different device. Looking around my pile of USB 
bits for something full speed with a kernel driver I've got a PL2303 serial 
port. Would that be a good choice to test with?

Just for reference with a full speed device I see the messages below in dmesg
with the second one only appearing when I do lsusb
[10832.128039] usb 3-2: new full speed USB device using uhci_hcd and address 
34
[10847.240031] usb 3-2: device descriptor read/64, error -110

and with a high speed device I see a continuous stream of
[11079.820097] usb 1-4: new high speed USB device using ehci_hcd and address 
103
[11079.888355] hub 1-0:1.0: unable to enumerate USB device on port 4
[11080.072377] hub 1-0:1.0: unable to enumerate USB device on port 4
[11080.312053] usb 1-4: new high speed USB device using ehci_hcd and address 
105
[11080.380418] hub 1-0:1.0: unable to enumerate USB device on port 4
[11080.620030] usb 1-4: new high speed USB device using ehci_hcd and address 
106
[11080.688322] hub 1-0:1.0: unable to enumerate USB device on port 4

Adam Baker
