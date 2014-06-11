Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:39313 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFKAym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jun 2014 20:54:42 -0400
Message-ID: <5397A8CD.6090302@mentor.com>
Date: Tue, 10 Jun 2014 17:54:37 -0700
From: Steve Longerbeam <steve_longerbeam@mentor.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: David Peverley <pev@audiogeek.co.uk>
Subject: Re: [PATCH 00/43] i.MX6 Video capture
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com> <53942098.9000109@xs4all.nl> <5395E407.7010100@mentor.com> <53972018.1020102@xs4all.nl>
In-Reply-To: <53972018.1020102@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2014 08:11 AM, Hans Verkuil wrote:
> On 06/09/2014 06:42 PM, Steve Longerbeam wrote:
>> On 06/08/2014 01:36 AM, Hans Verkuil wrote:
>>> Hi Steve!
>>>
>>> On 06/07/2014 11:56 PM, Steve Longerbeam wrote:
>>>> Hi all,
>>>>
>>>> This patch set adds video capture support for the Freescale i.MX6 SOC.
>>>>
>>>> It is a from-scratch standardized driver that works with community
>>>> v4l2 utilities, such as v4l2-ctl, v4l2-cap, and the v4l2src gstreamer
>>>> plugin. It uses the latest v4l2 interfaces (subdev, videobuf2).
>>>> Please see Documentation/video4linux/mx6_camera.txt for it's full list
>>>> of features!
>>>>
>>>> The first 38 patches:
>>>>
>>>> - prepare the ipu-v3 driver for video capture support. The current driver
>>>>   contains only video display functionality to support the imx DRM drivers.
>>>>   At some point ipu-v3 should be moved out from under staging/imx-drm since
>>>>   it will no longer only support DRM.
>>>>
>>>> - Adds the device tree nodes and OF graph bindings for video capture support
>>>>   on sabrelite, sabresd, and sabreauto reference platforms.
>>>>
>>>> The new i.MX6 capture host interface driver is at patch 39.
>>>>
>>>> To support the sensors found on the sabrelite, sabresd, and sabreauto,
>>>> three patches add sensor subdev's for parallel OV5642, MIPI CSI-2 OV5640,
>>>> and the ADV7180 decoder chip, beginning at patch 40.
>>>>
>>>> There is an existing adv7180 subdev driver under drivers/media/i2c, but
>>>> it needs some extra functionality to work on the sabreauto. It will need
>>>> OF graph bindings support and gpio for a power-on pin on the sabreauto.
>>>> It would also need to send a new subdev notification to take advantage
>>>> of decoder status change handling provided by the host driver. This
>>>> feature makes it possible to correctly handle "hot" (while streaming)
>>>> signal lock/unlock and autodetected video standard changes.
>>> A new V4L2_EVENT_SOURCE_CHANGE event has just been added for that.
>>
>> Hello Hans!
>>
>> Ok, V4L2_EVENT_SOURCE_CHANGE looks promising.
>>
>> But v4l2-framework.txt states that v4l2 events are passed to userland. So
>> I want to make sure this framework will also work internally; that is,
>> the decoder subdev (adv7180) can generate this event and it can be
>> subscribed by the capture host driver. That it can be passed to userland
>> is fine and would be useful, it's not necessary in this case.
> 
> A subdevice can notify its parent device through v4l2_subdev_notify (see
> v4l2-device.h). It would be nice if the event API and this notify mechanism
> were unified or at least be more similar.
> 
> It's on my TODO list, but it is fairly far down that list.
> 
> Let me know if you are interested to improve this situation. I should be able
> to give some pointers.
> 
>

Hi Hans,

It doesn't look possible for subdev's to queue events, since events require
a v4l2 fh context, so it looks like subdev notifications should stick
around.

But perhaps subdev notification can be modified to send a struct v4l2_event,
rather than a u32 notification value. Then at least notify and events can
share event types instead of duplicating them (such as what I caused by
introducing this similar decoder status change notification).

Something like:

/* Send an event to v4l2_device. */
static inline void v4l2_subdev_notify(struct v4l2_subdev *sd,
       	      	   		      struct v4l2_event *ev,
				      void *arg)
{
        if (sd && sd->v4l2_dev && sd->v4l2_dev->notify)
                sd->v4l2_dev->notify(sd, ev, arg);
}


Then the parent is free to consume this event internally, and/or queue it
off to userland via v4l2_event_queue().

Notification values could then completely disappear, replaced with new (or
existing) event types.

Is that what you had in mind, or something completely different?

Steve
