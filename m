Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34391 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809AbcGJApQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 20:45:16 -0400
Received: by mail-qk0-f182.google.com with SMTP id o67so1236552qke.1
        for <linux-media@vger.kernel.org>; Sat, 09 Jul 2016 17:45:15 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ismael Luceno <ismael@iodev.co.uk>,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	andrey_utkin@fastmail.com
Subject: [PATCH] media: solo6x10: increase FRAME_BUF_SIZE
Date: Sun, 10 Jul 2016 03:44:50 +0300
Message-Id: <20160710004450.2480-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In practice, devices sometimes return frames larger than current buffer
size, leading to failure in solo_send_desc().
It is not clear which minimal increase in buffer size would be enough,
so this patch doubles it, this should be safely assumed as sufficient.

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 8b1cde5..3991643 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -33,7 +33,7 @@
 #include "solo6x10-jpeg.h"
 
 #define MIN_VID_BUFFERS		2
-#define FRAME_BUF_SIZE		(196 * 1024)
+#define FRAME_BUF_SIZE		(400 * 1024)
 #define MP4_QS			16
 #define DMA_ALIGN		4096
 
-- 
2.8.4

