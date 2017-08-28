Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:50388 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbdH1LQ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 07:16:29 -0400
Subject: [PATCH 3/3] [media] Siano: Adjust five checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <386b5a60-548e-1896-5271-4875fa2aea94@users.sourceforge.net>
Message-ID: <2000da6b-ca21-18a1-dc04-d2b127084153@users.sourceforge.net>
Date: Mon, 28 Aug 2017 13:16:21 +0200
MIME-Version: 1.0
In-Reply-To: <386b5a60-548e-1896-5271-4875fa2aea94@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Aug 2017 12:50:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/common/siano/smscoreapi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index ad1c41f727b1..e4ea2a0c7a24 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -749,7 +749,7 @@ static int smscore_sendrequest_and_wait(struct smscore_device_t *coredev,
 		void *buffer, size_t size, struct completion *completion) {
 	int rc;
 
-	if (completion == NULL)
+	if (!completion)
 		return -EINVAL;
 	init_completion(completion);
 
@@ -1151,8 +1151,8 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 	}
 	pr_debug("Firmware name: %s\n", fw_filename);
 
-	if (loadfirmware_handler == NULL && !(coredev->device_flags
-			& SMS_DEVICE_FAMILY2))
+	if (!loadfirmware_handler &&
+	    !(coredev->device_flags & SMS_DEVICE_FAMILY2))
 		return -EINVAL;
 
 	rc = request_firmware(&fw, fw_filename, coredev->device);
@@ -1789,7 +1789,7 @@ int smsclient_sendrequest(struct smscore_client_t *client,
 	struct sms_msg_hdr *phdr = (struct sms_msg_hdr *) buffer;
 	int rc;
 
-	if (client == NULL) {
+	if (!client) {
 		pr_err("Got NULL client\n");
 		return -EINVAL;
 	}
@@ -1797,7 +1797,7 @@ int smsclient_sendrequest(struct smscore_client_t *client,
 	coredev = client->coredev;
 
 	/* check that no other channel with same id exists */
-	if (coredev == NULL) {
+	if (!coredev) {
 		pr_err("Got NULL coredev\n");
 		return -EINVAL;
 	}
@@ -1954,7 +1954,7 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 pin_num,
 	if (pin_num > MAX_GPIO_PIN_NUMBER)
 		return -EINVAL;
 
-	if (p_gpio_config == NULL)
+	if (!p_gpio_config)
 		return -EINVAL;
 
 	total_len = sizeof(struct sms_msg_hdr) + (sizeof(u32) * 6);
-- 
2.14.1
