Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:24120 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab1JWIHv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Oct 2011 04:07:51 -0400
Message-ID: <4EA3CB48.5000203@iki.fi>
Date: Sun, 23 Oct 2011 11:07:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC] subdevice PM: .s_power() deprecation?
References: <Pine.LNX.4.64.1110031138370.14314@axis700.grange> <Pine.LNX.4.64.1110171720260.18438@axis700.grange> <4E9C9D84.5020905@gmail.com> <201110180107.20494.laurent.pinchart@ideasonboard.com> <4E9DEB4A.4050001@gmail.com> <Pine.LNX.4.64.1110182315180.7139@axis700.grange> <4E9F399B.9080207@gmail.com>
In-Reply-To: <4E9F399B.9080207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
...
>> I understand what you're saying, but can you give us a specific example,
>> when a subdev driver (your SoC internal subdev, that is) doesn't have a
>> way to react to an event itself and only the bridge driver gets called
>> into at that time? Something like an interrupt or an internal timer or
>> some other internal event?
> 
> 1. The S5P SoC video output subsystem (http://lwn.net/Articles/449661) comprises
>  of multiple logical blocks, like Video Processor, Mixer, HDMI, HDMI PHY, SD TV Out.
>  For instance the master video clock is during normal operation derived from
>  (synchronized to, with PLL,) the HDMI-PHY output clock. The host driver can
>  switch to this clock only when the HDMI-PHY (subdev) power and clocks are enabled.
>  And it should be done before .s_stream(), to do some H/W configuration earlier
>  in the pipeline, before streaming is enabled. Perhaps Tomasz could give some
>  further explanation of what the s_power() op does and why in the driver. 
>  
> 2. In some of our camera pipeline setups - "Sensor - MIPI-CSI receiver - host/DMA",
>  the sensor won't boot properly if all MIPI-CSI regulators aren't enabled. So the  
>  MIPI-CSI receiver must always be powered on before the sensor. With the subdevs
>  doing their own magic wrt to power control the situation is getting slightly
>  out of control. 

How about this: CSI-2 receiver implements a few new regulators which the
sensor driver then requests to be enabled. Would that work for you?

>>> I guess we all agree the power requirements of external subdevs are generally
>>> unknown to the hosts.
>>>
>>> For these it might make lot of sense to let the subdev driver handle the device
>>> power supplies on basis of requests like, s_ctrl, s_stream, etc.
>>
>> Yes, right, so, most "external" (sensor, decoder,...) subdev drivers
>> should never need to implement .s_power(), regardless of whether we decide
>> to keep it or not. Well, ok, no, put it differently - in those drivers
>> .s_power() should only really be called during system-wide suspend /
>> resume.
> 
> Yes, I agree with that. But before we attempt to remove .s_power() or deprecate 
> it on "external" subdevs, I'd like to get solved the issue with sensor master clock 
> provided by the bridge. As these two are closely related - the sensor controller 
> won't boot if the clock is disabled. And there are always advantages of not keeping
> the clock always enabled. 

I guess we'll need to wait awhile before the clock framework would
support this. I don't know what's the status of this; probably worth
checking.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
