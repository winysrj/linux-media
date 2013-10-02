Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30733 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3JBUPt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 16:15:49 -0400
Message-ID: <524C8093.909@linux.intel.com>
Date: Wed, 02 Oct 2013 23:22:43 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 0/4]
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <13152311.59C5UI1BDX@avalon>
In-Reply-To: <13152311.59C5UI1BDX@avalon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Wednesday 02 October 2013 16:45:12 Sakari Ailus wrote:
>> Hi all,
>>
>> This is the second RFC set after the initial patch that makes poll return
>> POLLERR if no events are subscribed. There are other issues as well which
>> these patches address.
>>
>> The original RFC patch is here:
>>
>> <URL:http://www.spinics.net/lists/linux-media/msg68077.html>
>>
>> poll(2) and select(2) can both be used for I/O multiplexing. While both
>> provide slightly different semantics. man 2 select:
>>
>>         select() and  pselect()  allow  a  program  to  monitor  multiple
>> file descriptors,  waiting  until one or more of the file descriptors
>> become "ready" for some class of I/O operation (e.g., input possible).  A
>> file descriptor  is considered ready if it is possible to perform the
>> corre‐ sponding I/O operation (e.g., read(2)) without blocking.
>>
>> The two system calls provide slightly different semantics: poll(2) can
>> signal POLLERR related to a file handle but select(2) does not: instead, on
>> POLLERR it sets a bit corresponding to a file handle in the read and write
>> sets. This is somewhat confusing since with the original patch --- using
>> select(2) would suggest that there's something to read or write instead of
>> knowing no further exceptions are coming.
>>
>> Thus, also denying polling a subdev file handle using select(2) will mean
>> the POLLERR never gets through in any form.
>>
>> So the meaningful alternatives I can think of are:
>>
>> 1) Use POLLERR | POLLPRI. When the last event subscription is gone and
>> select(2) IOCTL is issued, all file descriptor sets are set for a file
>> handle. Users of poll(2) will directly see both of the flags, making the
>> case visible to the user immediately in some cases. On sub-devices this is
>> obvious but on V4L2 devices the user should poll(2) (or select(2)) again to
>> know whether there's I/O waiting to be read, written or whether buffers are
>> ready.
>>
>> 2) Use POLLPRI only. While this does not differ from any regular event at
>> the level of poll(2) or select(2), the POLLIN or POLLOUT flags are not
>> adversely affected.
>>
>> In each of the cases to ascertain oneself in a generic way of whether events
>> cannot no longer be obtained one has to call VIDIOC_DQEVENT IOCTL, which
>> currently may block. A patch in the set makes VIDIOC_DQEVENT to signal EIO
>> error code if no events are subscribed.
>>
>> The videobuf2 changes are untested at the moment since I didn't have a
>> device using videobuf2 at hand right now.
>>
>> Comments and questions are very welcome.
>
> What's the behaviour of select(2) and poll(2) after this patch set when
> polling an fd for both read and events, when no event has been subscribed to ?

The first one. If you're using select(2), you'll get the fd-specific bit 
set in all three sets. For poll(2), you'll get POLLERR and POLLPRI set 
for the fd.

No poll nor select can directly tell that there are no further events; 
instead they intend to say that the corresponding operations on the file 
descriptor wouldn't block. Events are a little funny in this respect; 
the difference of behaviour must be documented in select(2) V4L2 
documentation which currently is missing entirely (I'll send a patch).

An alternative would be indeed use POLLPRI only. The only way the user 
would know there are no further events coming would be to use 
VIDIOC_DQEVENT then. As a matter of fact, this way the behaviour of 
select(2) would better conform to what the POSIX standard specifies but 
OTOH would not allow to tell about the situation using poll(2) only in 
any case since it'd look like the same as any event. But I don't think 
it'd be a problem either.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
