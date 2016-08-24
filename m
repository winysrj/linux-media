Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36221 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757076AbcHYGiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 02:38:12 -0400
Received: by mail-lf0-f42.google.com with SMTP id g62so27486084lfe.3
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2016 23:38:11 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] [media] tw5864-core: remove excessive irqsave
Date: Thu, 25 Aug 2016 02:17:18 +0300
Message-Id: <20160824231718.25032-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/pci/tw5864/tw5864-core.c:160 tw5864_h264_isr() error: double lock 'irqsave:flags'
	drivers/media/pci/tw5864/tw5864-core.c:174 tw5864_h264_isr() error: double unlock 'irqsave:flags'

Two different spinlocks are obtained, so having two calls is correct,
but second irqsave is superfluous, and using same "flags" variable is
just wrong.

Reported-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 drivers/media/pci/tw5864/tw5864-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/tw5864/tw5864-core.c b/drivers/media/pci/tw5864/tw5864-core.c
index 440cd7b..1d43b96 100644
--- a/drivers/media/pci/tw5864/tw5864-core.c
+++ b/drivers/media/pci/tw5864/tw5864-core.c
@@ -157,12 +157,12 @@ static void tw5864_h264_isr(struct tw5864_dev *dev)
 
 		cur_frame = next_frame;
 
-		spin_lock_irqsave(&input->slock, flags);
+		spin_lock(&input->slock);
 		input->frame_seqno++;
 		input->frame_gop_seqno++;
 		if (input->frame_gop_seqno >= input->gop)
 			input->frame_gop_seqno = 0;
-		spin_unlock_irqrestore(&input->slock, flags);
+		spin_unlock(&input->slock);
 	} else {
 		dev_err(&dev->pci->dev,
 			"Skipped frame on input %d because all buffers busy\n",
-- 
2.9.2

