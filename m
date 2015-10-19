Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbbJSGRd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2015 02:17:33 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK
Date: Mon, 19 Oct 2015 08:17:30 +0200
Message-Id: <1445235450-6771-1-git-send-email-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

c8sectpfe driver selects CONFIG_FW_LOADER_USER_HELPER_FALLBACK by some
reason, but this option is known to be harmful, leading to minutes of
stalls at boot time.  The option was intended for only compatibility
for an old exotic system that mandates the udev interaction, and not a
thing a driver selects by itself.  Let's remove it.

Fixes: 850a3f7d5911 ('[media] c8sectpfe: Add Kconfig and Makefile for the driver')
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/media/platform/sti/c8sectpfe/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/Kconfig b/drivers/media/platform/sti/c8sectpfe/Kconfig
index 641ad8f34956..7420a50572d3 100644
--- a/drivers/media/platform/sti/c8sectpfe/Kconfig
+++ b/drivers/media/platform/sti/c8sectpfe/Kconfig
@@ -3,7 +3,6 @@ config DVB_C8SECTPFE
 	depends on PINCTRL && DVB_CORE && I2C
 	depends on ARCH_STI || ARCH_MULTIPLATFORM || COMPILE_TEST
 	select FW_LOADER
-	select FW_LOADER_USER_HELPER_FALLBACK
 	select DEBUG_FS
 	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV090x if MEDIA_SUBDRV_AUTOSELECT
-- 
2.6.1

