Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41633 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab2KVVoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 16:44:25 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3105218eek.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 13:44:24 -0800 (PST)
Message-ID: <50AE9CB6.8020100@gmail.com>
Date: Thu, 22 Nov 2012 22:44:22 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, shaik.samsung@gmail.com,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH] [media] exynos-gsc: propagate timestamps from src to
 dst buffers
References: <1352270424-14683-1-git-send-email-shaik.ameer@samsung.com> <50AAAD6A.80709@gmail.com> <20121121193948.GB30360@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121121193948.GB30360@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 11/21/2012 08:39 PM, Sakari Ailus wrote:
> Hi Sylwester and Shaik,
>
> On Mon, Nov 19, 2012 at 11:06:34PM +0100, Sylwester Nawrocki wrote:
>> On 11/07/2012 07:40 AM, Shaik Ameer Basha wrote:
>>> Make gsc-m2m propagate the timestamp field from source to destination
>>> buffers
>>
>> We probably need some means for letting know the mem-to-mem drivers and
>> applications whether timestamps are copied from OUTPUT to CAPTURE or not.
>> Timestamps at only OUTPUT interface are normally used to control buffer
>> processing time [1].
>>
>>
>> "struct timeval	timestamp	 	
>>
>> For input streams this is the system time (as returned by the
>> gettimeofday()
>> function) when the first data byte was captured. For output streams
>
> Thanks for notifying me; this is going to be dependent on the timestamp
> type.
>
> Also most drivers use the time the buffer is finished rather than when the
> "first data byte was captured", but that's separate I think.

Yes, that's an another ambiguity that might need to be resolved.

>> the data
>> will not be displayed before this time, secondary to the nominal frame rate
>> determined by the current video standard in enqueued order.
>> Applications can
>> for example zero this field to display frames as soon as possible.
>> The driver
>> stores the time at which the first data byte was actually sent out in the
>> timestamp field. This permits applications to monitor the drift between the
>> video and system clock."
>>
>> In some use cases it might be useful to know exact frame processing time,
>> where driver would be filling OUTPUT and CAPTURE value with exact monotonic
>> clock values corresponding to a frame processing start and end time.
>
> Shouldn't this always be done in memory-to-memory processing? I could
> imagine only performance measurements can benefit from other kind of
> timestamps.
>
> We could use different timestamp type to tell the timestamp source isn't any
> system clock but an input buffer.
>
> What do you think?

Yes, it makes sense to me to report with the buffer flag that the source of
timestamp is just an OUTPUT buffer. At least this would solve the reporting
part of the issue. Oh wait, could applications tell by setting buffer flag
what timestamping behaviour they expect from a driver ?

I can't see an important use of timestamping m2m buffers at device drivers.
Performance measurement can probably be done in user space with sufficient
accuracy as well. However, it wouldn't be difficult for drivers to 
implement
multiple time stamping techniques, e.g. OUTPUT -> CAPTURE timestamp copying
or getting timestamps from monotonic clock at frame processing beginning and
end for OUTPUT and CAPTURE respectively.

I believe the buffer flags might be a good solution.

--
Regards,
Sylwester
