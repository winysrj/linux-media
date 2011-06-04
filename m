Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:57395 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab1FDPP4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:15:56 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsZs-0003km-D3
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:15:55 +0200
Message-ID: <4DEA4C27.7040006@mailbox.hu>
Date: Sat, 04 Jun 2011 17:15:51 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: added audio_std module parameter
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010001060407060308040106"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010001060407060308040106
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

The 'audio_std' module parameter makes it possible to fine tune
some audio related aspects of the driver, like setting the exact
audio standard (NICAM, A2, etc.) to be used for some video standards.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------010001060407060308040106
Content-Type: text/x-patch;
 name="xc4000_audiostd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_audiostd.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 15:23:35.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 15:38:30.000000000 +0200
@@ -49,6 +49,27 @@
 	"\t\t2: powers device off when not used.\n"
 	"\t\t0 (default): use device-specific default mode.");
 
+#define XC4000_AUDIO_STD_B		 1
+#define XC4000_AUDIO_STD_A2		 2
+#define XC4000_AUDIO_STD_K3		 4
+#define XC4000_AUDIO_STD_L		 8
+#define XC4000_AUDIO_STD_INPUT1		16
+#define XC4000_AUDIO_STD_MONO		32
+
+static int audio_std;
+module_param(audio_std, int, 0644);
+MODULE_PARM_DESC(audio_std, "\n\t\tAudio standard. XC4000 audio decoder "
+	"explicitly needs to know\n"
+	"\t\twhat audio standard is needed for some video standards with\n"
+	"\t\taudio A2 or NICAM.\n"
+	"\t\tThe valid settings are a sum of:\n"
+	"\t\t 1: use NICAM/B or A2/B instead of NICAM/A or A2/A\n"
+	"\t\t 2: use A2 instead of NICAM or BTSC\n"
+	"\t\t 4: use SECAM/K3 instead of K1\n"
+	"\t\t 8: use PAL-D/K audio for SECAM-D/K\n"
+	"\t\t16: use FM radio input 1 instead of input 2\n"
+	"\t\t32: use mono audio (the lower three bits are ignored)");
+
 #define XC4000_DEFAULT_FIRMWARE "xc4000.fw"
 
 static char firmware_name[30];
@@ -1343,6 +1364,8 @@
 			if (priv->card_type == XC4000_CARD_WINFAST_CX88 &&
 			    priv->firm_version == 0x0102)
 				video_mode &= 0xFEFF;
+			if (audio_std & XC4000_AUDIO_STD_B)
+				video_mode |= 0x0080;
 		}
 		ret = xc_SetTVStandard(priv, video_mode, audio_mode);
 		if (ret != XC_RESULT_SUCCESS) {

--------------010001060407060308040106--
