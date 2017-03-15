Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:51700 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbdCOWW6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 18:22:58 -0400
From: Andreas Kemnade <andreas@kemnade.info>
To: crope@iki.fi, mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 3/3] [media] af9035: add Logilink vg0022a to device id table
Date: Wed, 15 Mar 2017 23:22:10 +0100
Message-Id: <1489616530-4025-4-git-send-email-andreas@kemnade.info>
In-Reply-To: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ths adds the logilink VG00022a dvb-t dongle to the device table.
The dongle contains (checked by removing the case)
IT9303
SI2168
  214730

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index a95f4b2..db93e59 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -2165,6 +2165,8 @@ static const struct usb_device_id af9035_id_table[] = {
 	/* IT930x devices */
 	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
 		&it930x_props, "ITE 9303 Generic", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x0100,
+		&it930x_props, "Logilink VG0022A", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
2.1.4
