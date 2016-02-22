Return-path: <linux-media-owner@vger.kernel.org>
Received: from yotta.elopez.com.ar ([185.83.216.59]:56754 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbcBVBt0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 20:49:26 -0500
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: vinod.koul@intel.com, maxime.ripard@free-electrons.com,
	wens@csie.org, mchehab@osg.samsung.com, balbi@kernel.org,
	hdegoede@redhat.com
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	=?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez@collabora.co.uk>
Subject: [PATCH 3/3] usb: musb: sunxi: support module autoloading
Date: Sun, 21 Feb 2016 22:26:36 -0300
Message-Id: <1456104396-13282-3-git-send-email-emilio@elopez.com.ar>
In-Reply-To: <1456104396-13282-1-git-send-email-emilio@elopez.com.ar>
References: <1456104396-13282-1-git-send-email-emilio@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Emilio López <emilio.lopez@collabora.co.uk>

MODULE_DEVICE_TABLE() is missing, so the module isn't auto-loading on
sunxi systems using the OTG controller. This commit adds the missing
line so it loads automatically when building it as a module and running
on a system with an USB OTG port.

Signed-off-by: Emilio López <emilio.lopez@collabora.co.uk>
---
 drivers/usb/musb/sunxi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/musb/sunxi.c b/drivers/usb/musb/sunxi.c
index d9b0dc4..fdab423 100644
--- a/drivers/usb/musb/sunxi.c
+++ b/drivers/usb/musb/sunxi.c
@@ -752,6 +752,7 @@ static const struct of_device_id sunxi_musb_match[] = {
 	{ .compatible = "allwinner,sun8i-a33-musb", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, sunxi_musb_match);
 
 static struct platform_driver sunxi_musb_driver = {
 	.probe = sunxi_musb_probe,
-- 
2.7.1

