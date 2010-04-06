Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab0DFSSR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:17 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIG0E013548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:16 -0400
Date: Tue, 6 Apr 2010 15:18:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/26] V4L/DVB: ir-common: Use macros to define the
 keytables
Message-ID: <20100406151803.257e90e2@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The usage of macros ensures that the proper namespace is being used
by all tables. It also makes easier to associate a keytable with
the name used inside the drivers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keymaps.c b/drivers/media/IR/ir-keymaps.c
index 55e7acd..1ba9285 100644
--- a/drivers/media/IR/ir-keymaps.c
+++ b/drivers/media/IR/ir-keymaps.c
@@ -35,24 +35,15 @@
  * to define the proper IR_TYPE (IR_TYPE_RC5/IR_TYPE_NEC).
  * The deprecated tables should use IR_TYPE_UNKNOWN
  */
-#define IR_TABLE(irname, type, tabname)				\
-struct ir_scancode_table tabname ## _table = {			\
-	.scan = tabname,					\
-	.size = ARRAY_SIZE(tabname),				\
-	.ir_type = type,					\
-	.name = #irname,					\
-};								\
-EXPORT_SYMBOL_GPL(tabname ## _table)
-
 
 /* empty keytable, can be used as placeholder for not-yet created keytables */
-static struct ir_scancode ir_codes_empty[] = {
+static struct ir_scancode empty[] = {
 	{ 0x2a, KEY_COFFEE },
 };
-IR_TABLE(empty, IR_TYPE_UNKNOWN, ir_codes_empty);
+DEFINE_LEGACY_IR_KEYTABLE(empty);
 
 /* Michal Majchrowicz <mmajchrowicz@gmail.com> */
-static struct ir_scancode ir_codes_proteus_2309[] = {
+static struct ir_scancode proteus_2309[] = {
 	/* numeric */
 	{ 0x00, KEY_0 },
 	{ 0x01, KEY_1 },
@@ -80,10 +71,10 @@ static struct ir_scancode ir_codes_proteus_2309[] = {
 	{ 0x1e, KEY_VOLUMEUP },		/* volume +    */
 	{ 0x14, KEY_F1 },
 };
-IR_TABLE(proteus_2309, IR_TYPE_UNKNOWN, ir_codes_proteus_2309);
+DEFINE_LEGACY_IR_KEYTABLE(proteus_2309);
 
 /* Matt Jesson <dvb@jesson.eclipse.co.uk */
-static struct ir_scancode ir_codes_avermedia_dvbt[] = {
+static struct ir_scancode avermedia_dvbt[] = {
 	{ 0x28, KEY_0 },		/* '0' / 'enter' */
 	{ 0x22, KEY_1 },		/* '1' */
 	{ 0x12, KEY_2 },		/* '2' / 'up arrow' */
@@ -120,14 +111,14 @@ static struct ir_scancode ir_codes_avermedia_dvbt[] = {
 	{ 0x1e, KEY_VOLUMEDOWN },	/* 'volume -' */
 	{ 0x3e, KEY_VOLUMEUP },		/* 'volume +' */
 };
-IR_TABLE(avermedia_dvbt, IR_TYPE_UNKNOWN, ir_codes_avermedia_dvbt);
+DEFINE_LEGACY_IR_KEYTABLE(avermedia_dvbt);
 
 /*
  * Avermedia M135A with IR model RM-JX
  * The same codes exist on both Positivo (BR) and original IR
  * Mauro Carvalho Chehab <mchehab@infradead.org>
  */
-static struct ir_scancode ir_codes_avermedia_m135a_rm_jx[] = {
+static struct ir_scancode avermedia_m135a_rm_jx[] = {
 	{ 0x0200, KEY_POWER2 },
 	{ 0x022e, KEY_DOT },		/* '.' */
 	{ 0x0201, KEY_MODE },		/* TV/FM or SOURCE */
@@ -172,10 +163,10 @@ static struct ir_scancode ir_codes_avermedia_m135a_rm_jx[] = {
 	{ 0x0218, KEY_PLAY },
 	{ 0x021b, KEY_STOP },
 };
-IR_TABLE(aver-m135a-RM-JX, IR_TYPE_NEC, ir_codes_avermedia_m135a_rm_jx);
+DEFINE_IR_KEYTABLE(avermedia_m135a_rm_jx, IR_TYPE_NEC);
 
 /* Oldrich Jedlicka <oldium.pro@seznam.cz> */
-static struct ir_scancode ir_codes_avermedia_cardbus[] = {
+static struct ir_scancode avermedia_cardbus[] = {
 	{ 0x00, KEY_POWER },
 	{ 0x01, KEY_TUNER },		/* TV/FM */
 	{ 0x03, KEY_TEXT },		/* Teletext */
@@ -231,10 +222,10 @@ static struct ir_scancode ir_codes_avermedia_cardbus[] = {
 	{ 0x42, KEY_CHANNELDOWN },	/* Channel down */
 	{ 0x43, KEY_CHANNELUP },	/* Channel up */
 };
-IR_TABLE(avermedia_cardbus, IR_TYPE_UNKNOWN, ir_codes_avermedia_cardbus);
+DEFINE_LEGACY_IR_KEYTABLE(avermedia_cardbus);
 
 /* Attila Kondoros <attila.kondoros@chello.hu> */
-static struct ir_scancode ir_codes_apac_viewcomp[] = {
+static struct ir_scancode apac_viewcomp[] = {
 
 	{ 0x01, KEY_1 },
 	{ 0x02, KEY_2 },
@@ -273,11 +264,11 @@ static struct ir_scancode ir_codes_apac_viewcomp[] = {
 	{ 0x0c, KEY_KPPLUS },		/* fine tune >>>> */
 	{ 0x18, KEY_KPMINUS },		/* fine tune <<<< */
 };
-IR_TABLE(apac_viewcomp, IR_TYPE_UNKNOWN, ir_codes_apac_viewcomp);
+DEFINE_LEGACY_IR_KEYTABLE(apac_viewcomp);
 
 /* ---------------------------------------------------------------------- */
 
-static struct ir_scancode ir_codes_pixelview[] = {
+static struct ir_scancode pixelview[] = {
 
 	{ 0x1e, KEY_POWER },	/* power */
 	{ 0x07, KEY_MEDIA },	/* source */
@@ -320,13 +311,13 @@ static struct ir_scancode ir_codes_pixelview[] = {
 	{ 0x1d, KEY_REFRESH },		/* reset */
 	{ 0x18, KEY_MUTE },		/* mute/unmute */
 };
-IR_TABLE(pixelview, IR_TYPE_UNKNOWN, ir_codes_pixelview);
+DEFINE_LEGACY_IR_KEYTABLE(pixelview);
 
 /*
    Mauro Carvalho Chehab <mchehab@infradead.org>
    present on PV MPEG 8000GT
  */
-static struct ir_scancode ir_codes_pixelview_new[] = {
+static struct ir_scancode pixelview_new[] = {
 	{ 0x3c, KEY_TIME },		/* Timeshift */
 	{ 0x12, KEY_POWER },
 
@@ -365,9 +356,9 @@ static struct ir_scancode ir_codes_pixelview_new[] = {
 	{ 0x31, KEY_TV },
 	{ 0x34, KEY_RADIO },
 };
-IR_TABLE(pixelview_new, IR_TYPE_UNKNOWN, ir_codes_pixelview_new);
+DEFINE_LEGACY_IR_KEYTABLE(pixelview_new);
 
-static struct ir_scancode ir_codes_nebula[] = {
+static struct ir_scancode nebula[] = {
 	{ 0x00, KEY_0 },
 	{ 0x01, KEY_1 },
 	{ 0x02, KEY_2 },
@@ -424,10 +415,10 @@ static struct ir_scancode ir_codes_nebula[] = {
 	{ 0x35, KEY_PHONE },
 	{ 0x36, KEY_PC },
 };
-IR_TABLE(nebula, IR_TYPE_UNKNOWN, ir_codes_nebula);
+DEFINE_LEGACY_IR_KEYTABLE(nebula);
 
 /* DigitalNow DNTV Live DVB-T Remote */
-static struct ir_scancode ir_codes_dntv_live_dvb_t[] = {
+static struct ir_scancode dntv_live_dvb_t[] = {
 	{ 0x00, KEY_ESC },		/* 'go up a level?' */
 	/* Keys 0 to 9 */
 	{ 0x0a, KEY_0 },
@@ -464,12 +455,12 @@ static struct ir_scancode ir_codes_dntv_live_dvb_t[] = {
 	{ 0x1e, KEY_CHANNELDOWN },
 	{ 0x1f, KEY_VOLUMEDOWN },
 };
-IR_TABLE(dntv_live_dvb_t, IR_TYPE_UNKNOWN, ir_codes_dntv_live_dvb_t);
+DEFINE_LEGACY_IR_KEYTABLE(dntv_live_dvb_t);
 
 /* ---------------------------------------------------------------------- */
 
 /* IO-DATA BCTV7E Remote */
-static struct ir_scancode ir_codes_iodata_bctv7e[] = {
+static struct ir_scancode iodata_bctv7e[] = {
 	{ 0x40, KEY_TV },
 	{ 0x20, KEY_RADIO },		/* FM */
 	{ 0x60, KEY_EPG },
@@ -516,12 +507,12 @@ static struct ir_scancode ir_codes_iodata_bctv7e[] = {
 	{ 0x61, KEY_FASTFORWARD },	/* forward >> */
 	{ 0x01, KEY_NEXT },		/* skip >| */
 };
-IR_TABLE(iodata_bctv7e, IR_TYPE_UNKNOWN, ir_codes_iodata_bctv7e);
+DEFINE_LEGACY_IR_KEYTABLE(iodata_bctv7e);
 
 /* ---------------------------------------------------------------------- */
 
 /* ADS Tech Instant TV DVB-T PCI Remote */
-static struct ir_scancode ir_codes_adstech_dvb_t_pci[] = {
+static struct ir_scancode adstech_dvb_t_pci[] = {
 	/* Keys 0 to 9 */
 	{ 0x4d, KEY_0 },
 	{ 0x57, KEY_1 },
@@ -569,13 +560,13 @@ static struct ir_scancode ir_codes_adstech_dvb_t_pci[] = {
 	{ 0x15, KEY_VOLUMEUP },
 	{ 0x1c, KEY_VOLUMEDOWN },
 };
-IR_TABLE(adstech_dvb_t_pci, IR_TYPE_UNKNOWN, ir_codes_adstech_dvb_t_pci);
+DEFINE_LEGACY_IR_KEYTABLE(adstech_dvb_t_pci);
 
 /* ---------------------------------------------------------------------- */
 
 /* MSI TV@nywhere MASTER remote */
 
-static struct ir_scancode ir_codes_msi_tvanywhere[] = {
+static struct ir_scancode msi_tvanywhere[] = {
 	/* Keys 0 to 9 */
 	{ 0x00, KEY_0 },
 	{ 0x01, KEY_1 },
@@ -603,7 +594,7 @@ static struct ir_scancode ir_codes_msi_tvanywhere[] = {
 	{ 0x1e, KEY_CHANNELDOWN },
 	{ 0x1f, KEY_VOLUMEDOWN },
 };
-IR_TABLE(msi_tvanywhere, IR_TYPE_UNKNOWN, ir_codes_msi_tvanywhere);
+DEFINE_LEGACY_IR_KEYTABLE(msi_tvanywhere);
 
 /* ---------------------------------------------------------------------- */
 
@@ -622,7 +613,7 @@ IR_TABLE(msi_tvanywhere, IR_TYPE_UNKNOWN, ir_codes_msi_tvanywhere);
 
 */
 
-static struct ir_scancode ir_codes_msi_tvanywhere_plus[] = {
+static struct ir_scancode msi_tvanywhere_plus[] = {
 
 /*  ---- Remote Button Layout ----
 
@@ -692,12 +683,12 @@ static struct ir_scancode ir_codes_msi_tvanywhere_plus[] = {
 	{ 0x0c, KEY_FASTFORWARD },	/* >> */
 	{ 0x1d, KEY_RESTART },		/* Reset */
 };
-IR_TABLE(msi_tvanywhere_plus, IR_TYPE_UNKNOWN, ir_codes_msi_tvanywhere_plus);
+DEFINE_LEGACY_IR_KEYTABLE(msi_tvanywhere_plus);
 
 /* ---------------------------------------------------------------------- */
 
 /* Cinergy 1400 DVB-T */
-static struct ir_scancode ir_codes_cinergy_1400[] = {
+static struct ir_scancode cinergy_1400[] = {
 	{ 0x01, KEY_POWER },
 	{ 0x02, KEY_1 },
 	{ 0x03, KEY_2 },
@@ -740,12 +731,12 @@ static struct ir_scancode ir_codes_cinergy_1400[] = {
 	{ 0x48, KEY_STOP },
 	{ 0x5c, KEY_NEXT },
 };
-IR_TABLE(cinergy_1400, IR_TYPE_UNKNOWN, ir_codes_cinergy_1400);
+DEFINE_LEGACY_IR_KEYTABLE(cinergy_1400);
 
 /* ---------------------------------------------------------------------- */
 
 /* AVERTV STUDIO 303 Remote */
-static struct ir_scancode ir_codes_avertv_303[] = {
+static struct ir_scancode avertv_303[] = {
 	{ 0x2a, KEY_1 },
 	{ 0x32, KEY_2 },
 	{ 0x3a, KEY_3 },
@@ -789,12 +780,12 @@ static struct ir_scancode ir_codes_avertv_303[] = {
 	{ 0x13, KEY_DOWN },
 	{ 0x1b, KEY_UP },
 };
-IR_TABLE(avertv_303, IR_TYPE_UNKNOWN, ir_codes_avertv_303);
+DEFINE_LEGACY_IR_KEYTABLE(avertv_303);
 
 /* ---------------------------------------------------------------------- */
 
 /* DigitalNow DNTV Live! DVB-T Pro Remote */
-static struct ir_scancode ir_codes_dntv_live_dvbt_pro[] = {
+static struct ir_scancode dntv_live_dvbt_pro[] = {
 	{ 0x16, KEY_POWER },
 	{ 0x5b, KEY_HOME },
 
@@ -850,9 +841,9 @@ static struct ir_scancode ir_codes_dntv_live_dvbt_pro[] = {
 	{ 0x5c, KEY_YELLOW },
 	{ 0x5d, KEY_BLUE },
 };
-IR_TABLE(dntv_live_dvbt_pro, IR_TYPE_UNKNOWN, ir_codes_dntv_live_dvbt_pro);
+DEFINE_LEGACY_IR_KEYTABLE(dntv_live_dvbt_pro);
 
-static struct ir_scancode ir_codes_em_terratec[] = {
+static struct ir_scancode em_terratec[] = {
 	{ 0x01, KEY_CHANNEL },
 	{ 0x02, KEY_SELECT },
 	{ 0x03, KEY_MUTE },
@@ -882,9 +873,9 @@ static struct ir_scancode ir_codes_em_terratec[] = {
 	{ 0x1e, KEY_STOP },
 	{ 0x40, KEY_ZOOM },
 };
-IR_TABLE(em_terratec, IR_TYPE_UNKNOWN, ir_codes_em_terratec);
+DEFINE_LEGACY_IR_KEYTABLE(em_terratec);
 
-static struct ir_scancode ir_codes_pinnacle_grey[] = {
+static struct ir_scancode pinnacle_grey[] = {
 	{ 0x3a, KEY_0 },
 	{ 0x31, KEY_1 },
 	{ 0x32, KEY_2 },
@@ -934,9 +925,9 @@ static struct ir_scancode ir_codes_pinnacle_grey[] = {
 	{ 0x2a, KEY_MEDIA },
 	{ 0x18, KEY_EPG },
 };
-IR_TABLE(pinnacle_grey, IR_TYPE_UNKNOWN, ir_codes_pinnacle_grey);
+DEFINE_LEGACY_IR_KEYTABLE(pinnacle_grey);
 
-static struct ir_scancode ir_codes_flyvideo[] = {
+static struct ir_scancode flyvideo[] = {
 	{ 0x0f, KEY_0 },
 	{ 0x03, KEY_1 },
 	{ 0x04, KEY_2 },
@@ -967,9 +958,9 @@ static struct ir_scancode ir_codes_flyvideo[] = {
 	{ 0x1f, KEY_FORWARD },	/* Forward ( >>> ) */
 	{ 0x0a, KEY_ANGLE },	/* no label, may be used as the PAUSE button */
 };
-IR_TABLE(flyvideo, IR_TYPE_UNKNOWN, ir_codes_flyvideo);
+DEFINE_LEGACY_IR_KEYTABLE(flyvideo);
 
-static struct ir_scancode ir_codes_flydvb[] = {
+static struct ir_scancode flydvb[] = {
 	{ 0x01, KEY_ZOOM },		/* Full Screen */
 	{ 0x00, KEY_POWER },		/* Power */
 
@@ -1007,9 +998,9 @@ static struct ir_scancode ir_codes_flydvb[] = {
 	{ 0x11, KEY_STOP },		/* Stop */
 	{ 0x0e, KEY_NEXT },		/* End >>| */
 };
-IR_TABLE(flydvb, IR_TYPE_UNKNOWN, ir_codes_flydvb);
+DEFINE_LEGACY_IR_KEYTABLE(flydvb);
 
-static struct ir_scancode ir_codes_cinergy[] = {
+static struct ir_scancode cinergy[] = {
 	{ 0x00, KEY_0 },
 	{ 0x01, KEY_1 },
 	{ 0x02, KEY_2 },
@@ -1048,11 +1039,11 @@ static struct ir_scancode ir_codes_cinergy[] = {
 	{ 0x22, KEY_PAUSE },
 	{ 0x23, KEY_STOP },
 };
-IR_TABLE(cinergy, IR_TYPE_UNKNOWN, ir_codes_cinergy);
+DEFINE_LEGACY_IR_KEYTABLE(cinergy);
 
 /* Alfons Geser <a.geser@cox.net>
  * updates from Job D. R. Borges <jobdrb@ig.com.br> */
-static struct ir_scancode ir_codes_eztv[] = {
+static struct ir_scancode eztv[] = {
 	{ 0x12, KEY_POWER },
 	{ 0x01, KEY_TV },	/* DVR */
 	{ 0x15, KEY_DVD },	/* DVD */
@@ -1106,10 +1097,10 @@ static struct ir_scancode ir_codes_eztv[] = {
 	{ 0x13, KEY_ENTER },	/* enter */
 	{ 0x21, KEY_DOT },	/* . (decimal dot) */
 };
-IR_TABLE(eztv, IR_TYPE_UNKNOWN, ir_codes_eztv);
+DEFINE_LEGACY_IR_KEYTABLE(eztv);
 
 /* Alex Hermann <gaaf@gmx.net> */
-static struct ir_scancode ir_codes_avermedia[] = {
+static struct ir_scancode avermedia[] = {
 	{ 0x28, KEY_1 },
 	{ 0x18, KEY_2 },
 	{ 0x38, KEY_3 },
@@ -1154,9 +1145,9 @@ static struct ir_scancode ir_codes_avermedia[] = {
 	{ 0x11, KEY_CHANNELDOWN },	/* CHANNEL/PAGE- */
 	{ 0x31, KEY_CHANNELUP }		/* CHANNEL/PAGE+ */
 };
-IR_TABLE(avermedia, IR_TYPE_UNKNOWN, ir_codes_avermedia);
+DEFINE_LEGACY_IR_KEYTABLE(avermedia);
 
-static struct ir_scancode ir_codes_videomate_tv_pvr[] = {
+static struct ir_scancode videomate_tv_pvr[] = {
 	{ 0x14, KEY_MUTE },
 	{ 0x24, KEY_ZOOM },
 
@@ -1204,7 +1195,7 @@ static struct ir_scancode ir_codes_videomate_tv_pvr[] = {
 	{ 0x20, KEY_LANGUAGE },
 	{ 0x21, KEY_SLEEP },
 };
-IR_TABLE(videomate_tv_pvr, IR_TYPE_UNKNOWN, ir_codes_videomate_tv_pvr);
+DEFINE_LEGACY_IR_KEYTABLE(videomate_tv_pvr);
 
 /* Michael Tokarev <mjt@tls.msk.ru>
    http://www.corpit.ru/mjt/beholdTV/remote_control.jpg
@@ -1215,7 +1206,7 @@ IR_TABLE(videomate_tv_pvr, IR_TYPE_UNKNOWN, ir_codes_videomate_tv_pvr);
    the button labels (several variants when appropriate)
    helps to descide which keycodes to assign to the buttons.
  */
-static struct ir_scancode ir_codes_manli[] = {
+static struct ir_scancode manli[] = {
 
 	/*  0x1c            0x12  *
 	 * FUNCTION         POWER *
@@ -1301,10 +1292,10 @@ static struct ir_scancode ir_codes_manli[] = {
 
 	/* 0x1d unused ? */
 };
-IR_TABLE(manli, IR_TYPE_UNKNOWN, ir_codes_manli);
+DEFINE_LEGACY_IR_KEYTABLE(manli);
 
 /* Mike Baikov <mike@baikov.com> */
-static struct ir_scancode ir_codes_gotview7135[] = {
+static struct ir_scancode gotview7135[] = {
 
 	{ 0x11, KEY_POWER },
 	{ 0x35, KEY_TV },
@@ -1342,9 +1333,9 @@ static struct ir_scancode ir_codes_gotview7135[] = {
 	{ 0x1e, KEY_TIME },	/* TIMESHIFT */
 	{ 0x38, KEY_F24 },	/* NORMAL TIMESHIFT */
 };
-IR_TABLE(gotview7135, IR_TYPE_UNKNOWN, ir_codes_gotview7135);
+DEFINE_LEGACY_IR_KEYTABLE(gotview7135);
 
-static struct ir_scancode ir_codes_purpletv[] = {
+static struct ir_scancode purpletv[] = {
 	{ 0x03, KEY_POWER },
 	{ 0x6f, KEY_MUTE },
 	{ 0x10, KEY_BACKSPACE },	/* Recall */
@@ -1386,13 +1377,13 @@ static struct ir_scancode ir_codes_purpletv[] = {
 	{ 0x42, KEY_REWIND },	/* Backward ? */
 
 };
-IR_TABLE(purpletv, IR_TYPE_UNKNOWN, ir_codes_purpletv);
+DEFINE_LEGACY_IR_KEYTABLE(purpletv);
 
 /* Mapping for the 28 key remote control as seen at
    http://www.sednacomputer.com/photo/cardbus-tv.jpg
    Pavel Mihaylov <bin@bash.info>
    Also for the remote bundled with Kozumi KTV-01C card */
-static struct ir_scancode ir_codes_pctv_sedna[] = {
+static struct ir_scancode pctv_sedna[] = {
 	{ 0x00, KEY_0 },
 	{ 0x01, KEY_1 },
 	{ 0x02, KEY_2 },
@@ -1428,10 +1419,10 @@ static struct ir_scancode ir_codes_pctv_sedna[] = {
 	{ 0x17, KEY_DIGITS },	/* Plus */
 	{ 0x1f, KEY_PLAY },	/* Play */
 };
-IR_TABLE(pctv_sedna, IR_TYPE_UNKNOWN, ir_codes_pctv_sedna);
+DEFINE_LEGACY_IR_KEYTABLE(pctv_sedna);
 
 /* Mark Phalan <phalanm@o2.ie> */
-static struct ir_scancode ir_codes_pv951[] = {
+static struct ir_scancode pv951[] = {
 	{ 0x00, KEY_0 },
 	{ 0x01, KEY_1 },
 	{ 0x02, KEY_2 },
@@ -1468,12 +1459,12 @@ static struct ir_scancode ir_codes_pv951[] = {
 	{ 0x14, KEY_EQUAL },		/* SYNC */
 	{ 0x1c, KEY_MEDIA },		/* PC/TV */
 };
-IR_TABLE(pv951, IR_TYPE_UNKNOWN, ir_codes_pv951);
+DEFINE_LEGACY_IR_KEYTABLE(pv951);
 
 /* generic RC5 keytable                                          */
 /* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
 /* used by old (black) Hauppauge remotes                         */
-static struct ir_scancode ir_codes_rc5_tv[] = {
+static struct ir_scancode rc5_tv[] = {
 	/* Keys 0 to 9 */
 	{ 0x00, KEY_0 },
 	{ 0x01, KEY_1 },
@@ -1511,10 +1502,10 @@ static struct ir_scancode ir_codes_rc5_tv[] = {
 	{ 0x3d, KEY_SUSPEND },		/* system standby */
 
 };
-IR_TABLE(rc5_tv, IR_TYPE_UNKNOWN, ir_codes_rc5_tv);
+DEFINE_LEGACY_IR_KEYTABLE(rc5_tv);
 
 /* Table for Leadtek Winfast Remote Controls - used by both bttv and cx88 */
-static struct ir_scancode ir_codes_winfast[] = {
+static struct ir_scancode winfast[] = {
 	/* Keys 0 to 9 */
 	{ 0x12, KEY_0 },
 	{ 0x05, KEY_1 },
@@ -1575,9 +1566,9 @@ static struct ir_scancode ir_codes_winfast[] = {
 	{ 0x3b, KEY_F23 },		/* MCE +CH,  on Y04G0033 */
 	{ 0x3f, KEY_F24 }		/* MCE -CH,  on Y04G0033 */
 };
-IR_TABLE(winfast, IR_TYPE_UNKNOWN, ir_codes_winfast);
+DEFINE_LEGACY_IR_KEYTABLE(winfast);
 
-static struct ir_scancode ir_codes_pinnacle_color[] = {
+static struct ir_scancode pinnacle_color[] = {
 	{ 0x59, KEY_MUTE },
 	{ 0x4a, KEY_POWER },
 
@@ -1632,12 +1623,12 @@ static struct ir_scancode ir_codes_pinnacle_color[] = {
 	{ 0x74, KEY_CHANNEL },
 	{ 0x0a, KEY_BACKSPACE },
 };
-IR_TABLE(pinnacle_color, IR_TYPE_UNKNOWN, ir_codes_pinnacle_color);
+DEFINE_LEGACY_IR_KEYTABLE(pinnacle_color);
 
 /* Hauppauge: the newer, gray remotes (seems there are multiple
  * slightly different versions), shipped with cx88+ivtv cards.
  * almost rc5 coding, but some non-standard keys */
-static struct ir_scancode ir_codes_hauppauge_new[] = {
+static struct ir_scancode hauppauge_new[] = {
 	/* Keys 0 to 9 */
 	{ 0x00, KEY_0 },
 	{ 0x01, KEY_1 },
@@ -1694,9 +1685,9 @@ static struct ir_scancode ir_codes_hauppauge_new[] = {
 	{ 0x3c, KEY_ZOOM },		/* full */
 	{ 0x3d, KEY_POWER },		/* system power (green button) */
 };
-IR_TABLE(hauppauge_new, IR_TYPE_UNKNOWN, ir_codes_hauppauge_new);
+DEFINE_LEGACY_IR_KEYTABLE(hauppauge_new);
 
-static struct ir_scancode ir_codes_npgtech[] = {
+static struct ir_scancode npgtech[] = {
 	{ 0x1d, KEY_SWITCHVIDEOMODE },	/* switch inputs */
 	{ 0x2a, KEY_FRONT },
 
@@ -1737,12 +1728,12 @@ static struct ir_scancode ir_codes_npgtech[] = {
 	{ 0x10, KEY_POWER },
 
 };
-IR_TABLE(npgtech, IR_TYPE_UNKNOWN, ir_codes_npgtech);
+DEFINE_LEGACY_IR_KEYTABLE(npgtech);
 
 /* Norwood Micro (non-Pro) TV Tuner
    By Peter Naulls <peter@chocky.org>
    Key comments are the functions given in the manual */
-static struct ir_scancode ir_codes_norwood[] = {
+static struct ir_scancode norwood[] = {
 	/* Keys 0 to 9 */
 	{ 0x20, KEY_0 },
 	{ 0x21, KEY_1 },
@@ -1784,14 +1775,14 @@ static struct ir_scancode ir_codes_norwood[] = {
 	{ 0x34, KEY_RADIO },		/* FM                  */
 	{ 0x65, KEY_POWER },		/* Computer power      */
 };
-IR_TABLE(norwood, IR_TYPE_UNKNOWN, ir_codes_norwood);
+DEFINE_LEGACY_IR_KEYTABLE(norwood);
 
 /* From reading the following remotes:
  * Zenith Universal 7 / TV Mode 807 / VCR Mode 837
  * Hauppauge (from NOVA-CI-s box product)
  * This is a "middle of the road" approach, differences are noted
  */
-static struct ir_scancode ir_codes_budget_ci_old[] = {
+static struct ir_scancode budget_ci_old[] = {
 	{ 0x00, KEY_0 },
 	{ 0x01, KEY_1 },
 	{ 0x02, KEY_2 },
@@ -1838,14 +1829,14 @@ static struct ir_scancode ir_codes_budget_ci_old[] = {
 	{ 0x3d, KEY_POWER2 },
 	{ 0x3e, KEY_TUNER },
 };
-IR_TABLE(budget_ci_old, IR_TYPE_UNKNOWN, ir_codes_budget_ci_old);
+DEFINE_LEGACY_IR_KEYTABLE(budget_ci_old);
 
 /*
  * Marc Fargas <telenieko@telenieko.com>
  * this is the remote control that comes with the asus p7131
  * which has a label saying is "Model PC-39"
  */
-static struct ir_scancode ir_codes_asus_pc39[] = {
+static struct ir_scancode asus_pc39[] = {
 	/* Keys 0 to 9 */
 	{ 0x15, KEY_0 },
 	{ 0x29, KEY_1 },
@@ -1891,11 +1882,11 @@ static struct ir_scancode ir_codes_asus_pc39[] = {
 	{ 0x3d, KEY_MUTE },		/* mute */
 	{ 0x01, KEY_DVD },		/* dvd */
 };
-IR_TABLE(asus_pc39, IR_TYPE_UNKNOWN, ir_codes_asus_pc39);
+DEFINE_LEGACY_IR_KEYTABLE(asus_pc39);
 
 /* Encore ENLTV-FM  - black plastic, white front cover with white glowing buttons
     Juan Pablo Sormani <sorman@gmail.com> */
-static struct ir_scancode ir_codes_encore_enltv[] = {
+static struct ir_scancode encore_enltv[] = {
 
 	/* Power button does nothing, neither in Windows app,
 	 although it sends data (used for BIOS wakeup?) */
@@ -1965,11 +1956,11 @@ static struct ir_scancode ir_codes_encore_enltv[] = {
 	{ 0x47, KEY_YELLOW },		/* AP3 */
 	{ 0x57, KEY_BLUE },		/* AP4 */
 };
-IR_TABLE(encore_enltv, IR_TYPE_UNKNOWN, ir_codes_encore_enltv);
+DEFINE_LEGACY_IR_KEYTABLE(encore_enltv);
 
 /* Encore ENLTV2-FM  - silver plastic - "Wand Media" written at the botton
     Mauro Carvalho Chehab <mchehab@infradead.org> */
-static struct ir_scancode ir_codes_encore_enltv2[] = {
+static struct ir_scancode encore_enltv2[] = {
 	{ 0x4c, KEY_POWER2 },
 	{ 0x4a, KEY_TUNER },
 	{ 0x40, KEY_1 },
@@ -2017,10 +2008,10 @@ static struct ir_scancode ir_codes_encore_enltv2[] = {
 	{ 0x7d, KEY_FORWARD },
 	{ 0x79, KEY_STOP },
 };
-IR_TABLE(encore_enltv2, IR_TYPE_UNKNOWN, ir_codes_encore_enltv2);
+DEFINE_LEGACY_IR_KEYTABLE(encore_enltv2);
 
 /* for the Technotrend 1500 bundled remotes (grey and black): */
-static struct ir_scancode ir_codes_tt_1500[] = {
+static struct ir_scancode tt_1500[] = {
 	{ 0x01, KEY_POWER },
 	{ 0x02, KEY_SHUFFLE },		/* ? double-arrow key */
 	{ 0x03, KEY_1 },
@@ -2061,10 +2052,10 @@ static struct ir_scancode ir_codes_tt_1500[] = {
 	{ 0x3e, KEY_PAUSE },
 	{ 0x3f, KEY_FORWARD },
 };
-IR_TABLE(tt_1500, IR_TYPE_UNKNOWN, ir_codes_tt_1500);
+DEFINE_LEGACY_IR_KEYTABLE(tt_1500);
 
 /* DViCO FUSION HDTV MCE remote */
-static struct ir_scancode ir_codes_fusionhdtv_mce[] = {
+static struct ir_scancode fusionhdtv_mce[] = {
 
 	{ 0x0b, KEY_1 },
 	{ 0x17, KEY_2 },
@@ -2121,10 +2112,10 @@ static struct ir_scancode ir_codes_fusionhdtv_mce[] = {
 	{ 0x01, KEY_RECORD },
 	{ 0x4e, KEY_POWER },
 };
-IR_TABLE(fusionhdtv_mce, IR_TYPE_UNKNOWN, ir_codes_fusionhdtv_mce);
+DEFINE_LEGACY_IR_KEYTABLE(fusionhdtv_mce);
 
 /* Pinnacle PCTV HD 800i mini remote */
-static struct ir_scancode ir_codes_pinnacle_pctv_hd[] = {
+static struct ir_scancode pinnacle_pctv_hd[] = {
 
 	{ 0x0f, KEY_1 },
 	{ 0x15, KEY_2 },
@@ -2156,7 +2147,7 @@ static struct ir_scancode ir_codes_pinnacle_pctv_hd[] = {
 	{ 0x36, KEY_RECORD },
 	{ 0x3f, KEY_EPG },	/* Labeled "?" */
 };
-IR_TABLE(pinnacle_pctv_hd, IR_TYPE_UNKNOWN, ir_codes_pinnacle_pctv_hd);
+DEFINE_LEGACY_IR_KEYTABLE(pinnacle_pctv_hd);
 
 /*
  * Igor Kuznetsov <igk72@ya.ru>
@@ -2169,7 +2160,7 @@ IR_TABLE(pinnacle_pctv_hd, IR_TYPE_UNKNOWN, ir_codes_pinnacle_pctv_hd);
  * the button labels (several variants when appropriate)
  * helps to descide which keycodes to assign to the buttons.
  */
-static struct ir_scancode ir_codes_behold[] = {
+static struct ir_scancode behold[] = {
 
 	/*  0x1c            0x12  *
 	 *  TV/FM          POWER  *
@@ -2259,7 +2250,7 @@ static struct ir_scancode ir_codes_behold[] = {
 	{ 0x5c, KEY_CAMERA },
 
 };
-IR_TABLE(behold, IR_TYPE_UNKNOWN, ir_codes_behold);
+DEFINE_LEGACY_IR_KEYTABLE(behold);
 
 /* Beholder Intl. Ltd. 2008
  * Dmitry Belimov d.belimov@google.com
@@ -2269,7 +2260,7 @@ IR_TABLE(behold, IR_TYPE_UNKNOWN, ir_codes_behold);
  * the button labels (several variants when appropriate)
  * helps to descide which keycodes to assign to the buttons.
  */
-static struct ir_scancode ir_codes_behold_columbus[] = {
+static struct ir_scancode behold_columbus[] = {
 
 	/*  0x13   0x11   0x1C   0x12  *
 	 *  Mute  Source  TV/FM  Power *
@@ -2329,13 +2320,13 @@ static struct ir_scancode ir_codes_behold_columbus[] = {
 	{ 0x1A, KEY_NEXT },
 
 };
-IR_TABLE(behold_columbus, IR_TYPE_UNKNOWN, ir_codes_behold_columbus);
+DEFINE_LEGACY_IR_KEYTABLE(behold_columbus);
 
 /*
  * Remote control for the Genius TVGO A11MCE
  * Adrian Pardini <pardo.bsso@gmail.com>
  */
-static struct ir_scancode ir_codes_genius_tvgo_a11mce[] = {
+static struct ir_scancode genius_tvgo_a11mce[] = {
 	/* Keys 0 to 9 */
 	{ 0x48, KEY_0 },
 	{ 0x09, KEY_1 },
@@ -2375,13 +2366,13 @@ static struct ir_scancode ir_codes_genius_tvgo_a11mce[] = {
 	{ 0x13, KEY_YELLOW },
 	{ 0x50, KEY_BLUE },
 };
-IR_TABLE(genius_tvgo_a11mce, IR_TYPE_UNKNOWN, ir_codes_genius_tvgo_a11mce);
+DEFINE_LEGACY_IR_KEYTABLE(genius_tvgo_a11mce);
 
 /*
  * Remote control for Powercolor Real Angel 330
  * Daniel Fraga <fragabr@gmail.com>
  */
-static struct ir_scancode ir_codes_powercolor_real_angel[] = {
+static struct ir_scancode powercolor_real_angel[] = {
 	{ 0x38, KEY_SWITCHVIDEOMODE },	/* switch inputs */
 	{ 0x0c, KEY_MEDIA },		/* Turn ON/OFF App */
 	{ 0x00, KEY_0 },
@@ -2418,12 +2409,12 @@ static struct ir_scancode ir_codes_powercolor_real_angel[] = {
 	{ 0x14, KEY_RADIO },		/* FM radio */
 	{ 0x25, KEY_POWER },		/* power */
 };
-IR_TABLE(powercolor_real_angel, IR_TYPE_UNKNOWN, ir_codes_powercolor_real_angel);
+DEFINE_LEGACY_IR_KEYTABLE(powercolor_real_angel);
 
 /* Kworld Plus TV Analog Lite PCI IR
    Mauro Carvalho Chehab <mchehab@infradead.org>
  */
-static struct ir_scancode ir_codes_kworld_plus_tv_analog[] = {
+static struct ir_scancode kworld_plus_tv_analog[] = {
 	{ 0x0c, KEY_PROG1 },		/* Kworld key */
 	{ 0x16, KEY_CLOSECD },		/* -> ) */
 	{ 0x1d, KEY_POWER2 },
@@ -2479,12 +2470,12 @@ static struct ir_scancode ir_codes_kworld_plus_tv_analog[] = {
 	{ 0x18, KEY_RED},		/* B */
 	{ 0x23, KEY_GREEN},		/* C */
 };
-IR_TABLE(kworld_plus_tv_analog, IR_TYPE_UNKNOWN, ir_codes_kworld_plus_tv_analog);
+DEFINE_LEGACY_IR_KEYTABLE(kworld_plus_tv_analog);
 
 /* Kaiomy TVnPC U2
    Mauro Carvalho Chehab <mchehab@infradead.org>
  */
-static struct ir_scancode ir_codes_kaiomy[] = {
+static struct ir_scancode kaiomy[] = {
 	{ 0x43, KEY_POWER2},
 	{ 0x01, KEY_LIST},
 	{ 0x0b, KEY_ZOOM},
@@ -2528,9 +2519,9 @@ static struct ir_scancode ir_codes_kaiomy[] = {
 	{ 0x1e, KEY_YELLOW},
 	{ 0x1f, KEY_BLUE},
 };
-IR_TABLE(kaiomy, IR_TYPE_UNKNOWN, ir_codes_kaiomy);
+DEFINE_LEGACY_IR_KEYTABLE(kaiomy);
 
-static struct ir_scancode ir_codes_avermedia_a16d[] = {
+static struct ir_scancode avermedia_a16d[] = {
 	{ 0x20, KEY_LIST},
 	{ 0x00, KEY_POWER},
 	{ 0x28, KEY_1},
@@ -2566,12 +2557,12 @@ static struct ir_scancode ir_codes_avermedia_a16d[] = {
 	{ 0x08, KEY_EPG},
 	{ 0x2a, KEY_MENU},
 };
-IR_TABLE(avermedia_a16d, IR_TYPE_UNKNOWN, ir_codes_avermedia_a16d);
+DEFINE_LEGACY_IR_KEYTABLE(avermedia_a16d);
 
 /* Encore ENLTV-FM v5.3
    Mauro Carvalho Chehab <mchehab@infradead.org>
  */
-static struct ir_scancode ir_codes_encore_enltv_fm53[] = {
+static struct ir_scancode encore_enltv_fm53[] = {
 	{ 0x10, KEY_POWER2},
 	{ 0x06, KEY_MUTE},
 
@@ -2609,10 +2600,10 @@ static struct ir_scancode ir_codes_encore_enltv_fm53[] = {
 	{ 0x0c, KEY_ZOOM},		/* hide pannel */
 	{ 0x47, KEY_SLEEP},		/* shutdown */
 };
-IR_TABLE(encore_enltv_fm53, IR_TYPE_UNKNOWN, ir_codes_encore_enltv_fm53);
+DEFINE_LEGACY_IR_KEYTABLE(encore_enltv_fm53);
 
 /* Zogis Real Audio 220 - 32 keys IR */
-static struct ir_scancode ir_codes_real_audio_220_32_keys[] = {
+static struct ir_scancode real_audio_220_32_keys[] = {
 	{ 0x1c, KEY_RADIO},
 	{ 0x12, KEY_POWER2},
 
@@ -2649,12 +2640,12 @@ static struct ir_scancode ir_codes_real_audio_220_32_keys[] = {
 	{ 0x19, KEY_CAMERA},		/* Snapshot */
 
 };
-IR_TABLE(real_audio_220_32_keys, IR_TYPE_UNKNOWN, ir_codes_real_audio_220_32_keys);
+DEFINE_LEGACY_IR_KEYTABLE(real_audio_220_32_keys);
 
 /* ATI TV Wonder HD 600 USB
    Devin Heitmueller <devin.heitmueller@gmail.com>
  */
-static struct ir_scancode ir_codes_ati_tv_wonder_hd_600[] = {
+static struct ir_scancode ati_tv_wonder_hd_600[] = {
 	{ 0x00, KEY_RECORD},		/* Row 1 */
 	{ 0x01, KEY_PLAYPAUSE},
 	{ 0x02, KEY_STOP},
@@ -2680,12 +2671,12 @@ static struct ir_scancode ir_codes_ati_tv_wonder_hd_600[] = {
 	{ 0x16, KEY_MUTE},
 	{ 0x17, KEY_VOLUMEDOWN},
 };
-IR_TABLE(ati_tv_wonder_hd_600, IR_TYPE_UNKNOWN, ir_codes_ati_tv_wonder_hd_600);
+DEFINE_LEGACY_IR_KEYTABLE(ati_tv_wonder_hd_600);
 
 /* DVBWorld remotes
    Igor M. Liplianin <liplianin@me.by>
  */
-static struct ir_scancode ir_codes_dm1105_nec[] = {
+static struct ir_scancode dm1105_nec[] = {
 	{ 0x0a, KEY_POWER2},		/* power */
 	{ 0x0c, KEY_MUTE},		/* mute */
 	{ 0x11, KEY_1},
@@ -2718,9 +2709,9 @@ static struct ir_scancode ir_codes_dm1105_nec[] = {
 	{ 0x1e, KEY_TV},		/* tvmode */
 	{ 0x1b, KEY_B},			/* recall */
 };
-IR_TABLE(dm1105_nec, IR_TYPE_UNKNOWN, ir_codes_dm1105_nec);
+DEFINE_LEGACY_IR_KEYTABLE(dm1105_nec);
 
-static struct ir_scancode ir_codes_tevii_nec[] = {
+static struct ir_scancode tevii_nec[] = {
 	{ 0x0a, KEY_POWER2},
 	{ 0x0c, KEY_MUTE},
 	{ 0x11, KEY_1},
@@ -2769,9 +2760,9 @@ static struct ir_scancode ir_codes_tevii_nec[] = {
 	{ 0x56, KEY_MODE},
 	{ 0x58, KEY_SWITCHVIDEOMODE},
 };
-IR_TABLE(tevii_nec, IR_TYPE_UNKNOWN, ir_codes_tevii_nec);
+DEFINE_LEGACY_IR_KEYTABLE(tevii_nec);
 
-static struct ir_scancode ir_codes_tbs_nec[] = {
+static struct ir_scancode tbs_nec[] = {
 	{ 0x04, KEY_POWER2},	/*power*/
 	{ 0x14, KEY_MUTE},	/*mute*/
 	{ 0x07, KEY_1},
@@ -2805,12 +2796,12 @@ static struct ir_scancode ir_codes_tbs_nec[] = {
 	{ 0x00, KEY_PREVIOUS},
 	{ 0x1b, KEY_MODE},
 };
-IR_TABLE(tbs_nec, IR_TYPE_UNKNOWN, ir_codes_tbs_nec);
+DEFINE_LEGACY_IR_KEYTABLE(tbs_nec);
 
 /* Terratec Cinergy Hybrid T USB XS
    Devin Heitmueller <dheitmueller@linuxtv.org>
  */
-static struct ir_scancode ir_codes_terratec_cinergy_xs[] = {
+static struct ir_scancode terratec_cinergy_xs[] = {
 	{ 0x41, KEY_HOME},
 	{ 0x01, KEY_POWER},
 	{ 0x42, KEY_MENU},
@@ -2859,12 +2850,12 @@ static struct ir_scancode ir_codes_terratec_cinergy_xs[] = {
 	{ 0x4f, KEY_FASTFORWARD},
 	{ 0x5c, KEY_NEXT},
 };
-IR_TABLE(terratec_cinergy_xs, IR_TYPE_UNKNOWN, ir_codes_terratec_cinergy_xs);
+DEFINE_LEGACY_IR_KEYTABLE(terratec_cinergy_xs);
 
 /* EVGA inDtube
    Devin Heitmueller <devin.heitmueller@gmail.com>
  */
-static struct ir_scancode ir_codes_evga_indtube[] = {
+static struct ir_scancode evga_indtube[] = {
 	{ 0x12, KEY_POWER},
 	{ 0x02, KEY_MODE},	/* TV */
 	{ 0x14, KEY_MUTE},
@@ -2882,9 +2873,9 @@ static struct ir_scancode ir_codes_evga_indtube[] = {
 	{ 0x1f, KEY_NEXT},
 	{ 0x13, KEY_CAMERA},
 };
-IR_TABLE(evga_indtube, IR_TYPE_UNKNOWN, ir_codes_evga_indtube);
+DEFINE_LEGACY_IR_KEYTABLE(evga_indtube);
 
-static struct ir_scancode ir_codes_videomate_s350[] = {
+static struct ir_scancode videomate_s350[] = {
 	{ 0x00, KEY_TV},
 	{ 0x01, KEY_DVD},
 	{ 0x04, KEY_RECORD},
@@ -2930,12 +2921,12 @@ static struct ir_scancode ir_codes_videomate_s350[] = {
 	{ 0x11, KEY_ENTER},
 	{ 0x20, KEY_TEXT},
 };
-IR_TABLE(videomate_s350, IR_TYPE_UNKNOWN, ir_codes_videomate_s350);
+DEFINE_LEGACY_IR_KEYTABLE(videomate_s350);
 
 /* GADMEI UTV330+ RM008Z remote
    Shine Liu <shinel@foxmail.com>
  */
-static struct ir_scancode ir_codes_gadmei_rm008z[] = {
+static struct ir_scancode gadmei_rm008z[] = {
 	{ 0x14, KEY_POWER2},		/* POWER OFF */
 	{ 0x0c, KEY_MUTE},		/* MUTE */
 
@@ -2973,7 +2964,7 @@ static struct ir_scancode ir_codes_gadmei_rm008z[] = {
 	{ 0x13, KEY_CHANNELDOWN},	/* CHANNELDOWN */
 	{ 0x15, KEY_ENTER},		/* OK */
 };
-IR_TABLE(gadmei_rm008z, IR_TYPE_UNKNOWN, ir_codes_gadmei_rm008z);
+DEFINE_LEGACY_IR_KEYTABLE(gadmei_rm008z);
 
 /*************************************************************
  *		COMPLETE SCANCODE TABLES
@@ -2987,7 +2978,7 @@ IR_TABLE(gadmei_rm008z, IR_TYPE_UNKNOWN, ir_codes_gadmei_rm008z);
  *
  * This table contains the complete RC5 code, instead of just the data part
  */
-static struct ir_scancode ir_codes_rc5_hauppauge_new[] = {
+static struct ir_scancode rc5_hauppauge_new[] = {
 	/* Keys 0 to 9 */
 	{ 0x1e00, KEY_0 },
 	{ 0x1e01, KEY_1 },
@@ -3044,12 +3035,12 @@ static struct ir_scancode ir_codes_rc5_hauppauge_new[] = {
 	{ 0x1e3c, KEY_ZOOM },		/* full */
 	{ 0x1e3d, KEY_POWER },		/* system power (green button) */
 };
-IR_TABLE(rc5_hauppauge_new, IR_TYPE_RC5, ir_codes_rc5_hauppauge_new);
+DEFINE_IR_KEYTABLE(rc5_hauppauge_new, IR_TYPE_RC5);
 
 /* Terratec Cinergy Hybrid T USB XS FM
    Mauro Carvalho Chehab <mchehab@redhat.com>
  */
-static struct ir_scancode ir_codes_nec_terratec_cinergy_xs[] = {
+static struct ir_scancode nec_terratec_cinergy_xs[] = {
 	{ 0x1441, KEY_HOME},
 	{ 0x1401, KEY_POWER2},
 
@@ -3111,12 +3102,12 @@ static struct ir_scancode ir_codes_nec_terratec_cinergy_xs[] = {
 	{ 0x144f, KEY_FASTFORWARD},
 	{ 0x145c, KEY_NEXT},
 };
-IR_TABLE(nec_terratec_cinergy_xs, IR_TYPE_NEC, ir_codes_nec_terratec_cinergy_xs);
+DEFINE_IR_KEYTABLE(nec_terratec_cinergy_xs, IR_TYPE_NEC);
 
 /* Leadtek Winfast TV USB II Deluxe remote
    Magnus Alm <magnus.alm@gmail.com>
  */
-static struct ir_scancode ir_codes_winfast_usbii_deluxe[] = {
+static struct ir_scancode winfast_usbii_deluxe[] = {
 	{ 0x62, KEY_0},
 	{ 0x75, KEY_1},
 	{ 0x76, KEY_2},
@@ -3155,11 +3146,11 @@ static struct ir_scancode ir_codes_winfast_usbii_deluxe[] = {
 	{ 0x63, KEY_ENTER},		/* ENTER */
 
 };
-IR_TABLE(winfast_usbii_deluxe, IR_TYPE_UNKNOWN, ir_codes_winfast_usbii_deluxe);
+DEFINE_LEGACY_IR_KEYTABLE(winfast_usbii_deluxe);
 
 /* Kworld 315U
  */
-static struct ir_scancode ir_codes_kworld_315u[] = {
+static struct ir_scancode kworld_315u[] = {
 	{ 0x6143, KEY_POWER },
 	{ 0x6101, KEY_TUNER },		/* source */
 	{ 0x610b, KEY_ZOOM },
@@ -3200,4 +3191,4 @@ static struct ir_scancode ir_codes_kworld_315u[] = {
 	{ 0x611e, KEY_YELLOW },
 	{ 0x611f, KEY_BLUE },
 };
-IR_TABLE(kworld_315u, IR_TYPE_NEC, ir_codes_kworld_315u);
+DEFINE_IR_KEYTABLE(kworld_315u, IR_TYPE_NEC);
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 2e27515..e8a6476 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -107,11 +107,23 @@ void ir_rc5_timer_keyup(unsigned long data);
 /* scancode->keycode map tables from ir-keymaps.c */
 
 #define IR_KEYTABLE(a)					\
-(ir_codes_ ## a ## _table)
+ir_codes_ ## a ## _table
 
 #define DECLARE_IR_KEYTABLE(a)					\
 extern struct ir_scancode_table IR_KEYTABLE(a)
 
+#define DEFINE_IR_KEYTABLE(tabname, type)			\
+struct ir_scancode_table IR_KEYTABLE(tabname) = {		\
+	.scan = tabname,					\
+	.size = ARRAY_SIZE(tabname),				\
+	.ir_type = type,					\
+	.name = #tabname,					\
+};								\
+EXPORT_SYMBOL_GPL(IR_KEYTABLE(tabname))
+
+#define DEFINE_LEGACY_IR_KEYTABLE(tabname)			\
+	DEFINE_IR_KEYTABLE(tabname, IR_TYPE_UNKNOWN)
+
 DECLARE_IR_KEYTABLE(adstech_dvb_t_pci);
 DECLARE_IR_KEYTABLE(apac_viewcomp);
 DECLARE_IR_KEYTABLE(asus_pc39);
-- 
1.6.6.1


