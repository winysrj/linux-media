Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbcGESkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 14:40:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/12] doc-rst: linux_tv: dvb: use lowercase for filenames
Date: Tue,  5 Jul 2016 14:59:19 -0300
Message-Id: <0060665c45c78796c748463ba742e88c123cecb7.1467743704.git.mchehab@s-opensource.com>
In-Reply-To: <47d23e363fb034f32551f5fe85add77ceba98d3b.1467740686.git.mchehab@s-opensource.com>
References: <47d23e363fb034f32551f5fe85add77ceba98d3b.1467740686.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467743704.git.mchehab@s-opensource.com>
References: <cover.1467743704.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some ioctls in upper case. This is not the standard.
Put them on lowercase, to match what's done with other ioctls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 ...LEGACY_CMD.rst => fe-dishnetwork-send-legacy-cmd.rst} |  0
 .../media/dvb/{FE_GET_EVENT.rst => fe-get-event.rst}     |  0
 .../dvb/{FE_GET_FRONTEND.rst => fe-get-frontend.rst}     |  0
 .../media/dvb/{FE_READ_BER.rst => fe-read-ber.rst}       |  0
 ...D_SIGNAL_STRENGTH.rst => fe-read-signal-strength.rst} |  0
 .../media/dvb/{FE_READ_SNR.rst => fe-read-snr.rst}       |  0
 ...RRECTED_BLOCKS.rst => fe-read-uncorrected-blocks.rst} |  0
 .../dvb/{FE_SET_FRONTEND.rst => fe-set-frontend.rst}     |  0
 Documentation/linux_tv/media/dvb/frontend_legacy_api.rst | 16 ++++++++--------
 9 files changed, 8 insertions(+), 8 deletions(-)
 rename Documentation/linux_tv/media/dvb/{FE_DISHNETWORK_SEND_LEGACY_CMD.rst => fe-dishnetwork-send-legacy-cmd.rst} (100%)
 rename Documentation/linux_tv/media/dvb/{FE_GET_EVENT.rst => fe-get-event.rst} (100%)
 rename Documentation/linux_tv/media/dvb/{FE_GET_FRONTEND.rst => fe-get-frontend.rst} (100%)
 rename Documentation/linux_tv/media/dvb/{FE_READ_BER.rst => fe-read-ber.rst} (100%)
 rename Documentation/linux_tv/media/dvb/{FE_READ_SIGNAL_STRENGTH.rst => fe-read-signal-strength.rst} (100%)
 rename Documentation/linux_tv/media/dvb/{FE_READ_SNR.rst => fe-read-snr.rst} (100%)
 rename Documentation/linux_tv/media/dvb/{FE_READ_UNCORRECTED_BLOCKS.rst => fe-read-uncorrected-blocks.rst} (100%)
 rename Documentation/linux_tv/media/dvb/{FE_SET_FRONTEND.rst => fe-set-frontend.rst} (100%)

diff --git a/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst b/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
rename to Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst
diff --git a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst b/Documentation/linux_tv/media/dvb/fe-get-event.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
rename to Documentation/linux_tv/media/dvb/fe-get-event.rst
diff --git a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/fe-get-frontend.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
rename to Documentation/linux_tv/media/dvb/fe-get-frontend.rst
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_BER.rst b/Documentation/linux_tv/media/dvb/fe-read-ber.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/FE_READ_BER.rst
rename to Documentation/linux_tv/media/dvb/fe-read-ber.rst
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst b/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
rename to Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst b/Documentation/linux_tv/media/dvb/fe-read-snr.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
rename to Documentation/linux_tv/media/dvb/fe-read-snr.rst
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst b/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
rename to Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst
diff --git a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
similarity index 100%
rename from Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
rename to Documentation/linux_tv/media/dvb/fe-set-frontend.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend_legacy_api.rst b/Documentation/linux_tv/media/dvb/frontend_legacy_api.rst
index fb17766d887e..759833d3eaa4 100644
--- a/Documentation/linux_tv/media/dvb/frontend_legacy_api.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_legacy_api.rst
@@ -28,11 +28,11 @@ recommended
 .. toctree::
     :maxdepth: 1
 
-    FE_READ_BER
-    FE_READ_SNR
-    FE_READ_SIGNAL_STRENGTH
-    FE_READ_UNCORRECTED_BLOCKS
-    FE_SET_FRONTEND
-    FE_GET_FRONTEND
-    FE_GET_EVENT
-    FE_DISHNETWORK_SEND_LEGACY_CMD
+    fe-read-ber
+    fe-read-snr
+    fe-read-signal-strength
+    fe-read-uncorrected-blocks
+    fe-set-frontend
+    fe-get-frontend
+    fe-get-event
+    fe-dishnetwork-send-legacy-cmd
-- 
2.7.4

