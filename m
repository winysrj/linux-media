Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38122 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AJAwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 19:52:10 -0500
Received: by yenm10 with SMTP id m10so506595yen.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2012 16:52:09 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] drivers: video: cx231xx: Fix dependency for VIDEO_CX231XX_DVB
Date: Mon,  9 Jan 2012 22:51:56 -0200
Message-Id: <1326156716-3670-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following build warning:

warning: (VIDEO_CX231XX_DVB) selects DVB_MB86A20S which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && I2C)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/cx231xx/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx231xx/Kconfig b/drivers/media/video/cx231xx/Kconfig
index c74ce9e..446f692 100644
--- a/drivers/media/video/cx231xx/Kconfig
+++ b/drivers/media/video/cx231xx/Kconfig
@@ -40,7 +40,7 @@ config VIDEO_CX231XX_ALSA
 
 config VIDEO_CX231XX_DVB
 	tristate "DVB/ATSC Support for Cx231xx based TV cards"
-	depends on VIDEO_CX231XX && DVB_CORE
+	depends on VIDEO_CX231XX && DVB_CORE && DVB_CAPTURE_DRIVERS
 	select VIDEOBUF_DVB
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
-- 
1.7.1

