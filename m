Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3CSRnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 13:43:47 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/46] [media] siano: add additional attributes to cards entries
Date: Tue, 19 Mar 2013 13:48:57 -0300
Message-Id: <1363711775-2120-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those attributes will be used by the newer sms2xxx cards.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/sms-cards.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/common/siano/sms-cards.h b/drivers/media/common/siano/sms-cards.h
index d8cdf75..60d26be 100644
--- a/drivers/media/common/siano/sms-cards.h
+++ b/drivers/media/common/siano/sms-cards.h
@@ -79,6 +79,12 @@ struct sms_board {
 
 	/* gpios */
 	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
+
+	char intf_num;
+	int default_mode;
+	unsigned int mtu;
+	unsigned int crystal;
+	struct sms_antenna_config_ST* antenna_config;
 };
 
 struct sms_board *sms_get_board(unsigned id);
-- 
1.8.1.4

