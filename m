Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145Ab3CSQuT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 13/46] [media] siano: fix the debug message
Date: Tue, 19 Mar 2013 13:49:02 -0300
Message-Id: <1363711775-2120-14-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of displaying this:
	[   61.869415] smscore_load_firmware_family2: rc=0, postload=0x          (null)

Display, instead:
	[ 1348.441160] smscore_load_firmware_family2: rc=0

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 250fe37..d5883bb 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -977,13 +977,16 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 	msleep(400);
 
 exit_fw_download:
-	sms_debug("rc=%d, postload=0x%p ", rc, coredev->postload_handler);
-
 	kfree(msg);
 
-	return ((rc >= 0) && coredev->postload_handler) ?
-		coredev->postload_handler(coredev->context) :
-		rc;
+	if (coredev->postload_handler) {
+		sms_debug("rc=%d, postload=0x%p", rc, coredev->postload_handler);
+		if (rc >= 0)
+			return coredev->postload_handler(coredev->context);
+	}
+
+	sms_debug("rc=%d", rc);
+	return rc;
 }
 
 
-- 
1.8.1.4

