Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:36199 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0BVHhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 02:37:14 -0500
Message-ID: <4B82341C.2050301@maxwell.research.nokia.com>
Date: Mon, 22 Feb 2010 09:37:00 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
Subject: Re: [PATCH v5 5/6] V4L: Events: Support event handling in do_ioctl
References: <4B7EE4A4.3080202@maxwell.research.nokia.com> <201002201056.56952.hverkuil@xs4all.nl> <4B81B44F.7080201@maxwell.research.nokia.com> <201002212354.51792.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201002212354.51792.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,

Salut Laurent,

>>> There is a crucial piece of functionality missing here: if the filehandle
>>> is in blocking mode, then it should wait until an event arrives. That
>>> also means that if vfh->events == NULL, you should still call
>>> v4l2_event_dequeue, and that function should initialize vfh->events and
>>> wait for an event if the fh is in blocking mode.
>>
>> I originally left this out intentionally. Most applications using events
>> would use select / poll as well by default. For completeness it should
>> be there, I agree.
>>
>> This btw. suggests that we perhaps should put back the struct file
>> argument for the event functions in video_ioctl_ops. The blocking flag
>> is indeed part of the file structure. I'm open to better suggestions, too.
> 
> If the only information we need from struct file is the flags, they could be 
> copied to v4l2_fh in the open handler. We could also put a struct file * 
> member in v4l2_fh.

That could be one possibility. Copying the flags in open() isn't enough
as they can change as a result of fcntl call. As we're not handling that
call the flags in struct v4l2_fh would have to be updated for every
ioctl. I'm not a big fan of caching information in general either. :-) I
could accept this, though.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
