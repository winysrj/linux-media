Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33027 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1035268AbdD3QVd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Apr 2017 12:21:33 -0400
Date: Sun, 30 Apr 2017 18:18:44 +0200
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Daniel Axtens <dja@axtens.net>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Subject: Re: [PATCH 1/2] [media] uvcvideo: Refactor teardown of uvc on USB
 disconnect
Message-ID: <20170430161844.GA27431@kroah.com>
References: <20170417085240.12930-1-dja@axtens.net>
 <2540812.MKbs17NyWb@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2540812.MKbs17NyWb@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 17, 2017 at 03:23:55PM +0300, Laurent Pinchart wrote:
> Hi Daniel,
> 
> Thank you for the patch (and the investigation).
> 
> On Monday 17 Apr 2017 18:52:39 Daniel Axtens wrote:
> > Currently, disconnecting a USB webcam while it is in use prints out a
> > number of warnings, such as:
> > 
> > WARNING: CPU: 2 PID: 3118 at
> > /build/linux-ezBi1T/linux-4.8.0/fs/sysfs/group.c:237
> > sysfs_remove_group+0x8b/0x90 sysfs group ffffffffa7cd0780 not found for
> > kobject 'event13'
> > 
> > This has been noticed before. [0]
> > 
> > This is because of the order in which things are torn down.
> > 
> > If there are no streams active during a USB disconnect:
> > 
> >  - uvc_disconnect() is invoked via device_del() through the bus
> >    notifier mechanism.
> > 
> >  - this calls uvc_unregister_video().
> > 
> >  - uvc_unregister_video() unregisters the video device for each
> >    stream,
> > 
> >  - because there are no streams open, it calls uvc_delete()
> > 
> >  - uvc_delete() calls uvc_status_cleanup(), which cleans up the status
> >    input device.
> > 
> >  - uvc_delete() calls media_device_unregister(), which cleans up the
> >    media device
> > 
> >  - uvc_delete(), uvc_unregister_video() and uvc_disconnect() all
> >    return, and we end up back in device_del().
> > 
> >  - device_del() then cleans up the sysfs folder for the camera with
> >    dpm_sysfs_remove(). Because uvc_status_cleanup() and
> >    media_device_unregister() have already been called, this all works
> >    nicely.
> > 
> > If, on the other hand, there *are* streams active during a USB disconnect:
> > 
> >  - uvc_disconnect() is invoked
> > 
> >  - this calls uvc_unregister_video()
> > 
> >  - uvc_unregister_video() unregisters the video device for each
> >    stream,
> > 
> >  - uvc_unregister_video() and uvc_disconnect() return, and we end up
> >    back in device_del().
> > 
> >  - device_del() then cleans up the sysfs folder for the camera with
> >    dpm_sysfs_remove(). Because the status input device and the media
> >    device are children of the USB device, this also deletes their
> >    sysfs folders.
> > 
> >  - Sometime later, the final stream is closed, invoking uvc_release().
> > 
> >  - uvc_release() calls uvc_delete()
> > 
> >  - uvc_delete() calls uvc_status_cleanup(), which cleans up the status
> >    input device. Because the sysfs directory has already been removed,
> >    this causes a WARNing.
> > 
> >  - uvc_delete() calls media_device_unregister(), which cleans up the
> >    media device. Because the sysfs directory has already been removed,
> >    this causes another WARNing.
> > 
> > To fix this, we need to make sure the devices are always unregistered
> > before the end of uvc_disconnect(). To this, move the unregistration
> > into the disconnect path:
> >
> >  - split uvc_status_cleanup() into two parts, one on disconnect that
> >    unregisters and one on delete that frees.
> > 
> >  - move media_device_unregister() into the disconnect path.
> 
> While the patch looks reasonable to me (with one comment below though), isn't 
> this an issue with the USB core, or possibly the device core ? It's a common 
> practice to create device nodes as children of physical devices. Does the 
> device core really require all device nodes to be unregistered synchronously 
> with physical device hot-unplug ? If so, shouldn't it warn somehow when a 
> device is deleted and still has children, instead of accepting that silently 
> and later complaining due to sysfs issues ?

When a physical device, or any other device, is removed, the children
should all also be removed.  You can't leave them around to be cleaned
up later, this has always been the case.

Yes, userspace can still hold references, but that should be fine as the
device will still be unregistered, just not freed yet, right?

> > [0]: https://lkml.org/lkml/2016/12/8/657
> > 
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
> > Cc: Greg KH <greg@kroah.com>
> > Signed-off-by: Daniel Axtens <dja@axtens.net>
> > 
> > ---
> > 
> > Tested with cheese and yavta.
> > ---
> >  drivers/media/usb/uvc/uvc_driver.c | 8 ++++++--
> >  drivers/media/usb/uvc/uvc_status.c | 8 ++++++--
> >  drivers/media/usb/uvc/uvcvideo.h   | 1 +
> >  3 files changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index 46d6be0bb316..2390592f78e0
> > 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -1815,8 +1815,6 @@ static void uvc_delete(struct uvc_device *dev)
> >  	if (dev->vdev.dev)
> >  		v4l2_device_unregister(&dev->vdev);
> >  #ifdef CONFIG_MEDIA_CONTROLLER
> > -	if (media_devnode_is_registered(dev->mdev.devnode))
> > -		media_device_unregister(&dev->mdev);
> 
> media_device_unregister() will now be called before v4l2_device_unregister() 
> which, unless I'm mistaken, will now result in 
> media_device_unregister_entity() being called twice for every entity, the 
> first time by media_device_unregister(), and the second time by 
> v4l2_device_unregister_subdev() through v4l2_device_unregister(). Looking at 
> media_device_unregister() I don't think that's safe.
> 
> We could move to v4l2_device_unregister() call to uvc_unregister_video(), but 
> that worries me (perhaps unnecessarily though) due to the race conditions it 
> could introduce. Would you still be able to give it a try ?
> 
> Note that your patch isn't really at fault here, the media controller and V4L2 
> core code have been broken for a long time when it comes to entity lifetime 
> management. That might be fixed some day, but I won't hold my breath given the 
> bad track record of the previous year and a half.

Ugh, what a mess, I'll trust you that this is correct :)

thanks,

greg k-h
