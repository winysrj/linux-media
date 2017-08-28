Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:54028 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751194AbdH1LOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 07:14:48 -0400
Subject: [PATCH 1/3] [media] Siano: Delete an error message for a failed
 memory allocation in three functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <386b5a60-548e-1896-5271-4875fa2aea94@users.sourceforge.net>
Message-ID: <11f54f52-6ba0-3432-0544-b71cd3d36b74@users.sourceforge.net>
Date: Mon, 28 Aug 2017 13:14:30 +0200
MIME-Version: 1.0
In-Reply-To: <386b5a60-548e-1896-5271-4875fa2aea94@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Aug 2017 12:30:11 +0200

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/common/siano/smscoreapi.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index e7a0d7798d5b..889b486fbc72 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1304,7 +1304,5 @@ static int smscore_init_device(struct smscore_device_t *coredev, int mode)
-	if (!buffer) {
-		pr_err("Could not allocate buffer for init device message.\n");
+	if (!buffer)
 		return -ENOMEM;
-	}
 
 	msg = (struct sms_msg_data *)SMS_ALIGN_ADDRESS(buffer);
 	SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_INIT_DEVICE_REQ,
@@ -1690,7 +1688,6 @@ static int smscore_validate_client(struct smscore_device_t *coredev,
-	if (!listentry) {
-		pr_err("Can't allocate memory for client id.\n");
+	if (!listentry)
 		return -ENOMEM;
-	}
+
 	listentry->id = id;
 	listentry->data_type = data_type;
 	list_add_locked(&listentry->entry, &client->idlist,
@@ -1728,7 +1725,5 @@ int smscore_register_client(struct smscore_device_t *coredev,
-	if (!newclient) {
-		pr_err("Failed to allocate memory for client.\n");
+	if (!newclient)
 		return -ENOMEM;
-	}
 
 	INIT_LIST_HEAD(&newclient->idlist);
 	newclient->coredev = coredev;
-- 
2.14.1
