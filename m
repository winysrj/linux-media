Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3582 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3LMObu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 09:31:50 -0500
Message-ID: <52AB1A3B.2050003@xs4all.nl>
Date: Fri, 13 Dec 2013 15:31:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 3/4] v4l: add new tuner types for SDR
References: <1386806043-5331-1-git-send-email-crope@iki.fi> <1386806043-5331-4-git-send-email-crope@iki.fi> <52A96ABF.50905@xs4all.nl> <52A9EE96.4050306@iki.fi> <52AA0AF9.1000109@iki.fi>
In-Reply-To: <52AA0AF9.1000109@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2013 08:14 PM, Antti Palosaari wrote:
> On 12.12.2013 19:12, Antti Palosaari wrote:
>> On 12.12.2013 09:50, Hans Verkuil wrote:
>>> On 12/12/2013 12:54 AM, Antti Palosaari wrote:
> 
>>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
>>>> b/drivers/media/v4l2-core/v4l2-ioctl.c
>>>> index bc10684..ee91a9f 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>>> @@ -1288,8 +1288,13 @@ static int v4l_g_frequency(const struct
>>>> v4l2_ioctl_ops *ops,
>>>>       struct video_device *vfd = video_devdata(file);
>>>>       struct v4l2_frequency *p = arg;
>>>>
>>>> -    p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>>>> -            V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>>>> +    if (vfd->vfl_type == VFL_TYPE_SDR) {
>>>> +        if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_SDR)
>>>> +            return -EINVAL;
>>>
>>> This isn't right. p->type is returned by the driver, not set by the user.
>>> In the case of TYPE_SDR I would just set it to TUNER_SDR and let the
>>> driver
>>> update it for ADC tuners. You can also just leave it alone. This does
>>> make
>>> the assumption that SDR and ADC tuners are always separate tuners.
>>> I.e., not
>>> like radio and TV tuners that can be one physical tuner with two mutually
>>> exclusive modes. It's my understanding that that is by definition true
>>> for
>>> SDR.
>>
>> Aaah, so it is possible to use same tuner and that type is aimed for
>> selecting tuner operation mode. Makes sense.
>>
>> So if I now understand V4L2 driver model correctly, there should be one
>> tuner that implements different functionality by using tuner type field.
>>
>> I could change it easily, no problem.
> 
> http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-g-frequency
> I still don't understand that. Why both index and type should be defined 
> for VIDIOC_S_FREQUENCY, but the opposite command VIDIOC_G_FREQUENCY 
> requires only index and returns type too? It does not sound correct 
> behavior.
> If S_FREQUENCY/G_FREQUENCY should be able to handle multiple tuner types 
> for same tuner index, then type must be also given that driver could 
> detect required mode.
> 
> http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-g-tuner
> How I can enumerate tuners. There is G_TUNER/S_TUNER for enumerating, 
> but documentation of these IOCTLs looks like only one tuner type per 
> tuner index is supported. That offers enumeration per tuner index.

I can imagine it is confusing. According to the spec the ENUM_FREQ_BANDS,
S_HW_FREQ_SEEK and S_FREQUENCY ioctls all require the type field to be set
by the user before calling, but G_FREQUENCY and G/S_TUNER do not. And the
G/S_MODULATOR ioctls do not use a type field at all.

Frankly, I consider this a bug in the API. All of these ioctls should have
required that userspace sets the type field.

The idea behind the original API design was that a tuner can be in either
radio or TV mode, and that's determined by the type. The only ioctl that
can change the tuner mode is S_FREQUENCY where the type tells the tuner
whether to select radio or TV mode. Note that originally it didn't matter
whether S_FREQ was called on a radio or a video node, it was the type field
that determined the tuner mode, not the node it was called on. At least,
that was the theory.

In practice drivers often didn't check the type field and instead depended
on whether the ioctl came from a radio or a video node. Applications certainly
never mixed radio and video nodes. Also, calling e.g. S_STD would also switch
the tuner mode back to the TV mode, requiring drivers to keep track of the
last used radio and TV frequencies, to be restored when switching back and
forth between radio and TV mode. Frankly, the tuner type handling was a
major nightmare and few drivers handled it correctly.

The practical result of all this was that, even though an internal tuner
could operate in either TV or radio mode, from the outside world it would
look as two separate tuners. So calling G_FREQ from a radio node gives
back the last set radio frequency and from a video node the last set TV
frequency, regardless of the actual tuner mode. Ditto for G/S_TUNER: if
the tuner is in the wrong mode, the tuner data is just faked.

So the tuner type now depends on the device node that is used: it does
not have to be set by userspace (except for those ioctls where the spec
explicitly requires it) but it is filled in by the core based on the
device node used.

This scheme works fine as long as each tuner has either only one mode
or the mode can be deduced from the device node used to access it.

If we ever get tuners with multiple modes that can all be used from the
same device node, then we have a problem.

My understanding from your SDR proposal is that this doesn't happen:
you have only one or two tuners, and each tuner has only one mode.

I hope this helps instead of confusing you even more :-)

Regards,

	Hans
