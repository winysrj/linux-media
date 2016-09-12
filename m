Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33333 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753157AbcILXDL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 19:03:11 -0400
Received: by mail-lf0-f52.google.com with SMTP id h127so98369733lfh.0
        for <linux-media@vger.kernel.org>; Mon, 12 Sep 2016 16:03:10 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, hans.verkuil@cisco.com, Julia.Lawall@lip6.fr
Cc: andrey_utkin@fastmail.com, maintainers@bluecherrydvr.com,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH 1/2] [media] tw5864: constify vb2_ops structure
Date: Tue, 13 Sep 2016 02:02:37 +0300
Message-Id: <20160912230238.2302-2-andrey.utkin@corp.bluecherry.net>
In-Reply-To: <20160912230238.2302-1-andrey.utkin@corp.bluecherry.net>
References: <20160912230238.2302-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inspired by "[media] pci: constify vb2_ops structures" patch
from Julia Lawall (dated 9 Sep 2016).

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 drivers/media/pci/tw5864/tw5864-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index 6c1685a..7401b64 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -465,7 +465,7 @@ static void tw5864_stop_streaming(struct vb2_queue *q)
 	spin_unlock_irqrestore(&input->slock, flags);
 }
 
-static struct vb2_ops tw5864_video_qops = {
+static const struct vb2_ops tw5864_video_qops = {
 	.queue_setup = tw5864_queue_setup,
 	.buf_queue = tw5864_buf_queue,
 	.start_streaming = tw5864_start_streaming,
-- 
2.9.2

