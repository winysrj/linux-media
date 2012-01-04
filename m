Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51244 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2ADDWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 22:22:46 -0500
Received: by ggdk6 with SMTP id k6so10125260ggd.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 19:22:45 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] drivers: media: tuners: Fix dependency for MEDIA_TUNER_TEA5761
Date: Wed,  4 Jan 2012 01:22:27 -0200
Message-Id: <1325647347-14564-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following build warning:

warning: (MEDIA_TUNER) selects MEDIA_TUNER_TEA5761 which has unmet direct 
dependencies (MEDIA_SUPPORT && VIDEO_MEDIA && I2C && EXPERIMENTAL)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/common/tuners/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 996302a..eb5f61e 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -26,7 +26,7 @@ config MEDIA_TUNER
 	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
-	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE && EXPERIMENTAL
 	select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA9887 if !MEDIA_TUNER_CUSTOMISE
-- 
1.7.1

