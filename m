Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35261 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752046AbeDNVpd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 17:45:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Subject: [PATCH 1/2] media: rc: mce_kbd decoder: remove superfluous call to input_sync
Date: Sat, 14 Apr 2018 22:45:30 +0100
Message-Id: <20180414214531.1450-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is nothing to sync in this code path.

Reported-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 002b8323ae69..2fc78710a724 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -362,7 +362,6 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	dev_dbg(&dev->dev, "failed at state %i (%uus %s)\n",
 		data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
-	input_sync(data->idev);
 	return -EINVAL;
 }
 
-- 
2.14.3
