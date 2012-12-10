Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42477 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab2LJAqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 19:46:21 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 05/11] af9035: make remote controller optional
Date: Mon, 10 Dec 2012 02:45:29 +0200
Message-Id: <1355100335-2123-5-git-send-email-crope@iki.fi>
In-Reply-To: <1355100335-2123-1-git-send-email-crope@iki.fi>
References: <1355100335-2123-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not compile remote controller when RC-core is disabled by Kconfig.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index ea37b5c..19b1394 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1146,6 +1146,7 @@ err:
 	return ret;
 }
 
+#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
 static int af9035_rc_query(struct dvb_usb_device *d)
 {
 	unsigned int key;
@@ -1220,6 +1221,9 @@ err:
 
 	return ret;
 }
+#else
+	#define af9035_get_rc_config NULL
+#endif
 
 /* interface 0 is used by DVB-T receiver and
    interface 1 is for remote controller (HID) */
-- 
1.7.11.7

