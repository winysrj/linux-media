Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:45801 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755529AbdGKJrj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 05:47:39 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Derek <user.vdr@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        "# v2 . 6 . 36+" <stable@vger.kernel.org>
Subject: [PATCH] [media] lirc: LIRC_GET_REC_RESOLUTION should return microseconds
Date: Tue, 11 Jul 2017 10:47:37 +0100
Message-Id: <20170711094737.8410-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit e8f4818895b3 ("[media] lirc: advertise
LIRC_CAN_GET_REC_RESOLUTION and improve") lircd uses the ioctl
LIRC_GET_REC_RESOLUTION to determine the shortest pulse or space that
the hardware can detect. This breaks decoding in lirc because lircd
expects the answer in microseconds, but nanoseconds is returned.

Cc: <stable@vger.kernel.org> # v2.6.36+
Reported-by: Derek <user.vdr@gmail.com>
Tested-by: Derek <user.vdr@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index a30af91..d2223c0 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -266,7 +266,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!dev->rx_resolution)
 			return -ENOTTY;
 
-		val = dev->rx_resolution;
+		val = dev->rx_resolution / 1000;
 		break;
 
 	case LIRC_SET_WIDEBAND_RECEIVER:
-- 
2.9.4
