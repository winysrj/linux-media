Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59309 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab0JROfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 10:35:02 -0400
Received: by vws2 with SMTP id 2so476720vws.19
        for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 07:35:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <26db46dc537ffbd7bd3e906043852169.squirrel@webmail.xs4all.nl>
References: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
	<AANLkTikmKf5uZ=QFYMQ8x_tQ4Mws3pJ61oXsr6Rt=ifx@mail.gmail.com>
	<9e7c8ba580484bbc3066089ece9c08a3.squirrel@webmail.xs4all.nl>
	<AANLkTik_dGRV9DLiCFg6YYDTa2_NASQ5HgNxpo=mzCF=@mail.gmail.com>
	<26db46dc537ffbd7bd3e906043852169.squirrel@webmail.xs4all.nl>
Date: Mon, 18 Oct 2010 10:35:00 -0400
Message-ID: <AANLkTikdgWXsmGE1KPC3KbLc37T_=G3Aa8RaVhL1PsAN@mail.gmail.com>
Subject: Re: [RFC PATCH] radio-mr800: locking fixes
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 18, 2010 at 10:18 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> On Mon, Oct 18, 2010 at 9:38 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>
>>>> On Sun, Oct 17, 2010 at 8:26 AM, Hans Verkuil <hverkuil@xs4all.nl>
>>>> wrote:
>>>>> - serialize the suspend and resume functions using the global lock.
>>>>> - do not call usb_autopm_put_interface after a disconnect.
>>>>> - fix a race when disconnecting the device.
>>>>>
>>>>> Reported-by: David Ellingsworth <david@identd.dyndns.org>
>>>>> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>>> ---
>>>>>  drivers/media/radio/radio-mr800.c |   17 ++++++++++++++---
>>>>>  1 files changed, 14 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/radio/radio-mr800.c
>>>>> b/drivers/media/radio/radio-mr800.c
>>>>> index 2f56b26..b540e80 100644
>>>>> --- a/drivers/media/radio/radio-mr800.c
>>>>> +++ b/drivers/media/radio/radio-mr800.c
>>>>> @@ -284,9 +284,13 @@ static void usb_amradio_disconnect(struct
>>>>> usb_interface *intf)
>>>>>        struct amradio_device *radio =
>>>>> to_amradio_dev(usb_get_intfdata(intf));
>>>>>
>>>>>        mutex_lock(&radio->lock);
>>>>> +       /* increase the device node's refcount */
>>>>> +       get_device(&radio->videodev.dev);
>>>>>        v4l2_device_disconnect(&radio->v4l2_dev);
>>>>> -       mutex_unlock(&radio->lock);
>>>>>        video_unregister_device(&radio->videodev);
>>>>> +       mutex_unlock(&radio->lock);
>>>>> +       /* decrease the device node's refcount, allowing it to be
>>>>> released */
>>>>> +       put_device(&radio->videodev.dev);
>>>>>  }
>>>>
>>>> Hans, I understand the use of get/put_device here.. but can you
>>>> explain to me what issue you are trying to solve?
>>>> video_unregister_device does not have to be synchronized with anything
>>>> else. Thus, it is perfectly safe to call video_unregister_device while
>>>> not holding the device lock. Your prior implementation here was
>>>> correct.
>>>
>>> This the original sequence:
>>>
>>>       mutex_lock(&radio->lock);
>>>       v4l2_device_disconnect(&radio->v4l2_dev);
>>>       mutex_unlock(&radio->lock);
>>>       video_unregister_device(&radio->videodev);
>>>
>>> The problem with this is that userspace can call open or ioctl after the
>>> unlock and before the device node is marked unregistered by
>>> video_unregister_device.
>>>
>>> Once you disconnect you want to block all access (except the release
>>> call).
>>> What my patch does is to move the video_unregister_device call inside
>>> the
>>> lock, but then I have to guard against the release being called before
>>> the
>>> unlock by increasing the refcount.
>>>
>>> I have ideas to improve on this as this gets hairy when you have
>>> multiple
>>> device nodes, but I wait with that until the next kernel cycle.
>>>
>>> Regards,
>>>
>>>         Hans
>>>
>>
>> I think you're trying to solve a problem that doesn't exist.
>> To be a little more specific we have the following:
>>
>> 1. video_register_device - increments device refcount
>> 2. video_unregister_device - decrements device refcount
>> 3. v4l2_open - increments device refcount
>> 4. v4l2_release - decrements device refcount
>>
>> Keeping this in mind, the release callback of video_device is called
>> only when the device count reaches 0.
>>
>> So under normal operation we have:
>>
>> 1. video_register_device -> device refcount incremented to 1
>> 2. v4l2_open -> device refcount incremented to 2
>> 3. v4l2_release -> device refcount decremented to 1
>> 4. disconnect callback: video_unregister_device -> device refcount
>> decremented to 0 & release callback called.
>>
>> If the user disconnects the device while it's open we have the following:
>>
>> 1. video_register_device -> device refcount incremented to 1
>> 2. v4l2_open -> device refcount incremented to 2
>> 3. disconnect callback: video_unregister_device -> device refcount
>> decremented to 1
>> 4. v4l2_release -> device refcount decremented to 0 & release callback
>> called.
>>
>> In the above case, once video_unregister_device has been called, calls
>> to open no longer will work. However, the user holding the currently
>> open file handle can still call ioctl and other callbacks, but those
>> should be met with an -EIO, forcing them to close the open handle. The
>> original code did this by using the usb device as an indicator to see
>> if the device was still connected, as this functionality was not in
>> v4l2_core. On the other hand, v4l2_core could do this for us, just by
>> checking if the device is still registered.
>>
>> As you can see from the above, there are no race conditions here.
>
> Yes there is a race: what you want is that in the disconnect function you
> can safely clean up any data structures or whatever in the knowledge that
> once the device nodes are unregistered only the release call can reach the
> driver. All other calls (open, ioctl, etc) are blocked by the v4l core.
>
> In order to do this you have to unregister the device nodes while the lock
> is held. In the original code the device node was unregistered without the
> lock being held, so that would allow userspace to sneak in a e.g. open()
> call just before the unregister call.
>
> BTW, note that this is probably not relevant for this particular driver.
> Even if this race happens, it will most likely not be a problem for this
> simple device.
>
> Regards,
>
>        Hans
>

Hans, right I understand what you're getting at.. between the
v4l2_device_disconnect and video_unregister_device a call to open
could succeed. In the original code, the usb device of the object was
set to NULL. In the open callback if the usb device was NULL, the open
would fail with -EIO, thus preventing the race you are referring to.

Subsequently, all ioctl callbacks had the same check applied. So yes,
while there is a race here now, there wasn't one before. It was
already handled by the driver. The addition get/put_device calls do
nothing to prevent this race. Not even locking around
video_unregister_device prevents this race. Consider the following:

1. The lock is taken in the disconnect callback.
2. While the disconnect callback is being processed, a call to open happens.
3. Since the lock is already taken the open waits on the lock to be released.
4. The lock is finally released, the call to open acquires the lock
and succeeds.

As you can see.. there's nothing you can do to prevent this from
happening. This is the reason the original code set the usb device to
NULL while holding the lock, and checked to see if it was NULL in open
and the ioctl callbacks with the lock held. It's the only way to
prevent this race from happening.

Regards,

David Ellingsworth
