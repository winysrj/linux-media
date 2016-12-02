Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:42827 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751654AbcLBRRK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:17:10 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 7/8] [media] rc5x: 6th command bit is S2 bit
Date: Fri,  2 Dec 2016 17:16:13 +0000
Message-Id: <1480698974-9093-7-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 2nd stop bit in rc5 is reused as an inverted 6th command bit in
20 bits rc5x. Currently the rc5x decoder sets the 6th command bit as
an inverted duplicate of the lowest system bit; as a result we do
not have all the command bits.

Note that there are no rc5x keymaps present.

Signed-off-by: Sean Young <sean@mess.org>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-rc5-decoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index a0fd4e6..a95477c 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -132,7 +132,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			command  = (data->bits & 0x00FC0) >> 6;
 			system   = (data->bits & 0x1F000) >> 12;
 			toggle   = (data->bits & 0x20000) ? 1 : 0;
-			command += (data->bits & 0x01000) ? 0 : 0x40;
+			command += (data->bits & 0x40000) ? 0 : 0x40;
 			scancode = system << 16 | command << 8 | xdata;
 			protocol = RC_TYPE_RC5X;
 
-- 
2.9.3

