Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1366 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaFJPLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jun 2014 11:11:36 -0400
Message-ID: <53972018.1020102@xs4all.nl>
Date: Tue, 10 Jun 2014 17:11:20 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
	linux-media@vger.kernel.org
CC: David Peverley <pev@audiogeek.co.uk>
Subject: Re: [PATCH 00/43] i.MX6 Video capture
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com> <53942098.9000109@xs4all.nl> <5395E407.7010100@mentor.com>
In-Reply-To: <5395E407.7010100@mentor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/2014 06:42 PM, Steve Longerbeam wrote:
> On 06/08/2014 01:36 AM, Hans Verkuil wrote:
>> Hi Steve!
>>
>> On 06/07/2014 11:56 PM, Steve Longerbeam wrote:
>>> Hi all,
>>>
>>> This patch set adds video capture support for the Freescale i.MX6 SOC.
>>>
>>> It is a from-scratch standardized driver that works with community
>>> v4l2 utilities, such as v4l2-ctl, v4l2-cap, and the v4l2src gstreamer
>>> plugin. It uses the latest v4l2 interfaces (subdev, videobuf2).
>>> Please see Documentation/video4linux/mx6_camera.txt for it's full list
>>> of features!
>>>
>>> The first 38 patches:
>>>
>>> - prepare the ipu-v3 driver for video capture support. The current driver
>>>   contains only video display functionality to support the imx DRM drivers.
>>>   At some point ipu-v3 should be moved out from under staging/imx-drm since
>>>   it will no longer only support DRM.
>>>
>>> - Adds the device tree nodes and OF graph bindings for video capture support
>>>   on sabrelite, sabresd, and sabreauto reference platforms.
>>>
>>> The new i.MX6 capture host interface driver is at patch 39.
>>>
>>> To support the sensors found on the sabrelite, sabresd, and sabreauto,
>>> three patches add sensor subdev's for parallel OV5642, MIPI CSI-2 OV5640,
>>> and the ADV7180 decoder chip, beginning at patch 40.
>>>
>>> There is an existing adv7180 subdev driver under drivers/media/i2c, but
>>> it needs some extra functionality to work on the sabreauto. It will need
>>> OF graph bindings support and gpio for a power-on pin on the sabreauto.
>>> It would also need to send a new subdev notification to take advantage
>>> of decoder status change handling provided by the host driver. This
>>> feature makes it possible to correctly handle "hot" (while streaming)
>>> signal lock/unlock and autodetected video standard changes.
>> A new V4L2_EVENT_SOURCE_CHANGE event has just been added for that.
> 
> Hello Hans!
> 
> Ok, V4L2_EVENT_SOURCE_CHANGE looks promising.
> 
> But v4l2-framework.txt states that v4l2 events are passed to userland. So I want to make sure this framework will also work internally; that is, the decoder subdev (adv7180) can generate this event
> and it can be subscribed by the capture host driver. That it can be passed to userland is fine and would be useful, it's not necessary in this case.

A subdevice can notify its parent device through v4l2_subdev_notify (see
v4l2-device.h). It would be nice if the event API and this notify mechanism
were unified or at least be more similar.

It's on my TODO list, but it is fairly far down that list.

Let me know if you are interested to improve this situation. I should be able
to give some pointers.

Regards,

	Hans

> 
>>
>>> Usage notes are found in Documentation/video4linux/mx6_camera.txt for the
>>> above three reference platforms.
>>>
>>> The driver source is under drivers/staging/media/imx6/capture/.
>> Thank you for this patch series! Much appreciated that this hardware is
>> finally going to supported with a proper driver.
>>
>> I did a quick scan of the driver and I noticed a few things that need
>> to be fixed: instead of implementing g/s_crop, implement g/s_selection:
>> new drivers should implement the selection API and they will get the crop
>> API for free.
> 
> Ok, I'll look into g/s_selection for v2 patches.
> 
>>
>> You should use the vb2 helper functions (vb2_fop_*, vb2_ioctl_*) unless
>> there is a good reason not to do it. Those functions should simplify the
>> code and they give you proper 'streaming ownership'. See also the example
>> code Documentation/video4linux/v4l2-pci-skeleton.c.
> 
> Ok, ditto.
> 
>>
>> Finally you should run the v4l2-compliance test tool and fix any failures.
>>
>> That tool is part of git://linuxtv.org/v4l-utils.git. Always compile from
>> that repository to be sure you use the latest code.
>>
>> Test first with 'v4l2-compliance'. When all issues are fixed, then test
>> with 'v4l2-compliance -s' to test actual streaming behavior as well.
>>
>> When you post v2 of this patch series I want to see the output of
>> 'v4l2-compliance -s'! New drivers should pass v4l2-compliance. However,
>> this is a staging driver so I won't be that strict, but it seems to be
>> the intention that this driver will become a mainline driver, so I would
>> recommend to fix any issues now rather than later.
> 
> Very cool, I'll make sure all v4l2-compliance issues are resolved. I can start that before issuing the v2 patches.
> 
> 
>>
>> If you have questions about v4l2-compliance it it might be easiest to
>> set up an irc session where we go through them. In that case mail me
>> so we can set up a time and date to do that. I'm in timezone UTC+2.
> 
> Thanks for the offer. Give me a few days to compose v2 patches and I'll start looking at v4l2-compliance.
> 
> Steve
> 

