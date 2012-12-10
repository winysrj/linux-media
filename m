Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57679 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab2LJAqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 19:46:22 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 10/11] dvb_usb_v2: use dummy function defines instead stub functions
Date: Mon, 10 Dec 2012 02:45:34 +0200
Message-Id: <1355100335-2123-10-git-send-email-crope@iki.fi>
In-Reply-To: <1355100335-2123-1-git-send-email-crope@iki.fi>
References: <1355100335-2123-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think it is better (cheaper) to use dummy defines for functions
that has no meaning when remote controller is disabled by Kconfig.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 94f134c..1330c64 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -204,15 +204,8 @@ static int dvb_usbv2_remote_exit(struct dvb_usb_device *d)
 	return 0;
 }
 #else
-static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
-{
-	return 0;
-}
-
-static int dvb_usbv2_remote_exit(struct dvb_usb_device *d)
-{
-	return 0;
-}
+	#define dvb_usbv2_remote_init(args...) 0
+	#define dvb_usbv2_remote_exit(args...)
 #endif
 
 static void dvb_usb_data_complete(struct usb_data_stream *stream, u8 *buf,
-- 
1.7.11.7

