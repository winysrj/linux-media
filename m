Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110806.mail.gq1.yahoo.com ([67.195.13.229]:21573 "HELO
	web110806.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752371AbZCLNKn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 09:10:43 -0400
Message-ID: <556868.10053.qm@web110806.mail.gq1.yahoo.com>
Date: Thu, 12 Mar 2009 06:10:40 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH 1/1] sdio: add cards ids for sms (Siano Mobile Silicon) MDTV receivers
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


sdio: add cards id for sms (Siano Mobile Silicon) MDTV receivers

From: Uri Shkolnik <uris@siano-ms.com>

Add SDIO vendor ID, and multiple device IDs for 
various SMS-based MDTV SDIO adapters.

The patch has been done against 2.6.29-rc7 .

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>


diff -uNr linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_ids.h linux-2.6.29-rc7_sdio_patch/include/linux/mmc/sdio_ids.h
--- linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_ids.h	2009-03-04 03:05:22.000000000 +0200
+++ linux-2.6.29-rc7_sdio_patch/include/linux/mmc/sdio_ids.h	2009-03-12 12:24:14.000000000 +0200
@@ -24,6 +24,14 @@
  */
 
 #define SDIO_VENDOR_ID_MARVELL			0x02df
+#define SDIO_VENDOR_ID_SIANO			0x039a
+
 #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103
+#define SDIO_DEVICE_ID_SIANO_STELLAR 		0x5347
+#define SDIO_DEVICE_ID_SIANO_NOVA_A0		0x1100
+#define SDIO_DEVICE_ID_SIANO_NOVA_B0		0x0201
+#define SDIO_DEVICE_ID_SIANO_NICE		0x0202
+#define SDIO_DEVICE_ID_SIANO_VEGA_A0		0x0300
+#define SDIO_DEVICE_ID_SIANO_VENICE		0x0301
 
 #endif



      
