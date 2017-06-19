Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36796 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750982AbdFSODI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:03:08 -0400
Received: by mail-pf0-f193.google.com with SMTP id y7so17152100pfd.3
        for <linux-media@vger.kernel.org>; Mon, 19 Jun 2017 07:03:07 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2] [media] uvcvideo: Refactor teardown of uvc on USB disconnect
In-Reply-To: <20170423045349.10292-1-dja@axtens.net>
References: <20170423045349.10292-1-dja@axtens.net>
Date: Tue, 20 Jun 2017 00:02:58 +1000
Message-ID: <878tkokrcd.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Just checking if this was OK with you - I hadn't heard anything and I
noticed it's not in -next so I just wanted to check to see if there were
any changes you wanted.

Regards,
Daniel

Daniel Axtens <dja@axtens.net> writes:

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
>
> ---
>
> v2: Move v4l2_device_unregister() as well as media_device_unregister(),
>     thanks Laurent.
>
> Tested with cheese and yavta.
>
> Laurent, I know you were concerned about race conditions so I plugged
> and unplugged the camera over a dozen times, with lots of debugging
> turned on.
>
> In particular:
>  - KASan was enabled and didn't trigger
>  - If I unplugged while yavta was running, and replugged *while yatva
>    was still running*, the video camera came up as video2, not video1.
>    This indicates that yatva was successfully holding a reference to
>    video1 - as it should.
>  - No other debugging triggered any warning.
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 12 ++++++++----
>  drivers/media/usb/uvc/uvc_status.c |  8 ++++++--
>  drivers/media/usb/uvc/uvcvideo.h   |  1 +
>  3 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 46d6be0bb316..0d0541054ce2 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1812,11 +1812,7 @@ static void uvc_delete(struct uvc_device *dev)
>  	usb_put_intf(dev->intf);
>  	usb_put_dev(dev->udev);
>  
> -	if (dev->vdev.dev)
> -		v4l2_device_unregister(&dev->vdev);
>  #ifdef CONFIG_MEDIA_CONTROLLER
> -	if (media_devnode_is_registered(dev->mdev.devnode))
> -		media_device_unregister(&dev->mdev);
>  	media_device_cleanup(&dev->mdev);
>  #endif
>  
> @@ -1884,6 +1880,14 @@ static void uvc_unregister_video(struct uvc_device *dev)
>  		uvc_debugfs_cleanup_stream(stream);
>  	}
>  
> +	uvc_status_unregister(dev);
> +	if (dev->vdev.dev)
> +		v4l2_device_unregister(&dev->vdev);
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	if (media_devnode_is_registered(dev->mdev.devnode))
> +		media_device_unregister(&dev->mdev);
> +#endif
> +
>  	/* Decrement the stream count and call uvc_delete explicitly if there
>  	 * are no stream left.
>  	 */
> diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
> index f552ab997956..95709b23d3b4 100644
> --- a/drivers/media/usb/uvc/uvc_status.c
> +++ b/drivers/media/usb/uvc/uvc_status.c
> @@ -198,12 +198,16 @@ int uvc_status_init(struct uvc_device *dev)
>  	return 0;
>  }
>  
> -void uvc_status_cleanup(struct uvc_device *dev)
> +void uvc_status_unregister(struct uvc_device *dev)
>  {
>  	usb_kill_urb(dev->int_urb);
> +	uvc_input_cleanup(dev);
> +}
> +
> +void uvc_status_cleanup(struct uvc_device *dev)
> +{
>  	usb_free_urb(dev->int_urb);
>  	kfree(dev->status);
> -	uvc_input_cleanup(dev);
>  }
>  
>  int uvc_status_start(struct uvc_device *dev, gfp_t flags)
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index 15e415e32c7f..4b4814df35cd 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -712,6 +712,7 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
>  
>  /* Status */
>  extern int uvc_status_init(struct uvc_device *dev);
> +extern void uvc_status_unregister(struct uvc_device *dev);
>  extern void uvc_status_cleanup(struct uvc_device *dev);
>  extern int uvc_status_start(struct uvc_device *dev, gfp_t flags);
>  extern void uvc_status_stop(struct uvc_device *dev);
> -- 
> 2.11.0
