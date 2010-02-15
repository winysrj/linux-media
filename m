Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2279 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0BOKg5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 05:36:57 -0500
Message-ID: <732a3c26ed77df5896cb310597d1c79e.squirrel@webmail.xs4all.nl>
In-Reply-To: <201002151111.09151.laurent.pinchart@ideasonboard.com>
References: <4B72C965.7040204@maxwell.research.nokia.com>
    <1265813889-17847-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>
    <201002131542.20916.hverkuil@xs4all.nl>
    <201002151111.09151.laurent.pinchart@ideasonboard.com>
Date: Mon, 15 Feb 2010 11:36:26 +0100
Subject: Re: [PATCH v4 7/7] V4L: Events: Support all events
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org, iivanov@mm-sol.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans,
>
> On Saturday 13 February 2010 15:42:20 Hans Verkuil wrote:
>> On Wednesday 10 February 2010 15:58:09 Sakari Ailus wrote:
>> > Add support for subscribing all events with a special id
>> V4L2_EVENT_ALL.
>> > If V4L2_EVENT_ALL is subscribed, no other events may be subscribed.
>> > Otherwise V4L2_EVENT_ALL is considered just as any other event.
>>
>> We should do this differently. I think that EVENT_ALL should not be used
>> internally (i.e. in the actual list of subscribed events), but just as a
>> special value for the subscribe and unsubscribe ioctls. So when used
>> with
>> unsubscribe you can just unsubscribe all subscribed events and when used
>> with subscribe, then you just subscribe all valid events (valid for that
>> device node).
>>
>> So in v4l2-event.c you will have a v4l2_event_unsubscribe_all() to
>> quickly
>> unsubscribe all events.
>>
>> In order to easily add all events from the driver it would help if the
>> v4l2_event_subscribe and v4l2_event_unsubscribe just take the event type
>> as argument rather than the whole v4l2_event_subscription struct.
>>
>> You will then get something like this in the driver:
>>
>> 	if (sub->type == V4L2_EVENT_ALL) {
>> 		int ret = v4l2_event_alloc(fh, 60);
>>
>> 		ret = ret ? ret : v4l2_event_subscribe(fh, V4L2_EVENT_EOS);
>> 		ret = ret ? ret : v4l2_event_subscribe(fh, V4L2_EVENT_VSYNC);
>> 		return ret;
>> 	}
>>
>> An alternative might be to add a v4l2_event_subscribe_all(fh, const u32
>> *events) where 'events' is a 0 terminated list of events that need to be
>> subscribed.
>
> Then don't call it v4l2_event_subscribe_all if it only subscribes to a set
> of
> event :-)
>
>> For each event this function would then call:
>>
>> fh->vdev->ioctl_ops->vidioc_subscribe_event(fh, sub);
>>
>> The nice thing about that is that in the driver you have a minimum of
>> fuss.
>>
>> I'm leaning towards this second solution due to the simple driver
>> implementation.
>>
>> Handling EVENT_ALL will simplify things substantially IMHO.
>
> I'm wondering if subscribing to all events should be allowed. Do we have
> use
> cases for that ? I'm always a bit cautious when adding APIs with no users,
> as
> that means the API has often not been properly tested against possible use
> cases and mistakes will need to be supported forever (or at least for a
> long
> time).

I think that is a good point. Supporting V4L2_EVENT_ALL makes sense for
unsubscribe, but does it makes sense for subscribe as well? I think it
does not. It just doesn't feel right when I tried to implement it in ivtv.

I also wonder whether the unsubscribe API shouldn't just receive the event
type instead of the big subscription struct. Or get its own struct. I
don't think it makes much sense that they both have the same struct.

Regards,

       Hans

>
> --
> Regards,
>
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

