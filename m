Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab2FVOvU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 10:51:20 -0400
Message-ID: <4FE48661.9070307@redhat.com>
Date: Fri, 22 Jun 2012 11:51:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org,
	Federico Vaga <federico.vaga@gmail.com>
Subject: Re: Recent patch for videobuf causing a crash to my driver
References: <CA+V-a8uDgmiy52wEs0rR5B08aAmSk=Wyf+e3mMzazeGykdMA4w@mail.gmail.com> <4FE423D4.9010609@xs4all.nl> <2147318.3kAzv4eQOG@avalon>
In-Reply-To: <2147318.3kAzv4eQOG@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-06-2012 05:50, Laurent Pinchart escreveu:
> Hi Hans,
> 
> On Friday 22 June 2012 09:50:44 Hans Verkuil wrote:
>> On 22/06/12 05:39, Prabhakar Lad wrote:
>>> Hi Federico,
>>>
>>> Recent patch from you (commit id a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4)
>>> which added cached buffer support to videobuf dma contig, is causing my
>>> driver to crash.
>>> Has this patch being tested for 'uncached' buffers ? If I replace this
>>> mapping logic with remap_pfn_range() my driver works without any crash.
>>>
>>> Or is that I am missing somewhere ?
>>
>> No, I had the same problem this week with vpif_capture. Since I was running
>> an unusual setup (a 3.0 kernel with the media subsystem patched to 3.5-rc1)
>> I didn't know whether it was caused by a mismatch between 3.0 and a 3.5
>> media subsystem.
>>
>> I intended to investigate this next week, but now it is clear that it is
>> this patch that is causing the problem.
> 
> Time to port the driver to videobuf2 ? ;-)

The regression needs to be fixed anyway, and send to stable. A patch that converts
it to VB2 won't met stable requirements.

Regards,
Mauro


