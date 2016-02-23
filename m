Return-path: <linux-media-owner@vger.kernel.org>
Received: from jusst.de ([188.40.114.84]:45517 "EHLO web01.jusst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbcBWVLt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 16:11:49 -0500
From: Julian Scheel <julian@jusst.de>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	lars@metafoo.de, hverkuil@xs4all.nl
Cc: Julian Scheel <julian@jusst.de>
Subject: [PATCHv2 2/2] media: adv7180: Add of compatible strings for full family
Date: Tue, 23 Feb 2016 22:11:21 +0100
Message-Id: <1456261881-28172-2-git-send-email-julian@jusst.de>
In-Reply-To: <1456261881-28172-1-git-send-email-julian@jusst.de>
References: <1456261881-28172-1-git-send-email-julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add entries for all supported chip variants into the of_match list, so that
the matching driver_info can be selected when using dt.

Signed-off-by: Julian Scheel <julian@jusst.de>
---
 Documentation/devicetree/bindings/media/i2c/adv7180.txt | 13 +++++++++++--
 drivers/media/i2c/adv7180.c                             |  8 ++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7180.txt b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
index 2f39f26..0d50115 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7180.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
@@ -1,10 +1,19 @@
 * Analog Devices ADV7180 analog video decoder family
 
 The adv7180 family devices are used to capture analog video to different
-digital interfaces like parallel video.
+digital interfaces like MIPI CSI-2 or parallel video.
 
 Required Properties :
-- compatible : value must be "adi,adv7180"
+- compatible : value must be one of
+		"adi,adv7180"
+		"adi,adv7182"
+		"adi,adv7280"
+		"adi,adv7280-m"
+		"adi,adv7281"
+		"adi,adv7281-m"
+		"adi,adv7281-ma"
+		"adi,adv7282"
+		"adi,adv7282-m"
 
 Example:
 
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index ff57c1d..5515f3d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1328,6 +1328,14 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
 #ifdef CONFIG_OF
 static const struct of_device_id adv7180_of_id[] = {
 	{ .compatible = "adi,adv7180", },
+	{ .compatible = "adi,adv7182", },
+	{ .compatible = "adi,adv7280", },
+	{ .compatible = "adi,adv7280-m", },
+	{ .compatible = "adi,adv7281", },
+	{ .compatible = "adi,adv7281-m", },
+	{ .compatible = "adi,adv7281-ma", },
+	{ .compatible = "adi,adv7282", },
+	{ .compatible = "adi,adv7282-m", },
 	{ },
 };
 
-- 
2.7.1

