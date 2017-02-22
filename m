Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:44447 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933907AbdBVXLw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 18:11:52 -0500
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
        linux-media@vger.kernel.org, <stable@kernel.org>
Subject: [PATCH] [media] rc: raw decoder for keymap protocol is not loaded on register
Date: Wed, 22 Feb 2017 23:11:49 +0000
Message-Id: <1487805109-17432-1-git-send-email-sean@mess.org>
In-Reply-To: <20170222230052.GA17047@gofer.mess.org>
References: <20170222230052.GA17047@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the protocol is set via the sysfs protocols attribute, the
decoder is loaded. However, when it is not when a device is first
plugged in or registered.

Fixes: acc1c3c ("[media] media: rc: load decoder modules on-demand")

Signed-off-by: Sean Young <sean@mess.org>
Cc: <stable@kernel.org> # v4.5+
---
 drivers/media/rc/rc-main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 2424946..a158b32 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1663,6 +1663,7 @@ static int rc_setup_rx_device(struct rc_dev *dev)
 {
 	int rc;
 	struct rc_map *rc_map;
+	u64 rc_type;
 
 	if (!dev->map_name)
 		return -EINVAL;
@@ -1677,15 +1678,18 @@ static int rc_setup_rx_device(struct rc_dev *dev)
 	if (rc)
 		return rc;
 
-	if (dev->change_protocol) {
-		u64 rc_type = (1ll << rc_map->rc_type);
+	rc_type = BIT_ULL(rc_map->rc_type);
 
+	if (dev->change_protocol) {
 		rc = dev->change_protocol(dev, &rc_type);
 		if (rc < 0)
 			goto out_table;
 		dev->enabled_protocols = rc_type;
 	}
 
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		ir_raw_load_modules(&rc_type);
+
 	set_bit(EV_KEY, dev->input_dev->evbit);
 	set_bit(EV_REP, dev->input_dev->evbit);
 	set_bit(EV_MSC, dev->input_dev->evbit);
-- 
2.9.3
