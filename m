Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56735 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab3FDV4M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 17:56:12 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/7] rtl28xxu: remove redundant IS_ENABLED macro
Date: Wed,  5 Jun 2013 00:54:59 +0300
Message-Id: <1370382903-21332-4-git-send-email-crope@iki.fi>
In-Reply-To: <1370382903-21332-1-git-send-email-crope@iki.fi>
References: <1370382903-21332-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 4167011..8bbc6ab 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1231,11 +1231,7 @@ static int rtl2831u_get_rc_config(struct dvb_usb_device *d,
 
 	return 0;
 }
-#else
-	#define rtl2831u_get_rc_config NULL
-#endif
 
-#if IS_ENABLED(CONFIG_RC_CORE)
 static int rtl2832u_rc_query(struct dvb_usb_device *d)
 {
 	int ret, i, len;
@@ -1338,7 +1334,8 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 	return 0;
 }
 #else
-	#define rtl2832u_get_rc_config NULL
+#define rtl2831u_get_rc_config NULL
+#define rtl2832u_get_rc_config NULL
 #endif
 
 static const struct dvb_usb_device_properties rtl2831u_props = {
-- 
1.7.11.7

