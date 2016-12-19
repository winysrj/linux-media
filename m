Return-path: <linux-media-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28805 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750793AbcLSGp3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 01:45:29 -0500
From: Cao jin <caoj.fnst@cn.fujitsu.com>
To: <linux-media@vger.kernel.org>
CC: <mchehab@kernel.org>
Subject: [PATCH] ngene: drop ngene_link_reset()
Date: Mon, 19 Dec 2016 14:49:53 +0800
Message-ID: <1482130193-19319-1-git-send-email-caoj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In AER recovery, pci_error_handlers.link_reset() is never called,
drop it now.

Signed-off-by: Cao jin <caoj.fnst@cn.fujitsu.com>
---
 drivers/media/pci/ngene/ngene-cards.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 423e8c889310..8438c1c8acde 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -781,12 +781,6 @@ static pci_ers_result_t ngene_error_detected(struct pci_dev *dev,
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-static pci_ers_result_t ngene_link_reset(struct pci_dev *dev)
-{
-	printk(KERN_INFO DEVICE_NAME ": link reset\n");
-	return 0;
-}
-
 static pci_ers_result_t ngene_slot_reset(struct pci_dev *dev)
 {
 	printk(KERN_INFO DEVICE_NAME ": slot reset\n");
@@ -800,7 +794,6 @@ static void ngene_resume(struct pci_dev *dev)
 
 static const struct pci_error_handlers ngene_errors = {
 	.error_detected = ngene_error_detected,
-	.link_reset = ngene_link_reset,
 	.slot_reset = ngene_slot_reset,
 	.resume = ngene_resume,
 };
-- 
2.1.0



