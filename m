Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3553 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaHTW7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 27/29] imon: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:26 +0200
Message-Id: <1408575568-20562-28-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/rc/imon.c:1343:44: warning: cast to restricted __be32
drivers/media/rc/imon.c:1343:44: warning: cast to restricted __be32
drivers/media/rc/imon.c:1343:44: warning: cast to restricted __be32
drivers/media/rc/imon.c:1343:44: warning: cast to restricted __be32
drivers/media/rc/imon.c:1343:44: warning: cast to restricted __be32
drivers/media/rc/imon.c:1343:44: warning: cast to restricted __be32
drivers/media/rc/imon.c:1407:36: warning: cast to restricted __be32
drivers/media/rc/imon.c:1407:36: warning: cast to restricted __be32
drivers/media/rc/imon.c:1407:36: warning: cast to restricted __be32
drivers/media/rc/imon.c:1407:36: warning: cast to restricted __be32
drivers/media/rc/imon.c:1407:36: warning: cast to restricted __be32
drivers/media/rc/imon.c:1407:36: warning: cast to restricted __be32
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1512:28: warning: cast to restricted __be64
drivers/media/rc/imon.c:1516:28: warning: cast to restricted __be32
drivers/media/rc/imon.c:1516:28: warning: cast to restricted __be32
drivers/media/rc/imon.c:1516:28: warning: cast to restricted __be32
drivers/media/rc/imon.c:1516:28: warning: cast to restricted __be32
drivers/media/rc/imon.c:1516:28: warning: cast to restricted __be32
drivers/media/rc/imon.c:1516:28: warning: cast to restricted __be32

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/rc/imon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 7115e68..20ab7d2 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1340,7 +1340,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 				}
 				buf[2] = dir & 0xFF;
 				buf[3] = (dir >> 8) & 0xFF;
-				scancode = be32_to_cpu(*((u32 *)buf));
+				scancode = be32_to_cpu(*((__be32 *)buf));
 			}
 		} else {
 			/*
@@ -1404,7 +1404,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 			}
 			buf[2] = dir & 0xFF;
 			buf[3] = (dir >> 8) & 0xFF;
-			scancode = be32_to_cpu(*((u32 *)buf));
+			scancode = be32_to_cpu(*((__be32 *)buf));
 		} else {
 			/*
 			 * Hack alert: instead of using keycodes, we have
@@ -1509,11 +1509,11 @@ static void imon_incoming_packet(struct imon_context *ictx,
 
 	/* Figure out what key was pressed */
 	if (len == 8 && buf[7] == 0xee) {
-		scancode = be64_to_cpu(*((u64 *)buf));
+		scancode = be64_to_cpu(*((__be64 *)buf));
 		ktype = IMON_KEY_PANEL;
 		kc = imon_panel_key_lookup(scancode);
 	} else {
-		scancode = be32_to_cpu(*((u32 *)buf));
+		scancode = be32_to_cpu(*((__be32 *)buf));
 		if (ictx->rc_type == RC_BIT_RC6_MCE) {
 			ktype = IMON_KEY_IMON;
 			if (buf[0] == 0x80)
-- 
2.1.0.rc1

