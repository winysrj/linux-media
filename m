Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:46281 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0AMUAJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 15:00:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: [PATCH 1/1] media: dvb-usb/af9015, add IR support for digivox mini II
Date: Wed, 13 Jan 2010 21:00:07 +0100
Message-Id: <1263412807-23350-1-git-send-email-jslaby@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MSI digivox mini II works even with remote=2 module parameter. Check
for manufacturer and if it is Afatech, use af9015_ir_table_msi and
af9015_rc_keys_msi.

The device itself is 15a4:9016.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-usb/af9015.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 8b60a60..f0d5731 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -835,9 +835,15 @@ static int af9015_read_config(struct usb_device *udev)
 					  af9015_ir_table_mygictv;
 					af9015_config.ir_table_size =
 					  ARRAY_SIZE(af9015_ir_table_mygictv);
-				} else if (!strcmp("MSI", manufacturer)) {
-					/* iManufacturer 1 MSI
-					   iProduct      2 MSI K-VOX */
+				} else if (!strcmp("MSI", manufacturer) ||
+					   !strcmp("Afatech", manufacturer)) {
+					/*
+					   iManufacturer 1 MSI
+					   iProduct      2 MSI K-VOX
+					   iManufacturer 1 Afatech
+					   iProduct      2 DVB-T 2
+					 */
+
 					af9015_properties[i].rc_key_map =
 					  af9015_rc_keys_msi;
 					af9015_properties[i].rc_key_map_size =
-- 
1.6.5.7

