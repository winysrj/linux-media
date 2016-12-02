Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:34587 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbcLBRRJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:17:09 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/8] [media] mceusb: LIRC_SET_SEND_CARRIER returns 0 on success
Date: Fri,  2 Dec 2016 17:16:07 +0000
Message-Id: <1480698974-9093-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LIRC_SET_SEND_CARRIER ioctl should not return the carrier used, it
should return 0.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 9bf6917..96b0ade 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -890,7 +890,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 			cmdbuf[3] = MCE_IRDATA_TRAILER;
 			dev_dbg(ir->dev, "disabling carrier modulation");
 			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
-			return carrier;
+			return 0;
 		}
 
 		for (prescaler = 0; prescaler < 4; ++prescaler) {
@@ -904,7 +904,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 
 				/* Transmit new carrier to mce device */
 				mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
-				return carrier;
+				return 0;
 			}
 		}
 
-- 
2.9.3

