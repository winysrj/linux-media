Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62526 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbbBRQYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 11:24:22 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH/RFC v11 08/20] mfd: max77693: Adjust FLASH_EN_SHIFT and
 TORCH_EN_SHIFT macros
Date: Wed, 18 Feb 2015 17:20:29 +0100
Message-id: <1424276441-3969-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
from leds-max77693 driver. Previous definitions were compatible with
one of the previous RFC versions of leds-max77693.c driver, which was
not merged.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max77693-private.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 8770ce1..51633ea 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -114,8 +114,8 @@ enum max77693_pmic_reg {
 #define FLASH_EN_FLASH		0x1
 #define FLASH_EN_TORCH		0x2
 #define FLASH_EN_ON		0x3
-#define FLASH_EN_SHIFT(x)	(6 - ((x) - 1) * 2)
-#define TORCH_EN_SHIFT(x)	(2 - ((x) - 1) * 2)
+#define FLASH_EN_SHIFT(x)	(6 - (x) * 2)
+#define TORCH_EN_SHIFT(x)	(2 - (x) * 2)
 
 /* MAX77693 MAX_FLASH1 register */
 #define MAX_FLASH1_MAX_FL_EN	0x80
-- 
1.7.9.5

