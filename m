Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37354 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab2LJAqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 19:46:22 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 09/11] dvb_usb_v2: remove rc-core stub implementations
Date: Mon, 10 Dec 2012 02:45:33 +0200
Message-Id: <1355100335-2123-9-git-send-email-crope@iki.fi>
In-Reply-To: <1355100335-2123-1-git-send-email-crope@iki.fi>
References: <1355100335-2123-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those are not needed anymore as all dvb-usb-v2 drivers has proper
dependency checks for RC-core.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index e2678a7..059291b 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -400,13 +400,4 @@ extern int dvb_usbv2_reset_resume(struct usb_interface *);
 extern int dvb_usbv2_generic_rw(struct dvb_usb_device *, u8 *, u16, u8 *, u16);
 extern int dvb_usbv2_generic_write(struct dvb_usb_device *, u8 *, u16);
 
-/* stub implementations that will be never called when RC-core is disabled */
-#if !defined(CONFIG_RC_CORE) && !defined(CONFIG_RC_CORE_MODULE)
-#define rc_repeat(args...)
-#define rc_keydown(args...)
-#define rc_keydown_notimeout(args...)
-#define rc_keyup(args...)
-#define rc_g_keycode_from_table(args...) 0
-#endif
-
 #endif
-- 
1.7.11.7

