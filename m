Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907Ab2ECWWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 18:22:35 -0400
Received: by pbbrp8 with SMTP id rp8so3032860pbb.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 15:22:34 -0700 (PDT)
From: mathieu.poirier@linaro.org
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 2/6] v4l/dvb: fix Kconfig dependencies on VIDEO_CAPTURE_DRIVERS
Date: Thu,  3 May 2012 16:22:23 -0600
Message-Id: <1336083747-3142-3-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

Kconfig warns about unsatisfied dependencies of symbols that
are directly selected.

Many capture drivers depend on DVB capture drivers, which
are hidden behind the CONFIG_DVB_CAPTURE_DRIVERS setting.

The solution here is to enable DVB_CAPTURE_DRIVERS unconditionally
when both DVB and VIDEO_CAPTURE_DRIVERS are enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/dvb/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index f6e40b3..c617996 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -29,7 +29,7 @@ config DVB_DYNAMIC_MINORS
 	  If you are unsure about this, say N here.
 
 menuconfig DVB_CAPTURE_DRIVERS
-	bool "DVB/ATSC adapters"
+	bool "DVB/ATSC adapters" if !VIDEO_CAPTURE_DRIVERS
 	depends on DVB_CORE
 	default y
 	---help---
-- 
1.7.5.4

