Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49449 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdIEPTs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Sep 2017 11:19:48 -0400
From: Colin King <colin.king@canonical.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cobalt: remove redundant zero check on retval
Date: Tue,  5 Sep 2017 16:19:44 +0100
Message-Id: <20170905151944.20491-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The error handling paths all end up with retval being non-zero,
so the check for retval being zero is always false and hence
is redundant. Remove it.

Detected by CoverityScan CID#1309479 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/cobalt/cobalt-driver.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 98b6cb9505d1..8487ecaa4d30 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -767,8 +767,6 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 err_wq:
 	destroy_workqueue(cobalt->irq_work_queues);
 err:
-	if (retval == 0)
-		retval = -ENODEV;
 	cobalt_err("error %d on initialization\n", retval);
 
 	v4l2_device_unregister(&cobalt->v4l2_dev);
-- 
2.14.1
