Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36203 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaHTNoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:01 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	SangYoung Son <hello.son@smasung.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH/RFC v5 1/3] mfd: max77693: Fix register enum name
Date: Wed, 20 Aug 2014 15:43:39 +0200
Message-id: <1408542221-375-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the MAX77693 documentation the name of
the register is FLASH_STATUS.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: SangYoung Son <hello.son@smasung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/mfd/max77693-private.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index c466ff3..615f121 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -46,7 +46,7 @@ enum max77693_pmic_reg {
 	MAX77693_LED_REG_VOUT_FLASH2			= 0x0C,
 	MAX77693_LED_REG_FLASH_INT			= 0x0E,
 	MAX77693_LED_REG_FLASH_INT_MASK			= 0x0F,
-	MAX77693_LED_REG_FLASH_INT_STATUS		= 0x10,
+	MAX77693_LED_REG_FLASH_STATUS			= 0x10,
 
 	MAX77693_PMIC_REG_PMIC_ID1			= 0x20,
 	MAX77693_PMIC_REG_PMIC_ID2			= 0x21,
-- 
1.7.9.5

