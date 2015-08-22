Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40486 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 29/39] [media] dvb_frontend: document dvb_frontend_tune_settings
Date: Sat, 22 Aug 2015 14:28:14 -0300
Message-Id: <c0de9a73a8af70e3ba5613098cd12bff6748fc81.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Documentation for dvb_frontend_tune_settings struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index d20d3da97201..ea68ba61f0de 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -48,6 +48,15 @@
  */
 #define MAX_DELSYS	8
 
+/**
+ * struct dvb_frontend_tune_settings - parameters to adjust frontend tuning
+ *
+ * @min_delay_ms:	minimum delay for tuning, in ms
+ * @step_size:		step size between two consecutive frequencies
+ * @max_drift:		maximum drift
+ *
+ * NOTE: step_size is in Hz, for terrestrial/cable or kHz for satellite
+ */
 struct dvb_frontend_tune_settings {
 	int min_delay_ms;
 	int step_size;
-- 
2.4.3

