Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:62318 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752694AbdIBSnT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 14:43:19 -0400
Subject: [PATCH 3/3] [media] cx18: Adjust ten checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <016d4c9c-1d8e-e277-5d7c-f433553cf0fa@users.sourceforge.net>
Message-ID: <57bf3409-b4b2-9771-ff81-13768d460d4d@users.sourceforge.net>
Date: Sat, 2 Sep 2017 20:43:06 +0200
MIME-Version: 1.0
In-Reply-To: <016d4c9c-1d8e-e277-5d7c-f433553cf0fa@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 19:49:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/cx18/cx18-driver.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 49fc9b72ada5..c29e8ec880b3 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -255,7 +255,7 @@ static void request_module_async(struct work_struct *work)
 	request_module("cx18-alsa");
 
 	/* Initialize cx18-alsa for this instance of the cx18 device */
-	if (cx18_ext_init != NULL)
+	if (cx18_ext_init)
 		cx18_ext_init(dev);
 }
 
@@ -291,11 +291,11 @@ int cx18_msleep_timeout(unsigned int msecs, int intr)
 /* Release ioremapped memory */
 static void cx18_iounmap(struct cx18 *cx)
 {
-	if (cx == NULL)
+	if (!cx)
 		return;
 
 	/* Release io memory */
-	if (cx->enc_mem != NULL) {
+	if (cx->enc_mem) {
 		CX18_DEBUG_INFO("releasing enc_mem\n");
 		iounmap(cx->enc_mem);
 		cx->enc_mem = NULL;
@@ -649,15 +649,15 @@ static void cx18_process_options(struct cx18 *cx)
 		CX18_INFO("User specified %s card\n", cx->card->name);
 	else if (cx->options.cardtype != 0)
 		CX18_ERR("Unknown user specified type, trying to autodetect card\n");
-	if (cx->card == NULL) {
+	if (!cx->card) {
 		if (cx->pci_dev->subsystem_vendor == CX18_PCI_ID_HAUPPAUGE) {
 			cx->card = cx18_get_card(CX18_CARD_HVR_1600_ESMT);
 			CX18_INFO("Autodetected Hauppauge card\n");
 		}
 	}
-	if (cx->card == NULL) {
+	if (!cx->card) {
 		for (i = 0; (cx->card = cx18_get_card(i)); i++) {
-			if (cx->card->pci_list == NULL)
+			if (!cx->card->pci_list)
 				continue;
 			for (j = 0; cx->card->pci_list[j].device; j++) {
 				if (cx->pci_dev->device !=
@@ -676,7 +676,7 @@ static void cx18_process_options(struct cx18 *cx)
 	}
 done:
 
-	if (cx->card == NULL) {
+	if (!cx->card) {
 		cx->card = cx18_get_card(CX18_CARD_HVR_1600_ESMT);
 		CX18_ERR("Unknown card: vendor/device: [%04x:%04x]\n",
 			 cx->pci_dev->vendor, cx->pci_dev->device);
@@ -698,7 +698,7 @@ static int cx18_create_in_workq(struct cx18 *cx)
 	snprintf(cx->in_workq_name, sizeof(cx->in_workq_name), "%s-in",
 		 cx->v4l2_dev.name);
 	cx->in_work_queue = alloc_ordered_workqueue("%s", 0, cx->in_workq_name);
-	if (cx->in_work_queue == NULL) {
+	if (!cx->in_work_queue) {
 		CX18_ERR("Unable to create incoming mailbox handler thread\n");
 		return -ENOMEM;
 	}
@@ -1254,7 +1254,7 @@ static void cx18_cancel_out_work_orders(struct cx18 *cx)
 {
 	int i;
 	for (i = 0; i < CX18_MAX_STREAMS; i++)
-		if (&cx->streams[i].video_dev != NULL)
+		if (&cx->streams[i].video_dev)
 			cancel_work_sync(&cx->streams[i].out_work_order);
 }
 
@@ -1299,7 +1299,7 @@ static void cx18_remove(struct pci_dev *pci_dev)
 
 	pci_disable_device(cx->pci_dev);
 
-	if (cx->vbi.sliced_mpeg_data[0] != NULL)
+	if (cx->vbi.sliced_mpeg_data[0])
 		for (i = 0; i < CX18_VBI_FRAMES; i++)
 			kfree(cx->vbi.sliced_mpeg_data[i]);
 
-- 
2.14.1
