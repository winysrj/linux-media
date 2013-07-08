Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:38231 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab3GHVlP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jul 2013 17:41:15 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] rc: allowed_protos now is a bit field
Date: Mon,  8 Jul 2013 22:33:10 +0100
Message-Id: <1373319192-26816-3-git-send-email-sean@mess.org>
In-Reply-To: <1373319192-26816-1-git-send-email-sean@mess.org>
References: <1373319192-26816-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one must have missed the conversion "c003ab1b [media] rc-core:
add separate defines for protocol bitmaps and numbers".

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/usb/dvb-usb/m920x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index c2b635d..0306cb7 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -1212,7 +1212,7 @@ static struct dvb_usb_device_properties vp7049_properties = {
 		.rc_interval    = 150,
 		.rc_codes       = RC_MAP_TWINHAN_VP1027_DVBS,
 		.rc_query       = m920x_rc_core_query,
-		.allowed_protos = RC_TYPE_UNKNOWN,
+		.allowed_protos = RC_BIT_UNKNOWN,
 	},
 
 	.size_of_priv     = sizeof(struct m920x_state),
-- 
1.8.3.1

