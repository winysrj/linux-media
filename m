Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:59059 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbZKMRod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 12:44:33 -0500
Message-ID: <4AFD9AE9.3090007@maxwell.research.nokia.com>
Date: Fri, 13 Nov 2009 19:44:09 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	"Kost Stefan (Nokia-M/Helsinki)" <Stefan.Kost@nokia.com>
Subject: Re: [RFC] Video events, version 2.2
References: <4AE182DD.6060103@maxwell.research.nokia.com>	<200911110819.59521.hverkuil@xs4all.nl>	<4AFAF490.6090507@maxwell.research.nokia.com>	<200911111859.09500.hverkuil@xs4all.nl> <20091113132947.0d307bfd@pedra.chehab.org>
In-Reply-To: <20091113132947.0d307bfd@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
[clip]
>>>> Hi Sakari,
>>>>
>>>> What is that status of the event API? It is my impression that it is pretty
>>>> much finished. Sakari, can you make a final 2.3 RFC? Then Guru can take over
>>>> and start the implementation.
>>> Ah.
>>>
>>> One thing that I was still wondering was that are there use cases where 
>>> other kind of time stamps might be useful? I guess that when the V4L2 
>>> was designed no-one though of the need for time stamps of different 
>>> type. So are there use cases where gettimeofday() style stamps would 
>>> still be better?
>> If you ever need to relate an event to a specific captured frame, then that
>> might well be useful. But I can't think of an actual use case, though.
>>
>>> In that case we might choose to leave it driver's decision to decide 
>>> what kind of timestamps to use and in that case application would just 
>>> have to know. The alternative would be to use union and a flag telling 
>>> what's in there.
>>>
>> Let's go with timespec. If we need to add an event that has to relate to
>> a specific captured frame then it is always possible to add a struct timeval
>> as part of the event data for that particular event.
> 
> I don't agree. It is better to use the same timestamp type used by the streaming
> interface. Having two different ways to represent it for the same devices is
> confusing, and changing it later doesn't make sense. I foresee some cases where
> correlating the two timestamps would be a need.

timespec style timestamps are superior in video encoding, for example. 
timeval is wall clock time which is unsuitable for video encoding due to 
clock slewing and daylight saving time.

ALSA and Gstreamer use monotonic clock (someone correct me if I'm 
wrong!, cc Stefan Kost) which is more usable for multimedia 
applications. The rate for gettimeofday() clock is different than 
clock_getres(CLOCK_MONOTONIC) which in practice means that the process 
acquiring the video buffers must call clock_getres() after VIDIOC_DQBUF 
to properly timestamp the buffers. This kind of timestamping, however, 
depends on the process' ability to run immediately.

I wouldn't want to carry this kind of problems on to the event interface.

One possibility would be also to create events when new video buffers 
become available. Then both the event and the corresponding video buffer 
would be available, having the same field_count. Perhaps not pretty but 
would well make it possible to compare the timestamps.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
