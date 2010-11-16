Return-path: <mchehab@pedra>
Received: from [120.204.251.227] ([120.204.251.227]:37648 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759494Ab0KPIHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 03:07:46 -0500
Message-ID: <4CE23A42.1090101@leadcoretech.com>
Date: Tue, 16 Nov 2010 16:01:06 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andrew Chew <AChew@nvidia.com>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Allocating videobuf_buffer, but lists not being initialized
References: <643E69AA4436674C8F39DCC2C05F763816BB828A36@HQMAIL03.nvidia.com> <643E69AA4436674C8F39DCC2C05F763816BB828A37@HQMAIL03.nvidia.com> <201011160837.32797.hverkuil@xs4all.nl>
In-Reply-To: <201011160837.32797.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

于 11/16/2010 03:37 PM, Hans Verkuil 写道:
> On Tuesday, November 16, 2010 02:10:39 Andrew Chew wrote:
>> I'm looking at drivers/media/video/videobuf-dma-contig.c's __videobuf_alloc() routine.  We call kzalloc() to allocate the videobuf_buffer.  However, I don't see where the two lists (vb->stream and vb->queue) that are a part of struct videobuf_buffer get initialized (with, say, INIT_LIST_HEAD).
>
> Yuck. The videobuf framework doesn't initialize vb-stream at all. It relies on
> list_add_tail to effectively initialize it for it. It works, but it is not
> exactly clean programming :-(
>
> The vb->queue list has to be initialized in the driver. Never understood the
> reason for that either.
>
> Marek, can you make sure that videobuf2 will initialize these lists correctly?
> That is, vb2 should do this initialization instead of the driver.

vb2 have init the list :
	INIT_LIST_HEAD(&q->queued_list);
	INIT_LIST_HEAD(&q->done_list);

btw, "queued_list" re-name "grabbing_list" is better?




