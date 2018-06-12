Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34650 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754285AbeFLJmD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 05:42:03 -0400
From: Colin King <colin.king@canonical.com>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] [media] cx18: remove redundant zero check on retval
Date: Tue, 12 Jun 2018 10:42:00 +0100
Message-Id: <20180612094200.11545-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check for a zero retval is redundant as all paths that lead to
this point have set retval to an error return value that is non-zero.
Remove the redundant check.

Detected by CoverityScan, CID#102589 ("Logically dead code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/cx18/cx18-driver.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 8f314ca320c7..0c389a3fb4e5 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -1134,8 +1134,6 @@ static int cx18_probe(struct pci_dev *pci_dev,
 free_workqueues:
 	destroy_workqueue(cx->in_work_queue);
 err:
-	if (retval == 0)
-		retval = -ENODEV;
 	CX18_ERR("Error %d on initialization\n", retval);
 
 	v4l2_device_unregister(&cx->v4l2_dev);
-- 
2.17.0
