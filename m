Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60241 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab2LJAqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 19:46:21 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 02/11] rtl28xxu: make remote controller optional
Date: Mon, 10 Dec 2012 02:45:26 +0200
Message-Id: <1355100335-2123-2-git-send-email-crope@iki.fi>
In-Reply-To: <1355100335-2123-1-git-send-email-crope@iki.fi>
References: <1355100335-2123-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not compile remote controller when RC-core is disabled by Kconfig.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index eddda69..9a68903 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1125,7 +1125,7 @@ err:
 	return ret;
 }
 
-
+#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
 static int rtl2831u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i;
@@ -1208,7 +1208,11 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
 
 	return 0;
 }
+#else
+	#define rtl2831u_get_rc_config NULL
+#endif
 
+#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
 static int rtl2832u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i;
@@ -1280,6 +1284,9 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 
 	return 0;
 }
+#else
+	#define rtl2832u_get_rc_config NULL
+#endif
 
 static const struct dvb_usb_device_properties rtl2831u_props = {
 	.driver_name = KBUILD_MODNAME,
-- 
1.7.11.7

