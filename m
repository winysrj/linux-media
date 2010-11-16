Return-path: <mchehab@pedra>
Received: from [120.204.251.227] ([120.204.251.227]:37648 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759524Ab0KPIHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 03:07:48 -0500
Message-ID: <4CE239B4.7000503@leadcoretech.com>
Date: Tue, 16 Nov 2010 15:58:44 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Pawel Osciak <pawel@osciak.com>, Andrew Chew <AChew@nvidia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Allocating videobuf_buffer, but lists not being initialized
References: <643E69AA4436674C8F39DCC2C05F763816BB828A36@HQMAIL03.nvidia.com> <643E69AA4436674C8F39DCC2C05F763816BB828A37@HQMAIL03.nvidia.com> <AANLkTi=HFRJpLFOCszKDMfE-_CtsQUYNoGfd6ZgfVn6U@mail.gmail.com> <201011160840.24134.hverkuil@xs4all.nl>
In-Reply-To: <201011160840.24134.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

于 11/16/2010 03:40 PM, Hans Verkuil 写道:
> On Tuesday, November 16, 2010 06:29:53 Pawel Osciak wrote:
>> On Mon, Nov 15, 2010 at 17:10, Andrew Chew<AChew@nvidia.com>  wrote:
>>> I'm looking at drivers/media/video/videobuf-dma-contig.c's __videobuf_alloc() routine.  We call kzalloc() to allocate the videobuf_buffer.  However, I don't see where the two lists (vb->stream and vb->queue) that are a part of struct videobuf_buffer get initialized (with, say, INIT_LIST_HEAD).
>>>
>>
>> Those are not lists, but list entries. Those members of
>> videobuf_buffer struct are used to put the buffer on one of the
>> following lists: stream is a list entry for stream list in
>> videobuf_queue, queue is used as list entry for driver's buffer queue.
>
> So? They still should be initialized properly. It's bad form to leave
> invalid pointers there.

it just a list->entry, it has initialized by kzalloc at 
__videobuf_alloc_vb(),

>
> Regards,
>
> 	Hans
>

