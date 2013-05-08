Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25048 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3EHHcX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 03:32:23 -0400
Message-id: <5189FF81.5030405@samsung.com>
Date: Wed, 08 May 2013 09:32:17 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Kim, Milo" <Milo.Kim@ti.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"hj210.choi@samsung.com" <hj210.choi@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC 0/2] V4L2 API for exposing flash subdevs as LED class device
References: <1367832828-30771-1-git-send-email-a.hajda@samsung.com>
 <A874F61F95741C4A9BA573A70FE3998F82E5C879@DQHE06.ent.ti.com>
 <1958801.k4UEk5OhXt@avalon>
In-reply-to: <1958801.k4UEk5OhXt@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07.05.2013 17:07, Laurent Pinchart wrote:
> On Tuesday 07 May 2013 02:11:27 Kim, Milo wrote:
>> On Monday, May 06, 2013 6:34 PM Andrzej Hajda wrote:
>>> This RFC proposes generic API for exposing flash subdevices via LED
>>> framework.
>>>
>>> Rationale
>>>
>>> Currently there are two frameworks which are used for exposing LED
>>> flash to user space:
>>> - V4L2 flash controls,
>>> - LED framework(with custom sysfs attributes).
>>>
>>> The list below shows flash drivers in mainline kernel with initial
>>> commit date and typical chip application (according to producer):
>>>
>>> LED API:
>>>     lm3642: 2012-09-12, Cameras
>>>     lm355x: 2012-09-05, Cameras
>>>     max8997: 2011-12-14, Cameras (?)
>>>     lp3944: 2009-06-19, Cameras, Lights, Indicators, Toys
>>>     pca955x: 2008-07-16, Cameras, Indicators (?)
>>>
>>> V4L2 API:
>>>     as3645a:  2011-05-05, Cameras
>>>     adp1653: 2011-05-05, Cameras
>>>
>>> V4L2 provides richest functionality, but there is often demand from
>>> application developers to provide already established LED API. We would
>>> like to have an unified user interface for flash devices. Some of devices
>>> already have the LED API driver exposing limited set of a Flash IC
>>> functionality. In order to support all required features the LED API
>>> would have to be extended or the V4L2 API would need to be used. However
>>> when switching from a LED to a V4L2 Flash driver existing LED API
>>> interface would need to be retained.
>>>
>>> Proposed solution
>>>
>>> This patch adds V4L2 helper functions to register existing V4L2 flash
>>> subdev as LED class device. After registration via v4l2_leddev_register
>>> appropriate entry in /sys/class/leds/ is created. During registration all
>>> V4L2 flash controls are enumerated and corresponding attributes are added.
>>>
>>> I have attached also patch with new max77693-led driver using v4l2_leddev.
>>> This patch requires presence of the patch "max77693: added device tree
>>> support": https://patchwork.kernel.org/patch/2414351/ .
>>>
>>> Additional features
>>>
>>> - simple API to access all V4L2 flash controls via sysfs,
>>> - V4L2 subdevice should not be registered by V4L2 device to use it,
>>> - LED triggers API can be used to control the device,
>>> - LED device is optional - it will be created only if V4L2_LEDDEV
>>>   configuration option is enabled and the subdev driver calls
>>>   v4l2_leddev_register.
>>>
>>> Doubts
>>>
>>> This RFC is a result of a uncertainty which API developers should expose
>>> by their flash drivers. It is a try to gluing together both APIs. I am not
>>> sure if it is the best solution, but I hope there will be some discussion
>>> and hopefully some decisions will be taken which way we should follow.
>> The LED subsystem provides similar APIs for the Camera driver.
>> With LED trigger event, flash and torch are enabled/disabled.
>> I'm not sure this is applicable for you.
>> Could you take a look at LED camera trigger feature?
>>
>> For the camera LED trigger,
>> https://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git/commit/
>> ?h=f or-next&id=48a1d032c954b9b06c3adbf35ef4735dd70ab757
>>
>> Example of camera flash driver,
>> https://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git/commit/
>> ?h=f or-next&id=313bf0b1a0eaeaac17ea8c4b748f16e28fce8b7a
> I think we should decide on one API. Implementing two APIs for a single device 
> is usually messy, and will result in different feature sets (and different 
> bugs) being implemented through each API, depending on the driver. 
> Interactions between the APIs are also a pain point on the kernel side to 
> properly synchronize calls.
>
> The LED API is too limited for torch and flash usage, but I'm definitely open 
> to moving flash devices to the LED API is we can extend it in a way that it 
> covers all the use cases.
>
Extending LED API IMHO seems to be quite straightforward - by adding
attributes for supported functionalities. We just need a specification for
standard flash/torch attributes.
I could prepare an RFC about it if there is a will to explore this
direction.

--
Regards
Andrzej Hajda <a.hajda@samsung.com>

