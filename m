Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33793 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751067AbdKUUvl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 15:51:41 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: imon: auto-config ffdc 30 device
Date: Tue, 21 Nov 2017 20:51:39 +0000
Message-Id: <20171121205139.10840-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another device with the 0xffdc device id, this one with 0x30 in the
config byte. Its an iMON VFD + iMON IR (it does not understand rc6).

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/imon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index b25b35b3f6da..bff2d8503504 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1956,6 +1956,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 		break;
 	/* iMON VFD, iMON IR */
 	case 0x24:
+	case 0x30:
 	case 0x85:
 		dev_info(ictx->dev, "0xffdc iMON VFD, iMON IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-- 
2.14.3
