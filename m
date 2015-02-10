Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:11583 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbbBJKkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2015 05:40:24 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH] rc: img-ir: fix error in parameters passed to irq_free()
Date: Tue, 10 Feb 2015 10:41:56 +0000
Message-ID: <1423564916-29805-1-git-send-email-sifan.naeem@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

img_ir_remove() passes a pointer to the ISR function as the 2nd
parameter to irq_free() instead of a pointer to the device data
structure.
This issue causes unloading img-ir module to fail with the below
warning after building and loading img-ir as a module.

WARNING: CPU: 2 PID: 155 at ../kernel/irq/manage.c:1278
__free_irq+0xb4/0x214() Trying to free already-free IRQ 58
Modules linked in: img_ir(-)
CPU: 2 PID: 155 Comm: rmmod Not tainted 3.14.0 #55 ...
Call Trace:
...
[<8048d420>] __free_irq+0xb4/0x214
[<8048d6b4>] free_irq+0xac/0xf4
[<c009b130>] img_ir_remove+0x54/0xd4 [img_ir] [<8073ded0>]
platform_drv_remove+0x30/0x54 ...

Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
Fixes: 160a8f8aec4d ("[media] rc: img-ir: add base driver")
Cc: <stable@vger.kernel.org> # 3.15+
---
 drivers/media/rc/img-ir/img-ir-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/img-ir/img-ir-core.c
index 77c78de..7020659 100644
--- a/drivers/media/rc/img-ir/img-ir-core.c
+++ b/drivers/media/rc/img-ir/img-ir-core.c
@@ -146,7 +146,7 @@ static int img_ir_remove(struct platform_device *pdev)
 {
 	struct img_ir_priv *priv = platform_get_drvdata(pdev);
 
-	free_irq(priv->irq, img_ir_isr);
+	free_irq(priv->irq, priv);
 	img_ir_remove_hw(priv);
 	img_ir_remove_raw(priv);
 
-- 
1.7.9.5

