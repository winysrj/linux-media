Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42207 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752809AbdC3Jkm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 05:40:42 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/atomisp: fix spelling mistake: "falied" -> "failed"
Date: Thu, 30 Mar 2017 10:40:36 +0100
Message-Id: <20170330094036.19049-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in dev_err error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo_dev.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo_dev.c
index 87090cea5b9d..d22a2d2388c2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo_dev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo_dev.c
@@ -59,7 +59,7 @@ int hmm_bo_device_init(struct hmm_bo_device *bdev,
 
 	ret = hmm_vm_init(&bdev->vaddr_space, vaddr_start, size);
 	if (ret) {
-		dev_err(atomisp_dev, "hmm_vm_init falied. vaddr_start = 0x%x, size = %d\n",
+		dev_err(atomisp_dev, "hmm_vm_init failed. vaddr_start = 0x%x, size = %d\n",
 			vaddr_start, size);
 		goto vm_init_err;
 	}
-- 
2.11.0
