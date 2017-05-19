Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36751 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755025AbdESNHP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 09:07:15 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, geert@linux-m68k.org,
        magnus.damm@gmail.com, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, sergei.shtylyov@cogentembedded.com,
        horms@verge.net.au, devicetree@vger.kernel.org,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v3 2/4] media: adv7180: add adv7180cp, adv7180st compatible strings
Date: Fri, 19 May 2017 15:07:02 +0200
Message-Id: <1495199224-16337-3-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used to differentiate between models with 3 and 6 inputs.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7180.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index bdbbf8c..78de7dd 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1452,6 +1452,8 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
 #ifdef CONFIG_OF
 static const struct of_device_id adv7180_of_id[] = {
 	{ .compatible = "adi,adv7180", },
+	{ .compatible = "adi,adv7180cp", },
+	{ .compatible = "adi,adv7180st", },
 	{ .compatible = "adi,adv7182", },
 	{ .compatible = "adi,adv7280", },
 	{ .compatible = "adi,adv7280-m", },
-- 
2.7.4
