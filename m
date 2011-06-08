Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46519 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1FHIyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 04:54:00 -0400
Date: Wed, 8 Jun 2011 10:53:55 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: vb2 queue setup skipped when playing bigger video
Message-ID: <20110608085355.GS9907@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I'm writing a driver for a video overlay device and have the problem
that if I first playback a video with a resolution of say 320x240 and
then another one with 640x400 the buffers allocated for the first
playback are too small, but my .queue_setup callback isn't called.

I think the culprit is the following line in vb2_reqbufs()
(drivers/media/video/videobuf2-core.c):

	/*
	 * If the same number of buffers and memory access method is requested
	 * then return immediately.
	 */
	if (q->memory == req->memory && req->count == q->num_buffers)
		return 0;

which exits vb2_reqbufs before

	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
		       plane_sizes, q->alloc_ctx);

Reading the vb1 code, this shortcut isn't implemented there.

As I'm quite new to all that v4l2 stuff, I'm not sure what to do.
Just removing the return 0 (i.e. reverting 31901a07) seems to do the
right thing for me.

Thoughts?

Thanks and best regards,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
