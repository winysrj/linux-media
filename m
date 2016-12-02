Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:47771 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751972AbcLBRRK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:17:10 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/8] [media] rc: allow software timeout to be set
Date: Fri,  2 Dec 2016 17:16:12 +0000
Message-Id: <1480698974-9093-6-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both the iguanair and the technotrend usb ir do not do any timeout
handling in hardware, so timeout is entirely done in
ir_raw_event_store_with_filter(). Any sensible timeout value will
do, so allow it to be set using LIRC_SET_REC_TIMEOUT.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 4 +++-
 drivers/media/rc/ttusbir.c  | 5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 5f63454..139a09c 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -504,7 +504,9 @@ static int iguanair_probe(struct usb_interface *intf,
 	rc->tx_ir = iguanair_tx;
 	rc->driver_name = DRIVER_NAME;
 	rc->map_name = RC_MAP_RC6_MCE;
-	rc->timeout = MS_TO_NS(100);
+	rc->min_timeout = 1;
+	rc->timeout = IR_DEFAULT_TIMEOUT;
+	rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	rc->rx_resolution = RX_RESOLUTION;
 
 	iguanair_set_tx_carrier(rc, 38000);
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index bc214e2..8393014 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -322,7 +322,10 @@ static int ttusbir_probe(struct usb_interface *intf,
 	rc->priv = tt;
 	rc->driver_name = DRIVER_NAME;
 	rc->map_name = RC_MAP_TT_1500;
-	rc->timeout = MS_TO_NS(100);
+	rc->min_timeout = 1;
+	rc->timeout = IR_DEFAULT_TIMEOUT;
+	rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
+
 	/*
 	 * The precision is NS_PER_BIT, but since every 8th bit can be
 	 * overwritten with garbage the accuracy is at best 2 * NS_PER_BIT.
-- 
2.9.3

