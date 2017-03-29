Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57070 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753716AbdC2HkI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:40:08 -0400
Subject: Re: [PATCH v7] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
 <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
 <f8466f7a-0f33-a610-10fc-2515d5f6b499@iki.fi>
 <ef7c1d62-0553-2c5b-004f-527d82e380b3@collabora.co.uk>
 <20170327150918.6843e285@vento.lan>
 <f668b12f-0da8-98da-63b0-c5064cc87da9@xs4all.nl>
 <20170328142339.GD16657@valkosipuli.retiisi.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Helen Koike <helen.koike@collabora.co.uk>,
        Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cc203084-0018-7851-2cae-c562d2abc060@xs4all.nl>
Date: Wed, 29 Mar 2017 09:39:58 +0200
MIME-Version: 1.0
In-Reply-To: <20170328142339.GD16657@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/03/17 16:23, Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, Mar 28, 2017 at 12:00:36PM +0200, Hans Verkuil wrote:
>> On 27/03/17 20:09, Mauro Carvalho Chehab wrote:
>>> Em Mon, 27 Mar 2017 12:19:51 -0300
>>> Helen Koike <helen.koike@collabora.co.uk> escreveu:
>>>
>>>> Hi Sakari,
>>>>
>>>> On 2017-03-26 10:31 AM, Sakari Ailus wrote:
>>>>> Hi Helen,
>>>>>
>>>>> ...  
>>>>>> +static int vimc_cap_enum_input(struct file *file, void *priv,
>>>>>> +			       struct v4l2_input *i)
>>>>>> +{
>>>>>> +	/* We only have one input */
>>>>>> +	if (i->index > 0)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	i->type = V4L2_INPUT_TYPE_CAMERA;
>>>>>> +	strlcpy(i->name, "VIMC capture", sizeof(i->name));
>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>> +static int vimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
>>>>>> +{
>>>>>> +	/* We only have one input */
>>>>>> +	*i = 0;
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>> +static int vimc_cap_s_input(struct file *file, void *priv, unsigned int i)
>>>>>> +{
>>>>>> +	/* We only have one input */
>>>>>> +	return i ? -EINVAL : 0;
>>>>>> +}  
>>>>>
>>>>> You can drop the input IOCTLs altogether here. If you had e.g. a TV
>>>>> tuner, it'd be the TV tuner driver's responsibility to implement them.
>>>>>  
>>>>
>>>> input IOCTLs seems to be mandatory from v4l2-compliance when capability 
>>>> V4L2_CAP_VIDEO_CAPTURE is set (which is the case):
>>>>
>>>> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-test-input-output.cpp#n418
>>>>
>>>> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-compliance.cpp#n989
>>>
>>> The V4L2 spec doesn't actually define what's mandatory and what's
>>> optional. The idea that was agreed on one of the media summits
>>> were to define a set of profiles for different device types,
>>> matching the features required by existing applications to work,
>>> but this was never materialized.
>>>
>>> So, my understanding is that any driver can implement
>>> any V4L2 ioctl.
>>>
>>> Yet, some applications require enum/get/set inputs, or otherwise
>>> they wouldn't work. It is too late to change this behavior. 
>>> So, either the driver or the core should implement those
>>> ioctls, in order to avoid breaking backward-compatibility.
>>
>> The closest we have to determining which ioctls are mandatory or not is
>> v4l2-compliance. That said, v4l2-compliance is actually a bit more strict
>> in some cases than the spec since some ioctls are optional in the spec, but
>> required in v4l2-compliance for the simple reason that there is no reason
>> for drivers NOT to implement those ioctls.
>>
>> However, the v4l2-compliance test was never written for MC devices. It turns
>> out that it works reasonably well as long as a working pipeline is configured
>> first, but these input ioctls are a bit iffy.
>>
>> There are really two options: don't implement them, or implement it as a single
>> input. Multiple inputs make no sense for MC devices: the video node is the
>> endpoint of a video pipeline, you never switch 'inputs' there.
>>
>> The way the input ioctls are implemented here would fit nicely for an MC
>> device IMHO.
>>
>> So should we define these ioctls or not?
>>
>> I am inclined to define them for the following reasons:
>>
>> - Some applications expect them, so adding them to the driver costs little but
>>   allows these applications to work, provided the correct pipeline is configured
>>   first.
>>
>> - If a plugin is needed, then that plugin can always override these ioctls and
>>   for different 'inputs' reconfigure the pipeline.
>>
>> I really don't see implementing this as a problem. Reporting that an MC video node
>> has a "VIMC capture" input seems perfectly reasonable to me.
> 
> If we implement it in order to be make an application happy, I would have
> expected to hear complaints from someone using existing MC based drivers
> that do not implement the input IOCTLs.

It's for the same reason no one complained about the missing plugin: 'regular'
applications aren't used for these MC devices since they tend to be used on
embedded systems with custom software.

> It is also confusing from application point of view since this interface
> would not be the interface to configure the input of the pipeline as it
> might look like.
> 

The whole point is that, once a video pipeline is set up with media-ctl, the
driver will act just like a non-MC driver with a single input. Which is the
whole point. Applications that are MC aware won't use this, they would program
the media controller/subdevs directly.

It costs us next to nothing and it makes life easier for all. I really don't
see a downside to this.

Regards,

	Hans
