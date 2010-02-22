Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:34874 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab0BVJmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 04:42:40 -0500
Message-ID: <4B82515E.3030106@maxwell.research.nokia.com>
Date: Mon, 22 Feb 2010 11:41:50 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, iivanov@mm-sol.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com
Subject: Re: [PATCH v5 5/6] V4L: Events: Support event handling in do_ioctl
References: <4B7EE4A4.3080202@maxwell.research.nokia.com>    <4B81B44F.7080201@maxwell.research.nokia.com>    <201002220853.53921.hverkuil@xs4all.nl>    <201002221010.21248.laurent.pinchart@ideasonboard.com> <3b2a22bbd1fd71331d3407c3653391b4.squirrel@webmail.xs4all.nl>
In-Reply-To: <3b2a22bbd1fd71331d3407c3653391b4.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>>>>> There is a crucial piece of functionality missing here: if the
>>>>> filehandle is in blocking mode, then it should wait until an event
>>>>> arrives. That also means that if vfh->events == NULL, you should
>>> still
>>>>> call v4l2_event_dequeue, and that function should initialize
>>>>> vfh->events and wait for an event if the fh is in blocking mode.
>>>>
>>>> I originally left this out intentionally. Most applications using
>>> events
>>>> would use select / poll as well by default. For completeness it should
>>>> be there, I agree.
>>>
>>> It has to be there. This is important functionality. For e.g. ivtv I
>>> would
>>> use this to wait until the MPEG decoder flushed all buffers and
>>> displayed
>>> the last frame of the stream. That's something you would often do in
>>> blocking mode.
>>
>> Blocking mode can easily be emulated using select().

It's quite simple to implement still so I'll do that in the
VIDIOC_DQEVENT. Easier for applications anyway in use cases that I
haven't been thinking about, e.g. ivtv.

>>>> This btw. suggests that we perhaps should put back the struct file
>>>> argument for the event functions in video_ioctl_ops. The blocking flag
>>>> is indeed part of the file structure. I'm open to better suggestions,
>>>> too.
>>>
>>> My long term goal is that the file struct is only used inside
>>> v4l2-ioctl.c
>>> and not in drivers. Drivers should not need this struct at all. The
>>> easiest
>>> way to ensure this is by not passing it to the drivers at all :-)
>>
>> Drivers still need a way to access the blocking flag. The interim solution
>> of
>> adding a file * member to v4l2_fh would allow that, while still removing
>> most
>> usage of file * from drivers.
> 
> Why not just add a 'blocking' argument to the v4l2_event_dequeue? And let
> v4l2-ioctl.c fill in that argument? That's how I would do it.

Implemented already before reading your mail... :-) I'll try to repost
the patches today.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
