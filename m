Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31017 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaCFEz1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 23:55:27 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N2000JNA0CD5Y70@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Mar 2014 13:55:25 +0900 (KST)
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, sachin.kamat@linaro.org
Cc: m.szyprowski@samsung.com, sw0312.kim@samsung.com
Subject: [PATCH v3] [media] s5p-mfc: remove meaningless memory bank assignment
Date: Thu, 06 Mar 2014 13:55:39 +0900
Message-id: <1394081739-23017-1-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <CAK9yfHx0o2n7fPvPeMHmMoLrP+ZifkP2uCitpatY8pFG-hDxCA@mail.gmail.com>
References: <CAK9yfHx0o2n7fPvPeMHmMoLrP+ZifkP2uCitpatY8pFG-hDxCA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes meaningless assignment of memory bank to itself.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
change from v2
- simplify description and change typo in subject
change from v1
- fixes subject and adds proper description
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 2475a3c..ee05f2d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -44,8 +44,6 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		return -ENOMEM;
 	}
 
-	dev->bank1 = dev->bank1;
-
 	if (HAS_PORTNUM(dev) && IS_TWOPORT(dev)) {
 		bank2_virt = dma_alloc_coherent(dev->mem_dev_r, 1 << MFC_BASE_ALIGN_ORDER,
 					&bank2_dma_addr, GFP_KERNEL);
-- 
1.7.4.1

