Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:56131 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1C3FGz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 01:06:55 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIU00644U7F3M20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 30 Mar 2011 14:06:52 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIU00FSSU7GF6@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 30 Mar 2011 14:06:52 +0900 (KST)
Date: Wed, 30 Mar 2011 14:06:57 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC] V4L2 API for flash devices
In-reply-to: <4D91EF7D.2020403@maxwell.research.nokia.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D92BA71.9080005@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D90854C.2000802@maxwell.research.nokia.com>
 <4D91B7EC.2020004@samsung.com> <4D91EF7D.2020403@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

2011-03-29 오후 11:41, Sakari Ailus 쓴 글:
> Kim, HeungJun wrote:
[snip]
>> I think it's not different method to turn on/off, whatever the mode name is.
>> But, the mode name DEDICATED is look more reasonable, because the reason 
>> which is devided FLASH and TORCH in the mode, is why only power up the led,
>> not sensor.
> 
> Sensor? Is the flash part of the sensor module for you?
Yes. The flash is a part of the sensor module(our case like M-5MOLS).
Precisely, the sensor internal core's gpio pin is connected with
external Flash LED, and the control master is the sensor internal core.
For turnning on the Flash LED, we should use I2C register access.
So, I think it's exactly matches with hardware strobe as you metioned.

> 
> I think it should be other factors than the flash mode that are used to
> make the decision on whether to power on the sensor or not.
> 
> The factors based on which to power the subdevs probably will be
> discussed in the future, and which entity is responsible for power
> management. The power management code originally was part of the Media
> controller framework but it was removed since it was not seen to be
> generic enough.
> 
> Many subdev drivers (including the adp1653) basically get powered as
> long as the subdev device node is open. Sensor can be powered based on
> other factors as well, such as the streaming state and what are the
> connections to the video nodes.
That's the start point I said. When the user use only the flash, it should be
accompanied(of course, I have same circumstance) by opening the videonode
and doing the media control operation, but we have no option to do because
it's depending on the hardware connection architecture.

So, I suggesst that, if we can not give to users(of course, this user
want to use only flash function, not the camera) proper method usage
(openning the videonode for using flash), let's express that the camera
flash is used in the DEDICATED MODE now, as the enumeration name DEDICATED.

But, I think it might be not a big issue. So, any others don't comment at this,
it's ok for me to pass this naming issue.

I can see this API is very cool for camera man just like me.

Cheers!

plus: actually I have the one of N-series, N810. So, the omap3isp is available to
activate this device, not even it's cpu is omap3? Just question.

Regards,
Heungjun Kim

