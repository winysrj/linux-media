Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37409 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751746AbdITHiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 03:38:19 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: p.zabel@pengutronix.de, mchehab@kernel.org, hans.verkuil@cisco.com,
        sean@mess.org, andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [media] cx23885: Handle return value of kasprintf
Date: Wed, 20 Sep 2017 13:07:13 +0530
Message-Id: <1505893033-7491-3-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1505893033-7491-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1505893033-7491-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kasprintf() can fail here and we must check its return value.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-input.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 944b7083..0f4e542 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -340,14 +340,23 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	kernel_ir->cx = dev;
 	kernel_ir->name = kasprintf(GFP_KERNEL, "cx23885 IR (%s)",
 				    cx23885_boards[dev->board].name);
+	if (!kernel_ir->name) {
+		ret = -ENOMEM;
+		goto err_out_free;
+	}
+
 	kernel_ir->phys = kasprintf(GFP_KERNEL, "pci-%s/ir0",
 				    pci_name(dev->pci));
+	if (!kernel_ir->phys) {
+		ret = -ENOMEM;
+		goto err_out_free_name;
+	}
 
 	/* input device */
 	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rc) {
 		ret = -ENOMEM;
-		goto err_out_free;
+		goto err_out_free_phys;
 	}
 
 	kernel_ir->rc = rc;
@@ -382,9 +391,11 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	cx23885_input_ir_stop(dev);
 	dev->kernel_ir = NULL;
 	rc_free_device(rc);
-err_out_free:
+err_out_free_phys:
 	kfree(kernel_ir->phys);
+err_out_free_name:
 	kfree(kernel_ir->name);
+err_out_free:
 	kfree(kernel_ir);
 	return ret;
 }
-- 
1.9.1
