Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50138 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab2BEOYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 09:24:46 -0500
Received: by eekc14 with SMTP id c14so1851796eek.19
        for <linux-media@vger.kernel.org>; Sun, 05 Feb 2012 06:24:45 -0800 (PST)
Message-ID: <4F2E9129.10102@gmail.com>
Date: Sun, 05 Feb 2012 15:24:41 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: Re: [PATCH v2 04/31] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
 IOCTLs
References: <20120202235231.GC841@valkosipuli.localdomain> <1328226891-8968-4-git-send-email-sakari.ailus@iki.fi> <4F2D80C1.2050808@gmail.com> <4F2D9581.1040809@iki.fi> <4F2DB332.9020106@gmail.com> <20120205090414.GB7784@valkosipuli.localdomain>
In-Reply-To: <20120205090414.GB7784@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/05/2012 10:04 AM, Sakari Ailus wrote:
>>> I wanted to keep the target numbers the same since we're still using
>>> exactly the same as the V4L2.
>>
>> You're right, keeping the numbers same for subdevs and regular video
>> nodes may be important. I'm wondering whether we should use same
>> definitions for subdevs, rather than inventing new ones ? In case we
>> associate the selection targets with controls some target identifiers
>> must not actually be different. Whether the control belongs directly
>> to a video node control handler or is inherited from a sub-device the
>> selection target would have to be same. I'm referring here to an auto
>> focus rectangle selection target base for instance.
>> I guess including videodev2.h from v4l2-subdev.h is not an option, if
>> at all necessary ?
> 
> I think you're right; there would be advantages of using the same
> definitions. On the other hand, there may be subtle and not so subtle
> differences what these rectangles actually mean between the two interfaces.

Until now those analogous rectangles mean different things for subdevs and 
for video devnodes. It then doesn't matter that much what numbers identify
them, or even the numbers should be made distinct by design to make any 
attempts to use them interchangeably fail right away.

A little worrying is that with this approach we diverge from a situation
where a selection target id _do_ actually mean the same for the two 
interfaces.

Ideally I would see all the targets defined centrally with definitions that 
would be telling explicitly what is different and what is not for both
interfaces.

> The interface is quite similar to controls but the purpose it is used for is
> quite different: not many interdependencies are expected with controls
> whereas selections have many. The reason for this is we're using them to
> control various kinds of image processing functionality which might not be
> even similar on V4L2 subdev nodes and V4L2 nodes: the former is a superset
> of the latter.

I see your point. Maybe using selections with controls is a Bad Idea(tm) ? :)
However inventing a new ioctls for auto exposure/focus/wb seems a bit 
pointless..

> I'd like to have Laurent's opinion on this.

--

Regards,
Sylwester
