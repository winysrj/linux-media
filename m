Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:48711 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932931AbdKPEit (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 23:38:49 -0500
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: david@hardeman.nu, mchehab@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] [media] winbond-cir: Fix pnp_irq's error checking for wbcir_probe
Date: Thu, 16 Nov 2017 10:07:51 +0530
Message-Id: <72c69922ccb3b83c47d0a824bdaeba335ab1cdb5.1510806986.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pnp_irq() function returns -1 if an error occurs.
pnp_irq() error checking for zero is not correct.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/rc/winbond-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 3ca7ab4..0adf099 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1044,7 +1044,7 @@ struct wbcir_data {
 	data->irq = pnp_irq(device, 0);
 
 	if (data->wbase == 0 || data->ebase == 0 ||
-	    data->sbase == 0 || data->irq == 0) {
+	    data->sbase == 0 || data->irq == -1) {
 		err = -ENODEV;
 		dev_err(dev, "Invalid resources\n");
 		goto exit_free_data;
-- 
1.9.1
