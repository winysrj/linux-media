Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47523 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3GWPvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 11:51:01 -0400
Received: by mail-pd0-f181.google.com with SMTP id 14so8266543pdj.26
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 08:51:01 -0700 (PDT)
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Cc: Chris Lee <updatelee@gmail.com>
Subject: [PATCH] gp8psk: add systems supported by genpix devices to .delsys
Date: Tue, 23 Jul 2013 09:50:49 -0600
Message-Id: <1374594649-6061-1-git-send-email-updatelee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/usb/dvb-usb/gp8psk-fe.c | 2 +-
 include/uapi/linux/dvb/frontend.h     | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
index 223a3ca..fcdf82c 100644
--- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/usb/dvb-usb/gp8psk-fe.c
@@ -333,7 +333,7 @@ success:
 
 
 static struct dvb_frontend_ops gp8psk_fe_ops = {
-	.delsys = { SYS_DVBS },
+	.delsys = { SYS_DCII_C_QPSK, SYS_DCII_I_QPSK, SYS_DCII_Q_QPSK, SYS_DCII_C_OQPSK, SYS_DSS, SYS_DVBS2, SYS_TURBO, SYS_DVBS },
 	.info = {
 		.name			= "Genpix DVB-S",
 		.frequency_min		= 800000,
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c56d77c..ada08a8 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -410,6 +410,10 @@ typedef enum fe_delivery_system {
 	SYS_DVBT2,
 	SYS_TURBO,
 	SYS_DVBC_ANNEX_C,
+	SYS_DCII_C_QPSK,
+	SYS_DCII_I_QPSK,
+	SYS_DCII_Q_QPSK,
+	SYS_DCII_C_OQPSK,
 } fe_delivery_system_t;
 
 /* backward compatibility */
-- 
1.8.1.2

