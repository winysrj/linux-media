Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40827 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbaAPMJZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 07:09:25 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC] af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2
Date: Thu, 16 Jan 2014 14:08:05 +0200
Message-Id: <1389874085-3538-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Few weeks ago someone reported there is Hauppauge WinTV-MiniStick 2
with USB ID 2040:f900 and it is build upon IT9135 chipset.
Unfortunately he wasn't able to test and eventually disappeared.
So here is the patch, which very likely works, waiting for someone
to test.

Please test and report, after that I could submit it to upstream.

Here is the tree (or just apply that single patch)
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_hauppauge

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 8f9b2cea..8ede8ea 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1539,6 +1539,8 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a05,
 		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_HAUPPAUGE, 0xf900,
+		&af9035_props, "Hauppauge WinTV-MiniStick 2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
1.8.4.2

