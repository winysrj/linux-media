Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36506 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbbH0Mab (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2015 08:30:31 -0400
Received: by wicgk12 with SMTP id gk12so7099027wic.1
        for <linux-media@vger.kernel.org>; Thu, 27 Aug 2015 05:30:30 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 3/5] [media] c8sectpfe: Remove select on undefined LIBELF_32
Date: Thu, 27 Aug 2015 13:29:33 +0100
Message-Id: <1440678575-21646-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
References: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LIBELF_32 is not defined in Kconfig, and is left over legacy
which is not required in the upstream driver, so remove it.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Suggested-by: Valentin Rothberg <valentinrothberg@gmail.com>
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

