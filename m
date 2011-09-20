Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6307 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932161Ab1ITKTY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:19:24 -0400
Subject: [PATCH  17/17]DVB:Siano drivers - Automatically load client
 modules to make easier usage of device
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:32:07 +0300
Message-ID: <1316514727.5199.95.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch step makes Automatically load client modules to make easier
usage of device
Thanks,
Doron Cohen

-----------------------
>From 82afa26fc1fb9db798e46de0c55b49fd1bda9580 Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Tue, 20 Sep 2011 09:39:02 +0300
Subject: [PATCH 21/21] Automatically load client modules to make easier
usage of device

---
 drivers/media/dvb/siano/sms-cards.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/siano/sms-cards.c
b/drivers/media/dvb/siano/sms-cards.c
index 66b302e..378c25d 100644
--- a/drivers/media/dvb/siano/sms-cards.c
+++ b/drivers/media/dvb/siano/sms-cards.c
@@ -458,19 +458,10 @@ EXPORT_SYMBOL_GPL(sms_board_lna_control);
 
 int sms_board_load_modules(int id)
 {
-	switch (id) {
-	case SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT:
-	case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A:
-	case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B:
-	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
-	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
-	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
-		request_module("smsdvb");
-		break;
-	default:
-		/* do nothing */
-		break;
-	}
+	/* Siano smsmdtv loads all other supported "client" modules*/
+	request_module("smsdvb");
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sms_board_load_modules);
-- 
1.7.4.1

