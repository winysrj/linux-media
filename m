Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15782 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1FHJJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 05:09:26 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LMG00I2MS3OLE@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 10:09:24 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMG006VLS3NBC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jun 2011 10:09:23 +0100 (BST)
Date: Wed, 08 Jun 2011 11:09:01 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: vb2 queue setup skipped when playing bigger video
In-reply-to: <20110608085355.GS9907@pengutronix.de>
To: =?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, 'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <p.osciak@samsung.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Message-id: <005001cc25bb$b58c13b0$20a43b10$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
References: <20110608085355.GS9907@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, June 08, 2011 10:54 AM Uwe Kleine-König wrote:

> I'm writing a driver for a video overlay device and have the problem
> that if I first playback a video with a resolution of say 320x240 and
> then another one with 640x400 the buffers allocated for the first
> playback are too small, but my .queue_setup callback isn't called.
> 
> I think the culprit is the following line in vb2_reqbufs()
> (drivers/media/video/videobuf2-core.c):
> 
> 	/*
> 	 * If the same number of buffers and memory access method is
> requested
> 	 * then return immediately.
> 	 */
> 	if (q->memory == req->memory && req->count == q->num_buffers)
> 		return 0;
> 
> which exits vb2_reqbufs before
> 
> 	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
> 		       plane_sizes, q->alloc_ctx);
> 
> Reading the vb1 code, this shortcut isn't implemented there.
> 
> As I'm quite new to all that v4l2 stuff, I'm not sure what to do.
> Just removing the return 0 (i.e. reverting 31901a07) seems to do the
> right thing for me.
> 
> Thoughts?

You are definitely right. I've missed the case that the format might
have changed in-between the reqbufs() calls. My commit 31901a07 is
completely wrong indeed, I've simplified it too much. I will send
revert soon.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



