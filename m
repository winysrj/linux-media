Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46908 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754774AbcHXQaq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 12:30:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/2] [media] tw5864-core: remove double irq lock code
Date: Wed, 24 Aug 2016 13:30:39 -0300
Message-Id: <c5f789d7d85f4c4b6bcdb2b1674d6495f05ada42.1472056235.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/pci/tw5864/tw5864-core.c:160 tw5864_h264_isr() error: double lock 'irqsave:flags'
	drivers/media/pci/tw5864/tw5864-core.c:174 tw5864_h264_isr() error: double unlock 'irqsave:flags'

Remove the IRQ duplicated lock.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/tw5864/tw5864-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/tw5864/tw5864-core.c b/drivers/media/pci/tw5864/tw5864-core.c
index 440cd7bb8d04..e3d884e963c0 100644
--- a/drivers/media/pci/tw5864/tw5864-core.c
+++ b/drivers/media/pci/tw5864/tw5864-core.c
@@ -157,12 +157,10 @@ static void tw5864_h264_isr(struct tw5864_dev *dev)
 
 		cur_frame = next_frame;
 
-		spin_lock_irqsave(&input->slock, flags);
 		input->frame_seqno++;
 		input->frame_gop_seqno++;
 		if (input->frame_gop_seqno >= input->gop)
 			input->frame_gop_seqno = 0;
-		spin_unlock_irqrestore(&input->slock, flags);
 	} else {
 		dev_err(&dev->pci->dev,
 			"Skipped frame on input %d because all buffers busy\n",
-- 
2.7.4

