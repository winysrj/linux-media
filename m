Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47399 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbaJIVOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 17:14:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] br-sp-SaoPaulo: Remove an invalid channel
Date: Thu,  9 Oct 2014 18:14:16 -0300
Message-Id: <827802523c09b7ba1da1a9a191865792df7c9c34.1412889202.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Channel 12 is currently not valid for ISDB-T in Brazil.

Also, due to an error FREQUENCY ended by not being filled here.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/isdb-t/br-sp-SaoPaulo b/isdb-t/br-sp-SaoPaulo
index 2f4d8d77662b..215e596caf2a 100644
--- a/isdb-t/br-sp-SaoPaulo
+++ b/isdb-t/br-sp-SaoPaulo
@@ -1,35 +1,6 @@
 # Channel table for São Paulo - SP - Brazil
 # Source: http://portalbsd.com.br/novo/terrestres_channels.php?channels=1
 
-# Physical channel 12
-[TV Mackenzie]
-	DELIVERY_SYSTEM = ISDBT
-	BANDWIDTH_HZ = 6000000
-	FREQUENCY = 
-	INVERSION = AUTO
-	GUARD_INTERVAL = AUTO
-	TRANSMISSION_MODE = AUTO
-	INVERSION = AUTO
-	GUARD_INTERVAL = AUTO
-	TRANSMISSION_MODE = AUTO
-	ISDBT_LAYER_ENABLED = 7
-	ISDBT_SOUND_BROADCASTING = 0
-	ISDBT_SB_SUBCHANNEL_ID = 0
-	ISDBT_SB_SEGMENT_IDX = 0
-	ISDBT_SB_SEGMENT_COUNT = 0
-	ISDBT_LAYERA_FEC = AUTO
-	ISDBT_LAYERA_MODULATION = QAM/AUTO
-	ISDBT_LAYERA_SEGMENT_COUNT = 0
-	ISDBT_LAYERA_TIME_INTERLEAVING = 0
-	ISDBT_LAYERB_FEC = AUTO
-	ISDBT_LAYERB_MODULATION = QAM/AUTO
-	ISDBT_LAYERB_SEGMENT_COUNT = 0
-	ISDBT_LAYERB_TIME_INTERLEAVING = 0
-	ISDBT_LAYERC_FEC = AUTO
-	ISDBT_LAYERC_MODULATION = QAM/AUTO
-	ISDBT_LAYERC_SEGMENT_COUNT = 0
-	ISDBT_LAYERC_TIME_INTERLEAVING = 0
-
 # Physical channel 15
 [Mega TV]
 	DELIVERY_SYSTEM = ISDBT
-- 
1.9.3

