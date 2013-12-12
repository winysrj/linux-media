Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34385 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3LLTOF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 14:14:05 -0500
Message-ID: <52AA0AF9.1000109@iki.fi>
Date: Thu, 12 Dec 2013 21:14:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 3/4] v4l: add new tuner types for SDR
References: <1386806043-5331-1-git-send-email-crope@iki.fi> <1386806043-5331-4-git-send-email-crope@iki.fi> <52A96ABF.50905@xs4all.nl> <52A9EE96.4050306@iki.fi>
In-Reply-To: <52A9EE96.4050306@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.12.2013 19:12, Antti Palosaari wrote:
> On 12.12.2013 09:50, Hans Verkuil wrote:
>> On 12/12/2013 12:54 AM, Antti Palosaari wrote:

>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> index bc10684..ee91a9f 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> @@ -1288,8 +1288,13 @@ static int v4l_g_frequency(const struct
>>> v4l2_ioctl_ops *ops,
>>>       struct video_device *vfd = video_devdata(file);
>>>       struct v4l2_frequency *p = arg;
>>>
>>> -    p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>>> -            V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>>> +    if (vfd->vfl_type == VFL_TYPE_SDR) {
>>> +        if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_SDR)
>>> +            return -EINVAL;
>>
>> This isn't right. p->type is returned by the driver, not set by the user.
>> In the case of TYPE_SDR I would just set it to TUNER_SDR and let the
>> driver
>> update it for ADC tuners. You can also just leave it alone. This does
>> make
>> the assumption that SDR and ADC tuners are always separate tuners.
>> I.e., not
>> like radio and TV tuners that can be one physical tuner with two mutually
>> exclusive modes. It's my understanding that that is by definition true
>> for
>> SDR.
>
> Aaah, so it is possible to use same tuner and that type is aimed for
> selecting tuner operation mode. Makes sense.
>
> So if I now understand V4L2 driver model correctly, there should be one
> tuner that implements different functionality by using tuner type field.
>
> I could change it easily, no problem.

http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-g-frequency
I still don't understand that. Why both index and type should be defined 
for VIDIOC_S_FREQUENCY, but the opposite command VIDIOC_G_FREQUENCY 
requires only index and returns type too? It does not sound correct 
behavior.
If S_FREQUENCY/G_FREQUENCY should be able to handle multiple tuner types 
for same tuner index, then type must be also given that driver could 
detect required mode.

http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-g-tuner
How I can enumerate tuners. There is G_TUNER/S_TUNER for enumerating, 
but documentation of these IOCTLs looks like only one tuner type per 
tuner index is supported. That offers enumeration per tuner index.

regards
Antti

-- 
http://palosaari.fi/
