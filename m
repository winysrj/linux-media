Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36436 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005AbcECO4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 10:56:18 -0400
Received: by mail-wm0-f67.google.com with SMTP id w143so4240996wmw.3
        for <linux-media@vger.kernel.org>; Tue, 03 May 2016 07:56:18 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 3 May 2016 15:56:17 +0100
Message-ID: <CAOQWjw0VpXq7cBxXTJoKOyxzDFrQXjsuj9DM0de57UOfc2k=tQ@mail.gmail.com>
Subject: [PATCH] Delete Eurobird1-28.5E tuning file (satellite moved)
From: Nick Morrott <knowledgejunkie@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove tuning file for Eurobird1 at 28.5E.

The satellite was moved to 33.0E (July 2015) and is now known as
Eutelsat 33C using different transponders.

Signed-off-by: Nick Morrott <knowledgejunkie@gmail.com>

---
 dvb-s/Eurobird1-28.5E | 26 --------------------------
 1 file changed, 26 deletions(-)
 delete mode 100644 dvb-s/Eurobird1-28.5E

diff --git a/dvb-s/Eurobird1-28.5E b/dvb-s/Eurobird1-28.5E
deleted file mode 100644
index 95f6eb9..0000000
--- a/dvb-s/Eurobird1-28.5E
+++ /dev/null
@@ -1,26 +0,0 @@
-# Eurobird 28.5E SDT info service transponder
-# freq pol sr fec
-[CHANNEL]
-       DELIVERY_SYSTEM = DVBS
-       FREQUENCY = 11623000
-       POLARIZATION = HORIZONTAL
-       SYMBOL_RATE = 27500000
-       INNER_FEC = 2/3
-       INVERSION = AUTO
-
-[CHANNEL]
-       DELIVERY_SYSTEM = DVBS
-       FREQUENCY = 11224000
-       POLARIZATION = VERTICAL
-       SYMBOL_RATE = 27500000
-       INNER_FEC = 2/3
-       INVERSION = AUTO
-
-[CHANNEL]
-       DELIVERY_SYSTEM = DVBS
-       FREQUENCY = 11527000
-       POLARIZATION = VERTICAL
-       SYMBOL_RATE = 27500000
-       INNER_FEC = 2/3
-       INVERSION = AUTO
-
-- 
2.8.0.rc3
