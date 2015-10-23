Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54284 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbbJWWId (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2015 18:08:33 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] hackrf: move RF gain ctrl enable behind module parameter
Date: Sat, 24 Oct 2015 01:08:08 +0300
Message-Id: <1445638088-7750-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used Avago MGA-81563 RF amplifier could be destroyed pretty easily
with too strong signal or transmitting to bad antenna.
Add module parameter 'enable_rf_gain_ctrl' which allows enabling
RF gain control - otherwise, default without the module parameter,
RF gain control is set to 'grabbed' state which prevents setting
value to the control.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/hackrf/hackrf.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 84e8a42..0fe5cb2 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -24,6 +24,15 @@
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-vmalloc.h>
 
+/*
+ * Used Avago MGA-81563 RF amplifier could be destroyed pretty easily with too
+ * strong signal or transmitting to bad antenna.
+ * Set RF gain control to 'grabbed' state by default for sure.
+ */
+static bool hackrf_enable_rf_gain_ctrl;
+module_param_named(enable_rf_gain_ctrl, hackrf_enable_rf_gain_ctrl, bool, 0644);
+MODULE_PARM_DESC(enable_rf_gain_ctrl, "enable RX/TX RF amplifier control (warn: could damage amplifier)");
+
 /* HackRF USB API commands (from HackRF Library) */
 enum {
 	CMD_SET_TRANSCEIVER_MODE           = 0x01,
@@ -1451,6 +1460,7 @@ static int hackrf_probe(struct usb_interface *intf,
 		dev_err(dev->dev, "Could not initialize controls\n");
 		goto err_v4l2_ctrl_handler_free_rx;
 	}
+	v4l2_ctrl_grab(dev->rx_rf_gain, !hackrf_enable_rf_gain_ctrl);
 	v4l2_ctrl_handler_setup(&dev->rx_ctrl_handler);
 
 	/* Register controls for transmitter */
@@ -1471,6 +1481,7 @@ static int hackrf_probe(struct usb_interface *intf,
 		dev_err(dev->dev, "Could not initialize controls\n");
 		goto err_v4l2_ctrl_handler_free_tx;
 	}
+	v4l2_ctrl_grab(dev->tx_rf_gain, !hackrf_enable_rf_gain_ctrl);
 	v4l2_ctrl_handler_setup(&dev->tx_ctrl_handler);
 
 	/* Register the v4l2_device structure */
-- 
http://palosaari.fi/

