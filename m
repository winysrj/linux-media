Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38043 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab0JTJg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 05:36:28 -0400
Received: by mail-bw0-f46.google.com with SMTP id 10so1123351bwz.19
        for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 02:36:27 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 6/6] Staging: tm6000: Delete braces from return in tm6000-cards.c
Date: Wed, 20 Oct 2010 12:36:18 +0300
Message-Id: <1287567378-18964-1-git-send-email-ruslan@rpisarev.org.ua>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the tm6000-cards.c file that fixed up
a space error found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/tm6000/tm6000-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 3064d0c..d61b517 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -349,7 +349,7 @@ int tm6000_xc5000_callback(void *ptr, int component, int command, int arg)
 			       dev->gpio.tuner_reset, 0x01);
 		break;
 	}
-	return (rc);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tm6000_xc5000_callback);
 
-- 
1.7.0.4

