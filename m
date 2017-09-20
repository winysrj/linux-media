Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:56812 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751688AbdITGhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 02:37:55 -0400
Subject: [PATCH 2/3] [media] pvrusb2-ioread: Delete an unnecessary check
 before kfree() in two functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c8117427-6d4d-0a1c-96c7-56e25d838b3e@users.sourceforge.net>
Message-ID: <a5db4b79-6b02-b49b-a618-fcb0f0ea762c@users.sourceforge.net>
Date: Wed, 20 Sep 2017 08:37:47 +0200
MIME-Version: 1.0
In-Reply-To: <c8117427-6d4d-0a1c-96c7-56e25d838b3e@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 19 Sep 2017 22:12:49 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: kfree(NULL) is safe and this check is probably not required

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
index 0218614ce988..4349f9b5f838 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
@@ -98,10 +98,8 @@ void pvr2_ioread_destroy(struct pvr2_ioread *cp)
 	if (!cp) return;
 	pvr2_ioread_done(cp);
 	pvr2_trace(PVR2_TRACE_STRUCT,"pvr2_ioread_destroy id=%p",cp);
-	if (cp->sync_key_ptr) {
-		kfree(cp->sync_key_ptr);
-		cp->sync_key_ptr = NULL;
-	}
+	kfree(cp->sync_key_ptr);
+	cp->sync_key_ptr = NULL;
 	kfree(cp);
 }
 
@@ -117,10 +115,8 @@ void pvr2_ioread_set_sync_key(struct pvr2_ioread *cp,
 	     (!memcmp(sync_key_ptr,cp->sync_key_ptr,sync_key_len)))) return;
 
 	if (sync_key_len != cp->sync_key_len) {
-		if (cp->sync_key_ptr) {
-			kfree(cp->sync_key_ptr);
-			cp->sync_key_ptr = NULL;
-		}
+		kfree(cp->sync_key_ptr);
+		cp->sync_key_ptr = NULL;
 		cp->sync_key_len = 0;
 		if (sync_key_len) {
 			cp->sync_key_ptr = kmalloc(sync_key_len,GFP_KERNEL);
-- 
2.14.1
