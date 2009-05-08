Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kolorific.com ([61.63.28.39]:34976 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbZEHCns (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2009 22:43:48 -0400
Subject: [PATCH]saa7134-video.c: fix the block bug
From: "figo.zhang" <figo.zhang@kolorific.com>
To: kraxel@bytesex.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	figo1802@126.com
Content-Type: text/plain
Date: Fri, 08 May 2009 10:25:55 +0800
Message-Id: <1241749555.3420.18.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

when re-open or re-start (video_streamon), the q->curr would not be NULL in saa7134_buffer_queue(),
and all the qbuf will add to q->queue list,no one to do activate to start DMA,and then no interrupt 
would happened,so it will be block. 

In VIDEOBUF_NEEDS_INIT state , inital the curr pointer to be NULL int  the buffer_prepare().

Signed-off-by: Figo.zhang <figo.zhang@kolorific.com>
---
 drivers/media/video/saa7134/saa7134-video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 493cad9..550d6ce 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1057,6 +1057,7 @@ static int buffer_prepare(struct videobuf_queue *q,
 		buf->vb.field  = field;
 		buf->fmt       = fh->fmt;
 		buf->pt        = &fh->pt_cap;
+		dev->video_q.curr = NULL;
 
 		err = videobuf_iolock(q,&buf->vb,&dev->ovbuf);
 		if (err)


