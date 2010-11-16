Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:36746 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab0KPKKR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 05:10:17 -0500
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LBZ00ELP2X408A0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Nov 2010 19:10:16 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LBZ00EXU2X0CF@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Nov 2010 19:10:16 +0900 (KST)
Date: Tue, 16 Nov 2010 11:10:11 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Allocating videobuf_buffer, but lists not being initialized
In-reply-to: <201011160837.32797.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Andrew Chew' <AChew@nvidia.com>
Cc: linux-media@vger.kernel.org
Message-id: <002001cb8576$76ca0fa0$645e2ee0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <643E69AA4436674C8F39DCC2C05F763816BB828A36@HQMAIL03.nvidia.com>
 <643E69AA4436674C8F39DCC2C05F763816BB828A37@HQMAIL03.nvidia.com>
 <201011160837.32797.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, November 16, 2010 8:38 AM Hans Verkuil wrote:

> On Tuesday, November 16, 2010 02:10:39 Andrew Chew wrote:
> > I'm looking at drivers/media/video/videobuf-dma-contig.c's __videobuf_alloc() routine.  We call
> kzalloc() to allocate the videobuf_buffer.  However, I don't see where the two lists (vb->stream and
> vb->queue) that are a part of struct videobuf_buffer get initialized (with, say, INIT_LIST_HEAD).
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

In the current version of vb2 there is no such list, so the driver has to keep
list tracking entries inside its own structures. Usually v4l2 drivers embed
video_buf structure inside some custom buffer structure to track some driver
specific per-buffer stuff, so there is no problem in adding struct list_head
there. This resolves all design problems like who is responsible of initializing
it.

> > This results in a warning in the V4L2 camera host driver that I'm developing when the buf_prepare
> method gets called.  I do a similar sanity check to the sh_mobile_ceu_camera driver (WARN_ON(!list-
> >empty(&vb->queue));) in my buf_prepare method, and see the warning.  If I add INIT_LIST_HEAD to
> __videobuf_alloc(), this warning goes away.
> >
> > Is this a known bug?
> 
> Well, videobuf is one big bug. We hope that we can merge the videobuf replacement
> (called videobuf2, amazingly enough :-) ) for 2.6.38. Fingers crossed.
> 
> So you might want to wait until vb2 arrives, depending on your schedule.

I'm sorry for the delay, but I work hard to track some well hidden bug. I hope to post
a new version of videobuf2 patches tomorrow.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

