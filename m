Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60371 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1JSU5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 16:57:06 -0400
Received: by eye27 with SMTP id 27so2043016eye.19
        for <linux-media@vger.kernel.org>; Wed, 19 Oct 2011 13:57:04 -0700 (PDT)
Message-ID: <4E9F399B.9080207@gmail.com>
Date: Wed, 19 Oct 2011 22:56:59 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC] subdevice PM: .s_power() deprecation?
References: <Pine.LNX.4.64.1110031138370.14314@axis700.grange> <Pine.LNX.4.64.1110171720260.18438@axis700.grange> <4E9C9D84.5020905@gmail.com> <201110180107.20494.laurent.pinchart@ideasonboard.com> <4E9DEB4A.4050001@gmail.com> <Pine.LNX.4.64.1110182315180.7139@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1110182315180.7139@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2011 11:38 PM, Guennadi Liakhovetski wrote:
> On Tue, 18 Oct 2011, Sylwester Nawrocki wrote:
>> On 10/18/2011 01:07 AM, Laurent Pinchart wrote:
>>> On Monday 17 October 2011 23:26:28 Sylwester Nawrocki wrote:
>>>> On 10/17/2011 05:23 PM, Guennadi Liakhovetski wrote:
>>>>> On Mon, 17 Oct 2011, Sylwester Nawrocki wrote:
> 
> [snip]
> 
>>>>>> The bridge driver could also choose to keep the sensor powered on,
>>>>>> whenever it sees appropriate, to avoid re-enabling the sensor to often.
>>>>>
>>>>> On what basis would the bridge driver make these decisions? How would it
>>>>> know in advance, when it'll have to re-enable the subdev next time?
>>>>
>>>> Re-enabling by allowing a subdev driver to entirely control the power
>>>> state. The sensor might implement "lowest power consumption" policy, while
>>>> the user might want "highest performance".
>>>
>>> Exactly, that's a policy decision. Would PM QoS help here ?
>>
>> Thanks for reminding about PM QoS. I didn't pay much attention to it but it
>> indeed appears to be a good fit for this sort of tasks.
> 
> But you anyway have to decide - who will implement those PM QoS callbacks?
> The bridge and then decide whether or not to call subdev's .s_power(), or
> the subdev driver itself? I think, the latter, in which case .s_power()
> remain unused.

Agreed. With some hints on how to handle power supply directly in the subdev
driver we should be able to do without s_power() at the "edge" subdevs.

> 
>> We would possibly just need to think of parameters which could be associated with
>> video, e.g. video_latency, etc. ?...
>>
>> I'm curious whether the whole power handling could be contained within a subdev
>> driver, most likely it could be done for subdevs exposing a devnode.
>>
>>>
>>>> I'm referring only to camera sensor subdevs, as I don't have much experience
>>>> with other ones.
>>>>
>>>> Also there are some devices where you want to model power control
>>>> explicitly, and it is critical to overall system operation. The s5p-tv
>>>> driver is one example of these. The host driver knows exactly how the
>>>> power state of its subdevs should be handled.
>>>
>>> The host probably knows about how to handle the power state of its internal
>>> subdevs, but what about external ones ?
>>
>> In this particular example there is no external subdevs associated with the host.
>>
>> But we don't seem to have separate callbacks for internal and external subdevs..
>> So removing s_power() puts the above described sort of drivers in trouble.
> 
> I understand what you're saying, but can you give us a specific example,
> when a subdev driver (your SoC internal subdev, that is) doesn't have a
> way to react to an event itself and only the bridge driver gets called
> into at that time? Something like an interrupt or an internal timer or
> some other internal event?

1. The S5P SoC video output subsystem (http://lwn.net/Articles/449661) comprises
 of multiple logical blocks, like Video Processor, Mixer, HDMI, HDMI PHY, SD TV Out.
 For instance the master video clock is during normal operation derived from
 (synchronized to, with PLL,) the HDMI-PHY output clock. The host driver can
 switch to this clock only when the HDMI-PHY (subdev) power and clocks are enabled.
 And it should be done before .s_stream(), to do some H/W configuration earlier
 in the pipeline, before streaming is enabled. Perhaps Tomasz could give some
 further explanation of what the s_power() op does and why in the driver. 
 
2. In some of our camera pipeline setups - "Sensor - MIPI-CSI receiver - host/DMA",
 the sensor won't boot properly if all MIPI-CSI regulators aren't enabled. So the  
 MIPI-CSI receiver must always be powered on before the sensor. With the subdevs
 doing their own magic wrt to power control the situation is getting slightly
 out of control. 
 
> 
>> I guess we all agree the power requirements of external subdevs are generally
>> unknown to the hosts.
>>
>> For these it might make lot of sense to let the subdev driver handle the device
>> power supplies on basis of requests like, s_ctrl, s_stream, etc.
> 
> Yes, right, so, most "external" (sensor, decoder,...) subdev drivers
> should never need to implement .s_power(), regardless of whether we decide
> to keep it or not. Well, ok, no, put it differently - in those drivers
> .s_power() should only really be called during system-wide suspend /
> resume.

Yes, I agree with that. But before we attempt to remove .s_power() or deprecate 
it on "external" subdevs, I'd like to get solved the issue with sensor master clock 
provided by the bridge. As these two are closely related - the sensor controller 
won't boot if the clock is disabled. And there are always advantages of not keeping
the clock always enabled. 

> 
>> With PM QoS it could be easier to decide in the driver when a device should be
>> put in a low power state.

-- 
Regards,
Sylwester
