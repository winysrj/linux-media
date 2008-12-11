Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBBKe5Zi014389
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:40:06 -0500
Received: from comal.ext.ti.com (comal.ext.ti.com [198.47.26.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBBKcRPp020830
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:38:27 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Thu, 11 Dec 2008 14:38:15 -0600
Message-ID: <A24693684029E5489D1D202277BE894415E6E19F@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: [REVIEW PATCH 09/14] OMAP: CAM: Add ISP gain tables
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

>From eb1dba075c262d2aa1e066e0030525c2056a81bf Mon Sep 17 00:00:00 2001
From: Sergio Aguirre <saaguirre@ti.com>
Date: Thu, 11 Dec 2008 13:35:48 -0600
Subject: [PATCH] OMAP: CAM: Add ISP gain tables

This adds the OMAP ISP gain tables. Includes:
* Blue Gamma gain table
* CFA gain table
* Green Gamma gain table
* Luma Enhancement gain table
* Noise filter gain table
* Red Gamma gain table

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/bluegamma_table.h    | 1040 ++++++++++++++++++++++++++
 drivers/media/video/isp/cfa_coef_table.h     |  592 +++++++++++++++
 drivers/media/video/isp/greengamma_table.h   | 1040 ++++++++++++++++++++++++++
 drivers/media/video/isp/luma_enhance_table.h |  144 ++++
 drivers/media/video/isp/noise_filter_table.h |   79 ++
 drivers/media/video/isp/redgamma_table.h     | 1040 ++++++++++++++++++++++++++
 6 files changed, 3935 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/isp/bluegamma_table.h
 create mode 100644 drivers/media/video/isp/cfa_coef_table.h
 create mode 100644 drivers/media/video/isp/greengamma_table.h
 create mode 100644 drivers/media/video/isp/luma_enhance_table.h
 create mode 100644 drivers/media/video/isp/noise_filter_table.h
 create mode 100644 drivers/media/video/isp/redgamma_table.h

diff --git a/drivers/media/video/isp/bluegamma_table.h b/drivers/media/video/isp/bluegamma_table.h
new file mode 100644
index 0000000..9ec8376
--- /dev/null
+++ b/drivers/media/video/isp/bluegamma_table.h
@@ -0,0 +1,1040 @@
+/*
+ * drivers/media/video/isp/bluegamma_table.h
+ *
+ * Gamma Table values for BLUE for TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+0,
+0,
+1,
+2,
+3,
+3,
+4,
+5,
+6,
+8,
+10,
+12,
+14,
+16,
+18,
+20,
+22,
+23,
+25,
+26,
+28,
+29,
+31,
+32,
+34,
+35,
+36,
+37,
+39,
+40,
+41,
+42,
+43,
+44,
+45,
+46,
+47,
+48,
+49,
+50,
+51,
+52,
+52,
+53,
+54,
+55,
+56,
+57,
+58,
+59,
+60,
+61,
+62,
+63,
+63,
+64,
+65,
+66,
+66,
+67,
+68,
+69,
+69,
+70,
+71,
+72,
+72,
+73,
+74,
+75,
+75,
+76,
+77,
+78,
+78,
+79,
+80,
+81,
+81,
+82,
+83,
+84,
+84,
+85,
+86,
+87,
+88,
+88,
+89,
+90,
+91,
+91,
+92,
+93,
+94,
+94,
+95,
+96,
+97,
+97,
+98,
+98,
+99,
+99,
+100,
+100,
+101,
+101,
+102,
+103,
+104,
+104,
+105,
+106,
+107,
+108,
+108,
+109,
+110,
+111,
+111,
+112,
+113,
+114,
+114,
+115,
+116,
+117,
+117,
+118,
+119,
+119,
+120,
+120,
+121,
+121,
+122,
+122,
+123,
+123,
+124,
+124,
+125,
+125,
+126,
+126,
+127,
+127,
+128,
+128,
+129,
+129,
+130,
+130,
+131,
+131,
+132,
+132,
+133,
+133,
+134,
+134,
+135,
+135,
+136,
+136,
+137,
+137,
+138,
+138,
+139,
+139,
+140,
+140,
+141,
+141,
+142,
+142,
+143,
+143,
+144,
+144,
+145,
+145,
+146,
+146,
+147,
+147,
+148,
+148,
+149,
+149,
+150,
+150,
+151,
+151,
+152,
+152,
+153,
+153,
+153,
+153,
+154,
+154,
+154,
+154,
+155,
+155,
+156,
+156,
+157,
+157,
+158,
+158,
+158,
+159,
+159,
+159,
+160,
+160,
+160,
+161,
+161,
+162,
+162,
+163,
+163,
+164,
+164,
+164,
+164,
+165,
+165,
+165,
+165,
+166,
+166,
+167,
+167,
+168,
+168,
+169,
+169,
+170,
+170,
+170,
+170,
+171,
+171,
+171,
+171,
+172,
+172,
+173,
+173,
+174,
+174,
+175,
+175,
+176,
+176,
+176,
+176,
+177,
+177,
+177,
+177,
+178,
+178,
+178,
+178,
+179,
+179,
+179,
+179,
+180,
+180,
+180,
+180,
+181,
+181,
+181,
+181,
+182,
+182,
+182,
+182,
+183,
+183,
+183,
+183,
+184,
+184,
+184,
+184,
+185,
+185,
+185,
+185,
+186,
+186,
+186,
+186,
+187,
+187,
+187,
+187,
+188,
+188,
+188,
+188,
+189,
+189,
+189,
+189,
+190,
+190,
+190,
+190,
+191,
+191,
+191,
+191,
+192,
+192,
+192,
+192,
+193,
+193,
+193,
+193,
+194,
+194,
+194,
+194,
+195,
+195,
+195,
+195,
+196,
+196,
+196,
+196,
+197,
+197,
+197,
+197,
+198,
+198,
+198,
+198,
+199,
+199,
+199,
+199,
+200,
+200,
+200,
+200,
+201,
+201,
+201,
+201,
+202,
+202,
+202,
+203,
+203,
+203,
+203,
+204,
+204,
+204,
+204,
+205,
+205,
+205,
+205,
+206,
+206,
+206,
+206,
+207,
+207,
+207,
+207,
+208,
+208,
+208,
+208,
+209,
+209,
+209,
+209,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+212,
+212,
+212,
+212,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+214,
+214,
+214,
+214,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+216,
+216,
+216,
+216,
+217,
+217,
+217,
+217,
+218,
+218,
+218,
+218,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+220,
+220,
+220,
+220,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+222,
+222,
+222,
+222,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+224,
+224,
+224,
+224,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+226,
+226,
+226,
+226,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+228,
+228,
+228,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+230,
+230,
+230,
+230,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+233,
+233,
+233,
+233,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+235,
+235,
+235,
+235,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+237,
+237,
+237,
+237,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+239,
+239,
+239,
+239,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+241,
+241,
+241,
+241,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+243,
+243,
+243,
+243,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+245,
+245,
+245,
+245,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+247,
+247,
+247,
+247,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+249,
+249,
+249,
+249,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+251,
+251,
+251,
+251,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+254,
+254,
+254,
+254,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255
diff --git a/drivers/media/video/isp/cfa_coef_table.h b/drivers/media/video/isp/cfa_coef_table.h
new file mode 100644
index 0000000..f661870
--- /dev/null
+++ b/drivers/media/video/isp/cfa_coef_table.h
@@ -0,0 +1,592 @@
+/*
+ * drivers/media/video/isp/cfa_coef_table.h
+ *
+ * CFA Coefficient Table values for TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+0,
+247,
+0,
+244,
+247,
+36,
+27,
+12,
+0,
+27,
+0,
+250,
+244,
+12,
+250,
+4,
+0,
+0,
+0,
+248,
+0,
+0,
+40,
+0,
+4,
+250,
+12,
+244,
+250,
+0,
+27,
+0,
+12,
+27,
+36,
+247,
+244,
+0,
+247,
+0,
+0,
+40,
+0,
+0,
+248,
+0,
+0,
+0,
+0,
+247,
+0,
+244,
+247,
+36,
+27,
+12,
+0,
+27,
+0,
+250,
+244,
+12,
+250,
+4,
+0,
+0,
+0,
+248,
+0,
+0,
+40,
+0,
+4,
+250,
+12,
+244,
+250,
+0,
+27,
+0,
+12,
+27,
+36,
+247,
+244,
+0,
+247,
+0,
+0,
+40,
+0,
+0,
+248,
+0,
+0,
+0,
+0,
+247,
+0,
+244,
+247,
+36,
+27,
+12,
+0,
+27,
+0,
+250,
+244,
+12,
+250,
+4,
+0,
+0,
+0,
+248,
+0,
+0,
+40,
+0,
+4,
+250,
+12,
+244,
+250,
+0,
+27,
+0,
+12,
+27,
+36,
+247,
+244,
+0,
+247,
+0,
+0,
+40,
+0,
+0,
+248,
+0,
+0,
+0,
+244,
+0,
+247,
+0,
+12,
+27,
+36,
+247,
+250,
+0,
+27,
+0,
+4,
+250,
+12,
+244,
+248,
+0,
+0,
+0,
+0,
+40,
+0,
+0,
+244,
+12,
+250,
+4,
+0,
+27,
+0,
+250,
+247,
+36,
+27,
+12,
+0,
+247,
+0,
+244,
+0,
+0,
+40,
+0,
+0,
+0,
+0,
+248,
+244,
+0,
+247,
+0,
+12,
+27,
+36,
+247,
+250,
+0,
+27,
+0,
+4,
+250,
+12,
+244,
+248,
+0,
+0,
+0,
+0,
+40,
+0,
+0,
+244,
+12,
+250,
+4,
+0,
+27,
+0,
+250,
+247,
+36,
+27,
+12,
+0,
+247,
+0,
+244,
+0,
+0,
+40,
+0,
+0,
+0,
+0,
+248,
+244,
+0,
+247,
+0,
+12,
+27,
+36,
+247,
+250,
+0,
+27,
+0,
+4,
+250,
+12,
+244,
+248,
+0,
+0,
+0,
+0,
+40,
+0,
+0,
+244,
+12,
+250,
+4,
+0,
+27,
+0,
+250,
+247,
+36,
+27,
+12,
+0,
+247,
+0,
+244,
+0,
+0,
+40,
+0,
+0,
+0,
+0,
+248,
+244,
+12,
+250,
+4,
+0,
+27,
+0,
+250,
+247,
+36,
+27,
+12,
+0,
+247,
+0,
+244,
+248,
+0,
+0,
+0,
+0,
+40,
+0,
+0,
+244,
+0,
+247,
+0,
+12,
+27,
+36,
+247,
+250,
+0,
+27,
+0,
+4,
+250,
+12,
+244,
+0,
+0,
+40,
+0,
+0,
+0,
+0,
+248,
+244,
+12,
+250,
+4,
+0,
+27,
+0,
+250,
+247,
+36,
+27,
+12,
+0,
+247,
+0,
+244,
+248,
+0,
+0,
+0,
+0,
+40,
+0,
+0,
+244,
+0,
+247,
+0,
+12,
+27,
+36,
+247,
+250,
+0,
+27,
+0,
+4,
+250,
+12,
+244,
+0,
+0,
+40,
+0,
+0,
+0,
+0,
+248,
+244,
+12,
+250,
+4,
+0,
+27,
+0,
+250,
+247,
+36,
+27,
+12,
+0,
+247,
+0,
+244,
+248,
+0,
+0,
+0,
+0,
+40,
+0,
+0,
+244,
+0,
+247,
+0,
+12,
+27,
+36,
+247,
+250,
+0,
+27,
+0,
+4,
+250,
+12,
+244,
+0,
+0,
+40,
+0,
+0,
+0,
+0,
+248,
+4,
+250,
+12,
+244,
+250,
+0,
+27,
+0,
+12,
+27,
+36,
+247,
+244,
+0,
+247,
+0,
+0,
+0,
+0,
+248,
+0,
+0,
+40,
+0,
+0,
+247,
+0,
+244,
+247,
+36,
+27,
+12,
+0,
+27,
+0,
+250,
+244,
+12,
+250,
+4,
+0,
+40,
+0,
+0,
+248,
+0,
+0,
+0,
+4,
+250,
+12,
+244,
+250,
+0,
+27,
+0,
+12,
+27,
+36,
+247,
+244,
+0,
+247,
+0,
+0,
+0,
+0,
+248,
+0,
+0,
+40,
+0,
+0,
+247,
+0,
+244,
+247,
+36,
+27,
+12,
+0,
+27,
+0,
+250,
+244,
+12,
+250,
+4,
+0,
+40,
+0,
+0,
+248,
+0,
+0,
+0,
+4,
+250,
+12,
+244,
+250,
+0,
+27,
+0,
+12,
+27,
+36,
+247,
+244,
+0,
+247,
+0,
+0,
+0,
+0,
+248,
+0,
+0,
+40,
+0,
+0,
+247,
+0,
+244,
+247,
+36,
+27,
+12,
+0,
+27,
+0,
+250,
+244,
+12,
+250,
+4,
+0,
+40,
+0,
+0,
+248,
+0,
+0,
+0
diff --git a/drivers/media/video/isp/greengamma_table.h b/drivers/media/video/isp/greengamma_table.h
new file mode 100644
index 0000000..94eeb8b
--- /dev/null
+++ b/drivers/media/video/isp/greengamma_table.h
@@ -0,0 +1,1040 @@
+/*
+ * drivers/media/video/isp/greengamma_table.h
+ *
+ * Gamma Table values for GREEN for TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+0,
+0,
+1,
+2,
+3,
+3,
+4,
+5,
+6,
+8,
+10,
+12,
+14,
+16,
+18,
+20,
+22,
+23,
+25,
+26,
+28,
+29,
+31,
+32,
+34,
+35,
+36,
+37,
+39,
+40,
+41,
+42,
+43,
+44,
+45,
+46,
+47,
+48,
+49,
+50,
+51,
+52,
+52,
+53,
+54,
+55,
+56,
+57,
+58,
+59,
+60,
+61,
+62,
+63,
+63,
+64,
+65,
+66,
+66,
+67,
+68,
+69,
+69,
+70,
+71,
+72,
+72,
+73,
+74,
+75,
+75,
+76,
+77,
+78,
+78,
+79,
+80,
+81,
+81,
+82,
+83,
+84,
+84,
+85,
+86,
+87,
+88,
+88,
+89,
+90,
+91,
+91,
+92,
+93,
+94,
+94,
+95,
+96,
+97,
+97,
+98,
+98,
+99,
+99,
+100,
+100,
+101,
+101,
+102,
+103,
+104,
+104,
+105,
+106,
+107,
+108,
+108,
+109,
+110,
+111,
+111,
+112,
+113,
+114,
+114,
+115,
+116,
+117,
+117,
+118,
+119,
+119,
+120,
+120,
+121,
+121,
+122,
+122,
+123,
+123,
+124,
+124,
+125,
+125,
+126,
+126,
+127,
+127,
+128,
+128,
+129,
+129,
+130,
+130,
+131,
+131,
+132,
+132,
+133,
+133,
+134,
+134,
+135,
+135,
+136,
+136,
+137,
+137,
+138,
+138,
+139,
+139,
+140,
+140,
+141,
+141,
+142,
+142,
+143,
+143,
+144,
+144,
+145,
+145,
+146,
+146,
+147,
+147,
+148,
+148,
+149,
+149,
+150,
+150,
+151,
+151,
+152,
+152,
+153,
+153,
+153,
+153,
+154,
+154,
+154,
+154,
+155,
+155,
+156,
+156,
+157,
+157,
+158,
+158,
+158,
+159,
+159,
+159,
+160,
+160,
+160,
+161,
+161,
+162,
+162,
+163,
+163,
+164,
+164,
+164,
+164,
+165,
+165,
+165,
+165,
+166,
+166,
+167,
+167,
+168,
+168,
+169,
+169,
+170,
+170,
+170,
+170,
+171,
+171,
+171,
+171,
+172,
+172,
+173,
+173,
+174,
+174,
+175,
+175,
+176,
+176,
+176,
+176,
+177,
+177,
+177,
+177,
+178,
+178,
+178,
+178,
+179,
+179,
+179,
+179,
+180,
+180,
+180,
+180,
+181,
+181,
+181,
+181,
+182,
+182,
+182,
+182,
+183,
+183,
+183,
+183,
+184,
+184,
+184,
+184,
+185,
+185,
+185,
+185,
+186,
+186,
+186,
+186,
+187,
+187,
+187,
+187,
+188,
+188,
+188,
+188,
+189,
+189,
+189,
+189,
+190,
+190,
+190,
+190,
+191,
+191,
+191,
+191,
+192,
+192,
+192,
+192,
+193,
+193,
+193,
+193,
+194,
+194,
+194,
+194,
+195,
+195,
+195,
+195,
+196,
+196,
+196,
+196,
+197,
+197,
+197,
+197,
+198,
+198,
+198,
+198,
+199,
+199,
+199,
+199,
+200,
+200,
+200,
+200,
+201,
+201,
+201,
+201,
+202,
+202,
+202,
+203,
+203,
+203,
+203,
+204,
+204,
+204,
+204,
+205,
+205,
+205,
+205,
+206,
+206,
+206,
+206,
+207,
+207,
+207,
+207,
+208,
+208,
+208,
+208,
+209,
+209,
+209,
+209,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+212,
+212,
+212,
+212,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+214,
+214,
+214,
+214,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+216,
+216,
+216,
+216,
+217,
+217,
+217,
+217,
+218,
+218,
+218,
+218,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+220,
+220,
+220,
+220,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+222,
+222,
+222,
+222,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+224,
+224,
+224,
+224,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+226,
+226,
+226,
+226,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+228,
+228,
+228,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+230,
+230,
+230,
+230,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+233,
+233,
+233,
+233,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+235,
+235,
+235,
+235,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+237,
+237,
+237,
+237,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+239,
+239,
+239,
+239,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+241,
+241,
+241,
+241,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+243,
+243,
+243,
+243,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+245,
+245,
+245,
+245,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+247,
+247,
+247,
+247,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+249,
+249,
+249,
+249,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+251,
+251,
+251,
+251,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+254,
+254,
+254,
+254,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255
diff --git a/drivers/media/video/isp/luma_enhance_table.h b/drivers/media/video/isp/luma_enhance_table.h
new file mode 100644
index 0000000..0249a50
--- /dev/null
+++ b/drivers/media/video/isp/luma_enhance_table.h
@@ -0,0 +1,144 @@
+/*
+ * drivers/media/video/isp/luma_enhance_table.h
+ *
+ * Luminance Enhancement table values for TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1047552,
+1048575,
+1047551,
+1046527,
+1045503,
+1044479,
+1043455,
+1042431,
+1041407,
+1040383,
+1039359,
+1038335,
+1037311,
+1036287,
+1035263,
+1034239,
+1033215,
+1032191,
+1031167,
+1030143,
+1028096,
+1028096,
+1028096,
+1028096,
+1028096,
+1028096,
+1028096,
+1028096,
+1028096,
+1028096,
+1028100,
+1032196,
+1036292,
+1040388,
+1044484,
+0,
+0,
+0,
+5,
+5125,
+10245,
+15365,
+20485,
+25605,
+30720,
+30720,
+30720,
+30720,
+30720,
+30720,
+30720,
+30720,
+30720,
+30720,
+30720,
+31743,
+30719,
+29695,
+28671,
+27647,
+26623,
+25599,
+24575,
+23551,
+22527,
+21503,
+20479,
+19455,
+18431,
+17407,
+16383,
+15359,
+14335,
+13311,
+12287,
+11263,
+10239,
+9215,
+8191,
+7167,
+6143,
+5119,
+4095,
+3071,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024,
+1024
diff --git a/drivers/media/video/isp/noise_filter_table.h b/drivers/media/video/isp/noise_filter_table.h
new file mode 100644
index 0000000..1c02044
--- /dev/null
+++ b/drivers/media/video/isp/noise_filter_table.h
@@ -0,0 +1,79 @@
+/*
+ * drivers/media/video/isp/noise_filter_table.
+ *
+ * Noise Filter Table values for TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+16,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31,
+31
diff --git a/drivers/media/video/isp/redgamma_table.h b/drivers/media/video/isp/redgamma_table.h
new file mode 100644
index 0000000..d754368
--- /dev/null
+++ b/drivers/media/video/isp/redgamma_table.h
@@ -0,0 +1,1040 @@
+/*
+ * drivers/media/video/isp/redgamma_table.h
+ *
+ * Gamma Table values for Red for TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+0,
+0,
+1,
+2,
+3,
+3,
+4,
+5,
+6,
+8,
+10,
+12,
+14,
+16,
+18,
+20,
+22,
+23,
+25,
+26,
+28,
+29,
+31,
+32,
+34,
+35,
+36,
+37,
+39,
+40,
+41,
+42,
+43,
+44,
+45,
+46,
+47,
+48,
+49,
+50,
+51,
+52,
+52,
+53,
+54,
+55,
+56,
+57,
+58,
+59,
+60,
+61,
+62,
+63,
+63,
+64,
+65,
+66,
+66,
+67,
+68,
+69,
+69,
+70,
+71,
+72,
+72,
+73,
+74,
+75,
+75,
+76,
+77,
+78,
+78,
+79,
+80,
+81,
+81,
+82,
+83,
+84,
+84,
+85,
+86,
+87,
+88,
+88,
+89,
+90,
+91,
+91,
+92,
+93,
+94,
+94,
+95,
+96,
+97,
+97,
+98,
+98,
+99,
+99,
+100,
+100,
+101,
+101,
+102,
+103,
+104,
+104,
+105,
+106,
+107,
+108,
+108,
+109,
+110,
+111,
+111,
+112,
+113,
+114,
+114,
+115,
+116,
+117,
+117,
+118,
+119,
+119,
+120,
+120,
+121,
+121,
+122,
+122,
+123,
+123,
+124,
+124,
+125,
+125,
+126,
+126,
+127,
+127,
+128,
+128,
+129,
+129,
+130,
+130,
+131,
+131,
+132,
+132,
+133,
+133,
+134,
+134,
+135,
+135,
+136,
+136,
+137,
+137,
+138,
+138,
+139,
+139,
+140,
+140,
+141,
+141,
+142,
+142,
+143,
+143,
+144,
+144,
+145,
+145,
+146,
+146,
+147,
+147,
+148,
+148,
+149,
+149,
+150,
+150,
+151,
+151,
+152,
+152,
+153,
+153,
+153,
+153,
+154,
+154,
+154,
+154,
+155,
+155,
+156,
+156,
+157,
+157,
+158,
+158,
+158,
+159,
+159,
+159,
+160,
+160,
+160,
+161,
+161,
+162,
+162,
+163,
+163,
+164,
+164,
+164,
+164,
+165,
+165,
+165,
+165,
+166,
+166,
+167,
+167,
+168,
+168,
+169,
+169,
+170,
+170,
+170,
+170,
+171,
+171,
+171,
+171,
+172,
+172,
+173,
+173,
+174,
+174,
+175,
+175,
+176,
+176,
+176,
+176,
+177,
+177,
+177,
+177,
+178,
+178,
+178,
+178,
+179,
+179,
+179,
+179,
+180,
+180,
+180,
+180,
+181,
+181,
+181,
+181,
+182,
+182,
+182,
+182,
+183,
+183,
+183,
+183,
+184,
+184,
+184,
+184,
+185,
+185,
+185,
+185,
+186,
+186,
+186,
+186,
+187,
+187,
+187,
+187,
+188,
+188,
+188,
+188,
+189,
+189,
+189,
+189,
+190,
+190,
+190,
+190,
+191,
+191,
+191,
+191,
+192,
+192,
+192,
+192,
+193,
+193,
+193,
+193,
+194,
+194,
+194,
+194,
+195,
+195,
+195,
+195,
+196,
+196,
+196,
+196,
+197,
+197,
+197,
+197,
+198,
+198,
+198,
+198,
+199,
+199,
+199,
+199,
+200,
+200,
+200,
+200,
+201,
+201,
+201,
+201,
+202,
+202,
+202,
+203,
+203,
+203,
+203,
+204,
+204,
+204,
+204,
+205,
+205,
+205,
+205,
+206,
+206,
+206,
+206,
+207,
+207,
+207,
+207,
+208,
+208,
+208,
+208,
+209,
+209,
+209,
+209,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+210,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+211,
+212,
+212,
+212,
+212,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+213,
+214,
+214,
+214,
+214,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+215,
+216,
+216,
+216,
+216,
+217,
+217,
+217,
+217,
+218,
+218,
+218,
+218,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+219,
+220,
+220,
+220,
+220,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+221,
+222,
+222,
+222,
+222,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+223,
+224,
+224,
+224,
+224,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+225,
+226,
+226,
+226,
+226,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+227,
+228,
+228,
+228,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+229,
+230,
+230,
+230,
+230,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+231,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+232,
+233,
+233,
+233,
+233,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+234,
+235,
+235,
+235,
+235,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+236,
+237,
+237,
+237,
+237,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+238,
+239,
+239,
+239,
+239,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+240,
+241,
+241,
+241,
+241,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+242,
+243,
+243,
+243,
+243,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+244,
+245,
+245,
+245,
+245,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+246,
+247,
+247,
+247,
+247,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+248,
+249,
+249,
+249,
+249,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+250,
+251,
+251,
+251,
+251,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+252,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+253,
+254,
+254,
+254,
+254,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255,
+255
--
1.5.6.5


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
