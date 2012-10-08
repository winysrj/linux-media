Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54249 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2JHMdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 08:33:49 -0400
Received: by mail-qc0-f174.google.com with SMTP id d3so2796440qch.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 05:33:49 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 20:33:49 +0800
Message-ID: <CAPgLHd9sam9oaqGVzh5Bt5cdH1R99t0rOKvS3Omqf26gOTbt5A@mail.gmail.com>
Subject: [PATCH] cx88: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/pci/cx88/cx88-mpeg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index c04fb61..33f6f87 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -217,8 +217,7 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 				return 0;
 			buf = list_entry(q->queued.next, struct cx88_buffer, vb.queue);
 			if (NULL == prev) {
-				list_del(&buf->vb.queue);
-				list_add_tail(&buf->vb.queue,&q->active);
+				list_move_tail(&buf->vb.queue, &q->active);
 				cx8802_start_dma(dev, q, buf);
 				buf->vb.state = VIDEOBUF_ACTIVE;
 				buf->count    = q->count++;
@@ -229,8 +228,7 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 			} else if (prev->vb.width  == buf->vb.width  &&
 				   prev->vb.height == buf->vb.height &&
 				   prev->fmt       == buf->fmt) {
-				list_del(&buf->vb.queue);
-				list_add_tail(&buf->vb.queue,&q->active);
+				list_move_tail(&buf->vb.queue, &q->active);
 				buf->vb.state = VIDEOBUF_ACTIVE;
 				buf->count    = q->count++;
 				prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);

