Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47822 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLII7A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 03:59:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <greg@kroah.com>
Cc: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: uvcvideo logging kernel warnings on device disconnect
Date: Fri, 09 Dec 2016 10:59:24 +0200
Message-ID: <3934137.UccFJV1Tl7@avalon>
In-Reply-To: <20161209072552.GA1513@kroah.com>
References: <ab3241e7-c525-d855-ecb6-ba04dbdb030f@destevenson.freeserve.co.uk> <4641182.Fvs5tG4yD4@avalon> <20161209072552.GA1513@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Friday 09 Dec 2016 08:25:52 Greg KH wrote:
> On Fri, Dec 09, 2016 at 01:09:21AM +0200, Laurent Pinchart wrote:
> > On Thursday 08 Dec 2016 12:31:55 Dave Stevenson wrote:
> >> Hi All.
> >> 
> >> I'm working with a USB webcam which has been seen to spontaneously
> >> disconnect when in use. That's a separate issue, but when it does it
> >> throws a load of warnings into the kernel log if there is a file handle
> >> on the device open at the time, even if not streaming.
> >> 
> >> I've reproduced this with a generic Logitech C270 webcam on:
> >> - Ubuntu 16.04 (kernel 4.4.0-51) vanilla, and with the latest media tree
> >> from linuxtv.org
> >> - Ubuntu 14.04 (kernel 4.4.0-42) vanilla
> >> - an old 3.10.x tree on an embedded device.
> >> 
> >> To reproduce:
> >> - connect USB webcam.
> >> - run a simple app that opens /dev/videoX, sleeps for a while, and then
> >> closes the handle.
> >> - disconnect the webcam whilst the app is running.
> >> - read kernel logs - observe warnings. We get the disconnect logged as
> >> it occurs, but the warnings all occur when the file descriptor is
> >> closed. (A copy of the logs from my Ubuntu 14.04 machine are below).
> >> 
> >> I can fully appreciate that the open file descriptor is holding
> >> references to a now invalid device, but is there a way to avoid them? Or
> >> do we really not care and have to put up with the log noise when doing
> >> such silly things?
> > 
> > This is a known problem, caused by the driver core trying to remove the
> > same sysfs attributes group twice.
> 
> Ick, not good.
> 
> > The group is first removed when the USB device is disconnected. The input
> > device and media device created by the uvcvideo driver are children of the
> > USB interface device, which is deleted from the system when the camera is
> > unplugged. Due to the parent-child relationship, all sysfs attribute
> > groups of the children are removed.
> 
> Wait, why is the USB device being removed from sysfs at this point,
> didn't the input and media subsystems grab a reference to it so that it
> does not disappear just yet?

References are taken in uvc_prove():

        dev->udev = usb_get_dev(udev);
        dev->intf = usb_get_intf(intf);

and released in uvc_delete(), called when the last video device node is 
closed. This prevents the device from being released (freed), but device_del() 
is synchronous to device unplug as far as I understand.

> > Then, when the device node is closed, the media device and input device
> > are unregistered, causing the corresponding devices to be deleted too. The
> > driver core tries to remove the sysfs attributes groups related to those
> > devices, and issues a warning as they have been removed already.
> > 
> > I'm not sure how to fix that, any hint from LKML would be appreciated.
> 
> Properly grab a reference to the USB device?  :)
> 
> If that's already happening, please let me know and I'll see what needs
> to be done, but I think that should solve the issue for you.

-- 
Regards,

Laurent Pinchart

