Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:62663 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966573AbdDSRQC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 13:16:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rainshadow-cec: use strlcat instead of strncat
Date: Wed, 19 Apr 2017 19:15:32 +0200
Message-Id: <20170419171543.3274995-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc warns about an obviously incorrect use of strncat():

drivers/media/usb/rainshadow-cec/rainshadow-cec.c: In function 'rain_cec_adap_transmit':
drivers/media/usb/rainshadow-cec/rainshadow-cec.c:299:4: error: specified bound 48 equals the size of the destination [-Werror=stringop-overflow=]

It seems that strlcat was intended here, and using that makes the
code correct.

Fixes: 0f314f6c2e77 ("[media] rainshadow-cec: new RainShadow Tech HDMI CEC driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
index 541ca543f71f..dc1f64f904cd 100644
--- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -296,7 +296,7 @@ static int rain_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 			 cec_msg_destination(msg), msg->msg[1]);
 		for (i = 2; i < msg->len; i++) {
 			snprintf(hex, sizeof(hex), "%02x", msg->msg[i]);
-			strncat(cmd, hex, sizeof(cmd));
+			strlcat(cmd, hex, sizeof(cmd));
 		}
 	}
 	mutex_lock(&rain->write_lock);
-- 
2.9.0
