Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822Ab3EBPQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 11:16:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH, RFC 22/22] radio-si4713: depend on SND_SOC
Date: Thu,  2 May 2013 17:16:26 +0200
Message-Id: <1367507786-505303-23-git-send-email-arnd@arndb.de>
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not possible to select SND_SOC_SI476X if we have not also
enabled SND_SOC.

warning: (RADIO_SI476X) selects SND_SOC_SI476X which has unmet
	 direct dependencies (SOUND && !M68K && !UML && SND && SND_SOC)

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/radio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index c0beee2..d529ba7 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -22,6 +22,7 @@ config RADIO_SI476X
 	tristate "Silicon Laboratories Si476x I2C FM Radio"
 	depends on I2C && VIDEO_V4L2
 	depends on MFD_SI476X_CORE
+	depends on SND_SOC
 	select SND_SOC_SI476X
 	---help---
 	  Choose Y here if you have this FM radio chip.
-- 
1.8.1.2

