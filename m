Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40300
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751489AbdFZMeo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 08:34:44 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mike Isely <isely@pobox.com>
Subject: [PATCH] media: pvrusb2: fix the retry logic
Date: Mon, 26 Jun 2017 09:33:56 -0300
Message-Id: <acd26dbca893cb72fb481dce3945c2831259c46a.1498480431.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by this warning:
	drivers/media/usb/pvrusb2/pvrusb2-encoder.c:263 pvr2_encoder_cmd() warn: continue to end of do { ... } while(0); loop

There's an issue at the retry logic there: the current logic is:

	do {
		if (need_to_retry)
			continue;

		some_code();
	} while (0);

Well, that won't work, as continue will make it test for zero, and
abort the loop. So, change the loop to:

	while (1) {
		if (need_to_retry)
			continue;

		some_code();
		break;
	};

With seems to be what's actually expected there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
index ca637074fa1f..43e43404095f 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
@@ -198,7 +198,7 @@ static int pvr2_encoder_cmd(void *ctxt,
 	}
 
 
-	LOCK_TAKE(hdw->ctl_lock); do {
+	LOCK_TAKE(hdw->ctl_lock); while (1) {
 
 		if (!hdw->state_encoder_ok) {
 			ret = -EIO;
@@ -293,9 +293,9 @@ rdData[0]);
 
 		wrData[0] = 0x0;
 		ret = pvr2_encoder_write_words(hdw,MBOX_BASE,wrData,1);
-		if (ret) break;
+		break;
 
-	} while(0); LOCK_GIVE(hdw->ctl_lock);
+	}; LOCK_GIVE(hdw->ctl_lock);
 
 	return ret;
 }
-- 
2.9.4
