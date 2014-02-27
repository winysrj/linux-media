Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36131 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbaB0AQ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:16:59 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 2/8] rtl28xxu: add module parameter to disable IR
Date: Thu, 27 Feb 2014 02:16:04 +0200
Message-Id: <1393460170-11591-3-git-send-email-crope@iki.fi>
In-Reply-To: <1393460170-11591-1-git-send-email-crope@iki.fi>
References: <1393460170-11591-1-git-send-email-crope@iki.fi>
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
index fda5c64..7de3e54 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -35,6 +35,9 @@
 #include "tua9001.h"
 #include "r820t.h"
 
+static int rtl28xxu_disable_rc;
+module_param_named(disable_rc, rtl28xxu_disable_rc, int, 0644);
+MODULE_PARM_DESC(disable_rc, "disable RTL2832U remote controller");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
@@ -1322,6 +1325,10 @@ err:
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

