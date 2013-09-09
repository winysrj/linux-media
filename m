Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4498 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3IIKHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 06:07:34 -0400
Message-ID: <522D9DD6.2080609@xs4all.nl>
Date: Mon, 09 Sep 2013 12:07:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Drop meaningless video_is_registered() call in v4l2_open()
References: <1375446449-27066-1-git-send-email-s.nawrocki@samsung.com> <522906CD.1000006@gmail.com> <522D8FDF.3030006@xs4all.nl> <5584569.Fq1hO5v8IF@avalon>
In-Reply-To: <5584569.Fq1hO5v8IF@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2013 12:00 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 09 September 2013 11:07:43 Hans Verkuil wrote:
>> On 09/06/2013 12:33 AM, Sylwester Nawrocki wrote:
>>> On 08/07/2013 07:49 PM, Hans Verkuil wrote:
>>>> On 08/07/2013 06:49 PM, Sylwester Nawrocki wrote:
>>>>> On 08/02/2013 03:00 PM, Hans Verkuil wrote:
>>>>>> On 08/02/2013 02:27 PM, Sylwester Nawrocki wrote:
> 
> [snip]
> 
>>> The main issue as I see it is that we need to track both driver remove()
>>> and struct device .release() calls and free resources only when last of
>>> them executes. Data structures which are referenced in fops must not be
>>> freed in remove() and we cannot use dev_get_drvdata() in fops, e.g. not
>>> protected with device_lock().
>>
>> You can do all that by returning 0 if probe() was partially successful (i.e.
>> one or more, but not all, nodes were created successfully) by doing what I
>> described above. I don't see another way that doesn't introduce a race
>> condition.
> 
> But isn't this just plain wrong ? If probing fails, I don't see how returning 
> success could be a good idea.

Well, the nodes that are created are working fine. So it's partially OK :-)

That said, yes it would be better if it could safely clean up and return an error.
But it is better than returning an error and introducing a race condition.

>> That doesn't mean that there isn't one, it's just that I don't know of a
>> better way of doing this.
> 
> We might need support from the device core.
> 

I do come back to my main question: has anyone actually experienced this error in a
realistic scenario? Other than in very low-memory situations I cannot imagine this
happening. I'm not sure whether you want to spend a lot of time trying to fix this
all perfectly. That's why I am suggesting just unregistering everything and returning
0 in probe(). Not ideal, but at least it's safe (as far as I can tell).

Regards,

	Hans
