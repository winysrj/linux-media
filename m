Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054Ab3CSQuP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:15 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/46] [media] siano: report the choosed firmware in debug
Date: Tue, 19 Mar 2013 13:49:01 -0300
Message-Id: <1363711775-2120-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't keep in the dark: report the firmware file name after
lookup. That helps to debug what's happening when a firmware is not
found.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 74a2cb5..250fe37 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1010,6 +1010,7 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 	const struct firmware *fw;
 
 	char *fw_filename = smscore_get_fw_filename(coredev, mode, lookup);
+	sms_debug("Firmware name: %s\n", fw_filename);
 	if (!strcmp(fw_filename, "none"))
 		return -ENOENT;
 
-- 
1.8.1.4

