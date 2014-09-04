Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52487 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079AbaIDChE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:04 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 28/37] af9035: replace PCTV device model numbers with name
Date: Thu,  4 Sep 2014 05:36:36 +0300
Message-Id: <1409798205-25645-28-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use device names for recent PCTV Systems devices:
PCTV AndroiDTV (78e)
PCTV microStick (79e)

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index b491707..94563b2 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1728,9 +1728,9 @@ static const struct usb_device_id af9035_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_HAUPPAUGE, 0xf900,
 		&af9035_props, "Hauppauge WinTV-MiniStick 2", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_PCTV, USB_PID_PCTV_78E,
-		&af9035_props, "PCTV 78e", RC_MAP_IT913X_V1) },
+		&af9035_props, "PCTV AndroiDTV (78e)", RC_MAP_IT913X_V1) },
 	{ DVB_USB_DEVICE(USB_VID_PCTV, USB_PID_PCTV_79E,
-		&af9035_props, "PCTV 79e", RC_MAP_IT913X_V2) },
+		&af9035_props, "PCTV microStick (79e)", RC_MAP_IT913X_V2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
http://palosaari.fi/

