Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3304 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab0KPHhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 02:37:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrew Chew <AChew@nvidia.com>
Subject: Re: Allocating videobuf_buffer, but lists not being initialized
Date: Tue, 16 Nov 2010 08:37:32 +0100
Cc: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <643E69AA4436674C8F39DCC2C05F763816BB828A36@HQMAIL03.nvidia.com> <643E69AA4436674C8F39DCC2C05F763816BB828A37@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763816BB828A37@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011160837.32797.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, November 16, 2010 02:10:39 Andrew Chew wrote:
> I'm looking at drivers/media/video/videobuf-dma-contig.c's __videobuf_alloc() routine.  We call kzalloc() to allocate the videobuf_buffer.  However, I don't see where the two lists (vb->stream and vb->queue) that are a part of struct videobuf_buffer get initialized (with, say, INIT_LIST_HEAD).

Yuck. The videobuf framework doesn't initialize vb-stream at all. It relies on
list_add_tail to effectively initialize it for it. It works, but it is not
exactly clean programming :-(

The vb->queue list has to be initialized in the driver. Never understood the
reason for that either.

Marek, can you make sure that videobuf2 will initialize these lists correctly?
That is, vb2 should do this initialization instead of the driver.

> This results in a warning in the V4L2 camera host driver that I'm developing when the buf_prepare method gets called.  I do a similar sanity check to the sh_mobile_ceu_camera driver (WARN_ON(!list->empty(&vb->queue));) in my buf_prepare method, and see the warning.  If I add INIT_LIST_HEAD to __videobuf_alloc(), this warning goes away.
> 
> Is this a known bug?

Well, videobuf is one big bug. We hope that we can merge the videobuf replacement
(called videobuf2, amazingly enough :-) ) for 2.6.38. Fingers crossed.

So you might want to wait until vb2 arrives, depending on your schedule.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
