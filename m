Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:36922 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846Ab1FCO0h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 10:26:37 -0400
Received: from [94.248.227.103]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSUqT-0003LM-Qa
	for linux-media@vger.kernel.org; Fri, 03 Jun 2011 15:55:31 +0200
Message-ID: <4DE8E7CC.1060200@mailbox.hu>
Date: Fri, 03 Jun 2011 15:55:24 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: updated standards table
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010803020708060507030706"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010803020708060507030706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch makes the following changes to the standards table:
  - added 'u16 int_freq' to struct XC_TV_STANDARD (needed for analog TV
    and radio, 0 for DVB-T)
  - added new standard for SECAM-D/K video with PAL-D/K audio
  - the 'int_freq' values are now specified in the table
  - changed VideoMode for NTSC and PAL-B/G standards

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------010803020708060507030706
Content-Type: text/x-patch;
 name="xc4000_standards.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_standards.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-03 14:33:40.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-03 15:41:55.000000000 +0200
@@ -94,7 +94,7 @@
 };
 
 /* Misc Defines */
-#define MAX_TV_STANDARD			23
+#define MAX_TV_STANDARD			24
 #define XC_MAX_I2C_WRITE_LENGTH		64
 
 /* Signal Types */
@@ -172,6 +172,7 @@
 	const char  *Name;
 	u16	    AudioMode;
 	u16	    VideoMode;
+	u16	    int_freq;
 };
 
 /* Tuner standards */
@@ -190,39 +191,41 @@
 #define XC4000_DK_SECAM_A2DK1		12
 #define XC4000_DK_SECAM_A2LDK3		13
 #define XC4000_DK_SECAM_A2MONO		14
-#define XC4000_L_SECAM_NICAM		15
-#define XC4000_LC_SECAM_NICAM		16
-#define XC4000_DTV6			17
-#define XC4000_DTV8			18
-#define XC4000_DTV7_8			19
-#define XC4000_DTV7			20
-#define XC4000_FM_Radio_INPUT2		21
-#define XC4000_FM_Radio_INPUT1	22
+#define XC4000_DK_SECAM_NICAM		15
+#define XC4000_L_SECAM_NICAM		16
+#define XC4000_LC_SECAM_NICAM		17
+#define XC4000_DTV6			18
+#define XC4000_DTV8			19
+#define XC4000_DTV7_8			20
+#define XC4000_DTV7			21
+#define XC4000_FM_Radio_INPUT2		22
+#define XC4000_FM_Radio_INPUT1		23
 
 static struct XC_TV_STANDARD XC4000_Standard[MAX_TV_STANDARD] = {
-	{"M/N-NTSC/PAL-BTSC", 0x0000, 0x8020},
-	{"M/N-NTSC/PAL-A2",   0x0000, 0x8020},
-	{"M/N-NTSC/PAL-EIAJ", 0x0040, 0x8020},
-	{"M/N-NTSC/PAL-Mono", 0x0078, 0x8020},
-	{"B/G-PAL-A2",        0x0000, 0x8059},
-	{"B/G-PAL-NICAM",     0x0004, 0x8059},
-	{"B/G-PAL-MONO",      0x0078, 0x8059},
-	{"I-PAL-NICAM",       0x0080, 0x8049},
-	{"I-PAL-NICAM-MONO",  0x0078, 0x8049},
-	{"D/K-PAL-A2",        0x0000, 0x8049},
-	{"D/K-PAL-NICAM",     0x0080, 0x8049},
-	{"D/K-PAL-MONO",      0x0078, 0x8049},
-	{"D/K-SECAM-A2 DK1",  0x0000, 0x8049},
-	{"D/K-SECAM-A2 L/DK3", 0x0000, 0x8049},
-	{"D/K-SECAM-A2 MONO", 0x0078, 0x8049},
-	{"L-SECAM-NICAM",     0x8080, 0x0009},
-	{"L'-SECAM-NICAM",    0x8080, 0x4009},
-	{"DTV6",              0x00C0, 0x8002},
-	{"DTV8",              0x00C0, 0x800B},
-	{"DTV7/8",            0x00C0, 0x801B},
-	{"DTV7",              0x00C0, 0x8007},
-	{"FM Radio-INPUT2",   0x0008, 0x9800},
-	{"FM Radio-INPUT1",   0x0008, 0x9000}
+	{"M/N-NTSC/PAL-BTSC",	0x0000, 0x80A0, 4500},
+	{"M/N-NTSC/PAL-A2",	0x0000, 0x80A0, 4600},
+	{"M/N-NTSC/PAL-EIAJ",	0x0040, 0x80A0, 4500},
+	{"M/N-NTSC/PAL-Mono",	0x0078, 0x80A0, 4500},
+	{"B/G-PAL-A2",		0x0000, 0x8159, 5640},
+	{"B/G-PAL-NICAM",	0x0004, 0x8159, 5740},
+	{"B/G-PAL-MONO",	0x0078, 0x8159, 5500},
+	{"I-PAL-NICAM",		0x0080, 0x8049, 6240},
+	{"I-PAL-NICAM-MONO",	0x0078, 0x8049, 6000},
+	{"D/K-PAL-A2",		0x0000, 0x8049, 6380},
+	{"D/K-PAL-NICAM",	0x0080, 0x8049, 6200},
+	{"D/K-PAL-MONO",	0x0078, 0x8049, 6500},
+	{"D/K-SECAM-A2 DK1",	0x0000, 0x8049, 6340},
+	{"D/K-SECAM-A2 L/DK3",	0x0000, 0x8049, 6000},
+	{"D/K-SECAM-A2 MONO",	0x0078, 0x8049, 6500},
+	{"D/K-SECAM-NICAM",	0x0080, 0x8049, 6200},
+	{"L-SECAM-NICAM",	0x8080, 0x0009, 6200},
+	{"L'-SECAM-NICAM",	0x8080, 0x4009, 6200},
+	{"DTV6",		0x00C0, 0x8002,    0},
+	{"DTV8",		0x00C0, 0x800B,    0},
+	{"DTV7/8",		0x00C0, 0x801B,    0},
+	{"DTV7",		0x00C0, 0x8007,    0},
+	{"FM Radio-INPUT2",	0x0008, 0x9800,10700},
+	{"FM Radio-INPUT1",	0x0008, 0x9000,10700}
 };
 
 static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val);

--------------010803020708060507030706--
