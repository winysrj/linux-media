Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:12583 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142AbbCDQQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 11:16:17 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v12 05/19] mfd: max77693: Modify flash cell name identifiers
Date: Wed, 04 Mar 2015 17:14:26 +0100
Message-id: <1425485680-8417-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change flash cell identifiers from max77693-flash to max77693-led
to avoid confusion with NOR/NAND Flash.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max77693.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index a159593..cb14afa 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -53,8 +53,8 @@ static const struct mfd_cell max77693_devs[] = {
 		.of_compatible = "maxim,max77693-haptic",
 	},
 	{
-		.name = "max77693-flash",
-		.of_compatible = "maxim,max77693-flash",
+		.name = "max77693-led",
+		.of_compatible = "maxim,max77693-led",
 	},
 };
 
-- 
1.7.9.5

