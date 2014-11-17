Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:35641 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbaKQJqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 04:46:48 -0500
Message-ID: <5469C3F9.5000501@xs4all.nl>
Date: Mon, 17 Nov 2014 10:46:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 07/11] v4l2-ctrls: implement 'ignore after use' support.
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl> <1411310909-32825-8-git-send-email-hverkuil@xs4all.nl> <20141115211051.GI8907@valkosipuli.retiisi.org.uk> <5469B98B.9060304@xs4all.nl> <20141117093142.GM8907@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141117093142.GM8907@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/17/2014 10:31 AM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Nov 17, 2014 at 10:02:03AM +0100, Hans Verkuil wrote:
>> On 11/15/2014 10:10 PM, Sakari Ailus wrote:
>>>> @@ -197,6 +207,8 @@ struct v4l2_ctrl {
>>>>  	u32 nr_of_dims;
>>>>  	u16 nr_of_stores;
>>>>  	u16 store;
>>>> +	DECLARE_BITMAP(ignore_store, V4L2_CTRLS_MAX_STORES);
>>>> +	DECLARE_BITMAP(ignore_store_after_use, V4L2_CTRLS_MAX_STORES);
>>>
>>> I'd store this information next to the value itself. The reason is that
>>> stores are typically accessed one at a time, and thus keeping data related
>>> to a single store in a single contiguous location reduces cache misses.
>>
>> Hmm, sounds like overengineering to me. If I can do that without sacrificing
>> readability, then I can more it around. It's likely that these datastructures
>> will change anyway.
> 
> The controls are accessed very often in practice so this kind of things
> count. There's already a lot of code which gets executed in order to set a
> single control that's relevant only in some cases, such as clusters.

Complexity is the biggest problem in video drivers, not speed. Optimizations for
the sake of speeding up code at the expense of complexity should only be implemented
if you can *prove* that there is a measurable speedup.

Personally I would be very surprised if you can measure this in this specific
case.

Anyway, it doesn't matter in this case since I intend to rework those data
structures in any case.

Regards,

	Hans

> I think it'd probably be more readable as well if information related to a
> store was located in a single place. As a bonus you wouldn't need to set a
> global maximum for the number of stores one may have.

