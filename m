Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:39341 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbeDXXNG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 19:13:06 -0400
Received: by mail-qt0-f193.google.com with SMTP id f1-v6so7336209qtj.6
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 16:13:06 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cx88: Get rid of spurious call to cx8800_start_vbi_dma()
Date: Tue, 24 Apr 2018 19:12:52 -0400
Message-Id: <1524611572-6075-1-git-send-email-dheitmueller@kernellabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was left over from the conversion to VB2, where the call was
getting invoked both in buffer_queue and start_streaming, which
was intermittently causing invalid opcodes on the VBI RISC queue.

This change effectively mirrors the exact same change Hans Verkuil
made in cx88-video.c in 389208e1173e097590856ed24a505551510f78d4.

Thanks to Daniel Glöckner for spotting the actual bug after I spent
several days trying to chase down the issue.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Thanks-to: Daniel Glöckner <daniel-gl@gmx.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/pci/cx88/cx88-vbi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index c637679..58489ea 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -178,7 +178,6 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	if (list_empty(&q->active)) {
 		list_add_tail(&buf->list, &q->active);
-		cx8800_start_vbi_dma(dev, q, buf);
 		dprintk(2, "[%p/%d] vbi_queue - first active\n",
 			buf, buf->vb.vb2_buf.index);
 
-- 
1.9.1
