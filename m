Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17743 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab0BSTM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 14:12:28 -0500
Message-ID: <4B7EE25F.9050402@maxwell.research.nokia.com>
Date: Fri, 19 Feb 2010 21:11:27 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, iivanov@mm-sol.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com
Subject: Re: [PATCH v4 7/7] V4L: Events: Support all events
References: <4B72C965.7040204@maxwell.research.nokia.com>    <1265813889-17847-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>    <201002131542.20916.hverkuil@xs4all.nl>    <201002151111.09151.laurent.pinchart@ideasonboard.com> <732a3c26ed77df5896cb310597d1c79e.squirrel@webmail.xs4all.nl>
In-Reply-To: <732a3c26ed77df5896cb310597d1c79e.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>> Then don't call it v4l2_event_subscribe_all if it only subscribes to a set
>> of
>> event :-)
>>
>>> For each event this function would then call:
>>>
>>> fh->vdev->ioctl_ops->vidioc_subscribe_event(fh, sub);
>>>
>>> The nice thing about that is that in the driver you have a minimum of
>>> fuss.
>>>
>>> I'm leaning towards this second solution due to the simple driver
>>> implementation.
>>>
>>> Handling EVENT_ALL will simplify things substantially IMHO.
>>
>> I'm wondering if subscribing to all events should be allowed. Do we have
>> use
>> cases for that ? I'm always a bit cautious when adding APIs with no users,
>> as
>> that means the API has often not been properly tested against possible use
>> cases and mistakes will need to be supported forever (or at least for a
>> long
>> time).
> 
> I think that is a good point. Supporting V4L2_EVENT_ALL makes sense for
> unsubscribe, but does it makes sense for subscribe as well? I think it
> does not. It just doesn't feel right when I tried to implement it in ivtv.

I don't see any harm in supporting it there. We could also specify that
drivers may support that. At least for testing purposes that could be
quite useful. :-) Perhaps not for regular use, though.

> I also wonder whether the unsubscribe API shouldn't just receive the event
> type instead of the big subscription struct. Or get its own struct. I
> don't think it makes much sense that they both have the same struct.

So for unsubscribing the argument would be just event type as __u32?

I don't see harm in having the struct there. There might be flags in
future, perhaps telling that events of that type should be cleaned up
from the event queue, for example. (I can't think of any other purposes
now. :))

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
