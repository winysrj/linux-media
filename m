Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114Ab3CSRX6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 13:23:58 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/46] [media] siano: Add the new voltage definitions for GPIO
Date: Tue, 19 Mar 2013 13:48:51 -0300
Message-Id: <1363711775-2120-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those new definitions came from this patch, from Doron Cohen:
	http://patchwork.linuxtv.org/patch/7882/

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index a6d29a2..62f05e8 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -642,10 +642,22 @@ struct smscore_config_gpio {
 #define SMS_GPIO_OUTPUTSLEWRATE_SLOW 1
 	u8 outputslewrate;
 
+	/* 10xx */
 #define SMS_GPIO_OUTPUTDRIVING_S_4mA  0
 #define SMS_GPIO_OUTPUTDRIVING_S_8mA  1
 #define SMS_GPIO_OUTPUTDRIVING_S_12mA 2
 #define SMS_GPIO_OUTPUTDRIVING_S_16mA 3
+
+	/* 11xx*/
+#define SMS_GPIO_OUTPUTDRIVING_1_5mA	0
+#define SMS_GPIO_OUTPUTDRIVING_2_8mA	1
+#define SMS_GPIO_OUTPUTDRIVING_4mA	2
+#define SMS_GPIO_OUTPUTDRIVING_7mA	3
+#define SMS_GPIO_OUTPUTDRIVING_10mA	4
+#define SMS_GPIO_OUTPUTDRIVING_11mA	5
+#define SMS_GPIO_OUTPUTDRIVING_14mA	6
+#define SMS_GPIO_OUTPUTDRIVING_16mA	7
+
 	u8 outputdriving;
 };
 
-- 
1.8.1.4

