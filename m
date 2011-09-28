Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43915 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1I1J7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 05:59:35 -0400
Message-ID: <4E82F002.4040401@infradead.org>
Date: Wed, 28 Sep 2011 06:59:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Ravi, Deepthy" <deepthy.ravi@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
References: <1315488922-16152-1-git-send-email-deepthy.ravi@ti.com> <19F8576C6E063C45BE387C64729E739404EC8113E2@dbde02.ent.ti.com> <4E824EC4.20305@infradead.org> <201109280041.29952.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109280041.29952.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-09-2011 19:41, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Wednesday 28 September 2011 00:31:32 Mauro Carvalho Chehab wrote:
>> Em 19-09-2011 12:31, Hiremath, Vaibhav escreveu:
>>> On Friday, September 16, 2011 6:36 PM Laurent Pinchart wrote: > >> On 
> Friday 16 September 2011 15:00:53 Ravi, Deepthy wrote:
>>>>> On Thursday, September 08, 2011 10:51 PM Laurent Pinchart wrote:
>>>>>> On Thursday 08 September 2011 15:35:22 Deepthy Ravi wrote:
>>>>>>> From: Vaibhav Hiremath <hvaibhav@ti.com>
>>>>>>>
>>>>>>> In order to support TVP5146 (for that matter any video decoder),
>>>>>>> it is important to support G/S/ENUM_STD ioctl on /dev/videoX
>>>>>>> device node.
>>>>>>
>>>>>> Why so ? Shouldn't it be queried on the subdev output pad directly ?
>>>>>
>>>>> Because standard v4l2 application for analog devices will call these
>>>>> std ioctls on the streaming device node. So it's done on /dev/video to
>>>>> make the existing apllication work.
>>>>
>>>> Existing applications can't work with the OMAP3 ISP (and similar complex
>>>> embedded devices) without userspace support anyway, either in the form
>>>> of a GStreamer element or a libv4l plugin. I still believe that analog
>>>> video standard operations should be added to the subdev pad operations
>>>> and exposed through subdev device nodes, exactly as done with formats.
>>>
>>> I completely agree with your point that, existing application will not
>>> work without setting links properly. But I believe the assumption here
>>> is, media-controller should set the links (along with pad formants) and
>>> all existing application should work as is. Isn't it?
>>
>> Yes.
>>
>>> The way it is being done currently is, set the format at the pad level
>>> which is same as analog standard resolution and use existing application
>>> for streaming...
>>
>> Yes.
>>
>>> I am ok, if we add s/g/enum_std api support at sub-dev level but this
>>> should also be supported on streaming device node.
>>
>> Agreed. Standards selection should be done at device node, just like any
>> other device.
> 
> No. Please see my reply to Vaibhav's e-mail. Standard selection should be done 
> on the subdev pads, for the exact same reason why formats and selection 
> rectangles are configured on subdev pads.

NACK. Let's not reinvent the wheel. the MC should not replace the V4L2 API.

Mauro.
