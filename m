Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50514 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbZKKRaa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 12:30:30 -0500
Message-ID: <4AFAF490.6090507@maxwell.research.nokia.com>
Date: Wed, 11 Nov 2009 19:29:52 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] Video events, version 2.2
References: <4AE182DD.6060103@maxwell.research.nokia.com> <1256302779.10472.45.camel@iivanov.int.mm-sol.com> <4AE37808.6090107@maxwell.research.nokia.com> <200911110819.59521.hverkuil@xs4all.nl>
In-Reply-To: <200911110819.59521.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Saturday 24 October 2009 23:56:24 Sakari Ailus wrote:
>> Ivan T. Ivanov wrote:
>>> Hi Sakari, 
>> Hi,
>>
>>> On Fri, 2009-10-23 at 13:18 +0300, Sakari Ailus wrote:
>> [clip]
>>>> struct v4l2_event {
>>>> 	__u32		count;
>>>> 	__u32		type;
>>>> 	__u32		sequence;
>>>> 	struct timeval	timestamp;
>>> Can we use 'struct timespec' here. This will force actual 
>>> implementation to use high-resolution source if possible, 
>>> and remove hundreds gettimeofday() in user space, which 
>>> should be used for event synchronization, with more 
>>> power friendly clock_getres(CLOCK_MONOTONIC).
>> Good point. I originally picked timeval since it was used in 
>> v4l2_buffer. The spec tells to use gettimeofday() for system time but 
>> clock skewing is causes problems in video encoding. 
>> clock_getres(CLOCK_MONOTONIC) is free of clock skewing and thus should 
>> be more suitable for this kind of use.
>>
>> I also propose to use timespec instead of timeval.
>>
> 
> Hi Sakari,
> 
> What is that status of the event API? It is my impression that it is pretty
> much finished. Sakari, can you make a final 2.3 RFC? Then Guru can take over
> and start the implementation.

Ah.

One thing that I was still wondering was that are there use cases where 
other kind of time stamps might be useful? I guess that when the V4L2 
was designed no-one though of the need for time stamps of different 
type. So are there use cases where gettimeofday() style stamps would 
still be better?

In that case we might choose to leave it driver's decision to decide 
what kind of timestamps to use and in that case application would just 
have to know. The alternative would be to use union and a flag telling 
what's in there.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
