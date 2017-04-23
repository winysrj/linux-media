Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36270 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427364AbdDWAkS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Apr 2017 20:40:18 -0400
Received: by mail-it0-f65.google.com with SMTP id x188so6407969itb.3
        for <linux-media@vger.kernel.org>; Sat, 22 Apr 2017 17:40:18 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] uvcvideo: Kill video URBs on disconnect
In-Reply-To: <9757129.ouSjzrobER@avalon>
References: <20170417085240.12930-1-dja@axtens.net> <20170417085240.12930-2-dja@axtens.net> <9757129.ouSjzrobER@avalon>
Date: Sun, 23 Apr 2017 10:40:12 +1000
Message-ID: <87r30k7y8j.fsf@possimpible.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Apologies for takig so long to get back to you.

> I assume that the error message is caused by a race between disconnection and 
> URB handling. When the device is disconnected I believe the USB core will 
> cancel all in-progress URBs (I'm not very familiar with that part of the USB 
> core anymore, so please don't consider this or any further related statement 
> as true without double-checking), resulting in the URB completion handler 
> being called with an error status. The completion handler should then avoid 
> resubmitting the URB. However, if the completion handler is in progress when 
> the device is disconnected, it won't notice that the device got disconnected, 
> and will try to resubmit the URB.
>
> I'm not sure to see how this patch will fix the problem. If the URB completion 
> handler is in progress when the device is being disconnected, won't it call 
> usb_submit_urb() regardless of whether you call usb_kill_urb() in the 
> disconnect handler, resulting in an error message being printed ?

You're completely right - I misunderstood the flow of the
function. Fixing this would require a different approach and would be
more invasive. Given that this does not cause anything more annoying
than some log messages, I will leave it for now.

Regards,
Daniel

>
>> ---
>>  drivers/media/usb/uvc/uvc_driver.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/drivers/media/usb/uvc/uvc_driver.c
>> b/drivers/media/usb/uvc/uvc_driver.c index 2390592f78e0..647e3d8a1256
>> 100644
>> --- a/drivers/media/usb/uvc/uvc_driver.c
>> +++ b/drivers/media/usb/uvc/uvc_driver.c
>> @@ -1877,6 +1877,8 @@ static void uvc_unregister_video(struct uvc_device
>> *dev) if (!video_is_registered(&stream->vdev))
>>  			continue;
>> 
>> +		uvc_video_enable(stream, 0);
>> +
>>  		video_unregister_device(&stream->vdev);
>> 
>>  		uvc_debugfs_cleanup_stream(stream);
>
> -- 
> Regards,
>
> Laurent Pinchart
