Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34541 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427091AbdDWA5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Apr 2017 20:57:22 -0400
Received: by mail-it0-f67.google.com with SMTP id 193so7253621itm.1
        for <linux-media@vger.kernel.org>; Sat, 22 Apr 2017 17:57:22 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] [media] uvcvideo: Refactor teardown of uvc on USB disconnect
In-Reply-To: <2540812.MKbs17NyWb@avalon>
References: <20170417085240.12930-1-dja@axtens.net> <2540812.MKbs17NyWb@avalon>
Date: Sun, 23 Apr 2017 10:57:17 +1000
Message-ID: <87o9vo7xg2.fsf@possimpible.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

>> To fix this, we need to make sure the devices are always unregistered
>> before the end of uvc_disconnect(). To this, move the unregistration
>> into the disconnect path:
>>
>>  - split uvc_status_cleanup() into two parts, one on disconnect that
>>    unregisters and one on delete that frees.
>> 
>>  - move media_device_unregister() into the disconnect path.
>
> While the patch looks reasonable to me (with one comment below though), isn't 
> this an issue with the USB core, or possibly the device core ? It's a common 
> practice to create device nodes as children of physical devices. Does the 
> device core really require all device nodes to be unregistered synchronously 
> with physical device hot-unplug ? If so, shouldn't it warn somehow when a 
> device is deleted and still has children, instead of accepting that silently 
> and later complaining due to sysfs issues ?

Probably! I might have a look at this in a bit - I was initially drawn
into this area because of a misbehaving USB3 dock + webcam combo; once I
sort out my more pressing issues there I will have a look at putting
that extra sanity checking in the device core.

>
>> [0]: https://lkml.org/lkml/2016/12/8/657
>> 
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
>> Cc: Greg KH <greg@kroah.com>
>> Signed-off-by: Daniel Axtens <dja@axtens.net>
>> 
>> ---
>> 
>> Tested with cheese and yavta.
>> ---
>>  drivers/media/usb/uvc/uvc_driver.c | 8 ++++++--
>>  drivers/media/usb/uvc/uvc_status.c | 8 ++++++--
>>  drivers/media/usb/uvc/uvcvideo.h   | 1 +
>>  3 files changed, 13 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/media/usb/uvc/uvc_driver.c
>> b/drivers/media/usb/uvc/uvc_driver.c index 46d6be0bb316..2390592f78e0
>> 100644
>> --- a/drivers/media/usb/uvc/uvc_driver.c
>> +++ b/drivers/media/usb/uvc/uvc_driver.c
>> @@ -1815,8 +1815,6 @@ static void uvc_delete(struct uvc_device *dev)
>>  	if (dev->vdev.dev)
>>  		v4l2_device_unregister(&dev->vdev);
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>> -	if (media_devnode_is_registered(dev->mdev.devnode))
>> -		media_device_unregister(&dev->mdev);
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

That's a good catch. I have moved v4l2_device_unregister() into the
unregister path, and turned on a bunch of debugging, including KASan. It
looks good so far, but I will plug and unplug the webcam a few more
times before sending v2 :)

> Note that your patch isn't really at fault here, the media controller and V4L2 
> core code have been broken for a long time when it comes to entity lifetime 
> management. That might be fixed some day, but I won't hold my breath given the 
> bad track record of the previous year and a half.

This is my first real foray into lifecycle managment in Linux. I've
found it quite confusing, so it's comforting to know that it's not just me!

Regards,
Daniel

>
>>  	media_device_cleanup(&dev->mdev);
>>  #endif
>> 
>> @@ -1884,6 +1882,12 @@ static void uvc_unregister_video(struct uvc_device
>> *dev) uvc_debugfs_cleanup_stream(stream);
>>  	}
>> 
>> +	uvc_status_unregister(dev);
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +	if (media_devnode_is_registered(dev->mdev.devnode))
>> +		media_device_unregister(&dev->mdev);
>> +#endif
>> +
>>  	/* Decrement the stream count and call uvc_delete explicitly if there
>>  	 * are no stream left.
>>  	 */
>> diff --git a/drivers/media/usb/uvc/uvc_status.c
>> b/drivers/media/usb/uvc/uvc_status.c index f552ab997956..95709b23d3b4
>> 100644
>> --- a/drivers/media/usb/uvc/uvc_status.c
>> +++ b/drivers/media/usb/uvc/uvc_status.c
>> @@ -198,12 +198,16 @@ int uvc_status_init(struct uvc_device *dev)
>>  	return 0;
>>  }
>> 
>> -void uvc_status_cleanup(struct uvc_device *dev)
>> +void uvc_status_unregister(struct uvc_device *dev)
>>  {
>>  	usb_kill_urb(dev->int_urb);
>> +	uvc_input_cleanup(dev);
>> +}
>> +
>> +void uvc_status_cleanup(struct uvc_device *dev)
>> +{
>>  	usb_free_urb(dev->int_urb);
>>  	kfree(dev->status);
>> -	uvc_input_cleanup(dev);
>>  }
>> 
>>  int uvc_status_start(struct uvc_device *dev, gfp_t flags)
>> diff --git a/drivers/media/usb/uvc/uvcvideo.h
>> b/drivers/media/usb/uvc/uvcvideo.h index 15e415e32c7f..4b4814df35cd 100644
>> --- a/drivers/media/usb/uvc/uvcvideo.h
>> +++ b/drivers/media/usb/uvc/uvcvideo.h
>> @@ -712,6 +712,7 @@ void uvc_video_clock_update(struct uvc_streaming
>> *stream,
>> 
>>  /* Status */
>>  extern int uvc_status_init(struct uvc_device *dev);
>> +extern void uvc_status_unregister(struct uvc_device *dev);
>>  extern void uvc_status_cleanup(struct uvc_device *dev);
>>  extern int uvc_status_start(struct uvc_device *dev, gfp_t flags);
>>  extern void uvc_status_stop(struct uvc_device *dev);
>
> -- 
> Regards,
>
> Laurent Pinchart
