Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbbHVR2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:36 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 30/39] [media] add documentation for struct dvb_tuner_info
Date: Sat, 22 Aug 2015 14:28:15 -0300
Message-Id: <9f12daea94fd2c773f99c1a53044fd89ef9efc03.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Despite being used everywhere at DVB frontends, the
struct dvb_tuner_info were never documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index ea68ba61f0de..e6df79fe8a71 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -65,6 +65,19 @@ struct dvb_frontend_tune_settings {
 
 struct dvb_frontend;
 
+/**
+ * struct dvb_tuner_info - Frontend name and min/max ranges/bandwidths
+ *
+ * @name:		name of the Frontend
+ * @frequency_min:	minimal frequency supported
+ * @frequency_max:	maximum frequency supported
+ * @frequency_step:	frequency step
+ * @bandwidth_min:	minimal frontend bandwidth supported
+ * @bandwidth_max:	maximum frontend bandwidth supported
+ * @bandwidth_step:	frontend bandwidth step
+ *
+ * NOTE: step_size is in Hz, for terrestrial/cable or kHz for satellite
+ */
 struct dvb_tuner_info {
 	char name[128];
 
-- 
2.4.3

