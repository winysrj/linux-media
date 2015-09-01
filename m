Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34698 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbbIAKs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2015 06:48:26 -0400
Received: by wicjd9 with SMTP id jd9so28401813wic.1
        for <linux-media@vger.kernel.org>; Tue, 01 Sep 2015 03:48:25 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	valentinrothberg@gmail.com, hugues.fruchet@st.com
Subject: [PATCH v4 3/6] [media] c8sectpfe: Remove select on undefined LIBELF_32
Date: Tue,  1 Sep 2015 11:48:11 +0100
Message-Id: <1441104494-10468-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1441104494-10468-1-git-send-email-peter.griffin@linaro.org>
References: <1441104494-10468-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LIBELF_32 is not defined in Kconfig, and is left over legacy
which is not required in the upstream driver, so remove it.

Suggested-by: Valentin Rothberg <valentinrothberg@gmail.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/platform/sti/c8sectpfe/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/Kconfig b/drivers/media/platform/sti/c8sectpfe/Kconfig
index d1bfd4c..b9ec667 100644
--- a/drivers/media/platform/sti/c8sectpfe/Kconfig
+++ b/drivers/media/platform/sti/c8sectpfe/Kconfig
@@ -1,7 +1,6 @@
 config DVB_C8SECTPFE
 	tristate "STMicroelectronics C8SECTPFE DVB support"
 	depends on DVB_CORE && I2C && (ARCH_STI || ARCH_MULTIPLATFORM)
-	select LIBELF_32
 	select FW_LOADER
 	select FW_LOADER_USER_HELPER_FALLBACK
 	select DEBUG_FS
-- 
1.9.1

