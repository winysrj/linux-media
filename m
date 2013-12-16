Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4214 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3LPMv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 07:51:28 -0500
Message-ID: <52AEF732.5080908@xs4all.nl>
Date: Mon, 16 Dec 2013 13:50:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v2 3/7] v4l: add new tuner types for SDR
References: <1387037729-1977-1-git-send-email-crope@iki.fi> <1387037729-1977-4-git-send-email-crope@iki.fi> <52AEBF6E.2090107@xs4all.nl> <52AEF3C9.9020906@iki.fi>
In-Reply-To: <52AEF3C9.9020906@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2013 01:36 PM, Antti Palosaari wrote:
> On 16.12.2013 10:53, Hans Verkuil wrote:
>> On 12/14/2013 05:15 PM, Antti Palosaari wrote:
> 
>>> @@ -1288,8 +1288,13 @@ static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
>>>   	struct video_device *vfd = video_devdata(file);
>>>   	struct v4l2_frequency *p = arg;
>>>
>>> -	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>>> -			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>>> +	if (vfd->vfl_type == VFL_TYPE_SDR) {
>>> +		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
>>> +			return -EINVAL;
>>
>> This is wrong. As you mentioned in patch 1, the type field should always be set by
>> the driver. So type is not something that is set by the user.
>>
>> I would just set type to V4L2_TUNER_ADC here (all SDR devices have at least an ADC
>> tuner), and let the driver change it to TUNER_RF if this tuner is really an RF
>> tuner.
> 
> I don't think so. It sounds very stupid to handle tuner type with 
> different meaning in that single case - it sounds just a is a mistake 
> (and that SDR case mistakes are not needed continue as no regressions 
> apply). I can say I was very puzzled what is the reason my tuner type is 
> always changed to wrong, until finally found it was overridden here.
> 
> For me this looks more than it is just forced to "some" suitable value 
> in a case app does not fill it correctly - not the way driver should 
> return it to app. Tuner ID and type are here for Kernel driver could 
> identify not the opposite and that is how it should be without unneeded 
> exceptions.
> 
> Also, API does not specify that kind of different meaning for tuner type 
> in a case of g_frequency.
> 
> Have to search some history where that odds is coming from...

The application *does not set type* when calling G_FREQUENCY. The driver has
to fill that in. So the type field as received from the application is
uninitialized. That's the way the spec was defined, and that's the way
applications use G_FREQUENCY. There is nothing you can do about that.

So drivers have to fill in the type based on vfl_type and the tuner index.
Since drivers often didn't do that the vfl_type check has been moved to the
v4l2 core. In the case of SDR the type is actually dependent on the tuner
index, so the core cannot fully initialize the type field.

You can either leave it uninitialized for vfl_type SDR and leave it to the
SDR driver to fill in the type, or you can set it to ADC so the driver
only has to update the type field if the tuner index corresponds to the
RF tuner.

Regards,

	Hans
