Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49551 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757933AbcIPKBP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 06:01:15 -0400
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: linux-media@vger.kernel.org, pmhahn+video@pmhahn.de
Cc: hverkuil@xs4all.nl, Andrey Utkin <andrey_utkin@fastmail.com>
Subject: [PATCH] Potential fix for "[BUG] process stuck when closing saa7146 [dvb_ttpci]"
Date: Fri, 16 Sep 2016 13:00:28 +0300
Message-Id: <20160916100028.8856-1-andrey_utkin@fastmail.com>
In-Reply-To: <20160911133317.whw3j2pok4sktkeo@pmhahn.de>
References: <20160911133317.whw3j2pok4sktkeo@pmhahn.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,
Please try this patch. It is purely speculative as I don't have the hardware,
but I hope my approach is right.

---
 drivers/media/common/saa7146/saa7146_video.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index ea2f3bf..93c64f0 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -390,6 +390,7 @@ static int video_end(struct saa7146_fh *fh, struct file *file)
 {
 	struct saa7146_dev *dev = fh->dev;
 	struct saa7146_vv *vv = dev->vv_data;
+	struct saa7146_dmaqueue *q = &vv->video_dmaq;
 	struct saa7146_format *fmt = NULL;
 	unsigned long flags;
 	unsigned int resource;
@@ -428,6 +429,9 @@ static int video_end(struct saa7146_fh *fh, struct file *file)
 	/* shut down all used video dma transfers */
 	saa7146_write(dev, MC1, dmas);
 
+	if(q->curr)
+		saa7146_buffer_finish(dev, q, VIDEOBUF_DONE);
+
 	spin_unlock_irqrestore(&dev->slock, flags);
 
 	vv->video_fh = NULL;
-- 
2.9.2

