Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:64935 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaGWAw0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 20:52:26 -0400
From: Zhaowei Yuan <zhaowei.yuan@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org,
	Zhaowei Yuan <zhaowei.yuan@samsung.com>
Subject: [PATCH] media: s5p_mfc: Check the right pointer after allocation
Date: Wed, 23 Jul 2014 08:48:45 +0800
Message-id: <1406076525-5683-1-git-send-email-zhaowei.yuan@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It should be bank2_virt to be checked after dma allocation
instead of dev->fw_virt_addr.

Change-Id: I03ed5603de3ef1d97bf76d7d42097d9489b6b003
Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index dc1fc94..55ad881 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -50,7 +50,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		bank2_virt = dma_alloc_coherent(dev->mem_dev_r, 1 << MFC_BASE_ALIGN_ORDER,
 					&bank2_dma_addr, GFP_KERNEL);

-		if (IS_ERR(dev->fw_virt_addr)) {
+		if (IS_ERR(bank2_virt)) {
 			mfc_err("Allocating bank2 base failed\n");
 			dma_free_coherent(dev->mem_dev_l, dev->fw_size,
 				dev->fw_virt_addr, dev->bank1);
--
1.7.9.5

