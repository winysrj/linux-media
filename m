Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16816 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab1FJLun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 07:50:43 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LMK009DPOWIZ9@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Jun 2011 12:50:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMK00LTPOWH8E@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Jun 2011 12:50:41 +0100 (BST)
Date: Fri, 10 Jun 2011 13:50:37 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: vb2: about vb2_queue->queued_count
In-reply-to: <20110608204758.GA15070@pengutronix.de>
To: =?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, 'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Message-id: <000b01cc2764$9cf53430$d6df9c90$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
References: <20110608204758.GA15070@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, June 08, 2011 10:48 PM Uwe Kleine-König wrote:

> I'm still debugging my new video overlay device driver. The current
> problem is again when playing back a second video.
> 
> After streamoff is called at the end of the first video, I disable the
> overlay and call vb2_buffer_done on the last buffer. This is exited
> early because vb->state == VB2_BUF_STATE_DEQUEUED.
> This results in vb->vb2_queue->queued_count being 1.
> 
> Now if the new video starts I call vb2_queue_init in the .vidioc_reqbufs
> callback on my queue (that still has queued_count == 1). After
> vb2_queue_init returns queued_count is still 1 though q->queued_list is
> reset to be empty.
> 
> __vb2_queue_cancel has a similar problem, &q->queued_list is reset, but
> queued_count is not.

Thanks again for finding the bug. You are right, __vb2_queue_cancel should
reset queued_count too. I will post a patch soon.

> OTOH queued_count seems to be read only by vb2_wait_for_all_buffers
> which currently has no users. :-)

Right, no mainline drive use it right now, but this function might be 
convenient for some standard drivers.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



