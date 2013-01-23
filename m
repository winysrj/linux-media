Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56631 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3AWWNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 17:13:14 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so4403696eei.31
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 14:13:13 -0800 (PST)
Message-ID: <5100609F.60909@googlemail.com>
Date: Wed, 23 Jan 2013 23:13:51 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tuner-core: return tuner name with ioctl VIDIOC_G_TUNER
References: <1358883981-2645-1-git-send-email-fschaefer.oss@googlemail.com> <201301231713.55685.hverkuil@xs4all.nl> <510017E5.2010402@googlemail.com> <201301231933.50841.hverkuil@xs4all.nl>
In-Reply-To: <201301231933.50841.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.01.2013 19:33, schrieb Hans Verkuil:
> On Wed January 23 2013 18:03:33 Frank Schäfer wrote:
>> Am 23.01.2013 17:13, schrieb Hans Verkuil:
>>> On Wed January 23 2013 16:57:40 Frank Schäfer wrote:
>>>> Am 23.01.2013 08:35, schrieb Hans Verkuil:
>>>>> On Tue January 22 2013 20:46:21 Frank Schäfer wrote:
>>>>>> tuner_g_tuner() is supposed to fill struct v4l2_tuner passed by ioctl
>>>>>> VIDIOC_G_TUNER, but misses setting the name field.
>>>>>>
>>>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>>>> Cc: stable@kernel.org
>>>>>> ---
>>>>>>  drivers/media/v4l2-core/tuner-core.c |    1 +
>>>>>>  1 Datei geändert, 1 Zeile hinzugefügt(+)
>>>>>>
>>>>>> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
>>>>>> index b5a819a..95a47cf 100644
>>>>>> --- a/drivers/media/v4l2-core/tuner-core.c
>>>>>> +++ b/drivers/media/v4l2-core/tuner-core.c
>>>>>> @@ -1187,6 +1187,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>>>>>>  
>>>>>>  	if (check_mode(t, vt->type) == -EINVAL)
>>>>>>  		return 0;
>>>>>> +	strcpy(vt->name, t->name);
>>>>>>  	if (vt->type == t->mode && analog_ops->get_afc)
>>>>>>  		vt->afc = analog_ops->get_afc(&t->fe);
>>>>>>  	if (analog_ops->has_signal)
>>>>>>
>>>>> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>
>>>>> And the reason is that the tuner field should be filled in by the bridge
>>>>> driver. That's because you may have multiple tuners and it's only the
>>>>> bridge driver that will know which tuner is which and what name to give
>>>>> it.
>>>> Hmmm... I don't understand.
>>>> Isn't his a per-tuner (subdev) operation ? If a device has multiple
>>>> tuners (subdevs) it is called for each of them.
>>>> So how can the returned tuner name be wrong and why should the bridge
>>>> driver know better than the subdevice itself which name is correct ?
>>> The name that's filled in is exposed to userspace, so it should be something
>>> meaningful and not some internal name. In the case of multiple tuners that
>>> means that the name should be something like 'TV 1' or 'TV 2', where the name
>>> matches a name (label) of a tuner input of the product. There is no way a
>>> subdev driver can know that, only the bridge driver knows what product it is
>>> and thus what the labels on the inputs are.
>> Hmm... I assume there is a misunderstanding about what the tuner "name"
>> means and the corresponding field in struct v42l_tuner should contain...
>> With the patch, the returned tuner names are e.g. "Temic PAL (4002
>> FH5)", "LG PAL_BG+FM (TPI8PSB01D)" etc, which is what I expect / think
>> is a correct tuner name.
> That's the name of the tuner device. That's like reporting to the user
> that the video input is named "saa7115 4-0021". That's not useful. It
> *is* useful for us as developers, which is why such names are seen in the
> kernel log.

Not sure if the saa7115 driver could provide better input names, but I
agree that letting the bridge driver set it's own names for inputs makes
sense.
But I would say for the tuner names, the situation is different.
Looking at tuner-types.c, I can say that these names are exaclty what I
expect to get with the VIDIOC_G_TUNER ioctrl.
Btw, bridge drivers can still overwrite the tuner name they get from the
subdevice. ;)
And getting the full device name from the subdevice is definitely better
than getting no device name at all. (I would also say it's somehow
inconsistent).

...
>>
>>> ...
>>>
>>> The golden rule is that sub-devices should not assume anything about how they
>>> are hooked up in the actual product.
>> Yeah, sure, but I can't see that we make such an assumption here !?
> In this case it is more in the opposite direction: a subdev internal name is
> exposed to userspace.

It doesn't matter where the name comes from, the important thing is that
it matches what the API spec says / userspace expects.
So if we can pass the name from the subdevice to userspace directly
because it matches these requirements, why not ?
I think overwriting names etc. retrieved via a subdevice call should be
the exception, not the rule.


I actually don't care too much about the content of the tuner name
field. I can't remember having seen any applications displaying it.
I'm just trying to understand the API and I have a pending patch (as
part of an ioctl fixes series) for the em28xx drivers that is supposed
to unify the tuner name handing for video/vbi and radio devices (in
whatever direction).

Regards,
Frank

>
> Regards,
>
> 	Hans

