Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39871 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab1KJXfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:35:40 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3521161iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:35:39 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 21/25] modified Kconfig to include pctv80e support
Date: Thu, 10 Nov 2011 17:31:41 -0600
Message-Id: <1320967905-7932-22-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb/frontends/Kconfig |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 4a2d2e6..352815e 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -683,6 +683,14 @@ config DVB_IX2505V
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
+config DVB_DRX39XYJ
+	tristate "Micronas DRX-J demodulator"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
+	  to support this frontend.
+
 config DVB_IT913X_FE
 	tristate "it913x frontend and it9137 tuner"
 	depends on DVB_CORE && I2C
-- 
1.7.5.4

