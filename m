Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50811 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1JRVKk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 17:10:40 -0400
Received: by eye27 with SMTP id 27so978820eye.19
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 14:10:39 -0700 (PDT)
Message-ID: <4E9DEB4A.4050001@gmail.com>
Date: Tue, 18 Oct 2011 23:10:34 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] subdevice PM: .s_power() deprecation?
References: <Pine.LNX.4.64.1110031138370.14314@axis700.grange> <Pine.LNX.4.64.1110171720260.18438@axis700.grange> <4E9C9D84.5020905@gmail.com> <201110180107.20494.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201110180107.20494.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 10/18/2011 01:07 AM, Laurent Pinchart wrote:
> On Monday 17 October 2011 23:26:28 Sylwester Nawrocki wrote:
>> On 10/17/2011 05:23 PM, Guennadi Liakhovetski wrote:
>>> On Mon, 17 Oct 2011, Sylwester Nawrocki wrote:
>>>> On 10/17/2011 03:49 PM, Guennadi Liakhovetski wrote:
>>>>> On Mon, 17 Oct 2011, Sylwester Nawrocki wrote:
>>>>>> On 10/17/2011 10:06 AM, Guennadi Liakhovetski wrote:
>>>>>>> On Sun, 9 Oct 2011, Sakari Ailus wrote:
>>>>>>>> On Mon, Oct 03, 2011 at 12:57:10PM +0200, Guennadi Liakhovetski
> wrote:
>>>> ...
>>>>
>>>>>>>> The bridge driver can't (nor should) know about the power management
>>>>>>>> requirements of random subdevs. The name of the s_power op is rather
>>>>>>>> poitless in its current state.
>>>>>>>>
>>>>>>>> The power state of the subdev probably even never matters to the
>>>>>>>> bridge ---
>>>>>>>
>>>>>>> Exactly, that's the conclusion I come to in this RFC too.
>>>>>>>
>>>>>>>> or do we really have an example of that?
>>>>>>>>
>>>>>>>> In my opinion the bridge driver should instead tell the bridge
>>>>>>>> drivers what they can expect to hear from the bridge --- for
>>>>>>>> example that the bridge can issue set / get controls or fmt ops to
>>>>>>>> the subdev. The subdev may or may not need to be powered for those:
>>>>>>>> only the subdev driver knows.
>>>>>>>
>>>>>>> Hm, why should the bridge driver tell the subdev driver (I presume,
>>>>>>> that's a typo in your above sentence) what to _expect_? Isn't just
>>>>>>> calling those operations enough?
>>>>>>>
>>>>>>>> This is analogous to opening the subdev node from user space.
>>>>>>>> Anything else except streaming is allowed. And streaming, which for
>>>>>>>> sure requires powering on the subdev, is already nicely handled by
>>>>>>>> the s_stream op.
>>>>>>>>
>>>>>>>> What do you think?
>>>>>>>>
>>>>>>>> In practice the name of s_power should change, as well as possible
>>>>>>>> implementatio on subdev drivers.
>>>>>>>
>>>>>>> But why do we need it at all?
>>>>>>
>>>>>> AFAICS in some TV card drivers it is used to put the analog tuner into
>>>>>> low power state.
>>>>>> So core.s_power op provides the mans to suspend/resume a sub-device.
>>>>>>
>>>>>> If the bridge driver only implements a user space interface for the
>>>>>> subdev, it may want to bring a subdev up in some specific moment,
>>>>>> before video.s_stream, e.g. in some ioctl or at device open(), etc.
>>>>>>
>>>>>> Let's imagine bringing the sensor up takes appr. 700 ms, often we
>>>>>> don't want the sensor driver to be doing this before every
>>>>>> s_stream().
>>>>>
>>>>> Sorry, I still don't understand, how the bridge driver knows better,
>>>>> than the subdev driver, whether the user will resume streaming in
>>>>> 500ms or in 20s? Maybe there's some such information available with
>>>>> tuners, which I'm just unaware about?
>>>>
>>>> What I meant was that if the bridge driver assumes in advance that
>>>> enabling sensor's power and getting it fully operational takes long
>>>> time, it can enable sensor's power earlier than it's really necessary,
>>>> to avoid excessive latencies during further actions.
>>>
>>> Where would a bridge driver get this information from? And how would it
>>> know in advance, when power would be "really needed" to enable it
>>> "earlier?"...
>>
>> I don't think this information could now be retrieved from a subdev in
>> standard way.
>>
>> If a bridge driver wants low latencies it can simply be coded to issue
>> s_power(1) before any other op call, and s_power(0) when it's done with a
>> subdev.
>>
>>>> The bridge driver could also choose to keep the sensor powered on,
>>>> whenever it sees appropriate, to avoid re-enabling the sensor to often.
>>>
>>> On what basis would the bridge driver make these decisions? How would it
>>> know in advance, when it'll have to re-enable the subdev next time?
>>
>> Re-enabling by allowing a subdev driver to entirely control the power
>> state. The sensor might implement "lowest power consumption" policy, while
>> the user might want "highest performance".
> 
> Exactly, that's a policy decision. Would PM QoS help here ?

Thanks for reminding about PM QoS. I didn't pay much attention to it but it
indeed appears to be a good fit for this sort of tasks.

We would possibly just need to think of parameters which could be associated with
video, e.g. video_latency, etc. ?...

I'm curious whether the whole power handling could be contained within a subdev 
driver, most likely it could be done for subdevs exposing a devnode.

> 
>> I'm referring only to camera sensor subdevs, as I don't have much experience
>> with other ones.
>>
>> Also there are some devices where you want to model power control
>> explicitly, and it is critical to overall system operation. The s5p-tv
>> driver is one example of these. The host driver knows exactly how the
>> power state of its subdevs should be handled.
> 
> The host probably knows about how to handle the power state of its internal
> subdevs, but what about external ones ?

In this particular example there is no external subdevs associated with the host. 

But we don't seem to have separate callbacks for internal and external subdevs..
So removing s_power() puts the above described sort of drivers in trouble.

I guess we all agree the power requirements of external subdevs are generally 
unknown to the hosts.

For these it might make lot of sense to let the subdev driver handle the device
power supplies on basis of requests like, s_ctrl, s_stream, etc.  

With PM QoS it could be easier to decide in the driver when a device should be
put in a low power state. 

---
Regards,
Sylwester
