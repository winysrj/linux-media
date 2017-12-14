Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50837 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753376AbdLNRWB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:01 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/10] media: imon:  auto-config ffdc 26 device
Date: Thu, 14 Dec 2017 17:21:52 +0000
Message-Id: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another device with the 0xffdc device id, this one with 0x26 in the
config byte. Its an iMON Inside + iMON IR. It does respond to rc-6,
but seems to produce random garbage rather than a scancode.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/imon.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 2c26d917fe0f..6c873a3c4720 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1975,6 +1975,11 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 		detected_display_type = IMON_DISPLAY_TYPE_LCD;
 		allowed_protos = RC_PROTO_BIT_RC6_MCE;
 		break;
+	/* no display, iMON IR */
+	case 0x26:
+		dev_info(ictx->dev, "0xffdc iMON Inside, iMON IR");
+		ictx->display_supported = false;
+		break;
 	default:
 		dev_info(ictx->dev, "Unknown 0xffdc device, defaulting to VFD and iMON IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-- 
2.14.3
