Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab3CSQtq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:49:46 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/46] [media] siano: Properly initialize board information
Date: Tue, 19 Mar 2013 13:48:56 -0300
Message-Id: <1363711775-2120-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Board #0 is an existing one. Instead of initializing the driver
with it, use a different value to detect if board is unknown.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 4c83d3c..7377c16 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -723,6 +723,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
 	sms_info("allocated %d buffers", dev->num_buffers);
 
 	dev->mode = DEVICE_MODE_NONE;
+	dev->board_id = SMS_BOARD_UNKNOWN;
 	dev->context = params->context;
 	dev->device = params->device;
 	dev->setmode_handler = params->setmode_handler;
-- 
1.8.1.4

