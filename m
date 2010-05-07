Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:41879 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567Ab0EGPap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 11:30:45 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: bugfix image position
Date: Fri,  7 May 2010 17:29:04 +0200
Message-Id: <1273246144-6876-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

bugfix incorrect image and line position in videobuffer


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 9554472..f7248f0 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -223,8 +223,8 @@ static int copy_packet(struct urb *urb, u32 header, u8 **ptr, u8 *endp,
 			 * It should, instead, check if the user selected
 			 * entrelaced or non-entrelaced mode
 			 */
-			pos= ((line<<1)+field)*linewidth +
-				block*TM6000_URB_MSG_LEN;
+			pos = ((line << 1) - field - 1) * linewidth +
+				block * TM6000_URB_MSG_LEN;
 
 			/* Don't allow to write out of the buffer */
 			if (pos+TM6000_URB_MSG_LEN > (*buf)->vb.size) {
-- 
1.7.0.3

