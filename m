Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935635Ab0CMAnm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 19:43:42 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2D0hdBR031973
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 19:43:39 -0500
Received: from [10.3.250.145] (vpn-250-145.phx2.redhat.com [10.3.250.145])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2D0hP6O027496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 19:43:33 -0500
Message-Id: <636219277bb150426e3219e48d30138f00b8a52e.1268440758.git.mchehab@redhat.com>
In-Reply-To: <ce6bfd7f5f6ec23a59900422f6180ca49d006b18.1268440758.git.mchehab@redhat.com>
References: <ce6bfd7f5f6ec23a59900422f6180ca49d006b18.1268440758.git.mchehab@redhat.com>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Fri, 12 Mar 2010 11:40:13 -0300
Subject: [PATCH 2/4] Add a macro to properly create IR tables
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keymaps.c b/drivers/media/IR/ir-keymaps.c
index 0efdefe..dfc777b 100644
--- a/drivers/media/IR/ir-keymaps.c
+++ b/drivers/media/IR/ir-keymaps.c
@@ -28,16 +28,28 @@
 #include <linux/input.h>
 #include <media/ir-common.h>
 
+
+/*
+ * The usage of tables with just the command part is deprecated.
+ * All new IR keytables should contain address+command and need
+ * to define the proper IR_TYPE (IR_TYPE_RC5/IR_TYPE_NEC).
+ * The deprecated tables should use IR_TYPE_UNKNOWN
+ */
+#define IR_TABLE(irname, type, tabname)				\
+struct ir_scancode_table tabname ## _table = {			\
+	.scan = tabname,					\
+	.size = ARRAY_SIZE(tabname),				\
+	.ir_type = type,					\
+	.name = #irname,					\
+};								\
+EXPORT_SYMBOL_GPL(tabname ## _table)
+
+
 /* empty keytable, can be used as placeholder for not-yet created keytables */
 static struct ir_scancode ir_codes_empty[] = {
 	{ 0x2a, KEY_COFFEE },
 };
-
-struct ir_scancode_table ir_codes_empty_table = {
-	.scan = ir_codes_empty,
-	.size = ARRAY_SIZE(ir_codes_empty),
-};
-EXPORT_SYMBOL_GPL(ir_codes_empty_table);
+IR_TABLE(empty, IR_TYPE_UNKNOWN, ir_codes_empty);
 
 /* Michal Majchrowicz <mmajchrowicz@gmail.com> */
 static struct ir_scancode ir_codes_proteus_2309[] = {
@@ -68,12 +80,7 @@ static struct ir_scancode ir_codes_proteus_2309[] = {
 	{ 0x1e, KEY_VOLUMEUP },		/* volume +    */
 	{ 0x14, KEY_F1 },
 };
-
-struct ir_scancode_table ir_codes_proteus_2309_table = {
-	.scan = ir_codes_proteus_2309,
-	.size = ARRAY_SIZE(ir_codes_proteus_2309),
-};
-EXPORT_SYMBOL_GPL(ir_codes_proteus_2309_table);
+IR_TABLE(proteus_2309, IR_TYPE_UNKNOWN, ir_codes_proteus_2309);
 
 /* Matt Jesson <dvb@jesson.eclipse.co.uk */
 static struct ir_scancode ir_codes_avermedia_dvbt[] = {
@@ -113,12 +120,7 @@ static struct ir_scancode ir_codes_avermedia_dvbt[] = {
 	{ 0x1e, KEY_VOLUMEDOWN },	/* 'volume -' */
 	{ 0x3e, KEY_VOLUMEUP },		/* 'volume +' */
 };
-
-struct ir_scancode_table ir_codes_avermedia_dvbt_table = {
-	.scan = ir_codes_avermedia_dvbt,
-	.size = ARRAY_SIZE(ir_codes_avermedia_dvbt),
-};
-EXPORT_SYMBOL_GPL(ir_codes_avermedia_dvbt_table);
+IR_TABLE(avermedia_dvbt, IR_TYPE_UNKNOWN, ir_codes_avermedia_dvbt);
 
 /* Mauro Carvalho Chehab <mchehab@infradead.org> */
 static struct ir_scancode ir_codes_avermedia_m135a[] = {
@@ -168,12 +170,7 @@ static struct ir_scancode ir_codes_avermedia_m135a[] = {
 	{ 0x18, KEY_PLAY },
 	{ 0x1b, KEY_STOP },
 };
-
-struct ir_scancode_table ir_codes_avermedia_m135a_table = {
-	.scan = ir_codes_avermedia_m135a,
-	.size = ARRAY_SIZE(ir_codes_avermedia_m135a),
-};
-EXPORT_SYMBOL_GPL(ir_codes_avermedia_m135a_table);
+IR_TABLE(avermedia_m135a, IR_TYPE_UNKNOWN, ir_codes_avermedia_m135a);
 
 /* Oldrich Jedlicka <oldium.pro@seznam.cz> */
 static struct ir_scancode ir_codes_avermedia_cardbus[] = {
@@ -232,12 +229,7 @@ static struct ir_scancode ir_codes_avermedia_cardbus[] = {
 	{ 0x42, KEY_CHANNELDOWN },	/* Channel down */
 	{ 0x43, KEY_CHANNELUP },	/* Channel up */
 };
-
-struct ir_scancode_table ir_codes_avermedia_cardbus_table = {
-	.scan = ir_codes_avermedia_cardbus,
-	.size = ARRAY_SIZE(ir_codes_avermedia_cardbus),
-};
-EXPORT_SYMBOL_GPL(ir_codes_avermedia_cardbus_table);
+IR_TABLE(avermedia_cardbus, IR_TYPE_UNKNOWN, ir_codes_avermedia_cardbus);
 
 /* Attila Kondoros <attila.kondoros@chello.hu> */
 static struct ir_scancode ir_codes_apac_viewcomp[] = {
@@ -279,12 +271,7 @@ static struct ir_scancode ir_codes_apac_viewcomp[] = {
 	{ 0x0c, KEY_KPPLUS },		/* fine tune >>>> */
 	{ 0x18, KEY_KPMINUS },		/* fine tune <<<< */
 };
-
-struct ir_scancode_table ir_codes_apac_viewcomp_table = {
-	.scan = ir_codes_apac_viewcomp,
-	.size = ARRAY_SIZE(ir_codes_apac_viewcomp),
-};
-EXPORT_SYMBOL_GPL(ir_codes_apac_viewcomp_table);
+IR_TABLE(apac_viewcomp, IR_TYPE_UNKNOWN, ir_codes_apac_viewcomp);
 
 /* ---------------------------------------------------------------------- */
 
@@ -331,12 +318,7 @@ static struct ir_scancode ir_codes_pixelview[] = {
 	{ 0x1d, KEY_REFRESH },		/* reset */
 	{ 0x18, KEY_MUTE },		/* mute/unmute */
 };
-
-struct ir_scancode_table ir_codes_pixelview_table = {
-	.scan = ir_codes_pixelview,
-	.size = ARRAY_SIZE(ir_codes_pixelview),
-};
-EXPORT_SYMBOL_GPL(ir_codes_pixelview_table);
+IR_TABLE(pixelview, IR_TYPE_UNKNOWN, ir_codes_pixelview);
 
 /*
    Mauro Carvalho Chehab <mchehab@infradead.org>
@@ -381,12 +363,7 @@ static struct ir_scancode ir_codes_pixelview_new[] = {
 	{ 0x31, KEY_TV },
 	{ 0x34, KEY_RADIO },
 };
-
-struct ir_scancode_table ir_codes_pixelview_new_table = {
-	.scan = ir_codes_pixelview_new,
-	.size = ARRAY_SIZE(ir_codes_pixelview_new),
-};
-EXPORT_SYMBOL_GPL(ir_codes_pixelview_new_table);
+IR_TABLE(pixelview_new, IR_TYPE_UNKNOWN, ir_codes_pixelview_new);
 
 static struct ir_scancode ir_codes_nebula[] = {
 	{ 0x00, KEY_0 },
@@ -445,12 +422,7 @@ static struct ir_scancode ir_codes_nebula[] = {
 	{ 0x35, KEY_PHONE },
 	{ 0x36, KEY_PC },
 };
-
-struct ir_scancode_table ir_codes_nebula_table = {
-	.scan = ir_codes_nebula,
-	.size = ARRAY_SIZE(ir_codes_nebula),
-};
-EXPORT_SYMBOL_GPL(ir_codes_nebula_table);
+IR_TABLE(nebula, IR_TYPE_UNKNOWN, ir_codes_nebula);
 
 /* DigitalNow DNTV Live DVB-T Remote */
 static struct ir_scancode ir_codes_dntv_live_dvb_t[] = {
@@ -490,12 +462,7 @@ static struct ir_scancode ir_codes_dntv_live_dvb_t[] = {
 	{ 0x1e, KEY_CHANNELDOWN },
 	{ 0x1f, KEY_VOLUMEDOWN },
 };
-
-struct ir_scancode_table ir_codes_dntv_live_dvb_t_table = {
-	.scan = ir_codes_dntv_live_dvb_t,
-	.size = ARRAY_SIZE(ir_codes_dntv_live_dvb_t),
-};
-EXPORT_SYMBOL_GPL(ir_codes_dntv_live_dvb_t_table);
+IR_TABLE(dntv_live_dvb_t, IR_TYPE_UNKNOWN, ir_codes_dntv_live_dvb_t);
 
 /* ---------------------------------------------------------------------- */
 
@@ -547,12 +514,7 @@ static struct ir_scancode ir_codes_iodata_bctv7e[] = {
 	{ 0x61, KEY_FASTFORWARD },	/* forward >> */
 	{ 0x01, KEY_NEXT },		/* skip >| */
 };
-
-struct ir_scancode_table ir_codes_iodata_bctv7e_table = {
-	.scan = ir_codes_iodata_bctv7e,
-	.size = ARRAY_SIZE(ir_codes_iodata_bctv7e),
-};
-EXPORT_SYMBOL_GPL(ir_codes_iodata_bctv7e_table);
+IR_TABLE(iodata_bctv7e, IR_TYPE_UNKNOWN, ir_codes_iodata_bctv7e);
 
 /* ---------------------------------------------------------------------- */
 
@@ -605,12 +567,7 @@ static struct ir_scancode ir_codes_adstech_dvb_t_pci[] = {
 	{ 0x15, KEY_VOLUMEUP },
 	{ 0x1c, KEY_VOLUMEDOWN },
 };
-
-struct ir_scancode_table ir_codes_adstech_dvb_t_pci_table = {
-	.scan = ir_codes_adstech_dvb_t_pci,
-	.size = ARRAY_SIZE(ir_codes_adstech_dvb_t_pci),
-};
-EXPORT_SYMBOL_GPL(ir_codes_adstech_dvb_t_pci_table);
+IR_TABLE(adstech_dvb_t_pci, IR_TYPE_UNKNOWN, ir_codes_adstech_dvb_t_pci);
 
 /* ---------------------------------------------------------------------- */
 
@@ -644,12 +601,7 @@ static struct ir_scancode ir_codes_msi_tvanywhere[] = {
 	{ 0x1e, KEY_CHANNELDOWN },
 	{ 0x1f, KEY_VOLUMEDOWN },
 };
-
-struct ir_scancode_table ir_codes_msi_tvanywhere_table = {
-	.scan = ir_codes_msi_tvanywhere,
-	.size = ARRAY_SIZE(ir_codes_msi_tvanywhere),
-};
-EXPORT_SYMBOL_GPL(ir_codes_msi_tvanywhere_table);
+IR_TABLE(msi_tvanywhere, IR_TYPE_UNKNOWN, ir_codes_msi_tvanywhere);
 
 /* ---------------------------------------------------------------------- */
 
@@ -738,12 +690,7 @@ static struct ir_scancode ir_codes_msi_tvanywhere_plus[] = {
 	{ 0x0c, KEY_FASTFORWARD },	/* >> */
 	{ 0x1d, KEY_RESTART },		/* Reset */
 };
-
-struct ir_scancode_table ir_codes_msi_tvanywhere_plus_table = {
-	.scan = ir_codes_msi_tvanywhere_plus,
-	.size = ARRAY_SIZE(ir_codes_msi_tvanywhere_plus),
-};
-EXPORT_SYMBOL_GPL(ir_codes_msi_tvanywhere_plus_table);
+IR_TABLE(msi_tvanywhere_plus, IR_TYPE_UNKNOWN, ir_codes_msi_tvanywhere_plus);
 
 /* ---------------------------------------------------------------------- */
 
@@ -791,12 +738,7 @@ static struct ir_scancode ir_codes_cinergy_1400[] = {
 	{ 0x48, KEY_STOP },
 	{ 0x5c, KEY_NEXT },
 };
-
-struct ir_scancode_table ir_codes_cinergy_1400_table = {
-	.scan = ir_codes_cinergy_1400,
-	.size = ARRAY_SIZE(ir_codes_cinergy_1400),
-};
-EXPORT_SYMBOL_GPL(ir_codes_cinergy_1400_table);
+IR_TABLE(cinergy_1400, IR_TYPE_UNKNOWN, ir_codes_cinergy_1400);
 
 /* ---------------------------------------------------------------------- */
 
@@ -845,12 +787,7 @@ static struct ir_scancode ir_codes_avertv_303[] = {
 	{ 0x13, KEY_DOWN },
 	{ 0x1b, KEY_UP },
 };
-
-struct ir_scancode_table ir_codes_avertv_303_table = {
-	.scan = ir_codes_avertv_303,
-	.size = ARRAY_SIZE(ir_codes_avertv_303),
-};
-EXPORT_SYMBOL_GPL(ir_codes_avertv_303_table);
+IR_TABLE(avertv_303, IR_TYPE_UNKNOWN, ir_codes_avertv_303);
 
 /* ---------------------------------------------------------------------- */
 
@@ -911,12 +848,7 @@ static struct ir_scancode ir_codes_dntv_live_dvbt_pro[] = {
 	{ 0x5c, KEY_YELLOW },
 	{ 0x5d, KEY_BLUE },
 };
-
-struct ir_scancode_table ir_codes_dntv_live_dvbt_pro_table = {
-	.scan = ir_codes_dntv_live_dvbt_pro,
-	.size = ARRAY_SIZE(ir_codes_dntv_live_dvbt_pro),
-};
-EXPORT_SYMBOL_GPL(ir_codes_dntv_live_dvbt_pro_table);
+IR_TABLE(dntv_live_dvbt_pro, IR_TYPE_UNKNOWN, ir_codes_dntv_live_dvbt_pro);
 
 static struct ir_scancode ir_codes_em_terratec[] = {
 	{ 0x01, KEY_CHANNEL },
@@ -948,12 +880,7 @@ static struct ir_scancode ir_codes_em_terratec[] = {
 	{ 0x1e, KEY_STOP },
 	{ 0x40, KEY_ZOOM },
 };
-
-struct ir_scancode_table ir_codes_em_terratec_table = {
-	.scan = ir_codes_em_terratec,
-	.size = ARRAY_SIZE(ir_codes_em_terratec),
-};
-EXPORT_SYMBOL_GPL(ir_codes_em_terratec_table);
+IR_TABLE(em_terratec, IR_TYPE_UNKNOWN, ir_codes_em_terratec);
 
 static struct ir_scancode ir_codes_pinnacle_grey[] = {
 	{ 0x3a, KEY_0 },
@@ -1005,12 +932,7 @@ static struct ir_scancode ir_codes_pinnacle_grey[] = {
 	{ 0x2a, KEY_MEDIA },
 	{ 0x18, KEY_EPG },
 };
-
-struct ir_scancode_table ir_codes_pinnacle_grey_table = {
-	.scan = ir_codes_pinnacle_grey,
-	.size = ARRAY_SIZE(ir_codes_pinnacle_grey),
-};
-EXPORT_SYMBOL_GPL(ir_codes_pinnacle_grey_table);
+IR_TABLE(pinnacle_grey, IR_TYPE_UNKNOWN, ir_codes_pinnacle_grey);
 
 static struct ir_scancode ir_codes_flyvideo[] = {
 	{ 0x0f, KEY_0 },
@@ -1043,12 +965,7 @@ static struct ir_scancode ir_codes_flyvideo[] = {
 	{ 0x1f, KEY_FORWARD },	/* Forward ( >>> ) */
 	{ 0x0a, KEY_ANGLE },	/* no label, may be used as the PAUSE button */
 };
-
-struct ir_scancode_table ir_codes_flyvideo_table = {
-	.scan = ir_codes_flyvideo,
-	.size = ARRAY_SIZE(ir_codes_flyvideo),
-};
-EXPORT_SYMBOL_GPL(ir_codes_flyvideo_table);
+IR_TABLE(flyvideo, IR_TYPE_UNKNOWN, ir_codes_flyvideo);
 
 static struct ir_scancode ir_codes_flydvb[] = {
 	{ 0x01, KEY_ZOOM },		/* Full Screen */
@@ -1088,12 +1005,7 @@ static struct ir_scancode ir_codes_flydvb[] = {
 	{ 0x11, KEY_STOP },		/* Stop */
 	{ 0x0e, KEY_NEXT },		/* End >>| */
 };
-
-struct ir_scancode_table ir_codes_flydvb_table = {
-	.scan = ir_codes_flydvb,
-	.size = ARRAY_SIZE(ir_codes_flydvb),
-};
-EXPORT_SYMBOL_GPL(ir_codes_flydvb_table);
+IR_TABLE(flydvb, IR_TYPE_UNKNOWN, ir_codes_flydvb);
 
 static struct ir_scancode ir_codes_cinergy[] = {
 	{ 0x00, KEY_0 },
@@ -1134,12 +1046,7 @@ static struct ir_scancode ir_codes_cinergy[] = {
 	{ 0x22, KEY_PAUSE },
 	{ 0x23, KEY_STOP },
 };
-
-struct ir_scancode_table ir_codes_cinergy_table = {
-	.scan = ir_codes_cinergy,
-	.size = ARRAY_SIZE(ir_codes_cinergy),
-};
-EXPORT_SYMBOL_GPL(ir_codes_cinergy_table);
+IR_TABLE(cinergy, IR_TYPE_UNKNOWN, ir_codes_cinergy);
 
 /* Alfons Geser <a.geser@cox.net>
  * updates from Job D. R. Borges <jobdrb@ig.com.br> */
@@ -1197,12 +1104,7 @@ static struct ir_scancode ir_codes_eztv[] = {
 	{ 0x13, KEY_ENTER },	/* enter */
 	{ 0x21, KEY_DOT },	/* . (decimal dot) */
 };
-
-struct ir_scancode_table ir_codes_eztv_table = {
-	.scan = ir_codes_eztv,
-	.size = ARRAY_SIZE(ir_codes_eztv),
-};
-EXPORT_SYMBOL_GPL(ir_codes_eztv_table);
+IR_TABLE(eztv, IR_TYPE_UNKNOWN, ir_codes_eztv);
 
 /* Alex Hermann <gaaf@gmx.net> */
 static struct ir_scancode ir_codes_avermedia[] = {
@@ -1250,12 +1152,7 @@ static struct ir_scancode ir_codes_avermedia[] = {
 	{ 0x11, KEY_CHANNELDOWN },	/* CHANNEL/PAGE- */
 	{ 0x31, KEY_CHANNELUP }		/* CHANNEL/PAGE+ */
 };
-
-struct ir_scancode_table ir_codes_avermedia_table = {
-	.scan = ir_codes_avermedia,
-	.size = ARRAY_SIZE(ir_codes_avermedia),
-};
-EXPORT_SYMBOL_GPL(ir_codes_avermedia_table);
+IR_TABLE(avermedia, IR_TYPE_UNKNOWN, ir_codes_avermedia);
 
 static struct ir_scancode ir_codes_videomate_tv_pvr[] = {
 	{ 0x14, KEY_MUTE },
@@ -1305,12 +1202,7 @@ static struct ir_scancode ir_codes_videomate_tv_pvr[] = {
 	{ 0x20, KEY_LANGUAGE },
 	{ 0x21, KEY_SLEEP },
 };
-
-struct ir_scancode_table ir_codes_videomate_tv_pvr_table = {
-	.scan = ir_codes_videomate_tv_pvr,
-	.size = ARRAY_SIZE(ir_codes_videomate_tv_pvr),
-};
-EXPORT_SYMBOL_GPL(ir_codes_videomate_tv_pvr_table);
+IR_TABLE(videomate_tv_pvr, IR_TYPE_UNKNOWN, ir_codes_videomate_tv_pvr);
 
 /* Michael Tokarev <mjt@tls.msk.ru>
    http://www.corpit.ru/mjt/beholdTV/remote_control.jpg
@@ -1407,12 +1299,7 @@ static struct ir_scancode ir_codes_manli[] = {
 
 	/* 0x1d unused ? */
 };
-
-struct ir_scancode_table ir_codes_manli_table = {
-	.scan = ir_codes_manli,
-	.size = ARRAY_SIZE(ir_codes_manli),
-};
-EXPORT_SYMBOL_GPL(ir_codes_manli_table);
+IR_TABLE(manli, IR_TYPE_UNKNOWN, ir_codes_manli);
 
 /* Mike Baikov <mike@baikov.com> */
 static struct ir_scancode ir_codes_gotview7135[] = {
@@ -1453,12 +1340,7 @@ static struct ir_scancode ir_codes_gotview7135[] = {
 	{ 0x1e, KEY_TIME },	/* TIMESHIFT */
 	{ 0x38, KEY_F24 },	/* NORMAL TIMESHIFT */
 };
-
-struct ir_scancode_table ir_codes_gotview7135_table = {
-	.scan = ir_codes_gotview7135,
-	.size = ARRAY_SIZE(ir_codes_gotview7135),
-};
-EXPORT_SYMBOL_GPL(ir_codes_gotview7135_table);
+IR_TABLE(gotview7135, IR_TYPE_UNKNOWN, ir_codes_gotview7135);
 
 static struct ir_scancode ir_codes_purpletv[] = {
 	{ 0x03, KEY_POWER },
@@ -1502,12 +1384,7 @@ static struct ir_scancode ir_codes_purpletv[] = {
 	{ 0x42, KEY_REWIND },	/* Backward ? */
 
 };
-
-struct ir_scancode_table ir_codes_purpletv_table = {
-	.scan = ir_codes_purpletv,
-	.size = ARRAY_SIZE(ir_codes_purpletv),
-};
-EXPORT_SYMBOL_GPL(ir_codes_purpletv_table);
+IR_TABLE(purpletv, IR_TYPE_UNKNOWN, ir_codes_purpletv);
 
 /* Mapping for the 28 key remote control as seen at
    http://www.sednacomputer.com/photo/cardbus-tv.jpg
@@ -1549,12 +1426,7 @@ static struct ir_scancode ir_codes_pctv_sedna[] = {
 	{ 0x17, KEY_DIGITS },	/* Plus */
 	{ 0x1f, KEY_PLAY },	/* Play */
 };
-
-struct ir_scancode_table ir_codes_pctv_sedna_table = {
-	.scan = ir_codes_pctv_sedna,
-	.size = ARRAY_SIZE(ir_codes_pctv_sedna),
-};
-EXPORT_SYMBOL_GPL(ir_codes_pctv_sedna_table);
+IR_TABLE(pctv_sedna, IR_TYPE_UNKNOWN, ir_codes_pctv_sedna);
 
 /* Mark Phalan <phalanm@o2.ie> */
 static struct ir_scancode ir_codes_pv951[] = {
@@ -1594,12 +1466,7 @@ static struct ir_scancode ir_codes_pv951[] = {
 	{ 0x14, KEY_EQUAL },		/* SYNC */
 	{ 0x1c, KEY_MEDIA },		/* PC/TV */
 };
-
-struct ir_scancode_table ir_codes_pv951_table = {
-	.scan = ir_codes_pv951,
-	.size = ARRAY_SIZE(ir_codes_pv951),
-};
-EXPORT_SYMBOL_GPL(ir_codes_pv951_table);
+IR_TABLE(pv951, IR_TYPE_UNKNOWN, ir_codes_pv951);
 
 /* generic RC5 keytable                                          */
 /* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
@@ -1642,12 +1509,7 @@ static struct ir_scancode ir_codes_rc5_tv[] = {
 	{ 0x3d, KEY_SUSPEND },		/* system standby */
 
 };
-
-struct ir_scancode_table ir_codes_rc5_tv_table = {
-	.scan = ir_codes_rc5_tv,
-	.size = ARRAY_SIZE(ir_codes_rc5_tv),
-};
-EXPORT_SYMBOL_GPL(ir_codes_rc5_tv_table);
+IR_TABLE(rc5_tv, IR_TYPE_UNKNOWN, ir_codes_rc5_tv);
 
 /* Table for Leadtek Winfast Remote Controls - used by both bttv and cx88 */
 static struct ir_scancode ir_codes_winfast[] = {
@@ -1711,12 +1573,7 @@ static struct ir_scancode ir_codes_winfast[] = {
 	{ 0x3b, KEY_F23 },		/* MCE +CH,  on Y04G0033 */
 	{ 0x3f, KEY_F24 }		/* MCE -CH,  on Y04G0033 */
 };
-
-struct ir_scancode_table ir_codes_winfast_table = {
-	.scan = ir_codes_winfast,
-	.size = ARRAY_SIZE(ir_codes_winfast),
-};
-EXPORT_SYMBOL_GPL(ir_codes_winfast_table);
+IR_TABLE(winfast, IR_TYPE_UNKNOWN, ir_codes_winfast);
 
 static struct ir_scancode ir_codes_pinnacle_color[] = {
 	{ 0x59, KEY_MUTE },
@@ -1773,12 +1630,7 @@ static struct ir_scancode ir_codes_pinnacle_color[] = {
 	{ 0x74, KEY_CHANNEL },
 	{ 0x0a, KEY_BACKSPACE },
 };
-
-struct ir_scancode_table ir_codes_pinnacle_color_table = {
-	.scan = ir_codes_pinnacle_color,
-	.size = ARRAY_SIZE(ir_codes_pinnacle_color),
-};
-EXPORT_SYMBOL_GPL(ir_codes_pinnacle_color_table);
+IR_TABLE(pinnacle_color, IR_TYPE_UNKNOWN, ir_codes_pinnacle_color);
 
 /* Hauppauge: the newer, gray remotes (seems there are multiple
  * slightly different versions), shipped with cx88+ivtv cards.
@@ -1840,12 +1692,7 @@ static struct ir_scancode ir_codes_hauppauge_new[] = {
 	{ 0x3c, KEY_ZOOM },		/* full */
 	{ 0x3d, KEY_POWER },		/* system power (green button) */
 };
-
-struct ir_scancode_table ir_codes_hauppauge_new_table = {
-	.scan = ir_codes_hauppauge_new,
-	.size = ARRAY_SIZE(ir_codes_hauppauge_new),
-};
-EXPORT_SYMBOL_GPL(ir_codes_hauppauge_new_table);
+IR_TABLE(hauppauge_new, IR_TYPE_UNKNOWN, ir_codes_hauppauge_new);
 
 static struct ir_scancode ir_codes_npgtech[] = {
 	{ 0x1d, KEY_SWITCHVIDEOMODE },	/* switch inputs */
@@ -1888,12 +1735,7 @@ static struct ir_scancode ir_codes_npgtech[] = {
 	{ 0x10, KEY_POWER },
 
 };
-
-struct ir_scancode_table ir_codes_npgtech_table = {
-	.scan = ir_codes_npgtech,
-	.size = ARRAY_SIZE(ir_codes_npgtech),
-};
-EXPORT_SYMBOL_GPL(ir_codes_npgtech_table);
+IR_TABLE(npgtech, IR_TYPE_UNKNOWN, ir_codes_npgtech);
 
 /* Norwood Micro (non-Pro) TV Tuner
    By Peter Naulls <peter@chocky.org>
@@ -1940,12 +1782,7 @@ static struct ir_scancode ir_codes_norwood[] = {
 	{ 0x34, KEY_RADIO },		/* FM                  */
 	{ 0x65, KEY_POWER },		/* Computer power      */
 };
-
-struct ir_scancode_table ir_codes_norwood_table = {
-	.scan = ir_codes_norwood,
-	.size = ARRAY_SIZE(ir_codes_norwood),
-};
-EXPORT_SYMBOL_GPL(ir_codes_norwood_table);
+IR_TABLE(norwood, IR_TYPE_UNKNOWN, ir_codes_norwood);
 
 /* From reading the following remotes:
  * Zenith Universal 7 / TV Mode 807 / VCR Mode 837
@@ -1999,12 +1836,7 @@ static struct ir_scancode ir_codes_budget_ci_old[] = {
 	{ 0x3d, KEY_POWER2 },
 	{ 0x3e, KEY_TUNER },
 };
-
-struct ir_scancode_table ir_codes_budget_ci_old_table = {
-	.scan = ir_codes_budget_ci_old,
-	.size = ARRAY_SIZE(ir_codes_budget_ci_old),
-};
-EXPORT_SYMBOL_GPL(ir_codes_budget_ci_old_table);
+IR_TABLE(budget_ci_old, IR_TYPE_UNKNOWN, ir_codes_budget_ci_old);
 
 /*
  * Marc Fargas <telenieko@telenieko.com>
@@ -2057,13 +1889,7 @@ static struct ir_scancode ir_codes_asus_pc39[] = {
 	{ 0x3d, KEY_MUTE },		/* mute */
 	{ 0x01, KEY_DVD },		/* dvd */
 };
-
-struct ir_scancode_table ir_codes_asus_pc39_table = {
-	.scan = ir_codes_asus_pc39,
-	.size = ARRAY_SIZE(ir_codes_asus_pc39),
-};
-EXPORT_SYMBOL_GPL(ir_codes_asus_pc39_table);
-
+IR_TABLE(asus_pc39, IR_TYPE_UNKNOWN, ir_codes_asus_pc39);
 
 /* Encore ENLTV-FM  - black plastic, white front cover with white glowing buttons
     Juan Pablo Sormani <sorman@gmail.com> */
@@ -2137,12 +1963,7 @@ static struct ir_scancode ir_codes_encore_enltv[] = {
 	{ 0x47, KEY_YELLOW },		/* AP3 */
 	{ 0x57, KEY_BLUE },		/* AP4 */
 };
-
-struct ir_scancode_table ir_codes_encore_enltv_table = {
-	.scan = ir_codes_encore_enltv,
-	.size = ARRAY_SIZE(ir_codes_encore_enltv),
-};
-EXPORT_SYMBOL_GPL(ir_codes_encore_enltv_table);
+IR_TABLE(encore_enltv, IR_TYPE_UNKNOWN, ir_codes_encore_enltv);
 
 /* Encore ENLTV2-FM  - silver plastic - "Wand Media" written at the botton
     Mauro Carvalho Chehab <mchehab@infradead.org> */
@@ -2194,12 +2015,7 @@ static struct ir_scancode ir_codes_encore_enltv2[] = {
 	{ 0x7d, KEY_FORWARD },
 	{ 0x79, KEY_STOP },
 };
-
-struct ir_scancode_table ir_codes_encore_enltv2_table = {
-	.scan = ir_codes_encore_enltv2,
-	.size = ARRAY_SIZE(ir_codes_encore_enltv2),
-};
-EXPORT_SYMBOL_GPL(ir_codes_encore_enltv2_table);
+IR_TABLE(encore_enltv2, IR_TYPE_UNKNOWN, ir_codes_encore_enltv2);
 
 /* for the Technotrend 1500 bundled remotes (grey and black): */
 static struct ir_scancode ir_codes_tt_1500[] = {
@@ -2243,12 +2059,7 @@ static struct ir_scancode ir_codes_tt_1500[] = {
 	{ 0x3e, KEY_PAUSE },
 	{ 0x3f, KEY_FORWARD },
 };
-
-struct ir_scancode_table ir_codes_tt_1500_table = {
-	.scan = ir_codes_tt_1500,
-	.size = ARRAY_SIZE(ir_codes_tt_1500),
-};
-EXPORT_SYMBOL_GPL(ir_codes_tt_1500_table);
+IR_TABLE(tt_1500, IR_TYPE_UNKNOWN, ir_codes_tt_1500);
 
 /* DViCO FUSION HDTV MCE remote */
 static struct ir_scancode ir_codes_fusionhdtv_mce[] = {
@@ -2308,12 +2119,7 @@ static struct ir_scancode ir_codes_fusionhdtv_mce[] = {
 	{ 0x01, KEY_RECORD },
 	{ 0x4e, KEY_POWER },
 };
-
-struct ir_scancode_table ir_codes_fusionhdtv_mce_table = {
-	.scan = ir_codes_fusionhdtv_mce,
-	.size = ARRAY_SIZE(ir_codes_fusionhdtv_mce),
-};
-EXPORT_SYMBOL_GPL(ir_codes_fusionhdtv_mce_table);
+IR_TABLE(fusionhdtv_mce, IR_TYPE_UNKNOWN, ir_codes_fusionhdtv_mce);
 
 /* Pinnacle PCTV HD 800i mini remote */
 static struct ir_scancode ir_codes_pinnacle_pctv_hd[] = {
@@ -2348,12 +2154,7 @@ static struct ir_scancode ir_codes_pinnacle_pctv_hd[] = {
 	{ 0x36, KEY_RECORD },
 	{ 0x3f, KEY_EPG },	/* Labeled "?" */
 };
-
-struct ir_scancode_table ir_codes_pinnacle_pctv_hd_table = {
-	.scan = ir_codes_pinnacle_pctv_hd,
-	.size = ARRAY_SIZE(ir_codes_pinnacle_pctv_hd),
-};
-EXPORT_SYMBOL_GPL(ir_codes_pinnacle_pctv_hd_table);
+IR_TABLE(pinnacle_pctv_hd, IR_TYPE_UNKNOWN, ir_codes_pinnacle_pctv_hd);
 
 /*
  * Igor Kuznetsov <igk72@ya.ru>
@@ -2456,12 +2257,7 @@ static struct ir_scancode ir_codes_behold[] = {
 	{ 0x5c, KEY_CAMERA },
 
 };
-
-struct ir_scancode_table ir_codes_behold_table = {
-	.scan = ir_codes_behold,
-	.size = ARRAY_SIZE(ir_codes_behold),
-};
-EXPORT_SYMBOL_GPL(ir_codes_behold_table);
+IR_TABLE(behold, IR_TYPE_UNKNOWN, ir_codes_behold);
 
 /* Beholder Intl. Ltd. 2008
  * Dmitry Belimov d.belimov@google.com
@@ -2531,12 +2327,7 @@ static struct ir_scancode ir_codes_behold_columbus[] = {
 	{ 0x1A, KEY_NEXT },
 
 };
-
-struct ir_scancode_table ir_codes_behold_columbus_table = {
-	.scan = ir_codes_behold_columbus,
-	.size = ARRAY_SIZE(ir_codes_behold_columbus),
-};
-EXPORT_SYMBOL_GPL(ir_codes_behold_columbus_table);
+IR_TABLE(behold_columbus, IR_TYPE_UNKNOWN, ir_codes_behold_columbus);
 
 /*
  * Remote control for the Genius TVGO A11MCE
@@ -2582,12 +2373,7 @@ static struct ir_scancode ir_codes_genius_tvgo_a11mce[] = {
 	{ 0x13, KEY_YELLOW },
 	{ 0x50, KEY_BLUE },
 };
-
-struct ir_scancode_table ir_codes_genius_tvgo_a11mce_table = {
-	.scan = ir_codes_genius_tvgo_a11mce,
-	.size = ARRAY_SIZE(ir_codes_genius_tvgo_a11mce),
-};
-EXPORT_SYMBOL_GPL(ir_codes_genius_tvgo_a11mce_table);
+IR_TABLE(genius_tvgo_a11mce, IR_TYPE_UNKNOWN, ir_codes_genius_tvgo_a11mce);
 
 /*
  * Remote control for Powercolor Real Angel 330
@@ -2630,12 +2416,7 @@ static struct ir_scancode ir_codes_powercolor_real_angel[] = {
 	{ 0x14, KEY_RADIO },		/* FM radio */
 	{ 0x25, KEY_POWER },		/* power */
 };
-
-struct ir_scancode_table ir_codes_powercolor_real_angel_table = {
-	.scan = ir_codes_powercolor_real_angel,
-	.size = ARRAY_SIZE(ir_codes_powercolor_real_angel),
-};
-EXPORT_SYMBOL_GPL(ir_codes_powercolor_real_angel_table);
+IR_TABLE(powercolor_real_angel, IR_TYPE_UNKNOWN, ir_codes_powercolor_real_angel);
 
 /* Kworld Plus TV Analog Lite PCI IR
    Mauro Carvalho Chehab <mchehab@infradead.org>
@@ -2696,11 +2477,7 @@ static struct ir_scancode ir_codes_kworld_plus_tv_analog[] = {
 	{ 0x18, KEY_RED},		/* B */
 	{ 0x23, KEY_GREEN},		/* C */
 };
-struct ir_scancode_table ir_codes_kworld_plus_tv_analog_table = {
-	.scan = ir_codes_kworld_plus_tv_analog,
-	.size = ARRAY_SIZE(ir_codes_kworld_plus_tv_analog),
-};
-EXPORT_SYMBOL_GPL(ir_codes_kworld_plus_tv_analog_table);
+IR_TABLE(kworld_plus_tv_analog, IR_TYPE_UNKNOWN, ir_codes_kworld_plus_tv_analog);
 
 /* Kaiomy TVnPC U2
    Mauro Carvalho Chehab <mchehab@infradead.org>
@@ -2749,11 +2526,7 @@ static struct ir_scancode ir_codes_kaiomy[] = {
 	{ 0x1e, KEY_YELLOW},
 	{ 0x1f, KEY_BLUE},
 };
-struct ir_scancode_table ir_codes_kaiomy_table = {
-	.scan = ir_codes_kaiomy,
-	.size = ARRAY_SIZE(ir_codes_kaiomy),
-};
-EXPORT_SYMBOL_GPL(ir_codes_kaiomy_table);
+IR_TABLE(kaiomy, IR_TYPE_UNKNOWN, ir_codes_kaiomy);
 
 static struct ir_scancode ir_codes_avermedia_a16d[] = {
 	{ 0x20, KEY_LIST},
@@ -2791,11 +2564,7 @@ static struct ir_scancode ir_codes_avermedia_a16d[] = {
 	{ 0x08, KEY_EPG},
 	{ 0x2a, KEY_MENU},
 };
-struct ir_scancode_table ir_codes_avermedia_a16d_table = {
-	.scan = ir_codes_avermedia_a16d,
-	.size = ARRAY_SIZE(ir_codes_avermedia_a16d),
-};
-EXPORT_SYMBOL_GPL(ir_codes_avermedia_a16d_table);
+IR_TABLE(avermedia_a16d, IR_TYPE_UNKNOWN, ir_codes_avermedia_a16d);
 
 /* Encore ENLTV-FM v5.3
    Mauro Carvalho Chehab <mchehab@infradead.org>
@@ -2838,11 +2607,7 @@ static struct ir_scancode ir_codes_encore_enltv_fm53[] = {
 	{ 0x0c, KEY_ZOOM},		/* hide pannel */
 	{ 0x47, KEY_SLEEP},		/* shutdown */
 };
-struct ir_scancode_table ir_codes_encore_enltv_fm53_table = {
-	.scan = ir_codes_encore_enltv_fm53,
-	.size = ARRAY_SIZE(ir_codes_encore_enltv_fm53),
-};
-EXPORT_SYMBOL_GPL(ir_codes_encore_enltv_fm53_table);
+IR_TABLE(encore_enltv_fm53, IR_TYPE_UNKNOWN, ir_codes_encore_enltv_fm53);
 
 /* Zogis Real Audio 220 - 32 keys IR */
 static struct ir_scancode ir_codes_real_audio_220_32_keys[] = {
@@ -2882,11 +2647,7 @@ static struct ir_scancode ir_codes_real_audio_220_32_keys[] = {
 	{ 0x19, KEY_CAMERA},		/* Snapshot */
 
 };
-struct ir_scancode_table ir_codes_real_audio_220_32_keys_table = {
-	.scan = ir_codes_real_audio_220_32_keys,
-	.size = ARRAY_SIZE(ir_codes_real_audio_220_32_keys),
-};
-EXPORT_SYMBOL_GPL(ir_codes_real_audio_220_32_keys_table);
+IR_TABLE(real_audio_220_32_keys, IR_TYPE_UNKNOWN, ir_codes_real_audio_220_32_keys);
 
 /* ATI TV Wonder HD 600 USB
    Devin Heitmueller <devin.heitmueller@gmail.com>
@@ -2917,11 +2678,7 @@ static struct ir_scancode ir_codes_ati_tv_wonder_hd_600[] = {
 	{ 0x16, KEY_MUTE},
 	{ 0x17, KEY_VOLUMEDOWN},
 };
-struct ir_scancode_table ir_codes_ati_tv_wonder_hd_600_table = {
-	.scan = ir_codes_ati_tv_wonder_hd_600,
-	.size = ARRAY_SIZE(ir_codes_ati_tv_wonder_hd_600),
-};
-EXPORT_SYMBOL_GPL(ir_codes_ati_tv_wonder_hd_600_table);
+IR_TABLE(ati_tv_wonder_hd_600, IR_TYPE_UNKNOWN, ir_codes_ati_tv_wonder_hd_600);
 
 /* DVBWorld remotes
    Igor M. Liplianin <liplianin@me.by>
@@ -2959,11 +2716,7 @@ static struct ir_scancode ir_codes_dm1105_nec[] = {
 	{ 0x1e, KEY_TV},		/* tvmode */
 	{ 0x1b, KEY_B},			/* recall */
 };
-struct ir_scancode_table ir_codes_dm1105_nec_table = {
-	.scan = ir_codes_dm1105_nec,
-	.size = ARRAY_SIZE(ir_codes_dm1105_nec),
-};
-EXPORT_SYMBOL_GPL(ir_codes_dm1105_nec_table);
+IR_TABLE(dm1105_nec, IR_TYPE_UNKNOWN, ir_codes_dm1105_nec);
 
 static struct ir_scancode ir_codes_tevii_nec[] = {
 	{ 0x0a, KEY_POWER2},
@@ -3014,11 +2767,7 @@ static struct ir_scancode ir_codes_tevii_nec[] = {
 	{ 0x56, KEY_MODE},
 	{ 0x58, KEY_SWITCHVIDEOMODE},
 };
-struct ir_scancode_table ir_codes_tevii_nec_table = {
-	.scan = ir_codes_tevii_nec,
-	.size = ARRAY_SIZE(ir_codes_tevii_nec),
-};
-EXPORT_SYMBOL_GPL(ir_codes_tevii_nec_table);
+IR_TABLE(tevii_nec, IR_TYPE_UNKNOWN, ir_codes_tevii_nec);
 
 static struct ir_scancode ir_codes_tbs_nec[] = {
 	{ 0x04, KEY_POWER2},	/*power*/
@@ -3054,11 +2803,7 @@ static struct ir_scancode ir_codes_tbs_nec[] = {
 	{ 0x00, KEY_PREVIOUS},
 	{ 0x1b, KEY_MODE},
 };
-struct ir_scancode_table ir_codes_tbs_nec_table = {
-	.scan = ir_codes_tbs_nec,
-	.size = ARRAY_SIZE(ir_codes_tbs_nec),
-};
-EXPORT_SYMBOL_GPL(ir_codes_tbs_nec_table);
+IR_TABLE(tbs_nec, IR_TYPE_UNKNOWN, ir_codes_tbs_nec);
 
 /* Terratec Cinergy Hybrid T USB XS
    Devin Heitmueller <dheitmueller@linuxtv.org>
@@ -3112,11 +2857,7 @@ static struct ir_scancode ir_codes_terratec_cinergy_xs[] = {
 	{ 0x4f, KEY_FASTFORWARD},
 	{ 0x5c, KEY_NEXT},
 };
-struct ir_scancode_table ir_codes_terratec_cinergy_xs_table = {
-	.scan = ir_codes_terratec_cinergy_xs,
-	.size = ARRAY_SIZE(ir_codes_terratec_cinergy_xs),
-};
-EXPORT_SYMBOL_GPL(ir_codes_terratec_cinergy_xs_table);
+IR_TABLE(terratec_cinergy_xs, IR_TYPE_UNKNOWN, ir_codes_terratec_cinergy_xs);
 
 /* EVGA inDtube
    Devin Heitmueller <devin.heitmueller@gmail.com>
@@ -3139,11 +2880,7 @@ static struct ir_scancode ir_codes_evga_indtube[] = {
 	{ 0x1f, KEY_NEXT},
 	{ 0x13, KEY_CAMERA},
 };
-struct ir_scancode_table ir_codes_evga_indtube_table = {
-	.scan = ir_codes_evga_indtube,
-	.size = ARRAY_SIZE(ir_codes_evga_indtube),
-};
-EXPORT_SYMBOL_GPL(ir_codes_evga_indtube_table);
+IR_TABLE(evga_indtube, IR_TYPE_UNKNOWN, ir_codes_evga_indtube);
 
 static struct ir_scancode ir_codes_videomate_s350[] = {
 	{ 0x00, KEY_TV},
@@ -3191,11 +2928,7 @@ static struct ir_scancode ir_codes_videomate_s350[] = {
 	{ 0x11, KEY_ENTER},
 	{ 0x20, KEY_TEXT},
 };
-struct ir_scancode_table ir_codes_videomate_s350_table = {
-	.scan = ir_codes_videomate_s350,
-	.size = ARRAY_SIZE(ir_codes_videomate_s350),
-};
-EXPORT_SYMBOL_GPL(ir_codes_videomate_s350_table);
+IR_TABLE(videomate_s350, IR_TYPE_UNKNOWN, ir_codes_videomate_s350);
 
 /* GADMEI UTV330+ RM008Z remote
    Shine Liu <shinel@foxmail.com>
@@ -3238,11 +2971,7 @@ static struct ir_scancode ir_codes_gadmei_rm008z[] = {
 	{ 0x13, KEY_CHANNELDOWN},	/* CHANNELDOWN */
 	{ 0x15, KEY_ENTER},		/* OK */
 };
-struct ir_scancode_table ir_codes_gadmei_rm008z_table = {
-	.scan = ir_codes_gadmei_rm008z,
-	.size = ARRAY_SIZE(ir_codes_gadmei_rm008z),
-};
-EXPORT_SYMBOL_GPL(ir_codes_gadmei_rm008z_table);
+IR_TABLE(gadmei_rm008z, IR_TYPE_UNKNOWN, ir_codes_gadmei_rm008z);
 
 /*************************************************************
  *		COMPLETE SCANCODE TABLES
@@ -3313,13 +3042,7 @@ static struct ir_scancode ir_codes_rc5_hauppauge_new[] = {
 	{ 0x1e3c, KEY_ZOOM },		/* full */
 	{ 0x1e3d, KEY_POWER },		/* system power (green button) */
 };
-
-struct ir_scancode_table ir_codes_rc5_hauppauge_new_table = {
-	.scan = ir_codes_rc5_hauppauge_new,
-	.size = ARRAY_SIZE(ir_codes_rc5_hauppauge_new),
-	.ir_type = IR_TYPE_RC5,
-};
-EXPORT_SYMBOL_GPL(ir_codes_rc5_hauppauge_new_table);
+IR_TABLE(rc5_hauppauge_new, IR_TYPE_RC5, ir_codes_rc5_hauppauge_new);
 
 /* Terratec Cinergy Hybrid T USB XS FM
    Mauro Carvalho Chehab <mchehab@redhat.com>
@@ -3386,13 +3109,7 @@ static struct ir_scancode ir_codes_nec_terratec_cinergy_xs[] = {
 	{ 0x144f, KEY_FASTFORWARD},
 	{ 0x145c, KEY_NEXT},
 };
-struct ir_scancode_table ir_codes_nec_terratec_cinergy_xs_table = {
-	.scan = ir_codes_nec_terratec_cinergy_xs,
-	.size = ARRAY_SIZE(ir_codes_nec_terratec_cinergy_xs),
-	.ir_type = IR_TYPE_NEC,
-};
-EXPORT_SYMBOL_GPL(ir_codes_nec_terratec_cinergy_xs_table);
-
+IR_TABLE(nec_terratec_cinergy_xs, IR_TYPE_NEC, ir_codes_nec_terratec_cinergy_xs);
 
 /* Leadtek Winfast TV USB II Deluxe remote
    Magnus Alm <magnus.alm@gmail.com>
@@ -3436,11 +3153,7 @@ static struct ir_scancode ir_codes_winfast_usbii_deluxe[] = {
 	{ 0x63, KEY_ENTER},		/* ENTER */
 
 };
-struct ir_scancode_table ir_codes_winfast_usbii_deluxe_table = {
-	.scan = ir_codes_winfast_usbii_deluxe,
-	.size = ARRAY_SIZE(ir_codes_winfast_usbii_deluxe),
-};
-EXPORT_SYMBOL_GPL(ir_codes_winfast_usbii_deluxe_table);
+IR_TABLE(winfast_usbii_deluxe, IR_TYPE_UNKNOWN, ir_codes_winfast_usbii_deluxe);
 
 /* Kworld 315U
  */
@@ -3485,10 +3198,4 @@ static struct ir_scancode ir_codes_kworld_315u[] = {
 	{ 0x611e, KEY_YELLOW },
 	{ 0x611f, KEY_BLUE },
 };
-
-struct ir_scancode_table ir_codes_kworld_315u_table = {
-	.scan = ir_codes_kworld_315u,
-	.size = ARRAY_SIZE(ir_codes_kworld_315u),
-	.ir_type = IR_TYPE_NEC,
-};
-EXPORT_SYMBOL_GPL(ir_codes_kworld_315u_table);
+IR_TABLE(kworld_315u, IR_TYPE_NEC, ir_codes_kworld_315u);
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index ce9f347..9ab8a77 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -35,7 +35,8 @@ struct ir_scancode {
 struct ir_scancode_table {
 	struct ir_scancode	*scan;
 	int			size;
-	u64		ir_type;
+	u64			ir_type;
+	char			*name;
 	spinlock_t		lock;
 };
 
-- 
1.6.6.1


