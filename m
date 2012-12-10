Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43651 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab2LJAqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 19:46:21 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 03/11] anysee: make remote controller optional
Date: Mon, 10 Dec 2012 02:45:27 +0200
Message-Id: <1355100335-2123-3-git-send-email-crope@iki.fi>
In-Reply-To: <1355100335-2123-1-git-send-email-crope@iki.fi>
References: <1355100335-2123-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not compile remote controller when RC-core is disabled by Kconfig.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index d05c5b5..5f45037 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -1019,6 +1019,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 	return ret;
 }
 
+#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
 static int anysee_rc_query(struct dvb_usb_device *d)
 {
 	u8 buf[] = {CMD_GET_IR_CODE};
@@ -1054,6 +1055,9 @@ static int anysee_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 
 	return 0;
 }
+#else
+	#define anysee_get_rc_config NULL
+#endif
 
 static int anysee_ci_read_attribute_mem(struct dvb_ca_en50221 *ci, int slot,
 	int addr)
-- 
1.7.11.7

