Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37603 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756942AbcLUJ7m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Dec 2016 04:59:42 -0500
Date: Wed, 21 Dec 2016 10:59:54 +0100
From: Greg KH <greg@kroah.com>
To: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: uvcvideo logging kernel warnings on device disconnect
Message-ID: <20161221095954.GG27395@kroah.com>
References: <ab3241e7-c525-d855-ecb6-ba04dbdb030f@destevenson.freeserve.co.uk>
 <3934137.UccFJV1Tl7@avalon>
 <20161209091113.GB27160@kroah.com>
 <2080235.u14sVkzQLZ@avalon>
 <20161209094304.GB4755@kroah.com>
 <01726e81-bbc2-b9a0-b2f0-045e3208f7b2@destevenson.freeserve.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01726e81-bbc2-b9a0-b2f0-045e3208f7b2@destevenson.freeserve.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 20, 2016 at 11:19:23AM +0000, Dave Stevenson wrote:
> Hi Greg.
> 
> On 09/12/16 09:43, Greg KH wrote:
> > On Fri, Dec 09, 2016 at 11:14:41AM +0200, Laurent Pinchart wrote:
> > > Hi Greg,
> > > 
> > > On Friday 09 Dec 2016 10:11:13 Greg KH wrote:
> > > > On Fri, Dec 09, 2016 at 10:59:24AM +0200, Laurent Pinchart wrote:
> > > > > On Friday 09 Dec 2016 08:25:52 Greg KH wrote:
> > > > > > On Fri, Dec 09, 2016 at 01:09:21AM +0200, Laurent Pinchart wrote:
> > > > > > > On Thursday 08 Dec 2016 12:31:55 Dave Stevenson wrote:
> > > > > > > > Hi All.
> > > > > > > > 
> > > > > > > > I'm working with a USB webcam which has been seen to spontaneously
> > > > > > > > disconnect when in use. That's a separate issue, but when it does it
> > > > > > > > throws a load of warnings into the kernel log if there is a file
> > > > > > > > handle on the device open at the time, even if not streaming.
> > > > > > > > 
> > > > > > > > I've reproduced this with a generic Logitech C270 webcam on:
> > > > > > > > - Ubuntu 16.04 (kernel 4.4.0-51) vanilla, and with the latest media
> > > > > > > > tree from linuxtv.org
> > > > > > > > - Ubuntu 14.04 (kernel 4.4.0-42) vanilla
> > > > > > > > - an old 3.10.x tree on an embedded device.
> > > > > > > > 
> > > > > > > > To reproduce:
> > > > > > > > - connect USB webcam.
> > > > > > > > - run a simple app that opens /dev/videoX, sleeps for a while, and
> > > > > > > > then closes the handle.
> > > > > > > > - disconnect the webcam whilst the app is running.
> > > > > > > > - read kernel logs - observe warnings. We get the disconnect logged
> > > > > > > > as it occurs, but the warnings all occur when the file descriptor is
> > > > > > > > closed. (A copy of the logs from my Ubuntu 14.04 machine are below).
> > > > > > > > 
> > > > > > > > I can fully appreciate that the open file descriptor is holding
> > > > > > > > references to a now invalid device, but is there a way to avoid them?
> > > > > > > > Or do we really not care and have to put up with the log noise when
> > > > > > > > doing such silly things?
> > > > > > > 
> > > > > > > This is a known problem, caused by the driver core trying to remove
> > > > > > > the same sysfs attributes group twice.
> > > > > > 
> > > > > > Ick, not good.
> > > > > > 
> > > > > > > The group is first removed when the USB device is disconnected. The
> > > > > > > input device and media device created by the uvcvideo driver are
> > > > > > > children of the USB interface device, which is deleted from the system
> > > > > > > when the camera is unplugged. Due to the parent-child relationship,
> > > > > > > all sysfs attribute groups of the children are removed.
> > > > > > 
> > > > > > Wait, why is the USB device being removed from sysfs at this point,
> > > > > > didn't the input and media subsystems grab a reference to it so that it
> > > > > > does not disappear just yet?
> > > > > 
> > > > > References are taken in uvc_prove():
> > > > >         dev->udev = usb_get_dev(udev);
> > > > >         dev->intf = usb_get_intf(intf);
> > > > 
> > > > s/uvc_prove/uvc_probe/ ?  :)
> > > 
> > > Oops :-)
> > > 
> > > > > and released in uvc_delete(), called when the last video device node is
> > > > > closed. This prevents the device from being released (freed), but
> > > > > device_del() is synchronous to device unplug as far as I understand.
> > > > 
> > > > Ok, good, that means the UVC driver is doing the right thing here.
> > > > 
> > > > But the sysfs files should only be attempted to be removed by the driver
> > > > core once, when the device is removed from sysfs, not twice, which is
> > > > really odd.
> > > > 
> > > > Is there a copy of the "simple app that grabs the device node" anywhere
> > > > so that I can test it out here with my USB camera device to try to track
> > > > down where the problem is?
> > > 
> > > Sure. The easiest way is to grab http://git.ideasonboard.org/yavta.git and run
> > > 
> > > yavta -c /dev/video0
> > > 
> > > (your mileage may vary if you have other video devices)
> > 
> > I'll point it at the correct device, /dev/video0 is built into this
> > laptop and can't be physically removed :)
> > 
> > > While the application is running, unplug the webcam, and then terminate the
> > > application with ctrl-C.
> > 
> > Ok, will try this out this afternoon and let you know how it goes.
> 
> I hate to pester, but wondered if you had found anything obvious.
> I really do appreciate you taking the time to look.

Sorry, I haven't had the chance and now will not be able to until
January....
