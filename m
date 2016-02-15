Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33162 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbcBORYm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 12:24:42 -0500
From: info@are.ma
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD?=
	 =?UTF-8?q?=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>,
	linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
	mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: [media 1/7] raise adapter number limit
Date: Tue, 16 Feb 2016 02:24:30 +0900
Message-Id: <370b7726279759abc41a71843c6a59cdb1e5cdb1.1455556118.git.knightrider@are.ma>
In-Reply-To: <cover.1455556118.git.knightrider@are.ma>
References: <cover.1455556118.git.knightrider@are.ma>
In-Reply-To: <cover.1455556118.git.knightrider@are.ma>
References: <cover.1455556118.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто, AreMa Inc <knightrider@are.ma>

The current limit is too low for latest cards with 8+ tuners on a single slot, change to 64.

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/dvb-core/dvbdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 4aff7bd..950decd 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -34,7 +34,7 @@
 #if defined(CONFIG_DVB_MAX_ADAPTERS) && CONFIG_DVB_MAX_ADAPTERS > 0
   #define DVB_MAX_ADAPTERS CONFIG_DVB_MAX_ADAPTERS
 #else
-  #define DVB_MAX_ADAPTERS 8
+  #define DVB_MAX_ADAPTERS 64
 #endif
 
 #define DVB_UNSET (-1)
-- 
2.3.10

