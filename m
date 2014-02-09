Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38225 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbaBIIt5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:57 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 19/86] rtl28xxu: add module parameter to disable IR
Date: Sun,  9 Feb 2014 10:48:24 +0200
Message-Id: <1391935771-18670-20-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable IR interrupts in order to avoid SDR sample loss.
IR interrupts causes some extra load for device and it seems
be one reason to loss samples when sampling rate is high.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 6a5eb0f..77f1fc9 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -36,6 +36,9 @@
 #include "tua9001.h"
 #include "r820t.h"
 
+static int rtl28xxu_disable_rc;
+module_param_named(disable_rc, rtl28xxu_disable_rc, int, 0644);
+MODULE_PARM_DESC(disable_rc, "disable RTL2832U remote controller");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
@@ -1325,6 +1328,10 @@ err:
 static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 		struct dvb_usb_rc *rc)
 {
+	/* disable IR interrupts in order to avoid SDR sample loss */
+	if (rtl28xxu_disable_rc)
+		return rtl28xx_wr_reg(d, IR_RX_IE, 0x00);
+
 	/* load empty to enable rc */
 	if (!rc->map_name)
 		rc->map_name = RC_MAP_EMPTY;
-- 
1.8.5.3

