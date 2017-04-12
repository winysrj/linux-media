Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43182 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754745AbdDLSUO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:20:14 -0400
Subject: [PATCH 02/14] staging/atomisp: fix spelling mistake: "falied" ->
 "failed"
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:20:10 +0100
Message-ID: <149202120800.16615.8247031346769358396.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in dev_err error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo_dev.c    |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo_dev.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo_dev.c
index 87090ce..d22a2d2 100644
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
