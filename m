Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162111AbdD3Q4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Apr 2017 12:56:14 -0400
Date: Sun, 30 Apr 2017 18:19:06 +0200
From: Greg KH <greg@kroah.com>
To: Daniel Axtens <dja@axtens.net>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Subject: Re: [PATCH v2] [media] uvcvideo: Refactor teardown of uvc on USB
 disconnect
Message-ID: <20170430161906.GB27431@kroah.com>
References: <20170423045349.10292-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170423045349.10292-1-dja@axtens.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 23, 2017 at 02:53:49PM +1000, Daniel Axtens wrote:
> Currently, disconnecting a USB webcam while it is in use prints out a
> number of warnings, such as:
> 
> WARNING: CPU: 2 PID: 3118 at /build/linux-ezBi1T/linux-4.8.0/fs/sysfs/group.c:237 sysfs_remove_group+0x8b/0x90
> sysfs group ffffffffa7cd0780 not found for kobject 'event13'
> 
> This has been noticed before. [0]
> 
> This is because of the order in which things are torn down.
> 
> If there are no streams active during a USB disconnect:
> 
>  - uvc_disconnect() is invoked via device_del() through the bus
>    notifier mechanism.
> 
>  - this calls uvc_unregister_video().
> 
>  - uvc_unregister_video() unregisters the video device for each
>    stream,
> 
>  - because there are no streams open, it calls uvc_delete()
> 
>  - uvc_delete() calls uvc_status_cleanup(), which cleans up the status
>    input device.
> 
>  - uvc_delete() calls media_device_unregister(), which cleans up the
>    media device
> 
>  - uvc_delete(), uvc_unregister_video() and uvc_disconnect() all
>    return, and we end up back in device_del().
> 
>  - device_del() then cleans up the sysfs folder for the camera with
>    dpm_sysfs_remove(). Because uvc_status_cleanup() and
>    media_device_unregister() have already been called, this all works
>    nicely.
> 
> If, on the other hand, there *are* streams active during a USB disconnect:
> 
>  - uvc_disconnect() is invoked
> 
>  - this calls uvc_unregister_video()
> 
>  - uvc_unregister_video() unregisters the video device for each
>    stream,
> 
>  - uvc_unregister_video() and uvc_disconnect() return, and we end up
>    back in device_del().
> 
>  - device_del() then cleans up the sysfs folder for the camera with
>    dpm_sysfs_remove(). Because the status input device and the media
>    device are children of the USB device, this also deletes their
>    sysfs folders.
> 
>  - Sometime later, the final stream is closed, invoking uvc_release().
> 
>  - uvc_release() calls uvc_delete()
> 
>  - uvc_delete() calls uvc_status_cleanup(), which cleans up the status
>    input device. Because the sysfs directory has already been removed,
>    this causes a WARNing.
> 
>  - uvc_delete() calls media_device_unregister(), which cleans up the
>    media device. Because the sysfs directory has already been removed,
>    this causes another WARNing.
> 
> To fix this, we need to make sure the devices are always unregistered
> before the end of uvc_disconnect(). To this, move the unregistration
> into the disconnect path:
> 
>  - split uvc_status_cleanup() into two parts, one on disconnect that
>    unregisters and one on delete that frees.
> 
>  - move v4l2_device_unregister() and media_device_unregister() into
>    the disconnect path.
> 
> [0]: https://lkml.org/lkml/2016/12/8/657
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Daniel Axtens <dja@axtens.net>


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Very nice work, what a tangled web this is...

greg k-h
