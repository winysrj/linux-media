Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:44357 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2IQMyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 08:54:03 -0400
Date: Mon, 17 Sep 2012 14:53:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: linux-media@vger.kernel.org
Cc: Stefan Ringel <linuxtv@stefanringel.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] cx23885: Select drivers for Terratec Cinergy T PCIe
 Dual
Message-ID: <20120917145353.6a98e115@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Terratec Cinergy T PCIe Dual is based on the CX23885, and uses
MT2063, DRX-3913k and DRX-3916k chips, so select the relevant drivers.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Stefan Ringel <linuxtv@stefanringel.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/video/cx23885/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-3.6-rc5.orig/drivers/media/video/cx23885/Kconfig	2012-07-21 22:58:29.000000000 +0200
+++ linux-3.6-rc5/drivers/media/video/cx23885/Kconfig	2012-09-13 15:57:13.833548830 +0200
@@ -23,7 +23,9 @@ config VIDEO_CX23885
 	select DVB_STV0900 if !DVB_FE_CUSTOMISE
 	select DVB_DS3000 if !DVB_FE_CUSTOMISE
 	select DVB_STV0367 if !DVB_FE_CUSTOMISE
+	select DVB_DRXK if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_MT2131 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_MT2063 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE


-- 
Jean Delvare
