Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49171 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbcDVIfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 04:35:09 -0400
Subject: Re: [RFC] Streaming I/O: proposal to expose MMAP/USERPTR/DMABUF
 capabilities with QUERYCAP
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
References: <5719DBE3.3040707@xs4all.nl>
 <CAH-u=82TugRcE1r=Rp=-YG9gVDV1i6bJixpZESBSqWPzhXZzsg@mail.gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5719E233.5090307@xs4all.nl>
Date: Fri, 22 Apr 2016 10:34:59 +0200
MIME-Version: 1.0
In-Reply-To: <CAH-u=82TugRcE1r=Rp=-YG9gVDV1i6bJixpZESBSqWPzhXZzsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/22/2016 10:23 AM, Jean-Michel Hautbois wrote:
> Hi Hans,
> 
> 2016-04-22 10:08 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> Hi all,
>>
>> I have always been unhappy with the fact that it is so hard to tell whether
>> the USERPTR and/or DMABUF modes are available with Streaming I/O. QUERYCAP
>> only tells you if Streaming I/O is available, but not in which flavors.
>>
>> So I propose the following:
>>
>> #define V4L2_CAP_STREAMING_MMAP V4L2_CAP_STREAMING
>> #define V4L2_CAP_STREAMING_USERPTR 0x08000000
>> #define V4L2_CAP_STREAMING_DMABUF  0x10000000
>>
>> All drivers that currently support CAP_STREAMING also support MMAP. For userptr
>> and dmabuf support we add new caps. These can be set by the core if the driver
>> uses vb2 since the core can query the io_modes field of vb2_queue.
> 
> So, you want to make it mandatory for future drivers that they support
> MMAP. Fine with me.
> BTW, dmabuf is still marked as experimental, what would make it part
> of the API for good ?

Just laziness on our part. I think I should go through the docs and update these
things. Most things marked experimental can probably drop that designation.

> 
>> For the drivers that do not yet support vb2 we can add it manually.
>>
>> I was considering making it a requirement that the MMAP streaming mode is
>> always present, but I don't know if that works once we get drivers that operate
>> on secure memory. So I won't do that for now.
> 
> By using "#define V4L2_CAP_STREAMING_MMAP V4L2_CAP_STREAMING" you make
> it mandatory... You would need a separate bit to indicate MMAP
> otherwise...

No: all *current* drivers marked CAP_STREAMING support MMAP. But future devices
that might not support MMAP would not set this cap.

So it is possible that in the future you'd get a driver that has just STREAMING_DMABUF
set. Which is something I can imagine for drivers operating on secure memory.

Regards,

	Hans

> 
>> Since we are looking at device caps anyway: can we just drop V4L2_CAP_ASYNCIO?
>> It's never been implemented, nor is it likely in the future. And we don't have
>> all that many bits left before we need to use one of the reserved fields for
>> additional capabilities.
>>
>> Regards,
>>
>>         Hans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

