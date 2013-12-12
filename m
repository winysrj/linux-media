Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:57307 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab3LLUl4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 15:41:56 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 1/2] cx231xx: Add missing selects for MEDIA_SUBDRV_AUTOSELECT
Date: Thu, 12 Dec 2013 21:41:09 +0100
Message-Id: <1386880870-5735-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1386880870-5735-1-git-send-email-zzam@gentoo.org>
References: <1386880870-5735-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two drivers LGDT3305 and TDA18271C2DD were not autoselected, so the
cx231xx_dvb module could not be loaded when MEDIA_SUBDRV_AUTOSELECT=y.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 86feeea..f14c5e8 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -45,6 +45,8 @@ config VIDEO_CX231XX_DVB
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 
 	---help---
 	  This adds support for DVB cards based on the
-- 
1.8.4.4

