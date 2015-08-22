Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40399 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbbHVR2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:36 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH 31/39] [media] dvb_frontend.h: get rid of dvbfe_modcod
Date: Sat, 22 Aug 2015 14:28:16 -0300
Message-Id: <67472661b27ea1d0f6739667374e8de7617b0660.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enum is not used anymore, as drivers use the
modulation definitions from the public API. It is probably
a left over from some DVB core cleanup.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index e6df79fe8a71..1cd1dcde93c2 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -97,42 +97,6 @@ struct analog_parameters {
 	u64 std;
 };
 
-enum dvbfe_modcod {
-	DVBFE_MODCOD_DUMMY_PLFRAME	= 0,
-	DVBFE_MODCOD_QPSK_1_4,
-	DVBFE_MODCOD_QPSK_1_3,
-	DVBFE_MODCOD_QPSK_2_5,
-	DVBFE_MODCOD_QPSK_1_2,
-	DVBFE_MODCOD_QPSK_3_5,
-	DVBFE_MODCOD_QPSK_2_3,
-	DVBFE_MODCOD_QPSK_3_4,
-	DVBFE_MODCOD_QPSK_4_5,
-	DVBFE_MODCOD_QPSK_5_6,
-	DVBFE_MODCOD_QPSK_8_9,
-	DVBFE_MODCOD_QPSK_9_10,
-	DVBFE_MODCOD_8PSK_3_5,
-	DVBFE_MODCOD_8PSK_2_3,
-	DVBFE_MODCOD_8PSK_3_4,
-	DVBFE_MODCOD_8PSK_5_6,
-	DVBFE_MODCOD_8PSK_8_9,
-	DVBFE_MODCOD_8PSK_9_10,
-	DVBFE_MODCOD_16APSK_2_3,
-	DVBFE_MODCOD_16APSK_3_4,
-	DVBFE_MODCOD_16APSK_4_5,
-	DVBFE_MODCOD_16APSK_5_6,
-	DVBFE_MODCOD_16APSK_8_9,
-	DVBFE_MODCOD_16APSK_9_10,
-	DVBFE_MODCOD_32APSK_3_4,
-	DVBFE_MODCOD_32APSK_4_5,
-	DVBFE_MODCOD_32APSK_5_6,
-	DVBFE_MODCOD_32APSK_8_9,
-	DVBFE_MODCOD_32APSK_9_10,
-	DVBFE_MODCOD_RESERVED_1,
-	DVBFE_MODCOD_BPSK_1_3,
-	DVBFE_MODCOD_BPSK_1_4,
-	DVBFE_MODCOD_RESERVED_2
-};
-
 enum tuner_param {
 	DVBFE_TUNER_FREQUENCY		= (1 <<  0),
 	DVBFE_TUNER_TUNERSTEP		= (1 <<  1),
-- 
2.4.3

