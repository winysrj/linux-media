Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63468 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1LVOeT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 09:34:19 -0500
Received: by wibhm6 with SMTP id hm6so2566645wib.19
        for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:34:18 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 22 Dec 2011 15:34:18 +0100
Message-ID: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com>
Subject: MEM2MEM devices: how to handle sequence number?
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	shawn.guo@linaro.org, richard.zhao@linaro.org,
	fabio.estevam@freescale.com, kernel@pengutronix.de,
	s.hauer@pengutronix.de, r.schwebel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
we have a processing chain composed of three v4l2 devices:

---------------------           -----------------------
----------------------
| v4l2 source  |            |     v4l2 fixer   |               |  v4l2 encoder |
|  (capture)     |---------->|  (mem2mem)| ------------>|  (mem2mem) |
------------>
|___________|            |____________|              |____________|


"v4l2 source" generates consecutive sequence numbers so that we can
detect whether a frame has been lost or not.
"v4l2 fixer" and "v4l2 encoder" cannot lose frames because they don't
interact with an external sensor.

How should "v4l2 fixer" and "v4l2 encoder" behave regarding frame
sequence number? Should they just copy the sequence number from the
input buffer to the output buffer or should they maintain their own
count for the CAPTURE queue?

If the former option is chosen we should apply a patch like the
following so that the sequence number of the input buffer is passed to
the videobuf2 layer:

diff --git a/drivers/media/video/videobuf2-core.c
b/drivers/media/video/videobuf2-core.c
index 1250662..7d8a88b 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1127,6 +1127,7 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
         */
        list_add_tail(&vb->queued_entry, &q->queued_list);
        vb->state = VB2_BUF_STATE_QUEUED;
+       vb->v4l2_buf.sequence = b->sequence;

        /*
         * If already streaming, give the buffer to driver for processing.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
