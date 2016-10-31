Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:60549 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945225AbcJaRwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:52:31 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/9] [media] winbond-cir: use name without space for pnp driver
Date: Mon, 31 Oct 2016 17:52:19 +0000
Message-Id: <1477936347-9029-2-git-send-email-sean@mess.org>
In-Reply-To: <1477936347-9029-1-git-send-email-sean@mess.org>
References: <1477936347-9029-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the pnp driver in sysfs from /sys/bus/pnp/drivers/Winbond CIR
to /sys/bus/pnp/drivers/winbond-cir

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index cdcd6e3..1ccb6bb 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1185,7 +1185,7 @@ static const struct pnp_device_id wbcir_ids[] = {
 MODULE_DEVICE_TABLE(pnp, wbcir_ids);
 
 static struct pnp_driver wbcir_driver = {
-	.name     = WBCIR_NAME,
+	.name     = DRVNAME,
 	.id_table = wbcir_ids,
 	.probe    = wbcir_probe,
 	.remove   = wbcir_remove,
-- 
2.7.4

