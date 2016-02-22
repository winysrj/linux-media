Return-path: <linux-media-owner@vger.kernel.org>
Received: from yotta.elopez.com.ar ([185.83.216.59]:56750 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbcBVBtX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 20:49:23 -0500
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: vinod.koul@intel.com, maxime.ripard@free-electrons.com,
	wens@csie.org, mchehab@osg.samsung.com, balbi@kernel.org,
	hdegoede@redhat.com
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	=?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez@collabora.co.uk>
Subject: [PATCH 1/3] [media] rc: sunxi-cir: support module autoloading
Date: Sun, 21 Feb 2016 22:26:34 -0300
Message-Id: <1456104396-13282-1-git-send-email-emilio@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Emilio López <emilio.lopez@collabora.co.uk>

MODULE_DEVICE_TABLE() is missing, so the module isn't auto-loading on
systems supporting infrared. This commit adds the missing line so it
works out of the box when built as a module and running on a sunxi
system with an infrared receiver.

Signed-off-by: Emilio López <emilio.lopez@collabora.co.uk>
---
 drivers/media/rc/sunxi-cir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index 40f7768..eaadc08 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -326,6 +326,7 @@ static const struct of_device_id sunxi_ir_match[] = {
 	{ .compatible = "allwinner,sun5i-a13-ir", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, sunxi_ir_match);
 
 static struct platform_driver sunxi_ir_driver = {
 	.probe          = sunxi_ir_probe,
-- 
2.7.1

