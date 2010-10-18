Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3889 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab0JRNiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:38:18 -0400
Message-ID: <9e7c8ba580484bbc3066089ece9c08a3.squirrel@webmail.xs4all.nl>
In-Reply-To: <AANLkTikmKf5uZ=QFYMQ8x_tQ4Mws3pJ61oXsr6Rt=ifx@mail.gmail.com>
References: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
    <AANLkTikmKf5uZ=QFYMQ8x_tQ4Mws3pJ61oXsr6Rt=ifx@mail.gmail.com>
Date: Mon, 18 Oct 2010 15:38:14 +0200
Subject: Re: [RFC PATCH] radio-mr800: locking fixes
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "David Ellingsworth" <david@identd.dyndns.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> On Sun, Oct 17, 2010 at 8:26 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> - serialize the suspend and resume functions using the global lock.
>> - do not call usb_autopm_put_interface after a disconnect.
>> - fix a race when disconnecting the device.
>>
>> Reported-by: David Ellingsworth <david@identd.dyndns.org>
>> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>> ---
>>  drivers/media/radio/radio-mr800.c |   17 ++++++++++++++---
>>  1 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/radio/radio-mr800.c
>> b/drivers/media/radio/radio-mr800.c
>> index 2f56b26..b540e80 100644
>> --- a/drivers/media/radio/radio-mr800.c
>> +++ b/drivers/media/radio/radio-mr800.c
>> @@ -284,9 +284,13 @@ static void usb_amradio_disconnect(struct
>> usb_interface *intf)
>>        struct amradio_device *radio =
>> to_amradio_dev(usb_get_intfdata(intf));
>>
>>        mutex_lock(&radio->lock);
>> +       /* increase the device node's refcount */
>> +       get_device(&radio->videodev.dev);
>>        v4l2_device_disconnect(&radio->v4l2_dev);
>> -       mutex_unlock(&radio->lock);
>>        video_unregister_device(&radio->videodev);
>> +       mutex_unlock(&radio->lock);
>> +       /* decrease the device node's refcount, allowing it to be
>> released */
>> +       put_device(&radio->videodev.dev);
>>  }
>
> Hans, I understand the use of get/put_device here.. but can you
> explain to me what issue you are trying to solve?
> video_unregister_device does not have to be synchronized with anything
> else. Thus, it is perfectly safe to call video_unregister_device while
> not holding the device lock. Your prior implementation here was
> correct.

This the original sequence:

       mutex_lock(&radio->lock);
       v4l2_device_disconnect(&radio->v4l2_dev);
       mutex_unlock(&radio->lock);
       video_unregister_device(&radio->videodev);

The problem with this is that userspace can call open or ioctl after the
unlock and before the device node is marked unregistered by
video_unregister_device.

Once you disconnect you want to block all access (except the release call).
What my patch does is to move the video_unregister_device call inside the
lock, but then I have to guard against the release being called before the
unlock by increasing the refcount.

I have ideas to improve on this as this gets hairy when you have multiple
device nodes, but I wait with that until the next kernel cycle.

Regards,

         Hans

>
> Regards,
>
> David Ellingsworth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

