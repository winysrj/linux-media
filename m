Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946722Ab3BHSTz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Feb 2013 13:19:55 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r18IJtsl021637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 8 Feb 2013 13:19:55 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] tveeprom: Fix lots of bad whitespace
Date: Fri,  8 Feb 2013 16:19:50 -0200
Message-Id: <1360347590-7707-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While running checkpatch.pl after the last patch, I noticed
lots of those:
	WARNING: please, no space before tabs
	#151: FILE: drivers/media/common/tveeprom.c:99:
	+^I{ TUNER_ABSENT,        ^I^I"None" },$

(together with other checkpatch.pl errors/warnings)

While I won't be fixing everything, as I have already an
script to fix the above, let's do it, in order to clean it
a little bit.

While here, also drop cmacs-specific format text at the end.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tveeprom.c | 290 ++++++++++++++++++++--------------------
 1 file changed, 142 insertions(+), 148 deletions(-)

diff --git a/drivers/media/common/tveeprom.c b/drivers/media/common/tveeprom.c
index 3b6cf03..cc1e172 100644
--- a/drivers/media/common/tveeprom.c
+++ b/drivers/media/common/tveeprom.c
@@ -96,170 +96,170 @@ static struct HAUPPAUGE_TUNER
 hauppauge_tuner[] =
 {
 	/* 0-9 */
-	{ TUNER_ABSENT,        		"None" },
-	{ TUNER_ABSENT,        		"External" },
-	{ TUNER_ABSENT,        		"Unspecified" },
-	{ TUNER_PHILIPS_PAL,   		"Philips FI1216" },
-	{ TUNER_PHILIPS_SECAM, 		"Philips FI1216MF" },
-	{ TUNER_PHILIPS_NTSC,  		"Philips FI1236" },
-	{ TUNER_PHILIPS_PAL_I, 		"Philips FI1246" },
+	{ TUNER_ABSENT,			"None" },
+	{ TUNER_ABSENT,			"External" },
+	{ TUNER_ABSENT,			"Unspecified" },
+	{ TUNER_PHILIPS_PAL,		"Philips FI1216" },
+	{ TUNER_PHILIPS_SECAM,		"Philips FI1216MF" },
+	{ TUNER_PHILIPS_NTSC,		"Philips FI1236" },
+	{ TUNER_PHILIPS_PAL_I,		"Philips FI1246" },
 	{ TUNER_PHILIPS_PAL_DK,		"Philips FI1256" },
-	{ TUNER_PHILIPS_PAL,   		"Philips FI1216 MK2" },
-	{ TUNER_PHILIPS_SECAM, 		"Philips FI1216MF MK2" },
+	{ TUNER_PHILIPS_PAL,		"Philips FI1216 MK2" },
+	{ TUNER_PHILIPS_SECAM,		"Philips FI1216MF MK2" },
 	/* 10-19 */
-	{ TUNER_PHILIPS_NTSC,  		"Philips FI1236 MK2" },
-	{ TUNER_PHILIPS_PAL_I, 		"Philips FI1246 MK2" },
+	{ TUNER_PHILIPS_NTSC,		"Philips FI1236 MK2" },
+	{ TUNER_PHILIPS_PAL_I,		"Philips FI1246 MK2" },
 	{ TUNER_PHILIPS_PAL_DK,		"Philips FI1256 MK2" },
-	{ TUNER_TEMIC_NTSC,    		"Temic 4032FY5" },
-	{ TUNER_TEMIC_PAL,     		"Temic 4002FH5" },
-	{ TUNER_TEMIC_PAL_I,   		"Temic 4062FY5" },
-	{ TUNER_PHILIPS_PAL,   		"Philips FR1216 MK2" },
-	{ TUNER_PHILIPS_SECAM, 		"Philips FR1216MF MK2" },
-	{ TUNER_PHILIPS_NTSC,  		"Philips FR1236 MK2" },
-	{ TUNER_PHILIPS_PAL_I, 		"Philips FR1246 MK2" },
+	{ TUNER_TEMIC_NTSC,		"Temic 4032FY5" },
+	{ TUNER_TEMIC_PAL,		"Temic 4002FH5" },
+	{ TUNER_TEMIC_PAL_I,		"Temic 4062FY5" },
+	{ TUNER_PHILIPS_PAL,		"Philips FR1216 MK2" },
+	{ TUNER_PHILIPS_SECAM,		"Philips FR1216MF MK2" },
+	{ TUNER_PHILIPS_NTSC,		"Philips FR1236 MK2" },
+	{ TUNER_PHILIPS_PAL_I,		"Philips FR1246 MK2" },
 	/* 20-29 */
 	{ TUNER_PHILIPS_PAL_DK,		"Philips FR1256 MK2" },
-	{ TUNER_PHILIPS_PAL,   		"Philips FM1216" },
-	{ TUNER_PHILIPS_SECAM, 		"Philips FM1216MF" },
-	{ TUNER_PHILIPS_NTSC,  		"Philips FM1236" },
-	{ TUNER_PHILIPS_PAL_I, 		"Philips FM1246" },
+	{ TUNER_PHILIPS_PAL,		"Philips FM1216" },
+	{ TUNER_PHILIPS_SECAM,		"Philips FM1216MF" },
+	{ TUNER_PHILIPS_NTSC,		"Philips FM1236" },
+	{ TUNER_PHILIPS_PAL_I,		"Philips FM1246" },
 	{ TUNER_PHILIPS_PAL_DK,		"Philips FM1256" },
-	{ TUNER_TEMIC_4036FY5_NTSC, 	"Temic 4036FY5" },
-	{ TUNER_ABSENT,        		"Samsung TCPN9082D" },
-	{ TUNER_ABSENT,        		"Samsung TCPM9092P" },
-	{ TUNER_TEMIC_4006FH5_PAL, 	"Temic 4006FH5" },
+	{ TUNER_TEMIC_4036FY5_NTSC,	"Temic 4036FY5" },
+	{ TUNER_ABSENT,			"Samsung TCPN9082D" },
+	{ TUNER_ABSENT,			"Samsung TCPM9092P" },
+	{ TUNER_TEMIC_4006FH5_PAL,	"Temic 4006FH5" },
 	/* 30-39 */
-	{ TUNER_ABSENT,        		"Samsung TCPN9085D" },
-	{ TUNER_ABSENT,        		"Samsung TCPB9085P" },
-	{ TUNER_ABSENT,        		"Samsung TCPL9091P" },
-	{ TUNER_TEMIC_4039FR5_NTSC, 	"Temic 4039FR5" },
-	{ TUNER_PHILIPS_FQ1216ME,   	"Philips FQ1216 ME" },
-	{ TUNER_TEMIC_4066FY5_PAL_I, 	"Temic 4066FY5" },
-	{ TUNER_PHILIPS_NTSC,        	"Philips TD1536" },
-	{ TUNER_PHILIPS_NTSC,        	"Philips TD1536D" },
-	{ TUNER_PHILIPS_NTSC,  		"Philips FMR1236" }, /* mono radio */
-	{ TUNER_ABSENT,        		"Philips FI1256MP" },
+	{ TUNER_ABSENT,			"Samsung TCPN9085D" },
+	{ TUNER_ABSENT,			"Samsung TCPB9085P" },
+	{ TUNER_ABSENT,			"Samsung TCPL9091P" },
+	{ TUNER_TEMIC_4039FR5_NTSC,	"Temic 4039FR5" },
+	{ TUNER_PHILIPS_FQ1216ME,	"Philips FQ1216 ME" },
+	{ TUNER_TEMIC_4066FY5_PAL_I,	"Temic 4066FY5" },
+	{ TUNER_PHILIPS_NTSC,		"Philips TD1536" },
+	{ TUNER_PHILIPS_NTSC,		"Philips TD1536D" },
+	{ TUNER_PHILIPS_NTSC,		"Philips FMR1236" }, /* mono radio */
+	{ TUNER_ABSENT,			"Philips FI1256MP" },
 	/* 40-49 */
-	{ TUNER_ABSENT,        		"Samsung TCPQ9091P" },
-	{ TUNER_TEMIC_4006FN5_MULTI_PAL, "Temic 4006FN5" },
-	{ TUNER_TEMIC_4009FR5_PAL, 	"Temic 4009FR5" },
-	{ TUNER_TEMIC_4046FM5,     	"Temic 4046FM5" },
+	{ TUNER_ABSENT,			"Samsung TCPQ9091P" },
+	{ TUNER_TEMIC_4006FN5_MULTI_PAL,"Temic 4006FN5" },
+	{ TUNER_TEMIC_4009FR5_PAL,	"Temic 4009FR5" },
+	{ TUNER_TEMIC_4046FM5,		"Temic 4046FM5" },
 	{ TUNER_TEMIC_4009FN5_MULTI_PAL_FM, "Temic 4009FN5" },
-	{ TUNER_ABSENT,        		"Philips TD1536D FH 44"},
-	{ TUNER_LG_NTSC_FM,    		"LG TP18NSR01F"},
-	{ TUNER_LG_PAL_FM,     		"LG TP18PSB01D"},
-	{ TUNER_LG_PAL,        		"LG TP18PSB11D"},
-	{ TUNER_LG_PAL_I_FM,   		"LG TAPC-I001D"},
+	{ TUNER_ABSENT,			"Philips TD1536D FH 44"},
+	{ TUNER_LG_NTSC_FM,		"LG TP18NSR01F"},
+	{ TUNER_LG_PAL_FM,		"LG TP18PSB01D"},
+	{ TUNER_LG_PAL,		"LG TP18PSB11D"},
+	{ TUNER_LG_PAL_I_FM,		"LG TAPC-I001D"},
 	/* 50-59 */
-	{ TUNER_LG_PAL_I,      		"LG TAPC-I701D"},
-	{ TUNER_ABSENT,       		"Temic 4042FI5"},
-	{ TUNER_MICROTUNE_4049FM5, 	"Microtune 4049 FM5"},
-	{ TUNER_ABSENT,        		"LG TPI8NSR11F"},
-	{ TUNER_ABSENT,        		"Microtune 4049 FM5 Alt I2C"},
-	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FQ1216ME MK3"},
-	{ TUNER_ABSENT,        		"Philips FI1236 MK3"},
-	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FM1216 ME MK3"},
-	{ TUNER_PHILIPS_FM1236_MK3, 	"Philips FM1236 MK3"},
-	{ TUNER_ABSENT,        		"Philips FM1216MP MK3"},
+	{ TUNER_LG_PAL_I,		"LG TAPC-I701D"},
+	{ TUNER_ABSENT,			"Temic 4042FI5"},
+	{ TUNER_MICROTUNE_4049FM5,	"Microtune 4049 FM5"},
+	{ TUNER_ABSENT,			"LG TPI8NSR11F"},
+	{ TUNER_ABSENT,			"Microtune 4049 FM5 Alt I2C"},
+	{ TUNER_PHILIPS_FM1216ME_MK3,	"Philips FQ1216ME MK3"},
+	{ TUNER_ABSENT,			"Philips FI1236 MK3"},
+	{ TUNER_PHILIPS_FM1216ME_MK3,	"Philips FM1216 ME MK3"},
+	{ TUNER_PHILIPS_FM1236_MK3,	"Philips FM1236 MK3"},
+	{ TUNER_ABSENT,			"Philips FM1216MP MK3"},
 	/* 60-69 */
-	{ TUNER_PHILIPS_FM1216ME_MK3, 	"LG S001D MK3"},
-	{ TUNER_ABSENT,        		"LG M001D MK3"},
-	{ TUNER_PHILIPS_FM1216ME_MK3, 	"LG S701D MK3"},
-	{ TUNER_ABSENT,        		"LG M701D MK3"},
-	{ TUNER_ABSENT,        		"Temic 4146FM5"},
-	{ TUNER_ABSENT,        		"Temic 4136FY5"},
-	{ TUNER_ABSENT,        		"Temic 4106FH5"},
-	{ TUNER_ABSENT,        		"Philips FQ1216LMP MK3"},
-	{ TUNER_LG_NTSC_TAPE,  		"LG TAPE H001F MK3"},
-	{ TUNER_LG_NTSC_TAPE,  		"LG TAPE H701F MK3"},
+	{ TUNER_PHILIPS_FM1216ME_MK3,	"LG S001D MK3"},
+	{ TUNER_ABSENT,			"LG M001D MK3"},
+	{ TUNER_PHILIPS_FM1216ME_MK3,	"LG S701D MK3"},
+	{ TUNER_ABSENT,			"LG M701D MK3"},
+	{ TUNER_ABSENT,			"Temic 4146FM5"},
+	{ TUNER_ABSENT,			"Temic 4136FY5"},
+	{ TUNER_ABSENT,			"Temic 4106FH5"},
+	{ TUNER_ABSENT,			"Philips FQ1216LMP MK3"},
+	{ TUNER_LG_NTSC_TAPE,		"LG TAPE H001F MK3"},
+	{ TUNER_LG_NTSC_TAPE,		"LG TAPE H701F MK3"},
 	/* 70-79 */
-	{ TUNER_ABSENT,        		"LG TALN H200T"},
-	{ TUNER_ABSENT,        		"LG TALN H250T"},
-	{ TUNER_ABSENT,        		"LG TALN M200T"},
-	{ TUNER_ABSENT,        		"LG TALN Z200T"},
-	{ TUNER_ABSENT,        		"LG TALN S200T"},
-	{ TUNER_ABSENT,        		"Thompson DTT7595"},
-	{ TUNER_ABSENT,        		"Thompson DTT7592"},
-	{ TUNER_ABSENT,        		"Silicon TDA8275C1 8290"},
-	{ TUNER_ABSENT,        		"Silicon TDA8275C1 8290 FM"},
-	{ TUNER_ABSENT,        		"Thompson DTT757"},
+	{ TUNER_ABSENT,			"LG TALN H200T"},
+	{ TUNER_ABSENT,			"LG TALN H250T"},
+	{ TUNER_ABSENT,			"LG TALN M200T"},
+	{ TUNER_ABSENT,			"LG TALN Z200T"},
+	{ TUNER_ABSENT,			"LG TALN S200T"},
+	{ TUNER_ABSENT,			"Thompson DTT7595"},
+	{ TUNER_ABSENT,			"Thompson DTT7592"},
+	{ TUNER_ABSENT,			"Silicon TDA8275C1 8290"},
+	{ TUNER_ABSENT,			"Silicon TDA8275C1 8290 FM"},
+	{ TUNER_ABSENT,			"Thompson DTT757"},
 	/* 80-89 */
-	{ TUNER_PHILIPS_FQ1216LME_MK3, 	"Philips FQ1216LME MK3"},
-	{ TUNER_LG_PAL_NEW_TAPC, 	"LG TAPC G701D"},
-	{ TUNER_LG_NTSC_NEW_TAPC, 	"LG TAPC H791F"},
-	{ TUNER_LG_PAL_NEW_TAPC, 	"TCL 2002MB 3"},
-	{ TUNER_LG_PAL_NEW_TAPC, 	"TCL 2002MI 3"},
-	{ TUNER_TCL_2002N,     		"TCL 2002N 6A"},
-	{ TUNER_PHILIPS_FM1236_MK3, 	"Philips FQ1236 MK3"},
-	{ TUNER_SAMSUNG_TCPN_2121P30A, 	"Samsung TCPN 2121P30A"},
-	{ TUNER_ABSENT,        		"Samsung TCPE 4121P30A"},
-	{ TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MFPE05 2"},
+	{ TUNER_PHILIPS_FQ1216LME_MK3,	"Philips FQ1216LME MK3"},
+	{ TUNER_LG_PAL_NEW_TAPC,	"LG TAPC G701D"},
+	{ TUNER_LG_NTSC_NEW_TAPC,	"LG TAPC H791F"},
+	{ TUNER_LG_PAL_NEW_TAPC,	"TCL 2002MB 3"},
+	{ TUNER_LG_PAL_NEW_TAPC,	"TCL 2002MI 3"},
+	{ TUNER_TCL_2002N,		"TCL 2002N 6A"},
+	{ TUNER_PHILIPS_FM1236_MK3,	"Philips FQ1236 MK3"},
+	{ TUNER_SAMSUNG_TCPN_2121P30A,	"Samsung TCPN 2121P30A"},
+	{ TUNER_ABSENT,			"Samsung TCPE 4121P30A"},
+	{ TUNER_PHILIPS_FM1216ME_MK3,	"TCL MFPE05 2"},
 	/* 90-99 */
-	{ TUNER_ABSENT,        		"LG TALN H202T"},
-	{ TUNER_PHILIPS_FQ1216AME_MK4, 	"Philips FQ1216AME MK4"},
-	{ TUNER_PHILIPS_FQ1236A_MK4, 	"Philips FQ1236A MK4"},
-	{ TUNER_ABSENT,       		"Philips FQ1286A MK4"},
-	{ TUNER_ABSENT,        		"Philips FQ1216ME MK5"},
-	{ TUNER_ABSENT,        		"Philips FQ1236 MK5"},
-	{ TUNER_SAMSUNG_TCPG_6121P30A, 	"Samsung TCPG 6121P30A"},
-	{ TUNER_TCL_2002MB,    		"TCL 2002MB_3H"},
-	{ TUNER_ABSENT,        		"TCL 2002MI_3H"},
-	{ TUNER_TCL_2002N,     		"TCL 2002N 5H"},
+	{ TUNER_ABSENT,			"LG TALN H202T"},
+	{ TUNER_PHILIPS_FQ1216AME_MK4,	"Philips FQ1216AME MK4"},
+	{ TUNER_PHILIPS_FQ1236A_MK4,	"Philips FQ1236A MK4"},
+	{ TUNER_ABSENT,			"Philips FQ1286A MK4"},
+	{ TUNER_ABSENT,			"Philips FQ1216ME MK5"},
+	{ TUNER_ABSENT,			"Philips FQ1236 MK5"},
+	{ TUNER_SAMSUNG_TCPG_6121P30A,	"Samsung TCPG 6121P30A"},
+	{ TUNER_TCL_2002MB,		"TCL 2002MB_3H"},
+	{ TUNER_ABSENT,			"TCL 2002MI_3H"},
+	{ TUNER_TCL_2002N,		"TCL 2002N 5H"},
 	/* 100-109 */
-	{ TUNER_PHILIPS_FMD1216ME_MK3, 	"Philips FMD1216ME"},
-	{ TUNER_TEA5767,       		"Philips TEA5768HL FM Radio"},
-	{ TUNER_ABSENT,        		"Panasonic ENV57H12D5"},
-	{ TUNER_PHILIPS_FM1236_MK3, 	"TCL MFNM05-4"},
+	{ TUNER_PHILIPS_FMD1216ME_MK3,	"Philips FMD1216ME"},
+	{ TUNER_TEA5767,		"Philips TEA5768HL FM Radio"},
+	{ TUNER_ABSENT,			"Panasonic ENV57H12D5"},
+	{ TUNER_PHILIPS_FM1236_MK3,	"TCL MFNM05-4"},
 	{ TUNER_PHILIPS_FM1236_MK3,	"TCL MNM05-4"},
-	{ TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MPE05-2"},
-	{ TUNER_ABSENT,        		"TCL MQNM05-4"},
-	{ TUNER_ABSENT,        		"LG TAPC-W701D"},
-	{ TUNER_ABSENT,        		"TCL 9886P-WM"},
-	{ TUNER_ABSENT,        		"TCL 1676NM-WM"},
+	{ TUNER_PHILIPS_FM1216ME_MK3,	"TCL MPE05-2"},
+	{ TUNER_ABSENT,			"TCL MQNM05-4"},
+	{ TUNER_ABSENT,			"LG TAPC-W701D"},
+	{ TUNER_ABSENT,			"TCL 9886P-WM"},
+	{ TUNER_ABSENT,			"TCL 1676NM-WM"},
 	/* 110-119 */
-	{ TUNER_ABSENT,        		"Thompson DTT75105"},
-	{ TUNER_ABSENT,        		"Conexant_CX24109"},
-	{ TUNER_TCL_2002N,     		"TCL M2523_5N_E"},
-	{ TUNER_TCL_2002MB,    		"TCL M2523_3DB_E"},
-	{ TUNER_ABSENT,        		"Philips 8275A"},
-	{ TUNER_ABSENT,        		"Microtune MT2060"},
-	{ TUNER_PHILIPS_FM1236_MK3, 	"Philips FM1236 MK5"},
-	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FM1216ME MK5"},
-	{ TUNER_ABSENT,        		"TCL M2523_3DI_E"},
-	{ TUNER_ABSENT,        		"Samsung THPD5222FG30A"},
+	{ TUNER_ABSENT,			"Thompson DTT75105"},
+	{ TUNER_ABSENT,			"Conexant_CX24109"},
+	{ TUNER_TCL_2002N,		"TCL M2523_5N_E"},
+	{ TUNER_TCL_2002MB,		"TCL M2523_3DB_E"},
+	{ TUNER_ABSENT,			"Philips 8275A"},
+	{ TUNER_ABSENT,			"Microtune MT2060"},
+	{ TUNER_PHILIPS_FM1236_MK3,	"Philips FM1236 MK5"},
+	{ TUNER_PHILIPS_FM1216ME_MK3,	"Philips FM1216ME MK5"},
+	{ TUNER_ABSENT,			"TCL M2523_3DI_E"},
+	{ TUNER_ABSENT,			"Samsung THPD5222FG30A"},
 	/* 120-129 */
-	{ TUNER_XC2028,        		"Xceive XC3028"},
+	{ TUNER_XC2028,			"Xceive XC3028"},
 	{ TUNER_PHILIPS_FQ1216LME_MK3,	"Philips FQ1216LME MK5"},
-	{ TUNER_ABSENT,        		"Philips FQD1216LME"},
-	{ TUNER_ABSENT,        		"Conexant CX24118A"},
-	{ TUNER_ABSENT,        		"TCL DMF11WIP"},
-	{ TUNER_ABSENT,        		"TCL MFNM05_4H_E"},
-	{ TUNER_ABSENT,        		"TCL MNM05_4H_E"},
-	{ TUNER_ABSENT,        		"TCL MPE05_2H_E"},
-	{ TUNER_ABSENT,        		"TCL MQNM05_4_U"},
-	{ TUNER_ABSENT,        		"TCL M2523_5NH_E"},
+	{ TUNER_ABSENT,			"Philips FQD1216LME"},
+	{ TUNER_ABSENT,			"Conexant CX24118A"},
+	{ TUNER_ABSENT,			"TCL DMF11WIP"},
+	{ TUNER_ABSENT,			"TCL MFNM05_4H_E"},
+	{ TUNER_ABSENT,			"TCL MNM05_4H_E"},
+	{ TUNER_ABSENT,			"TCL MPE05_2H_E"},
+	{ TUNER_ABSENT,			"TCL MQNM05_4_U"},
+	{ TUNER_ABSENT,			"TCL M2523_5NH_E"},
 	/* 130-139 */
-	{ TUNER_ABSENT,        		"TCL M2523_3DBH_E"},
-	{ TUNER_ABSENT,        		"TCL M2523_3DIH_E"},
-	{ TUNER_ABSENT,        		"TCL MFPE05_2_U"},
+	{ TUNER_ABSENT,			"TCL M2523_3DBH_E"},
+	{ TUNER_ABSENT,			"TCL M2523_3DIH_E"},
+	{ TUNER_ABSENT,			"TCL MFPE05_2_U"},
 	{ TUNER_PHILIPS_FMD1216MEX_MK3,	"Philips FMD1216MEX"},
-	{ TUNER_ABSENT,        		"Philips FRH2036B"},
-	{ TUNER_ABSENT,        		"Panasonic ENGF75_01GF"},
-	{ TUNER_ABSENT,        		"MaxLinear MXL5005"},
-	{ TUNER_ABSENT,        		"MaxLinear MXL5003"},
-	{ TUNER_ABSENT,        		"Xceive XC2028"},
-	{ TUNER_ABSENT,        		"Microtune MT2131"},
+	{ TUNER_ABSENT,			"Philips FRH2036B"},
+	{ TUNER_ABSENT,			"Panasonic ENGF75_01GF"},
+	{ TUNER_ABSENT,			"MaxLinear MXL5005"},
+	{ TUNER_ABSENT,			"MaxLinear MXL5003"},
+	{ TUNER_ABSENT,			"Xceive XC2028"},
+	{ TUNER_ABSENT,			"Microtune MT2131"},
 	/* 140-149 */
-	{ TUNER_ABSENT,        		"Philips 8275A_8295"},
-	{ TUNER_ABSENT,        		"TCL MF02GIP_5N_E"},
-	{ TUNER_ABSENT,        		"TCL MF02GIP_3DB_E"},
-	{ TUNER_ABSENT,        		"TCL MF02GIP_3DI_E"},
-	{ TUNER_ABSENT,        		"Microtune MT2266"},
-	{ TUNER_ABSENT,        		"TCL MF10WPP_4N_E"},
-	{ TUNER_ABSENT,        		"LG TAPQ_H702F"},
-	{ TUNER_ABSENT,        		"TCL M09WPP_4N_E"},
-	{ TUNER_ABSENT,        		"MaxLinear MXL5005_v2"},
-	{ TUNER_PHILIPS_TDA8290, 	"Philips 18271_8295"},
+	{ TUNER_ABSENT,			"Philips 8275A_8295"},
+	{ TUNER_ABSENT,			"TCL MF02GIP_5N_E"},
+	{ TUNER_ABSENT,			"TCL MF02GIP_3DB_E"},
+	{ TUNER_ABSENT,			"TCL MF02GIP_3DI_E"},
+	{ TUNER_ABSENT,			"Microtune MT2266"},
+	{ TUNER_ABSENT,			"TCL MF10WPP_4N_E"},
+	{ TUNER_ABSENT,			"LG TAPQ_H702F"},
+	{ TUNER_ABSENT,			"TCL M09WPP_4N_E"},
+	{ TUNER_ABSENT,			"MaxLinear MXL5005_v2"},
+	{ TUNER_PHILIPS_TDA8290,	"Philips 18271_8295"},
 	/* 150-159 */
 	{ TUNER_XC5000,                 "Xceive XC5000"},
 	{ TUNER_ABSENT,                 "Xceive XC3028L"},
@@ -784,9 +784,3 @@ int tveeprom_read(struct i2c_client *c, unsigned char *eedata, int len)
 	return 0;
 }
 EXPORT_SYMBOL(tveeprom_read);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-- 
1.8.1

