Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44136 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753868AbeCFTPG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:06 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/8] em28xx: Change hex to lower case
Date: Tue,  6 Mar 2018 13:14:56 -0600
Message-Id: <1520363702-25536-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
References: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checkpatch fix.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/em28xx/em28xx-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index bb1b650..36d341f 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -643,7 +643,7 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 			em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
 					 EM2874_R5D_TS1_PKT_SIZE :
 					 EM2874_R5E_TS2_PKT_SIZE,
-					 0xFF);
+					 0xff);
 		} else {
 			/* ISOC Maximum Transfer Size = 188 * 5 */
 			em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
-- 
2.7.4
