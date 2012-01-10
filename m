Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57069 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab2AJNPk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 08:15:40 -0500
Received: by ghbg21 with SMTP id g21so2088525ghb.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 05:15:39 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] drivers: media: au0828: Fix dependency for VIDEO_AU0828
Date: Tue, 10 Jan 2012 11:15:29 -0200
Message-Id: <1326201329-10222-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following build warning:

warning: (VIDEO_AU0828) selects DVB_AU8522 which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && I2C && VIDEO_V4L2)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/au0828/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/au0828/Kconfig b/drivers/media/video/au0828/Kconfig
index 0c3a5ba..81ba9d9 100644
--- a/drivers/media/video/au0828/Kconfig
+++ b/drivers/media/video/au0828/Kconfig
@@ -2,6 +2,7 @@
 config VIDEO_AU0828
 	tristate "Auvitek AU0828 support"
 	depends on I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2
+	depends on DVB_CAPTURE_DRIVERS
 	select I2C_ALGOBIT
 	select VIDEO_TVEEPROM
 	select VIDEOBUF_VMALLOC
-- 
1.7.1

