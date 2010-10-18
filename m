Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40263 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0JRN4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:56:15 -0400
Received: by ywi6 with SMTP id 6so362150ywi.19
        for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 06:56:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9e7c8ba580484bbc3066089ece9c08a3.squirrel@webmail.xs4all.nl>
References: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
	<AANLkTikmKf5uZ=QFYMQ8x_tQ4Mws3pJ61oXsr6Rt=ifx@mail.gmail.com>
	<9e7c8ba580484bbc3066089ece9c08a3.squirrel@webmail.xs4all.nl>
Date: Mon, 18 Oct 2010 09:56:14 -0400
Message-ID: <AANLkTik_dGRV9DLiCFg6YYDTa2_NASQ5HgNxpo=mzCF=@mail.gmail.com>
Subject: Re: [RFC PATCH] radio-mr800: locking fixes
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 18, 2010 at 9:38 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> On Sun, Oct 17, 2010 at 8:26 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> - serialize the suspend and resume functions using the global lock.
>>> - do not call usb_autopm_put_interface after a disconnect.
>>> - fix a race when disconnecting the device.
>>>
>>> Reported-by: David Ellingsworth <david@identd.dyndns.org>
>>> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>>> ---
>>>  drivers/media/radio/radio-mr800.c |   17 ++++++++++++++---
>>>  1 files changed, 14 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/media/radio/radio-mr800.c
>>> b/drivers/media/radio/radio-mr800.c
>>> index 2f56b26..b540e80 100644
>>> --- a/drivers/media/radio/radio-mr800.c
>>> +++ b/drivers/media/radio/radio-mr800.c
>>> @@ -284,9 +284,13 @@ static void usb_amradio_disconnect(struct
>>> usb_interface *intf)
>>>        struct amradio_device *radio =
>>> to_amradio_dev(usb_get_intfdata(intf));
>>>
>>>        mutex_lock(&radio->lock);
>>> +       /* increase the device node's refcount */
>>> +       get_device(&radio->videodev.dev);
>>>        v4l2_device_disconnect(&radio->v4l2_dev);
>>> -       mutex_unlock(&radio->lock);
>>>        video_unregister_device(&radio->videodev);
>>> +       mutex_unlock(&radio->lock);
>>> +       /* decrease the device node's refcount, allowing it to be
>>> released */
>>> +       put_device(&radio->videodev.dev);
>>>  }
>>
>> Hans, I understand the use of get/put_device here.. but can you
>> explain to me what issue you are trying to solve?
>> video_unregister_device does not have to be synchronized with anything
>> else. Thus, it is perfectly safe to call video_unregister_device while
>> not holding the device lock. Your prior implementation here was
>> correct.
>
> This the original sequence:
>
>       mutex_lock(&radio->lock);
>       v4l2_device_disconnect(&radio->v4l2_dev);
>       mutex_unlock(&radio->lock);
>       video_unregister_device(&radio->videodev);
>
> The problem with this is that userspace can call open or ioctl after the
> unlock and before the device node is marked unregistered by
> video_unregister_device.
>
> Once you disconnect you want to block all access (except the release call).
> What my patch does is to move the video_unregister_device call inside the
> lock, but then I have to guard against the release being called before the
> unlock by increasing the refcount.
>
> I have ideas to improve on this as this gets hairy when you have multiple
> device nodes, but I wait with that until the next kernel cycle.
>
> Regards,
>
>         Hans
>

I think you're trying to solve a problem that doesn't exist.
To be a little more specific we have the following:

1. video_register_device - increments device refcount
2. video_unregister_device - decrements device refcount
3. v4l2_open - increments device refcount
4. v4l2_release - decrements device refcount

Keeping this in mind, the release callback of video_device is called
only when the device count reaches 0.

So under normal operation we have:

1. video_register_device -> device refcount incremented to 1
2. v4l2_open -> device refcount incremented to 2
3. v4l2_release -> device refcount decremented to 1
4. disconnect callback: video_unregister_device -> device refcount
decremented to 0 & release callback called.

If the user disconnects the device while it's open we have the following:

1. video_register_device -> device refcount incremented to 1
2. v4l2_open -> device refcount incremented to 2
3. disconnect callback: video_unregister_device -> device refcount
decremented to 1
4. v4l2_release -> device refcount decremented to 0 & release callback called.

In the above case, once video_unregister_device has been called, calls
to open no longer will work. However, the user holding the currently
open file handle can still call ioctl and other callbacks, but those
should be met with an -EIO, forcing them to close the open handle. The
original code did this by using the usb device as an indicator to see
if the device was still connected, as this functionality was not in
v4l2_core. On the other hand, v4l2_core could do this for us, just by
checking if the device is still registered.

As you can see from the above, there are no race conditions here.

Regards,

David Ellingsworth
