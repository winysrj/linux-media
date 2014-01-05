Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:54804 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAERqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 12:46:39 -0500
Received: from [192.168.1.15] (g231118199.adsl.alicedsl.de [92.231.118.199])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.14.7/8.14.7) with ESMTP id s05HXJhf023929
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Sun, 5 Jan 2014 18:33:20 +0100 (CET)
Message-ID: <52C9975A.2060900@tu-dortmund.de>
Date: Sun, 05 Jan 2014 18:33:14 +0100
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Patch for TechnoTrend S2-4600
Content-Type: multipart/mixed;
 boundary="------------080404080901020300010309"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080404080901020300010309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi guys,

i'm sending you a patch that adds support for the TechnoTrend S2-4600 
DVB-S2 device to a 3.12 (5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52) 
mainline kernel.
I just extracted the drivers for the two frontends (ds3103 and ts2202) 
from [1] and added them to a mainline kernel. Furthermore, i modified 
the dw2102 driver to support the new frontends (= copied the necessary 
lines of code from the origin dw2102) . In addition, i attached a 
firmware for the dw2102 extracted from [3].
I appreciate, if you review my patch and may integrate it into the 
mainline tree.

Thank you!
Greetings
Alex

[1] 
https://bitbucket.org/liplianin/s2-liplianin-v37/get/67ce08afdbe7.tar.bz2
[2] http://www.tt-downloads.de/Linux/s2-TT4600-linux-20120815.tgz
[3] http://www.tt-downloads.de/Linux/linux_tt-connect_s2-4600.pdf

--------------080404080901020300010309
Content-Type: application/octet-stream;
 name="dvb-fe-ds3103.fw"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dvb-fe-ds3103.fw"

gwEAMIoABCgiMIQAWzASICAwhAAiMBIggwGKFUUqBAaAAYQKBAYDHQ8oADQAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgwFSCJAAUwiRAFQIlABVCJUAAABsOwAAFwjXABYI
1gBXCPEAVgjwAAgAgwHWAJABkQGSAZMBkxZWCvAASCgDEJMM8AtGKIMSAxOUAZUBVAiWAFUI
lwDYAdkBETDXALI7AxCXDJYMlQyUDAMQ2A3ZDZsfFxtrKBgIkAAZCJEAGgiSABsIkwBYFNcL
VihZCPEAWAjwAAgAgwHVAAYw1wDUCAMdeygEMHwoCTDYAAUw1gDYCAMdhihdMNkAdDDIKFgL
iyjZAWQwyChYCAI6Ax2SKFUw2QDIKFgIAzoDHZootTDZAEcwyChYCAQ6Ax2iKKow2QA8MMgo
WAgFOgMdqiirMNkAajDIKFgIBjoDHbIobjDZAFswyChYCAc6Ax25KNkBUDDIKFgICDoDHcEo
pDDZAEEwyChYCAk6Ax3JKOQw2QA4MNoA2ANVCvAA0CgDENoM2QzwC80ogxIDE0IIWgIDHdoo
QQhZAgMY3ihWCNcA1gt/KFQI1wJXCAgANTCDAUICVjADGUECAxzwKNQBqwGrCh8pGjBCAqsw
AxlBAgMc+yjUAdQKAjAeKQ0wQgJVMAMZQQIDHAYpAjDUAAQwHikGMEICqzADGUECAzADHBEp
1AAIMB4pQgJVMAMZQQIDHBspBDDUABAwHikFMNQAIDCrAFQICACDAdYAkACRAVQIlABVCJUA
AABsOwAAFgjYABUI1wBYCPEAVwjwAAgAgwHUAIwAAADgOwAAEQjWABAI1QBWCPEAVQjwAAgA
gwEhE9IB0wHOAc8BzAHLAf8sMgihHmcpLgSzAEcwnAAzCJ4AoR1mKU4wnAAeFJ4BZjCcAAAA
IREdGCEVgxIDEyEdXCkyCDg6Ax1rKqEeeCkeMJwAHhQdMJwAHhSjAboBAzA1AgMYLhehGqAZ
VCogMJwAHhQSMJwAngETMJwAngEUMJwABzCeAEEwnACeARUwnAAeFBYwnAAeFBcwnAAeFBgw
nAAeFG4wnAAeFBkwnAAeFBownAAeFEgwnAAeFB4wnAAeFB0wnAAeFEwwnAAeFEswnAAeFFAw
nAAeFEIwnAAeFCEwnAAeFCIwnAAeFEAwnACeAQswnAAAACARHRggFQowgxIDE5wAAAAgEB0Y
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
KjCcAB4ULjCcAB4UCADrMIMBjADiOwAAEQgwBgMdCykQCC8GAxkIABEIsAAQCK8AQQiUAEII
lQAAAGw7AAAVCJQAFgiVABcIlgCXHyEp/zCXACIplwElCJAAJgiRACcIkgAoCJMAAAByOwAA
FAilABUIpgAWCKcAFwioANwwjQD6OwgAgwHSANcB1QHTANYBlAGVAZYBlwGYAZkBmgGbAdcK
VwiMAOI73TCMAPY71wpXCIwA4jveMIwA9jsQFN8wjAD2O5ABjAD2OwYw1ADUC14p0DCMAOI7
cjuWAZcBAzCVBRUIAjoDGW4pFQtvKdYKlRxzKfwwlQRVCIgAzDvVCq870DCNAOY70wtHKRUw
VgIDHIMpIBeEKSATIBsIABkIkAAaCJEAQQiUAEIIlQAlCJgAJgiZACcImgAoCJsAAABzOwAA
FAilABUIpgAWCKcAFwioANwwjQD6OxYIkAAXCJEAUggZOgMdCADoMIwA9jsIABswgwGIAIwB
vCnNO4gK3TsxO/U7iAqMCiAwDAIDHLUpmzCIACAwjABAMAwCAxjQKc07iArdOzE79TuICowK
xCkCMNUA1AHUChAw0gDWAdYK0wFSCFMCAxj9KVMI8ABWCPEA8QrlKQMQ8A3xC+MpcAiMAFUY
jBZUCNcA4DsMCFQHjQDkO7E7cjv6OwwIjgD9O4wK1wvtKdMK2SkDENIMAxDUDdYKBjBWAgMc
2CnVC9Ip/zCMAI0APzCOACAw1wCMCuA7jQrkO44K6DuzO/871wsPKh8wjACNAD8wjgAgMNcA
jArgO40K5DuOCug7szv/O9cLICoIAIMB1gCOAFQImABVCJkAAAD8OwAACACDAdgAjgBUCJgA
VQiZAFYImgBXCJsAAAD8OwAACACDEgMToRagEa4BswG6AbUBowGpAVEwnAA3MJ4A1AHVAdYB
1wHvMDYiODCyAGUwnAAAAKERHRihFVwwgxIDE5wAAAAdCLkAPjCcAAAAoBAdGKAUgxIDE6Ac
rSqhHqwqoRJEMJwAngFHMJwAMDCeABQwnAAHMJ4AQTCcAJ4BFTCcAB4UQjCcAB4UHTCcAB4U
EjCcAJ4BFzCcAB4UEzCcAJ4B1AHVAeIwKyIWMJwAHhSeARgwnAAeFBkwnAAeFJ4BSDCcAB4U
IDCcAB4UngGgEawqoRaKEUQhihUQMJwAAAAhEh0YIRaDEgMTIR6/KooVeSSKFWgqihELJYoV
aCqDAdMAXzCcAAAAHQjSAFILGisMMDQCAxweKxIwNAIDGLwrNAgMOgMd3ipTC9oqpjDUAGYw
XSs0CA06Ax3oKlML5CqmMNQAZjBvKzQIDjoDHfUqUwvxKmYw1ACBK6Yw1ABmMIErNAgPOgMd
ACtTC/wqjCumMNQAZjCTKzQIEDoDHQ0rUwsKK2Yw1ABEMKUrZjDUAKUrNAgROgMd2itTCxcr
ZjDUAEQwtytmMNQAtysMMDQCAxhMKzQIBDoDGT4rNAgFOgMZPis0CAY6Axk+KzQIBzoDGT4r
NAgIOgMZPis0CAk6Axk+KzQICjoDGT4rNAgLOgMd2itTC0QrZjDUAEQwRytmMNQAZDDVAIIw
1gCAMNIrEjA0AgMYvCs0CAw6Ax1iK1MLWitmMNQARDBdK7Yw1AB0MNUAgjDWAIEw0is0CA06
Ax10K1MLbCtmMNQARDBvK6Yw1ABkMNUAgjDWAJEw0is0CA46Ax2GK1MLfitmMNQARDCBK6Yw
1ABkMNUAgjDWAKEw0is0CA86Ax2YK1MLkCtmMNQARDCTK6Yw1ABkMNUAgjDWALEw0is0CBA6
Ax2qK1MLoitmMNQAMzClK6Yw1ABkMNUAgjDWAMEw0is0CBE6Ax3aK1MLtCtmMNQAMzC3K7Yw
1AB0MNUAgjDWANEw0isYMDQCAxjJK1MLwivXMNQAdTDVAIIw1gDSK1MLyyvXMNQAdTDVAIIw
1gCDMNcA7zA2Iogw1ADVAfQwKyJfMJwAAAAdCNIACACDAdIAUgvwK0Qw1AAiMNUAgjDWAIAw
1wDvMDYiRDD7K1Uw1ABUMNUAgjDWAIAw1wDvMDYizDDUANUB9DArItQB1QHWAdcB7zA2KoMB
VQjXAFYI2ABUCIoRAiWKFf8w0gcDHNMDUwhSBAMZCAAFLIMB0gABMI4A1AHUCl8siAFUCIkA
6DtUCFIC0wDVAIgKzDuJCtw7rzvVCyYsgDCIAFQIgD6JAFMI1QCICsw7iQrcO6871Qs0LPw7
iAFUCIA+iQCOCug7UwjVAIkK3DuICsw7rzvVC0Qs/DuAMIgAVAiJAA4IjABTCNUAiQrcO4gK
zDtgO7I7/DvVC1QsjgrUClIIVAIDGAgAHiyDAdIAmAGZAZoBmwFSCI4A/DuOC2wsCACDAdQA
jAAAAOA7AAAQCNUACACDAc0BIROgGWwtIDClLjIIoR6aLC4EswBHMJwAMwieAKEdmSxOMJwA
HhSeAWYwnAAAACERHRghFYMSAxMhHY8sMgggOgMdCC2hHuAsGzCcAB4UHTCcAB4UHjCcAB4U
QjCcAB4UngFEMJwATjCeADYwnACeATcwnACeATgwnACeATkwnACeATIwnAAeFJ4B2DBwJNAA
tjBkJNQB1QHWAdcB3DCKFTYi1AHVAegwihUrIooVMzCcAJ4BNDCcAJ4BNTCcAB4UoRKlAaYB
pwGoAQ8wnAAAAB0I0QBRGP0vTTCcAB4UngHQAwMZ8iwyMJwAHhSeARowFyTQCAMd/S81MJwA
ngE2MJwAHhQZMIoVOSGKFaEWIB8GLScwpS4hMKUuMgghOgMdMS0gHRAtEDASLdUwcCTRAPAA
8QEDEPAN8Q0DEPAN8Q1wCL0AcQi+AP8w1wDYASsIihECJYoV/zC9BwMcvgM+CD0EAx0fLaEW
IjClLjIIIjoDHW4toR5QLTUwnACeATYwnACeATcwnACeATgwnACeATkwnAAeFDIwnAAeFJ4B
2TBwJNAAYDBkJKESDzCcAAAAHQjRAFEY/S9NMJwAHhSeAdADAxliLTIwnAAeFJ4BihWwIYoV
0AgDHf0vihWnIIoVoRYjMKUuMggjOgMdpC2hHpItMzCcAJ4BNDCcAJ4BMzCcAB4UNTCcAJ4B
NjCcAJ4BNzCcAB4UODCcAJ4BOTCcAJ4BMjCcAB4UngGhEswBDzCcAAAAHQjRAFEY/S9NMJwA
HhSeASQwsgChFjQwnAAeFP0vMggkOgMd9y2hHtMtRDCcAE4wngADMJwAngFDMJwAngEiMJwA
HhQhMJwAHhQ1MJwAngE2MJwAngE3MJwAHhQ4MJwAngE5MJwAngEyMJwAHhSeAdowcCTQALQw
ZCShEg8wnAAAAB0I0QBRGP0vTTCcAB4UngHQAwMZ5S0yMJwAHhSeAVowFyTQCAMd/S83MJwA
ngE4MJwAHhRZMIoVOSGKFaEWJTClLjIIJToDHZQuoR5YLqESAzCcAB4UIjCcAB4UngEhMJwA
HhSeAUQwnACeAXUwnAAeFJ4BdjCcAB4UngFDMJwAHhRoMJwAAAAdCNEAURxULjEODznQADEI
DznwAAMQ8AwDEPAMAxBwDPAAcAfQBzEIBznwAAMQ8AwDEHAM8AADEPANAxBwDdAHMQgDOfAA
AxBwDPAAAxDwDQMQ8A0DEHAN0AcxCAE58ADwDvAw8AVwCNAHUAi0AAAwihXDIhUwnAAeFJ4B
/zDXANgBKwiKEQIlihUCMJwAAAAdCNEABDCcAAAAHQjQAFEF8ABwHHguGjCcAB4UngGgHnUu
KzB2LigwsgChFmQwnAAAAB0I0QBgMJwAAAAdCNAAURiGLlAcii6hFgswsgAhFwEwnAAAAB0I
0QAHOQMd/S+hFscvMggoOgMdnS6KFccgihUrMPYvMggrOgMdpy5uMJwAngEmMLIA/S8yCCY6
Ax38LqEewC6hEr0BZDC+ABswnAAeFJ4BHTCcAB4UngEeMJwAHhSeAS4wnAAeFP8w1wDYASsI
ihECJYoVBTCcAAAAIBIdGCAWAjCDEgMTnAAAAB0I0QAEMJwAAAAdCNAAATCcAAAAHQi4AFEY
UBzoLjgIBzkDGeguKTCyAPYuPgg9BAMdURzzLlAc8y44CAc5Ax33LgswsgAhF6EW/zC9BwMc
vgP9LzIIKToDHYIvoBkIL6AVRwjDAEgIxACuAaEeFS+hEr0ByDC+AM8BywHOAaQBtQHNAcwB
BTCcAAAAIBIdGCAWAjCDEgMTnAAAAB0I0QBgMJwAAAAdCNAA0QgDGTMvUAstLzMvIBo2Lz4I
PQQDHTYvKjCyAKEWzggDHUQv0gHIMNMAKwjUAP8w1QDWAQUkzgHOCnMwnAAAAB0I0QA+CD0E
AxleL1EcUy9PCgMZUy/PCr0IAxm+A70D/zDXANgBKwiKEQIlihVoMJwAAAAdCNEAPgg9BAMZ
ay9oMJwATwieACAwTwIDHP0vTgv9L1EIAzkBOgMd/S/PAQEwihXDIooVAzDOAGkwnACqMJ4A
/S8yCCo6Ax3LL6EejC+9ARAwvgChEv8w1wDYASsIihECJYoVBTCcAAAAIBIdGCAWAjCDEgMT
nAAAAB0I0QBgMJwAAAAdCNAA/zC9BwMcvgM+CD0EAxmwL1EYUBiML6EWATCcAAAAHQi4AAc5
AxnHL1EYUBjALyAewC8pMPYvUBxRHMcvPgg9BAMd/S8LMLIAIRf9LzIIJzoDHfgvoB2kCs0B
YzCcAAAAHQjRAKAZ9S8kCFEGAx3fL88w9i88MJwAAAAdCNEAATDRBtEUPDCcAFEIngA8MJwA
ngH/MNcA2AErCIoRAiWKFSAwsgD8Ly4XODCyACEXoRYhGwgAgCw=
--------------080404080901020300010309
Content-Type: text/x-patch;
 name="tt-s2-4600.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tt-s2-4600.patch"

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 0e2ec6f..ab0b94e 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -207,6 +207,13 @@ config DVB_SI21XX
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
+config DVB_TS2022
+        tristate "Montage TS2022 silicon tuner"
+        depends on DVB_CORE && I2C
+        default m if DVB_FE_CUSTOMISE
+          help
+          A DVB-S silicon tuner module. Say Y when you want to support this tuner.
+
 config DVB_TS2020
 	tristate "Montage Tehnology TS2020 based tuners"
 	depends on DVB_CORE && I2C
@@ -214,6 +221,13 @@ config DVB_TS2020
 	help
 	  A DVB-S/S2 silicon tuner. Say Y when you want to support this tuner.
 
+config DVB_DS3103
+        tristate "Montage DS3103 based"
+        depends on DVB_CORE && I2C
+        default m if DVB_FE_CUSTOMISE
+        help
+          A DVB-S/S2 tuner module. Say Y when you want to support this frontend.
+
 config DVB_DS3000
 	tristate "Montage Tehnology DS3000 based"
 	depends on DVB_CORE && I2C
diff --git a/drivers/media/dvb-frontends/ds3103.c b/drivers/media/dvb-frontends/ds3103.c
new file mode 100644
index 0000000..db8869f
--- /dev/null
+++ b/drivers/media/dvb-frontends/ds3103.c
@@ -0,0 +1,1304 @@
+/*
+    Montage Technology DS3103 - DVBS/S2 Demodulator driver
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/firmware.h>
+
+#include "dvb_frontend.h"
+#include "ds3103.h"
+
+static int debug;
+
+#define dprintk(args...) \
+	do { \
+		if (debug) \
+			printk(args); \
+	} while (0)
+
+#define DS3103_DEFAULT_FIRMWARE "dvb-fe-ds3103.fw"
+
+#define DS3000_SAMPLE_RATE 96000 /* in kHz */
+#define DS3000_XTAL_FREQ   27000 /* in kHz */
+
+static u8 ds310x_dvbs_init_tab[] = {
+	0x23, 0x07,
+	0x08, 0x03,
+	0x0c, 0x02,
+	0x21, 0x54,
+	0x25, 0x82,
+	0x27, 0x31,
+	0x30, 0x08,
+	0x31, 0x40,
+	0x32, 0x32,
+	0x33, 0x35,
+	0x35, 0xff,
+	0x3a, 0x00,
+	0x37, 0x10,
+	0x38, 0x10,
+	0x39, 0x02,
+	0x42, 0x60,
+	0x4a, 0x80,
+	0x4b, 0x04,
+	0x4d, 0x91,
+	0x5d, 0xc8,
+	0x50, 0x36,
+	0x51, 0x36,
+	0x52, 0x36,
+	0x53, 0x36,
+	0x63, 0x0f,
+	0x64, 0x30,
+	0x65, 0x40,
+	0x68, 0x26,
+	0x69, 0x4c,
+	0x70, 0x20,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0x40,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0x60,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0x80,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0xa0,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0x1f,
+	0x76, 0x38,
+	0x77, 0xa6,
+	0x78, 0x0c,
+	0x79, 0x80,
+	0x7f, 0x14,
+	0x7c, 0x00,
+	0xae, 0x82,
+	0x80, 0x64,
+	0x81, 0x66,
+	0x82, 0x44,
+	0x85, 0x04,
+	0xcd, 0xf4,
+	0x90, 0x33,
+	0xa0, 0x44,
+	0xc0, 0x08,
+	0xc3, 0x10,
+	0xc4, 0x08,
+	0xc5, 0xf0,
+	0xc6, 0xff,
+	0xc7, 0x00,
+	0xc8, 0x1a,
+	0xc9, 0x80,
+	0xe0, 0xf8,
+	0xe6, 0x8b,
+	0xd0, 0x40,
+	0xf8, 0x20,
+	0xfa, 0x0f,
+	0x00, 0x00,
+	0xbd, 0x01,
+	0xb8, 0x00
+};
+
+static u8 ds310x_dvbs2_init_tab[] = {
+	0x23, 0x07,
+	0x08, 0x07,
+	0x0c, 0x02,
+	0x21, 0x54,
+	0x25, 0x82,
+	0x27, 0x31,
+	0x30, 0x08,
+	0x32, 0x32,
+	0x33, 0x35,
+	0x35, 0xff,
+	0x3a, 0x00,
+	0x37, 0x10,
+	0x38, 0x10,
+	0x39, 0x02,
+	0x42, 0x60,
+	0x4a, 0x80,
+	0x4b, 0x04,
+	0x4d, 0x91,
+	0x5d, 0xc8,
+	0x50, 0x36,
+	0x51, 0x36,
+	0x52, 0x36,
+	0x53, 0x36,
+	0x63, 0x0f,
+	0x64, 0x10,
+	0x65, 0x20,
+	0x68, 0x46,
+	0x69, 0xcd,
+	0x70, 0x20,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0x40,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0x60,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0x80,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0xa0,
+	0x71, 0x70,
+	0x72, 0x04,
+	0x73, 0x00,
+	0x70, 0x1f,
+	0x76, 0x38,
+	0x77, 0xa6,
+	0x78, 0x0c,
+	0x79, 0x80,
+	0x7f, 0x14,
+	0x85, 0x08,
+	0xcd, 0xf4,
+	0x90, 0x33,
+	0x86, 0x00,
+	0x87, 0x0f,
+	0x89, 0x00,
+	0x8b, 0x44,
+	0x8c, 0x66,
+	0x9d, 0xc1,
+	0x8a, 0x10,
+	0xad, 0x40,
+	0xa0, 0x44,
+	0xc0, 0x08,
+	0xc1, 0x10,
+	0xc2, 0x08,
+	0xc3, 0x10,
+	0xc4, 0x08,
+	0xc5, 0xf0,
+	0xc6, 0xff,
+	0xc7, 0x00,
+	0xc8, 0x1a,
+	0xc9, 0x80,
+	0xca, 0x23,
+	0xcb, 0x24,
+	0xcc, 0xf4,
+	0xce, 0x74,
+	0x00, 0x00,
+	0xbd, 0x01,
+	0xb8, 0x00
+};
+
+struct ds3103_state {
+	struct i2c_adapter *i2c;
+	const struct ds3103_config *config;
+	struct dvb_frontend frontend;
+	u8 skip_fw_load;
+	/* previous uncorrected block counter for DVB-S2 */
+	u16 prevUCBS2;
+};
+
+static int ds3103_writereg(struct ds3103_state *state, int reg, int data)
+{
+	u8 buf[] = { reg, data };
+	struct i2c_msg msg = { .addr = state->config->demod_address,
+		.flags = 0, .buf = buf, .len = 2 };
+	int err;
+
+	dprintk("%s: write reg 0x%02x, value 0x%02x\n", __func__, reg, data);
+
+	err = i2c_transfer(state->i2c, &msg, 1);
+	if (err != 1) {
+		printk(KERN_ERR "%s: writereg error(err == %i, reg == 0x%02x,"
+			 " value == 0x%02x)\n", __func__, err, reg, data);
+		return -EREMOTEIO;
+	}
+
+	return 0;
+}
+
+/* I2C write for 8k firmware load */
+static int ds3103_writeFW(struct ds3103_state *state, int reg,
+				const u8 *data, u16 len)
+{
+	int i, ret = -EREMOTEIO;
+	struct i2c_msg msg;
+	u8 *buf;
+
+	buf = kmalloc(33, GFP_KERNEL);
+	if (buf == NULL) {
+		printk(KERN_ERR "Unable to kmalloc\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	*(buf) = reg;
+
+	msg.addr = state->config->demod_address;
+	msg.flags = 0;
+	msg.buf = buf;
+	msg.len = 33;
+   
+	for (i = 0; i < len; i += 32) {
+		memcpy(buf + 1, data + i, 32);
+
+		dprintk("%s: write reg 0x%02x, len = %d\n", __func__, reg, len);
+
+		ret = i2c_transfer(state->i2c, &msg, 1);
+		if (ret != 1) {
+			printk(KERN_ERR "%s: write error(err == %i, "
+				"reg == 0x%02x\n", __func__, ret, reg);
+			ret = -EREMOTEIO;
+		}
+	}
+
+error:
+	kfree(buf);
+
+	return ret;
+}
+
+static int ds3103_readreg(struct ds3103_state *state, u8 reg)
+{
+	int ret;
+	u8 b0[] = { reg };
+	u8 b1[] = { 0 };
+	struct i2c_msg msg[] = {
+		{
+			.addr = state->config->demod_address,
+			.flags = 0,
+			.buf = b0,
+			.len = 1
+		}, {
+			.addr = state->config->demod_address,
+			.flags = I2C_M_RD,
+			.buf = b1,
+			.len = 1
+		}
+	};
+
+	ret = i2c_transfer(state->i2c, msg, 2);
+
+	if (ret != 2) {
+		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, reg, ret);
+		return ret;
+	}
+
+	dprintk("%s: read reg 0x%02x, value 0x%02x\n", __func__, reg, b1[0]);
+
+	return b1[0];
+}
+
+static int ds3103_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	
+	if (enable)
+		ds3103_writereg(state, 0x03, 0x12);
+	else
+		ds3103_writereg(state, 0x03, 0x02);
+	
+	return 0;
+}
+static int ds3103_load_firmware(struct dvb_frontend *fe,
+					const struct firmware *fw);
+
+static int ds3103_firmware_ondemand(struct dvb_frontend *fe)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	const struct firmware *fw;
+	int ret = 0;
+
+	dprintk("%s()\n", __func__);
+
+	if (ds3103_readreg(state, 0xb2) <= 0)
+		return ret;
+
+	if (state->skip_fw_load)
+		return 0;
+
+	/* global reset, global diseqc reset, golbal fec reset */
+	ds3103_writereg(state, 0x07, 0xe0);
+	ds3103_writereg(state, 0x07, 0x00);
+
+	/* request the firmware, this will block until someone uploads it */
+	printk(KERN_INFO "%s: Waiting for firmware upload (%s)...\n", __func__,
+				DS3103_DEFAULT_FIRMWARE);
+	ret = request_firmware(&fw, DS3103_DEFAULT_FIRMWARE,
+				state->i2c->dev.parent);
+	printk(KERN_INFO "%s: Waiting for firmware upload(2)...\n", __func__);
+	if (ret) {
+		printk(KERN_ERR "%s: No firmware uploaded (timeout or file not "
+				"found?)\n", __func__);
+		return ret;
+	}
+
+	/* Make sure we don't recurse back through here during loading */
+	state->skip_fw_load = 1;
+
+	ret = ds3103_load_firmware(fe, fw);
+	if (ret)
+		printk("%s: Writing firmware to device failed\n", __func__);
+
+	release_firmware(fw);
+
+	dprintk("%s: Firmware upload %s\n", __func__,
+			ret == 0 ? "complete" : "failed");
+
+	/* Ensure firmware is always loaded if required */
+	state->skip_fw_load = 0;
+
+	return ret;
+}
+
+static int ds3103_load_firmware(struct dvb_frontend *fe,
+					const struct firmware *fw)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+
+	dprintk("%s\n", __func__);
+	dprintk("Firmware is %zu bytes (%02x %02x .. %02x %02x)\n",
+			fw->size,
+			fw->data[0],
+			fw->data[1],
+			fw->data[fw->size - 2],
+			fw->data[fw->size - 1]);
+
+	/* Begin the firmware load process */
+	ds3103_writereg(state, 0xb2, 0x01);
+	/* write the entire firmware */
+	ds3103_writeFW(state, 0xb0, fw->data, fw->size);
+	ds3103_writereg(state, 0xb2, 0x00);
+
+	return 0;
+}
+
+static int ds3103_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	u8 data;
+
+	dprintk("%s(%d)\n", __func__, voltage);
+
+	data = ds3103_readreg(state, 0xa2);
+	data |= 0x03; /* bit0 V/H, bit1 off/on */
+
+	switch (voltage) {
+	case SEC_VOLTAGE_18:
+		data &= ~0x03;
+		break;
+	case SEC_VOLTAGE_13:
+		data &= ~0x03;
+		data |= 0x01;
+		break;
+	case SEC_VOLTAGE_OFF:
+		break;
+	}
+
+	ds3103_writereg(state, 0xa2, data);
+
+	return 0;
+}
+
+static int ds3103_read_status(struct dvb_frontend *fe, fe_status_t* status)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int lock;
+
+	*status = 0;
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		lock = ds3103_readreg(state, 0xd1);
+		if ((lock & 0x07) == 0x07)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+				FE_HAS_VITERBI | FE_HAS_SYNC |
+				FE_HAS_LOCK;
+
+		break;
+	case SYS_DVBS2:
+		lock = ds3103_readreg(state, 0x0d);
+		if ((lock & 0x8f) == 0x8f)
+			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+				FE_HAS_VITERBI | FE_HAS_SYNC |
+				FE_HAS_LOCK;
+
+		break;
+	default:
+		return 1;
+	}
+
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, *status == 0 ? 0 : 1);
+
+	dprintk("%s: status = 0x%02x\n", __func__, lock);
+
+	return 0;
+}
+
+/* read DS3000 BER value */
+static int ds3103_read_ber(struct dvb_frontend *fe, u32* ber)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u8 data;
+	u32 ber_reading, lpdc_frames;
+
+	dprintk("%s()\n", __func__);
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		/* set the number of bytes checked during
+		BER estimation */
+		ds3103_writereg(state, 0xf9, 0x04);
+		/* read BER estimation status */
+		data = ds3103_readreg(state, 0xf8);
+		/* check if BER estimation is ready */
+		if ((data & 0x10) == 0) {
+			/* this is the number of error bits,
+			to calculate the bit error rate
+			divide to 8388608 */
+			*ber = (ds3103_readreg(state, 0xf7) << 8) |
+				ds3103_readreg(state, 0xf6);
+			/* start counting error bits */
+			/* need to be set twice
+			otherwise it fails sometimes */
+			data |= 0x10;
+			ds3103_writereg(state, 0xf8, data);
+			ds3103_writereg(state, 0xf8, data);
+		} else
+			/* used to indicate that BER estimation
+			is not ready, i.e. BER is unknown */
+			*ber = 0xffffffff;
+		break;
+	case SYS_DVBS2:
+		/* read the number of LPDC decoded frames */
+		lpdc_frames = (ds3103_readreg(state, 0xd7) << 16) |
+				(ds3103_readreg(state, 0xd6) << 8) |
+				ds3103_readreg(state, 0xd5);
+		/* read the number of packets with bad CRC */
+		ber_reading = (ds3103_readreg(state, 0xf8) << 8) |
+				ds3103_readreg(state, 0xf7);
+		if (lpdc_frames > 750) {
+			/* clear LPDC frame counters */
+			ds3103_writereg(state, 0xd1, 0x01);
+			/* clear bad packets counter */
+			ds3103_writereg(state, 0xf9, 0x01);
+			/* enable bad packets counter */
+			ds3103_writereg(state, 0xf9, 0x00);
+			/* enable LPDC frame counters */
+			ds3103_writereg(state, 0xd1, 0x00);
+			*ber = ber_reading;
+		} else
+			/* used to indicate that BER estimation is not ready,
+			i.e. BER is unknown */
+			*ber = 0xffffffff;
+		break;
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+/* calculate DS3000 snr value in dB */
+static int ds3103_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u8 snr_reading, snr_value;
+	u32 dvbs2_signal_reading, dvbs2_noise_reading, tmp;
+	static const u16 dvbs_snr_tab[] = { /* 20 x Table (rounded up) */
+		0x0000, 0x1b13, 0x2aea, 0x3627, 0x3ede, 0x45fe, 0x4c03,
+		0x513a, 0x55d4, 0x59f2, 0x5dab, 0x6111, 0x6431, 0x6717,
+		0x69c9, 0x6c4e, 0x6eac, 0x70e8, 0x7304, 0x7505
+	};
+	static const u16 dvbs2_snr_tab[] = { /* 80 x Table (rounded up) */
+		0x0000, 0x0bc2, 0x12a3, 0x1785, 0x1b4e, 0x1e65, 0x2103,
+		0x2347, 0x2546, 0x2710, 0x28ae, 0x2a28, 0x2b83, 0x2cc5,
+		0x2df1, 0x2f09, 0x3010, 0x3109, 0x31f4, 0x32d2, 0x33a6,
+		0x3470, 0x3531, 0x35ea, 0x369b, 0x3746, 0x37ea, 0x3888,
+		0x3920, 0x39b3, 0x3a42, 0x3acc, 0x3b51, 0x3bd3, 0x3c51,
+		0x3ccb, 0x3d42, 0x3db6, 0x3e27, 0x3e95, 0x3f00, 0x3f68,
+		0x3fcf, 0x4033, 0x4094, 0x40f4, 0x4151, 0x41ac, 0x4206,
+		0x425e, 0x42b4, 0x4308, 0x435b, 0x43ac, 0x43fc, 0x444a,
+		0x4497, 0x44e2, 0x452d, 0x4576, 0x45bd, 0x4604, 0x4649,
+		0x468e, 0x46d1, 0x4713, 0x4755, 0x4795, 0x47d4, 0x4813,
+		0x4851, 0x488d, 0x48c9, 0x4904, 0x493f, 0x4978, 0x49b1,
+		0x49e9, 0x4a20, 0x4a57
+	};
+
+	dprintk("%s()\n", __func__);
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		snr_reading = ds3103_readreg(state, 0xff);
+		snr_reading /= 8;
+		if (snr_reading == 0)
+			*snr = 0x0000;
+		else {
+			if (snr_reading > 20)
+				snr_reading = 20;
+			snr_value = dvbs_snr_tab[snr_reading - 1] * 10 / 23026;
+			/* cook the value to be suitable for szap-s2
+			human readable output */
+			*snr = snr_value * 8 * 655;
+		}
+		dprintk("%s: raw / cooked = 0x%02x / 0x%04x\n", __func__,
+				snr_reading, *snr);
+		break;
+	case SYS_DVBS2:
+		dvbs2_noise_reading = (ds3103_readreg(state, 0x8c) & 0x3f) +
+				(ds3103_readreg(state, 0x8d) << 4);
+		dvbs2_signal_reading = ds3103_readreg(state, 0x8e);
+		tmp = dvbs2_signal_reading * dvbs2_signal_reading >> 1;
+		if (tmp == 0) {
+			*snr = 0x0000;
+			return 0;
+		}
+		if (dvbs2_noise_reading == 0) {
+			snr_value = 0x0013;
+			/* cook the value to be suitable for szap-s2
+			human readable output */
+			*snr = 0xffff;
+			return 0;
+		}
+		if (tmp > dvbs2_noise_reading) {
+			snr_reading = tmp / dvbs2_noise_reading;
+			if (snr_reading > 80)
+				snr_reading = 80;
+			snr_value = dvbs2_snr_tab[snr_reading - 1] / 1000;
+			/* cook the value to be suitable for szap-s2
+			human readable output */
+			*snr = snr_value * 5 * 655;
+		} else {
+			snr_reading = dvbs2_noise_reading / tmp;
+			if (snr_reading > 80)
+				snr_reading = 80;
+			*snr = -(dvbs2_snr_tab[snr_reading] / 1000);
+		}
+		dprintk("%s: raw / cooked = 0x%02x / 0x%04x\n", __func__,
+				snr_reading, *snr);
+		break;
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+/* read DS3000 uncorrected blocks */
+static int ds3103_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u8 data;
+	u16 _ucblocks;
+
+	dprintk("%s()\n", __func__);
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		*ucblocks = (ds3103_readreg(state, 0xf5) << 8) |
+				ds3103_readreg(state, 0xf4);
+		data = ds3103_readreg(state, 0xf8);
+		/* clear packet counters */
+		data &= ~0x20;
+		ds3103_writereg(state, 0xf8, data);
+		/* enable packet counters */
+		data |= 0x20;
+		ds3103_writereg(state, 0xf8, data);
+		break;
+	case SYS_DVBS2:
+		_ucblocks = (ds3103_readreg(state, 0xe2) << 8) |
+				ds3103_readreg(state, 0xe1);
+		if (_ucblocks > state->prevUCBS2)
+			*ucblocks = _ucblocks - state->prevUCBS2;
+		else
+			*ucblocks = state->prevUCBS2 - _ucblocks;
+		state->prevUCBS2 = _ucblocks;
+		break;
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+static int ds3103_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	u8 data;
+
+	dprintk("%s(%d)\n", __func__, tone);
+	if ((tone != SEC_TONE_ON) && (tone != SEC_TONE_OFF)) {
+		printk(KERN_ERR "%s: Invalid, tone=%d\n", __func__, tone);
+		return -EINVAL;
+	}
+
+	data = ds3103_readreg(state, 0xa2);
+	data &= ~0xc0;
+	ds3103_writereg(state, 0xa2, data);
+
+	switch (tone) {
+	case SEC_TONE_ON:
+		dprintk("%s: setting tone on\n", __func__);
+		data = ds3103_readreg(state, 0xa1);
+		data &= ~0x43;
+		data |= 0x04;
+		ds3103_writereg(state, 0xa1, data);
+		break;
+	case SEC_TONE_OFF:
+		dprintk("%s: setting tone off\n", __func__);
+		data = ds3103_readreg(state, 0xa2);
+		data |= 0x80;
+		ds3103_writereg(state, 0xa2, data);
+		break;
+	}
+
+	return 0;
+}
+
+static int ds3103_send_diseqc_msg(struct dvb_frontend *fe,
+				struct dvb_diseqc_master_cmd *d)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	int i;
+	u8 data;
+
+	/* Dump DiSEqC message */
+	dprintk("%s(", __func__);
+	for (i = 0 ; i < d->msg_len;) {
+		dprintk("0x%02x", d->msg[i]);
+		if (++i < d->msg_len)
+			dprintk(", ");
+	}
+
+	/* enable DiSEqC message send pin */
+	data = ds3103_readreg(state, 0xa2);
+	data &= ~0xc0;
+	data &= ~0x20;
+	ds3103_writereg(state, 0xa2, data);
+
+	/* DiSEqC message */
+	for (i = 0; i < d->msg_len; i++)
+		ds3103_writereg(state, 0xa3 + i, d->msg[i]);
+
+	data = ds3103_readreg(state, 0xa1);
+	/* clear DiSEqC message length and status,
+	enable DiSEqC message send */
+	data &= ~0xf8;
+	/* set DiSEqC mode, modulation active during 33 pulses,
+	set DiSEqC message length */
+	data |= ((d->msg_len - 1) << 3) | 0x07;
+	ds3103_writereg(state, 0xa1, data);
+
+	/* wait up to 150ms for DiSEqC transmission to complete */
+	for (i = 0; i < 15; i++) {
+		data = ds3103_readreg(state, 0xa1);
+		if ((data & 0x40) == 0)
+			break;
+		msleep(10);
+	}
+
+	/* DiSEqC timeout after 150ms */
+	if (i == 15) {
+		data = ds3103_readreg(state, 0xa1);
+		data &= ~0x80;
+		data |= 0x40;
+		ds3103_writereg(state, 0xa1, data);
+
+		data = ds3103_readreg(state, 0xa2);
+		data &= ~0xc0;
+		data |= 0x80;
+		ds3103_writereg(state, 0xa2, data);
+
+		return 1;
+	}
+
+	data = ds3103_readreg(state, 0xa2);
+	data &= ~0xc0;
+	data |= 0x80;
+	ds3103_writereg(state, 0xa2, data);
+
+	return 0;
+}
+
+/* Send DiSEqC burst */
+static int ds3103_diseqc_send_burst(struct dvb_frontend *fe,
+					fe_sec_mini_cmd_t burst)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	int i;
+	u8 data;
+
+	dprintk("%s()\n", __func__);
+
+	data = ds3103_readreg(state, 0xa2);
+	data &= ~0xc0;
+	data &= ~0x20;
+	ds3103_writereg(state, 0xa2, data);
+
+	/* DiSEqC burst */
+	if (burst == SEC_MINI_A)
+		/* Unmodulated tone burst */
+		ds3103_writereg(state, 0xa1, 0x02);
+	else if (burst == SEC_MINI_B)
+		/* Modulated tone burst */
+		ds3103_writereg(state, 0xa1, 0x01);
+	else
+		return -EINVAL;
+
+	msleep(13);
+	for (i = 0; i < 5; i++) {
+		data = ds3103_readreg(state, 0xa1);
+		if ((data & 0x40) == 0)
+			break;
+		msleep(1);
+	}
+
+	if (i == 5) {
+		data = ds3103_readreg(state, 0xa1);
+		data &= ~0x80;
+		data |= 0x40;
+		ds3103_writereg(state, 0xa1, data);
+
+		data = ds3103_readreg(state, 0xa2);
+		data &= ~0xc0;
+		data |= 0x80;
+		ds3103_writereg(state, 0xa2, data);
+
+		return 1;
+	}
+
+	data = ds3103_readreg(state, 0xa2);
+	data &= ~0xc0;
+	data |= 0x80;
+	ds3103_writereg(state, 0xa2, data);
+
+	return 0;
+}
+
+static void ds3103_release(struct dvb_frontend *fe)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, 0);
+
+	dprintk("%s\n", __func__);
+	kfree(state);
+}
+
+static struct dvb_frontend_ops ds3103_ops;
+
+struct dvb_frontend *ds3103_attach(const struct ds3103_config *config,
+				    struct i2c_adapter *i2c)
+{
+	struct ds3103_state *state = NULL;
+	int ret;
+	u8 val_01, val_02, val_b2;
+
+
+	dprintk("%s\n", __func__);
+
+	/* allocate memory for the internal state */
+	state = kzalloc(sizeof(struct ds3103_state), GFP_KERNEL);
+	if (state == NULL) {
+		printk(KERN_ERR "Unable to kmalloc\n");
+		goto error2;
+	}
+
+	state->config = config;
+	state->i2c = i2c;
+	state->prevUCBS2 = 0;
+
+	/* check if the demod is present */
+	ret = ds3103_readreg(state, 0x00) & 0xfe;
+	if (ret != 0xe0) {
+		printk(KERN_ERR "Invalid probe, probably not a DS3x0x\n");
+		goto error3;
+	}
+
+	/* check demod chip ID */
+	val_01 = ds3103_readreg(state, 0x01);
+	val_02 = ds3103_readreg(state, 0x02);
+	val_b2 = ds3103_readreg(state, 0xb2);
+	if((val_02 == 0x00) &&
+			(val_01 == 0xD0) && ((val_b2 & 0xC0) == 0xC0)) {
+		printk("\tChip ID = [DS3103]!\n");
+	} else if((val_02 == 0x00) &&
+			(val_01 == 0xD0) && ((val_b2 & 0xC0) == 0x00)) {
+		printk("\tChip ID = [DS3002B]!\n");
+	} else if ((val_02 == 0x00) && (val_01 == 0xC0)) {
+		printk("\tChip ID = [DS300X]! Not supported by this module\n");
+		goto error3;
+	} else {
+		printk("\tChip ID = unknow!\n");
+		goto error3;
+	}
+
+	printk(KERN_INFO "DS3103 chip version: %d.%d attached.\n", val_02, val_01);
+
+	memcpy(&state->frontend.ops, &ds3103_ops,
+			sizeof(struct dvb_frontend_ops));
+	state->frontend.demodulator_priv = state;
+	return &state->frontend;
+
+error3:
+	kfree(state);
+error2:
+	return NULL;
+}
+EXPORT_SYMBOL(ds3103_attach);
+
+static int ds3103_set_carrier_offset(struct dvb_frontend *fe,
+					s32 carrier_offset_khz)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	s32 tmp;
+
+	tmp = carrier_offset_khz;
+	tmp *= 65536;
+	tmp = (2 * tmp + DS3000_SAMPLE_RATE) / (2 * DS3000_SAMPLE_RATE);
+
+	if (tmp < 0)
+		tmp += 65536;
+
+	ds3103_writereg(state, 0x5f, tmp >> 8);
+	ds3103_writereg(state, 0x5e, tmp & 0xff);
+
+	return 0;
+}
+static int ds3103_setTSdiv(struct ds3103_state *state, int type, u8 tmp1, u8 tmp2)
+{
+	u8 buf;
+	if (type == SYS_DVBS) {
+		tmp1 -= 1;
+		tmp2 -= 1;
+
+		tmp1 &= 0x3f;
+		tmp2 &= 0x3f;
+
+		buf = ds3103_readreg(state, 0xfe);
+		buf &= 0xF0;
+		buf |= (tmp1 >> 2) & 0x0f;
+		ds3103_writereg(state, 0xfe, buf);
+
+		buf = (u8)((tmp1 & 0x03) << 6);
+		buf |= tmp2;
+		ds3103_writereg(state, 0xea, buf);
+
+	} else if(type == SYS_DVBS2) {
+		tmp1 -= 1;
+		tmp2 -= 1;
+
+		tmp1 &= 0x3f;
+		tmp2 &= 0x3f;
+
+		buf = ds3103_readreg(state, 0xfe);
+		buf &= 0xF0;			// bits[3:0]
+		buf |= (tmp1 >> 2) & 0x0f;
+		ds3103_writereg(state, 0xfe, buf);
+
+		buf = (u8)((tmp1 & 0x03) << 6);	// ci_divrange_h_0 bits[1:0]
+		buf |= tmp2;			// ci_divrange_l   bits[5:0]
+		ds3103_writereg(state, 0xea, buf);
+	}
+
+	return 0;
+}
+
+static int ds3103_set_frontend(struct dvb_frontend *fe)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	int i;
+	fe_status_t status;
+	s32 offset_khz;
+	u32 tuner_freq;
+	u16 value;//, ndiv=0;
+	u32 			tmp;
+	u8			tmp1, tmp2;
+	u32			target_mclk = 0;
+	u32			ts_clk = 24000;
+	u16			divide_ratio;
+
+	dprintk("%s() frec=%d symb=%d", __func__, c->frequency, c->symbol_rate);
+
+	if (state->config->set_ts_params)
+		state->config->set_ts_params(fe, 0);
+
+	if (fe->ops.tuner_ops.set_params)
+		fe->ops.tuner_ops.set_params(fe);
+	
+
+	ds3103_writereg(state, 0xb2, 0x01);
+		ds3103_writereg(state, 0x00, 0x01);
+
+	if (fe->ops.tuner_ops.get_frequency)
+		fe->ops.tuner_ops.get_frequency(fe, &tuner_freq);
+
+	offset_khz = tuner_freq - c->frequency;
+
+	value = ds3103_readreg(state, 0x08);
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		/* initialise the demod in DVB-S mode */
+		value &= ~0x04;
+		ds3103_writereg(state, 0x08, value);
+			for (i = 0; i < sizeof(ds310x_dvbs_init_tab); i += 2)
+				ds3103_writereg(state,
+					ds310x_dvbs_init_tab[i],
+					ds310x_dvbs_init_tab[i + 1]);
+
+		ts_clk = 8000;
+		target_mclk = 96000;
+
+			value = ds3103_readreg(state, 0x4d);
+			value &= ~0x02;
+			ds3103_writereg(state, 0x4d, value);
+			value = ds3103_readreg(state, 0x30);
+			value &= ~0x10;
+			ds3103_writereg(state, 0x30, value);
+
+		break;
+	case SYS_DVBS2:
+		/* initialise the demod in DVB-S2 mode */
+		value |= 0x04;
+		ds3103_writereg(state, 0x08, value);
+			for (i = 0; i < sizeof(ds310x_dvbs2_init_tab); i += 2)
+				ds3103_writereg(state,
+					ds310x_dvbs2_init_tab[i],
+					ds310x_dvbs2_init_tab[i + 1]);
+		ts_clk = 8471;
+			value = ds3103_readreg(state, 0x4d);
+			value &= ~0x02;
+			ds3103_writereg(state, 0x4d, value);
+			value = ds3103_readreg(state, 0x30);
+			value &= ~0x10;
+			ds3103_writereg(state, 0x30, value);
+			if(c->symbol_rate > 28000000) {
+				target_mclk = 192000;
+			} else if(c->symbol_rate > 18000000) {
+				target_mclk = 144000;
+			} else
+				target_mclk = 96000;
+
+
+		if (c->symbol_rate <= 5000000) {
+			ds3103_writereg(state, 0xc0, 0x04);
+			ds3103_writereg(state, 0x8a, 0x09);
+			ds3103_writereg(state, 0x8b, 0x22);
+			ds3103_writereg(state, 0x8c, 0x88);
+		}
+
+		break;
+	default:
+		return 1;
+	}
+	divide_ratio = (target_mclk + ts_clk - 1) / ts_clk;
+
+	if (divide_ratio > 128)
+		divide_ratio = 128;
+
+	if (divide_ratio < 2)
+		divide_ratio = 2;
+
+	tmp1 = (u8)(divide_ratio / 2);
+	tmp2 = (u8)(divide_ratio / 2);
+
+	if ((divide_ratio % 2) != 0)
+		tmp2 += 1;
+
+	ds3103_setTSdiv(state, c->delivery_system, tmp1, tmp2);
+
+		tmp1 = ds3103_readreg(state, 0x22);
+		tmp2 = ds3103_readreg(state, 0x24);
+
+		switch (target_mclk) {
+		case 192000:		// 4b'0011 MCLK = 192M
+			tmp1 |= 0xc0;		// 0x22 bit[7:6] = 2b'11
+			tmp2 &= 0x3f;		// 0x24 bit[7:6] = 2b'00
+			break;
+
+		case 144000:		// 4b'0100 MCLK = 144M
+			tmp1 &= 0x3f;		// 0x22 bit[7:6] = 2b'00
+			tmp2 &= 0x7f;		// 0x24 bit[7:6] = 2b'01
+			tmp2 |= 0x40;
+			break;
+
+		case 115200:		// 4b'0101 MCLK = 115.2M
+			tmp1 &= 0x7f;		// 0x22 bit[7:6] = 2b'01
+			tmp1 |= 0x40;
+			tmp2 &= 0x7f;		// 0x24 bit[7:6] = 2b'01
+			tmp2 |= 0x40;
+			break;
+
+		case 72000:			// 4b'1100 MCLK = 72M
+			tmp2 |= 0xc0;		// 0x24 bit[7:6] = 2b'11
+			tmp1 &= 0x3f;		// 0x22 bit[7:6] = 2b'00
+			break;
+
+		case 96000:			// 4b'0110 MCLK = 96M
+		default:
+			tmp1 &= 0xbf;		// 0x22 bit[7:6] = 2b'10
+			tmp1 |= 0x80;
+
+			tmp2 &= 0x7f;		// 0x24 bit[7:6] = 2b'01
+			tmp2 |= 0x40;
+			break;
+		}
+
+		ds3103_writereg(state, 0x22, tmp1);
+		ds3103_writereg(state, 0x24, tmp2);
+	ds3103_writereg(state, 0x33, 0x99);
+
+
+	/* enable 27MHz clock output */
+	value = ds3103_readreg(state, 0x29);
+	value |= 0x80;
+	value &= ~0x10;
+	ds3103_writereg(state, 0x29, value);
+
+	/* enable ac coupling */
+	value = ds3103_readreg(state, 0x25);
+	value |= 0x08;
+	ds3103_writereg(state, 0x25, value);
+
+
+	/* enhance symbol rate performance */
+	if ((c->symbol_rate / 1000) <= 3000) {
+		ds3103_writereg(state, 0xc3, 0x08); // 8 * 32 * 100 / 64 = 400
+		ds3103_writereg(state, 0xc8, 0x20);
+		ds3103_writereg(state, 0xc4, 0x08); // 8 * 0 * 100 / 128 = 0
+		ds3103_writereg(state, 0xc7, 0x00);
+	} else if((c->symbol_rate / 1000) <= 10000) {
+		ds3103_writereg(state, 0xc3, 0x08); // 8 * 16 * 100 / 64 = 200
+		ds3103_writereg(state, 0xc8, 0x10);
+		ds3103_writereg(state, 0xc4, 0x08); // 8 * 0 * 100 / 128 = 0
+		ds3103_writereg(state, 0xc7, 0x00);
+	} else {
+		ds3103_writereg(state, 0xc3, 0x08); // 8 * 6 * 100 / 64 = 75
+		ds3103_writereg(state, 0xc8, 0x06);
+		ds3103_writereg(state, 0xc4, 0x08); // 8 * 0 * 100 / 128 = 0
+		ds3103_writereg(state, 0xc7, 0x00);
+	}
+
+	/* normalized symbol rate rounded to the closest integer */
+	tmp = (u32)((((c->symbol_rate / 1000) << 15) + (DS3000_SAMPLE_RATE / 4)) / (DS3000_SAMPLE_RATE / 2));
+
+	ds3103_writereg(state, 0x61, tmp & 0x00ff);
+	ds3103_writereg(state, 0x62, (tmp & 0xff00) >> 8);
+
+	/* co-channel interference cancellation disabled */
+	value = ds3103_readreg(state, 0x56);
+		value &= ~0x01;
+	ds3103_writereg(state, 0x56, value);
+	/* equalizer disabled */
+	value = ds3103_readreg(state, 0x76);
+	value &= ~0x80;
+	ds3103_writereg(state, 0x76, value);
+	//offset
+	if ((c->symbol_rate / 1000) < 5000)
+		offset_khz += 3000;
+	ds3103_set_carrier_offset(fe, offset_khz);
+
+	/* ds3000 out of software reset */
+	ds3103_writereg(state, 0x00, 0x00);
+	/* start ds3000 build-in uC */
+	ds3103_writereg(state, 0xb2, 0x00);
+
+
+	for (i = 0; i < 30 ; i++) {
+		ds3103_read_status(fe, &status);
+		if (status && FE_HAS_LOCK)
+			break;
+
+		msleep(10);
+	}
+
+	return 0;
+}
+
+static int ds3103_tune(struct dvb_frontend *fe,
+			bool re_tune,
+			unsigned int mode_flags,
+			unsigned int *delay,
+			fe_status_t *status)
+{
+	if (re_tune) {
+		int ret = ds3103_set_frontend(fe);
+		if (ret)
+			return ret;
+	}
+
+	*delay = HZ / 5;
+
+	return ds3103_read_status(fe, status);
+}
+
+static enum dvbfe_algo ds3103_get_algo(struct dvb_frontend *fe)
+{
+	dprintk("%s()\n", __func__);
+	return DVBFE_ALGO_HW;
+}
+
+/*
+ * Initialize or wake up device
+ *
+ * Power config will reset and load initial firmware if required
+ */
+static int ds3103_initfe(struct dvb_frontend *fe)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+	int ret;
+	u8 buf;
+	u8 val_08;
+
+	dprintk("%s()\n", __func__);
+	/* hard reset */
+	buf = ds3103_readreg(state, 0xb2);
+	if(buf == 0x01) {
+		ds3103_writereg(state, 0x00, 0x00);
+		ds3103_writereg(state, 0xb2, 0x00);
+	}
+
+	ds3103_writereg(state, 0x07, 0x80);
+	ds3103_writereg(state, 0x07, 0x00);
+	ds3103_writereg(state, 0x08, 0x01 | ds3103_readreg(state, 0x08));
+	msleep(1);
+
+	/* Load the firmware if required */
+	ret = ds3103_firmware_ondemand(fe);
+	if (ret != 0) {
+		printk(KERN_ERR "%s: Unable initialize firmware\n", __func__);
+		return ret;
+	}
+	//TS mode
+	val_08 = ds3103_readreg(state, 0x08);
+	buf = ds3103_readreg(state, 0x27);
+	buf &= ~0x01;
+	ds3103_writereg(state, 0x27, buf);
+	//dvbs
+	buf = val_08 & (~0x04) ;
+	ds3103_writereg(state, 0x08, buf);
+	ds3103_setTSdiv(state, SYS_DVBS, 6, 6);
+	buf = ds3103_readreg(state, 0xfd);
+	buf |= 0x80;
+	buf &= ~0x40;
+	if (state->config->ci_mode)
+		buf |= 0x20;
+        else
+		buf &= ~0x20;
+	buf &= ~0x1f;
+	ds3103_writereg(state, 0xfd, buf);
+
+	//S2
+	buf = val_08 | 0x04 ;
+	ds3103_writereg(state, 0x08, buf);
+	ds3103_setTSdiv(state, SYS_DVBS2, 8, 9);
+	buf = ds3103_readreg(state, 0xfd);
+	buf |= 0x01;
+	buf &= ~0x04;
+	buf &= ~0xba;
+	if (state->config->ci_mode)
+		buf |= 0x40;
+	else
+		buf &= ~0x40;
+
+	ds3103_writereg(state, 0xfd, buf);
+	ds3103_writereg(state, 0x08, val_08);
+
+	buf = ds3103_readreg(state, 0x27);
+	buf |= 0x11;
+	ds3103_writereg(state, 0x27, buf);
+
+	buf = ds3103_readreg(state, 0x4d);
+	buf &= ~0x02;
+	ds3103_writereg(state, 0x4d, buf);
+	buf = ds3103_readreg(state, 0x30);
+	buf &= ~0x10;
+	ds3103_writereg(state, 0x30, buf);
+
+	return 0;
+}
+
+/* Put device to sleep */
+static int ds3103_sleep(struct dvb_frontend *fe)
+{
+	struct ds3103_state *state = fe->demodulator_priv;
+
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, 0);
+
+	dprintk("%s()\n", __func__);
+	return 0;
+}
+
+static struct dvb_frontend_ops ds3103_ops = {
+	.delsys = { SYS_DVBS, SYS_DVBS2},
+	.info = {
+		.name = "Montage Technology DS3103/TS2022",
+		.frequency_min = 950000,
+		.frequency_max = 2150000,
+		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
+		.frequency_tolerance = 5000,
+		.symbol_rate_min = 1000000,
+		.symbol_rate_max = 45000000,
+		.caps = FE_CAN_INVERSION_AUTO |
+			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
+			FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
+			FE_CAN_2G_MODULATION |
+			FE_CAN_QPSK | FE_CAN_RECOVER
+	},
+
+	.release = ds3103_release,
+
+	.init = ds3103_initfe,
+	.sleep = ds3103_sleep,
+	.read_status = ds3103_read_status,
+	.read_ber = ds3103_read_ber,
+	.i2c_gate_ctrl = ds3103_i2c_gate_ctrl,
+	.read_snr = ds3103_read_snr,
+	.read_ucblocks = ds3103_read_ucblocks,
+	.set_voltage = ds3103_set_voltage,
+	.set_tone = ds3103_set_tone,
+	.diseqc_send_master_cmd = ds3103_send_diseqc_msg,
+	.diseqc_send_burst = ds3103_diseqc_send_burst,
+	.get_frontend_algo = ds3103_get_algo,
+
+	.set_frontend = ds3103_set_frontend,
+	.tune = ds3103_tune,
+};
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
+
+MODULE_DESCRIPTION("DVB Frontend module for Montage Technology "
+			"DS3103 hardware");
+MODULE_AUTHOR("Tomazzo Muzumici");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/ds3103.h b/drivers/media/dvb-frontends/ds3103.h
new file mode 100644
index 0000000..e52740c
--- /dev/null
+++ b/drivers/media/dvb-frontends/ds3103.h
@@ -0,0 +1,47 @@
+/*
+    Montage Technology DS3103 - DVBS/S2 Demodulator driver
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#ifndef DS3103_H
+#define DS3103_H
+
+#include <linux/dvb/frontend.h>
+
+struct ds3103_config {
+	/* the demodulator's i2c address */
+	u8 demod_address;
+	u8 ci_mode;
+	/* Set device param to start dma */
+	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
+	/* Hook for Lock LED */
+	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
+};
+
+#if defined(CONFIG_DVB_DS3103) || \
+			(defined(CONFIG_DVB_DS3103_MODULE) && defined(MODULE))
+extern struct dvb_frontend *ds3103_attach(const struct ds3103_config *config,
+					struct i2c_adapter *i2c);
+#else
+static inline
+struct dvb_frontend *ds3103_attach(const struct ds3103_config *config,
+					struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_DS3103 */
+#endif /* DS3103_H */
diff --git a/drivers/media/dvb-frontends/ts2022.c b/drivers/media/dvb-frontends/ts2022.c
new file mode 100644
index 0000000..cd4ca11
--- /dev/null
+++ b/drivers/media/dvb-frontends/ts2022.c
@@ -0,0 +1,453 @@
+  /*
+     Driver for Montage ts2022 DVBS/S2 Silicon tuner
+
+     Copyright (C) 2012 Tomazzo Muzumici
+
+     This program is free software; you can redistribute it and/or modify
+     it under the terms of the GNU General Public License as published by
+     the Free Software Foundation; either version 2 of the License, or
+     (at your option) any later version.
+
+     This program is distributed in the hope that it will be useful,
+     but WITHOUT ANY WARRANTY; without even the implied warranty of
+     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+
+     GNU General Public License for more details.
+
+     You should have received a copy of the GNU General Public License
+     along with this program; if not, write to the Free Software
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+  */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/dvb/frontend.h>
+#include <asm/types.h>
+
+#include "ts2022.h"
+
+static int debug;
+#define dprintk(args...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG "ts2022: " args); \
+	} while (0)
+
+#define TS2022_XTAL_FREQ   27000 /* in kHz */
+
+struct ts2022_priv {
+	/* i2c details */
+	int i2c_address;
+	struct i2c_adapter *i2c;
+	u32 frequency;
+};
+
+static int ts2022_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static int ts2022_writereg(struct dvb_frontend *fe, int reg, int data)
+{
+	struct ts2022_priv *priv = fe->tuner_priv;
+	u8 buf[] = { reg, data };
+	struct i2c_msg msg[] = {
+		{
+			.addr = priv->i2c_address,
+			.flags = 0,
+			.buf = buf,
+			.len = 2
+		}
+	};
+	int err;
+
+	dprintk("%s: write reg 0x%02x, value 0x%02x\n", __func__, reg, data);
+	
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	err = i2c_transfer(priv->i2c, msg, 1);
+	if (err != 1) {
+		printk("%s: writereg error(err == %i, reg == 0x%02x,"
+		" value == 0x%02x)\n", __func__, err, reg, data);
+		return -EREMOTEIO;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return 0;
+}
+
+static int ts2022_readreg(struct dvb_frontend *fe, u8 reg)
+{
+	struct ts2022_priv *priv = fe->tuner_priv;
+	int ret;
+	u8 b0[] = { reg };
+	u8 b1[] = { 0 };
+	struct i2c_msg msg[] = {
+		{
+			.addr = priv->i2c_address,
+			.flags = 0,
+			.buf = b0,
+			.len = 1
+		}, {
+			.addr = priv->i2c_address,
+			.flags = I2C_M_RD,
+			.buf = b1,
+			.len = 1
+		}
+	};
+	
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	ret = i2c_transfer(priv->i2c, msg, 2);
+	
+	if (ret != 2) {
+		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, reg, ret);
+		return ret;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	dprintk("%s: read reg 0x%02x, value 0x%02x\n", __func__, reg, b1[0]);
+	
+	return b1[0];
+}
+
+static int ts2022_sleep(struct dvb_frontend *fe)
+{
+	struct ts2022_priv *priv = fe->tuner_priv;
+	int ret;
+	u8 buf[] = { 10, 0 };
+	struct i2c_msg msg = {
+		.addr = priv->i2c_address,
+		.flags = 0,
+		.buf = buf,
+		.len = 2
+	};
+
+	dprintk("%s:\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	ret = i2c_transfer(priv->i2c, &msg, 1);
+	if (ret != 1)
+		dprintk("%s: i2c error\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return (ret == 1) ? 0 : ret;
+}
+
+static int ts2022_set_params(struct dvb_frontend *fe)
+{
+	struct ts2022_priv *priv = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u8 mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf, div4;
+	u16 value, ndiv;
+	u32 f3db;
+
+	dprintk("%s:\n", __func__);
+
+	ts2022_writereg(fe, 0x10, 0x0b);
+	ts2022_writereg(fe, 0x11, 0x40);
+	div4 = 0;
+	if (c->frequency < 1103000) {
+		ts2022_writereg(fe, 0x10, 0x1b);
+		div4 = 1;
+		ndiv = (c->frequency * (6 + 8) * 4)/TS2022_XTAL_FREQ ;
+	} else
+		ndiv = (c->frequency * (6 + 8) * 2)/TS2022_XTAL_FREQ ;
+
+	ndiv = ndiv + ndiv %2 ;
+	if (ndiv < 4095)
+		value = ndiv - 1024;
+	else if (ndiv < 6143 )
+		value = ndiv + 1024;
+	else
+		value = ndiv + 3072;
+
+	ts2022_writereg(fe, 0x01, (value & 0x3f00) >> 8);
+	ts2022_writereg(fe, 0x02, value & 0x00ff);
+	ts2022_writereg(fe, 0x03, 0x06);
+	ts2022_writereg(fe, 0x51, 0x0f);
+	ts2022_writereg(fe, 0x51, 0x1f);
+	ts2022_writereg(fe, 0x50, 0x10);
+	ts2022_writereg(fe, 0x50, 0x00);
+	msleep(5);
+
+	value =  ts2022_readreg(fe, 0x14);
+	value &=0x7f;
+	if (value < 64 ) {
+		value =  ts2022_readreg(fe, 0x10);
+		value |= 0x80;
+		ts2022_writereg(fe, 0x10, value);
+		ts2022_writereg(fe, 0x11, 0x6f);
+
+		ts2022_writereg(fe, 0x51, 0x0f);
+		ts2022_writereg(fe, 0x51, 0x1f);
+		ts2022_writereg(fe, 0x50, 0x10);
+		ts2022_writereg(fe, 0x50, 0x00);
+	}
+	msleep(5);
+	value =  ts2022_readreg(fe, 0x14);
+	value &=0x1f;
+	if (value > 19) {
+		value =  ts2022_readreg(fe, 0x10);
+		value &= 0xfd;
+		ts2022_writereg(fe, 0x10, value);
+	}
+	ts2022_writereg(fe, 0x51, 0x17);
+	ts2022_writereg(fe, 0x51, 0x1f);
+	ts2022_writereg(fe, 0x50, 0x08);
+	ts2022_writereg(fe, 0x50, 0x00);
+	msleep(5);
+
+	ts2022_writereg(fe, 0x25, 0x00);
+	ts2022_writereg(fe, 0x27, 0x70);
+	ts2022_writereg(fe, 0x41, 0x09);
+
+	ts2022_writereg(fe, 0x08, 0x0b);
+	ts2022_writereg(fe, 0x04, 0x2e);
+	ts2022_writereg(fe, 0x51, 0x1b);
+	ts2022_writereg(fe, 0x51, 0x1f);
+	ts2022_writereg(fe, 0x50, 0x04);
+	ts2022_writereg(fe, 0x50, 0x00);
+	msleep(5);
+
+	f3db = ((c->symbol_rate / 1000) * 135) / 200 + 2000;
+	if ((c->symbol_rate / 1000) < 5000)
+		f3db += 3000;
+	if (f3db < 7000)
+		f3db = 7000;
+	if (f3db > 40000)
+		f3db = 40000;
+
+	value = ts2022_readreg(fe, 0x26);
+	value &= 0x3f ;
+
+	ts2022_writereg(fe, 0x41, 0x0d);
+
+	ts2022_writereg(fe, 0x51, 0x1b);
+	ts2022_writereg(fe, 0x51, 0x1f);
+	ts2022_writereg(fe, 0x50, 0x04);
+	ts2022_writereg(fe, 0x50, 0x00);
+	msleep(5);
+	value = (value + (ts2022_readreg(fe, 0x26) & 0x3f)) / 2;
+	mlpf = 0x2e * 207 / ((value << 1) + 151);
+	mlpf_max = mlpf * 135 / 100;
+	mlpf_min = mlpf * 78 / 100;
+	if (mlpf_max > 63)
+		mlpf_max = 63;
+
+
+		value = 3200;
+	nlpf = ((mlpf * f3db * 1000) + (value * TS2022_XTAL_FREQ / 2))
+			/ (value * TS2022_XTAL_FREQ);
+
+	if (nlpf > 23)
+		nlpf = 23;
+	if (nlpf < 1)
+		nlpf = 1;
+
+	/* rounded to the closest integer */
+	mlpf_new = ((TS2022_XTAL_FREQ * nlpf * value) +
+			(1000 * f3db / 2)) / (1000 * f3db);
+
+	if (mlpf_new < mlpf_min) {
+		nlpf++;
+		mlpf_new = ((TS2022_XTAL_FREQ * nlpf * value) +
+				(1000 * f3db / 2)) / (1000 * f3db);
+	}
+
+	if (mlpf_new > mlpf_max)
+		mlpf_new = mlpf_max;
+
+	ts2022_writereg(fe, 0x04, mlpf_new);
+	ts2022_writereg(fe, 0x06, nlpf);
+	ts2022_writereg(fe, 0x51, 0x1b);
+	ts2022_writereg(fe, 0x51, 0x1f);
+	ts2022_writereg(fe, 0x50, 0x04);
+	ts2022_writereg(fe, 0x50, 0x00);
+	msleep(5);
+
+	value = ts2022_readreg(fe, 0x26);
+	value &= 0x3f;
+	ts2022_writereg(fe, 0x41, 0x09);
+
+	ts2022_writereg(fe, 0x51, 0x1b);
+	ts2022_writereg(fe, 0x51, 0x1f);
+	ts2022_writereg(fe, 0x50, 0x04);
+	ts2022_writereg(fe, 0x50, 0x00);
+	msleep(5);
+	value = (value + (ts2022_readreg(fe, 0x26)&0x3f))/2;
+
+	value |= 0x80;
+	ts2022_writereg(fe, 0x25, value);
+	ts2022_writereg(fe, 0x27, 0x30);
+	ts2022_writereg(fe, 0x08, 0x09);
+	ts2022_writereg(fe, 0x51, 0x1e);
+	ts2022_writereg(fe, 0x51, 0x1f);
+	ts2022_writereg(fe, 0x50, 0x01);
+	ts2022_writereg(fe, 0x50, 0x00);
+
+	msleep(60);
+
+	priv->frequency = (u32)(ndiv * TS2022_XTAL_FREQ / (6 + 8) / (div4 + 1) / 2);
+
+	printk("%s: offset %dkhz\n", __func__, priv->frequency - c->frequency);
+	printk("%s:  %dkhz  %dkhz\n", __func__, c->frequency, priv->frequency);
+
+	return 0;
+}
+
+static int ts2022_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct ts2022_priv *priv = fe->tuner_priv;
+	*frequency = priv->frequency;
+	return 0;
+}
+
+static int ts2022_init(struct dvb_frontend *fe)
+{
+	ts2022_writereg(fe, 0x62, 0xec);
+	ts2022_writereg(fe, 0x42, 0x6c);
+	
+	ts2022_writereg(fe, 0x7d, 0x9d);
+	ts2022_writereg(fe, 0x7c, 0x9a);
+	ts2022_writereg(fe, 0x7a, 0x76);
+	
+	ts2022_writereg(fe, 0x3b, 0x01);
+	ts2022_writereg(fe, 0x63, 0x88);
+	
+	ts2022_writereg(fe, 0x61, 0x85);
+	ts2022_writereg(fe, 0x22, 0x30);
+	ts2022_writereg(fe, 0x30, 0x40);
+	ts2022_writereg(fe, 0x20, 0x23);
+	ts2022_writereg(fe, 0x24, 0x02);
+	ts2022_writereg(fe, 0x12, 0xa0);
+
+	return 0;
+}
+
+static int ts2022_read_signal_strength(struct dvb_frontend *fe,
+				       u16 *signal_strength)
+{
+	int sig_reading = 0; 
+	u8 rfgain, bbgain, nngain;
+	u8 rfagc;
+	u32 gain = 0;
+	dprintk("%s()\n", __func__);
+	
+	rfgain = ts2022_readreg(fe, 0x3d) & 0x1f;
+	bbgain = ts2022_readreg(fe, 0x21) & 0x1f;
+	rfagc = ts2022_readreg(fe, 0x3f);
+	sig_reading = rfagc * 16 -670;
+	if (sig_reading<0)
+		sig_reading =0;
+	nngain =ts2022_readreg(fe, 0x66);
+	nngain = (nngain >> 3) & 0x07;
+	
+	if (rfgain < 0)
+		rfgain = 0;
+	if (rfgain > 15)
+		rfgain = 15;
+	if (bbgain < 2)
+		bbgain = 2;
+	if (bbgain > 16)
+		bbgain = 16;
+	if (nngain < 0)
+		nngain = 0;
+	if (nngain > 6)
+		nngain = 6;
+	
+	if (sig_reading < 600)
+		sig_reading = 600;
+	if (sig_reading > 1600)
+		sig_reading = 1600;
+	
+	gain = (u16) rfgain * 265 + (u16) bbgain * 338 + (u16) nngain * 285 + sig_reading * 176 / 100 - 3000;
+	
+	
+	*signal_strength = gain*100;
+	
+	dprintk("%s: raw / cooked = 0x%04x / 0x%04x\n", __func__,
+		sig_reading, *signal_strength);
+	
+	return 0;
+}
+
+static struct dvb_tuner_ops ts2022_tuner_ops = {
+	.info = {
+		.name = "TS2022",
+		.frequency_min = 950000,
+		.frequency_max = 2150000
+	},
+	.init = ts2022_init,
+	.release = ts2022_release,
+	.sleep = ts2022_sleep,
+	.set_params = ts2022_set_params,
+	.get_frequency = ts2022_get_frequency,
+	.get_rf_strength = ts2022_read_signal_strength,
+};
+
+struct dvb_frontend *ts2022_attach(struct dvb_frontend *fe, int addr,
+						struct i2c_adapter *i2c)
+{
+	struct ts2022_priv *priv = NULL;
+	u8 buf;
+
+	dprintk("%s:\n", __func__);
+
+	priv = kzalloc(sizeof(struct ts2022_priv), GFP_KERNEL);
+	if (priv == NULL)
+		return NULL;
+
+	priv->i2c_address = addr;
+	priv->i2c = i2c;
+	fe->tuner_priv = priv;
+
+	/* Wake Up the tuner */
+	buf = ts2022_readreg(fe, 0x00);
+	buf &= 0x03;
+	
+	if (buf == 0x00) {
+		ts2022_writereg(fe, 0x00, 0x01);
+		msleep(2);
+	}
+
+	ts2022_writereg(fe, 0x00, 0x03);
+	msleep(2);
+	
+	/* Check the tuner version */
+	buf = ts2022_readreg(fe, 0x00);
+	if ((buf == 0xc3)|| (buf == 0x83))
+		dprintk(KERN_INFO "%s: Find tuner TS2022!\n", __func__);
+	else {
+		dprintk(KERN_ERR "%s: Read tuner reg[0] = %d\n", __func__, buf);
+		kfree(priv);
+		return NULL;
+	}
+
+	memcpy(&fe->ops.tuner_ops, &ts2022_tuner_ops,
+				sizeof(struct dvb_tuner_ops));
+	fe->ops.read_signal_strength = fe->ops.tuner_ops.get_rf_strength;
+
+	return fe;
+}
+EXPORT_SYMBOL(ts2022_attach);
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
+
+MODULE_DESCRIPTION("DVB ts2022 driver");
+MODULE_AUTHOR("Tomazzo Muzumici");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/ts2022.h b/drivers/media/dvb-frontends/ts2022.h
new file mode 100644
index 0000000..c894edb
--- /dev/null
+++ b/drivers/media/dvb-frontends/ts2022.h
@@ -0,0 +1,51 @@
+  /*
+     Driver for Montage TS2022 DVBS/S2 Silicon tuner
+
+     Copyright (C) 2012 Tomazzo Muzumici
+
+     This program is free software; you can redistribute it and/or modify
+     it under the terms of the GNU General Public License as published by
+     the Free Software Foundation; either version 2 of the License, or
+     (at your option) any later version.
+
+     This program is distributed in the hope that it will be useful,
+     but WITHOUT ANY WARRANTY; without even the implied warranty of
+     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+
+     GNU General Public License for more details.
+
+     You should have received a copy of the GNU General Public License
+     along with this program; if not, write to the Free Software
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+  */
+
+#ifndef __DVB_TS2022_H__
+#define __DVB_TS2022_H__
+
+#include <linux/i2c.h>
+#include "dvb_frontend.h"
+
+/**
+ * Attach a ts2022 tuner to the supplied frontend structure.
+ *
+ * @param fe Frontend to attach to.
+ * @param addr i2c address of the tuner.
+ * @param i2c i2c adapter to use.
+ * @return FE pointer on success, NULL on failure.
+ */
+#if defined(CONFIG_DVB_TS2022) || (defined(CONFIG_DVB_TS2022_MODULE) \
+							&& defined(MODULE))
+extern struct dvb_frontend *ts2022_attach(struct dvb_frontend *fe, int addr,
+					   struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *ts2022_attach(struct dvb_frontend *fe,
+						  int addr,
+						  struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_TS2022 */
+
+#endif /* __DVB_TS2022_H__ */
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6e237b6..bff0979 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -23,6 +23,8 @@
 #include "mt312.h"
 #include "zl10039.h"
 #include "ts2020.h"
+#include "ts2022.h"
+#include "ds3103.h"
 #include "ds3000.h"
 #include "stv0900.h"
 #include "stv6110.h"
@@ -1018,6 +1020,12 @@ static struct ds3000_config su3000_ds3000_config = {
 	.set_lock_led = dw210x_led_ctrl,
 };
 
+static struct ds3103_config su3000_ds3103_config = {
+	.demod_address = 0x68,
+	.ci_mode = 0,
+	.set_lock_led = dw210x_led_ctrl,
+};
+
 static u8 m88rs2000_inittab[] = {
 	DEMOD_WRITE, 0x9a, 0x30,
 	DEMOD_WRITE, 0x00, 0x01,
@@ -1273,17 +1281,25 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
 
 	d->fe_adap[0].fe = dvb_attach(ds3000_attach, &su3000_ds3000_config,
 					&d->dev->i2c_adap);
-	if (d->fe_adap[0].fe == NULL)
-		return -EIO;
+	if (d->fe_adap[0].fe != NULL) {
+		if (dvb_attach(ts2020_attach, d->fe_adap[0].fe,
+					&dw2104_ts2020_config,
+					&d->dev->i2c_adap)) {
+			info("Attached DS3000/TS2020!\n");
+			return 0;
+		}
+	}
 
-	if (dvb_attach(ts2020_attach, d->fe_adap[0].fe,
-				&dw2104_ts2020_config,
+	d->fe_adap[0].fe = dvb_attach(ds3103_attach, &su3000_ds3103_config, &d->dev->i2c_adap);
+	if (d->fe_adap[0].fe != NULL) {
+		if (dvb_attach(ts2022_attach, d->fe_adap[0].fe, 0x60,
 				&d->dev->i2c_adap)) {
-		info("Attached DS3000/TS2020!\n");
-		return 0;
+			info("Attached DS3103/TS2022!\n");
+			return 0;
+		}
 	}
 
-	info("Failed to attach DS3000/TS2020!\n");
+	info("Failed to attach DS3000/TS2020 or DS3103/TS2022!\n");
 	return -EIO;
 }
 
@@ -1484,11 +1500,54 @@ static struct rc_map_table rc_map_su3000_table[] = {
 	{ 0x0c, KEY_ESC }	/* upper Red button */
 };
 
+static struct rc_map_table rc_map_tt_4600_table[] = {
+	{ 0x41, KEY_POWER },
+	{ 0x42, KEY_SHUFFLE },
+	{ 0x43, KEY_1 },
+	{ 0x44, KEY_2 },
+	{ 0x45, KEY_3 },
+	{ 0x46, KEY_4 },
+	{ 0x47, KEY_5 },
+	{ 0x48, KEY_6 },
+	{ 0x49, KEY_7 },
+	{ 0x4a, KEY_8 },
+	{ 0x4b, KEY_9 },
+	{ 0x4c, KEY_0 },
+	{ 0x4d, KEY_UP },
+	{ 0x4e, KEY_LEFT },
+	{ 0x4f, KEY_OK },
+	{ 0x50, KEY_RIGHT },
+	{ 0x51, KEY_DOWN },
+	{ 0x52, KEY_INFO },
+	{ 0x53, KEY_EXIT },
+	{ 0x54, KEY_RED },
+	{ 0x55, KEY_GREEN },
+	{ 0x56, KEY_YELLOW },
+	{ 0x57, KEY_BLUE },
+	{ 0x58, KEY_MUTE },
+	{ 0x59, KEY_TEXT },
+	{ 0x5a, KEY_MODE },
+	{ 0x61, KEY_OPTION },
+	{ 0x62, KEY_EPG },
+	{ 0x63, KEY_CHANNELUP },
+	{ 0x64, KEY_CHANNELDOWN },
+	{ 0x65, KEY_VOLUMEUP },
+	{ 0x66, KEY_VOLUMEDOWN },
+	{ 0x67, KEY_SETUP },
+	{ 0x7a, KEY_RECORD },
+	{ 0x7b, KEY_PLAY },
+	{ 0x7c, KEY_STOP },
+	{ 0x7d, KEY_REWIND },
+	{ 0x7e, KEY_PAUSE },
+	{ 0x7f, KEY_FORWARD },
+};
+
 static struct rc_map_dvb_usb_table_table keys_tables[] = {
 	{ rc_map_dw210x_table, ARRAY_SIZE(rc_map_dw210x_table) },
 	{ rc_map_tevii_table, ARRAY_SIZE(rc_map_tevii_table) },
 	{ rc_map_tbs_table, ARRAY_SIZE(rc_map_tbs_table) },
 	{ rc_map_su3000_table, ARRAY_SIZE(rc_map_su3000_table) },
+	{ rc_map_tt_4600_table, ARRAY_SIZE(rc_map_tt_4600_table) },
 };
 
 static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
@@ -1551,6 +1610,7 @@ enum dw2102_table_entry {
 	X3M_SPC1400HD,
 	TEVII_S421,
 	TEVII_S632,
+	TT_S2_4600,
 	TERRATEC_CINERGY_S2_R2,
 	GOTVIEW_SAT_HD,
 };
@@ -1573,6 +1633,7 @@ static struct usb_device_id dw2102_table[] = {
 	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
 	[TEVII_S421] = {USB_DEVICE(0x9022, USB_PID_TEVII_S421)},
 	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
+	[TT_S2_4600] = {USB_DEVICE(0x0b48, 0x3011)},
 	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00b0)},
 	[GOTVIEW_SAT_HD] = {USB_DEVICE(0x1FE1, USB_PID_GOTVIEW_SAT_HD)},
 	{ }
@@ -1936,6 +1997,13 @@ static struct dvb_usb_device_description d632 = {
 	{NULL},
 };
 
+struct dvb_usb_device_properties *s472;
+static struct dvb_usb_device_description d472 = {
+	"TT Connect S2 4600",
+	{&dw2102_table[TT_S2_4600], NULL},
+	{NULL},
+};
+
 static struct dvb_usb_device_properties su3000_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
@@ -2055,6 +2123,21 @@ static int dw2102_probe(struct usb_interface *intf,
 	s421->devices[1] = d632;
 	s421->adapter->fe[0].frontend_attach = m88rs2000_frontend_attach;
 
+	s472 = kmemdup(&su3000_properties,
+		       sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
+	if (!s472) {
+		kfree(s421);
+		kfree(p1100);
+		kfree(s660);
+		kfree(p7500);
+		return -ENOMEM;
+	}
+	s472->num_device_descs = 1;
+	s472->devices[0] = d472;
+	s472->rc.legacy.rc_map_table = rc_map_tt_4600_table;
+	s472->rc.legacy.rc_map_size = ARRAY_SIZE(rc_map_tt_4600_table);
+	s472->rc.legacy.rc_interval = 250;
+
 	if (0 == dvb_usb_device_init(intf, &dw2102_properties,
 			THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &dw2104_properties,
@@ -2071,6 +2154,8 @@ static int dw2102_probe(struct usb_interface *intf,
 			THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, s421,
 			THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, s472,
+			THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &su3000_properties,
 				     THIS_MODULE, NULL, adapter_nr))
 		return 0;

--------------080404080901020300010309--
