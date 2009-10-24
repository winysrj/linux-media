Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:62585 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZJXV4l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 17:56:41 -0400
Message-ID: <4AE37808.6090107@maxwell.research.nokia.com>
Date: Sun, 25 Oct 2009 00:56:24 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] Video events, version 2.2
References: <4AE182DD.6060103@maxwell.research.nokia.com> <1256302779.10472.45.camel@iivanov.int.mm-sol.com>
In-Reply-To: <1256302779.10472.45.camel@iivanov.int.mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ivan T. Ivanov wrote:
> Hi Sakari, 

Hi,

> On Fri, 2009-10-23 at 13:18 +0300, Sakari Ailus wrote:
[clip]
>> struct v4l2_event {
>> 	__u32		count;
>> 	__u32		type;
>> 	__u32		sequence;
>> 	struct timeval	timestamp;
> 
> Can we use 'struct timespec' here. This will force actual 
> implementation to use high-resolution source if possible, 
> and remove hundreds gettimeofday() in user space, which 
> should be used for event synchronization, with more 
> power friendly clock_getres(CLOCK_MONOTONIC).

Good point. I originally picked timeval since it was used in 
v4l2_buffer. The spec tells to use gettimeofday() for system time but 
clock skewing is causes problems in video encoding. 
clock_getres(CLOCK_MONOTONIC) is free of clock skewing and thus should 
be more suitable for this kind of use.

I also propose to use timespec instead of timeval.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
