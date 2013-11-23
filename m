Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2047 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3KWQzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Nov 2013 11:55:18 -0500
Message-ID: <5290DDD8.7070305@xs4all.nl>
Date: Sat, 23 Nov 2013 17:54:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Wade Farnsworth <wade_farnsworth@mentor.com>,
	linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] v4l2-dev: Add tracepoints for QBUF and DQBUF
References: <52614DB9.8090908@mentor.com> <528FB50C.6060909@mentor.com> <529090A9.7030505@xs4all.nl> <5290D826.5080308@gmail.com>
In-Reply-To: <5290D826.5080308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/23/2013 05:30 PM, Sylwester Nawrocki wrote:
> Hi,
> 
> On 11/23/2013 12:25 PM, Hans Verkuil wrote:
>> Hi Wade,
>>
>> On 11/22/2013 08:48 PM, Wade Farnsworth wrote:
>>> Add tracepoints to the QBUF and DQBUF ioctls to enable rudimentary
>>> performance measurements using standard kernel tracers.
>>>
>>> Signed-off-by: Wade Farnsworth<wade_farnsworth@mentor.com>
>>> ---
>>>
>>> This is the update to the RFC patch I posted a few weeks back.  I've added
>>> several bits of metadata to the tracepoint output per Mauro's suggestion.
>>
>> I don't like this. All v4l2 ioctls can already be traced by doing e.g.
>> echo 1 (or echo 2)>/sys/class/video4linux/video0/debug.
>>
>> So this code basically duplicates that functionality. It would be nice to be able
>> to tie in the existing tracing code (v4l2-ioctl.c) into tracepoints.
> 
> I think it would be really nice to have this kind of support for standard
> traces at the v4l2 subsystem. Presumably it could even gradually replace
> the v4l2 custom debug infrastructure.
> 
> If I understand things correctly, the current tracing/profiling 
> infrastructure
> is much less invasive than inserting printks all over, which may cause 
> changes
> in control flow. I doubt the system could be reliably profiled by 
> enabling all
> those debug prints.
> 
> So my vote would be to add support for standard tracers, like in other
> subsystems in the kernel.

The reason for the current system is to trace which ioctls are called in
what order by a misbehaving application. It's very useful for that,
especially when trying to debug user problems.

I don't mind switching to tracepoints as long as this functionality is
kept one way or another.

Regards,

	Hans
