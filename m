Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1JCTGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 15:06:23 -0400
Message-ID: <4E8A07A6.3030600@infradead.org>
Date: Mon, 03 Oct 2011 16:06:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework
 and add video format detection
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <4E891B22.1020204@infradead.org> <201110030830.25364.hverkuil@xs4all.nl> <201110031039.27849.laurent.pinchart@ideasonboard.com> <CAAwP0s0bTcUPvkVT-aB2EKskS_60CdW4P3orQLvSJMMkEWBpqw@mail.gmail.com>
In-Reply-To: <CAAwP0s0bTcUPvkVT-aB2EKskS_60CdW4P3orQLvSJMMkEWBpqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-10-2011 06:53, Javier Martinez Canillas escreveu:
> On Mon, Oct 3, 2011 at 10:39 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Hans,
>>
>> On Monday 03 October 2011 08:30:25 Hans Verkuil wrote:
>>> On Monday, October 03, 2011 04:17:06 Mauro Carvalho Chehab wrote:
>>>> Em 02-10-2011 18:18, Javier Martinez Canillas escreveu:
>>>>> On Sun, Oct 2, 2011 at 6:30 PM, Sakari Ailus wrote:
>>
>> [snip]
>>
>>>>>>>  static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
>>>>>>>
>>>>>>>       .s_routing = tvp5150_s_routing,
>>>>>>>
>>>>>>> +     .s_stream = tvp515x_s_stream,
>>>>>>> +     .enum_mbus_fmt = tvp515x_enum_mbus_fmt,
>>>>>>> +     .g_mbus_fmt = tvp515x_mbus_fmt,
>>>>>>> +     .try_mbus_fmt = tvp515x_mbus_fmt,
>>>>>>> +     .s_mbus_fmt = tvp515x_mbus_fmt,
>>>>>>> +     .g_parm = tvp515x_g_parm,
>>>>>>> +     .s_parm = tvp515x_s_parm,
>>>>>>> +     .s_std_output = tvp5150_s_std,
>>>>>>
>>>>>> Do we really need both video and pad format ops?
>>>>>
>>>>> Good question, I don't know. Can this device be used as a standalone
>>>>> v4l2 device? Or is supposed to always be a part of a video streaming
>>>>> pipeline as a sub-device with a source pad? Sorry if my questions are
>>>>> silly but as I stated before, I'm a newbie with v4l2 and MCF.
>>>>
>>>> The tvp5150 driver is used on some em28xx devices. It is nice to add
>>>> auto-detection code to the driver, but converting it to the media bus
>>>> should be done with enough care to not break support for the existing
>>>> devices.
>>>
>>> So in other words, the tvp5150 driver needs both pad and non-pad ops.
>>> Eventually all non-pad variants in subdev drivers should be replaced by the
>>> pad variants so you don't have duplication of ops. But that will take a lot
>>> more work.
>>
>> What about replacing direct calls to non-pad operations with core V4L2
>> functions that would use the subdev non-pad operation if available, and
>> emulate if with the pad operation otherwise ? I think this would ease the
>> transition, as subdev drivers could be ported to pad operations without
>> worrying about the bridges that use them, and bridge drivers could be switched
>> to the new wrappers with a simple search and replace.
> 
> Ok, that is a good solution. I'll do that. Implement V4L2 core
> operations as wrappers of the subdev pad operations.

As I said, I can't see _any_ reason why setting a format would be needed
at pad level. Patches shouldn't increase driver/core and userspace complexity
for nothing.

Regards,
Mauro
