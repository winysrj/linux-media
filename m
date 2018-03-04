Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:37754 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752908AbeCDPt3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2018 10:49:29 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: alan@linux.intel.com
Cc: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 3/3] staging: media: Replace "dont" with "don't"
Date: Sun,  4 Mar 2018 21:18:27 +0530
Message-Id: <1520178507-25141-4-git-send-email-arushisinghal19971997@gmail.com>
In-Reply-To: <1520178507-25141-1-git-send-email-arushisinghal19971997@gmail.com>
References: <1520178507-25141-1-git-send-email-arushisinghal19971997@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace "dont" with "don't".
"Dont" is not same as "Do not" or "Don't".

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c b/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
index e36c2a3..f21075c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
@@ -450,7 +450,7 @@ static void mmu_l1_unmap(struct isp_mmu *mmu, phys_addr_t l1_pt,
 			ptr = end;
 		}
 		/*
-		 * use the same L2 page next time, so we dont
+		 * use the same L2 page next time, so we don't
 		 * need to invalidate and free this PT.
 		 */
 		/*      atomisp_set_pte(l1_pt, idx, NULL_PTE); */
-- 
2.7.4
