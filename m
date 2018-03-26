Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:50919 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752447AbeCZPf1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 11:35:27 -0400
Subject: Re: [RFC v2 00/10] Preparing the request API
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: acourbot@chromium.org
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
 <bc453725-e35d-77d4-c92f-27c37e9b3b5d@xs4all.nl>
 <2c969629-d69c-49b6-4cfc-a00e8157b070@xs4all.nl>
Message-ID: <f11c24e1-599d-3248-008c-4730569cfa10@xs4all.nl>
Date: Mon, 26 Mar 2018 17:35:18 +0200
MIME-Version: 1.0
In-Reply-To: <2c969629-d69c-49b6-4cfc-a00e8157b070@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/25/2018 06:17 PM, Hans Verkuil wrote:
>> So this weekend I worked on a merger of this work and the RFCv4 Request API
>> patch series, taking what I think are the best bits of both.
>>
>> It is available here:
>>
>> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv6
> 
> I reorganized/cleaned up the patch series. So look here instead:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv7
> 
> It's easier to follow.

Status update:

Current work-in-progress tree:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv8

v4l2-compliance test code:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=request

I had hoped to have more tests ready, but there were loads of
get/put errors (not surprisingly) which took a lot of time to fix.

I also must remember for the next time that the list_add_tail prototype is:

void list_add_tail(struct list_head *new, struct list_head *head)

and not:

void list_add_tail(struct list_head *head, struct list_head *new)

Adding an object to a request worked much better than adding a request
to an object :-)

The v4l2-compliance tests I wrote test the basic creation/deletion
of requests, and adding controls to a request.

The main tests deal with all the various open/close combinations
(media fd, video fd, request fd). It's now working for both vim2m and
vivid.

I will try to start on buffers and queueing tests tomorrow, but it might
slip to Wednesday.

An interesting corner case was vim2m: what to do if you allocate a request,
add a control to it, then close the video file handle. Since the whole
state is contained in the video file handle, the control inside the request
is suddenly orphaned since the control refers to the control handler in the
file handle state, which is now deleted.

I have decided to remove the control from the request in that case. This means
that closing the video file handle for such devices removes all request objects
that are created by that file handle from any requests that they were bound to.

For vim2m it is effectively equal to calling MEDIA_REQUEST_IOC_REINIT for the
request.

I think this is a sane approach for such devices.

Regards,

	Hans
