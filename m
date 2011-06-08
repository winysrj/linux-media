Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54725 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1FHUsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 16:48:06 -0400
Date: Wed, 8 Jun 2011 22:47:58 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: vb2: about vb2_queue->queued_count
Message-ID: <20110608204758.GA15070@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I'm still debugging my new video overlay device driver. The current
problem is again when playing back a second video.

After streamoff is called at the end of the first video, I disable the
overlay and call vb2_buffer_done on the last buffer. This is exited
early because vb->state == VB2_BUF_STATE_DEQUEUED.
This results in vb->vb2_queue->queued_count being 1.

Now if the new video starts I call vb2_queue_init in the .vidioc_reqbufs
callback on my queue (that still has queued_count == 1). After
vb2_queue_init returns queued_count is still 1 though q->queued_list is
reset to be empty.

__vb2_queue_cancel has a similar problem, &q->queued_list is reset, but
queued_count is not.

OTOH queued_count seems to be read only by vb2_wait_for_all_buffers
which currently has no users. :-)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
