Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:40920 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab1JWIov (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Oct 2011 04:44:51 -0400
Message-ID: <4EA3D3F8.907@iki.fi>
Date: Sun, 23 Oct 2011 11:44:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC] subdevice PM: .s_power() deprecation?
References: <Pine.LNX.4.64.1110031138370.14314@axis700.grange> <Pine.LNX.4.64.1110171720260.18438@axis700.grange> <4E9C9D84.5020905@gmail.com> <201110180107.20494.laurent.pinchart@ideasonboard.com> <4E9DEB4A.4050001@gmail.com> <Pine.LNX.4.64.1110182315180.7139@axis700.grange> <4E9F399B.9080207@gmail.com> <4EA3CB48.5000203@iki.fi> <4EA3D1C4.8050302@gmail.com>
In-Reply-To: <4EA3D1C4.8050302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 10/23/2011 10:07 AM, Sakari Ailus wrote:
>> Sylwester Nawrocki wrote:
>> ...
>>>> I understand what you're saying, but can you give us a specific example,
>>>> when a subdev driver (your SoC internal subdev, that is) doesn't have a
>>>> way to react to an event itself and only the bridge driver gets called
>>>> into at that time? Something like an interrupt or an internal timer or
>>>> some other internal event?
>>>
>>> 1. The S5P SoC video output subsystem (http://lwn.net/Articles/449661) comprises
>>>   of multiple logical blocks, like Video Processor, Mixer, HDMI, HDMI PHY, SD TV Out.
>>>   For instance the master video clock is during normal operation derived from
>>>   (synchronized to, with PLL,) the HDMI-PHY output clock. The host driver can
>>>   switch to this clock only when the HDMI-PHY (subdev) power and clocks are enabled.
>>>   And it should be done before .s_stream(), to do some H/W configuration earlier
>>>   in the pipeline, before streaming is enabled. Perhaps Tomasz could give some
>>>   further explanation of what the s_power() op does and why in the driver.
>>>
>>> 2. In some of our camera pipeline setups - "Sensor - MIPI-CSI receiver - host/DMA",
>>>   the sensor won't boot properly if all MIPI-CSI regulators aren't enabled. So the
>>>   MIPI-CSI receiver must always be powered on before the sensor. With the subdevs
>>>   doing their own magic wrt to power control the situation is getting slightly
>>>   out of control.
>>
>> How about this: CSI-2 receiver implements a few new regulators which the
>> sensor driver then requests to be enabled. Would that work for you?
> 
> No, I don't like that... :)
> 
> We would have to standardize the regulator supply names, etc. Such approach
> would be more difficult to align with runtime/system suspend/resume.
> Also the sensor drivers should be independent on other drivers. The MIPI-CSI
> receiver is more specific to the host, rather than a sensor.
> 
> Not all sensors need MIPI-CSI, some just use parallel video bus.

The sensor drivers are responsible for the regulators they want to use,
right? If they need no CSI-2 related regulators then they just ignore
them as any other regulators the sensor doesn't need.

The names of the regulators could come from the platform data, they're
board specific anyway. I can't see another way to do this without having
platform code to do this which is not quite compatible with the idea of
the device tree.

-- 
Sakari Ailus
sakari.ailus@iki.fi
