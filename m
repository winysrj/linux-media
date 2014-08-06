Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.230]:43929 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaHFN2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Aug 2014 09:28:01 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] sp2: Add SP2 entry to Kconfig
Date: Wed,  6 Aug 2014 16:27:53 +0300
Message-Id: <1407331673-4591-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Option DVB_SP2 must be in Kconfig as well. This patch should be applied 
together with patch 25206 that was submitted earlier today.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index fe0ddcc..c38c936 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -720,6 +720,13 @@ config DVB_A8293
 	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 
+config DVB_SP2
+	tristate "CIMaX SP2"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  CIMaX SP2/SP2HF Common Interface module.
+
 config DVB_LGS8GL5
 	tristate "Silicon Legend LGS-8GL5 demodulator (OFDM)"
 	depends on DVB_CORE && I2C
-- 
1.9.1

