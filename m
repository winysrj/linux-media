Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36659 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbcDDREN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 13:04:13 -0400
From: info@are.ma
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=
	<knightrider@are.ma>, linux-kernel@vger.kernel.org, crope@iki.fi,
	m.chehab@samsung.com, mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: [media 1/6] Raise adapter number limit
Date: Tue,  5 Apr 2016 02:04:00 +0900
Message-Id: <f73dc33bab1621d88f06a969752f6ed281110a7b.1459787898.git.knightrider@are.ma>
In-Reply-To: <cover.1459787898.git.knightrider@are.ma>
References: <cover.1459787898.git.knightrider@are.ma>
In-Reply-To: <cover.1459787898.git.knightrider@are.ma>
References: <cover.1459787898.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто, AreMa Inc <knightrider@are.ma>

The current limit is too low for latest cards with 8+ tuners on a single slot.
IMHO, the most appropriate minimum default is 16.

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/dvb-core/Kconfig  | 4 ++--
 drivers/media/dvb-core/dvbdev.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/Kconfig b/drivers/media/dvb-core/Kconfig
index fa7a249..91732a9 100644
--- a/drivers/media/dvb-core/Kconfig
+++ b/drivers/media/dvb-core/Kconfig
@@ -5,7 +5,7 @@
 config DVB_MAX_ADAPTERS
 	int "maximum number of DVB/ATSC adapters"
 	depends on DVB_CORE
-	default 8
+	default 16
 	range 1 255
 	help
 	  Maximum number of DVB/ATSC adapters. Increasing this number
@@ -13,7 +13,7 @@ config DVB_MAX_ADAPTERS
 	  if a much lower number of DVB/ATSC adapters is present.
 	  Only values in the range 4-32 are tested.
 
-	  If you are unsure about this, use the default value 8
+	  If you are unsure about this, use the default value 16
 
 config DVB_DYNAMIC_MINORS
 	bool "Dynamic DVB minor allocation"
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 4aff7bd..ae4e0a2 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -34,7 +34,7 @@
 #if defined(CONFIG_DVB_MAX_ADAPTERS) && CONFIG_DVB_MAX_ADAPTERS > 0
   #define DVB_MAX_ADAPTERS CONFIG_DVB_MAX_ADAPTERS
 #else
-  #define DVB_MAX_ADAPTERS 8
+  #define DVB_MAX_ADAPTERS 16
 #endif
 
 #define DVB_UNSET (-1)
-- 
2.7.4

