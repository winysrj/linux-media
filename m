Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd18532.kasserver.com ([85.13.139.13]:33782 "EHLO
	dd18532.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbZAWOEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 09:04:50 -0500
Date: Fri, 23 Jan 2009 15:04:47 +0100
From: Carsten Meier <cm@trexity.de>
To: Thierry Merle <thierry.merle@free.fr>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-media@vger.kernel.org
Subject: How to obtain sysfs-path from bus_info
Message-ID: <20090123150447.4a7d7ead@tuvok>
In-Reply-To: <4978E128.3050701@free.fr>
References: <20090115184133.724d1d70@tuvok>
	<200901220020.00520.laurent.pinchart@skynet.be>
	<20090122012111.00634e0b@tuvok>
	<200901221657.37189.laurent.pinchart@skynet.be>
	<4978E128.3050701@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Thu, 22 Jan 2009 22:12:08 +0100
schrieb Thierry Merle <thierry.merle@free.fr>:

> Laurent Pinchart a écrit :
> > On Thursday 22 January 2009, Carsten Meier wrote:
> >> Am Thu, 22 Jan 2009 00:20:00 +0100
> >>
> >> schrieb Laurent Pinchart <laurent.pinchart@skynet.be>:
> >>> Hi Carsten,
> >>>
> >>> On Wednesday 21 January 2009, Carsten Meier wrote:
> >>>> now I want to translate bus_info into a sysfs-path to obtain
> >>>> device-info like serial numbers. Given a device reports
> >>>> "usb-0000:00:1d.2-2" as bus_info, then the device-info is located
> >>>> under "/sys/bus/usb/devices/2-2", which is a symlink to the
> >>>> appropriate /sys/devices/ directory, right?
> >>> I'm afraid not. In the above bus_info value, 0000:00:1d.2 is the
> >>> PCI bus path of your USB controller, and the last digit after the
> >>> dash is the USB device path.
> >>>
> >>>> All I have to do is to compare the first 4 chars of bus_info
> >>>> against "usb-", get the chars after "." and append it to
> >>>> "/sys/bus/usb/devices/" to obatin a sysfs-path, right?
> >>>>
> >>>> Is there a more elegant solution or already a function for this?
> >>>> Can the "." appear more than once before the last one?
> >>> Probably not before, but definitely after.
> >>>
> >>> Root hubs get a USB device path set to '0'. Every other device is
> >>> numbered according to the hub port number it is connected to. If
> >>> you have an external hub connected on port 2 of your root hub,
> >>> and have a webcam connected to port 3 of the external hub,
> >>> usb_make_path() will return "usb-0000:00:1d.2-2.3".
> >>>
> >>> Cheers,
> >>>
> >>> Laurent Pinchart
> >> Hi,
> >>
> >> On my machine, my pvrusb2 (connected directly to my mini-pc) shows
> >> up under "/sys/bus/usb/devices/7-2/" which is a symbolic link to
> >> "../../../devices/pci0000:00/0000:00:1d.7/usb7/7-2"
> > 
> > You're just lucky that USB bus 7 (usb7/7) is connected to the 7th
> > function of your USB host controller (1d.7).
> > 
> > Here's an example of what I get on my computer:
> > 
> > /sys/bus/usb/devices/4-2
> > -> ../../../devices/pci0000:00/0000:00:1d.2/usb4/4-2
> > 
> >> I can't test for the new bus_info-string, because it's not fixed
> >> yet in the driver. But if I got it correctly it should be
> >> "usb-0000:00:1d.7-7.2" ?
> > 
> > I think you will get usb-0000:00:1d.7-2
> > 
> >> Then I've to simply take the string after the last dash, replace
> >> "." by "-" and append it to "/sys/bus/usb/devices/" for a
> >> sysfs-path?
> > 
> > Unfortunately the mapping is not that direct. The part before the
> > last dash identifies the USB host controller. The part after the
> > last dash identifies the device path related to the controller,
> > expressed as a combination of port numbers.
> > 
> > The sysfs device path /sys/bus/usb/devices/7-2/ includes a USB bus
> > number (in this case 7) that is not present in usb_make_path()'s
> > output.
> > 
> > To find the sysfs path of your USB peripheral, you will have to
> > find out which bus number the bus name (0000:00:1d.7) corresponds
> > to. You might be able to find that by checking each usb[0-9]+ links
> > in /sys/bus/usb/devices and comparing the link's target with the
> > bus name.
> > 
> To ease this processing, using libsysfs can be a good idea...
> On my system, the documentation of libsysfs is here:
> /usr/doc/sysfsutils-2.1.0/libsysfs.txt
> Knowing the bus-id, it won't be hard to look at it in data structures.
> Just my 2 cents.

Hi,

I already looked at it, but it doesn't help very much if you don't know
how sysfs is organized in detail. The sysfs-reference at
http://www.kernel.org/pub/linux/kernel/people/mochel/doc/papers/ols-2005/
also doesn't help very much as it only gives a brief overview.

Regards,
Carsten
