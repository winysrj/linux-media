Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:65237 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751596AbdIBSlR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 14:41:17 -0400
Subject: [PATCH 1/3] [media] cx18: Delete an error message for a failed memory
 allocation in cx18_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <016d4c9c-1d8e-e277-5d7c-f433553cf0fa@users.sourceforge.net>
Message-ID: <a47013ab-7738-b07b-5e01-1f3435d45a43@users.sourceforge.net>
Date: Sat, 2 Sep 2017 20:41:03 +0200
MIME-Version: 1.0
In-Reply-To: <016d4c9c-1d8e-e277-5d7c-f433553cf0fa@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 19:39:56 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/cx18/cx18-driver.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 8bce49cdad46..b267590e0877 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -913,8 +913,6 @@ static int cx18_probe(struct pci_dev *pci_dev,
-	if (cx == NULL) {
-		printk(KERN_ERR "cx18: cannot manage card %d, out of memory\n",
-		       i);
+	if (!cx)
 		return -ENOMEM;
-	}
+
 	cx->pci_dev = pci_dev;
 	cx->instance = i;
 
-- 
2.14.1
