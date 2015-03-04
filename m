Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:12599 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219AbbCDQQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 11:16:26 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH/RFC v12 07/19] mfd: max77693: add TORCH_IOUT_MASK macro
Date: Wed, 04 Mar 2015 17:14:28 +0100
Message-id: <1425485680-8417-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a macro for obtaining the mask of ITORCH register bit fields
related either to FLED1 or FLED2 current output. The expected
arguments are TORCH_IOUT1_SHIFT or TORCH_IOUT2_SHIFT.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max77693-private.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 955dd99..8770ce1 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -87,6 +87,7 @@ enum max77693_pmic_reg {
 /* MAX77693 ITORCH register */
 #define TORCH_IOUT1_SHIFT	0
 #define TORCH_IOUT2_SHIFT	4
+#define TORCH_IOUT_MASK(x)	(0xf << (x))
 #define TORCH_IOUT_MIN		15625
 #define TORCH_IOUT_MAX		250000
 #define TORCH_IOUT_STEP		15625
-- 
1.7.9.5

