Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36804 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab3K0QOZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 11:14:25 -0500
Message-ID: <52961A59.4070600@gentoo.org>
Date: Wed, 27 Nov 2013 17:14:17 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: [PATCH] cx231xx: Add missing selects for MEDIA_SUBDRV_AUTOSELECT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two drivers LGDT3305 and TDA18271C2DD were not autoselected, so the
cx231xx_dvb module could not be loaded if MEDIA_SUBDRV_AUTOSELECT is 
enabled.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
  drivers/media/usb/cx231xx/Kconfig | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/Kconfig 
b/drivers/media/usb/cx231xx/Kconfig
index 86feeea..f14c5e8 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -45,6 +45,8 @@ config VIDEO_CX231XX_DVB
         select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
         select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
         select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
+       select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
+       select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT

         ---help---
           This adds support for DVB cards based on the

