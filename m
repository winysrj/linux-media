Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:42788 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1HHD2j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2011 23:28:39 -0400
Date: Sun, 7 Aug 2011 22:33:36 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Adam Baker <linux@baker-net.org.uk>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <Pine.LNX.4.44L0.1108071914440.17195-100000@netrider.rowland.org>
Message-ID: <alpine.LNX.2.00.1108072158210.20613@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1108071914440.17195-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 7 Aug 2011, Alan Stern wrote:

> On Sun, 7 Aug 2011, Adam Baker wrote:
> 
> > I've addec Hans de Geode and linux-usb to the CC as this response picks up on 
> > a related discussion about the usb mini summit.
> > 
> > On Friday 05 August 2011, Theodore Kilgore wrote:
> > > > If you can solve the locking problem between devices in the kernel then
> > > > it  shouldn't matter if one of the kernel devices is the generic device
> > > > that is used to support libusb.
> > > 
> > > Hmmm. Perhaps not. While we are on the topic, what exactly do you mean by 
> > > "the generic device that is used to support libusb." Which device is that, 
> > > exactly?
> > 
> > The file drivers/usb/core/devio.c registers itself as a driver called 
> > usb_device which is used to provide all of the device drivers that live under 
> > /proc/bus/usb
> 
> Let's get things correct.  The driver is called usbfs, not usb_device.  
> The things that live under /proc/bus/usb are files representing USB
> devices, not device drivers.

This indirectly answers my question, above, about whatever device there 
may or may not be. What I get from this, and also from a bit of snooping 
around, is that there is not any dev that gets created in order to be 
accessed by libusb. Just an entry under /proc/bus/usb, which AFAICT is at 
most a pseudo-device. Thanks.

So, Alan, what do you think is the best way to go about the problem? The 
camera can act as a stillcam or as a webcam. The problem is to provide 
access to both, with equal facility (and of course to lock out access to 
whichever action is not currently in use, if the other one is). 

The current situation with libusb does not cut it, as among other things 
it currently does only half the job and seemingly cannot address the 
locking problem. Hans suggests to create two explicit devices, /dev/video 
(as already done and something like /dev/cam. Then access webcam function 
as now and stillcam function with libgphoto2, as now, but through /dev/cam 
instead of through libusb. This would seem to me to solve all the 
problems, but at the expense of some work. Can you think of something more 
clever?

Theodore Kilgore
