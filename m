Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:45511 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab0ESRAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 13:00:33 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/4] tm6000: bugfix incorrect size
Date: Wed, 19 May 2010 18:58:24 +0200
Message-Id: <1274288307-2858-3-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 9554472..e5f8b57 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -205,7 +205,11 @@ static int copy_packet(struct urb *urb, u32 header, u8 **ptr, u8 *endp,
 		c = (header >> 24) & 0xff;
 
 		/* split the header fields */
-		size  = (((header & 0x7e) << 1) -1) *4;
+		size  = ((header & 0x7e) << 1);
+
+		if (size > 0)
+			size -= 4;
+
 		block = (header >> 7) & 0xf;
 		field = (header >> 11) & 0x1;
 		line  = (header >> 12) & 0x1ff;
-- 
1.7.0.3

