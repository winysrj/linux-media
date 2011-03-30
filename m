Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:45650 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab1C3LiG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 07:38:06 -0400
Message-ID: <4D931610.9030504@maxwell.research.nokia.com>
Date: Wed, 30 Mar 2011 14:37:52 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: riverful.kim@samsung.com
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <4D91B7EC.2020004@samsung.com> <4D91EF7D.2020403@maxwell.research.nokia.com> <4D92BA71.9080005@samsung.com>
In-Reply-To: <4D92BA71.9080005@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Kim, HeungJun wrote:
> Hi Sakari,

Hi HeungJun,

> 2011-03-29 오후 11:41, Sakari Ailus 쓴 글:
>> Kim, HeungJun wrote:
> [snip]
>>> I think it's not different method to turn on/off, whatever the mode name is.
>>> But, the mode name DEDICATED is look more reasonable, because the reason 
>>> which is devided FLASH and TORCH in the mode, is why only power up the led,
>>> not sensor.
>>
>> Sensor? Is the flash part of the sensor module for you?
> Yes. The flash is a part of the sensor module(our case like M-5MOLS).
> Precisely, the sensor internal core's gpio pin is connected with
> external Flash LED, and the control master is the sensor internal core.
> For turnning on the Flash LED, we should use I2C register access.
> So, I think it's exactly matches with hardware strobe as you metioned.

Ok, I think I'm lost now. :-)

What signals are sent from sensor to flash in both torch and flash cases?

>> I think it should be other factors than the flash mode that are used to
>> make the decision on whether to power on the sensor or not.
>>
>> The factors based on which to power the subdevs probably will be
>> discussed in the future, and which entity is responsible for power
>> management. The power management code originally was part of the Media
>> controller framework but it was removed since it was not seen to be
>> generic enough.
>>
>> Many subdev drivers (including the adp1653) basically get powered as
>> long as the subdev device node is open. Sensor can be powered based on
>> other factors as well, such as the streaming state and what are the
>> connections to the video nodes.
> That's the start point I said. When the user use only the flash, it should be
> accompanied(of course, I have same circumstance) by opening the videonode
> and doing the media control operation, but we have no option to do because
> it's depending on the hardware connection architecture.

When the user only needs to use the flash, in this case the user must
open the subdev node which is exported by the flash controller driver.
Not the video node, which is handled in the bridge (ISP) driver.

> So, I suggesst that, if we can not give to users(of course, this user
> want to use only flash function, not the camera) proper method usage
> (openning the videonode for using flash), let's express that the camera
> flash is used in the DEDICATED MODE now, as the enumeration name DEDICATED.

No. The video nodes should not be involved since they are related to the
bridge (ISP) which is not needed to use the flash. Assuming that this is
the situation.

This is how the use case should go:

1. open subdev node, e.g. /dev/v4l-subdev0, which is the flash
(flash controller powered on)
2. VIDIOC_S_CTRL: V4L2_CID_FLASH_LED_MODE, V4L2_FLASH_LED_MODE_TORCH
(flash is on now)
2. VIDIOC_S_CTRL: V4L2_CID_FLASH_LED_MODE, V4L2_FLASH_LED_MODE_NONE
(flash is off now)
3. close the file handle
(flash controller powered off)

> But, I think it might be not a big issue. So, any others don't comment at this,
> it's ok for me to pass this naming issue.
> 
> I can see this API is very cool for camera man just like me.

Thanks!

> plus: actually I have the one of N-series, N810. So, the omap3isp is available to
> activate this device, not even it's cpu is omap3? Just question.

The N810 has OMAP 2420 which has a completely different camera bridge,
and there's no flash. The drivers for the camera in N810 are omap24xxcam
and tcm825x. The drivers are functional in mainline but the platform
data is missing, as well as the CBUS driver. This work is queued but
unknown when there's time for this.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
