Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110815.mail.gq1.yahoo.com ([67.195.13.238]:46583 "HELO
	web110815.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752641AbZEQJCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 05:02:46 -0400
Message-ID: <16292.18803.qm@web110815.mail.gq1.yahoo.com>
Date: Sun, 17 May 2009 02:02:46 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_29] Siano: smscore - bug fix at get_device_mode
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242332841 -10800
# Node ID 211989f20f803bc5a719c6fda4640888e379d6fc
# Parent  7e56c108996ef016c4b2117090e2577aea9ed56c
[0905_29] Siano: smscore - bug fix at get_device_mode

From: Uri Shkolnik <uris@siano-ms.com>

Fix bug that cause error log to echo also if success

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 7e56c108996e -r 211989f20f80 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 23:24:44 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 23:27:21 2009 +0300
@@ -938,7 +938,7 @@ int smscore_set_device_mode(struct smsco
 		coredev->device_flags &= ~SMS_DEVICE_NOT_READY;
 	}
 
-	if (rc != 0)
+	if (rc < 0)
 		sms_err("return error code %d.", rc);
 	return rc;
 }



      
