Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:33875 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175Ab0ESRAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 13:00:38 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 4/4] tm6000: bugfix stabilizing urb data
Date: Wed, 19 May 2010 18:58:27 +0200
Message-Id: <1274288307-2858-6-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1274288307-2858-3-git-send-email-stefan.ringel@arcor.de>
References: <1274288307-2858-3-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 4d92a12..2a61cc3 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -48,7 +48,7 @@
 #define TM6000_MIN_BUF 4
 #define TM6000_DEF_BUF 8
 
-#define TM6000_MAX_ISO_PACKETS	40	/* Max number of ISO packets */
+#define TM6000_MAX_ISO_PACKETS	46	/* Max number of ISO packets */
 
 /* Declare static vars that will be used as parameters */
 static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
@@ -620,7 +620,7 @@ static void tm6000_uninit_isoc(struct tm6000_core *dev)
 static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 {
 	struct tm6000_dmaqueue *dma_q = &dev->vidq;
-	int i, j, sb_size, pipe, size, max_packets, num_bufs = 5;
+	int i, j, sb_size, pipe, size, max_packets, num_bufs = 8;
 	struct urb *urb;
 
 	/* De-allocates all pending stuff */
-- 
1.7.0.3

