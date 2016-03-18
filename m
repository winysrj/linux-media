Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37932 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbcCRNB2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 09:01:28 -0400
Received: by mail-wm0-f53.google.com with SMTP id l68so36259131wml.1
        for <linux-media@vger.kernel.org>; Fri, 18 Mar 2016 06:01:27 -0700 (PDT)
Received: from fractal.localdomain (255.163.90.146.dyn.plus.net. [146.90.163.255])
        by smtp.gmail.com with ESMTPSA id xx3sm12171678wjc.32.2016.03.18.06.01.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Mar 2016 06:01:26 -0700 (PDT)
Date: Fri, 18 Mar 2016 13:01:25 +0000 (GMT)
From: Edward Sheldrake <ejsheldrake@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Remove space before end of line in Astra-28.2E file
Message-ID: <alpine.LFD.2.20.1603181258560.22757@fractal.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes dvb-format-convert parsing the polarization value.

Signed-off-by: Edward Sheldrake <ejsheldrake@gmail.com>
---
 dvb-s/Astra-28.2E | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/dvb-s/Astra-28.2E b/dvb-s/Astra-28.2E
index ea06c56..5c3e515 100644
--- a/dvb-s/Astra-28.2E
+++ b/dvb-s/Astra-28.2E
@@ -572,7 +572,7 @@
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBS
 	FREQUENCY = 11170750
-	POLARIZATION = HORIZONTAL 
+	POLARIZATION = HORIZONTAL
 	SYMBOL_RATE = 22000000
 	INNER_FEC = 5/6
 	MODULATION = QPSK
-- 
2.5.0

