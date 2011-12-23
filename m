Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27015 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1LWHKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 02:10:00 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LWN0078TAKKV1@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Dec 2011 07:09:56 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LWN00MOFAKK20@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Dec 2011 07:09:56 +0000 (GMT)
Date: Fri, 23 Dec 2011 08:09:25 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: MEM2MEM devices: how to handle sequence number?
In-reply-to: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com>
To: 'javier Martin' <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de
Cc: 'Pawel Osciak' <p.osciak@gmail.com>
Message-id: <013f01ccc141$cdf78ed0$69e6ac70$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, December 22, 2011 3:34 PM Javier Martin wrote:

> we have a processing chain composed of three v4l2 devices:
> 
> ---------------------           -----------------------
> ----------------------
> | v4l2 source  |            |     v4l2 fixer   |               |  v4l2 encoder |
> |  (capture)     |---------->|  (mem2mem)| ------------>|  (mem2mem) |
> ------------>
> |___________|            |____________|              |____________|
> 
> 
> "v4l2 source" generates consecutive sequence numbers so that we can
> detect whether a frame has been lost or not.
> "v4l2 fixer" and "v4l2 encoder" cannot lose frames because they don't
> interact with an external sensor.
> 
> How should "v4l2 fixer" and "v4l2 encoder" behave regarding frame
> sequence number? Should they just copy the sequence number from the
> input buffer to the output buffer or should they maintain their own
> count for the CAPTURE queue?

IMHO mem2mem devices, which process buffers in 1:1 way (there is always 
exactly one 'capture'/destination buffer for every 'output'/source buffer)
can simply copy the sequence number from the source buffer to the
destination.

If there is no such 1:1 mapping between the buffers, drivers should maintain
their own numbers. video encoder is probably an example of such device.
A single destination ('capture') buffer with encoded video data might 
contain a fraction, one or more source ('output') video buffers/frames.

> If the former option is chosen we should apply a patch like the
> following so that the sequence number of the input buffer is passed to
> the videobuf2 layer:
> 
> diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c
> index 1250662..7d8a88b 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1127,6 +1127,7 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>          */
>         list_add_tail(&vb->queued_entry, &q->queued_list);
>         vb->state = VB2_BUF_STATE_QUEUED;
> +       vb->v4l2_buf.sequence = b->sequence;
> 
>         /*
>          * If already streaming, give the buffer to driver for processing.
> 

Right, such patch is definitely needed. Please resend it with 'signed-off-by'
annotation.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



