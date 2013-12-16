Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2125 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LPO5w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 09:57:52 -0500
Message-ID: <52AF14D0.90806@xs4all.nl>
Date: Mon, 16 Dec 2013 15:57:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v2 3/7] v4l: add new tuner types for SDR
References: <1387037729-1977-1-git-send-email-crope@iki.fi> <1387037729-1977-4-git-send-email-crope@iki.fi> <52AEBF6E.2090107@xs4all.nl> <52AEF3C9.9020906@iki.fi> <52AEF732.5080908@xs4all.nl> <52AF0BF0.3090403@iki.fi> <52AF0D54.1070602@xs4all.nl> <52AF1116.2040006@iki.fi>
In-Reply-To: <52AF1116.2040006@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2013 03:41 PM, Antti Palosaari wrote:
> On 16.12.2013 16:25, Hans Verkuil wrote:
>> On 12/16/2013 03:19 PM, Antti Palosaari wrote:
>>> On 16.12.2013 14:50, Hans Verkuil wrote:
>>>> On 12/16/2013 01:36 PM, Antti Palosaari wrote:
>>>>> On 16.12.2013 10:53, Hans Verkuil wrote:
>>>>>> On 12/14/2013 05:15 PM, Antti Palosaari wrote:
>>>>>
>>>>>>> @@ -1288,8 +1288,13 @@ static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
>>>>>>>     	struct video_device *vfd = video_devdata(file);
>>>>>>>     	struct v4l2_frequency *p = arg;
>>>>>>>
>>>>>>> -	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>>>>>>> -			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>>>>>>> +	if (vfd->vfl_type == VFL_TYPE_SDR) {
>>>>>>> +		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
>>>>>>> +			return -EINVAL;
>>>>>>
>>>>>> This is wrong. As you mentioned in patch 1, the type field should always be set by
>>>>>> the driver. So type is not something that is set by the user.
>>>>>>
>>>>>> I would just set type to V4L2_TUNER_ADC here (all SDR devices have at least an ADC
>>>>>> tuner), and let the driver change it to TUNER_RF if this tuner is really an RF
>>>>>> tuner.
>>>>>
>>>>> I don't think so. It sounds very stupid to handle tuner type with
>>>>> different meaning in that single case - it sounds just a is a mistake
>>>>> (and that SDR case mistakes are not needed continue as no regressions
>>>>> apply). I can say I was very puzzled what is the reason my tuner type is
>>>>> always changed to wrong, until finally found it was overridden here.
>>>>>
>>>>> For me this looks more than it is just forced to "some" suitable value
>>>>> in a case app does not fill it correctly - not the way driver should
>>>>> return it to app. Tuner ID and type are here for Kernel driver could
>>>>> identify not the opposite and that is how it should be without unneeded
>>>>> exceptions.
>>>>>
>>>>> Also, API does not specify that kind of different meaning for tuner type
>>>>> in a case of g_frequency.
>>>>>
>>>>> Have to search some history where that odds is coming from...
>>>>
>>>> The application *does not set type* when calling G_FREQUENCY. The driver has
>>>> to fill that in. So the type field as received from the application is
>>>> uninitialized. That's the way the spec was defined, and that's the way
>>>> applications use G_FREQUENCY. There is nothing you can do about that.
>>>>
>>>> So drivers have to fill in the type based on vfl_type and the tuner index.
>>>> Since drivers often didn't do that the vfl_type check has been moved to the
>>>> v4l2 core. In the case of SDR the type is actually dependent on the tuner
>>>> index, so the core cannot fully initialize the type field.
>>>>
>>>> You can either leave it uninitialized for vfl_type SDR and leave it to the
>>>> SDR driver to fill in the type, or you can set it to ADC so the driver
>>>> only has to update the type field if the tuner index corresponds to the
>>>> RF tuner.
>>>
>>>
>>> commit 227690df75382e46a4f6ea1bbc5df855a674b47f
>>> Author: Hans Verkuil <hans.verkuil@cisco.com>
>>> Date:   Sun Jun 12 06:36:41 2011 -0300
>>>
>>>       [media] v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner
>>>
>>>       The subdevs are supposed to receive a valid tuner type for the
>>> g_frequency
>>
>> This talks about the *subdevs*. The low-level tuner ops implemented by
>> sub-devices expected a valid type field. That field had to be filled in
>> by bridge drivers, and they often did not do that, or filled in the wrong
>> type.
>>
>>>       and g/s_tuner subdev ops. Some drivers do this, others don't. So
>>> prefill
>>>       this in v4l2-ioctl.c based on whether the device node from which
>>> this is
>>>       called is a radio node or not.
>>>
>>>       The spec does not require applications to fill in the type, and if they
>>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Yes, I saw it was not required. And thats why I saw now it is possible 
> to fix in a case of SDR device. You can check if it is set correctly 
> without fear of possible regressions. Implementation I made left 
> functionality for any other devices than SDR to old "don't care about 
> tuner type".

So what you are basically doing is that for non-SDR device nodes the
type field is just ignored (as per the spec) and filled-in by the core,
while for SDR device nodes you check what the application gives you.

In other words, the G_FREQUENCY ioctl behaves differently depending on
the device node you use (for sdr nodes it checks type, for others it
ignores type). That's highly unexpected and inconsistent, and that's
not the way to go.

> 
>>>       leave it at 0 then the 'check_mode' call in tuner-core.c will return
>>>       an error and the ioctl does nothing.
>>>
>>>       Cc: stable@kernel.org
>>>       Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>       Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>
> 
> That is the patch where tuner type overridden (for g_frequency) was 
> added. It does not say type is field aimed for reporting type to 
> application, instead it says Kernel driver needs it and as applications 
> are not setting always, just override some reasonable values.

That's not what it says. I quote: "The spec does not require applications to
fill in the type". So 'type' is *undefined*. But the low-level sub-device
drivers like tuners *do* expect type to be set by someone. That someone was the
bridge driver. That patch just sets the type in the core code, since it can
determine the type from vfl_type. So no bridge drivers had to be modified,
and sub-device drivers now receive a valid type.

> 
> I cannot see why you are against proper validation of tuner type got 
> from app in a case of g_frequency (and it looks even more strange as 
> type is validated for s_frequency).

Because for G_FREQUENCY the type field is not written by the application.
I can't help that, that's the way the spec was defined (and I agree that
it is weird).

It's been like that for many years, and we can't change it. And we don't
need to change it either, since your sdr driver can set the type based
on the tuner index.

You should drop patch 1, because that suggests that the type field as
passed in from the application can be used by the driver, and that's
simply not the case.

Regards,

	Hans
