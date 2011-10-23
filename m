Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35848 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab1JWJyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Oct 2011 05:54:00 -0400
Received: by bkbzt19 with SMTP id zt19so6828367bkb.19
        for <linux-media@vger.kernel.org>; Sun, 23 Oct 2011 02:53:58 -0700 (PDT)
Message-ID: <4EA3E42A.9040306@gmail.com>
Date: Sun, 23 Oct 2011 11:53:46 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC] subdevice PM: .s_power() deprecation?
References: <Pine.LNX.4.64.1110031138370.14314@axis700.grange> <4EA3D3F8.907@iki.fi> <4EA3D7DB.4000908@gmail.com> <201110231126.24905.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201110231126.24905.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 10/23/2011 11:26 AM, Laurent Pinchart wrote:
> On Sunday 23 October 2011 11:01:15 Sylwester Nawrocki wrote:
>> On 10/23/2011 10:44 AM, Sakari Ailus wrote:
>>> Sylwester Nawrocki wrote:
>>>>>> 2. In some of our camera pipeline setups - "Sensor - MIPI-CSI receiver
>>>>>> - host/DMA",
>>>>>>
>>>>>>     the sensor won't boot properly if all MIPI-CSI regulators aren't
>>>>>>     enabled. So the MIPI-CSI receiver must always be powered on before
>>>>>>     the sensor. With the subdevs doing their own magic wrt to power
>>>>>>     control the situation is getting slightly out of control.
>>>>>
>>>>> How about this: CSI-2 receiver implements a few new regulators which
>>>>> the sensor driver then requests to be enabled. Would that work for
>>>>> you?
>>>>
>>>> No, I don't like that... :)
>>>>
>>>> We would have to standardize the regulator supply names, etc. Such
>>>> approach would be more difficult to align with runtime/system
>>>> suspend/resume. Also the sensor drivers should be independent on other
>>>> drivers. The MIPI-CSI receiver is more specific to the host, rather
>>>> than a sensor.
>>>>
>>>> Not all sensors need MIPI-CSI, some just use parallel video bus.
>>>
>>> The sensor drivers are responsible for the regulators they want to use,
>>> right? If they need no CSI-2 related regulators then they just ignore
>>
>> Only for the regulator supplies for their device. In this case the sensor
>> driver would have to touch MIPI-CSI device regulator supplies.
>>
>>> them as any other regulators the sensor doesn't need.
>>>
>>> The names of the regulators could come from the platform data, they're
>>> board specific anyway. I can't see another way to do this without having
>>
>> No, you don't want regulator supply names in any platform data struct.
>> The platform code binds regulator supplies to the devices, whether it is DT
>> based or not.
> 
> You can still add a regulator name field to the sensor platform data, or a
> link to the regulator in the device tree, and use that in the sensor driver if
> present.
> 
> I'm not telling it's a good solution, but it's technically doable.

Yes, that would be also possible.

> 
>>> platform code to do this which is not quite compatible with the idea of
>>> the device tree.
>>
>> Now I just use s_power callback in our drivers and it all works well.
> 
> Having the sensor driver calling the CSI-2 receiver s_power callback directly
> sounds a bit hackish to me. If we really want to call subdev operations from
> another subdev driver we'll need to specify that, as the current mode of
> operation (at least in my understanding) is that subdev operations are only
> called by host drivers.

I meant s_power() is only used by the host. Every device in the pipeline is
powered up by the host at video device open() in right order.

Maybe we could ad some kind of notifier to v4l core so the host gets notified
when any of subdevs registered to it gets it's video node opened ?

--
Regards,
Sylwester 
