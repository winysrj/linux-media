Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235Ab3CSQur (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:47 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 14/46] [media] siano: always load smsdvb
Date: Tue, 19 Mar 2013 13:49:03 -0300
Message-Id: <1363711775-2120-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without smsdvb, the driver actually does nothing, as it
lacks the userspace API.

While I wrote it independently, in order to make a sms2270 board
I have here to work, this patch is functionally identical to this
patch from Doron Cohen:
	http://patchwork.linuxtv.org/patch/7894/

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/sms-cards.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index b22b61d..04bb04c 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -293,19 +293,7 @@ EXPORT_SYMBOL_GPL(sms_board_lna_control);
 
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
+	request_module("smsdvb");
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sms_board_load_modules);
-- 
1.8.1.4

