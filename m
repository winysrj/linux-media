Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54773 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab1JWIfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Oct 2011 04:35:22 -0400
Received: by bkbzt19 with SMTP id zt19so6776033bkb.19
        for <linux-media@vger.kernel.org>; Sun, 23 Oct 2011 01:35:20 -0700 (PDT)
Message-ID: <4EA3D1C4.8050302@gmail.com>
Date: Sun, 23 Oct 2011 10:35:16 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC] subdevice PM: .s_power() deprecation?
References: <Pine.LNX.4.64.1110031138370.14314@axis700.grange> <Pine.LNX.4.64.1110171720260.18438@axis700.grange> <4E9C9D84.5020905@gmail.com> <201110180107.20494.laurent.pinchart@ideasonboard.com> <4E9DEB4A.4050001@gmail.com> <Pine.LNX.4.64.1110182315180.7139@axis700.grange> <4E9F399B.9080207@gmail.com> <4EA3CB48.5000203@iki.fi>
In-Reply-To: <4EA3CB48.5000203@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/23/2011 10:07 AM, Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
> ...
>>> I understand what you're saying, but can you give us a specific example,
>>> when a subdev driver (your SoC internal subdev, that is) doesn't have a
>>> way to react to an event itself and only the bridge driver gets called
>>> into at that time? Something like an interrupt or an internal timer or
>>> some other internal event?
>>
>> 1. The S5P SoC video output subsystem (http://lwn.net/Articles/449661) comprises
>>   of multiple logical blocks, like Video Processor, Mixer, HDMI, HDMI PHY, SD TV Out.
>>   For instance the master video clock is during normal operation derived from
>>   (synchronized to, with PLL,) the HDMI-PHY output clock. The host driver can
>>   switch to this clock only when the HDMI-PHY (subdev) power and clocks are enabled.
>>   And it should be done before .s_stream(), to do some H/W configuration earlier
>>   in the pipeline, before streaming is enabled. Perhaps Tomasz could give some
>>   further explanation of what the s_power() op does and why in the driver.
>>
>> 2. In some of our camera pipeline setups - "Sensor - MIPI-CSI receiver - host/DMA",
>>   the sensor won't boot properly if all MIPI-CSI regulators aren't enabled. So the
>>   MIPI-CSI receiver must always be powered on before the sensor. With the subdevs
>>   doing their own magic wrt to power control the situation is getting slightly
>>   out of control.
> 
> How about this: CSI-2 receiver implements a few new regulators which the
> sensor driver then requests to be enabled. Would that work for you?

No, I don't like that... :)

We would have to standardize the regulator supply names, etc. Such approach
would be more difficult to align with runtime/system suspend/resume.
Also the sensor drivers should be independent on other drivers. The MIPI-CSI
receiver is more specific to the host, rather than a sensor.

Not all sensors need MIPI-CSI, some just use parallel video bus.

> 
>>>> I guess we all agree the power requirements of external subdevs are generally
>>>> unknown to the hosts.
>>>>
>>>> For these it might make lot of sense to let the subdev driver handle the device
>>>> power supplies on basis of requests like, s_ctrl, s_stream, etc.
>>>
>>> Yes, right, so, most "external" (sensor, decoder,...) subdev drivers
>>> should never need to implement .s_power(), regardless of whether we decide
>>> to keep it or not. Well, ok, no, put it differently - in those drivers
>>> .s_power() should only really be called during system-wide suspend /
>>> resume.
>>
>> Yes, I agree with that. But before we attempt to remove .s_power() or deprecate
>> it on "external" subdevs, I'd like to get solved the issue with sensor master clock
>> provided by the bridge. As these two are closely related - the sensor controller
>> won't boot if the clock is disabled. And there are always advantages of not keeping
>> the clock always enabled.
> 
> I guess we'll need to wait awhile before the clock framework would
> support this. I don't know what's the status of this; probably worth
> checking.

Last time I checked, a reference platform migration to common clk struct was
being prepared for OMAP.
So hopefully we are close to the agreement. I think there is a speech about
this during ELCE.

--
Regards,
Sylwester
