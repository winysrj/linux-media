Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34307 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752742AbdGCInu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 04:43:50 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org, geert@linux-m68k.org
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        magnus.damm@gmail.com, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, sergei.shtylyov@cogentembedded.com,
        horms@verge.net.au, devicetree@vger.kernel.org,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH] media: adv7180: add missing adv7180cp, adv7180st i2c device IDs
Date: Mon,  3 Jul 2017 10:43:33 +0200
Message-Id: <1499071413-609-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes a crash on Renesas R8A7793 Gose board that uses these "compatible"
entries.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7180.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 78de7dd..3df28f2 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1402,6 +1402,8 @@ static int adv7180_remove(struct i2c_client *client)
 
 static const struct i2c_device_id adv7180_id[] = {
 	{ "adv7180", (kernel_ulong_t)&adv7180_info },
+	{ "adv7180cp", (kernel_ulong_t)&adv7180_info },
+	{ "adv7180st", (kernel_ulong_t)&adv7180_info },
 	{ "adv7182", (kernel_ulong_t)&adv7182_info },
 	{ "adv7280", (kernel_ulong_t)&adv7280_info },
 	{ "adv7280-m", (kernel_ulong_t)&adv7280_m_info },
-- 
2.7.4
