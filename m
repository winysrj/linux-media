Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:33958 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbcD3DXq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 23:23:46 -0400
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
Date: Sat, 30 Apr 2016 00:17:08 -0300
Message-Id: <1461986229-11949-1-git-send-email-ismael@iodev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Such frame size is met in practice. Also report oversized frames.

Based on patches by Andrey Utkin <andrey.utkin@corp.bluecherry.net>.

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 67a14c4..f98017b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -33,7 +33,7 @@
 #include "solo6x10-jpeg.h"
 
 #define MIN_VID_BUFFERS		2
-#define FRAME_BUF_SIZE		(196 * 1024)
+#define FRAME_BUF_SIZE		(200 * 1024)
 #define MP4_QS			16
 #define DMA_ALIGN		4096
 
@@ -323,8 +323,11 @@ static int solo_send_desc(struct solo_enc_dev *solo_enc, int skip,
 	int i;
 	int ret;
 
-	if (WARN_ON_ONCE(size > FRAME_BUF_SIZE))
+	if (WARN_ON_ONCE(size > FRAME_BUF_SIZE)) {
+		dev_warn(&solo_dev->pdev->dev,
+			 "oversized frame (%d bytes)\n", size);
 		return -EINVAL;
+	}
 
 	solo_enc->desc_count = 1;
 
-- 
2.8.0

