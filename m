Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42701 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758708AbZANQSI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 11:18:08 -0500
Cc: o.endriss@gmx.de
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 14 Jan 2009 17:17:59 +0100
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20090114161759.39640@gmx.net>
MIME-Version: 1.0
Subject: [PATCH] lnbp21: documentation about the system register
To: mchehab@infradead.org, linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Here is a patch which adds some documentation about meanings of the
the lnbp21 system register bits.

Regards,
Hans

Signed-off-by: Hans Werner <hwerner4@gmx.de>

diff -r 6896782d783d linux/drivers/media/dvb/frontends/lnbp21.h
--- a/linux/drivers/media/dvb/frontends/lnbp21.h
+++ b/linux/drivers/media/dvb/frontends/lnbp21.h
@@ -28,14 +28,14 @@
 #define _LNBP21_H

 /* system register bits */
-#define LNBP21_OLF     0x01
-#define LNBP21_OTF     0x02
-#define LNBP21_EN      0x04
-#define LNBP21_VSEL    0x08
-#define LNBP21_LLC     0x10
-#define LNBP21_TEN     0x20
-#define LNBP21_ISEL    0x40
-#define LNBP21_PCL     0x80
+#define LNBP21_OLF     0x01 /* [R-only] 0=OK; 1=over current limit flag*/
+#define LNBP21_OTF     0x02 /* [R-only] 0=OK; 1=over temperature flag (150degC typ) */
+#define LNBP21_EN      0x04 /* [RW] 0=disable LNB power, enable loopthrough; 1=enable LNB power, disable loopthrough*/
+#define LNBP21_VSEL    0x08 /* [RW] 0=low voltage (13/14V, vert pol); 1=high voltage (18/19V,horiz pol) */
+#define LNBP21_LLC     0x10 /* [RW] increase LNB voltage by 1V:  0=13/18V; 1=14/19V */
+#define LNBP21_TEN     0x20 /* [RW] 0=tone controlled by DSQIN pin; 1=tone enable, disable DSQIN */
+#define LNBP21_ISEL    0x40 /* [RW] current limit select 0:Iout=500-650mA,Isc=300mA ; 1:Iout=400-550mA,Isc=200mA*/
+#define LNBP21_PCL     0x80 /* [RW] short-circuit prot: 0=pulsed (dynamic) curr limiting; 1=static curr limiting*/

 #include <linux/dvb/frontend.h>

-- 
Release early, release often.

Sensationsangebot verlängert: GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K1308T4569a
