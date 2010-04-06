Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497Ab0DFSTB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:19:01 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IJ1sq008079
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:19:01 -0400
Date: Tue, 6 Apr 2010 15:18:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/26] V4L/DVB: ir-common: move IR tables from ir-keymaps.c
 to a separate file
Message-ID: <20100406151803.4669bd8a@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having one big file with lots of keytables, create one include
file for each IR keymap.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 include/media/keycodes/adstech-dvb-t-pci.h
 create mode 100644 include/media/keycodes/apac-viewcomp.h
 create mode 100644 include/media/keycodes/asus-pc39.h
 create mode 100644 include/media/keycodes/ati-tv-wonder-hd-600.h
 create mode 100644 include/media/keycodes/avermedia-a16d.h
 create mode 100644 include/media/keycodes/avermedia-cardbus.h
 create mode 100644 include/media/keycodes/avermedia-dvbt.h
 create mode 100644 include/media/keycodes/avermedia-m135a-rm-jx.h
 create mode 100644 include/media/keycodes/avermedia.h
 create mode 100644 include/media/keycodes/avertv-303.h
 create mode 100644 include/media/keycodes/behold-columbus.h
 create mode 100644 include/media/keycodes/behold.h
 create mode 100644 include/media/keycodes/budget-ci-old.h
 create mode 100644 include/media/keycodes/cinergy-1400.h
 create mode 100644 include/media/keycodes/cinergy.h
 create mode 100644 include/media/keycodes/dm1105-nec.h
 create mode 100644 include/media/keycodes/dntv-live-dvb-t.h
 create mode 100644 include/media/keycodes/dntv-live-dvbt-pro.h
 create mode 100644 include/media/keycodes/em-terratec.h
 create mode 100644 include/media/keycodes/empty.h
 create mode 100644 include/media/keycodes/encore-enltv-fm53.h
 create mode 100644 include/media/keycodes/encore-enltv.h
 create mode 100644 include/media/keycodes/encore-enltv2.h
 create mode 100644 include/media/keycodes/evga-indtube.h
 create mode 100644 include/media/keycodes/eztv.h
 create mode 100644 include/media/keycodes/flydvb.h
 create mode 100644 include/media/keycodes/flyvideo.h
 create mode 100644 include/media/keycodes/fusionhdtv-mce.h
 create mode 100644 include/media/keycodes/gadmei-rm008z.h
 create mode 100644 include/media/keycodes/genius-tvgo-a11mce.h
 create mode 100644 include/media/keycodes/gotview7135.h
 create mode 100644 include/media/keycodes/hauppauge-new.h
 create mode 100644 include/media/keycodes/iodata-bctv7e.h
 create mode 100644 include/media/keycodes/kaiomy.h
 create mode 100644 include/media/keycodes/kworld-315u.h
 create mode 100644 include/media/keycodes/kworld-plus-tv-analog.h
 create mode 100644 include/media/keycodes/manli.h
 create mode 100644 include/media/keycodes/msi-tvanywhere-plus.h
 create mode 100644 include/media/keycodes/msi-tvanywhere.h
 create mode 100644 include/media/keycodes/nebula.h
 create mode 100644 include/media/keycodes/nec-terratec-cinergy-xs.h
 create mode 100644 include/media/keycodes/norwood.h
 create mode 100644 include/media/keycodes/npgtech.h
 create mode 100644 include/media/keycodes/pctv-sedna.h
 create mode 100644 include/media/keycodes/pinnacle-color.h
 create mode 100644 include/media/keycodes/pinnacle-grey.h
 create mode 100644 include/media/keycodes/pinnacle-pctv-hd.h
 create mode 100644 include/media/keycodes/pixelview-new.h
 create mode 100644 include/media/keycodes/pixelview.h
 create mode 100644 include/media/keycodes/powercolor-real-angel.h
 create mode 100644 include/media/keycodes/proteus-2309.h
 create mode 100644 include/media/keycodes/purpletv.h
 create mode 100644 include/media/keycodes/pv951.h
 create mode 100644 include/media/keycodes/rc5-hauppauge-new.h
 create mode 100644 include/media/keycodes/rc5-tv.h
 create mode 100644 include/media/keycodes/real-audio-220-32-keys.h
 create mode 100644 include/media/keycodes/tbs-nec.h
 create mode 100644 include/media/keycodes/terratec-cinergy-xs.h
 create mode 100644 include/media/keycodes/tevii-nec.h
 create mode 100644 include/media/keycodes/tt-1500.h
 create mode 100644 include/media/keycodes/videomate-s350.h
 create mode 100644 include/media/keycodes/videomate-tv-pvr.h
 create mode 100644 include/media/keycodes/winfast-usbii-deluxe.h
 create mode 100644 include/media/keycodes/winfast.h

diff --git a/drivers/media/IR/ir-keymaps.c b/drivers/media/IR/ir-keymaps.c
index 1ba9285..eb25531 100644
--- a/drivers/media/IR/ir-keymaps.c
+++ b/drivers/media/IR/ir-keymaps.c
@@ -17,3178 +17,29 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define IR_KEYMAPS
+
 /*
  * NOTICE FOR DEVELOPERS:
  *   The IR mappings should be as close as possible to what's
  *   specified at:
  *      http://linuxtv.org/wiki/index.php/Remote_Controllers
- */
-#include <linux/module.h>
-
-#include <linux/input.h>
-#include <media/ir-common.h>
-
-
-/*
+ *
  * The usage of tables with just the command part is deprecated.
  * All new IR keytables should contain address+command and need
  * to define the proper IR_TYPE (IR_TYPE_RC5/IR_TYPE_NEC).
  * The deprecated tables should use IR_TYPE_UNKNOWN
  */
+#include <linux/module.h>
 
-/* empty keytable, can be used as placeholder for not-yet created keytables */
-static struct ir_scancode empty[] = {
-	{ 0x2a, KEY_COFFEE },
-};
-DEFINE_LEGACY_IR_KEYTABLE(empty);
-
-/* Michal Majchrowicz <mmajchrowicz@gmail.com> */
-static struct ir_scancode proteus_2309[] = {
-	/* numeric */
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x5c, KEY_POWER },		/* power       */
-	{ 0x20, KEY_ZOOM },		/* full screen */
-	{ 0x0f, KEY_BACKSPACE },	/* recall      */
-	{ 0x1b, KEY_ENTER },		/* mute        */
-	{ 0x41, KEY_RECORD },		/* record      */
-	{ 0x43, KEY_STOP },		/* stop        */
-	{ 0x16, KEY_S },
-	{ 0x1a, KEY_POWER2 },		/* off         */
-	{ 0x2e, KEY_RED },
-	{ 0x1f, KEY_CHANNELDOWN },	/* channel -   */
-	{ 0x1c, KEY_CHANNELUP },	/* channel +   */
-	{ 0x10, KEY_VOLUMEDOWN },	/* volume -    */
-	{ 0x1e, KEY_VOLUMEUP },		/* volume +    */
-	{ 0x14, KEY_F1 },
-};
-DEFINE_LEGACY_IR_KEYTABLE(proteus_2309);
-
-/* Matt Jesson <dvb@jesson.eclipse.co.uk */
-static struct ir_scancode avermedia_dvbt[] = {
-	{ 0x28, KEY_0 },		/* '0' / 'enter' */
-	{ 0x22, KEY_1 },		/* '1' */
-	{ 0x12, KEY_2 },		/* '2' / 'up arrow' */
-	{ 0x32, KEY_3 },		/* '3' */
-	{ 0x24, KEY_4 },		/* '4' / 'left arrow' */
-	{ 0x14, KEY_5 },		/* '5' */
-	{ 0x34, KEY_6 },		/* '6' / 'right arrow' */
-	{ 0x26, KEY_7 },		/* '7' */
-	{ 0x16, KEY_8 },		/* '8' / 'down arrow' */
-	{ 0x36, KEY_9 },		/* '9' */
-
-	{ 0x20, KEY_LIST },		/* 'source' */
-	{ 0x10, KEY_TEXT },		/* 'teletext' */
-	{ 0x00, KEY_POWER },		/* 'power' */
-	{ 0x04, KEY_AUDIO },		/* 'audio' */
-	{ 0x06, KEY_ZOOM },		/* 'full screen' */
-	{ 0x18, KEY_VIDEO },		/* 'display' */
-	{ 0x38, KEY_SEARCH },		/* 'loop' */
-	{ 0x08, KEY_INFO },		/* 'preview' */
-	{ 0x2a, KEY_REWIND },		/* 'backward <<' */
-	{ 0x1a, KEY_FASTFORWARD },	/* 'forward >>' */
-	{ 0x3a, KEY_RECORD },		/* 'capture' */
-	{ 0x0a, KEY_MUTE },		/* 'mute' */
-	{ 0x2c, KEY_RECORD },		/* 'record' */
-	{ 0x1c, KEY_PAUSE },		/* 'pause' */
-	{ 0x3c, KEY_STOP },		/* 'stop' */
-	{ 0x0c, KEY_PLAY },		/* 'play' */
-	{ 0x2e, KEY_RED },		/* 'red' */
-	{ 0x01, KEY_BLUE },		/* 'blue' / 'cancel' */
-	{ 0x0e, KEY_YELLOW },		/* 'yellow' / 'ok' */
-	{ 0x21, KEY_GREEN },		/* 'green' */
-	{ 0x11, KEY_CHANNELDOWN },	/* 'channel -' */
-	{ 0x31, KEY_CHANNELUP },	/* 'channel +' */
-	{ 0x1e, KEY_VOLUMEDOWN },	/* 'volume -' */
-	{ 0x3e, KEY_VOLUMEUP },		/* 'volume +' */
-};
-DEFINE_LEGACY_IR_KEYTABLE(avermedia_dvbt);
-
-/*
- * Avermedia M135A with IR model RM-JX
- * The same codes exist on both Positivo (BR) and original IR
- * Mauro Carvalho Chehab <mchehab@infradead.org>
- */
-static struct ir_scancode avermedia_m135a_rm_jx[] = {
-	{ 0x0200, KEY_POWER2 },
-	{ 0x022e, KEY_DOT },		/* '.' */
-	{ 0x0201, KEY_MODE },		/* TV/FM or SOURCE */
-
-	{ 0x0205, KEY_1 },
-	{ 0x0206, KEY_2 },
-	{ 0x0207, KEY_3 },
-	{ 0x0209, KEY_4 },
-	{ 0x020a, KEY_5 },
-	{ 0x020b, KEY_6 },
-	{ 0x020d, KEY_7 },
-	{ 0x020e, KEY_8 },
-	{ 0x020f, KEY_9 },
-	{ 0x0211, KEY_0 },
-
-	{ 0x0213, KEY_RIGHT },		/* -> or L */
-	{ 0x0212, KEY_LEFT },		/* <- or R */
-
-	{ 0x0217, KEY_SLEEP },		/* Capturar Imagem or Snapshot */
-	{ 0x0210, KEY_SHUFFLE },	/* Amostra or 16 chan prev */
-
-	{ 0x0303, KEY_CHANNELUP },
-	{ 0x0302, KEY_CHANNELDOWN },
-	{ 0x021f, KEY_VOLUMEUP },
-	{ 0x021e, KEY_VOLUMEDOWN },
-	{ 0x020c, KEY_ENTER },		/* Full Screen */
-
-	{ 0x0214, KEY_MUTE },
-	{ 0x0208, KEY_AUDIO },
-
-	{ 0x0203, KEY_TEXT },		/* Teletext */
-	{ 0x0204, KEY_EPG },
-	{ 0x022b, KEY_TV2 },		/* TV2 or PIP */
-
-	{ 0x021d, KEY_RED },
-	{ 0x021c, KEY_YELLOW },
-	{ 0x0301, KEY_GREEN },
-	{ 0x0300, KEY_BLUE },
-
-	{ 0x021a, KEY_PLAYPAUSE },
-	{ 0x0219, KEY_RECORD },
-	{ 0x0218, KEY_PLAY },
-	{ 0x021b, KEY_STOP },
-};
-DEFINE_IR_KEYTABLE(avermedia_m135a_rm_jx, IR_TYPE_NEC);
-
-/* Oldrich Jedlicka <oldium.pro@seznam.cz> */
-static struct ir_scancode avermedia_cardbus[] = {
-	{ 0x00, KEY_POWER },
-	{ 0x01, KEY_TUNER },		/* TV/FM */
-	{ 0x03, KEY_TEXT },		/* Teletext */
-	{ 0x04, KEY_EPG },
-	{ 0x05, KEY_1 },
-	{ 0x06, KEY_2 },
-	{ 0x07, KEY_3 },
-	{ 0x08, KEY_AUDIO },
-	{ 0x09, KEY_4 },
-	{ 0x0a, KEY_5 },
-	{ 0x0b, KEY_6 },
-	{ 0x0c, KEY_ZOOM },		/* Full screen */
-	{ 0x0d, KEY_7 },
-	{ 0x0e, KEY_8 },
-	{ 0x0f, KEY_9 },
-	{ 0x10, KEY_PAGEUP },		/* 16-CH PREV */
-	{ 0x11, KEY_0 },
-	{ 0x12, KEY_INFO },
-	{ 0x13, KEY_AGAIN },		/* CH RTN - channel return */
-	{ 0x14, KEY_MUTE },
-	{ 0x15, KEY_EDIT },		/* Autoscan */
-	{ 0x17, KEY_SAVE },		/* Screenshot */
-	{ 0x18, KEY_PLAYPAUSE },
-	{ 0x19, KEY_RECORD },
-	{ 0x1a, KEY_PLAY },
-	{ 0x1b, KEY_STOP },
-	{ 0x1c, KEY_FASTFORWARD },
-	{ 0x1d, KEY_REWIND },
-	{ 0x1e, KEY_VOLUMEDOWN },
-	{ 0x1f, KEY_VOLUMEUP },
-	{ 0x22, KEY_SLEEP },		/* Sleep */
-	{ 0x23, KEY_ZOOM },		/* Aspect */
-	{ 0x26, KEY_SCREEN },		/* Pos */
-	{ 0x27, KEY_ANGLE },		/* Size */
-	{ 0x28, KEY_SELECT },		/* Select */
-	{ 0x29, KEY_BLUE },		/* Blue/Picture */
-	{ 0x2a, KEY_BACKSPACE },	/* Back */
-	{ 0x2b, KEY_MEDIA },		/* PIP (Picture-in-picture) */
-	{ 0x2c, KEY_DOWN },
-	{ 0x2e, KEY_DOT },
-	{ 0x2f, KEY_TV },		/* Live TV */
-	{ 0x32, KEY_LEFT },
-	{ 0x33, KEY_CLEAR },		/* Clear */
-	{ 0x35, KEY_RED },		/* Red/TV */
-	{ 0x36, KEY_UP },
-	{ 0x37, KEY_HOME },		/* Home */
-	{ 0x39, KEY_GREEN },		/* Green/Video */
-	{ 0x3d, KEY_YELLOW },		/* Yellow/Music */
-	{ 0x3e, KEY_OK },		/* Ok */
-	{ 0x3f, KEY_RIGHT },
-	{ 0x40, KEY_NEXT },		/* Next */
-	{ 0x41, KEY_PREVIOUS },		/* Previous */
-	{ 0x42, KEY_CHANNELDOWN },	/* Channel down */
-	{ 0x43, KEY_CHANNELUP },	/* Channel up */
-};
-DEFINE_LEGACY_IR_KEYTABLE(avermedia_cardbus);
-
-/* Attila Kondoros <attila.kondoros@chello.hu> */
-static struct ir_scancode apac_viewcomp[] = {
-
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-	{ 0x00, KEY_0 },
-	{ 0x17, KEY_LAST },		/* +100 */
-	{ 0x0a, KEY_LIST },		/* recall */
-
-
-	{ 0x1c, KEY_TUNER },		/* TV/FM */
-	{ 0x15, KEY_SEARCH },		/* scan */
-	{ 0x12, KEY_POWER },		/* power */
-	{ 0x1f, KEY_VOLUMEDOWN },	/* vol up */
-	{ 0x1b, KEY_VOLUMEUP },		/* vol down */
-	{ 0x1e, KEY_CHANNELDOWN },	/* chn up */
-	{ 0x1a, KEY_CHANNELUP },	/* chn down */
-
-	{ 0x11, KEY_VIDEO },		/* video */
-	{ 0x0f, KEY_ZOOM },		/* full screen */
-	{ 0x13, KEY_MUTE },		/* mute/unmute */
-	{ 0x10, KEY_TEXT },		/* min */
-
-	{ 0x0d, KEY_STOP },		/* freeze */
-	{ 0x0e, KEY_RECORD },		/* record */
-	{ 0x1d, KEY_PLAYPAUSE },	/* stop */
-	{ 0x19, KEY_PLAY },		/* play */
-
-	{ 0x16, KEY_GOTO },		/* osd */
-	{ 0x14, KEY_REFRESH },		/* default */
-	{ 0x0c, KEY_KPPLUS },		/* fine tune >>>> */
-	{ 0x18, KEY_KPMINUS },		/* fine tune <<<< */
-};
-DEFINE_LEGACY_IR_KEYTABLE(apac_viewcomp);
-
-/* ---------------------------------------------------------------------- */
-
-static struct ir_scancode pixelview[] = {
-
-	{ 0x1e, KEY_POWER },	/* power */
-	{ 0x07, KEY_MEDIA },	/* source */
-	{ 0x1c, KEY_SEARCH },	/* scan */
-
-
-	{ 0x03, KEY_TUNER },		/* TV/FM */
-
-	{ 0x00, KEY_RECORD },
-	{ 0x08, KEY_STOP },
-	{ 0x11, KEY_PLAY },
-
-	{ 0x1a, KEY_PLAYPAUSE },	/* freeze */
-	{ 0x19, KEY_ZOOM },		/* zoom */
-	{ 0x0f, KEY_TEXT },		/* min */
-
-	{ 0x01, KEY_1 },
-	{ 0x0b, KEY_2 },
-	{ 0x1b, KEY_3 },
-	{ 0x05, KEY_4 },
-	{ 0x09, KEY_5 },
-	{ 0x15, KEY_6 },
-	{ 0x06, KEY_7 },
-	{ 0x0a, KEY_8 },
-	{ 0x12, KEY_9 },
-	{ 0x02, KEY_0 },
-	{ 0x10, KEY_LAST },		/* +100 */
-	{ 0x13, KEY_LIST },		/* recall */
-
-	{ 0x1f, KEY_CHANNELUP },	/* chn down */
-	{ 0x17, KEY_CHANNELDOWN },	/* chn up */
-	{ 0x16, KEY_VOLUMEUP },		/* vol down */
-	{ 0x14, KEY_VOLUMEDOWN },	/* vol up */
-
-	{ 0x04, KEY_KPMINUS },		/* <<< */
-	{ 0x0e, KEY_SETUP },		/* function */
-	{ 0x0c, KEY_KPPLUS },		/* >>> */
-
-	{ 0x0d, KEY_GOTO },		/* mts */
-	{ 0x1d, KEY_REFRESH },		/* reset */
-	{ 0x18, KEY_MUTE },		/* mute/unmute */
-};
-DEFINE_LEGACY_IR_KEYTABLE(pixelview);
+#include <linux/input.h>
+#include <media/ir-common.h>
 
 /*
-   Mauro Carvalho Chehab <mchehab@infradead.org>
-   present on PV MPEG 8000GT
- */
-static struct ir_scancode pixelview_new[] = {
-	{ 0x3c, KEY_TIME },		/* Timeshift */
-	{ 0x12, KEY_POWER },
-
-	{ 0x3d, KEY_1 },
-	{ 0x38, KEY_2 },
-	{ 0x18, KEY_3 },
-	{ 0x35, KEY_4 },
-	{ 0x39, KEY_5 },
-	{ 0x15, KEY_6 },
-	{ 0x36, KEY_7 },
-	{ 0x3a, KEY_8 },
-	{ 0x1e, KEY_9 },
-	{ 0x3e, KEY_0 },
-
-	{ 0x1c, KEY_AGAIN },		/* LOOP	*/
-	{ 0x3f, KEY_MEDIA },		/* Source */
-	{ 0x1f, KEY_LAST },		/* +100 */
-	{ 0x1b, KEY_MUTE },
-
-	{ 0x17, KEY_CHANNELDOWN },
-	{ 0x16, KEY_CHANNELUP },
-	{ 0x10, KEY_VOLUMEUP },
-	{ 0x14, KEY_VOLUMEDOWN },
-	{ 0x13, KEY_ZOOM },
-
-	{ 0x19, KEY_CAMERA },		/* SNAPSHOT */
-	{ 0x1a, KEY_SEARCH },		/* scan */
-
-	{ 0x37, KEY_REWIND },		/* << */
-	{ 0x32, KEY_RECORD },		/* o (red) */
-	{ 0x33, KEY_FORWARD },		/* >> */
-	{ 0x11, KEY_STOP },		/* square */
-	{ 0x3b, KEY_PLAY },		/* > */
-	{ 0x30, KEY_PLAYPAUSE },	/* || */
-
-	{ 0x31, KEY_TV },
-	{ 0x34, KEY_RADIO },
-};
-DEFINE_LEGACY_IR_KEYTABLE(pixelview_new);
-
-static struct ir_scancode nebula[] = {
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-	{ 0x0a, KEY_TV },
-	{ 0x0b, KEY_AUX },
-	{ 0x0c, KEY_DVD },
-	{ 0x0d, KEY_POWER },
-	{ 0x0e, KEY_MHP },	/* labelled 'Picture' */
-	{ 0x0f, KEY_AUDIO },
-	{ 0x10, KEY_INFO },
-	{ 0x11, KEY_F13 },	/* 16:9 */
-	{ 0x12, KEY_F14 },	/* 14:9 */
-	{ 0x13, KEY_EPG },
-	{ 0x14, KEY_EXIT },
-	{ 0x15, KEY_MENU },
-	{ 0x16, KEY_UP },
-	{ 0x17, KEY_DOWN },
-	{ 0x18, KEY_LEFT },
-	{ 0x19, KEY_RIGHT },
-	{ 0x1a, KEY_ENTER },
-	{ 0x1b, KEY_CHANNELUP },
-	{ 0x1c, KEY_CHANNELDOWN },
-	{ 0x1d, KEY_VOLUMEUP },
-	{ 0x1e, KEY_VOLUMEDOWN },
-	{ 0x1f, KEY_RED },
-	{ 0x20, KEY_GREEN },
-	{ 0x21, KEY_YELLOW },
-	{ 0x22, KEY_BLUE },
-	{ 0x23, KEY_SUBTITLE },
-	{ 0x24, KEY_F15 },	/* AD */
-	{ 0x25, KEY_TEXT },
-	{ 0x26, KEY_MUTE },
-	{ 0x27, KEY_REWIND },
-	{ 0x28, KEY_STOP },
-	{ 0x29, KEY_PLAY },
-	{ 0x2a, KEY_FASTFORWARD },
-	{ 0x2b, KEY_F16 },	/* chapter */
-	{ 0x2c, KEY_PAUSE },
-	{ 0x2d, KEY_PLAY },
-	{ 0x2e, KEY_RECORD },
-	{ 0x2f, KEY_F17 },	/* picture in picture */
-	{ 0x30, KEY_KPPLUS },	/* zoom in */
-	{ 0x31, KEY_KPMINUS },	/* zoom out */
-	{ 0x32, KEY_F18 },	/* capture */
-	{ 0x33, KEY_F19 },	/* web */
-	{ 0x34, KEY_EMAIL },
-	{ 0x35, KEY_PHONE },
-	{ 0x36, KEY_PC },
-};
-DEFINE_LEGACY_IR_KEYTABLE(nebula);
-
-/* DigitalNow DNTV Live DVB-T Remote */
-static struct ir_scancode dntv_live_dvb_t[] = {
-	{ 0x00, KEY_ESC },		/* 'go up a level?' */
-	/* Keys 0 to 9 */
-	{ 0x0a, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x0b, KEY_TUNER },		/* tv/fm */
-	{ 0x0c, KEY_SEARCH },		/* scan */
-	{ 0x0d, KEY_STOP },
-	{ 0x0e, KEY_PAUSE },
-	{ 0x0f, KEY_LIST },		/* source */
-
-	{ 0x10, KEY_MUTE },
-	{ 0x11, KEY_REWIND },		/* backward << */
-	{ 0x12, KEY_POWER },
-	{ 0x13, KEY_CAMERA },		/* snap */
-	{ 0x14, KEY_AUDIO },		/* stereo */
-	{ 0x15, KEY_CLEAR },		/* reset */
-	{ 0x16, KEY_PLAY },
-	{ 0x17, KEY_ENTER },
-	{ 0x18, KEY_ZOOM },		/* full screen */
-	{ 0x19, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x1a, KEY_CHANNELUP },
-	{ 0x1b, KEY_VOLUMEUP },
-	{ 0x1c, KEY_INFO },		/* preview */
-	{ 0x1d, KEY_RECORD },		/* record */
-	{ 0x1e, KEY_CHANNELDOWN },
-	{ 0x1f, KEY_VOLUMEDOWN },
-};
-DEFINE_LEGACY_IR_KEYTABLE(dntv_live_dvb_t);
-
-/* ---------------------------------------------------------------------- */
-
-/* IO-DATA BCTV7E Remote */
-static struct ir_scancode iodata_bctv7e[] = {
-	{ 0x40, KEY_TV },
-	{ 0x20, KEY_RADIO },		/* FM */
-	{ 0x60, KEY_EPG },
-	{ 0x00, KEY_POWER },
-
-	/* Keys 0 to 9 */
-	{ 0x44, KEY_0 },		/* 10 */
-	{ 0x50, KEY_1 },
-	{ 0x30, KEY_2 },
-	{ 0x70, KEY_3 },
-	{ 0x48, KEY_4 },
-	{ 0x28, KEY_5 },
-	{ 0x68, KEY_6 },
-	{ 0x58, KEY_7 },
-	{ 0x38, KEY_8 },
-	{ 0x78, KEY_9 },
-
-	{ 0x10, KEY_L },		/* Live */
-	{ 0x08, KEY_TIME },		/* Time Shift */
-
-	{ 0x18, KEY_PLAYPAUSE },	/* Play */
-
-	{ 0x24, KEY_ENTER },		/* 11 */
-	{ 0x64, KEY_ESC },		/* 12 */
-	{ 0x04, KEY_M },		/* Multi */
-
-	{ 0x54, KEY_VIDEO },
-	{ 0x34, KEY_CHANNELUP },
-	{ 0x74, KEY_VOLUMEUP },
-	{ 0x14, KEY_MUTE },
-
-	{ 0x4c, KEY_VCR },		/* SVIDEO */
-	{ 0x2c, KEY_CHANNELDOWN },
-	{ 0x6c, KEY_VOLUMEDOWN },
-	{ 0x0c, KEY_ZOOM },
-
-	{ 0x5c, KEY_PAUSE },
-	{ 0x3c, KEY_RED },		/* || (red) */
-	{ 0x7c, KEY_RECORD },		/* recording */
-	{ 0x1c, KEY_STOP },
-
-	{ 0x41, KEY_REWIND },		/* backward << */
-	{ 0x21, KEY_PLAY },
-	{ 0x61, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x01, KEY_NEXT },		/* skip >| */
-};
-DEFINE_LEGACY_IR_KEYTABLE(iodata_bctv7e);
-
-/* ---------------------------------------------------------------------- */
-
-/* ADS Tech Instant TV DVB-T PCI Remote */
-static struct ir_scancode adstech_dvb_t_pci[] = {
-	/* Keys 0 to 9 */
-	{ 0x4d, KEY_0 },
-	{ 0x57, KEY_1 },
-	{ 0x4f, KEY_2 },
-	{ 0x53, KEY_3 },
-	{ 0x56, KEY_4 },
-	{ 0x4e, KEY_5 },
-	{ 0x5e, KEY_6 },
-	{ 0x54, KEY_7 },
-	{ 0x4c, KEY_8 },
-	{ 0x5c, KEY_9 },
-
-	{ 0x5b, KEY_POWER },
-	{ 0x5f, KEY_MUTE },
-	{ 0x55, KEY_GOTO },
-	{ 0x5d, KEY_SEARCH },
-	{ 0x17, KEY_EPG },		/* Guide */
-	{ 0x1f, KEY_MENU },
-	{ 0x0f, KEY_UP },
-	{ 0x46, KEY_DOWN },
-	{ 0x16, KEY_LEFT },
-	{ 0x1e, KEY_RIGHT },
-	{ 0x0e, KEY_SELECT },		/* Enter */
-	{ 0x5a, KEY_INFO },
-	{ 0x52, KEY_EXIT },
-	{ 0x59, KEY_PREVIOUS },
-	{ 0x51, KEY_NEXT },
-	{ 0x58, KEY_REWIND },
-	{ 0x50, KEY_FORWARD },
-	{ 0x44, KEY_PLAYPAUSE },
-	{ 0x07, KEY_STOP },
-	{ 0x1b, KEY_RECORD },
-	{ 0x13, KEY_TUNER },		/* Live */
-	{ 0x0a, KEY_A },
-	{ 0x12, KEY_B },
-	{ 0x03, KEY_PROG1 },		/* 1 */
-	{ 0x01, KEY_PROG2 },		/* 2 */
-	{ 0x00, KEY_PROG3 },		/* 3 */
-	{ 0x06, KEY_DVD },
-	{ 0x48, KEY_AUX },		/* Photo */
-	{ 0x40, KEY_VIDEO },
-	{ 0x19, KEY_AUDIO },		/* Music */
-	{ 0x0b, KEY_CHANNELUP },
-	{ 0x08, KEY_CHANNELDOWN },
-	{ 0x15, KEY_VOLUMEUP },
-	{ 0x1c, KEY_VOLUMEDOWN },
-};
-DEFINE_LEGACY_IR_KEYTABLE(adstech_dvb_t_pci);
-
-/* ---------------------------------------------------------------------- */
-
-/* MSI TV@nywhere MASTER remote */
-
-static struct ir_scancode msi_tvanywhere[] = {
-	/* Keys 0 to 9 */
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x0c, KEY_MUTE },
-	{ 0x0f, KEY_SCREEN },		/* Full Screen */
-	{ 0x10, KEY_FN },		/* Funtion */
-	{ 0x11, KEY_TIME },		/* Time shift */
-	{ 0x12, KEY_POWER },
-	{ 0x13, KEY_MEDIA },		/* MTS */
-	{ 0x14, KEY_SLOW },
-	{ 0x16, KEY_REWIND },		/* backward << */
-	{ 0x17, KEY_ENTER },		/* Return */
-	{ 0x18, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x1a, KEY_CHANNELUP },
-	{ 0x1b, KEY_VOLUMEUP },
-	{ 0x1e, KEY_CHANNELDOWN },
-	{ 0x1f, KEY_VOLUMEDOWN },
-};
-DEFINE_LEGACY_IR_KEYTABLE(msi_tvanywhere);
-
-/* ---------------------------------------------------------------------- */
-
-/*
-  Keycodes for remote on the MSI TV@nywhere Plus. The controller IC on the card
-  is marked "KS003". The controller is I2C at address 0x30, but does not seem
-  to respond to probes until a read is performed from a valid device.
-  I don't know why...
-
-  Note: This remote may be of similar or identical design to the
-  Pixelview remote (?).  The raw codes and duplicate button codes
-  appear to be the same.
-
-  Henry Wong <henry@stuffedcow.net>
-  Some changes to formatting and keycodes by Mark Schultz <n9xmj@yahoo.com>
-
-*/
-
-static struct ir_scancode msi_tvanywhere_plus[] = {
-
-/*  ---- Remote Button Layout ----
-
-    POWER   SOURCE  SCAN    MUTE
-    TV/FM   1       2       3
-    |>      4       5       6
-    <|      7       8       9
-    ^^UP    0       +       RECALL
-    vvDN    RECORD  STOP    PLAY
-
-	MINIMIZE          ZOOM
-
-		  CH+
-      VOL-                   VOL+
-		  CH-
-
-	SNAPSHOT           MTS
-
-     <<      FUNC    >>     RESET
-*/
-
-	{ 0x01, KEY_1 },		/* 1 */
-	{ 0x0b, KEY_2 },		/* 2 */
-	{ 0x1b, KEY_3 },		/* 3 */
-	{ 0x05, KEY_4 },		/* 4 */
-	{ 0x09, KEY_5 },		/* 5 */
-	{ 0x15, KEY_6 },		/* 6 */
-	{ 0x06, KEY_7 },		/* 7 */
-	{ 0x0a, KEY_8 },		/* 8 */
-	{ 0x12, KEY_9 },		/* 9 */
-	{ 0x02, KEY_0 },		/* 0 */
-	{ 0x10, KEY_KPPLUS },		/* + */
-	{ 0x13, KEY_AGAIN },		/* Recall */
-
-	{ 0x1e, KEY_POWER },		/* Power */
-	{ 0x07, KEY_TUNER },		/* Source */
-	{ 0x1c, KEY_SEARCH },		/* Scan */
-	{ 0x18, KEY_MUTE },		/* Mute */
-
-	{ 0x03, KEY_RADIO },		/* TV/FM */
-	/* The next four keys are duplicates that appear to send the
-	   same IR code as Ch+, Ch-, >>, and << .  The raw code assigned
-	   to them is the actual code + 0x20 - they will never be
-	   detected as such unless some way is discovered to distinguish
-	   these buttons from those that have the same code. */
-	{ 0x3f, KEY_RIGHT },		/* |> and Ch+ */
-	{ 0x37, KEY_LEFT },		/* <| and Ch- */
-	{ 0x2c, KEY_UP },		/* ^^Up and >> */
-	{ 0x24, KEY_DOWN },		/* vvDn and << */
-
-	{ 0x00, KEY_RECORD },		/* Record */
-	{ 0x08, KEY_STOP },		/* Stop */
-	{ 0x11, KEY_PLAY },		/* Play */
-
-	{ 0x0f, KEY_CLOSE },		/* Minimize */
-	{ 0x19, KEY_ZOOM },		/* Zoom */
-	{ 0x1a, KEY_CAMERA },		/* Snapshot */
-	{ 0x0d, KEY_LANGUAGE },		/* MTS */
-
-	{ 0x14, KEY_VOLUMEDOWN },	/* Vol- */
-	{ 0x16, KEY_VOLUMEUP },		/* Vol+ */
-	{ 0x17, KEY_CHANNELDOWN },	/* Ch- */
-	{ 0x1f, KEY_CHANNELUP },	/* Ch+ */
-
-	{ 0x04, KEY_REWIND },		/* << */
-	{ 0x0e, KEY_MENU },		/* Function */
-	{ 0x0c, KEY_FASTFORWARD },	/* >> */
-	{ 0x1d, KEY_RESTART },		/* Reset */
-};
-DEFINE_LEGACY_IR_KEYTABLE(msi_tvanywhere_plus);
-
-/* ---------------------------------------------------------------------- */
-
-/* Cinergy 1400 DVB-T */
-static struct ir_scancode cinergy_1400[] = {
-	{ 0x01, KEY_POWER },
-	{ 0x02, KEY_1 },
-	{ 0x03, KEY_2 },
-	{ 0x04, KEY_3 },
-	{ 0x05, KEY_4 },
-	{ 0x06, KEY_5 },
-	{ 0x07, KEY_6 },
-	{ 0x08, KEY_7 },
-	{ 0x09, KEY_8 },
-	{ 0x0a, KEY_9 },
-	{ 0x0c, KEY_0 },
-
-	{ 0x0b, KEY_VIDEO },
-	{ 0x0d, KEY_REFRESH },
-	{ 0x0e, KEY_SELECT },
-	{ 0x0f, KEY_EPG },
-	{ 0x10, KEY_UP },
-	{ 0x11, KEY_LEFT },
-	{ 0x12, KEY_OK },
-	{ 0x13, KEY_RIGHT },
-	{ 0x14, KEY_DOWN },
-	{ 0x15, KEY_TEXT },
-	{ 0x16, KEY_INFO },
-
-	{ 0x17, KEY_RED },
-	{ 0x18, KEY_GREEN },
-	{ 0x19, KEY_YELLOW },
-	{ 0x1a, KEY_BLUE },
-
-	{ 0x1b, KEY_CHANNELUP },
-	{ 0x1c, KEY_VOLUMEUP },
-	{ 0x1d, KEY_MUTE },
-	{ 0x1e, KEY_VOLUMEDOWN },
-	{ 0x1f, KEY_CHANNELDOWN },
-
-	{ 0x40, KEY_PAUSE },
-	{ 0x4c, KEY_PLAY },
-	{ 0x58, KEY_RECORD },
-	{ 0x54, KEY_PREVIOUS },
-	{ 0x48, KEY_STOP },
-	{ 0x5c, KEY_NEXT },
-};
-DEFINE_LEGACY_IR_KEYTABLE(cinergy_1400);
-
-/* ---------------------------------------------------------------------- */
-
-/* AVERTV STUDIO 303 Remote */
-static struct ir_scancode avertv_303[] = {
-	{ 0x2a, KEY_1 },
-	{ 0x32, KEY_2 },
-	{ 0x3a, KEY_3 },
-	{ 0x4a, KEY_4 },
-	{ 0x52, KEY_5 },
-	{ 0x5a, KEY_6 },
-	{ 0x6a, KEY_7 },
-	{ 0x72, KEY_8 },
-	{ 0x7a, KEY_9 },
-	{ 0x0e, KEY_0 },
-
-	{ 0x02, KEY_POWER },
-	{ 0x22, KEY_VIDEO },
-	{ 0x42, KEY_AUDIO },
-	{ 0x62, KEY_ZOOM },
-	{ 0x0a, KEY_TV },
-	{ 0x12, KEY_CD },
-	{ 0x1a, KEY_TEXT },
-
-	{ 0x16, KEY_SUBTITLE },
-	{ 0x1e, KEY_REWIND },
-	{ 0x06, KEY_PRINT },
-
-	{ 0x2e, KEY_SEARCH },
-	{ 0x36, KEY_SLEEP },
-	{ 0x3e, KEY_SHUFFLE },
-	{ 0x26, KEY_MUTE },
-
-	{ 0x4e, KEY_RECORD },
-	{ 0x56, KEY_PAUSE },
-	{ 0x5e, KEY_STOP },
-	{ 0x46, KEY_PLAY },
-
-	{ 0x6e, KEY_RED },
-	{ 0x0b, KEY_GREEN },
-	{ 0x66, KEY_YELLOW },
-	{ 0x03, KEY_BLUE },
-
-	{ 0x76, KEY_LEFT },
-	{ 0x7e, KEY_RIGHT },
-	{ 0x13, KEY_DOWN },
-	{ 0x1b, KEY_UP },
-};
-DEFINE_LEGACY_IR_KEYTABLE(avertv_303);
-
-/* ---------------------------------------------------------------------- */
-
-/* DigitalNow DNTV Live! DVB-T Pro Remote */
-static struct ir_scancode dntv_live_dvbt_pro[] = {
-	{ 0x16, KEY_POWER },
-	{ 0x5b, KEY_HOME },
-
-	{ 0x55, KEY_TV },		/* live tv */
-	{ 0x58, KEY_TUNER },		/* digital Radio */
-	{ 0x5a, KEY_RADIO },		/* FM radio */
-	{ 0x59, KEY_DVD },		/* dvd menu */
-	{ 0x03, KEY_1 },
-	{ 0x01, KEY_2 },
-	{ 0x06, KEY_3 },
-	{ 0x09, KEY_4 },
-	{ 0x1d, KEY_5 },
-	{ 0x1f, KEY_6 },
-	{ 0x0d, KEY_7 },
-	{ 0x19, KEY_8 },
-	{ 0x1b, KEY_9 },
-	{ 0x0c, KEY_CANCEL },
-	{ 0x15, KEY_0 },
-	{ 0x4a, KEY_CLEAR },
-	{ 0x13, KEY_BACK },
-	{ 0x00, KEY_TAB },
-	{ 0x4b, KEY_UP },
-	{ 0x4e, KEY_LEFT },
-	{ 0x4f, KEY_OK },
-	{ 0x52, KEY_RIGHT },
-	{ 0x51, KEY_DOWN },
-	{ 0x1e, KEY_VOLUMEUP },
-	{ 0x0a, KEY_VOLUMEDOWN },
-	{ 0x02, KEY_CHANNELDOWN },
-	{ 0x05, KEY_CHANNELUP },
-	{ 0x11, KEY_RECORD },
-	{ 0x14, KEY_PLAY },
-	{ 0x4c, KEY_PAUSE },
-	{ 0x1a, KEY_STOP },
-	{ 0x40, KEY_REWIND },
-	{ 0x12, KEY_FASTFORWARD },
-	{ 0x41, KEY_PREVIOUSSONG },	/* replay |< */
-	{ 0x42, KEY_NEXTSONG },		/* skip >| */
-	{ 0x54, KEY_CAMERA },		/* capture */
-	{ 0x50, KEY_LANGUAGE },		/* sap */
-	{ 0x47, KEY_TV2 },		/* pip */
-	{ 0x4d, KEY_SCREEN },
-	{ 0x43, KEY_SUBTITLE },
-	{ 0x10, KEY_MUTE },
-	{ 0x49, KEY_AUDIO },		/* l/r */
-	{ 0x07, KEY_SLEEP },
-	{ 0x08, KEY_VIDEO },		/* a/v */
-	{ 0x0e, KEY_PREVIOUS },		/* recall */
-	{ 0x45, KEY_ZOOM },		/* zoom + */
-	{ 0x46, KEY_ANGLE },		/* zoom - */
-	{ 0x56, KEY_RED },
-	{ 0x57, KEY_GREEN },
-	{ 0x5c, KEY_YELLOW },
-	{ 0x5d, KEY_BLUE },
-};
-DEFINE_LEGACY_IR_KEYTABLE(dntv_live_dvbt_pro);
-
-static struct ir_scancode em_terratec[] = {
-	{ 0x01, KEY_CHANNEL },
-	{ 0x02, KEY_SELECT },
-	{ 0x03, KEY_MUTE },
-	{ 0x04, KEY_POWER },
-	{ 0x05, KEY_1 },
-	{ 0x06, KEY_2 },
-	{ 0x07, KEY_3 },
-	{ 0x08, KEY_CHANNELUP },
-	{ 0x09, KEY_4 },
-	{ 0x0a, KEY_5 },
-	{ 0x0b, KEY_6 },
-	{ 0x0c, KEY_CHANNELDOWN },
-	{ 0x0d, KEY_7 },
-	{ 0x0e, KEY_8 },
-	{ 0x0f, KEY_9 },
-	{ 0x10, KEY_VOLUMEUP },
-	{ 0x11, KEY_0 },
-	{ 0x12, KEY_MENU },
-	{ 0x13, KEY_PRINT },
-	{ 0x14, KEY_VOLUMEDOWN },
-	{ 0x16, KEY_PAUSE },
-	{ 0x18, KEY_RECORD },
-	{ 0x19, KEY_REWIND },
-	{ 0x1a, KEY_PLAY },
-	{ 0x1b, KEY_FORWARD },
-	{ 0x1c, KEY_BACKSPACE },
-	{ 0x1e, KEY_STOP },
-	{ 0x40, KEY_ZOOM },
-};
-DEFINE_LEGACY_IR_KEYTABLE(em_terratec);
-
-static struct ir_scancode pinnacle_grey[] = {
-	{ 0x3a, KEY_0 },
-	{ 0x31, KEY_1 },
-	{ 0x32, KEY_2 },
-	{ 0x33, KEY_3 },
-	{ 0x34, KEY_4 },
-	{ 0x35, KEY_5 },
-	{ 0x36, KEY_6 },
-	{ 0x37, KEY_7 },
-	{ 0x38, KEY_8 },
-	{ 0x39, KEY_9 },
-
-	{ 0x2f, KEY_POWER },
-
-	{ 0x2e, KEY_P },
-	{ 0x1f, KEY_L },
-	{ 0x2b, KEY_I },
-
-	{ 0x2d, KEY_SCREEN },
-	{ 0x1e, KEY_ZOOM },
-	{ 0x1b, KEY_VOLUMEUP },
-	{ 0x0f, KEY_VOLUMEDOWN },
-	{ 0x17, KEY_CHANNELUP },
-	{ 0x1c, KEY_CHANNELDOWN },
-	{ 0x25, KEY_INFO },
-
-	{ 0x3c, KEY_MUTE },
-
-	{ 0x3d, KEY_LEFT },
-	{ 0x3b, KEY_RIGHT },
-
-	{ 0x3f, KEY_UP },
-	{ 0x3e, KEY_DOWN },
-	{ 0x1a, KEY_ENTER },
-
-	{ 0x1d, KEY_MENU },
-	{ 0x19, KEY_AGAIN },
-	{ 0x16, KEY_PREVIOUSSONG },
-	{ 0x13, KEY_NEXTSONG },
-	{ 0x15, KEY_PAUSE },
-	{ 0x0e, KEY_REWIND },
-	{ 0x0d, KEY_PLAY },
-	{ 0x0b, KEY_STOP },
-	{ 0x07, KEY_FORWARD },
-	{ 0x27, KEY_RECORD },
-	{ 0x26, KEY_TUNER },
-	{ 0x29, KEY_TEXT },
-	{ 0x2a, KEY_MEDIA },
-	{ 0x18, KEY_EPG },
-};
-DEFINE_LEGACY_IR_KEYTABLE(pinnacle_grey);
-
-static struct ir_scancode flyvideo[] = {
-	{ 0x0f, KEY_0 },
-	{ 0x03, KEY_1 },
-	{ 0x04, KEY_2 },
-	{ 0x05, KEY_3 },
-	{ 0x07, KEY_4 },
-	{ 0x08, KEY_5 },
-	{ 0x09, KEY_6 },
-	{ 0x0b, KEY_7 },
-	{ 0x0c, KEY_8 },
-	{ 0x0d, KEY_9 },
-
-	{ 0x0e, KEY_MODE },	/* Air/Cable */
-	{ 0x11, KEY_VIDEO },	/* Video */
-	{ 0x15, KEY_AUDIO },	/* Audio */
-	{ 0x00, KEY_POWER },	/* Power */
-	{ 0x18, KEY_TUNER },	/* AV Source */
-	{ 0x02, KEY_ZOOM },	/* Fullscreen */
-	{ 0x1a, KEY_LANGUAGE },	/* Stereo */
-	{ 0x1b, KEY_MUTE },	/* Mute */
-	{ 0x14, KEY_VOLUMEUP },	/* Volume + */
-	{ 0x17, KEY_VOLUMEDOWN },/* Volume - */
-	{ 0x12, KEY_CHANNELUP },/* Channel + */
-	{ 0x13, KEY_CHANNELDOWN },/* Channel - */
-	{ 0x06, KEY_AGAIN },	/* Recall */
-	{ 0x10, KEY_ENTER },	/* Enter */
-
-	{ 0x19, KEY_BACK },	/* Rewind  ( <<< ) */
-	{ 0x1f, KEY_FORWARD },	/* Forward ( >>> ) */
-	{ 0x0a, KEY_ANGLE },	/* no label, may be used as the PAUSE button */
-};
-DEFINE_LEGACY_IR_KEYTABLE(flyvideo);
-
-static struct ir_scancode flydvb[] = {
-	{ 0x01, KEY_ZOOM },		/* Full Screen */
-	{ 0x00, KEY_POWER },		/* Power */
-
-	{ 0x03, KEY_1 },
-	{ 0x04, KEY_2 },
-	{ 0x05, KEY_3 },
-	{ 0x07, KEY_4 },
-	{ 0x08, KEY_5 },
-	{ 0x09, KEY_6 },
-	{ 0x0b, KEY_7 },
-	{ 0x0c, KEY_8 },
-	{ 0x0d, KEY_9 },
-	{ 0x06, KEY_AGAIN },		/* Recall */
-	{ 0x0f, KEY_0 },
-	{ 0x10, KEY_MUTE },		/* Mute */
-	{ 0x02, KEY_RADIO },		/* TV/Radio */
-	{ 0x1b, KEY_LANGUAGE },		/* SAP (Second Audio Program) */
-
-	{ 0x14, KEY_VOLUMEUP },		/* VOL+ */
-	{ 0x17, KEY_VOLUMEDOWN },	/* VOL- */
-	{ 0x12, KEY_CHANNELUP },	/* CH+ */
-	{ 0x13, KEY_CHANNELDOWN },	/* CH- */
-	{ 0x1d, KEY_ENTER },		/* Enter */
-
-	{ 0x1a, KEY_MODE },		/* PIP */
-	{ 0x18, KEY_TUNER },		/* Source */
-
-	{ 0x1e, KEY_RECORD },		/* Record/Pause */
-	{ 0x15, KEY_ANGLE },		/* Swap (no label on key) */
-	{ 0x1c, KEY_PAUSE },		/* Timeshift/Pause */
-	{ 0x19, KEY_BACK },		/* Rewind << */
-	{ 0x0a, KEY_PLAYPAUSE },	/* Play/Pause */
-	{ 0x1f, KEY_FORWARD },		/* Forward >> */
-	{ 0x16, KEY_PREVIOUS },		/* Back |<< */
-	{ 0x11, KEY_STOP },		/* Stop */
-	{ 0x0e, KEY_NEXT },		/* End >>| */
-};
-DEFINE_LEGACY_IR_KEYTABLE(flydvb);
-
-static struct ir_scancode cinergy[] = {
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x0a, KEY_POWER },
-	{ 0x0b, KEY_PROG1 },		/* app */
-	{ 0x0c, KEY_ZOOM },		/* zoom/fullscreen */
-	{ 0x0d, KEY_CHANNELUP },	/* channel */
-	{ 0x0e, KEY_CHANNELDOWN },	/* channel- */
-	{ 0x0f, KEY_VOLUMEUP },
-	{ 0x10, KEY_VOLUMEDOWN },
-	{ 0x11, KEY_TUNER },		/* AV */
-	{ 0x12, KEY_NUMLOCK },		/* -/-- */
-	{ 0x13, KEY_AUDIO },		/* audio */
-	{ 0x14, KEY_MUTE },
-	{ 0x15, KEY_UP },
-	{ 0x16, KEY_DOWN },
-	{ 0x17, KEY_LEFT },
-	{ 0x18, KEY_RIGHT },
-	{ 0x19, BTN_LEFT, },
-	{ 0x1a, BTN_RIGHT, },
-	{ 0x1b, KEY_WWW },		/* text */
-	{ 0x1c, KEY_REWIND },
-	{ 0x1d, KEY_FORWARD },
-	{ 0x1e, KEY_RECORD },
-	{ 0x1f, KEY_PLAY },
-	{ 0x20, KEY_PREVIOUSSONG },
-	{ 0x21, KEY_NEXTSONG },
-	{ 0x22, KEY_PAUSE },
-	{ 0x23, KEY_STOP },
-};
-DEFINE_LEGACY_IR_KEYTABLE(cinergy);
-
-/* Alfons Geser <a.geser@cox.net>
- * updates from Job D. R. Borges <jobdrb@ig.com.br> */
-static struct ir_scancode eztv[] = {
-	{ 0x12, KEY_POWER },
-	{ 0x01, KEY_TV },	/* DVR */
-	{ 0x15, KEY_DVD },	/* DVD */
-	{ 0x17, KEY_AUDIO },	/* music */
-				/* DVR mode / DVD mode / music mode */
-
-	{ 0x1b, KEY_MUTE },	/* mute */
-	{ 0x02, KEY_LANGUAGE },	/* MTS/SAP / audio / autoseek */
-	{ 0x1e, KEY_SUBTITLE },	/* closed captioning / subtitle / seek */
-	{ 0x16, KEY_ZOOM },	/* full screen */
-	{ 0x1c, KEY_VIDEO },	/* video source / eject / delall */
-	{ 0x1d, KEY_RESTART },	/* playback / angle / del */
-	{ 0x2f, KEY_SEARCH },	/* scan / menu / playlist */
-	{ 0x30, KEY_CHANNEL },	/* CH surfing / bookmark / memo */
-
-	{ 0x31, KEY_HELP },	/* help */
-	{ 0x32, KEY_MODE },	/* num/memo */
-	{ 0x33, KEY_ESC },	/* cancel */
-
-	{ 0x0c, KEY_UP },	/* up */
-	{ 0x10, KEY_DOWN },	/* down */
-	{ 0x08, KEY_LEFT },	/* left */
-	{ 0x04, KEY_RIGHT },	/* right */
-	{ 0x03, KEY_SELECT },	/* select */
-
-	{ 0x1f, KEY_REWIND },	/* rewind */
-	{ 0x20, KEY_PLAYPAUSE },/* play/pause */
-	{ 0x29, KEY_FORWARD },	/* forward */
-	{ 0x14, KEY_AGAIN },	/* repeat */
-	{ 0x2b, KEY_RECORD },	/* recording */
-	{ 0x2c, KEY_STOP },	/* stop */
-	{ 0x2d, KEY_PLAY },	/* play */
-	{ 0x2e, KEY_CAMERA },	/* snapshot / shuffle */
-
-	{ 0x00, KEY_0 },
-	{ 0x05, KEY_1 },
-	{ 0x06, KEY_2 },
-	{ 0x07, KEY_3 },
-	{ 0x09, KEY_4 },
-	{ 0x0a, KEY_5 },
-	{ 0x0b, KEY_6 },
-	{ 0x0d, KEY_7 },
-	{ 0x0e, KEY_8 },
-	{ 0x0f, KEY_9 },
-
-	{ 0x2a, KEY_VOLUMEUP },
-	{ 0x11, KEY_VOLUMEDOWN },
-	{ 0x18, KEY_CHANNELUP },/* CH.tracking up */
-	{ 0x19, KEY_CHANNELDOWN },/* CH.tracking down */
-
-	{ 0x13, KEY_ENTER },	/* enter */
-	{ 0x21, KEY_DOT },	/* . (decimal dot) */
-};
-DEFINE_LEGACY_IR_KEYTABLE(eztv);
-
-/* Alex Hermann <gaaf@gmx.net> */
-static struct ir_scancode avermedia[] = {
-	{ 0x28, KEY_1 },
-	{ 0x18, KEY_2 },
-	{ 0x38, KEY_3 },
-	{ 0x24, KEY_4 },
-	{ 0x14, KEY_5 },
-	{ 0x34, KEY_6 },
-	{ 0x2c, KEY_7 },
-	{ 0x1c, KEY_8 },
-	{ 0x3c, KEY_9 },
-	{ 0x22, KEY_0 },
-
-	{ 0x20, KEY_TV },		/* TV/FM */
-	{ 0x10, KEY_CD },		/* CD */
-	{ 0x30, KEY_TEXT },		/* TELETEXT */
-	{ 0x00, KEY_POWER },		/* POWER */
-
-	{ 0x08, KEY_VIDEO },		/* VIDEO */
-	{ 0x04, KEY_AUDIO },		/* AUDIO */
-	{ 0x0c, KEY_ZOOM },		/* FULL SCREEN */
-
-	{ 0x12, KEY_SUBTITLE },		/* DISPLAY */
-	{ 0x32, KEY_REWIND },		/* LOOP	*/
-	{ 0x02, KEY_PRINT },		/* PREVIEW */
-
-	{ 0x2a, KEY_SEARCH },		/* AUTOSCAN */
-	{ 0x1a, KEY_SLEEP },		/* FREEZE */
-	{ 0x3a, KEY_CAMERA },		/* SNAPSHOT */
-	{ 0x0a, KEY_MUTE },		/* MUTE */
-
-	{ 0x26, KEY_RECORD },		/* RECORD */
-	{ 0x16, KEY_PAUSE },		/* PAUSE */
-	{ 0x36, KEY_STOP },		/* STOP */
-	{ 0x06, KEY_PLAY },		/* PLAY */
-
-	{ 0x2e, KEY_RED },		/* RED */
-	{ 0x21, KEY_GREEN },		/* GREEN */
-	{ 0x0e, KEY_YELLOW },		/* YELLOW */
-	{ 0x01, KEY_BLUE },		/* BLUE */
-
-	{ 0x1e, KEY_VOLUMEDOWN },	/* VOLUME- */
-	{ 0x3e, KEY_VOLUMEUP },		/* VOLUME+ */
-	{ 0x11, KEY_CHANNELDOWN },	/* CHANNEL/PAGE- */
-	{ 0x31, KEY_CHANNELUP }		/* CHANNEL/PAGE+ */
-};
-DEFINE_LEGACY_IR_KEYTABLE(avermedia);
-
-static struct ir_scancode videomate_tv_pvr[] = {
-	{ 0x14, KEY_MUTE },
-	{ 0x24, KEY_ZOOM },
-
-	{ 0x01, KEY_DVD },
-	{ 0x23, KEY_RADIO },
-	{ 0x00, KEY_TV },
-
-	{ 0x0a, KEY_REWIND },
-	{ 0x08, KEY_PLAYPAUSE },
-	{ 0x0f, KEY_FORWARD },
-
-	{ 0x02, KEY_PREVIOUS },
-	{ 0x07, KEY_STOP },
-	{ 0x06, KEY_NEXT },
-
-	{ 0x0c, KEY_UP },
-	{ 0x0e, KEY_DOWN },
-	{ 0x0b, KEY_LEFT },
-	{ 0x0d, KEY_RIGHT },
-	{ 0x11, KEY_OK },
-
-	{ 0x03, KEY_MENU },
-	{ 0x09, KEY_SETUP },
-	{ 0x05, KEY_VIDEO },
-	{ 0x22, KEY_CHANNEL },
-
-	{ 0x12, KEY_VOLUMEUP },
-	{ 0x15, KEY_VOLUMEDOWN },
-	{ 0x10, KEY_CHANNELUP },
-	{ 0x13, KEY_CHANNELDOWN },
-
-	{ 0x04, KEY_RECORD },
-
-	{ 0x16, KEY_1 },
-	{ 0x17, KEY_2 },
-	{ 0x18, KEY_3 },
-	{ 0x19, KEY_4 },
-	{ 0x1a, KEY_5 },
-	{ 0x1b, KEY_6 },
-	{ 0x1c, KEY_7 },
-	{ 0x1d, KEY_8 },
-	{ 0x1e, KEY_9 },
-	{ 0x1f, KEY_0 },
-
-	{ 0x20, KEY_LANGUAGE },
-	{ 0x21, KEY_SLEEP },
-};
-DEFINE_LEGACY_IR_KEYTABLE(videomate_tv_pvr);
-
-/* Michael Tokarev <mjt@tls.msk.ru>
-   http://www.corpit.ru/mjt/beholdTV/remote_control.jpg
-   keytable is used by MANLI MTV00[0x0c] and BeholdTV 40[13] at
-   least, and probably other cards too.
-   The "ascii-art picture" below (in comments, first row
-   is the keycode in hex, and subsequent row(s) shows
-   the button labels (several variants when appropriate)
-   helps to descide which keycodes to assign to the buttons.
+ * All keytables got moved to include/media/keytables directory.
+ * This file is still needed - at least for now, as their data is
+ * dynamically inserted here by the media/ir-common.h, due to the
+ * #define IR_KEYMAPS line, at the beginning of this file. The
+ * plans are to get rid of this file completely in a near future.
  */
-static struct ir_scancode manli[] = {
-
-	/*  0x1c            0x12  *
-	 * FUNCTION         POWER *
-	 *   FM              (|)  *
-	 *                        */
-	{ 0x1c, KEY_RADIO },	/*XXX*/
-	{ 0x12, KEY_POWER },
-
-	/*  0x01    0x02    0x03  *
-	 *   1       2       3    *
-	 *                        *
-	 *  0x04    0x05    0x06  *
-	 *   4       5       6    *
-	 *                        *
-	 *  0x07    0x08    0x09  *
-	 *   7       8       9    *
-	 *                        */
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	/*  0x0a    0x00    0x17  *
-	 * RECALL    0      +100  *
-	 *                  PLUS  *
-	 *                        */
-	{ 0x0a, KEY_AGAIN },	/*XXX KEY_REWIND? */
-	{ 0x00, KEY_0 },
-	{ 0x17, KEY_DIGITS },	/*XXX*/
-
-	/*  0x14            0x10  *
-	 *  MENU            INFO  *
-	 *  OSD                   */
-	{ 0x14, KEY_MENU },
-	{ 0x10, KEY_INFO },
-
-	/*          0x0b          *
-	 *           Up           *
-	 *                        *
-	 *  0x18    0x16    0x0c  *
-	 *  Left     Ok     Right *
-	 *                        *
-	 *         0x015          *
-	 *         Down           *
-	 *                        */
-	{ 0x0b, KEY_UP },
-	{ 0x18, KEY_LEFT },
-	{ 0x16, KEY_OK },	/*XXX KEY_SELECT? KEY_ENTER? */
-	{ 0x0c, KEY_RIGHT },
-	{ 0x15, KEY_DOWN },
-
-	/*  0x11            0x0d  *
-	 *  TV/AV           MODE  *
-	 *  SOURCE         STEREO *
-	 *                        */
-	{ 0x11, KEY_TV },	/*XXX*/
-	{ 0x0d, KEY_MODE },	/*XXX there's no KEY_STEREO	*/
-
-	/*  0x0f    0x1b    0x1a  *
-	 *  AUDIO   Vol+    Chan+ *
-	 *        TIMESHIFT???    *
-	 *                        *
-	 *  0x0e    0x1f    0x1e  *
-	 *  SLEEP   Vol-    Chan- *
-	 *                        */
-	{ 0x0f, KEY_AUDIO },
-	{ 0x1b, KEY_VOLUMEUP },
-	{ 0x1a, KEY_CHANNELUP },
-	{ 0x0e, KEY_TIME },
-	{ 0x1f, KEY_VOLUMEDOWN },
-	{ 0x1e, KEY_CHANNELDOWN },
-
-	/*         0x13     0x19  *
-	 *         MUTE   SNAPSHOT*
-	 *                        */
-	{ 0x13, KEY_MUTE },
-	{ 0x19, KEY_CAMERA },
-
-	/* 0x1d unused ? */
-};
-DEFINE_LEGACY_IR_KEYTABLE(manli);
-
-/* Mike Baikov <mike@baikov.com> */
-static struct ir_scancode gotview7135[] = {
-
-	{ 0x11, KEY_POWER },
-	{ 0x35, KEY_TV },
-	{ 0x1b, KEY_0 },
-	{ 0x29, KEY_1 },
-	{ 0x19, KEY_2 },
-	{ 0x39, KEY_3 },
-	{ 0x1f, KEY_4 },
-	{ 0x2c, KEY_5 },
-	{ 0x21, KEY_6 },
-	{ 0x24, KEY_7 },
-	{ 0x18, KEY_8 },
-	{ 0x2b, KEY_9 },
-	{ 0x3b, KEY_AGAIN },	/* LOOP */
-	{ 0x06, KEY_AUDIO },
-	{ 0x31, KEY_PRINT },	/* PREVIEW */
-	{ 0x3e, KEY_VIDEO },
-	{ 0x10, KEY_CHANNELUP },
-	{ 0x20, KEY_CHANNELDOWN },
-	{ 0x0c, KEY_VOLUMEDOWN },
-	{ 0x28, KEY_VOLUMEUP },
-	{ 0x08, KEY_MUTE },
-	{ 0x26, KEY_SEARCH },	/* SCAN */
-	{ 0x3f, KEY_CAMERA },	/* SNAPSHOT */
-	{ 0x12, KEY_RECORD },
-	{ 0x32, KEY_STOP },
-	{ 0x3c, KEY_PLAY },
-	{ 0x1d, KEY_REWIND },
-	{ 0x2d, KEY_PAUSE },
-	{ 0x0d, KEY_FORWARD },
-	{ 0x05, KEY_ZOOM },	/*FULL*/
-
-	{ 0x2a, KEY_F21 },	/* LIVE TIMESHIFT */
-	{ 0x0e, KEY_F22 },	/* MIN TIMESHIFT */
-	{ 0x1e, KEY_TIME },	/* TIMESHIFT */
-	{ 0x38, KEY_F24 },	/* NORMAL TIMESHIFT */
-};
-DEFINE_LEGACY_IR_KEYTABLE(gotview7135);
-
-static struct ir_scancode purpletv[] = {
-	{ 0x03, KEY_POWER },
-	{ 0x6f, KEY_MUTE },
-	{ 0x10, KEY_BACKSPACE },	/* Recall */
-
-	{ 0x11, KEY_0 },
-	{ 0x04, KEY_1 },
-	{ 0x05, KEY_2 },
-	{ 0x06, KEY_3 },
-	{ 0x08, KEY_4 },
-	{ 0x09, KEY_5 },
-	{ 0x0a, KEY_6 },
-	{ 0x0c, KEY_7 },
-	{ 0x0d, KEY_8 },
-	{ 0x0e, KEY_9 },
-	{ 0x12, KEY_DOT },	/* 100+ */
-
-	{ 0x07, KEY_VOLUMEUP },
-	{ 0x0b, KEY_VOLUMEDOWN },
-	{ 0x1a, KEY_KPPLUS },
-	{ 0x18, KEY_KPMINUS },
-	{ 0x15, KEY_UP },
-	{ 0x1d, KEY_DOWN },
-	{ 0x0f, KEY_CHANNELUP },
-	{ 0x13, KEY_CHANNELDOWN },
-	{ 0x48, KEY_ZOOM },
-
-	{ 0x1b, KEY_VIDEO },	/* Video source */
-	{ 0x1f, KEY_CAMERA },	/* Snapshot */
-	{ 0x49, KEY_LANGUAGE },	/* MTS Select */
-	{ 0x19, KEY_SEARCH },	/* Auto Scan */
-
-	{ 0x4b, KEY_RECORD },
-	{ 0x46, KEY_PLAY },
-	{ 0x45, KEY_PAUSE },	/* Pause */
-	{ 0x44, KEY_STOP },
-	{ 0x43, KEY_TIME },	/* Time Shift */
-	{ 0x17, KEY_CHANNEL },	/* SURF CH */
-	{ 0x40, KEY_FORWARD },	/* Forward ? */
-	{ 0x42, KEY_REWIND },	/* Backward ? */
-
-};
-DEFINE_LEGACY_IR_KEYTABLE(purpletv);
-
-/* Mapping for the 28 key remote control as seen at
-   http://www.sednacomputer.com/photo/cardbus-tv.jpg
-   Pavel Mihaylov <bin@bash.info>
-   Also for the remote bundled with Kozumi KTV-01C card */
-static struct ir_scancode pctv_sedna[] = {
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x0a, KEY_AGAIN },	/* Recall */
-	{ 0x0b, KEY_CHANNELUP },
-	{ 0x0c, KEY_VOLUMEUP },
-	{ 0x0d, KEY_MODE },	/* Stereo */
-	{ 0x0e, KEY_STOP },
-	{ 0x0f, KEY_PREVIOUSSONG },
-	{ 0x10, KEY_ZOOM },
-	{ 0x11, KEY_TUNER },	/* Source */
-	{ 0x12, KEY_POWER },
-	{ 0x13, KEY_MUTE },
-	{ 0x15, KEY_CHANNELDOWN },
-	{ 0x18, KEY_VOLUMEDOWN },
-	{ 0x19, KEY_CAMERA },	/* Snapshot */
-	{ 0x1a, KEY_NEXTSONG },
-	{ 0x1b, KEY_TIME },	/* Time Shift */
-	{ 0x1c, KEY_RADIO },	/* FM Radio */
-	{ 0x1d, KEY_RECORD },
-	{ 0x1e, KEY_PAUSE },
-	/* additional codes for Kozumi's remote */
-	{ 0x14, KEY_INFO },	/* OSD */
-	{ 0x16, KEY_OK },	/* OK */
-	{ 0x17, KEY_DIGITS },	/* Plus */
-	{ 0x1f, KEY_PLAY },	/* Play */
-};
-DEFINE_LEGACY_IR_KEYTABLE(pctv_sedna);
-
-/* Mark Phalan <phalanm@o2.ie> */
-static struct ir_scancode pv951[] = {
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x12, KEY_POWER },
-	{ 0x10, KEY_MUTE },
-	{ 0x1f, KEY_VOLUMEDOWN },
-	{ 0x1b, KEY_VOLUMEUP },
-	{ 0x1a, KEY_CHANNELUP },
-	{ 0x1e, KEY_CHANNELDOWN },
-	{ 0x0e, KEY_PAGEUP },
-	{ 0x1d, KEY_PAGEDOWN },
-	{ 0x13, KEY_SOUND },
-
-	{ 0x18, KEY_KPPLUSMINUS },	/* CH +/- */
-	{ 0x16, KEY_SUBTITLE },		/* CC */
-	{ 0x0d, KEY_TEXT },		/* TTX */
-	{ 0x0b, KEY_TV },		/* AIR/CBL */
-	{ 0x11, KEY_PC },		/* PC/TV */
-	{ 0x17, KEY_OK },		/* CH RTN */
-	{ 0x19, KEY_MODE },		/* FUNC */
-	{ 0x0c, KEY_SEARCH },		/* AUTOSCAN */
-
-	/* Not sure what to do with these ones! */
-	{ 0x0f, KEY_SELECT },		/* SOURCE */
-	{ 0x0a, KEY_KPPLUS },		/* +100 */
-	{ 0x14, KEY_EQUAL },		/* SYNC */
-	{ 0x1c, KEY_MEDIA },		/* PC/TV */
-};
-DEFINE_LEGACY_IR_KEYTABLE(pv951);
-
-/* generic RC5 keytable                                          */
-/* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
-/* used by old (black) Hauppauge remotes                         */
-static struct ir_scancode rc5_tv[] = {
-	/* Keys 0 to 9 */
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x0b, KEY_CHANNEL },		/* channel / program (japan: 11) */
-	{ 0x0c, KEY_POWER },		/* standby */
-	{ 0x0d, KEY_MUTE },		/* mute / demute */
-	{ 0x0f, KEY_TV },		/* display */
-	{ 0x10, KEY_VOLUMEUP },
-	{ 0x11, KEY_VOLUMEDOWN },
-	{ 0x12, KEY_BRIGHTNESSUP },
-	{ 0x13, KEY_BRIGHTNESSDOWN },
-	{ 0x1e, KEY_SEARCH },		/* search + */
-	{ 0x20, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x21, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x22, KEY_CHANNEL },		/* alt / channel */
-	{ 0x23, KEY_LANGUAGE },		/* 1st / 2nd language */
-	{ 0x26, KEY_SLEEP },		/* sleeptimer */
-	{ 0x2e, KEY_MENU },		/* 2nd controls (USA: menu) */
-	{ 0x30, KEY_PAUSE },
-	{ 0x32, KEY_REWIND },
-	{ 0x33, KEY_GOTO },
-	{ 0x35, KEY_PLAY },
-	{ 0x36, KEY_STOP },
-	{ 0x37, KEY_RECORD },		/* recording */
-	{ 0x3c, KEY_TEXT },		/* teletext submode (Japan: 12) */
-	{ 0x3d, KEY_SUSPEND },		/* system standby */
-
-};
-DEFINE_LEGACY_IR_KEYTABLE(rc5_tv);
-
-/* Table for Leadtek Winfast Remote Controls - used by both bttv and cx88 */
-static struct ir_scancode winfast[] = {
-	/* Keys 0 to 9 */
-	{ 0x12, KEY_0 },
-	{ 0x05, KEY_1 },
-	{ 0x06, KEY_2 },
-	{ 0x07, KEY_3 },
-	{ 0x09, KEY_4 },
-	{ 0x0a, KEY_5 },
-	{ 0x0b, KEY_6 },
-	{ 0x0d, KEY_7 },
-	{ 0x0e, KEY_8 },
-	{ 0x0f, KEY_9 },
-
-	{ 0x00, KEY_POWER },
-	{ 0x1b, KEY_AUDIO },		/* Audio Source */
-	{ 0x02, KEY_TUNER },		/* TV/FM, not on Y0400052 */
-	{ 0x1e, KEY_VIDEO },		/* Video Source */
-	{ 0x16, KEY_INFO },		/* Display information */
-	{ 0x04, KEY_VOLUMEUP },
-	{ 0x08, KEY_VOLUMEDOWN },
-	{ 0x0c, KEY_CHANNELUP },
-	{ 0x10, KEY_CHANNELDOWN },
-	{ 0x03, KEY_ZOOM },		/* fullscreen */
-	{ 0x1f, KEY_TEXT },		/* closed caption/teletext */
-	{ 0x20, KEY_SLEEP },
-	{ 0x29, KEY_CLEAR },		/* boss key */
-	{ 0x14, KEY_MUTE },
-	{ 0x2b, KEY_RED },
-	{ 0x2c, KEY_GREEN },
-	{ 0x2d, KEY_YELLOW },
-	{ 0x2e, KEY_BLUE },
-	{ 0x18, KEY_KPPLUS },		/* fine tune + , not on Y040052 */
-	{ 0x19, KEY_KPMINUS },		/* fine tune - , not on Y040052 */
-	{ 0x2a, KEY_MEDIA },		/* PIP (Picture in picture */
-	{ 0x21, KEY_DOT },
-	{ 0x13, KEY_ENTER },
-	{ 0x11, KEY_LAST },		/* Recall (last channel */
-	{ 0x22, KEY_PREVIOUS },
-	{ 0x23, KEY_PLAYPAUSE },
-	{ 0x24, KEY_NEXT },
-	{ 0x25, KEY_TIME },		/* Time Shifting */
-	{ 0x26, KEY_STOP },
-	{ 0x27, KEY_RECORD },
-	{ 0x28, KEY_SAVE },		/* Screenshot */
-	{ 0x2f, KEY_MENU },
-	{ 0x30, KEY_CANCEL },
-	{ 0x31, KEY_CHANNEL },		/* Channel Surf */
-	{ 0x32, KEY_SUBTITLE },
-	{ 0x33, KEY_LANGUAGE },
-	{ 0x34, KEY_REWIND },
-	{ 0x35, KEY_FASTFORWARD },
-	{ 0x36, KEY_TV },
-	{ 0x37, KEY_RADIO },		/* FM */
-	{ 0x38, KEY_DVD },
-
-	{ 0x1a, KEY_MODE},		/* change to MCE mode on Y04G0051 */
-	{ 0x3e, KEY_F21 },		/* MCE +VOL, on Y04G0033 */
-	{ 0x3a, KEY_F22 },		/* MCE -VOL, on Y04G0033 */
-	{ 0x3b, KEY_F23 },		/* MCE +CH,  on Y04G0033 */
-	{ 0x3f, KEY_F24 }		/* MCE -CH,  on Y04G0033 */
-};
-DEFINE_LEGACY_IR_KEYTABLE(winfast);
-
-static struct ir_scancode pinnacle_color[] = {
-	{ 0x59, KEY_MUTE },
-	{ 0x4a, KEY_POWER },
-
-	{ 0x18, KEY_TEXT },
-	{ 0x26, KEY_TV },
-	{ 0x3d, KEY_PRINT },
-
-	{ 0x48, KEY_RED },
-	{ 0x04, KEY_GREEN },
-	{ 0x11, KEY_YELLOW },
-	{ 0x00, KEY_BLUE },
-
-	{ 0x2d, KEY_VOLUMEUP },
-	{ 0x1e, KEY_VOLUMEDOWN },
-
-	{ 0x49, KEY_MENU },
-
-	{ 0x16, KEY_CHANNELUP },
-	{ 0x17, KEY_CHANNELDOWN },
-
-	{ 0x20, KEY_UP },
-	{ 0x21, KEY_DOWN },
-	{ 0x22, KEY_LEFT },
-	{ 0x23, KEY_RIGHT },
-	{ 0x0d, KEY_SELECT },
-
-	{ 0x08, KEY_BACK },
-	{ 0x07, KEY_REFRESH },
-
-	{ 0x2f, KEY_ZOOM },
-	{ 0x29, KEY_RECORD },
-
-	{ 0x4b, KEY_PAUSE },
-	{ 0x4d, KEY_REWIND },
-	{ 0x2e, KEY_PLAY },
-	{ 0x4e, KEY_FORWARD },
-	{ 0x53, KEY_PREVIOUS },
-	{ 0x4c, KEY_STOP },
-	{ 0x54, KEY_NEXT },
-
-	{ 0x69, KEY_0 },
-	{ 0x6a, KEY_1 },
-	{ 0x6b, KEY_2 },
-	{ 0x6c, KEY_3 },
-	{ 0x6d, KEY_4 },
-	{ 0x6e, KEY_5 },
-	{ 0x6f, KEY_6 },
-	{ 0x70, KEY_7 },
-	{ 0x71, KEY_8 },
-	{ 0x72, KEY_9 },
-
-	{ 0x74, KEY_CHANNEL },
-	{ 0x0a, KEY_BACKSPACE },
-};
-DEFINE_LEGACY_IR_KEYTABLE(pinnacle_color);
-
-/* Hauppauge: the newer, gray remotes (seems there are multiple
- * slightly different versions), shipped with cx88+ivtv cards.
- * almost rc5 coding, but some non-standard keys */
-static struct ir_scancode hauppauge_new[] = {
-	/* Keys 0 to 9 */
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x0a, KEY_TEXT },		/* keypad asterisk as well */
-	{ 0x0b, KEY_RED },		/* red button */
-	{ 0x0c, KEY_RADIO },
-	{ 0x0d, KEY_MENU },
-	{ 0x0e, KEY_SUBTITLE },		/* also the # key */
-	{ 0x0f, KEY_MUTE },
-	{ 0x10, KEY_VOLUMEUP },
-	{ 0x11, KEY_VOLUMEDOWN },
-	{ 0x12, KEY_PREVIOUS },		/* previous channel */
-	{ 0x14, KEY_UP },
-	{ 0x15, KEY_DOWN },
-	{ 0x16, KEY_LEFT },
-	{ 0x17, KEY_RIGHT },
-	{ 0x18, KEY_VIDEO },		/* Videos */
-	{ 0x19, KEY_AUDIO },		/* Music */
-	/* 0x1a: Pictures - presume this means
-	   "Multimedia Home Platform" -
-	   no "PICTURES" key in input.h
-	 */
-	{ 0x1a, KEY_MHP },
-
-	{ 0x1b, KEY_EPG },		/* Guide */
-	{ 0x1c, KEY_TV },
-	{ 0x1e, KEY_NEXTSONG },		/* skip >| */
-	{ 0x1f, KEY_EXIT },		/* back/exit */
-	{ 0x20, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x21, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x22, KEY_CHANNEL },		/* source (old black remote) */
-	{ 0x24, KEY_PREVIOUSSONG },	/* replay |< */
-	{ 0x25, KEY_ENTER },		/* OK */
-	{ 0x26, KEY_SLEEP },		/* minimize (old black remote) */
-	{ 0x29, KEY_BLUE },		/* blue key */
-	{ 0x2e, KEY_GREEN },		/* green button */
-	{ 0x30, KEY_PAUSE },		/* pause */
-	{ 0x32, KEY_REWIND },		/* backward << */
-	{ 0x34, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x35, KEY_PLAY },
-	{ 0x36, KEY_STOP },
-	{ 0x37, KEY_RECORD },		/* recording */
-	{ 0x38, KEY_YELLOW },		/* yellow key */
-	{ 0x3b, KEY_SELECT },		/* top right button */
-	{ 0x3c, KEY_ZOOM },		/* full */
-	{ 0x3d, KEY_POWER },		/* system power (green button) */
-};
-DEFINE_LEGACY_IR_KEYTABLE(hauppauge_new);
-
-static struct ir_scancode npgtech[] = {
-	{ 0x1d, KEY_SWITCHVIDEOMODE },	/* switch inputs */
-	{ 0x2a, KEY_FRONT },
-
-	{ 0x3e, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x06, KEY_3 },
-	{ 0x0a, KEY_4 },
-	{ 0x0e, KEY_5 },
-	{ 0x12, KEY_6 },
-	{ 0x16, KEY_7 },
-	{ 0x1a, KEY_8 },
-	{ 0x1e, KEY_9 },
-	{ 0x3a, KEY_0 },
-	{ 0x22, KEY_NUMLOCK },		/* -/-- */
-	{ 0x20, KEY_REFRESH },
-
-	{ 0x03, KEY_BRIGHTNESSDOWN },
-	{ 0x28, KEY_AUDIO },
-	{ 0x3c, KEY_CHANNELUP },
-	{ 0x3f, KEY_VOLUMEDOWN },
-	{ 0x2e, KEY_MUTE },
-	{ 0x3b, KEY_VOLUMEUP },
-	{ 0x00, KEY_CHANNELDOWN },
-	{ 0x07, KEY_BRIGHTNESSUP },
-	{ 0x2c, KEY_TEXT },
-
-	{ 0x37, KEY_RECORD },
-	{ 0x17, KEY_PLAY },
-	{ 0x13, KEY_PAUSE },
-	{ 0x26, KEY_STOP },
-	{ 0x18, KEY_FASTFORWARD },
-	{ 0x14, KEY_REWIND },
-	{ 0x33, KEY_ZOOM },
-	{ 0x32, KEY_KEYBOARD },
-	{ 0x30, KEY_GOTO },		/* Pointing arrow */
-	{ 0x36, KEY_MACRO },		/* Maximize/Minimize (yellow) */
-	{ 0x0b, KEY_RADIO },
-	{ 0x10, KEY_POWER },
-
-};
-DEFINE_LEGACY_IR_KEYTABLE(npgtech);
-
-/* Norwood Micro (non-Pro) TV Tuner
-   By Peter Naulls <peter@chocky.org>
-   Key comments are the functions given in the manual */
-static struct ir_scancode norwood[] = {
-	/* Keys 0 to 9 */
-	{ 0x20, KEY_0 },
-	{ 0x21, KEY_1 },
-	{ 0x22, KEY_2 },
-	{ 0x23, KEY_3 },
-	{ 0x24, KEY_4 },
-	{ 0x25, KEY_5 },
-	{ 0x26, KEY_6 },
-	{ 0x27, KEY_7 },
-	{ 0x28, KEY_8 },
-	{ 0x29, KEY_9 },
-
-	{ 0x78, KEY_TUNER },		/* Video Source        */
-	{ 0x2c, KEY_EXIT },		/* Open/Close software */
-	{ 0x2a, KEY_SELECT },		/* 2 Digit Select      */
-	{ 0x69, KEY_AGAIN },		/* Recall              */
-
-	{ 0x32, KEY_BRIGHTNESSUP },	/* Brightness increase */
-	{ 0x33, KEY_BRIGHTNESSDOWN },	/* Brightness decrease */
-	{ 0x6b, KEY_KPPLUS },		/* (not named >>>>>)   */
-	{ 0x6c, KEY_KPMINUS },		/* (not named <<<<<)   */
-
-	{ 0x2d, KEY_MUTE },		/* Mute                */
-	{ 0x30, KEY_VOLUMEUP },		/* Volume up           */
-	{ 0x31, KEY_VOLUMEDOWN },	/* Volume down         */
-	{ 0x60, KEY_CHANNELUP },	/* Channel up          */
-	{ 0x61, KEY_CHANNELDOWN },	/* Channel down        */
-
-	{ 0x3f, KEY_RECORD },		/* Record              */
-	{ 0x37, KEY_PLAY },		/* Play                */
-	{ 0x36, KEY_PAUSE },		/* Pause               */
-	{ 0x2b, KEY_STOP },		/* Stop                */
-	{ 0x67, KEY_FASTFORWARD },	/* Foward              */
-	{ 0x66, KEY_REWIND },		/* Rewind              */
-	{ 0x3e, KEY_SEARCH },		/* Auto Scan           */
-	{ 0x2e, KEY_CAMERA },		/* Capture Video       */
-	{ 0x6d, KEY_MENU },		/* Show/Hide Control   */
-	{ 0x2f, KEY_ZOOM },		/* Full Screen         */
-	{ 0x34, KEY_RADIO },		/* FM                  */
-	{ 0x65, KEY_POWER },		/* Computer power      */
-};
-DEFINE_LEGACY_IR_KEYTABLE(norwood);
-
-/* From reading the following remotes:
- * Zenith Universal 7 / TV Mode 807 / VCR Mode 837
- * Hauppauge (from NOVA-CI-s box product)
- * This is a "middle of the road" approach, differences are noted
- */
-static struct ir_scancode budget_ci_old[] = {
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-	{ 0x0a, KEY_ENTER },
-	{ 0x0b, KEY_RED },
-	{ 0x0c, KEY_POWER },		/* RADIO on Hauppauge */
-	{ 0x0d, KEY_MUTE },
-	{ 0x0f, KEY_A },		/* TV on Hauppauge */
-	{ 0x10, KEY_VOLUMEUP },
-	{ 0x11, KEY_VOLUMEDOWN },
-	{ 0x14, KEY_B },
-	{ 0x1c, KEY_UP },
-	{ 0x1d, KEY_DOWN },
-	{ 0x1e, KEY_OPTION },		/* RESERVED on Hauppauge */
-	{ 0x1f, KEY_BREAK },
-	{ 0x20, KEY_CHANNELUP },
-	{ 0x21, KEY_CHANNELDOWN },
-	{ 0x22, KEY_PREVIOUS },		/* Prev Ch on Zenith, SOURCE on Hauppauge */
-	{ 0x24, KEY_RESTART },
-	{ 0x25, KEY_OK },
-	{ 0x26, KEY_CYCLEWINDOWS },	/* MINIMIZE on Hauppauge */
-	{ 0x28, KEY_ENTER },		/* VCR mode on Zenith */
-	{ 0x29, KEY_PAUSE },
-	{ 0x2b, KEY_RIGHT },
-	{ 0x2c, KEY_LEFT },
-	{ 0x2e, KEY_MENU },		/* FULL SCREEN on Hauppauge */
-	{ 0x30, KEY_SLOW },
-	{ 0x31, KEY_PREVIOUS },		/* VCR mode on Zenith */
-	{ 0x32, KEY_REWIND },
-	{ 0x34, KEY_FASTFORWARD },
-	{ 0x35, KEY_PLAY },
-	{ 0x36, KEY_STOP },
-	{ 0x37, KEY_RECORD },
-	{ 0x38, KEY_TUNER },		/* TV/VCR on Zenith */
-	{ 0x3a, KEY_C },
-	{ 0x3c, KEY_EXIT },
-	{ 0x3d, KEY_POWER2 },
-	{ 0x3e, KEY_TUNER },
-};
-DEFINE_LEGACY_IR_KEYTABLE(budget_ci_old);
-
-/*
- * Marc Fargas <telenieko@telenieko.com>
- * this is the remote control that comes with the asus p7131
- * which has a label saying is "Model PC-39"
- */
-static struct ir_scancode asus_pc39[] = {
-	/* Keys 0 to 9 */
-	{ 0x15, KEY_0 },
-	{ 0x29, KEY_1 },
-	{ 0x2d, KEY_2 },
-	{ 0x2b, KEY_3 },
-	{ 0x09, KEY_4 },
-	{ 0x0d, KEY_5 },
-	{ 0x0b, KEY_6 },
-	{ 0x31, KEY_7 },
-	{ 0x35, KEY_8 },
-	{ 0x33, KEY_9 },
-
-	{ 0x3e, KEY_RADIO },		/* radio */
-	{ 0x03, KEY_MENU },		/* dvd/menu */
-	{ 0x2a, KEY_VOLUMEUP },
-	{ 0x19, KEY_VOLUMEDOWN },
-	{ 0x37, KEY_UP },
-	{ 0x3b, KEY_DOWN },
-	{ 0x27, KEY_LEFT },
-	{ 0x2f, KEY_RIGHT },
-	{ 0x25, KEY_VIDEO },		/* video */
-	{ 0x39, KEY_AUDIO },		/* music */
-
-	{ 0x21, KEY_TV },		/* tv */
-	{ 0x1d, KEY_EXIT },		/* back */
-	{ 0x0a, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x1b, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x1a, KEY_ENTER },		/* enter */
-
-	{ 0x06, KEY_PAUSE },		/* play/pause */
-	{ 0x1e, KEY_PREVIOUS },		/* rew */
-	{ 0x26, KEY_NEXT },		/* forward */
-	{ 0x0e, KEY_REWIND },		/* backward << */
-	{ 0x3a, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x36, KEY_STOP },
-	{ 0x2e, KEY_RECORD },		/* recording */
-	{ 0x16, KEY_POWER },		/* the button that reads "close" */
-
-	{ 0x11, KEY_ZOOM },		/* full screen */
-	{ 0x13, KEY_MACRO },		/* recall */
-	{ 0x23, KEY_HOME },		/* home */
-	{ 0x05, KEY_PVR },		/* picture */
-	{ 0x3d, KEY_MUTE },		/* mute */
-	{ 0x01, KEY_DVD },		/* dvd */
-};
-DEFINE_LEGACY_IR_KEYTABLE(asus_pc39);
-
-/* Encore ENLTV-FM  - black plastic, white front cover with white glowing buttons
-    Juan Pablo Sormani <sorman@gmail.com> */
-static struct ir_scancode encore_enltv[] = {
-
-	/* Power button does nothing, neither in Windows app,
-	 although it sends data (used for BIOS wakeup?) */
-	{ 0x0d, KEY_MUTE },
-
-	{ 0x1e, KEY_TV },
-	{ 0x00, KEY_VIDEO },
-	{ 0x01, KEY_AUDIO },		/* music */
-	{ 0x02, KEY_MHP },		/* picture */
-
-	{ 0x1f, KEY_1 },
-	{ 0x03, KEY_2 },
-	{ 0x04, KEY_3 },
-	{ 0x05, KEY_4 },
-	{ 0x1c, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x1d, KEY_9 },
-	{ 0x0a, KEY_0 },
-
-	{ 0x09, KEY_LIST },		/* -/-- */
-	{ 0x0b, KEY_LAST },		/* recall */
-
-	{ 0x14, KEY_HOME },		/* win start menu */
-	{ 0x15, KEY_EXIT },		/* exit */
-	{ 0x16, KEY_CHANNELUP },	/* UP */
-	{ 0x12, KEY_CHANNELDOWN },	/* DOWN */
-	{ 0x0c, KEY_VOLUMEUP },		/* RIGHT */
-	{ 0x17, KEY_VOLUMEDOWN },	/* LEFT */
-
-	{ 0x18, KEY_ENTER },		/* OK */
-
-	{ 0x0e, KEY_ESC },
-	{ 0x13, KEY_CYCLEWINDOWS },	/* desktop */
-	{ 0x11, KEY_TAB },
-	{ 0x19, KEY_SWITCHVIDEOMODE },	/* switch */
-
-	{ 0x1a, KEY_MENU },
-	{ 0x1b, KEY_ZOOM },		/* fullscreen */
-	{ 0x44, KEY_TIME },		/* time shift */
-	{ 0x40, KEY_MODE },		/* source */
-
-	{ 0x5a, KEY_RECORD },
-	{ 0x42, KEY_PLAY },		/* play/pause */
-	{ 0x45, KEY_STOP },
-	{ 0x43, KEY_CAMERA },		/* camera icon */
-
-	{ 0x48, KEY_REWIND },
-	{ 0x4a, KEY_FASTFORWARD },
-	{ 0x49, KEY_PREVIOUS },
-	{ 0x4b, KEY_NEXT },
-
-	{ 0x4c, KEY_FAVORITES },	/* tv wall */
-	{ 0x4d, KEY_SOUND },		/* DVD sound */
-	{ 0x4e, KEY_LANGUAGE },		/* DVD lang */
-	{ 0x4f, KEY_TEXT },		/* DVD text */
-
-	{ 0x50, KEY_SLEEP },		/* shutdown */
-	{ 0x51, KEY_MODE },		/* stereo > main */
-	{ 0x52, KEY_SELECT },		/* stereo > sap */
-	{ 0x53, KEY_PROG1 },		/* teletext */
-
-
-	{ 0x59, KEY_RED },		/* AP1 */
-	{ 0x41, KEY_GREEN },		/* AP2 */
-	{ 0x47, KEY_YELLOW },		/* AP3 */
-	{ 0x57, KEY_BLUE },		/* AP4 */
-};
-DEFINE_LEGACY_IR_KEYTABLE(encore_enltv);
-
-/* Encore ENLTV2-FM  - silver plastic - "Wand Media" written at the botton
-    Mauro Carvalho Chehab <mchehab@infradead.org> */
-static struct ir_scancode encore_enltv2[] = {
-	{ 0x4c, KEY_POWER2 },
-	{ 0x4a, KEY_TUNER },
-	{ 0x40, KEY_1 },
-	{ 0x60, KEY_2 },
-	{ 0x50, KEY_3 },
-	{ 0x70, KEY_4 },
-	{ 0x48, KEY_5 },
-	{ 0x68, KEY_6 },
-	{ 0x58, KEY_7 },
-	{ 0x78, KEY_8 },
-	{ 0x44, KEY_9 },
-	{ 0x54, KEY_0 },
-
-	{ 0x64, KEY_LAST },		/* +100 */
-	{ 0x4e, KEY_AGAIN },		/* Recall */
-
-	{ 0x6c, KEY_SWITCHVIDEOMODE },	/* Video Source */
-	{ 0x5e, KEY_MENU },
-	{ 0x56, KEY_SCREEN },
-	{ 0x7a, KEY_SETUP },
-
-	{ 0x46, KEY_MUTE },
-	{ 0x5c, KEY_MODE },		/* Stereo */
-	{ 0x74, KEY_INFO },
-	{ 0x7c, KEY_CLEAR },
-
-	{ 0x55, KEY_UP },
-	{ 0x49, KEY_DOWN },
-	{ 0x7e, KEY_LEFT },
-	{ 0x59, KEY_RIGHT },
-	{ 0x6a, KEY_ENTER },
-
-	{ 0x42, KEY_VOLUMEUP },
-	{ 0x62, KEY_VOLUMEDOWN },
-	{ 0x52, KEY_CHANNELUP },
-	{ 0x72, KEY_CHANNELDOWN },
-
-	{ 0x41, KEY_RECORD },
-	{ 0x51, KEY_CAMERA },		/* Snapshot */
-	{ 0x75, KEY_TIME },		/* Timeshift */
-	{ 0x71, KEY_TV2 },		/* PIP */
-
-	{ 0x45, KEY_REWIND },
-	{ 0x6f, KEY_PAUSE },
-	{ 0x7d, KEY_FORWARD },
-	{ 0x79, KEY_STOP },
-};
-DEFINE_LEGACY_IR_KEYTABLE(encore_enltv2);
-
-/* for the Technotrend 1500 bundled remotes (grey and black): */
-static struct ir_scancode tt_1500[] = {
-	{ 0x01, KEY_POWER },
-	{ 0x02, KEY_SHUFFLE },		/* ? double-arrow key */
-	{ 0x03, KEY_1 },
-	{ 0x04, KEY_2 },
-	{ 0x05, KEY_3 },
-	{ 0x06, KEY_4 },
-	{ 0x07, KEY_5 },
-	{ 0x08, KEY_6 },
-	{ 0x09, KEY_7 },
-	{ 0x0a, KEY_8 },
-	{ 0x0b, KEY_9 },
-	{ 0x0c, KEY_0 },
-	{ 0x0d, KEY_UP },
-	{ 0x0e, KEY_LEFT },
-	{ 0x0f, KEY_OK },
-	{ 0x10, KEY_RIGHT },
-	{ 0x11, KEY_DOWN },
-	{ 0x12, KEY_INFO },
-	{ 0x13, KEY_EXIT },
-	{ 0x14, KEY_RED },
-	{ 0x15, KEY_GREEN },
-	{ 0x16, KEY_YELLOW },
-	{ 0x17, KEY_BLUE },
-	{ 0x18, KEY_MUTE },
-	{ 0x19, KEY_TEXT },
-	{ 0x1a, KEY_MODE },		/* ? TV/Radio */
-	{ 0x21, KEY_OPTION },
-	{ 0x22, KEY_EPG },
-	{ 0x23, KEY_CHANNELUP },
-	{ 0x24, KEY_CHANNELDOWN },
-	{ 0x25, KEY_VOLUMEUP },
-	{ 0x26, KEY_VOLUMEDOWN },
-	{ 0x27, KEY_SETUP },
-	{ 0x3a, KEY_RECORD },		/* these keys are only in the black remote */
-	{ 0x3b, KEY_PLAY },
-	{ 0x3c, KEY_STOP },
-	{ 0x3d, KEY_REWIND },
-	{ 0x3e, KEY_PAUSE },
-	{ 0x3f, KEY_FORWARD },
-};
-DEFINE_LEGACY_IR_KEYTABLE(tt_1500);
-
-/* DViCO FUSION HDTV MCE remote */
-static struct ir_scancode fusionhdtv_mce[] = {
-
-	{ 0x0b, KEY_1 },
-	{ 0x17, KEY_2 },
-	{ 0x1b, KEY_3 },
-	{ 0x07, KEY_4 },
-	{ 0x50, KEY_5 },
-	{ 0x54, KEY_6 },
-	{ 0x48, KEY_7 },
-	{ 0x4c, KEY_8 },
-	{ 0x58, KEY_9 },
-	{ 0x03, KEY_0 },
-
-	{ 0x5e, KEY_OK },
-	{ 0x51, KEY_UP },
-	{ 0x53, KEY_DOWN },
-	{ 0x5b, KEY_LEFT },
-	{ 0x5f, KEY_RIGHT },
-
-	{ 0x02, KEY_TV },		/* Labeled DTV on remote */
-	{ 0x0e, KEY_MP3 },
-	{ 0x1a, KEY_DVD },
-	{ 0x1e, KEY_FAVORITES },	/* Labeled CPF on remote */
-	{ 0x16, KEY_SETUP },
-	{ 0x46, KEY_POWER2 },		/* TV On/Off button on remote */
-	{ 0x0a, KEY_EPG },		/* Labeled Guide on remote */
-
-	{ 0x49, KEY_BACK },
-	{ 0x59, KEY_INFO },		/* Labeled MORE on remote */
-	{ 0x4d, KEY_MENU },		/* Labeled DVDMENU on remote */
-	{ 0x55, KEY_CYCLEWINDOWS },	/* Labeled ALT-TAB on remote */
-
-	{ 0x0f, KEY_PREVIOUSSONG },	/* Labeled |<< REPLAY on remote */
-	{ 0x12, KEY_NEXTSONG },		/* Labeled >>| SKIP on remote */
-	{ 0x42, KEY_ENTER },		/* Labeled START with a green
-					   MS windows logo on remote */
-
-	{ 0x15, KEY_VOLUMEUP },
-	{ 0x05, KEY_VOLUMEDOWN },
-	{ 0x11, KEY_CHANNELUP },
-	{ 0x09, KEY_CHANNELDOWN },
-
-	{ 0x52, KEY_CAMERA },
-	{ 0x5a, KEY_TUNER },
-	{ 0x19, KEY_OPEN },
-
-	{ 0x13, KEY_MODE },		/* 4:3 16:9 select */
-	{ 0x1f, KEY_ZOOM },
-
-	{ 0x43, KEY_REWIND },
-	{ 0x47, KEY_PLAYPAUSE },
-	{ 0x4f, KEY_FASTFORWARD },
-	{ 0x57, KEY_MUTE },
-	{ 0x0d, KEY_STOP },
-	{ 0x01, KEY_RECORD },
-	{ 0x4e, KEY_POWER },
-};
-DEFINE_LEGACY_IR_KEYTABLE(fusionhdtv_mce);
-
-/* Pinnacle PCTV HD 800i mini remote */
-static struct ir_scancode pinnacle_pctv_hd[] = {
-
-	{ 0x0f, KEY_1 },
-	{ 0x15, KEY_2 },
-	{ 0x10, KEY_3 },
-	{ 0x18, KEY_4 },
-	{ 0x1b, KEY_5 },
-	{ 0x1e, KEY_6 },
-	{ 0x11, KEY_7 },
-	{ 0x21, KEY_8 },
-	{ 0x12, KEY_9 },
-	{ 0x27, KEY_0 },
-
-	{ 0x24, KEY_ZOOM },
-	{ 0x2a, KEY_SUBTITLE },
-
-	{ 0x00, KEY_MUTE },
-	{ 0x01, KEY_ENTER },	/* Pinnacle Logo */
-	{ 0x39, KEY_POWER },
-
-	{ 0x03, KEY_VOLUMEUP },
-	{ 0x09, KEY_VOLUMEDOWN },
-	{ 0x06, KEY_CHANNELUP },
-	{ 0x0c, KEY_CHANNELDOWN },
-
-	{ 0x2d, KEY_REWIND },
-	{ 0x30, KEY_PLAYPAUSE },
-	{ 0x33, KEY_FASTFORWARD },
-	{ 0x3c, KEY_STOP },
-	{ 0x36, KEY_RECORD },
-	{ 0x3f, KEY_EPG },	/* Labeled "?" */
-};
-DEFINE_LEGACY_IR_KEYTABLE(pinnacle_pctv_hd);
-
-/*
- * Igor Kuznetsov <igk72@ya.ru>
- * Andrey J. Melnikov <temnota@kmv.ru>
- *
- * Keytable is used by BeholdTV 60x series, M6 series at
- * least, and probably other cards too.
- * The "ascii-art picture" below (in comments, first row
- * is the keycode in hex, and subsequent row(s) shows
- * the button labels (several variants when appropriate)
- * helps to descide which keycodes to assign to the buttons.
- */
-static struct ir_scancode behold[] = {
-
-	/*  0x1c            0x12  *
-	 *  TV/FM          POWER  *
-	 *                        */
-	{ 0x1c, KEY_TUNER },	/* XXX KEY_TV / KEY_RADIO */
-	{ 0x12, KEY_POWER },
-
-	/*  0x01    0x02    0x03  *
-	 *   1       2       3    *
-	 *                        *
-	 *  0x04    0x05    0x06  *
-	 *   4       5       6    *
-	 *                        *
-	 *  0x07    0x08    0x09  *
-	 *   7       8       9    *
-	 *                        */
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	/*  0x0a    0x00    0x17  *
-	 * RECALL    0      MODE  *
-	 *                        */
-	{ 0x0a, KEY_AGAIN },
-	{ 0x00, KEY_0 },
-	{ 0x17, KEY_MODE },
-
-	/*  0x14          0x10    *
-	 * ASPECT      FULLSCREEN *
-	 *                        */
-	{ 0x14, KEY_SCREEN },
-	{ 0x10, KEY_ZOOM },
-
-	/*          0x0b          *
-	 *           Up           *
-	 *                        *
-	 *  0x18    0x16    0x0c  *
-	 *  Left     Ok     Right *
-	 *                        *
-	 *         0x015          *
-	 *         Down           *
-	 *                        */
-	{ 0x0b, KEY_CHANNELUP },
-	{ 0x18, KEY_VOLUMEDOWN },
-	{ 0x16, KEY_OK },		/* XXX KEY_ENTER */
-	{ 0x0c, KEY_VOLUMEUP },
-	{ 0x15, KEY_CHANNELDOWN },
-
-	/*  0x11            0x0d  *
-	 *  MUTE            INFO  *
-	 *                        */
-	{ 0x11, KEY_MUTE },
-	{ 0x0d, KEY_INFO },
-
-	/*  0x0f    0x1b    0x1a  *
-	 * RECORD PLAY/PAUSE STOP *
-	 *                        *
-	 *  0x0e    0x1f    0x1e  *
-	 *TELETEXT  AUDIO  SOURCE *
-	 *           RED   YELLOW *
-	 *                        */
-	{ 0x0f, KEY_RECORD },
-	{ 0x1b, KEY_PLAYPAUSE },
-	{ 0x1a, KEY_STOP },
-	{ 0x0e, KEY_TEXT },
-	{ 0x1f, KEY_RED },	/*XXX KEY_AUDIO	*/
-	{ 0x1e, KEY_YELLOW },	/*XXX KEY_SOURCE	*/
-
-	/*  0x1d   0x13     0x19  *
-	 * SLEEP  PREVIEW   DVB   *
-	 *         GREEN    BLUE  *
-	 *                        */
-	{ 0x1d, KEY_SLEEP },
-	{ 0x13, KEY_GREEN },
-	{ 0x19, KEY_BLUE },	/* XXX KEY_SAT	*/
-
-	/*  0x58           0x5c   *
-	 * FREEZE        SNAPSHOT *
-	 *                        */
-	{ 0x58, KEY_SLOW },
-	{ 0x5c, KEY_CAMERA },
-
-};
-DEFINE_LEGACY_IR_KEYTABLE(behold);
-
-/* Beholder Intl. Ltd. 2008
- * Dmitry Belimov d.belimov@google.com
- * Keytable is used by BeholdTV Columbus
- * The "ascii-art picture" below (in comments, first row
- * is the keycode in hex, and subsequent row(s) shows
- * the button labels (several variants when appropriate)
- * helps to descide which keycodes to assign to the buttons.
- */
-static struct ir_scancode behold_columbus[] = {
-
-	/*  0x13   0x11   0x1C   0x12  *
-	 *  Mute  Source  TV/FM  Power *
-	 *                             */
-
-	{ 0x13, KEY_MUTE },
-	{ 0x11, KEY_PROPS },
-	{ 0x1C, KEY_TUNER },	/* KEY_TV/KEY_RADIO	*/
-	{ 0x12, KEY_POWER },
-
-	/*  0x01    0x02    0x03  0x0D    *
-	 *   1       2       3   Stereo   *
-	 *                        	  *
-	 *  0x04    0x05    0x06  0x19    *
-	 *   4       5       6   Snapshot *
-	 *                        	  *
-	 *  0x07    0x08    0x09  0x10    *
-	 *   7       8       9    Zoom 	  *
-	 *                                */
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x0D, KEY_SETUP },	  /* Setup key */
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x19, KEY_CAMERA },	/* Snapshot key */
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-	{ 0x10, KEY_ZOOM },
-
-	/*  0x0A    0x00    0x0B       0x0C   *
-	 * RECALL    0    ChannelUp  VolumeUp *
-	 *                                    */
-	{ 0x0A, KEY_AGAIN },
-	{ 0x00, KEY_0 },
-	{ 0x0B, KEY_CHANNELUP },
-	{ 0x0C, KEY_VOLUMEUP },
-
-	/*   0x1B      0x1D      0x15        0x18     *
-	 * Timeshift  Record  ChannelDown  VolumeDown *
-	 *                                            */
-
-	{ 0x1B, KEY_TIME },
-	{ 0x1D, KEY_RECORD },
-	{ 0x15, KEY_CHANNELDOWN },
-	{ 0x18, KEY_VOLUMEDOWN },
-
-	/*   0x0E   0x1E     0x0F     0x1A  *
-	 *   Stop   Pause  Previouse  Next  *
-	 *                                  */
-
-	{ 0x0E, KEY_STOP },
-	{ 0x1E, KEY_PAUSE },
-	{ 0x0F, KEY_PREVIOUS },
-	{ 0x1A, KEY_NEXT },
-
-};
-DEFINE_LEGACY_IR_KEYTABLE(behold_columbus);
-
-/*
- * Remote control for the Genius TVGO A11MCE
- * Adrian Pardini <pardo.bsso@gmail.com>
- */
-static struct ir_scancode genius_tvgo_a11mce[] = {
-	/* Keys 0 to 9 */
-	{ 0x48, KEY_0 },
-	{ 0x09, KEY_1 },
-	{ 0x1d, KEY_2 },
-	{ 0x1f, KEY_3 },
-	{ 0x19, KEY_4 },
-	{ 0x1b, KEY_5 },
-	{ 0x11, KEY_6 },
-	{ 0x17, KEY_7 },
-	{ 0x12, KEY_8 },
-	{ 0x16, KEY_9 },
-
-	{ 0x54, KEY_RECORD },		/* recording */
-	{ 0x06, KEY_MUTE },		/* mute */
-	{ 0x10, KEY_POWER },
-	{ 0x40, KEY_LAST },		/* recall */
-	{ 0x4c, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x00, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x0d, KEY_VOLUMEUP },
-	{ 0x15, KEY_VOLUMEDOWN },
-	{ 0x4d, KEY_OK },		/* also labeled as Pause */
-	{ 0x1c, KEY_ZOOM },		/* full screen and Stop*/
-	{ 0x02, KEY_MODE },		/* AV Source or Rewind*/
-	{ 0x04, KEY_LIST },		/* -/-- */
-	/* small arrows above numbers */
-	{ 0x1a, KEY_NEXT },		/* also Fast Forward */
-	{ 0x0e, KEY_PREVIOUS },		/* also Rewind */
-	/* these are in a rather non standard layout and have
-	an alternate name written */
-	{ 0x1e, KEY_UP },		/* Video Setting */
-	{ 0x0a, KEY_DOWN },		/* Video Default */
-	{ 0x05, KEY_CAMERA },		/* Snapshot */
-	{ 0x0c, KEY_RIGHT },		/* Hide Panel */
-	/* Four buttons without label */
-	{ 0x49, KEY_RED },
-	{ 0x0b, KEY_GREEN },
-	{ 0x13, KEY_YELLOW },
-	{ 0x50, KEY_BLUE },
-};
-DEFINE_LEGACY_IR_KEYTABLE(genius_tvgo_a11mce);
-
-/*
- * Remote control for Powercolor Real Angel 330
- * Daniel Fraga <fragabr@gmail.com>
- */
-static struct ir_scancode powercolor_real_angel[] = {
-	{ 0x38, KEY_SWITCHVIDEOMODE },	/* switch inputs */
-	{ 0x0c, KEY_MEDIA },		/* Turn ON/OFF App */
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-	{ 0x0a, KEY_DIGITS },		/* single, double, tripple digit */
-	{ 0x29, KEY_PREVIOUS },		/* previous channel */
-	{ 0x12, KEY_BRIGHTNESSUP },
-	{ 0x13, KEY_BRIGHTNESSDOWN },
-	{ 0x2b, KEY_MODE },		/* stereo/mono */
-	{ 0x2c, KEY_TEXT },		/* teletext */
-	{ 0x20, KEY_CHANNELUP },	/* channel up */
-	{ 0x21, KEY_CHANNELDOWN },	/* channel down */
-	{ 0x10, KEY_VOLUMEUP },		/* volume up */
-	{ 0x11, KEY_VOLUMEDOWN },	/* volume down */
-	{ 0x0d, KEY_MUTE },
-	{ 0x1f, KEY_RECORD },
-	{ 0x17, KEY_PLAY },
-	{ 0x16, KEY_PAUSE },
-	{ 0x0b, KEY_STOP },
-	{ 0x27, KEY_FASTFORWARD },
-	{ 0x26, KEY_REWIND },
-	{ 0x1e, KEY_SEARCH },		/* autoscan */
-	{ 0x0e, KEY_CAMERA },		/* snapshot */
-	{ 0x2d, KEY_SETUP },
-	{ 0x0f, KEY_SCREEN },		/* full screen */
-	{ 0x14, KEY_RADIO },		/* FM radio */
-	{ 0x25, KEY_POWER },		/* power */
-};
-DEFINE_LEGACY_IR_KEYTABLE(powercolor_real_angel);
-
-/* Kworld Plus TV Analog Lite PCI IR
-   Mauro Carvalho Chehab <mchehab@infradead.org>
- */
-static struct ir_scancode kworld_plus_tv_analog[] = {
-	{ 0x0c, KEY_PROG1 },		/* Kworld key */
-	{ 0x16, KEY_CLOSECD },		/* -> ) */
-	{ 0x1d, KEY_POWER2 },
-
-	{ 0x00, KEY_1 },
-	{ 0x01, KEY_2 },
-	{ 0x02, KEY_3 },		/* Two keys have the same code: 3 and left */
-	{ 0x03, KEY_4 },		/* Two keys have the same code: 3 and right */
-	{ 0x04, KEY_5 },
-	{ 0x05, KEY_6 },
-	{ 0x06, KEY_7 },
-	{ 0x07, KEY_8 },
-	{ 0x08, KEY_9 },
-	{ 0x0a, KEY_0 },
-
-	{ 0x09, KEY_AGAIN },
-	{ 0x14, KEY_MUTE },
-
-	{ 0x20, KEY_UP },
-	{ 0x21, KEY_DOWN },
-	{ 0x0b, KEY_ENTER },
-
-	{ 0x10, KEY_CHANNELUP },
-	{ 0x11, KEY_CHANNELDOWN },
-
-	/* Couldn't map key left/key right since those
-	   conflict with '3' and '4' scancodes
-	   I dunno what the original driver does
-	 */
-
-	{ 0x13, KEY_VOLUMEUP },
-	{ 0x12, KEY_VOLUMEDOWN },
-
-	/* The lower part of the IR
-	   There are several duplicated keycodes there.
-	   Most of them conflict with digits.
-	   Add mappings just to the unused scancodes.
-	   Somehow, the original driver has a way to know,
-	   but this doesn't seem to be on some GPIO.
-	   Also, it is not related to the time between keyup
-	   and keydown.
-	 */
-	{ 0x19, KEY_TIME},		/* Timeshift */
-	{ 0x1a, KEY_STOP},
-	{ 0x1b, KEY_RECORD},
-
-	{ 0x22, KEY_TEXT},
-
-	{ 0x15, KEY_AUDIO},		/* ((*)) */
-	{ 0x0f, KEY_ZOOM},
-	{ 0x1c, KEY_CAMERA},		/* snapshot */
-
-	{ 0x18, KEY_RED},		/* B */
-	{ 0x23, KEY_GREEN},		/* C */
-};
-DEFINE_LEGACY_IR_KEYTABLE(kworld_plus_tv_analog);
-
-/* Kaiomy TVnPC U2
-   Mauro Carvalho Chehab <mchehab@infradead.org>
- */
-static struct ir_scancode kaiomy[] = {
-	{ 0x43, KEY_POWER2},
-	{ 0x01, KEY_LIST},
-	{ 0x0b, KEY_ZOOM},
-	{ 0x03, KEY_POWER},
-
-	{ 0x04, KEY_1},
-	{ 0x08, KEY_2},
-	{ 0x02, KEY_3},
-
-	{ 0x0f, KEY_4},
-	{ 0x05, KEY_5},
-	{ 0x06, KEY_6},
-
-	{ 0x0c, KEY_7},
-	{ 0x0d, KEY_8},
-	{ 0x0a, KEY_9},
-
-	{ 0x11, KEY_0},
-
-	{ 0x09, KEY_CHANNELUP},
-	{ 0x07, KEY_CHANNELDOWN},
-
-	{ 0x0e, KEY_VOLUMEUP},
-	{ 0x13, KEY_VOLUMEDOWN},
-
-	{ 0x10, KEY_HOME},
-	{ 0x12, KEY_ENTER},
-
-	{ 0x14, KEY_RECORD},
-	{ 0x15, KEY_STOP},
-	{ 0x16, KEY_PLAY},
-	{ 0x17, KEY_MUTE},
-
-	{ 0x18, KEY_UP},
-	{ 0x19, KEY_DOWN},
-	{ 0x1a, KEY_LEFT},
-	{ 0x1b, KEY_RIGHT},
-
-	{ 0x1c, KEY_RED},
-	{ 0x1d, KEY_GREEN},
-	{ 0x1e, KEY_YELLOW},
-	{ 0x1f, KEY_BLUE},
-};
-DEFINE_LEGACY_IR_KEYTABLE(kaiomy);
-
-static struct ir_scancode avermedia_a16d[] = {
-	{ 0x20, KEY_LIST},
-	{ 0x00, KEY_POWER},
-	{ 0x28, KEY_1},
-	{ 0x18, KEY_2},
-	{ 0x38, KEY_3},
-	{ 0x24, KEY_4},
-	{ 0x14, KEY_5},
-	{ 0x34, KEY_6},
-	{ 0x2c, KEY_7},
-	{ 0x1c, KEY_8},
-	{ 0x3c, KEY_9},
-	{ 0x12, KEY_SUBTITLE},
-	{ 0x22, KEY_0},
-	{ 0x32, KEY_REWIND},
-	{ 0x3a, KEY_SHUFFLE},
-	{ 0x02, KEY_PRINT},
-	{ 0x11, KEY_CHANNELDOWN},
-	{ 0x31, KEY_CHANNELUP},
-	{ 0x0c, KEY_ZOOM},
-	{ 0x1e, KEY_VOLUMEDOWN},
-	{ 0x3e, KEY_VOLUMEUP},
-	{ 0x0a, KEY_MUTE},
-	{ 0x04, KEY_AUDIO},
-	{ 0x26, KEY_RECORD},
-	{ 0x06, KEY_PLAY},
-	{ 0x36, KEY_STOP},
-	{ 0x16, KEY_PAUSE},
-	{ 0x2e, KEY_REWIND},
-	{ 0x0e, KEY_FASTFORWARD},
-	{ 0x30, KEY_TEXT},
-	{ 0x21, KEY_GREEN},
-	{ 0x01, KEY_BLUE},
-	{ 0x08, KEY_EPG},
-	{ 0x2a, KEY_MENU},
-};
-DEFINE_LEGACY_IR_KEYTABLE(avermedia_a16d);
-
-/* Encore ENLTV-FM v5.3
-   Mauro Carvalho Chehab <mchehab@infradead.org>
- */
-static struct ir_scancode encore_enltv_fm53[] = {
-	{ 0x10, KEY_POWER2},
-	{ 0x06, KEY_MUTE},
-
-	{ 0x09, KEY_1},
-	{ 0x1d, KEY_2},
-	{ 0x1f, KEY_3},
-	{ 0x19, KEY_4},
-	{ 0x1b, KEY_5},
-	{ 0x11, KEY_6},
-	{ 0x17, KEY_7},
-	{ 0x12, KEY_8},
-	{ 0x16, KEY_9},
-	{ 0x48, KEY_0},
-
-	{ 0x04, KEY_LIST},		/* -/-- */
-	{ 0x40, KEY_LAST},		/* recall */
-
-	{ 0x02, KEY_MODE},		/* TV/AV */
-	{ 0x05, KEY_CAMERA},		/* SNAPSHOT */
-
-	{ 0x4c, KEY_CHANNELUP},		/* UP */
-	{ 0x00, KEY_CHANNELDOWN},	/* DOWN */
-	{ 0x0d, KEY_VOLUMEUP},		/* RIGHT */
-	{ 0x15, KEY_VOLUMEDOWN},	/* LEFT */
-	{ 0x49, KEY_ENTER},		/* OK */
-
-	{ 0x54, KEY_RECORD},
-	{ 0x4d, KEY_PLAY},		/* pause */
-
-	{ 0x1e, KEY_MENU},		/* video setting */
-	{ 0x0e, KEY_RIGHT},		/* <- */
-	{ 0x1a, KEY_LEFT},		/* -> */
-
-	{ 0x0a, KEY_CLEAR},		/* video default */
-	{ 0x0c, KEY_ZOOM},		/* hide pannel */
-	{ 0x47, KEY_SLEEP},		/* shutdown */
-};
-DEFINE_LEGACY_IR_KEYTABLE(encore_enltv_fm53);
-
-/* Zogis Real Audio 220 - 32 keys IR */
-static struct ir_scancode real_audio_220_32_keys[] = {
-	{ 0x1c, KEY_RADIO},
-	{ 0x12, KEY_POWER2},
-
-	{ 0x01, KEY_1},
-	{ 0x02, KEY_2},
-	{ 0x03, KEY_3},
-	{ 0x04, KEY_4},
-	{ 0x05, KEY_5},
-	{ 0x06, KEY_6},
-	{ 0x07, KEY_7},
-	{ 0x08, KEY_8},
-	{ 0x09, KEY_9},
-	{ 0x00, KEY_0},
-
-	{ 0x0c, KEY_VOLUMEUP},
-	{ 0x18, KEY_VOLUMEDOWN},
-	{ 0x0b, KEY_CHANNELUP},
-	{ 0x15, KEY_CHANNELDOWN},
-	{ 0x16, KEY_ENTER},
-
-	{ 0x11, KEY_LIST},		/* Source */
-	{ 0x0d, KEY_AUDIO},		/* stereo */
-
-	{ 0x0f, KEY_PREVIOUS},		/* Prev */
-	{ 0x1b, KEY_TIME},		/* Timeshift */
-	{ 0x1a, KEY_NEXT},		/* Next */
-
-	{ 0x0e, KEY_STOP},
-	{ 0x1f, KEY_PLAY},
-	{ 0x1e, KEY_PLAYPAUSE},		/* Pause */
-
-	{ 0x1d, KEY_RECORD},
-	{ 0x13, KEY_MUTE},
-	{ 0x19, KEY_CAMERA},		/* Snapshot */
-
-};
-DEFINE_LEGACY_IR_KEYTABLE(real_audio_220_32_keys);
-
-/* ATI TV Wonder HD 600 USB
-   Devin Heitmueller <devin.heitmueller@gmail.com>
- */
-static struct ir_scancode ati_tv_wonder_hd_600[] = {
-	{ 0x00, KEY_RECORD},		/* Row 1 */
-	{ 0x01, KEY_PLAYPAUSE},
-	{ 0x02, KEY_STOP},
-	{ 0x03, KEY_POWER},
-	{ 0x04, KEY_PREVIOUS},	/* Row 2 */
-	{ 0x05, KEY_REWIND},
-	{ 0x06, KEY_FORWARD},
-	{ 0x07, KEY_NEXT},
-	{ 0x08, KEY_EPG},		/* Row 3 */
-	{ 0x09, KEY_HOME},
-	{ 0x0a, KEY_MENU},
-	{ 0x0b, KEY_CHANNELUP},
-	{ 0x0c, KEY_BACK},		/* Row 4 */
-	{ 0x0d, KEY_UP},
-	{ 0x0e, KEY_INFO},
-	{ 0x0f, KEY_CHANNELDOWN},
-	{ 0x10, KEY_LEFT},		/* Row 5 */
-	{ 0x11, KEY_SELECT},
-	{ 0x12, KEY_RIGHT},
-	{ 0x13, KEY_VOLUMEUP},
-	{ 0x14, KEY_LAST},		/* Row 6 */
-	{ 0x15, KEY_DOWN},
-	{ 0x16, KEY_MUTE},
-	{ 0x17, KEY_VOLUMEDOWN},
-};
-DEFINE_LEGACY_IR_KEYTABLE(ati_tv_wonder_hd_600);
-
-/* DVBWorld remotes
-   Igor M. Liplianin <liplianin@me.by>
- */
-static struct ir_scancode dm1105_nec[] = {
-	{ 0x0a, KEY_POWER2},		/* power */
-	{ 0x0c, KEY_MUTE},		/* mute */
-	{ 0x11, KEY_1},
-	{ 0x12, KEY_2},
-	{ 0x13, KEY_3},
-	{ 0x14, KEY_4},
-	{ 0x15, KEY_5},
-	{ 0x16, KEY_6},
-	{ 0x17, KEY_7},
-	{ 0x18, KEY_8},
-	{ 0x19, KEY_9},
-	{ 0x10, KEY_0},
-	{ 0x1c, KEY_CHANNELUP},		/* ch+ */
-	{ 0x0f, KEY_CHANNELDOWN},	/* ch- */
-	{ 0x1a, KEY_VOLUMEUP},		/* vol+ */
-	{ 0x0e, KEY_VOLUMEDOWN},	/* vol- */
-	{ 0x04, KEY_RECORD},		/* rec */
-	{ 0x09, KEY_CHANNEL},		/* fav */
-	{ 0x08, KEY_BACKSPACE},		/* rewind */
-	{ 0x07, KEY_FASTFORWARD},	/* fast */
-	{ 0x0b, KEY_PAUSE},		/* pause */
-	{ 0x02, KEY_ESC},		/* cancel */
-	{ 0x03, KEY_TAB},		/* tab */
-	{ 0x00, KEY_UP},		/* up */
-	{ 0x1f, KEY_ENTER},		/* ok */
-	{ 0x01, KEY_DOWN},		/* down */
-	{ 0x05, KEY_RECORD},		/* cap */
-	{ 0x06, KEY_STOP},		/* stop */
-	{ 0x40, KEY_ZOOM},		/* full */
-	{ 0x1e, KEY_TV},		/* tvmode */
-	{ 0x1b, KEY_B},			/* recall */
-};
-DEFINE_LEGACY_IR_KEYTABLE(dm1105_nec);
-
-static struct ir_scancode tevii_nec[] = {
-	{ 0x0a, KEY_POWER2},
-	{ 0x0c, KEY_MUTE},
-	{ 0x11, KEY_1},
-	{ 0x12, KEY_2},
-	{ 0x13, KEY_3},
-	{ 0x14, KEY_4},
-	{ 0x15, KEY_5},
-	{ 0x16, KEY_6},
-	{ 0x17, KEY_7},
-	{ 0x18, KEY_8},
-	{ 0x19, KEY_9},
-	{ 0x10, KEY_0},
-	{ 0x1c, KEY_MENU},
-	{ 0x0f, KEY_VOLUMEDOWN},
-	{ 0x1a, KEY_LAST},
-	{ 0x0e, KEY_OPEN},
-	{ 0x04, KEY_RECORD},
-	{ 0x09, KEY_VOLUMEUP},
-	{ 0x08, KEY_CHANNELUP},
-	{ 0x07, KEY_PVR},
-	{ 0x0b, KEY_TIME},
-	{ 0x02, KEY_RIGHT},
-	{ 0x03, KEY_LEFT},
-	{ 0x00, KEY_UP},
-	{ 0x1f, KEY_OK},
-	{ 0x01, KEY_DOWN},
-	{ 0x05, KEY_TUNER},
-	{ 0x06, KEY_CHANNELDOWN},
-	{ 0x40, KEY_PLAYPAUSE},
-	{ 0x1e, KEY_REWIND},
-	{ 0x1b, KEY_FAVORITES},
-	{ 0x1d, KEY_BACK},
-	{ 0x4d, KEY_FASTFORWARD},
-	{ 0x44, KEY_EPG},
-	{ 0x4c, KEY_INFO},
-	{ 0x41, KEY_AB},
-	{ 0x43, KEY_AUDIO},
-	{ 0x45, KEY_SUBTITLE},
-	{ 0x4a, KEY_LIST},
-	{ 0x46, KEY_F1},
-	{ 0x47, KEY_F2},
-	{ 0x5e, KEY_F3},
-	{ 0x5c, KEY_F4},
-	{ 0x52, KEY_F5},
-	{ 0x5a, KEY_F6},
-	{ 0x56, KEY_MODE},
-	{ 0x58, KEY_SWITCHVIDEOMODE},
-};
-DEFINE_LEGACY_IR_KEYTABLE(tevii_nec);
-
-static struct ir_scancode tbs_nec[] = {
-	{ 0x04, KEY_POWER2},	/*power*/
-	{ 0x14, KEY_MUTE},	/*mute*/
-	{ 0x07, KEY_1},
-	{ 0x06, KEY_2},
-	{ 0x05, KEY_3},
-	{ 0x0b, KEY_4},
-	{ 0x0a, KEY_5},
-	{ 0x09, KEY_6},
-	{ 0x0f, KEY_7},
-	{ 0x0e, KEY_8},
-	{ 0x0d, KEY_9},
-	{ 0x12, KEY_0},
-	{ 0x16, KEY_CHANNELUP},	/*ch+*/
-	{ 0x11, KEY_CHANNELDOWN},/*ch-*/
-	{ 0x13, KEY_VOLUMEUP},	/*vol+*/
-	{ 0x0c, KEY_VOLUMEDOWN},/*vol-*/
-	{ 0x03, KEY_RECORD},	/*rec*/
-	{ 0x18, KEY_PAUSE},	/*pause*/
-	{ 0x19, KEY_OK},	/*ok*/
-	{ 0x1a, KEY_CAMERA},	/* snapshot */
-	{ 0x01, KEY_UP},
-	{ 0x10, KEY_LEFT},
-	{ 0x02, KEY_RIGHT},
-	{ 0x08, KEY_DOWN},
-	{ 0x15, KEY_FAVORITES},
-	{ 0x17, KEY_SUBTITLE},
-	{ 0x1d, KEY_ZOOM},
-	{ 0x1f, KEY_EXIT},
-	{ 0x1e, KEY_MENU},
-	{ 0x1c, KEY_EPG},
-	{ 0x00, KEY_PREVIOUS},
-	{ 0x1b, KEY_MODE},
-};
-DEFINE_LEGACY_IR_KEYTABLE(tbs_nec);
-
-/* Terratec Cinergy Hybrid T USB XS
-   Devin Heitmueller <dheitmueller@linuxtv.org>
- */
-static struct ir_scancode terratec_cinergy_xs[] = {
-	{ 0x41, KEY_HOME},
-	{ 0x01, KEY_POWER},
-	{ 0x42, KEY_MENU},
-	{ 0x02, KEY_1},
-	{ 0x03, KEY_2},
-	{ 0x04, KEY_3},
-	{ 0x43, KEY_SUBTITLE},
-	{ 0x05, KEY_4},
-	{ 0x06, KEY_5},
-	{ 0x07, KEY_6},
-	{ 0x44, KEY_TEXT},
-	{ 0x08, KEY_7},
-	{ 0x09, KEY_8},
-	{ 0x0a, KEY_9},
-	{ 0x45, KEY_DELETE},
-	{ 0x0b, KEY_TUNER},
-	{ 0x0c, KEY_0},
-	{ 0x0d, KEY_MODE},
-	{ 0x46, KEY_TV},
-	{ 0x47, KEY_DVD},
-	{ 0x49, KEY_VIDEO},
-	{ 0x4b, KEY_AUX},
-	{ 0x10, KEY_UP},
-	{ 0x11, KEY_LEFT},
-	{ 0x12, KEY_OK},
-	{ 0x13, KEY_RIGHT},
-	{ 0x14, KEY_DOWN},
-	{ 0x0f, KEY_EPG},
-	{ 0x16, KEY_INFO},
-	{ 0x4d, KEY_BACKSPACE},
-	{ 0x1c, KEY_VOLUMEUP},
-	{ 0x4c, KEY_PLAY},
-	{ 0x1b, KEY_CHANNELUP},
-	{ 0x1e, KEY_VOLUMEDOWN},
-	{ 0x1d, KEY_MUTE},
-	{ 0x1f, KEY_CHANNELDOWN},
-	{ 0x17, KEY_RED},
-	{ 0x18, KEY_GREEN},
-	{ 0x19, KEY_YELLOW},
-	{ 0x1a, KEY_BLUE},
-	{ 0x58, KEY_RECORD},
-	{ 0x48, KEY_STOP},
-	{ 0x40, KEY_PAUSE},
-	{ 0x54, KEY_LAST},
-	{ 0x4e, KEY_REWIND},
-	{ 0x4f, KEY_FASTFORWARD},
-	{ 0x5c, KEY_NEXT},
-};
-DEFINE_LEGACY_IR_KEYTABLE(terratec_cinergy_xs);
-
-/* EVGA inDtube
-   Devin Heitmueller <devin.heitmueller@gmail.com>
- */
-static struct ir_scancode evga_indtube[] = {
-	{ 0x12, KEY_POWER},
-	{ 0x02, KEY_MODE},	/* TV */
-	{ 0x14, KEY_MUTE},
-	{ 0x1a, KEY_CHANNELUP},
-	{ 0x16, KEY_TV2},	/* PIP */
-	{ 0x1d, KEY_VOLUMEUP},
-	{ 0x05, KEY_CHANNELDOWN},
-	{ 0x0f, KEY_PLAYPAUSE},
-	{ 0x19, KEY_VOLUMEDOWN},
-	{ 0x1c, KEY_REWIND},
-	{ 0x0d, KEY_RECORD},
-	{ 0x18, KEY_FORWARD},
-	{ 0x1e, KEY_PREVIOUS},
-	{ 0x1b, KEY_STOP},
-	{ 0x1f, KEY_NEXT},
-	{ 0x13, KEY_CAMERA},
-};
-DEFINE_LEGACY_IR_KEYTABLE(evga_indtube);
-
-static struct ir_scancode videomate_s350[] = {
-	{ 0x00, KEY_TV},
-	{ 0x01, KEY_DVD},
-	{ 0x04, KEY_RECORD},
-	{ 0x05, KEY_VIDEO},	/* TV/Video */
-	{ 0x07, KEY_STOP},
-	{ 0x08, KEY_PLAYPAUSE},
-	{ 0x0a, KEY_REWIND},
-	{ 0x0f, KEY_FASTFORWARD},
-	{ 0x10, KEY_CHANNELUP},
-	{ 0x12, KEY_VOLUMEUP},
-	{ 0x13, KEY_CHANNELDOWN},
-	{ 0x14, KEY_MUTE},
-	{ 0x15, KEY_VOLUMEDOWN},
-	{ 0x16, KEY_1},
-	{ 0x17, KEY_2},
-	{ 0x18, KEY_3},
-	{ 0x19, KEY_4},
-	{ 0x1a, KEY_5},
-	{ 0x1b, KEY_6},
-	{ 0x1c, KEY_7},
-	{ 0x1d, KEY_8},
-	{ 0x1e, KEY_9},
-	{ 0x1f, KEY_0},
-	{ 0x21, KEY_SLEEP},
-	{ 0x24, KEY_ZOOM},
-	{ 0x25, KEY_LAST},	/* Recall */
-	{ 0x26, KEY_SUBTITLE},	/* CC */
-	{ 0x27, KEY_LANGUAGE},	/* MTS */
-	{ 0x29, KEY_CHANNEL},	/* SURF */
-	{ 0x2b, KEY_A},
-	{ 0x2c, KEY_B},
-	{ 0x2f, KEY_CAMERA},	/* Snapshot */
-	{ 0x23, KEY_RADIO},
-	{ 0x02, KEY_PREVIOUSSONG},
-	{ 0x06, KEY_NEXTSONG},
-	{ 0x03, KEY_EPG},
-	{ 0x09, KEY_SETUP},
-	{ 0x22, KEY_BACKSPACE},
-	{ 0x0c, KEY_UP},
-	{ 0x0e, KEY_DOWN},
-	{ 0x0b, KEY_LEFT},
-	{ 0x0d, KEY_RIGHT},
-	{ 0x11, KEY_ENTER},
-	{ 0x20, KEY_TEXT},
-};
-DEFINE_LEGACY_IR_KEYTABLE(videomate_s350);
-
-/* GADMEI UTV330+ RM008Z remote
-   Shine Liu <shinel@foxmail.com>
- */
-static struct ir_scancode gadmei_rm008z[] = {
-	{ 0x14, KEY_POWER2},		/* POWER OFF */
-	{ 0x0c, KEY_MUTE},		/* MUTE */
-
-	{ 0x18, KEY_TV},		/* TV */
-	{ 0x0e, KEY_VIDEO},		/* AV */
-	{ 0x0b, KEY_AUDIO},		/* SV */
-	{ 0x0f, KEY_RADIO},		/* FM */
-
-	{ 0x00, KEY_1},
-	{ 0x01, KEY_2},
-	{ 0x02, KEY_3},
-	{ 0x03, KEY_4},
-	{ 0x04, KEY_5},
-	{ 0x05, KEY_6},
-	{ 0x06, KEY_7},
-	{ 0x07, KEY_8},
-	{ 0x08, KEY_9},
-	{ 0x09, KEY_0},
-	{ 0x0a, KEY_INFO},		/* OSD */
-	{ 0x1c, KEY_BACKSPACE},		/* LAST */
-
-	{ 0x0d, KEY_PLAY},		/* PLAY */
-	{ 0x1e, KEY_CAMERA},		/* SNAPSHOT */
-	{ 0x1a, KEY_RECORD},		/* RECORD */
-	{ 0x17, KEY_STOP},		/* STOP */
-
-	{ 0x1f, KEY_UP},		/* UP */
-	{ 0x44, KEY_DOWN},		/* DOWN */
-	{ 0x46, KEY_TAB},		/* BACK */
-	{ 0x4a, KEY_ZOOM},		/* FULLSECREEN */
-
-	{ 0x10, KEY_VOLUMEUP},		/* VOLUMEUP */
-	{ 0x11, KEY_VOLUMEDOWN},	/* VOLUMEDOWN */
-	{ 0x12, KEY_CHANNELUP},		/* CHANNELUP */
-	{ 0x13, KEY_CHANNELDOWN},	/* CHANNELDOWN */
-	{ 0x15, KEY_ENTER},		/* OK */
-};
-DEFINE_LEGACY_IR_KEYTABLE(gadmei_rm008z);
-
-/*************************************************************
- *		COMPLETE SCANCODE TABLES
- * Instead of just a partial scancode, the tables bellow
- * contains the complete scancode and the receiver protocol
- *************************************************************/
-
-/*
- * Hauppauge:the newer, gray remotes (seems there are multiple
- * slightly different versions), shipped with cx88+ivtv cards.
- *
- * This table contains the complete RC5 code, instead of just the data part
- */
-static struct ir_scancode rc5_hauppauge_new[] = {
-	/* Keys 0 to 9 */
-	{ 0x1e00, KEY_0 },
-	{ 0x1e01, KEY_1 },
-	{ 0x1e02, KEY_2 },
-	{ 0x1e03, KEY_3 },
-	{ 0x1e04, KEY_4 },
-	{ 0x1e05, KEY_5 },
-	{ 0x1e06, KEY_6 },
-	{ 0x1e07, KEY_7 },
-	{ 0x1e08, KEY_8 },
-	{ 0x1e09, KEY_9 },
-
-	{ 0x1e0a, KEY_TEXT },		/* keypad asterisk as well */
-	{ 0x1e0b, KEY_RED },		/* red button */
-	{ 0x1e0c, KEY_RADIO },
-	{ 0x1e0d, KEY_MENU },
-	{ 0x1e0e, KEY_SUBTITLE },		/* also the # key */
-	{ 0x1e0f, KEY_MUTE },
-	{ 0x1e10, KEY_VOLUMEUP },
-	{ 0x1e11, KEY_VOLUMEDOWN },
-	{ 0x1e12, KEY_PREVIOUS },		/* previous channel */
-	{ 0x1e14, KEY_UP },
-	{ 0x1e15, KEY_DOWN },
-	{ 0x1e16, KEY_LEFT },
-	{ 0x1e17, KEY_RIGHT },
-	{ 0x1e18, KEY_VIDEO },		/* Videos */
-	{ 0x1e19, KEY_AUDIO },		/* Music */
-	/* 0x1e1a: Pictures - presume this means
-	   "Multimedia Home Platform" -
-	   no "PICTURES" key in input.h
-	 */
-	{ 0x1e1a, KEY_MHP },
-
-	{ 0x1e1b, KEY_EPG },		/* Guide */
-	{ 0x1e1c, KEY_TV },
-	{ 0x1e1e, KEY_NEXTSONG },		/* skip >| */
-	{ 0x1e1f, KEY_EXIT },		/* back/exit */
-	{ 0x1e20, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x1e21, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x1e22, KEY_CHANNEL },		/* source (old black remote) */
-	{ 0x1e24, KEY_PREVIOUSSONG },	/* replay |< */
-	{ 0x1e25, KEY_ENTER },		/* OK */
-	{ 0x1e26, KEY_SLEEP },		/* minimize (old black remote) */
-	{ 0x1e29, KEY_BLUE },		/* blue key */
-	{ 0x1e2e, KEY_GREEN },		/* green button */
-	{ 0x1e30, KEY_PAUSE },		/* pause */
-	{ 0x1e32, KEY_REWIND },		/* backward << */
-	{ 0x1e34, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x1e35, KEY_PLAY },
-	{ 0x1e36, KEY_STOP },
-	{ 0x1e37, KEY_RECORD },		/* recording */
-	{ 0x1e38, KEY_YELLOW },		/* yellow key */
-	{ 0x1e3b, KEY_SELECT },		/* top right button */
-	{ 0x1e3c, KEY_ZOOM },		/* full */
-	{ 0x1e3d, KEY_POWER },		/* system power (green button) */
-};
-DEFINE_IR_KEYTABLE(rc5_hauppauge_new, IR_TYPE_RC5);
-
-/* Terratec Cinergy Hybrid T USB XS FM
-   Mauro Carvalho Chehab <mchehab@redhat.com>
- */
-static struct ir_scancode nec_terratec_cinergy_xs[] = {
-	{ 0x1441, KEY_HOME},
-	{ 0x1401, KEY_POWER2},
-
-	{ 0x1442, KEY_MENU},		/* DVD menu */
-	{ 0x1443, KEY_SUBTITLE},
-	{ 0x1444, KEY_TEXT},		/* Teletext */
-	{ 0x1445, KEY_DELETE},
-
-	{ 0x1402, KEY_1},
-	{ 0x1403, KEY_2},
-	{ 0x1404, KEY_3},
-	{ 0x1405, KEY_4},
-	{ 0x1406, KEY_5},
-	{ 0x1407, KEY_6},
-	{ 0x1408, KEY_7},
-	{ 0x1409, KEY_8},
-	{ 0x140a, KEY_9},
-	{ 0x140c, KEY_0},
-
-	{ 0x140b, KEY_TUNER},		/* AV */
-	{ 0x140d, KEY_MODE},		/* A.B */
-
-	{ 0x1446, KEY_TV},
-	{ 0x1447, KEY_DVD},
-	{ 0x1449, KEY_VIDEO},
-	{ 0x144a, KEY_RADIO},		/* Music */
-	{ 0x144b, KEY_CAMERA},		/* PIC */
-
-	{ 0x1410, KEY_UP},
-	{ 0x1411, KEY_LEFT},
-	{ 0x1412, KEY_OK},
-	{ 0x1413, KEY_RIGHT},
-	{ 0x1414, KEY_DOWN},
-
-	{ 0x140f, KEY_EPG},
-	{ 0x1416, KEY_INFO},
-	{ 0x144d, KEY_BACKSPACE},
-
-	{ 0x141c, KEY_VOLUMEUP},
-	{ 0x141e, KEY_VOLUMEDOWN},
-
-	{ 0x144c, KEY_PLAY},
-	{ 0x141d, KEY_MUTE},
-
-	{ 0x141b, KEY_CHANNELUP},
-	{ 0x141f, KEY_CHANNELDOWN},
-
-	{ 0x1417, KEY_RED},
-	{ 0x1418, KEY_GREEN},
-	{ 0x1419, KEY_YELLOW},
-	{ 0x141a, KEY_BLUE},
-
-	{ 0x1458, KEY_RECORD},
-	{ 0x1448, KEY_STOP},
-	{ 0x1440, KEY_PAUSE},
-
-	{ 0x1454, KEY_LAST},
-	{ 0x144e, KEY_REWIND},
-	{ 0x144f, KEY_FASTFORWARD},
-	{ 0x145c, KEY_NEXT},
-};
-DEFINE_IR_KEYTABLE(nec_terratec_cinergy_xs, IR_TYPE_NEC);
-
-/* Leadtek Winfast TV USB II Deluxe remote
-   Magnus Alm <magnus.alm@gmail.com>
- */
-static struct ir_scancode winfast_usbii_deluxe[] = {
-	{ 0x62, KEY_0},
-	{ 0x75, KEY_1},
-	{ 0x76, KEY_2},
-	{ 0x77, KEY_3},
-	{ 0x79, KEY_4},
-	{ 0x7a, KEY_5},
-	{ 0x7b, KEY_6},
-	{ 0x7d, KEY_7},
-	{ 0x7e, KEY_8},
-	{ 0x7f, KEY_9},
-
-	{ 0x38, KEY_CAMERA},		/* SNAPSHOT */
-	{ 0x37, KEY_RECORD},		/* RECORD */
-	{ 0x35, KEY_TIME},		/* TIMESHIFT */
-
-	{ 0x74, KEY_VOLUMEUP},		/* VOLUMEUP */
-	{ 0x78, KEY_VOLUMEDOWN},	/* VOLUMEDOWN */
-	{ 0x64, KEY_MUTE},		/* MUTE */
-
-	{ 0x21, KEY_CHANNEL},		/* SURF */
-	{ 0x7c, KEY_CHANNELUP},		/* CHANNELUP */
-	{ 0x60, KEY_CHANNELDOWN},	/* CHANNELDOWN */
-	{ 0x61, KEY_LAST},		/* LAST CHANNEL (RECALL) */
-
-	{ 0x72, KEY_VIDEO}, 		/* INPUT MODES (TV/FM) */
-
-	{ 0x70, KEY_POWER2},		/* TV ON/OFF */
-
-	{ 0x39, KEY_CYCLEWINDOWS},	/* MINIMIZE (BOSS) */
-	{ 0x3a, KEY_NEW},		/* PIP */
-	{ 0x73, KEY_ZOOM},		/* FULLSECREEN */
-
-	{ 0x66, KEY_INFO},		/* OSD (DISPLAY) */
-
-	{ 0x31, KEY_DOT},		/* '.' */
-	{ 0x63, KEY_ENTER},		/* ENTER */
-
-};
-DEFINE_LEGACY_IR_KEYTABLE(winfast_usbii_deluxe);
-
-/* Kworld 315U
- */
-static struct ir_scancode kworld_315u[] = {
-	{ 0x6143, KEY_POWER },
-	{ 0x6101, KEY_TUNER },		/* source */
-	{ 0x610b, KEY_ZOOM },
-	{ 0x6103, KEY_POWER2 },		/* shutdown */
-
-	{ 0x6104, KEY_1 },
-	{ 0x6108, KEY_2 },
-	{ 0x6102, KEY_3 },
-	{ 0x6109, KEY_CHANNELUP },
-
-	{ 0x610f, KEY_4 },
-	{ 0x6105, KEY_5 },
-	{ 0x6106, KEY_6 },
-	{ 0x6107, KEY_CHANNELDOWN },
-
-	{ 0x610c, KEY_7 },
-	{ 0x610d, KEY_8 },
-	{ 0x610a, KEY_9 },
-	{ 0x610e, KEY_VOLUMEUP },
-
-	{ 0x6110, KEY_LAST },
-	{ 0x6111, KEY_0 },
-	{ 0x6112, KEY_ENTER },
-	{ 0x6113, KEY_VOLUMEDOWN },
-
-	{ 0x6114, KEY_RECORD },
-	{ 0x6115, KEY_STOP },
-	{ 0x6116, KEY_PLAY },
-	{ 0x6117, KEY_MUTE },
-
-	{ 0x6118, KEY_UP },
-	{ 0x6119, KEY_DOWN },
-	{ 0x611a, KEY_LEFT },
-	{ 0x611b, KEY_RIGHT },
 
-	{ 0x611c, KEY_RED },
-	{ 0x611d, KEY_GREEN },
-	{ 0x611e, KEY_YELLOW },
-	{ 0x611f, KEY_BLUE },
-};
-DEFINE_IR_KEYTABLE(kworld_315u, IR_TYPE_NEC);
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index e8a6476..59ce302 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -28,6 +28,71 @@
 #include <linux/interrupt.h>
 #include <media/ir-core.h>
 
+#include <media/keycodes/adstech-dvb-t-pci.h>
+#include <media/keycodes/apac-viewcomp.h>
+#include <media/keycodes/asus-pc39.h>
+#include <media/keycodes/ati-tv-wonder-hd-600.h>
+#include <media/keycodes/avermedia-a16d.h>
+#include <media/keycodes/avermedia-cardbus.h>
+#include <media/keycodes/avermedia-dvbt.h>
+#include <media/keycodes/avermedia.h>
+#include <media/keycodes/avermedia-m135a-rm-jx.h>
+#include <media/keycodes/avertv-303.h>
+#include <media/keycodes/behold-columbus.h>
+#include <media/keycodes/behold.h>
+#include <media/keycodes/budget-ci-old.h>
+#include <media/keycodes/cinergy-1400.h>
+#include <media/keycodes/cinergy.h>
+#include <media/keycodes/dm1105-nec.h>
+#include <media/keycodes/dntv-live-dvb-t.h>
+#include <media/keycodes/dntv-live-dvbt-pro.h>
+#include <media/keycodes/empty.h>
+#include <media/keycodes/em-terratec.h>
+#include <media/keycodes/encore-enltv2.h>
+#include <media/keycodes/encore-enltv-fm53.h>
+#include <media/keycodes/encore-enltv.h>
+#include <media/keycodes/evga-indtube.h>
+#include <media/keycodes/eztv.h>
+#include <media/keycodes/flydvb.h>
+#include <media/keycodes/flyvideo.h>
+#include <media/keycodes/fusionhdtv-mce.h>
+#include <media/keycodes/gadmei-rm008z.h>
+#include <media/keycodes/genius-tvgo-a11mce.h>
+#include <media/keycodes/gotview7135.h>
+#include <media/keycodes/hauppauge-new.h>
+#include <media/keycodes/iodata-bctv7e.h>
+#include <media/keycodes/kaiomy.h>
+#include <media/keycodes/kworld-315u.h>
+#include <media/keycodes/kworld-plus-tv-analog.h>
+#include <media/keycodes/manli.h>
+#include <media/keycodes/msi-tvanywhere.h>
+#include <media/keycodes/msi-tvanywhere-plus.h>
+#include <media/keycodes/nebula.h>
+#include <media/keycodes/nec-terratec-cinergy-xs.h>
+#include <media/keycodes/norwood.h>
+#include <media/keycodes/npgtech.h>
+#include <media/keycodes/pctv-sedna.h>
+#include <media/keycodes/pinnacle-color.h>
+#include <media/keycodes/pinnacle-grey.h>
+#include <media/keycodes/pinnacle-pctv-hd.h>
+#include <media/keycodes/pixelview.h>
+#include <media/keycodes/pixelview-new.h>
+#include <media/keycodes/powercolor-real-angel.h>
+#include <media/keycodes/proteus-2309.h>
+#include <media/keycodes/purpletv.h>
+#include <media/keycodes/pv951.h>
+#include <media/keycodes/rc5-hauppauge-new.h>
+#include <media/keycodes/rc5-tv.h>
+#include <media/keycodes/real-audio-220-32-keys.h>
+#include <media/keycodes/tbs-nec.h>
+#include <media/keycodes/terratec-cinergy-xs.h>
+#include <media/keycodes/tevii-nec.h>
+#include <media/keycodes/tt-1500.h>
+#include <media/keycodes/videomate-s350.h>
+#include <media/keycodes/videomate-tv-pvr.h>
+#include <media/keycodes/winfast.h>
+#include <media/keycodes/winfast-usbii-deluxe.h>
+
 #define RC5_START(x)	(((x)>>12)&3)
 #define RC5_TOGGLE(x)	(((x)>>11)&1)
 #define RC5_ADDR(x)	(((x)>>6)&31)
@@ -104,89 +169,4 @@ u32  ir_rc5_decode(unsigned int code);
 void ir_rc5_timer_end(unsigned long data);
 void ir_rc5_timer_keyup(unsigned long data);
 
-/* scancode->keycode map tables from ir-keymaps.c */
-
-#define IR_KEYTABLE(a)					\
-ir_codes_ ## a ## _table
-
-#define DECLARE_IR_KEYTABLE(a)					\
-extern struct ir_scancode_table IR_KEYTABLE(a)
-
-#define DEFINE_IR_KEYTABLE(tabname, type)			\
-struct ir_scancode_table IR_KEYTABLE(tabname) = {		\
-	.scan = tabname,					\
-	.size = ARRAY_SIZE(tabname),				\
-	.ir_type = type,					\
-	.name = #tabname,					\
-};								\
-EXPORT_SYMBOL_GPL(IR_KEYTABLE(tabname))
-
-#define DEFINE_LEGACY_IR_KEYTABLE(tabname)			\
-	DEFINE_IR_KEYTABLE(tabname, IR_TYPE_UNKNOWN)
-
-DECLARE_IR_KEYTABLE(adstech_dvb_t_pci);
-DECLARE_IR_KEYTABLE(apac_viewcomp);
-DECLARE_IR_KEYTABLE(asus_pc39);
-DECLARE_IR_KEYTABLE(ati_tv_wonder_hd_600);
-DECLARE_IR_KEYTABLE(avermedia);
-DECLARE_IR_KEYTABLE(avermedia_a16d);
-DECLARE_IR_KEYTABLE(avermedia_cardbus);
-DECLARE_IR_KEYTABLE(avermedia_dvbt);
-DECLARE_IR_KEYTABLE(avermedia_m135a_rm_jx);
-DECLARE_IR_KEYTABLE(avertv_303);
-DECLARE_IR_KEYTABLE(behold);
-DECLARE_IR_KEYTABLE(behold_columbus);
-DECLARE_IR_KEYTABLE(budget_ci_old);
-DECLARE_IR_KEYTABLE(cinergy);
-DECLARE_IR_KEYTABLE(cinergy_1400);
-DECLARE_IR_KEYTABLE(dm1105_nec);
-DECLARE_IR_KEYTABLE(dntv_live_dvb_t);
-DECLARE_IR_KEYTABLE(dntv_live_dvbt_pro);
-DECLARE_IR_KEYTABLE(empty);
-DECLARE_IR_KEYTABLE(em_terratec);
-DECLARE_IR_KEYTABLE(encore_enltv);
-DECLARE_IR_KEYTABLE(encore_enltv2);
-DECLARE_IR_KEYTABLE(encore_enltv_fm53);
-DECLARE_IR_KEYTABLE(evga_indtube);
-DECLARE_IR_KEYTABLE(eztv);
-DECLARE_IR_KEYTABLE(flydvb);
-DECLARE_IR_KEYTABLE(flyvideo);
-DECLARE_IR_KEYTABLE(fusionhdtv_mce);
-DECLARE_IR_KEYTABLE(gadmei_rm008z);
-DECLARE_IR_KEYTABLE(genius_tvgo_a11mce);
-DECLARE_IR_KEYTABLE(gotview7135);
-DECLARE_IR_KEYTABLE(hauppauge_new);
-DECLARE_IR_KEYTABLE(iodata_bctv7e);
-DECLARE_IR_KEYTABLE(kaiomy);
-DECLARE_IR_KEYTABLE(kworld_315u);
-DECLARE_IR_KEYTABLE(kworld_plus_tv_analog);
-DECLARE_IR_KEYTABLE(manli);
-DECLARE_IR_KEYTABLE(msi_tvanywhere);
-DECLARE_IR_KEYTABLE(msi_tvanywhere_plus);
-DECLARE_IR_KEYTABLE(nebula);
-DECLARE_IR_KEYTABLE(nec_terratec_cinergy_xs);
-DECLARE_IR_KEYTABLE(norwood);
-DECLARE_IR_KEYTABLE(npgtech);
-DECLARE_IR_KEYTABLE(pctv_sedna);
-DECLARE_IR_KEYTABLE(pinnacle_color);
-DECLARE_IR_KEYTABLE(pinnacle_grey);
-DECLARE_IR_KEYTABLE(pinnacle_pctv_hd);
-DECLARE_IR_KEYTABLE(pixelview);
-DECLARE_IR_KEYTABLE(pixelview_new);
-DECLARE_IR_KEYTABLE(powercolor_real_angel);
-DECLARE_IR_KEYTABLE(proteus_2309);
-DECLARE_IR_KEYTABLE(purpletv);
-DECLARE_IR_KEYTABLE(pv951);
-DECLARE_IR_KEYTABLE(rc5_hauppauge_new);
-DECLARE_IR_KEYTABLE(rc5_tv);
-DECLARE_IR_KEYTABLE(real_audio_220_32_keys);
-DECLARE_IR_KEYTABLE(tbs_nec);
-DECLARE_IR_KEYTABLE(terratec_cinergy_xs);
-DECLARE_IR_KEYTABLE(tevii_nec);
-DECLARE_IR_KEYTABLE(tt_1500);
-DECLARE_IR_KEYTABLE(videomate_s350);
-DECLARE_IR_KEYTABLE(videomate_tv_pvr);
-DECLARE_IR_KEYTABLE(winfast);
-DECLARE_IR_KEYTABLE(winfast_usbii_deluxe);
-
 #endif
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 9a2f308..643ff25 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -96,6 +96,24 @@ struct ir_raw_handler {
 
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
 
+#define IR_KEYTABLE(a)					\
+ir_codes_ ## a ## _table
+
+#define DECLARE_IR_KEYTABLE(a)					\
+extern struct ir_scancode_table IR_KEYTABLE(a)
+
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
 /* Routines from ir-keytable.c */
 
 u32 ir_g_keycode_from_table(struct input_dev *input_dev,
diff --git a/include/media/keycodes/adstech-dvb-t-pci.h b/include/media/keycodes/adstech-dvb-t-pci.h
new file mode 100644
index 0000000..cfca526
--- /dev/null
+++ b/include/media/keycodes/adstech-dvb-t-pci.h
@@ -0,0 +1,65 @@
+/* adstech-dvb-t-pci.h - Keytable for adstech_dvb_t_pci Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* ADS Tech Instant TV DVB-T PCI Remote */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode adstech_dvb_t_pci[] = {
+	/* Keys 0 to 9 */
+	{ 0x4d, KEY_0 },
+	{ 0x57, KEY_1 },
+	{ 0x4f, KEY_2 },
+	{ 0x53, KEY_3 },
+	{ 0x56, KEY_4 },
+	{ 0x4e, KEY_5 },
+	{ 0x5e, KEY_6 },
+	{ 0x54, KEY_7 },
+	{ 0x4c, KEY_8 },
+	{ 0x5c, KEY_9 },
+
+	{ 0x5b, KEY_POWER },
+	{ 0x5f, KEY_MUTE },
+	{ 0x55, KEY_GOTO },
+	{ 0x5d, KEY_SEARCH },
+	{ 0x17, KEY_EPG },		/* Guide */
+	{ 0x1f, KEY_MENU },
+	{ 0x0f, KEY_UP },
+	{ 0x46, KEY_DOWN },
+	{ 0x16, KEY_LEFT },
+	{ 0x1e, KEY_RIGHT },
+	{ 0x0e, KEY_SELECT },		/* Enter */
+	{ 0x5a, KEY_INFO },
+	{ 0x52, KEY_EXIT },
+	{ 0x59, KEY_PREVIOUS },
+	{ 0x51, KEY_NEXT },
+	{ 0x58, KEY_REWIND },
+	{ 0x50, KEY_FORWARD },
+	{ 0x44, KEY_PLAYPAUSE },
+	{ 0x07, KEY_STOP },
+	{ 0x1b, KEY_RECORD },
+	{ 0x13, KEY_TUNER },		/* Live */
+	{ 0x0a, KEY_A },
+	{ 0x12, KEY_B },
+	{ 0x03, KEY_PROG1 },		/* 1 */
+	{ 0x01, KEY_PROG2 },		/* 2 */
+	{ 0x00, KEY_PROG3 },		/* 3 */
+	{ 0x06, KEY_DVD },
+	{ 0x48, KEY_AUX },		/* Photo */
+	{ 0x40, KEY_VIDEO },
+	{ 0x19, KEY_AUDIO },		/* Music */
+	{ 0x0b, KEY_CHANNELUP },
+	{ 0x08, KEY_CHANNELDOWN },
+	{ 0x15, KEY_VOLUMEUP },
+	{ 0x1c, KEY_VOLUMEDOWN },
+};
+DEFINE_LEGACY_IR_KEYTABLE(adstech_dvb_t_pci);
+#else
+DECLARE_IR_KEYTABLE(adstech_dvb_t_pci);
+#endif
diff --git a/include/media/keycodes/apac-viewcomp.h b/include/media/keycodes/apac-viewcomp.h
new file mode 100644
index 0000000..69460c2
--- /dev/null
+++ b/include/media/keycodes/apac-viewcomp.h
@@ -0,0 +1,56 @@
+/* apac-viewcomp.h - Keytable for apac_viewcomp Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Attila Kondoros <attila.kondoros@chello.hu> */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode apac_viewcomp[] = {
+
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+	{ 0x00, KEY_0 },
+	{ 0x17, KEY_LAST },		/* +100 */
+	{ 0x0a, KEY_LIST },		/* recall */
+
+
+	{ 0x1c, KEY_TUNER },		/* TV/FM */
+	{ 0x15, KEY_SEARCH },		/* scan */
+	{ 0x12, KEY_POWER },		/* power */
+	{ 0x1f, KEY_VOLUMEDOWN },	/* vol up */
+	{ 0x1b, KEY_VOLUMEUP },		/* vol down */
+	{ 0x1e, KEY_CHANNELDOWN },	/* chn up */
+	{ 0x1a, KEY_CHANNELUP },	/* chn down */
+
+	{ 0x11, KEY_VIDEO },		/* video */
+	{ 0x0f, KEY_ZOOM },		/* full screen */
+	{ 0x13, KEY_MUTE },		/* mute/unmute */
+	{ 0x10, KEY_TEXT },		/* min */
+
+	{ 0x0d, KEY_STOP },		/* freeze */
+	{ 0x0e, KEY_RECORD },		/* record */
+	{ 0x1d, KEY_PLAYPAUSE },	/* stop */
+	{ 0x19, KEY_PLAY },		/* play */
+
+	{ 0x16, KEY_GOTO },		/* osd */
+	{ 0x14, KEY_REFRESH },		/* default */
+	{ 0x0c, KEY_KPPLUS },		/* fine tune >>>> */
+	{ 0x18, KEY_KPMINUS },		/* fine tune <<<< */
+};
+DEFINE_LEGACY_IR_KEYTABLE(apac_viewcomp);
+#else
+DECLARE_IR_KEYTABLE(apac_viewcomp);
+#endif
diff --git a/include/media/keycodes/asus-pc39.h b/include/media/keycodes/asus-pc39.h
new file mode 100644
index 0000000..3e89ccd
--- /dev/null
+++ b/include/media/keycodes/asus-pc39.h
@@ -0,0 +1,67 @@
+/* asus-pc39.h - Keytable for asus_pc39 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * Marc Fargas <telenieko@telenieko.com>
+ * this is the remote control that comes with the asus p7131
+ * which has a label saying is "Model PC-39"
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode asus_pc39[] = {
+	/* Keys 0 to 9 */
+	{ 0x15, KEY_0 },
+	{ 0x29, KEY_1 },
+	{ 0x2d, KEY_2 },
+	{ 0x2b, KEY_3 },
+	{ 0x09, KEY_4 },
+	{ 0x0d, KEY_5 },
+	{ 0x0b, KEY_6 },
+	{ 0x31, KEY_7 },
+	{ 0x35, KEY_8 },
+	{ 0x33, KEY_9 },
+
+	{ 0x3e, KEY_RADIO },		/* radio */
+	{ 0x03, KEY_MENU },		/* dvd/menu */
+	{ 0x2a, KEY_VOLUMEUP },
+	{ 0x19, KEY_VOLUMEDOWN },
+	{ 0x37, KEY_UP },
+	{ 0x3b, KEY_DOWN },
+	{ 0x27, KEY_LEFT },
+	{ 0x2f, KEY_RIGHT },
+	{ 0x25, KEY_VIDEO },		/* video */
+	{ 0x39, KEY_AUDIO },		/* music */
+
+	{ 0x21, KEY_TV },		/* tv */
+	{ 0x1d, KEY_EXIT },		/* back */
+	{ 0x0a, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x1b, KEY_CHANNELDOWN },	/* channel / program - */
+	{ 0x1a, KEY_ENTER },		/* enter */
+
+	{ 0x06, KEY_PAUSE },		/* play/pause */
+	{ 0x1e, KEY_PREVIOUS },		/* rew */
+	{ 0x26, KEY_NEXT },		/* forward */
+	{ 0x0e, KEY_REWIND },		/* backward << */
+	{ 0x3a, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x36, KEY_STOP },
+	{ 0x2e, KEY_RECORD },		/* recording */
+	{ 0x16, KEY_POWER },		/* the button that reads "close" */
+
+	{ 0x11, KEY_ZOOM },		/* full screen */
+	{ 0x13, KEY_MACRO },		/* recall */
+	{ 0x23, KEY_HOME },		/* home */
+	{ 0x05, KEY_PVR },		/* picture */
+	{ 0x3d, KEY_MUTE },		/* mute */
+	{ 0x01, KEY_DVD },		/* dvd */
+};
+DEFINE_LEGACY_IR_KEYTABLE(asus_pc39);
+#else
+DECLARE_IR_KEYTABLE(asus_pc39);
+#endif
diff --git a/include/media/keycodes/ati-tv-wonder-hd-600.h b/include/media/keycodes/ati-tv-wonder-hd-600.h
new file mode 100644
index 0000000..25db7bf
--- /dev/null
+++ b/include/media/keycodes/ati-tv-wonder-hd-600.h
@@ -0,0 +1,45 @@
+/* ati-tv-wonder-hd-600.h - Keytable for ati_tv_wonder_hd_600 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* ATI TV Wonder HD 600 USB
+   Devin Heitmueller <devin.heitmueller@gmail.com>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode ati_tv_wonder_hd_600[] = {
+	{ 0x00, KEY_RECORD},		/* Row 1 */
+	{ 0x01, KEY_PLAYPAUSE},
+	{ 0x02, KEY_STOP},
+	{ 0x03, KEY_POWER},
+	{ 0x04, KEY_PREVIOUS},	/* Row 2 */
+	{ 0x05, KEY_REWIND},
+	{ 0x06, KEY_FORWARD},
+	{ 0x07, KEY_NEXT},
+	{ 0x08, KEY_EPG},		/* Row 3 */
+	{ 0x09, KEY_HOME},
+	{ 0x0a, KEY_MENU},
+	{ 0x0b, KEY_CHANNELUP},
+	{ 0x0c, KEY_BACK},		/* Row 4 */
+	{ 0x0d, KEY_UP},
+	{ 0x0e, KEY_INFO},
+	{ 0x0f, KEY_CHANNELDOWN},
+	{ 0x10, KEY_LEFT},		/* Row 5 */
+	{ 0x11, KEY_SELECT},
+	{ 0x12, KEY_RIGHT},
+	{ 0x13, KEY_VOLUMEUP},
+	{ 0x14, KEY_LAST},		/* Row 6 */
+	{ 0x15, KEY_DOWN},
+	{ 0x16, KEY_MUTE},
+	{ 0x17, KEY_VOLUMEDOWN},
+};
+DEFINE_LEGACY_IR_KEYTABLE(ati_tv_wonder_hd_600);
+#else
+DECLARE_IR_KEYTABLE(ati_tv_wonder_hd_600);
+#endif
diff --git a/include/media/keycodes/avermedia-a16d.h b/include/media/keycodes/avermedia-a16d.h
new file mode 100644
index 0000000..d267951
--- /dev/null
+++ b/include/media/keycodes/avermedia-a16d.h
@@ -0,0 +1,52 @@
+/* avermedia-a16d.h - Keytable for avermedia_a16d Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode avermedia_a16d[] = {
+	{ 0x20, KEY_LIST},
+	{ 0x00, KEY_POWER},
+	{ 0x28, KEY_1},
+	{ 0x18, KEY_2},
+	{ 0x38, KEY_3},
+	{ 0x24, KEY_4},
+	{ 0x14, KEY_5},
+	{ 0x34, KEY_6},
+	{ 0x2c, KEY_7},
+	{ 0x1c, KEY_8},
+	{ 0x3c, KEY_9},
+	{ 0x12, KEY_SUBTITLE},
+	{ 0x22, KEY_0},
+	{ 0x32, KEY_REWIND},
+	{ 0x3a, KEY_SHUFFLE},
+	{ 0x02, KEY_PRINT},
+	{ 0x11, KEY_CHANNELDOWN},
+	{ 0x31, KEY_CHANNELUP},
+	{ 0x0c, KEY_ZOOM},
+	{ 0x1e, KEY_VOLUMEDOWN},
+	{ 0x3e, KEY_VOLUMEUP},
+	{ 0x0a, KEY_MUTE},
+	{ 0x04, KEY_AUDIO},
+	{ 0x26, KEY_RECORD},
+	{ 0x06, KEY_PLAY},
+	{ 0x36, KEY_STOP},
+	{ 0x16, KEY_PAUSE},
+	{ 0x2e, KEY_REWIND},
+	{ 0x0e, KEY_FASTFORWARD},
+	{ 0x30, KEY_TEXT},
+	{ 0x21, KEY_GREEN},
+	{ 0x01, KEY_BLUE},
+	{ 0x08, KEY_EPG},
+	{ 0x2a, KEY_MENU},
+};
+DEFINE_LEGACY_IR_KEYTABLE(avermedia_a16d);
+#else
+DECLARE_IR_KEYTABLE(avermedia_a16d);
+#endif
diff --git a/include/media/keycodes/avermedia-cardbus.h b/include/media/keycodes/avermedia-cardbus.h
new file mode 100644
index 0000000..221049d
--- /dev/null
+++ b/include/media/keycodes/avermedia-cardbus.h
@@ -0,0 +1,73 @@
+/* avermedia-cardbus.h - Keytable for avermedia_cardbus Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Oldrich Jedlicka <oldium.pro@seznam.cz> */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode avermedia_cardbus[] = {
+	{ 0x00, KEY_POWER },
+	{ 0x01, KEY_TUNER },		/* TV/FM */
+	{ 0x03, KEY_TEXT },		/* Teletext */
+	{ 0x04, KEY_EPG },
+	{ 0x05, KEY_1 },
+	{ 0x06, KEY_2 },
+	{ 0x07, KEY_3 },
+	{ 0x08, KEY_AUDIO },
+	{ 0x09, KEY_4 },
+	{ 0x0a, KEY_5 },
+	{ 0x0b, KEY_6 },
+	{ 0x0c, KEY_ZOOM },		/* Full screen */
+	{ 0x0d, KEY_7 },
+	{ 0x0e, KEY_8 },
+	{ 0x0f, KEY_9 },
+	{ 0x10, KEY_PAGEUP },		/* 16-CH PREV */
+	{ 0x11, KEY_0 },
+	{ 0x12, KEY_INFO },
+	{ 0x13, KEY_AGAIN },		/* CH RTN - channel return */
+	{ 0x14, KEY_MUTE },
+	{ 0x15, KEY_EDIT },		/* Autoscan */
+	{ 0x17, KEY_SAVE },		/* Screenshot */
+	{ 0x18, KEY_PLAYPAUSE },
+	{ 0x19, KEY_RECORD },
+	{ 0x1a, KEY_PLAY },
+	{ 0x1b, KEY_STOP },
+	{ 0x1c, KEY_FASTFORWARD },
+	{ 0x1d, KEY_REWIND },
+	{ 0x1e, KEY_VOLUMEDOWN },
+	{ 0x1f, KEY_VOLUMEUP },
+	{ 0x22, KEY_SLEEP },		/* Sleep */
+	{ 0x23, KEY_ZOOM },		/* Aspect */
+	{ 0x26, KEY_SCREEN },		/* Pos */
+	{ 0x27, KEY_ANGLE },		/* Size */
+	{ 0x28, KEY_SELECT },		/* Select */
+	{ 0x29, KEY_BLUE },		/* Blue/Picture */
+	{ 0x2a, KEY_BACKSPACE },	/* Back */
+	{ 0x2b, KEY_MEDIA },		/* PIP (Picture-in-picture) */
+	{ 0x2c, KEY_DOWN },
+	{ 0x2e, KEY_DOT },
+	{ 0x2f, KEY_TV },		/* Live TV */
+	{ 0x32, KEY_LEFT },
+	{ 0x33, KEY_CLEAR },		/* Clear */
+	{ 0x35, KEY_RED },		/* Red/TV */
+	{ 0x36, KEY_UP },
+	{ 0x37, KEY_HOME },		/* Home */
+	{ 0x39, KEY_GREEN },		/* Green/Video */
+	{ 0x3d, KEY_YELLOW },		/* Yellow/Music */
+	{ 0x3e, KEY_OK },		/* Ok */
+	{ 0x3f, KEY_RIGHT },
+	{ 0x40, KEY_NEXT },		/* Next */
+	{ 0x41, KEY_PREVIOUS },		/* Previous */
+	{ 0x42, KEY_CHANNELDOWN },	/* Channel down */
+	{ 0x43, KEY_CHANNELUP },	/* Channel up */
+};
+DEFINE_LEGACY_IR_KEYTABLE(avermedia_cardbus);
+#else
+DECLARE_IR_KEYTABLE(avermedia_cardbus);
+#endif
diff --git a/include/media/keycodes/avermedia-dvbt.h b/include/media/keycodes/avermedia-dvbt.h
new file mode 100644
index 0000000..bdaadf4
--- /dev/null
+++ b/include/media/keycodes/avermedia-dvbt.h
@@ -0,0 +1,54 @@
+/* avermedia-dvbt.h - Keytable for avermedia_dvbt Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Matt Jesson <dvb@jesson.eclipse.co.uk */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode avermedia_dvbt[] = {
+	{ 0x28, KEY_0 },		/* '0' / 'enter' */
+	{ 0x22, KEY_1 },		/* '1' */
+	{ 0x12, KEY_2 },		/* '2' / 'up arrow' */
+	{ 0x32, KEY_3 },		/* '3' */
+	{ 0x24, KEY_4 },		/* '4' / 'left arrow' */
+	{ 0x14, KEY_5 },		/* '5' */
+	{ 0x34, KEY_6 },		/* '6' / 'right arrow' */
+	{ 0x26, KEY_7 },		/* '7' */
+	{ 0x16, KEY_8 },		/* '8' / 'down arrow' */
+	{ 0x36, KEY_9 },		/* '9' */
+
+	{ 0x20, KEY_LIST },		/* 'source' */
+	{ 0x10, KEY_TEXT },		/* 'teletext' */
+	{ 0x00, KEY_POWER },		/* 'power' */
+	{ 0x04, KEY_AUDIO },		/* 'audio' */
+	{ 0x06, KEY_ZOOM },		/* 'full screen' */
+	{ 0x18, KEY_VIDEO },		/* 'display' */
+	{ 0x38, KEY_SEARCH },		/* 'loop' */
+	{ 0x08, KEY_INFO },		/* 'preview' */
+	{ 0x2a, KEY_REWIND },		/* 'backward <<' */
+	{ 0x1a, KEY_FASTFORWARD },	/* 'forward >>' */
+	{ 0x3a, KEY_RECORD },		/* 'capture' */
+	{ 0x0a, KEY_MUTE },		/* 'mute' */
+	{ 0x2c, KEY_RECORD },		/* 'record' */
+	{ 0x1c, KEY_PAUSE },		/* 'pause' */
+	{ 0x3c, KEY_STOP },		/* 'stop' */
+	{ 0x0c, KEY_PLAY },		/* 'play' */
+	{ 0x2e, KEY_RED },		/* 'red' */
+	{ 0x01, KEY_BLUE },		/* 'blue' / 'cancel' */
+	{ 0x0e, KEY_YELLOW },		/* 'yellow' / 'ok' */
+	{ 0x21, KEY_GREEN },		/* 'green' */
+	{ 0x11, KEY_CHANNELDOWN },	/* 'channel -' */
+	{ 0x31, KEY_CHANNELUP },	/* 'channel +' */
+	{ 0x1e, KEY_VOLUMEDOWN },	/* 'volume -' */
+	{ 0x3e, KEY_VOLUMEUP },		/* 'volume +' */
+};
+DEFINE_LEGACY_IR_KEYTABLE(avermedia_dvbt);
+#else
+DECLARE_IR_KEYTABLE(avermedia_dvbt);
+#endif
diff --git a/include/media/keycodes/avermedia-m135a-rm-jx.h b/include/media/keycodes/avermedia-m135a-rm-jx.h
new file mode 100644
index 0000000..1158598
--- /dev/null
+++ b/include/media/keycodes/avermedia-m135a-rm-jx.h
@@ -0,0 +1,66 @@
+/* avermedia-m135a-rm-jx.h - Keytable for avermedia_m135a_rm_jx Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * Avermedia M135A with IR model RM-JX
+ * The same codes exist on both Positivo (BR) and original IR
+ * Mauro Carvalho Chehab <mchehab@infradead.org>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode avermedia_m135a_rm_jx[] = {
+	{ 0x0200, KEY_POWER2 },
+	{ 0x022e, KEY_DOT },		/* '.' */
+	{ 0x0201, KEY_MODE },		/* TV/FM or SOURCE */
+
+	{ 0x0205, KEY_1 },
+	{ 0x0206, KEY_2 },
+	{ 0x0207, KEY_3 },
+	{ 0x0209, KEY_4 },
+	{ 0x020a, KEY_5 },
+	{ 0x020b, KEY_6 },
+	{ 0x020d, KEY_7 },
+	{ 0x020e, KEY_8 },
+	{ 0x020f, KEY_9 },
+	{ 0x0211, KEY_0 },
+
+	{ 0x0213, KEY_RIGHT },		/* -> or L */
+	{ 0x0212, KEY_LEFT },		/* <- or R */
+
+	{ 0x0217, KEY_SLEEP },		/* Capturar Imagem or Snapshot */
+	{ 0x0210, KEY_SHUFFLE },	/* Amostra or 16 chan prev */
+
+	{ 0x0303, KEY_CHANNELUP },
+	{ 0x0302, KEY_CHANNELDOWN },
+	{ 0x021f, KEY_VOLUMEUP },
+	{ 0x021e, KEY_VOLUMEDOWN },
+	{ 0x020c, KEY_ENTER },		/* Full Screen */
+
+	{ 0x0214, KEY_MUTE },
+	{ 0x0208, KEY_AUDIO },
+
+	{ 0x0203, KEY_TEXT },		/* Teletext */
+	{ 0x0204, KEY_EPG },
+	{ 0x022b, KEY_TV2 },		/* TV2 or PIP */
+
+	{ 0x021d, KEY_RED },
+	{ 0x021c, KEY_YELLOW },
+	{ 0x0301, KEY_GREEN },
+	{ 0x0300, KEY_BLUE },
+
+	{ 0x021a, KEY_PLAYPAUSE },
+	{ 0x0219, KEY_RECORD },
+	{ 0x0218, KEY_PLAY },
+	{ 0x021b, KEY_STOP },
+};
+DEFINE_IR_KEYTABLE(avermedia_m135a_rm_jx, IR_TYPE_NEC);
+#else
+DECLARE_IR_KEYTABLE(avermedia_m135a_rm_jx);
+#endif
diff --git a/include/media/keycodes/avermedia.h b/include/media/keycodes/avermedia.h
new file mode 100644
index 0000000..a483452
--- /dev/null
+++ b/include/media/keycodes/avermedia.h
@@ -0,0 +1,62 @@
+/* avermedia.h - Keytable for avermedia Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Alex Hermann <gaaf@gmx.net> */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode avermedia[] = {
+	{ 0x28, KEY_1 },
+	{ 0x18, KEY_2 },
+	{ 0x38, KEY_3 },
+	{ 0x24, KEY_4 },
+	{ 0x14, KEY_5 },
+	{ 0x34, KEY_6 },
+	{ 0x2c, KEY_7 },
+	{ 0x1c, KEY_8 },
+	{ 0x3c, KEY_9 },
+	{ 0x22, KEY_0 },
+
+	{ 0x20, KEY_TV },		/* TV/FM */
+	{ 0x10, KEY_CD },		/* CD */
+	{ 0x30, KEY_TEXT },		/* TELETEXT */
+	{ 0x00, KEY_POWER },		/* POWER */
+
+	{ 0x08, KEY_VIDEO },		/* VIDEO */
+	{ 0x04, KEY_AUDIO },		/* AUDIO */
+	{ 0x0c, KEY_ZOOM },		/* FULL SCREEN */
+
+	{ 0x12, KEY_SUBTITLE },		/* DISPLAY */
+	{ 0x32, KEY_REWIND },		/* LOOP	*/
+	{ 0x02, KEY_PRINT },		/* PREVIEW */
+
+	{ 0x2a, KEY_SEARCH },		/* AUTOSCAN */
+	{ 0x1a, KEY_SLEEP },		/* FREEZE */
+	{ 0x3a, KEY_CAMERA },		/* SNAPSHOT */
+	{ 0x0a, KEY_MUTE },		/* MUTE */
+
+	{ 0x26, KEY_RECORD },		/* RECORD */
+	{ 0x16, KEY_PAUSE },		/* PAUSE */
+	{ 0x36, KEY_STOP },		/* STOP */
+	{ 0x06, KEY_PLAY },		/* PLAY */
+
+	{ 0x2e, KEY_RED },		/* RED */
+	{ 0x21, KEY_GREEN },		/* GREEN */
+	{ 0x0e, KEY_YELLOW },		/* YELLOW */
+	{ 0x01, KEY_BLUE },		/* BLUE */
+
+	{ 0x1e, KEY_VOLUMEDOWN },	/* VOLUME- */
+	{ 0x3e, KEY_VOLUMEUP },		/* VOLUME+ */
+	{ 0x11, KEY_CHANNELDOWN },	/* CHANNEL/PAGE- */
+	{ 0x31, KEY_CHANNELUP }		/* CHANNEL/PAGE+ */
+};
+DEFINE_LEGACY_IR_KEYTABLE(avermedia);
+#else
+DECLARE_IR_KEYTABLE(avermedia);
+#endif
diff --git a/include/media/keycodes/avertv-303.h b/include/media/keycodes/avertv-303.h
new file mode 100644
index 0000000..1ef10af
--- /dev/null
+++ b/include/media/keycodes/avertv-303.h
@@ -0,0 +1,61 @@
+/* avertv-303.h - Keytable for avertv_303 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* AVERTV STUDIO 303 Remote */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode avertv_303[] = {
+	{ 0x2a, KEY_1 },
+	{ 0x32, KEY_2 },
+	{ 0x3a, KEY_3 },
+	{ 0x4a, KEY_4 },
+	{ 0x52, KEY_5 },
+	{ 0x5a, KEY_6 },
+	{ 0x6a, KEY_7 },
+	{ 0x72, KEY_8 },
+	{ 0x7a, KEY_9 },
+	{ 0x0e, KEY_0 },
+
+	{ 0x02, KEY_POWER },
+	{ 0x22, KEY_VIDEO },
+	{ 0x42, KEY_AUDIO },
+	{ 0x62, KEY_ZOOM },
+	{ 0x0a, KEY_TV },
+	{ 0x12, KEY_CD },
+	{ 0x1a, KEY_TEXT },
+
+	{ 0x16, KEY_SUBTITLE },
+	{ 0x1e, KEY_REWIND },
+	{ 0x06, KEY_PRINT },
+
+	{ 0x2e, KEY_SEARCH },
+	{ 0x36, KEY_SLEEP },
+	{ 0x3e, KEY_SHUFFLE },
+	{ 0x26, KEY_MUTE },
+
+	{ 0x4e, KEY_RECORD },
+	{ 0x56, KEY_PAUSE },
+	{ 0x5e, KEY_STOP },
+	{ 0x46, KEY_PLAY },
+
+	{ 0x6e, KEY_RED },
+	{ 0x0b, KEY_GREEN },
+	{ 0x66, KEY_YELLOW },
+	{ 0x03, KEY_BLUE },
+
+	{ 0x76, KEY_LEFT },
+	{ 0x7e, KEY_RIGHT },
+	{ 0x13, KEY_DOWN },
+	{ 0x1b, KEY_UP },
+};
+DEFINE_LEGACY_IR_KEYTABLE(avertv_303);
+#else
+DECLARE_IR_KEYTABLE(avertv_303);
+#endif
diff --git a/include/media/keycodes/behold-columbus.h b/include/media/keycodes/behold-columbus.h
new file mode 100644
index 0000000..fb68e75
--- /dev/null
+++ b/include/media/keycodes/behold-columbus.h
@@ -0,0 +1,84 @@
+/* behold-columbus.h - Keytable for behold_columbus Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Beholder Intl. Ltd. 2008
+ * Dmitry Belimov d.belimov@google.com
+ * Keytable is used by BeholdTV Columbus
+ * The "ascii-art picture" below (in comments, first row
+ * is the keycode in hex, and subsequent row(s) shows
+ * the button labels (several variants when appropriate)
+ * helps to descide which keycodes to assign to the buttons.
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode behold_columbus[] = {
+
+	/*  0x13   0x11   0x1C   0x12  *
+	 *  Mute  Source  TV/FM  Power *
+	 *                             */
+
+	{ 0x13, KEY_MUTE },
+	{ 0x11, KEY_PROPS },
+	{ 0x1C, KEY_TUNER },	/* KEY_TV/KEY_RADIO	*/
+	{ 0x12, KEY_POWER },
+
+	/*  0x01    0x02    0x03  0x0D    *
+	 *   1       2       3   Stereo   *
+	 *                        	  *
+	 *  0x04    0x05    0x06  0x19    *
+	 *   4       5       6   Snapshot *
+	 *                        	  *
+	 *  0x07    0x08    0x09  0x10    *
+	 *   7       8       9    Zoom 	  *
+	 *                                */
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x0D, KEY_SETUP },	  /* Setup key */
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x19, KEY_CAMERA },	/* Snapshot key */
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+	{ 0x10, KEY_ZOOM },
+
+	/*  0x0A    0x00    0x0B       0x0C   *
+	 * RECALL    0    ChannelUp  VolumeUp *
+	 *                                    */
+	{ 0x0A, KEY_AGAIN },
+	{ 0x00, KEY_0 },
+	{ 0x0B, KEY_CHANNELUP },
+	{ 0x0C, KEY_VOLUMEUP },
+
+	/*   0x1B      0x1D      0x15        0x18     *
+	 * Timeshift  Record  ChannelDown  VolumeDown *
+	 *                                            */
+
+	{ 0x1B, KEY_TIME },
+	{ 0x1D, KEY_RECORD },
+	{ 0x15, KEY_CHANNELDOWN },
+	{ 0x18, KEY_VOLUMEDOWN },
+
+	/*   0x0E   0x1E     0x0F     0x1A  *
+	 *   Stop   Pause  Previouse  Next  *
+	 *                                  */
+
+	{ 0x0E, KEY_STOP },
+	{ 0x1E, KEY_PAUSE },
+	{ 0x0F, KEY_PREVIOUS },
+	{ 0x1A, KEY_NEXT },
+
+};
+DEFINE_LEGACY_IR_KEYTABLE(behold_columbus);
+#else
+DECLARE_IR_KEYTABLE(behold_columbus);
+#endif
diff --git a/include/media/keycodes/behold.h b/include/media/keycodes/behold.h
new file mode 100644
index 0000000..57a2dae
--- /dev/null
+++ b/include/media/keycodes/behold.h
@@ -0,0 +1,117 @@
+/* behold.h - Keytable for behold Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * Igor Kuznetsov <igk72@ya.ru>
+ * Andrey J. Melnikov <temnota@kmv.ru>
+ *
+ * Keytable is used by BeholdTV 60x series, M6 series at
+ * least, and probably other cards too.
+ * The "ascii-art picture" below (in comments, first row
+ * is the keycode in hex, and subsequent row(s) shows
+ * the button labels (several variants when appropriate)
+ * helps to descide which keycodes to assign to the buttons.
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode behold[] = {
+
+	/*  0x1c            0x12  *
+	 *  TV/FM          POWER  *
+	 *                        */
+	{ 0x1c, KEY_TUNER },	/* XXX KEY_TV / KEY_RADIO */
+	{ 0x12, KEY_POWER },
+
+	/*  0x01    0x02    0x03  *
+	 *   1       2       3    *
+	 *                        *
+	 *  0x04    0x05    0x06  *
+	 *   4       5       6    *
+	 *                        *
+	 *  0x07    0x08    0x09  *
+	 *   7       8       9    *
+	 *                        */
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	/*  0x0a    0x00    0x17  *
+	 * RECALL    0      MODE  *
+	 *                        */
+	{ 0x0a, KEY_AGAIN },
+	{ 0x00, KEY_0 },
+	{ 0x17, KEY_MODE },
+
+	/*  0x14          0x10    *
+	 * ASPECT      FULLSCREEN *
+	 *                        */
+	{ 0x14, KEY_SCREEN },
+	{ 0x10, KEY_ZOOM },
+
+	/*          0x0b          *
+	 *           Up           *
+	 *                        *
+	 *  0x18    0x16    0x0c  *
+	 *  Left     Ok     Right *
+	 *                        *
+	 *         0x015          *
+	 *         Down           *
+	 *                        */
+	{ 0x0b, KEY_CHANNELUP },
+	{ 0x18, KEY_VOLUMEDOWN },
+	{ 0x16, KEY_OK },		/* XXX KEY_ENTER */
+	{ 0x0c, KEY_VOLUMEUP },
+	{ 0x15, KEY_CHANNELDOWN },
+
+	/*  0x11            0x0d  *
+	 *  MUTE            INFO  *
+	 *                        */
+	{ 0x11, KEY_MUTE },
+	{ 0x0d, KEY_INFO },
+
+	/*  0x0f    0x1b    0x1a  *
+	 * RECORD PLAY/PAUSE STOP *
+	 *                        *
+	 *  0x0e    0x1f    0x1e  *
+	 *TELETEXT  AUDIO  SOURCE *
+	 *           RED   YELLOW *
+	 *                        */
+	{ 0x0f, KEY_RECORD },
+	{ 0x1b, KEY_PLAYPAUSE },
+	{ 0x1a, KEY_STOP },
+	{ 0x0e, KEY_TEXT },
+	{ 0x1f, KEY_RED },	/*XXX KEY_AUDIO	*/
+	{ 0x1e, KEY_YELLOW },	/*XXX KEY_SOURCE	*/
+
+	/*  0x1d   0x13     0x19  *
+	 * SLEEP  PREVIEW   DVB   *
+	 *         GREEN    BLUE  *
+	 *                        */
+	{ 0x1d, KEY_SLEEP },
+	{ 0x13, KEY_GREEN },
+	{ 0x19, KEY_BLUE },	/* XXX KEY_SAT	*/
+
+	/*  0x58           0x5c   *
+	 * FREEZE        SNAPSHOT *
+	 *                        */
+	{ 0x58, KEY_SLOW },
+	{ 0x5c, KEY_CAMERA },
+
+};
+DEFINE_LEGACY_IR_KEYTABLE(behold);
+#else
+DECLARE_IR_KEYTABLE(behold);
+#endif
diff --git a/include/media/keycodes/budget-ci-old.h b/include/media/keycodes/budget-ci-old.h
new file mode 100644
index 0000000..03ada47
--- /dev/null
+++ b/include/media/keycodes/budget-ci-old.h
@@ -0,0 +1,68 @@
+/* budget-ci-old.h - Keytable for budget_ci_old Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* From reading the following remotes:
+ * Zenith Universal 7 / TV Mode 807 / VCR Mode 837
+ * Hauppauge (from NOVA-CI-s box product)
+ * This is a "middle of the road" approach, differences are noted
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode budget_ci_old[] = {
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+	{ 0x0a, KEY_ENTER },
+	{ 0x0b, KEY_RED },
+	{ 0x0c, KEY_POWER },		/* RADIO on Hauppauge */
+	{ 0x0d, KEY_MUTE },
+	{ 0x0f, KEY_A },		/* TV on Hauppauge */
+	{ 0x10, KEY_VOLUMEUP },
+	{ 0x11, KEY_VOLUMEDOWN },
+	{ 0x14, KEY_B },
+	{ 0x1c, KEY_UP },
+	{ 0x1d, KEY_DOWN },
+	{ 0x1e, KEY_OPTION },		/* RESERVED on Hauppauge */
+	{ 0x1f, KEY_BREAK },
+	{ 0x20, KEY_CHANNELUP },
+	{ 0x21, KEY_CHANNELDOWN },
+	{ 0x22, KEY_PREVIOUS },		/* Prev Ch on Zenith, SOURCE on Hauppauge */
+	{ 0x24, KEY_RESTART },
+	{ 0x25, KEY_OK },
+	{ 0x26, KEY_CYCLEWINDOWS },	/* MINIMIZE on Hauppauge */
+	{ 0x28, KEY_ENTER },		/* VCR mode on Zenith */
+	{ 0x29, KEY_PAUSE },
+	{ 0x2b, KEY_RIGHT },
+	{ 0x2c, KEY_LEFT },
+	{ 0x2e, KEY_MENU },		/* FULL SCREEN on Hauppauge */
+	{ 0x30, KEY_SLOW },
+	{ 0x31, KEY_PREVIOUS },		/* VCR mode on Zenith */
+	{ 0x32, KEY_REWIND },
+	{ 0x34, KEY_FASTFORWARD },
+	{ 0x35, KEY_PLAY },
+	{ 0x36, KEY_STOP },
+	{ 0x37, KEY_RECORD },
+	{ 0x38, KEY_TUNER },		/* TV/VCR on Zenith */
+	{ 0x3a, KEY_C },
+	{ 0x3c, KEY_EXIT },
+	{ 0x3d, KEY_POWER2 },
+	{ 0x3e, KEY_TUNER },
+};
+DEFINE_LEGACY_IR_KEYTABLE(budget_ci_old);
+#else
+DECLARE_IR_KEYTABLE(budget_ci_old);
+#endif
diff --git a/include/media/keycodes/cinergy-1400.h b/include/media/keycodes/cinergy-1400.h
new file mode 100644
index 0000000..9b562ea
--- /dev/null
+++ b/include/media/keycodes/cinergy-1400.h
@@ -0,0 +1,60 @@
+/* cinergy-1400.h - Keytable for cinergy_1400 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Cinergy 1400 DVB-T */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode cinergy_1400[] = {
+	{ 0x01, KEY_POWER },
+	{ 0x02, KEY_1 },
+	{ 0x03, KEY_2 },
+	{ 0x04, KEY_3 },
+	{ 0x05, KEY_4 },
+	{ 0x06, KEY_5 },
+	{ 0x07, KEY_6 },
+	{ 0x08, KEY_7 },
+	{ 0x09, KEY_8 },
+	{ 0x0a, KEY_9 },
+	{ 0x0c, KEY_0 },
+
+	{ 0x0b, KEY_VIDEO },
+	{ 0x0d, KEY_REFRESH },
+	{ 0x0e, KEY_SELECT },
+	{ 0x0f, KEY_EPG },
+	{ 0x10, KEY_UP },
+	{ 0x11, KEY_LEFT },
+	{ 0x12, KEY_OK },
+	{ 0x13, KEY_RIGHT },
+	{ 0x14, KEY_DOWN },
+	{ 0x15, KEY_TEXT },
+	{ 0x16, KEY_INFO },
+
+	{ 0x17, KEY_RED },
+	{ 0x18, KEY_GREEN },
+	{ 0x19, KEY_YELLOW },
+	{ 0x1a, KEY_BLUE },
+
+	{ 0x1b, KEY_CHANNELUP },
+	{ 0x1c, KEY_VOLUMEUP },
+	{ 0x1d, KEY_MUTE },
+	{ 0x1e, KEY_VOLUMEDOWN },
+	{ 0x1f, KEY_CHANNELDOWN },
+
+	{ 0x40, KEY_PAUSE },
+	{ 0x4c, KEY_PLAY },
+	{ 0x58, KEY_RECORD },
+	{ 0x54, KEY_PREVIOUS },
+	{ 0x48, KEY_STOP },
+	{ 0x5c, KEY_NEXT },
+};
+DEFINE_LEGACY_IR_KEYTABLE(cinergy_1400);
+#else
+DECLARE_IR_KEYTABLE(cinergy_1400);
+#endif
diff --git a/include/media/keycodes/cinergy.h b/include/media/keycodes/cinergy.h
new file mode 100644
index 0000000..7884696
--- /dev/null
+++ b/include/media/keycodes/cinergy.h
@@ -0,0 +1,55 @@
+/* cinergy.h - Keytable for cinergy Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode cinergy[] = {
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	{ 0x0a, KEY_POWER },
+	{ 0x0b, KEY_PROG1 },		/* app */
+	{ 0x0c, KEY_ZOOM },		/* zoom/fullscreen */
+	{ 0x0d, KEY_CHANNELUP },	/* channel */
+	{ 0x0e, KEY_CHANNELDOWN },	/* channel- */
+	{ 0x0f, KEY_VOLUMEUP },
+	{ 0x10, KEY_VOLUMEDOWN },
+	{ 0x11, KEY_TUNER },		/* AV */
+	{ 0x12, KEY_NUMLOCK },		/* -/-- */
+	{ 0x13, KEY_AUDIO },		/* audio */
+	{ 0x14, KEY_MUTE },
+	{ 0x15, KEY_UP },
+	{ 0x16, KEY_DOWN },
+	{ 0x17, KEY_LEFT },
+	{ 0x18, KEY_RIGHT },
+	{ 0x19, BTN_LEFT, },
+	{ 0x1a, BTN_RIGHT, },
+	{ 0x1b, KEY_WWW },		/* text */
+	{ 0x1c, KEY_REWIND },
+	{ 0x1d, KEY_FORWARD },
+	{ 0x1e, KEY_RECORD },
+	{ 0x1f, KEY_PLAY },
+	{ 0x20, KEY_PREVIOUSSONG },
+	{ 0x21, KEY_NEXTSONG },
+	{ 0x22, KEY_PAUSE },
+	{ 0x23, KEY_STOP },
+};
+DEFINE_LEGACY_IR_KEYTABLE(cinergy);
+#else
+DECLARE_IR_KEYTABLE(cinergy);
+#endif
diff --git a/include/media/keycodes/dm1105-nec.h b/include/media/keycodes/dm1105-nec.h
new file mode 100644
index 0000000..b87d770
--- /dev/null
+++ b/include/media/keycodes/dm1105-nec.h
@@ -0,0 +1,52 @@
+/* dm1105-nec.h - Keytable for dm1105_nec Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* DVBWorld remotes
+   Igor M. Liplianin <liplianin@me.by>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode dm1105_nec[] = {
+	{ 0x0a, KEY_POWER2},		/* power */
+	{ 0x0c, KEY_MUTE},		/* mute */
+	{ 0x11, KEY_1},
+	{ 0x12, KEY_2},
+	{ 0x13, KEY_3},
+	{ 0x14, KEY_4},
+	{ 0x15, KEY_5},
+	{ 0x16, KEY_6},
+	{ 0x17, KEY_7},
+	{ 0x18, KEY_8},
+	{ 0x19, KEY_9},
+	{ 0x10, KEY_0},
+	{ 0x1c, KEY_CHANNELUP},		/* ch+ */
+	{ 0x0f, KEY_CHANNELDOWN},	/* ch- */
+	{ 0x1a, KEY_VOLUMEUP},		/* vol+ */
+	{ 0x0e, KEY_VOLUMEDOWN},	/* vol- */
+	{ 0x04, KEY_RECORD},		/* rec */
+	{ 0x09, KEY_CHANNEL},		/* fav */
+	{ 0x08, KEY_BACKSPACE},		/* rewind */
+	{ 0x07, KEY_FASTFORWARD},	/* fast */
+	{ 0x0b, KEY_PAUSE},		/* pause */
+	{ 0x02, KEY_ESC},		/* cancel */
+	{ 0x03, KEY_TAB},		/* tab */
+	{ 0x00, KEY_UP},		/* up */
+	{ 0x1f, KEY_ENTER},		/* ok */
+	{ 0x01, KEY_DOWN},		/* down */
+	{ 0x05, KEY_RECORD},		/* cap */
+	{ 0x06, KEY_STOP},		/* stop */
+	{ 0x40, KEY_ZOOM},		/* full */
+	{ 0x1e, KEY_TV},		/* tvmode */
+	{ 0x1b, KEY_B},			/* recall */
+};
+DEFINE_LEGACY_IR_KEYTABLE(dm1105_nec);
+#else
+DECLARE_IR_KEYTABLE(dm1105_nec);
+#endif
diff --git a/include/media/keycodes/dntv-live-dvb-t.h b/include/media/keycodes/dntv-live-dvb-t.h
new file mode 100644
index 0000000..4431ae6
--- /dev/null
+++ b/include/media/keycodes/dntv-live-dvb-t.h
@@ -0,0 +1,54 @@
+/* dntv-live-dvb-t.h - Keytable for dntv_live_dvb_t Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* DigitalNow DNTV Live DVB-T Remote */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode dntv_live_dvb_t[] = {
+	{ 0x00, KEY_ESC },		/* 'go up a level?' */
+	/* Keys 0 to 9 */
+	{ 0x0a, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	{ 0x0b, KEY_TUNER },		/* tv/fm */
+	{ 0x0c, KEY_SEARCH },		/* scan */
+	{ 0x0d, KEY_STOP },
+	{ 0x0e, KEY_PAUSE },
+	{ 0x0f, KEY_LIST },		/* source */
+
+	{ 0x10, KEY_MUTE },
+	{ 0x11, KEY_REWIND },		/* backward << */
+	{ 0x12, KEY_POWER },
+	{ 0x13, KEY_CAMERA },		/* snap */
+	{ 0x14, KEY_AUDIO },		/* stereo */
+	{ 0x15, KEY_CLEAR },		/* reset */
+	{ 0x16, KEY_PLAY },
+	{ 0x17, KEY_ENTER },
+	{ 0x18, KEY_ZOOM },		/* full screen */
+	{ 0x19, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x1a, KEY_CHANNELUP },
+	{ 0x1b, KEY_VOLUMEUP },
+	{ 0x1c, KEY_INFO },		/* preview */
+	{ 0x1d, KEY_RECORD },		/* record */
+	{ 0x1e, KEY_CHANNELDOWN },
+	{ 0x1f, KEY_VOLUMEDOWN },
+};
+DEFINE_LEGACY_IR_KEYTABLE(dntv_live_dvb_t);
+#else
+DECLARE_IR_KEYTABLE(dntv_live_dvb_t);
+#endif
diff --git a/include/media/keycodes/dntv-live-dvbt-pro.h b/include/media/keycodes/dntv-live-dvbt-pro.h
new file mode 100644
index 0000000..d64fa26
--- /dev/null
+++ b/include/media/keycodes/dntv-live-dvbt-pro.h
@@ -0,0 +1,73 @@
+/* dntv-live-dvbt-pro.h - Keytable for dntv_live_dvbt_pro Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* DigitalNow DNTV Live! DVB-T Pro Remote */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode dntv_live_dvbt_pro[] = {
+	{ 0x16, KEY_POWER },
+	{ 0x5b, KEY_HOME },
+
+	{ 0x55, KEY_TV },		/* live tv */
+	{ 0x58, KEY_TUNER },		/* digital Radio */
+	{ 0x5a, KEY_RADIO },		/* FM radio */
+	{ 0x59, KEY_DVD },		/* dvd menu */
+	{ 0x03, KEY_1 },
+	{ 0x01, KEY_2 },
+	{ 0x06, KEY_3 },
+	{ 0x09, KEY_4 },
+	{ 0x1d, KEY_5 },
+	{ 0x1f, KEY_6 },
+	{ 0x0d, KEY_7 },
+	{ 0x19, KEY_8 },
+	{ 0x1b, KEY_9 },
+	{ 0x0c, KEY_CANCEL },
+	{ 0x15, KEY_0 },
+	{ 0x4a, KEY_CLEAR },
+	{ 0x13, KEY_BACK },
+	{ 0x00, KEY_TAB },
+	{ 0x4b, KEY_UP },
+	{ 0x4e, KEY_LEFT },
+	{ 0x4f, KEY_OK },
+	{ 0x52, KEY_RIGHT },
+	{ 0x51, KEY_DOWN },
+	{ 0x1e, KEY_VOLUMEUP },
+	{ 0x0a, KEY_VOLUMEDOWN },
+	{ 0x02, KEY_CHANNELDOWN },
+	{ 0x05, KEY_CHANNELUP },
+	{ 0x11, KEY_RECORD },
+	{ 0x14, KEY_PLAY },
+	{ 0x4c, KEY_PAUSE },
+	{ 0x1a, KEY_STOP },
+	{ 0x40, KEY_REWIND },
+	{ 0x12, KEY_FASTFORWARD },
+	{ 0x41, KEY_PREVIOUSSONG },	/* replay |< */
+	{ 0x42, KEY_NEXTSONG },		/* skip >| */
+	{ 0x54, KEY_CAMERA },		/* capture */
+	{ 0x50, KEY_LANGUAGE },		/* sap */
+	{ 0x47, KEY_TV2 },		/* pip */
+	{ 0x4d, KEY_SCREEN },
+	{ 0x43, KEY_SUBTITLE },
+	{ 0x10, KEY_MUTE },
+	{ 0x49, KEY_AUDIO },		/* l/r */
+	{ 0x07, KEY_SLEEP },
+	{ 0x08, KEY_VIDEO },		/* a/v */
+	{ 0x0e, KEY_PREVIOUS },		/* recall */
+	{ 0x45, KEY_ZOOM },		/* zoom + */
+	{ 0x46, KEY_ANGLE },		/* zoom - */
+	{ 0x56, KEY_RED },
+	{ 0x57, KEY_GREEN },
+	{ 0x5c, KEY_YELLOW },
+	{ 0x5d, KEY_BLUE },
+};
+DEFINE_LEGACY_IR_KEYTABLE(dntv_live_dvbt_pro);
+#else
+DECLARE_IR_KEYTABLE(dntv_live_dvbt_pro);
+#endif
diff --git a/include/media/keycodes/em-terratec.h b/include/media/keycodes/em-terratec.h
new file mode 100644
index 0000000..906557d
--- /dev/null
+++ b/include/media/keycodes/em-terratec.h
@@ -0,0 +1,46 @@
+/* em-terratec.h - Keytable for em_terratec Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode em_terratec[] = {
+	{ 0x01, KEY_CHANNEL },
+	{ 0x02, KEY_SELECT },
+	{ 0x03, KEY_MUTE },
+	{ 0x04, KEY_POWER },
+	{ 0x05, KEY_1 },
+	{ 0x06, KEY_2 },
+	{ 0x07, KEY_3 },
+	{ 0x08, KEY_CHANNELUP },
+	{ 0x09, KEY_4 },
+	{ 0x0a, KEY_5 },
+	{ 0x0b, KEY_6 },
+	{ 0x0c, KEY_CHANNELDOWN },
+	{ 0x0d, KEY_7 },
+	{ 0x0e, KEY_8 },
+	{ 0x0f, KEY_9 },
+	{ 0x10, KEY_VOLUMEUP },
+	{ 0x11, KEY_0 },
+	{ 0x12, KEY_MENU },
+	{ 0x13, KEY_PRINT },
+	{ 0x14, KEY_VOLUMEDOWN },
+	{ 0x16, KEY_PAUSE },
+	{ 0x18, KEY_RECORD },
+	{ 0x19, KEY_REWIND },
+	{ 0x1a, KEY_PLAY },
+	{ 0x1b, KEY_FORWARD },
+	{ 0x1c, KEY_BACKSPACE },
+	{ 0x1e, KEY_STOP },
+	{ 0x40, KEY_ZOOM },
+};
+DEFINE_LEGACY_IR_KEYTABLE(em_terratec);
+#else
+DECLARE_IR_KEYTABLE(em_terratec);
+#endif
diff --git a/include/media/keycodes/empty.h b/include/media/keycodes/empty.h
new file mode 100644
index 0000000..aea866c
--- /dev/null
+++ b/include/media/keycodes/empty.h
@@ -0,0 +1,20 @@
+/* empty.h - Keytable for empty Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* empty keytable, can be used as placeholder for not-yet created keytables */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode empty[] = {
+	{ 0x2a, KEY_COFFEE },
+};
+DEFINE_LEGACY_IR_KEYTABLE(empty);
+#else
+DECLARE_IR_KEYTABLE(empty);
+#endif
diff --git a/include/media/keycodes/encore-enltv-fm53.h b/include/media/keycodes/encore-enltv-fm53.h
new file mode 100644
index 0000000..bccb744
--- /dev/null
+++ b/include/media/keycodes/encore-enltv-fm53.h
@@ -0,0 +1,57 @@
+/* encore-enltv-fm53.h - Keytable for encore_enltv_fm53 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Encore ENLTV-FM v5.3
+   Mauro Carvalho Chehab <mchehab@infradead.org>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode encore_enltv_fm53[] = {
+	{ 0x10, KEY_POWER2},
+	{ 0x06, KEY_MUTE},
+
+	{ 0x09, KEY_1},
+	{ 0x1d, KEY_2},
+	{ 0x1f, KEY_3},
+	{ 0x19, KEY_4},
+	{ 0x1b, KEY_5},
+	{ 0x11, KEY_6},
+	{ 0x17, KEY_7},
+	{ 0x12, KEY_8},
+	{ 0x16, KEY_9},
+	{ 0x48, KEY_0},
+
+	{ 0x04, KEY_LIST},		/* -/-- */
+	{ 0x40, KEY_LAST},		/* recall */
+
+	{ 0x02, KEY_MODE},		/* TV/AV */
+	{ 0x05, KEY_CAMERA},		/* SNAPSHOT */
+
+	{ 0x4c, KEY_CHANNELUP},		/* UP */
+	{ 0x00, KEY_CHANNELDOWN},	/* DOWN */
+	{ 0x0d, KEY_VOLUMEUP},		/* RIGHT */
+	{ 0x15, KEY_VOLUMEDOWN},	/* LEFT */
+	{ 0x49, KEY_ENTER},		/* OK */
+
+	{ 0x54, KEY_RECORD},
+	{ 0x4d, KEY_PLAY},		/* pause */
+
+	{ 0x1e, KEY_MENU},		/* video setting */
+	{ 0x0e, KEY_RIGHT},		/* <- */
+	{ 0x1a, KEY_LEFT},		/* -> */
+
+	{ 0x0a, KEY_CLEAR},		/* video default */
+	{ 0x0c, KEY_ZOOM},		/* hide pannel */
+	{ 0x47, KEY_SLEEP},		/* shutdown */
+};
+DEFINE_LEGACY_IR_KEYTABLE(encore_enltv_fm53);
+#else
+DECLARE_IR_KEYTABLE(encore_enltv_fm53);
+#endif
diff --git a/include/media/keycodes/encore-enltv.h b/include/media/keycodes/encore-enltv.h
new file mode 100644
index 0000000..4c55b52
--- /dev/null
+++ b/include/media/keycodes/encore-enltv.h
@@ -0,0 +1,88 @@
+/* encore-enltv.h - Keytable for encore_enltv Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Encore ENLTV-FM  - black plastic, white front cover with white glowing buttons
+    Juan Pablo Sormani <sorman@gmail.com> */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode encore_enltv[] = {
+
+	/* Power button does nothing, neither in Windows app,
+	 although it sends data (used for BIOS wakeup?) */
+	{ 0x0d, KEY_MUTE },
+
+	{ 0x1e, KEY_TV },
+	{ 0x00, KEY_VIDEO },
+	{ 0x01, KEY_AUDIO },		/* music */
+	{ 0x02, KEY_MHP },		/* picture */
+
+	{ 0x1f, KEY_1 },
+	{ 0x03, KEY_2 },
+	{ 0x04, KEY_3 },
+	{ 0x05, KEY_4 },
+	{ 0x1c, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x1d, KEY_9 },
+	{ 0x0a, KEY_0 },
+
+	{ 0x09, KEY_LIST },		/* -/-- */
+	{ 0x0b, KEY_LAST },		/* recall */
+
+	{ 0x14, KEY_HOME },		/* win start menu */
+	{ 0x15, KEY_EXIT },		/* exit */
+	{ 0x16, KEY_CHANNELUP },	/* UP */
+	{ 0x12, KEY_CHANNELDOWN },	/* DOWN */
+	{ 0x0c, KEY_VOLUMEUP },		/* RIGHT */
+	{ 0x17, KEY_VOLUMEDOWN },	/* LEFT */
+
+	{ 0x18, KEY_ENTER },		/* OK */
+
+	{ 0x0e, KEY_ESC },
+	{ 0x13, KEY_CYCLEWINDOWS },	/* desktop */
+	{ 0x11, KEY_TAB },
+	{ 0x19, KEY_SWITCHVIDEOMODE },	/* switch */
+
+	{ 0x1a, KEY_MENU },
+	{ 0x1b, KEY_ZOOM },		/* fullscreen */
+	{ 0x44, KEY_TIME },		/* time shift */
+	{ 0x40, KEY_MODE },		/* source */
+
+	{ 0x5a, KEY_RECORD },
+	{ 0x42, KEY_PLAY },		/* play/pause */
+	{ 0x45, KEY_STOP },
+	{ 0x43, KEY_CAMERA },		/* camera icon */
+
+	{ 0x48, KEY_REWIND },
+	{ 0x4a, KEY_FASTFORWARD },
+	{ 0x49, KEY_PREVIOUS },
+	{ 0x4b, KEY_NEXT },
+
+	{ 0x4c, KEY_FAVORITES },	/* tv wall */
+	{ 0x4d, KEY_SOUND },		/* DVD sound */
+	{ 0x4e, KEY_LANGUAGE },		/* DVD lang */
+	{ 0x4f, KEY_TEXT },		/* DVD text */
+
+	{ 0x50, KEY_SLEEP },		/* shutdown */
+	{ 0x51, KEY_MODE },		/* stereo > main */
+	{ 0x52, KEY_SELECT },		/* stereo > sap */
+	{ 0x53, KEY_PROG1 },		/* teletext */
+
+
+	{ 0x59, KEY_RED },		/* AP1 */
+	{ 0x41, KEY_GREEN },		/* AP2 */
+	{ 0x47, KEY_YELLOW },		/* AP3 */
+	{ 0x57, KEY_BLUE },		/* AP4 */
+};
+DEFINE_LEGACY_IR_KEYTABLE(encore_enltv);
+#else
+DECLARE_IR_KEYTABLE(encore_enltv);
+#endif
diff --git a/include/media/keycodes/encore-enltv2.h b/include/media/keycodes/encore-enltv2.h
new file mode 100644
index 0000000..6b37fbc
--- /dev/null
+++ b/include/media/keycodes/encore-enltv2.h
@@ -0,0 +1,66 @@
+/* encore-enltv2.h - Keytable for encore_enltv2 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Encore ENLTV2-FM  - silver plastic - "Wand Media" written at the botton
+    Mauro Carvalho Chehab <mchehab@infradead.org> */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode encore_enltv2[] = {
+	{ 0x4c, KEY_POWER2 },
+	{ 0x4a, KEY_TUNER },
+	{ 0x40, KEY_1 },
+	{ 0x60, KEY_2 },
+	{ 0x50, KEY_3 },
+	{ 0x70, KEY_4 },
+	{ 0x48, KEY_5 },
+	{ 0x68, KEY_6 },
+	{ 0x58, KEY_7 },
+	{ 0x78, KEY_8 },
+	{ 0x44, KEY_9 },
+	{ 0x54, KEY_0 },
+
+	{ 0x64, KEY_LAST },		/* +100 */
+	{ 0x4e, KEY_AGAIN },		/* Recall */
+
+	{ 0x6c, KEY_SWITCHVIDEOMODE },	/* Video Source */
+	{ 0x5e, KEY_MENU },
+	{ 0x56, KEY_SCREEN },
+	{ 0x7a, KEY_SETUP },
+
+	{ 0x46, KEY_MUTE },
+	{ 0x5c, KEY_MODE },		/* Stereo */
+	{ 0x74, KEY_INFO },
+	{ 0x7c, KEY_CLEAR },
+
+	{ 0x55, KEY_UP },
+	{ 0x49, KEY_DOWN },
+	{ 0x7e, KEY_LEFT },
+	{ 0x59, KEY_RIGHT },
+	{ 0x6a, KEY_ENTER },
+
+	{ 0x42, KEY_VOLUMEUP },
+	{ 0x62, KEY_VOLUMEDOWN },
+	{ 0x52, KEY_CHANNELUP },
+	{ 0x72, KEY_CHANNELDOWN },
+
+	{ 0x41, KEY_RECORD },
+	{ 0x51, KEY_CAMERA },		/* Snapshot */
+	{ 0x75, KEY_TIME },		/* Timeshift */
+	{ 0x71, KEY_TV2 },		/* PIP */
+
+	{ 0x45, KEY_REWIND },
+	{ 0x6f, KEY_PAUSE },
+	{ 0x7d, KEY_FORWARD },
+	{ 0x79, KEY_STOP },
+};
+DEFINE_LEGACY_IR_KEYTABLE(encore_enltv2);
+#else
+DECLARE_IR_KEYTABLE(encore_enltv2);
+#endif
diff --git a/include/media/keycodes/evga-indtube.h b/include/media/keycodes/evga-indtube.h
new file mode 100644
index 0000000..2aab58d
--- /dev/null
+++ b/include/media/keycodes/evga-indtube.h
@@ -0,0 +1,37 @@
+/* evga-indtube.h - Keytable for evga_indtube Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* EVGA inDtube
+   Devin Heitmueller <devin.heitmueller@gmail.com>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode evga_indtube[] = {
+	{ 0x12, KEY_POWER},
+	{ 0x02, KEY_MODE},	/* TV */
+	{ 0x14, KEY_MUTE},
+	{ 0x1a, KEY_CHANNELUP},
+	{ 0x16, KEY_TV2},	/* PIP */
+	{ 0x1d, KEY_VOLUMEUP},
+	{ 0x05, KEY_CHANNELDOWN},
+	{ 0x0f, KEY_PLAYPAUSE},
+	{ 0x19, KEY_VOLUMEDOWN},
+	{ 0x1c, KEY_REWIND},
+	{ 0x0d, KEY_RECORD},
+	{ 0x18, KEY_FORWARD},
+	{ 0x1e, KEY_PREVIOUS},
+	{ 0x1b, KEY_STOP},
+	{ 0x1f, KEY_NEXT},
+	{ 0x13, KEY_CAMERA},
+};
+DEFINE_LEGACY_IR_KEYTABLE(evga_indtube);
+#else
+DECLARE_IR_KEYTABLE(evga_indtube);
+#endif
diff --git a/include/media/keycodes/eztv.h b/include/media/keycodes/eztv.h
new file mode 100644
index 0000000..030f57a
--- /dev/null
+++ b/include/media/keycodes/eztv.h
@@ -0,0 +1,72 @@
+/* eztv.h - Keytable for eztv Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Alfons Geser <a.geser@cox.net>
+ * updates from Job D. R. Borges <jobdrb@ig.com.br> */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode eztv[] = {
+	{ 0x12, KEY_POWER },
+	{ 0x01, KEY_TV },	/* DVR */
+	{ 0x15, KEY_DVD },	/* DVD */
+	{ 0x17, KEY_AUDIO },	/* music */
+				/* DVR mode / DVD mode / music mode */
+
+	{ 0x1b, KEY_MUTE },	/* mute */
+	{ 0x02, KEY_LANGUAGE },	/* MTS/SAP / audio / autoseek */
+	{ 0x1e, KEY_SUBTITLE },	/* closed captioning / subtitle / seek */
+	{ 0x16, KEY_ZOOM },	/* full screen */
+	{ 0x1c, KEY_VIDEO },	/* video source / eject / delall */
+	{ 0x1d, KEY_RESTART },	/* playback / angle / del */
+	{ 0x2f, KEY_SEARCH },	/* scan / menu / playlist */
+	{ 0x30, KEY_CHANNEL },	/* CH surfing / bookmark / memo */
+
+	{ 0x31, KEY_HELP },	/* help */
+	{ 0x32, KEY_MODE },	/* num/memo */
+	{ 0x33, KEY_ESC },	/* cancel */
+
+	{ 0x0c, KEY_UP },	/* up */
+	{ 0x10, KEY_DOWN },	/* down */
+	{ 0x08, KEY_LEFT },	/* left */
+	{ 0x04, KEY_RIGHT },	/* right */
+	{ 0x03, KEY_SELECT },	/* select */
+
+	{ 0x1f, KEY_REWIND },	/* rewind */
+	{ 0x20, KEY_PLAYPAUSE },/* play/pause */
+	{ 0x29, KEY_FORWARD },	/* forward */
+	{ 0x14, KEY_AGAIN },	/* repeat */
+	{ 0x2b, KEY_RECORD },	/* recording */
+	{ 0x2c, KEY_STOP },	/* stop */
+	{ 0x2d, KEY_PLAY },	/* play */
+	{ 0x2e, KEY_CAMERA },	/* snapshot / shuffle */
+
+	{ 0x00, KEY_0 },
+	{ 0x05, KEY_1 },
+	{ 0x06, KEY_2 },
+	{ 0x07, KEY_3 },
+	{ 0x09, KEY_4 },
+	{ 0x0a, KEY_5 },
+	{ 0x0b, KEY_6 },
+	{ 0x0d, KEY_7 },
+	{ 0x0e, KEY_8 },
+	{ 0x0f, KEY_9 },
+
+	{ 0x2a, KEY_VOLUMEUP },
+	{ 0x11, KEY_VOLUMEDOWN },
+	{ 0x18, KEY_CHANNELUP },/* CH.tracking up */
+	{ 0x19, KEY_CHANNELDOWN },/* CH.tracking down */
+
+	{ 0x13, KEY_ENTER },	/* enter */
+	{ 0x21, KEY_DOT },	/* . (decimal dot) */
+};
+DEFINE_LEGACY_IR_KEYTABLE(eztv);
+#else
+DECLARE_IR_KEYTABLE(eztv);
+#endif
diff --git a/include/media/keycodes/flydvb.h b/include/media/keycodes/flydvb.h
new file mode 100644
index 0000000..b270cc0
--- /dev/null
+++ b/include/media/keycodes/flydvb.h
@@ -0,0 +1,54 @@
+/* flydvb.h - Keytable for flydvb Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode flydvb[] = {
+	{ 0x01, KEY_ZOOM },		/* Full Screen */
+	{ 0x00, KEY_POWER },		/* Power */
+
+	{ 0x03, KEY_1 },
+	{ 0x04, KEY_2 },
+	{ 0x05, KEY_3 },
+	{ 0x07, KEY_4 },
+	{ 0x08, KEY_5 },
+	{ 0x09, KEY_6 },
+	{ 0x0b, KEY_7 },
+	{ 0x0c, KEY_8 },
+	{ 0x0d, KEY_9 },
+	{ 0x06, KEY_AGAIN },		/* Recall */
+	{ 0x0f, KEY_0 },
+	{ 0x10, KEY_MUTE },		/* Mute */
+	{ 0x02, KEY_RADIO },		/* TV/Radio */
+	{ 0x1b, KEY_LANGUAGE },		/* SAP (Second Audio Program) */
+
+	{ 0x14, KEY_VOLUMEUP },		/* VOL+ */
+	{ 0x17, KEY_VOLUMEDOWN },	/* VOL- */
+	{ 0x12, KEY_CHANNELUP },	/* CH+ */
+	{ 0x13, KEY_CHANNELDOWN },	/* CH- */
+	{ 0x1d, KEY_ENTER },		/* Enter */
+
+	{ 0x1a, KEY_MODE },		/* PIP */
+	{ 0x18, KEY_TUNER },		/* Source */
+
+	{ 0x1e, KEY_RECORD },		/* Record/Pause */
+	{ 0x15, KEY_ANGLE },		/* Swap (no label on key) */
+	{ 0x1c, KEY_PAUSE },		/* Timeshift/Pause */
+	{ 0x19, KEY_BACK },		/* Rewind << */
+	{ 0x0a, KEY_PLAYPAUSE },	/* Play/Pause */
+	{ 0x1f, KEY_FORWARD },		/* Forward >> */
+	{ 0x16, KEY_PREVIOUS },		/* Back |<< */
+	{ 0x11, KEY_STOP },		/* Stop */
+	{ 0x0e, KEY_NEXT },		/* End >>| */
+};
+DEFINE_LEGACY_IR_KEYTABLE(flydvb);
+#else
+DECLARE_IR_KEYTABLE(flydvb);
+#endif
diff --git a/include/media/keycodes/flyvideo.h b/include/media/keycodes/flyvideo.h
new file mode 100644
index 0000000..5c52f92
--- /dev/null
+++ b/include/media/keycodes/flyvideo.h
@@ -0,0 +1,47 @@
+/* flyvideo.h - Keytable for flyvideo Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode flyvideo[] = {
+	{ 0x0f, KEY_0 },
+	{ 0x03, KEY_1 },
+	{ 0x04, KEY_2 },
+	{ 0x05, KEY_3 },
+	{ 0x07, KEY_4 },
+	{ 0x08, KEY_5 },
+	{ 0x09, KEY_6 },
+	{ 0x0b, KEY_7 },
+	{ 0x0c, KEY_8 },
+	{ 0x0d, KEY_9 },
+
+	{ 0x0e, KEY_MODE },	/* Air/Cable */
+	{ 0x11, KEY_VIDEO },	/* Video */
+	{ 0x15, KEY_AUDIO },	/* Audio */
+	{ 0x00, KEY_POWER },	/* Power */
+	{ 0x18, KEY_TUNER },	/* AV Source */
+	{ 0x02, KEY_ZOOM },	/* Fullscreen */
+	{ 0x1a, KEY_LANGUAGE },	/* Stereo */
+	{ 0x1b, KEY_MUTE },	/* Mute */
+	{ 0x14, KEY_VOLUMEUP },	/* Volume + */
+	{ 0x17, KEY_VOLUMEDOWN },/* Volume - */
+	{ 0x12, KEY_CHANNELUP },/* Channel + */
+	{ 0x13, KEY_CHANNELDOWN },/* Channel - */
+	{ 0x06, KEY_AGAIN },	/* Recall */
+	{ 0x10, KEY_ENTER },	/* Enter */
+
+	{ 0x19, KEY_BACK },	/* Rewind  ( <<< ) */
+	{ 0x1f, KEY_FORWARD },	/* Forward ( >>> ) */
+	{ 0x0a, KEY_ANGLE },	/* no label, may be used as the PAUSE button */
+};
+DEFINE_LEGACY_IR_KEYTABLE(flyvideo);
+#else
+DECLARE_IR_KEYTABLE(flyvideo);
+#endif
diff --git a/include/media/keycodes/fusionhdtv-mce.h b/include/media/keycodes/fusionhdtv-mce.h
new file mode 100644
index 0000000..bf2998f
--- /dev/null
+++ b/include/media/keycodes/fusionhdtv-mce.h
@@ -0,0 +1,74 @@
+/* fusionhdtv-mce.h - Keytable for fusionhdtv_mce Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* DViCO FUSION HDTV MCE remote */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode fusionhdtv_mce[] = {
+
+	{ 0x0b, KEY_1 },
+	{ 0x17, KEY_2 },
+	{ 0x1b, KEY_3 },
+	{ 0x07, KEY_4 },
+	{ 0x50, KEY_5 },
+	{ 0x54, KEY_6 },
+	{ 0x48, KEY_7 },
+	{ 0x4c, KEY_8 },
+	{ 0x58, KEY_9 },
+	{ 0x03, KEY_0 },
+
+	{ 0x5e, KEY_OK },
+	{ 0x51, KEY_UP },
+	{ 0x53, KEY_DOWN },
+	{ 0x5b, KEY_LEFT },
+	{ 0x5f, KEY_RIGHT },
+
+	{ 0x02, KEY_TV },		/* Labeled DTV on remote */
+	{ 0x0e, KEY_MP3 },
+	{ 0x1a, KEY_DVD },
+	{ 0x1e, KEY_FAVORITES },	/* Labeled CPF on remote */
+	{ 0x16, KEY_SETUP },
+	{ 0x46, KEY_POWER2 },		/* TV On/Off button on remote */
+	{ 0x0a, KEY_EPG },		/* Labeled Guide on remote */
+
+	{ 0x49, KEY_BACK },
+	{ 0x59, KEY_INFO },		/* Labeled MORE on remote */
+	{ 0x4d, KEY_MENU },		/* Labeled DVDMENU on remote */
+	{ 0x55, KEY_CYCLEWINDOWS },	/* Labeled ALT-TAB on remote */
+
+	{ 0x0f, KEY_PREVIOUSSONG },	/* Labeled |<< REPLAY on remote */
+	{ 0x12, KEY_NEXTSONG },		/* Labeled >>| SKIP on remote */
+	{ 0x42, KEY_ENTER },		/* Labeled START with a green
+					   MS windows logo on remote */
+
+	{ 0x15, KEY_VOLUMEUP },
+	{ 0x05, KEY_VOLUMEDOWN },
+	{ 0x11, KEY_CHANNELUP },
+	{ 0x09, KEY_CHANNELDOWN },
+
+	{ 0x52, KEY_CAMERA },
+	{ 0x5a, KEY_TUNER },
+	{ 0x19, KEY_OPEN },
+
+	{ 0x13, KEY_MODE },		/* 4:3 16:9 select */
+	{ 0x1f, KEY_ZOOM },
+
+	{ 0x43, KEY_REWIND },
+	{ 0x47, KEY_PLAYPAUSE },
+	{ 0x4f, KEY_FASTFORWARD },
+	{ 0x57, KEY_MUTE },
+	{ 0x0d, KEY_STOP },
+	{ 0x01, KEY_RECORD },
+	{ 0x4e, KEY_POWER },
+};
+DEFINE_LEGACY_IR_KEYTABLE(fusionhdtv_mce);
+#else
+DECLARE_IR_KEYTABLE(fusionhdtv_mce);
+#endif
diff --git a/include/media/keycodes/gadmei-rm008z.h b/include/media/keycodes/gadmei-rm008z.h
new file mode 100644
index 0000000..b73d3e5
--- /dev/null
+++ b/include/media/keycodes/gadmei-rm008z.h
@@ -0,0 +1,57 @@
+/* gadmei-rm008z.h - Keytable for gadmei_rm008z Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* GADMEI UTV330+ RM008Z remote
+   Shine Liu <shinel@foxmail.com>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode gadmei_rm008z[] = {
+	{ 0x14, KEY_POWER2},		/* POWER OFF */
+	{ 0x0c, KEY_MUTE},		/* MUTE */
+
+	{ 0x18, KEY_TV},		/* TV */
+	{ 0x0e, KEY_VIDEO},		/* AV */
+	{ 0x0b, KEY_AUDIO},		/* SV */
+	{ 0x0f, KEY_RADIO},		/* FM */
+
+	{ 0x00, KEY_1},
+	{ 0x01, KEY_2},
+	{ 0x02, KEY_3},
+	{ 0x03, KEY_4},
+	{ 0x04, KEY_5},
+	{ 0x05, KEY_6},
+	{ 0x06, KEY_7},
+	{ 0x07, KEY_8},
+	{ 0x08, KEY_9},
+	{ 0x09, KEY_0},
+	{ 0x0a, KEY_INFO},		/* OSD */
+	{ 0x1c, KEY_BACKSPACE},		/* LAST */
+
+	{ 0x0d, KEY_PLAY},		/* PLAY */
+	{ 0x1e, KEY_CAMERA},		/* SNAPSHOT */
+	{ 0x1a, KEY_RECORD},		/* RECORD */
+	{ 0x17, KEY_STOP},		/* STOP */
+
+	{ 0x1f, KEY_UP},		/* UP */
+	{ 0x44, KEY_DOWN},		/* DOWN */
+	{ 0x46, KEY_TAB},		/* BACK */
+	{ 0x4a, KEY_ZOOM},		/* FULLSECREEN */
+
+	{ 0x10, KEY_VOLUMEUP},		/* VOLUMEUP */
+	{ 0x11, KEY_VOLUMEDOWN},	/* VOLUMEDOWN */
+	{ 0x12, KEY_CHANNELUP},		/* CHANNELUP */
+	{ 0x13, KEY_CHANNELDOWN},	/* CHANNELDOWN */
+	{ 0x15, KEY_ENTER},		/* OK */
+};
+DEFINE_LEGACY_IR_KEYTABLE(gadmei_rm008z);
+#else
+DECLARE_IR_KEYTABLE(gadmei_rm008z);
+#endif
diff --git a/include/media/keycodes/genius-tvgo-a11mce.h b/include/media/keycodes/genius-tvgo-a11mce.h
new file mode 100644
index 0000000..b0aad3b
--- /dev/null
+++ b/include/media/keycodes/genius-tvgo-a11mce.h
@@ -0,0 +1,60 @@
+/* genius-tvgo-a11mce.h - Keytable for genius_tvgo_a11mce Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * Remote control for the Genius TVGO A11MCE
+ * Adrian Pardini <pardo.bsso@gmail.com>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode genius_tvgo_a11mce[] = {
+	/* Keys 0 to 9 */
+	{ 0x48, KEY_0 },
+	{ 0x09, KEY_1 },
+	{ 0x1d, KEY_2 },
+	{ 0x1f, KEY_3 },
+	{ 0x19, KEY_4 },
+	{ 0x1b, KEY_5 },
+	{ 0x11, KEY_6 },
+	{ 0x17, KEY_7 },
+	{ 0x12, KEY_8 },
+	{ 0x16, KEY_9 },
+
+	{ 0x54, KEY_RECORD },		/* recording */
+	{ 0x06, KEY_MUTE },		/* mute */
+	{ 0x10, KEY_POWER },
+	{ 0x40, KEY_LAST },		/* recall */
+	{ 0x4c, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x00, KEY_CHANNELDOWN },	/* channel / program - */
+	{ 0x0d, KEY_VOLUMEUP },
+	{ 0x15, KEY_VOLUMEDOWN },
+	{ 0x4d, KEY_OK },		/* also labeled as Pause */
+	{ 0x1c, KEY_ZOOM },		/* full screen and Stop*/
+	{ 0x02, KEY_MODE },		/* AV Source or Rewind*/
+	{ 0x04, KEY_LIST },		/* -/-- */
+	/* small arrows above numbers */
+	{ 0x1a, KEY_NEXT },		/* also Fast Forward */
+	{ 0x0e, KEY_PREVIOUS },		/* also Rewind */
+	/* these are in a rather non standard layout and have
+	an alternate name written */
+	{ 0x1e, KEY_UP },		/* Video Setting */
+	{ 0x0a, KEY_DOWN },		/* Video Default */
+	{ 0x05, KEY_CAMERA },		/* Snapshot */
+	{ 0x0c, KEY_RIGHT },		/* Hide Panel */
+	/* Four buttons without label */
+	{ 0x49, KEY_RED },
+	{ 0x0b, KEY_GREEN },
+	{ 0x13, KEY_YELLOW },
+	{ 0x50, KEY_BLUE },
+};
+DEFINE_LEGACY_IR_KEYTABLE(genius_tvgo_a11mce);
+#else
+DECLARE_IR_KEYTABLE(genius_tvgo_a11mce);
+#endif
diff --git a/include/media/keycodes/gotview7135.h b/include/media/keycodes/gotview7135.h
new file mode 100644
index 0000000..1d108e8
--- /dev/null
+++ b/include/media/keycodes/gotview7135.h
@@ -0,0 +1,55 @@
+/* gotview7135.h - Keytable for gotview7135 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Mike Baikov <mike@baikov.com> */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode gotview7135[] = {
+
+	{ 0x11, KEY_POWER },
+	{ 0x35, KEY_TV },
+	{ 0x1b, KEY_0 },
+	{ 0x29, KEY_1 },
+	{ 0x19, KEY_2 },
+	{ 0x39, KEY_3 },
+	{ 0x1f, KEY_4 },
+	{ 0x2c, KEY_5 },
+	{ 0x21, KEY_6 },
+	{ 0x24, KEY_7 },
+	{ 0x18, KEY_8 },
+	{ 0x2b, KEY_9 },
+	{ 0x3b, KEY_AGAIN },	/* LOOP */
+	{ 0x06, KEY_AUDIO },
+	{ 0x31, KEY_PRINT },	/* PREVIEW */
+	{ 0x3e, KEY_VIDEO },
+	{ 0x10, KEY_CHANNELUP },
+	{ 0x20, KEY_CHANNELDOWN },
+	{ 0x0c, KEY_VOLUMEDOWN },
+	{ 0x28, KEY_VOLUMEUP },
+	{ 0x08, KEY_MUTE },
+	{ 0x26, KEY_SEARCH },	/* SCAN */
+	{ 0x3f, KEY_CAMERA },	/* SNAPSHOT */
+	{ 0x12, KEY_RECORD },
+	{ 0x32, KEY_STOP },
+	{ 0x3c, KEY_PLAY },
+	{ 0x1d, KEY_REWIND },
+	{ 0x2d, KEY_PAUSE },
+	{ 0x0d, KEY_FORWARD },
+	{ 0x05, KEY_ZOOM },	/*FULL*/
+
+	{ 0x2a, KEY_F21 },	/* LIVE TIMESHIFT */
+	{ 0x0e, KEY_F22 },	/* MIN TIMESHIFT */
+	{ 0x1e, KEY_TIME },	/* TIMESHIFT */
+	{ 0x38, KEY_F24 },	/* NORMAL TIMESHIFT */
+};
+DEFINE_LEGACY_IR_KEYTABLE(gotview7135);
+#else
+DECLARE_IR_KEYTABLE(gotview7135);
+#endif
diff --git a/include/media/keycodes/hauppauge-new.h b/include/media/keycodes/hauppauge-new.h
new file mode 100644
index 0000000..f06702d
--- /dev/null
+++ b/include/media/keycodes/hauppauge-new.h
@@ -0,0 +1,76 @@
+/* hauppauge-new.h - Keytable for hauppauge_new Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Hauppauge: the newer, gray remotes (seems there are multiple
+ * slightly different versions), shipped with cx88+ivtv cards.
+ * almost rc5 coding, but some non-standard keys */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode hauppauge_new[] = {
+	/* Keys 0 to 9 */
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	{ 0x0a, KEY_TEXT },		/* keypad asterisk as well */
+	{ 0x0b, KEY_RED },		/* red button */
+	{ 0x0c, KEY_RADIO },
+	{ 0x0d, KEY_MENU },
+	{ 0x0e, KEY_SUBTITLE },		/* also the # key */
+	{ 0x0f, KEY_MUTE },
+	{ 0x10, KEY_VOLUMEUP },
+	{ 0x11, KEY_VOLUMEDOWN },
+	{ 0x12, KEY_PREVIOUS },		/* previous channel */
+	{ 0x14, KEY_UP },
+	{ 0x15, KEY_DOWN },
+	{ 0x16, KEY_LEFT },
+	{ 0x17, KEY_RIGHT },
+	{ 0x18, KEY_VIDEO },		/* Videos */
+	{ 0x19, KEY_AUDIO },		/* Music */
+	/* 0x1a: Pictures - presume this means
+	   "Multimedia Home Platform" -
+	   no "PICTURES" key in input.h
+	 */
+	{ 0x1a, KEY_MHP },
+
+	{ 0x1b, KEY_EPG },		/* Guide */
+	{ 0x1c, KEY_TV },
+	{ 0x1e, KEY_NEXTSONG },		/* skip >| */
+	{ 0x1f, KEY_EXIT },		/* back/exit */
+	{ 0x20, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x21, KEY_CHANNELDOWN },	/* channel / program - */
+	{ 0x22, KEY_CHANNEL },		/* source (old black remote) */
+	{ 0x24, KEY_PREVIOUSSONG },	/* replay |< */
+	{ 0x25, KEY_ENTER },		/* OK */
+	{ 0x26, KEY_SLEEP },		/* minimize (old black remote) */
+	{ 0x29, KEY_BLUE },		/* blue key */
+	{ 0x2e, KEY_GREEN },		/* green button */
+	{ 0x30, KEY_PAUSE },		/* pause */
+	{ 0x32, KEY_REWIND },		/* backward << */
+	{ 0x34, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x35, KEY_PLAY },
+	{ 0x36, KEY_STOP },
+	{ 0x37, KEY_RECORD },		/* recording */
+	{ 0x38, KEY_YELLOW },		/* yellow key */
+	{ 0x3b, KEY_SELECT },		/* top right button */
+	{ 0x3c, KEY_ZOOM },		/* full */
+	{ 0x3d, KEY_POWER },		/* system power (green button) */
+};
+DEFINE_LEGACY_IR_KEYTABLE(hauppauge_new);
+#else
+DECLARE_IR_KEYTABLE(hauppauge_new);
+#endif
diff --git a/include/media/keycodes/iodata-bctv7e.h b/include/media/keycodes/iodata-bctv7e.h
new file mode 100644
index 0000000..6dea92a
--- /dev/null
+++ b/include/media/keycodes/iodata-bctv7e.h
@@ -0,0 +1,64 @@
+/* iodata-bctv7e.h - Keytable for iodata_bctv7e Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* IO-DATA BCTV7E Remote */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode iodata_bctv7e[] = {
+	{ 0x40, KEY_TV },
+	{ 0x20, KEY_RADIO },		/* FM */
+	{ 0x60, KEY_EPG },
+	{ 0x00, KEY_POWER },
+
+	/* Keys 0 to 9 */
+	{ 0x44, KEY_0 },		/* 10 */
+	{ 0x50, KEY_1 },
+	{ 0x30, KEY_2 },
+	{ 0x70, KEY_3 },
+	{ 0x48, KEY_4 },
+	{ 0x28, KEY_5 },
+	{ 0x68, KEY_6 },
+	{ 0x58, KEY_7 },
+	{ 0x38, KEY_8 },
+	{ 0x78, KEY_9 },
+
+	{ 0x10, KEY_L },		/* Live */
+	{ 0x08, KEY_TIME },		/* Time Shift */
+
+	{ 0x18, KEY_PLAYPAUSE },	/* Play */
+
+	{ 0x24, KEY_ENTER },		/* 11 */
+	{ 0x64, KEY_ESC },		/* 12 */
+	{ 0x04, KEY_M },		/* Multi */
+
+	{ 0x54, KEY_VIDEO },
+	{ 0x34, KEY_CHANNELUP },
+	{ 0x74, KEY_VOLUMEUP },
+	{ 0x14, KEY_MUTE },
+
+	{ 0x4c, KEY_VCR },		/* SVIDEO */
+	{ 0x2c, KEY_CHANNELDOWN },
+	{ 0x6c, KEY_VOLUMEDOWN },
+	{ 0x0c, KEY_ZOOM },
+
+	{ 0x5c, KEY_PAUSE },
+	{ 0x3c, KEY_RED },		/* || (red) */
+	{ 0x7c, KEY_RECORD },		/* recording */
+	{ 0x1c, KEY_STOP },
+
+	{ 0x41, KEY_REWIND },		/* backward << */
+	{ 0x21, KEY_PLAY },
+	{ 0x61, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x01, KEY_NEXT },		/* skip >| */
+};
+DEFINE_LEGACY_IR_KEYTABLE(iodata_bctv7e);
+#else
+DECLARE_IR_KEYTABLE(iodata_bctv7e);
+#endif
diff --git a/include/media/keycodes/kaiomy.h b/include/media/keycodes/kaiomy.h
new file mode 100644
index 0000000..2d6dbbc
--- /dev/null
+++ b/include/media/keycodes/kaiomy.h
@@ -0,0 +1,63 @@
+/* kaiomy.h - Keytable for kaiomy Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Kaiomy TVnPC U2
+   Mauro Carvalho Chehab <mchehab@infradead.org>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode kaiomy[] = {
+	{ 0x43, KEY_POWER2},
+	{ 0x01, KEY_LIST},
+	{ 0x0b, KEY_ZOOM},
+	{ 0x03, KEY_POWER},
+
+	{ 0x04, KEY_1},
+	{ 0x08, KEY_2},
+	{ 0x02, KEY_3},
+
+	{ 0x0f, KEY_4},
+	{ 0x05, KEY_5},
+	{ 0x06, KEY_6},
+
+	{ 0x0c, KEY_7},
+	{ 0x0d, KEY_8},
+	{ 0x0a, KEY_9},
+
+	{ 0x11, KEY_0},
+
+	{ 0x09, KEY_CHANNELUP},
+	{ 0x07, KEY_CHANNELDOWN},
+
+	{ 0x0e, KEY_VOLUMEUP},
+	{ 0x13, KEY_VOLUMEDOWN},
+
+	{ 0x10, KEY_HOME},
+	{ 0x12, KEY_ENTER},
+
+	{ 0x14, KEY_RECORD},
+	{ 0x15, KEY_STOP},
+	{ 0x16, KEY_PLAY},
+	{ 0x17, KEY_MUTE},
+
+	{ 0x18, KEY_UP},
+	{ 0x19, KEY_DOWN},
+	{ 0x1a, KEY_LEFT},
+	{ 0x1b, KEY_RIGHT},
+
+	{ 0x1c, KEY_RED},
+	{ 0x1d, KEY_GREEN},
+	{ 0x1e, KEY_YELLOW},
+	{ 0x1f, KEY_BLUE},
+};
+DEFINE_LEGACY_IR_KEYTABLE(kaiomy);
+#else
+DECLARE_IR_KEYTABLE(kaiomy);
+#endif
diff --git a/include/media/keycodes/kworld-315u.h b/include/media/keycodes/kworld-315u.h
new file mode 100644
index 0000000..44e29b6
--- /dev/null
+++ b/include/media/keycodes/kworld-315u.h
@@ -0,0 +1,59 @@
+/* kworld-315u.h - Keytable for kworld_315u Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Kworld 315U
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode kworld_315u[] = {
+	{ 0x6143, KEY_POWER },
+	{ 0x6101, KEY_TUNER },		/* source */
+	{ 0x610b, KEY_ZOOM },
+	{ 0x6103, KEY_POWER2 },		/* shutdown */
+
+	{ 0x6104, KEY_1 },
+	{ 0x6108, KEY_2 },
+	{ 0x6102, KEY_3 },
+	{ 0x6109, KEY_CHANNELUP },
+
+	{ 0x610f, KEY_4 },
+	{ 0x6105, KEY_5 },
+	{ 0x6106, KEY_6 },
+	{ 0x6107, KEY_CHANNELDOWN },
+
+	{ 0x610c, KEY_7 },
+	{ 0x610d, KEY_8 },
+	{ 0x610a, KEY_9 },
+	{ 0x610e, KEY_VOLUMEUP },
+
+	{ 0x6110, KEY_LAST },
+	{ 0x6111, KEY_0 },
+	{ 0x6112, KEY_ENTER },
+	{ 0x6113, KEY_VOLUMEDOWN },
+
+	{ 0x6114, KEY_RECORD },
+	{ 0x6115, KEY_STOP },
+	{ 0x6116, KEY_PLAY },
+	{ 0x6117, KEY_MUTE },
+
+	{ 0x6118, KEY_UP },
+	{ 0x6119, KEY_DOWN },
+	{ 0x611a, KEY_LEFT },
+	{ 0x611b, KEY_RIGHT },
+
+	{ 0x611c, KEY_RED },
+	{ 0x611d, KEY_GREEN },
+	{ 0x611e, KEY_YELLOW },
+	{ 0x611f, KEY_BLUE },
+};
+DEFINE_IR_KEYTABLE(kworld_315u, IR_TYPE_NEC);
+#else
+DECLARE_IR_KEYTABLE(kworld_315u);
+#endif
diff --git a/include/media/keycodes/kworld-plus-tv-analog.h b/include/media/keycodes/kworld-plus-tv-analog.h
new file mode 100644
index 0000000..2b4ae0b
--- /dev/null
+++ b/include/media/keycodes/kworld-plus-tv-analog.h
@@ -0,0 +1,75 @@
+/* kworld-plus-tv-analog.h - Keytable for kworld_plus_tv_analog Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Kworld Plus TV Analog Lite PCI IR
+   Mauro Carvalho Chehab <mchehab@infradead.org>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode kworld_plus_tv_analog[] = {
+	{ 0x0c, KEY_PROG1 },		/* Kworld key */
+	{ 0x16, KEY_CLOSECD },		/* -> ) */
+	{ 0x1d, KEY_POWER2 },
+
+	{ 0x00, KEY_1 },
+	{ 0x01, KEY_2 },
+	{ 0x02, KEY_3 },		/* Two keys have the same code: 3 and left */
+	{ 0x03, KEY_4 },		/* Two keys have the same code: 3 and right */
+	{ 0x04, KEY_5 },
+	{ 0x05, KEY_6 },
+	{ 0x06, KEY_7 },
+	{ 0x07, KEY_8 },
+	{ 0x08, KEY_9 },
+	{ 0x0a, KEY_0 },
+
+	{ 0x09, KEY_AGAIN },
+	{ 0x14, KEY_MUTE },
+
+	{ 0x20, KEY_UP },
+	{ 0x21, KEY_DOWN },
+	{ 0x0b, KEY_ENTER },
+
+	{ 0x10, KEY_CHANNELUP },
+	{ 0x11, KEY_CHANNELDOWN },
+
+	/* Couldn't map key left/key right since those
+	   conflict with '3' and '4' scancodes
+	   I dunno what the original driver does
+	 */
+
+	{ 0x13, KEY_VOLUMEUP },
+	{ 0x12, KEY_VOLUMEDOWN },
+
+	/* The lower part of the IR
+	   There are several duplicated keycodes there.
+	   Most of them conflict with digits.
+	   Add mappings just to the unused scancodes.
+	   Somehow, the original driver has a way to know,
+	   but this doesn't seem to be on some GPIO.
+	   Also, it is not related to the time between keyup
+	   and keydown.
+	 */
+	{ 0x19, KEY_TIME},		/* Timeshift */
+	{ 0x1a, KEY_STOP},
+	{ 0x1b, KEY_RECORD},
+
+	{ 0x22, KEY_TEXT},
+
+	{ 0x15, KEY_AUDIO},		/* ((*)) */
+	{ 0x0f, KEY_ZOOM},
+	{ 0x1c, KEY_CAMERA},		/* snapshot */
+
+	{ 0x18, KEY_RED},		/* B */
+	{ 0x23, KEY_GREEN},		/* C */
+};
+DEFINE_LEGACY_IR_KEYTABLE(kworld_plus_tv_analog);
+#else
+DECLARE_IR_KEYTABLE(kworld_plus_tv_analog);
+#endif
diff --git a/include/media/keycodes/manli.h b/include/media/keycodes/manli.h
new file mode 100644
index 0000000..9f8e752
--- /dev/null
+++ b/include/media/keycodes/manli.h
@@ -0,0 +1,111 @@
+/* manli.h - Keytable for manli Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Michael Tokarev <mjt@tls.msk.ru>
+   http://www.corpit.ru/mjt/beholdTV/remote_control.jpg
+   keytable is used by MANLI MTV00[0x0c] and BeholdTV 40[13] at
+   least, and probably other cards too.
+   The "ascii-art picture" below (in comments, first row
+   is the keycode in hex, and subsequent row(s) shows
+   the button labels (several variants when appropriate)
+   helps to descide which keycodes to assign to the buttons.
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode manli[] = {
+
+	/*  0x1c            0x12  *
+	 * FUNCTION         POWER *
+	 *   FM              (|)  *
+	 *                        */
+	{ 0x1c, KEY_RADIO },	/*XXX*/
+	{ 0x12, KEY_POWER },
+
+	/*  0x01    0x02    0x03  *
+	 *   1       2       3    *
+	 *                        *
+	 *  0x04    0x05    0x06  *
+	 *   4       5       6    *
+	 *                        *
+	 *  0x07    0x08    0x09  *
+	 *   7       8       9    *
+	 *                        */
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	/*  0x0a    0x00    0x17  *
+	 * RECALL    0      +100  *
+	 *                  PLUS  *
+	 *                        */
+	{ 0x0a, KEY_AGAIN },	/*XXX KEY_REWIND? */
+	{ 0x00, KEY_0 },
+	{ 0x17, KEY_DIGITS },	/*XXX*/
+
+	/*  0x14            0x10  *
+	 *  MENU            INFO  *
+	 *  OSD                   */
+	{ 0x14, KEY_MENU },
+	{ 0x10, KEY_INFO },
+
+	/*          0x0b          *
+	 *           Up           *
+	 *                        *
+	 *  0x18    0x16    0x0c  *
+	 *  Left     Ok     Right *
+	 *                        *
+	 *         0x015          *
+	 *         Down           *
+	 *                        */
+	{ 0x0b, KEY_UP },
+	{ 0x18, KEY_LEFT },
+	{ 0x16, KEY_OK },	/*XXX KEY_SELECT? KEY_ENTER? */
+	{ 0x0c, KEY_RIGHT },
+	{ 0x15, KEY_DOWN },
+
+	/*  0x11            0x0d  *
+	 *  TV/AV           MODE  *
+	 *  SOURCE         STEREO *
+	 *                        */
+	{ 0x11, KEY_TV },	/*XXX*/
+	{ 0x0d, KEY_MODE },	/*XXX there's no KEY_STEREO	*/
+
+	/*  0x0f    0x1b    0x1a  *
+	 *  AUDIO   Vol+    Chan+ *
+	 *        TIMESHIFT???    *
+	 *                        *
+	 *  0x0e    0x1f    0x1e  *
+	 *  SLEEP   Vol-    Chan- *
+	 *                        */
+	{ 0x0f, KEY_AUDIO },
+	{ 0x1b, KEY_VOLUMEUP },
+	{ 0x1a, KEY_CHANNELUP },
+	{ 0x0e, KEY_TIME },
+	{ 0x1f, KEY_VOLUMEDOWN },
+	{ 0x1e, KEY_CHANNELDOWN },
+
+	/*         0x13     0x19  *
+	 *         MUTE   SNAPSHOT*
+	 *                        */
+	{ 0x13, KEY_MUTE },
+	{ 0x19, KEY_CAMERA },
+
+	/* 0x1d unused ? */
+};
+DEFINE_LEGACY_IR_KEYTABLE(manli);
+#else
+DECLARE_IR_KEYTABLE(manli);
+#endif
diff --git a/include/media/keycodes/msi-tvanywhere-plus.h b/include/media/keycodes/msi-tvanywhere-plus.h
new file mode 100644
index 0000000..c5e51ad
--- /dev/null
+++ b/include/media/keycodes/msi-tvanywhere-plus.h
@@ -0,0 +1,100 @@
+/* msi-tvanywhere-plus.h - Keytable for msi_tvanywhere_plus Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+  Keycodes for remote on the MSI TV@nywhere Plus. The controller IC on the card
+  is marked "KS003". The controller is I2C at address 0x30, but does not seem
+  to respond to probes until a read is performed from a valid device.
+  I don't know why...
+
+  Note: This remote may be of similar or identical design to the
+  Pixelview remote (?).  The raw codes and duplicate button codes
+  appear to be the same.
+
+  Henry Wong <henry@stuffedcow.net>
+  Some changes to formatting and keycodes by Mark Schultz <n9xmj@yahoo.com>
+
+*/
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode msi_tvanywhere_plus[] = {
+
+/*  ---- Remote Button Layout ----
+
+    POWER   SOURCE  SCAN    MUTE
+    TV/FM   1       2       3
+    |>      4       5       6
+    <|      7       8       9
+    ^^UP    0       +       RECALL
+    vvDN    RECORD  STOP    PLAY
+
+	MINIMIZE          ZOOM
+
+		  CH+
+      VOL-                   VOL+
+		  CH-
+
+	SNAPSHOT           MTS
+
+     <<      FUNC    >>     RESET
+*/
+
+	{ 0x01, KEY_1 },		/* 1 */
+	{ 0x0b, KEY_2 },		/* 2 */
+	{ 0x1b, KEY_3 },		/* 3 */
+	{ 0x05, KEY_4 },		/* 4 */
+	{ 0x09, KEY_5 },		/* 5 */
+	{ 0x15, KEY_6 },		/* 6 */
+	{ 0x06, KEY_7 },		/* 7 */
+	{ 0x0a, KEY_8 },		/* 8 */
+	{ 0x12, KEY_9 },		/* 9 */
+	{ 0x02, KEY_0 },		/* 0 */
+	{ 0x10, KEY_KPPLUS },		/* + */
+	{ 0x13, KEY_AGAIN },		/* Recall */
+
+	{ 0x1e, KEY_POWER },		/* Power */
+	{ 0x07, KEY_TUNER },		/* Source */
+	{ 0x1c, KEY_SEARCH },		/* Scan */
+	{ 0x18, KEY_MUTE },		/* Mute */
+
+	{ 0x03, KEY_RADIO },		/* TV/FM */
+	/* The next four keys are duplicates that appear to send the
+	   same IR code as Ch+, Ch-, >>, and << .  The raw code assigned
+	   to them is the actual code + 0x20 - they will never be
+	   detected as such unless some way is discovered to distinguish
+	   these buttons from those that have the same code. */
+	{ 0x3f, KEY_RIGHT },		/* |> and Ch+ */
+	{ 0x37, KEY_LEFT },		/* <| and Ch- */
+	{ 0x2c, KEY_UP },		/* ^^Up and >> */
+	{ 0x24, KEY_DOWN },		/* vvDn and << */
+
+	{ 0x00, KEY_RECORD },		/* Record */
+	{ 0x08, KEY_STOP },		/* Stop */
+	{ 0x11, KEY_PLAY },		/* Play */
+
+	{ 0x0f, KEY_CLOSE },		/* Minimize */
+	{ 0x19, KEY_ZOOM },		/* Zoom */
+	{ 0x1a, KEY_CAMERA },		/* Snapshot */
+	{ 0x0d, KEY_LANGUAGE },		/* MTS */
+
+	{ 0x14, KEY_VOLUMEDOWN },	/* Vol- */
+	{ 0x16, KEY_VOLUMEUP },		/* Vol+ */
+	{ 0x17, KEY_CHANNELDOWN },	/* Ch- */
+	{ 0x1f, KEY_CHANNELUP },	/* Ch+ */
+
+	{ 0x04, KEY_REWIND },		/* << */
+	{ 0x0e, KEY_MENU },		/* Function */
+	{ 0x0c, KEY_FASTFORWARD },	/* >> */
+	{ 0x1d, KEY_RESTART },		/* Reset */
+};
+DEFINE_LEGACY_IR_KEYTABLE(msi_tvanywhere_plus);
+#else
+DECLARE_IR_KEYTABLE(msi_tvanywhere_plus);
+#endif
diff --git a/include/media/keycodes/msi-tvanywhere.h b/include/media/keycodes/msi-tvanywhere.h
new file mode 100644
index 0000000..2f4cfe1
--- /dev/null
+++ b/include/media/keycodes/msi-tvanywhere.h
@@ -0,0 +1,44 @@
+/* msi-tvanywhere.h - Keytable for msi_tvanywhere Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode msi_tvanywhere[] = {
+	/* Keys 0 to 9 */
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	{ 0x0c, KEY_MUTE },
+	{ 0x0f, KEY_SCREEN },		/* Full Screen */
+	{ 0x10, KEY_FN },		/* Funtion */
+	{ 0x11, KEY_TIME },		/* Time shift */
+	{ 0x12, KEY_POWER },
+	{ 0x13, KEY_MEDIA },		/* MTS */
+	{ 0x14, KEY_SLOW },
+	{ 0x16, KEY_REWIND },		/* backward << */
+	{ 0x17, KEY_ENTER },		/* Return */
+	{ 0x18, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x1a, KEY_CHANNELUP },
+	{ 0x1b, KEY_VOLUMEUP },
+	{ 0x1e, KEY_CHANNELDOWN },
+	{ 0x1f, KEY_VOLUMEDOWN },
+};
+DEFINE_LEGACY_IR_KEYTABLE(msi_tvanywhere);
+#else
+DECLARE_IR_KEYTABLE(msi_tvanywhere);
+#endif
diff --git a/include/media/keycodes/nebula.h b/include/media/keycodes/nebula.h
new file mode 100644
index 0000000..4e2eb1f
--- /dev/null
+++ b/include/media/keycodes/nebula.h
@@ -0,0 +1,73 @@
+/* nebula.h - Keytable for nebula Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode nebula[] = {
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+	{ 0x0a, KEY_TV },
+	{ 0x0b, KEY_AUX },
+	{ 0x0c, KEY_DVD },
+	{ 0x0d, KEY_POWER },
+	{ 0x0e, KEY_MHP },	/* labelled 'Picture' */
+	{ 0x0f, KEY_AUDIO },
+	{ 0x10, KEY_INFO },
+	{ 0x11, KEY_F13 },	/* 16:9 */
+	{ 0x12, KEY_F14 },	/* 14:9 */
+	{ 0x13, KEY_EPG },
+	{ 0x14, KEY_EXIT },
+	{ 0x15, KEY_MENU },
+	{ 0x16, KEY_UP },
+	{ 0x17, KEY_DOWN },
+	{ 0x18, KEY_LEFT },
+	{ 0x19, KEY_RIGHT },
+	{ 0x1a, KEY_ENTER },
+	{ 0x1b, KEY_CHANNELUP },
+	{ 0x1c, KEY_CHANNELDOWN },
+	{ 0x1d, KEY_VOLUMEUP },
+	{ 0x1e, KEY_VOLUMEDOWN },
+	{ 0x1f, KEY_RED },
+	{ 0x20, KEY_GREEN },
+	{ 0x21, KEY_YELLOW },
+	{ 0x22, KEY_BLUE },
+	{ 0x23, KEY_SUBTITLE },
+	{ 0x24, KEY_F15 },	/* AD */
+	{ 0x25, KEY_TEXT },
+	{ 0x26, KEY_MUTE },
+	{ 0x27, KEY_REWIND },
+	{ 0x28, KEY_STOP },
+	{ 0x29, KEY_PLAY },
+	{ 0x2a, KEY_FASTFORWARD },
+	{ 0x2b, KEY_F16 },	/* chapter */
+	{ 0x2c, KEY_PAUSE },
+	{ 0x2d, KEY_PLAY },
+	{ 0x2e, KEY_RECORD },
+	{ 0x2f, KEY_F17 },	/* picture in picture */
+	{ 0x30, KEY_KPPLUS },	/* zoom in */
+	{ 0x31, KEY_KPMINUS },	/* zoom out */
+	{ 0x32, KEY_F18 },	/* capture */
+	{ 0x33, KEY_F19 },	/* web */
+	{ 0x34, KEY_EMAIL },
+	{ 0x35, KEY_PHONE },
+	{ 0x36, KEY_PC },
+};
+DEFINE_LEGACY_IR_KEYTABLE(nebula);
+#else
+DECLARE_IR_KEYTABLE(nebula);
+#endif
diff --git a/include/media/keycodes/nec-terratec-cinergy-xs.h b/include/media/keycodes/nec-terratec-cinergy-xs.h
new file mode 100644
index 0000000..39ede1e
--- /dev/null
+++ b/include/media/keycodes/nec-terratec-cinergy-xs.h
@@ -0,0 +1,81 @@
+/* nec-terratec-cinergy-xs.h - Keytable for nec_terratec_cinergy_xs Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Terratec Cinergy Hybrid T USB XS FM
+   Mauro Carvalho Chehab <mchehab@redhat.com>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode nec_terratec_cinergy_xs[] = {
+	{ 0x1441, KEY_HOME},
+	{ 0x1401, KEY_POWER2},
+
+	{ 0x1442, KEY_MENU},		/* DVD menu */
+	{ 0x1443, KEY_SUBTITLE},
+	{ 0x1444, KEY_TEXT},		/* Teletext */
+	{ 0x1445, KEY_DELETE},
+
+	{ 0x1402, KEY_1},
+	{ 0x1403, KEY_2},
+	{ 0x1404, KEY_3},
+	{ 0x1405, KEY_4},
+	{ 0x1406, KEY_5},
+	{ 0x1407, KEY_6},
+	{ 0x1408, KEY_7},
+	{ 0x1409, KEY_8},
+	{ 0x140a, KEY_9},
+	{ 0x140c, KEY_0},
+
+	{ 0x140b, KEY_TUNER},		/* AV */
+	{ 0x140d, KEY_MODE},		/* A.B */
+
+	{ 0x1446, KEY_TV},
+	{ 0x1447, KEY_DVD},
+	{ 0x1449, KEY_VIDEO},
+	{ 0x144a, KEY_RADIO},		/* Music */
+	{ 0x144b, KEY_CAMERA},		/* PIC */
+
+	{ 0x1410, KEY_UP},
+	{ 0x1411, KEY_LEFT},
+	{ 0x1412, KEY_OK},
+	{ 0x1413, KEY_RIGHT},
+	{ 0x1414, KEY_DOWN},
+
+	{ 0x140f, KEY_EPG},
+	{ 0x1416, KEY_INFO},
+	{ 0x144d, KEY_BACKSPACE},
+
+	{ 0x141c, KEY_VOLUMEUP},
+	{ 0x141e, KEY_VOLUMEDOWN},
+
+	{ 0x144c, KEY_PLAY},
+	{ 0x141d, KEY_MUTE},
+
+	{ 0x141b, KEY_CHANNELUP},
+	{ 0x141f, KEY_CHANNELDOWN},
+
+	{ 0x1417, KEY_RED},
+	{ 0x1418, KEY_GREEN},
+	{ 0x1419, KEY_YELLOW},
+	{ 0x141a, KEY_BLUE},
+
+	{ 0x1458, KEY_RECORD},
+	{ 0x1448, KEY_STOP},
+	{ 0x1440, KEY_PAUSE},
+
+	{ 0x1454, KEY_LAST},
+	{ 0x144e, KEY_REWIND},
+	{ 0x144f, KEY_FASTFORWARD},
+	{ 0x145c, KEY_NEXT},
+};
+DEFINE_IR_KEYTABLE(nec_terratec_cinergy_xs, IR_TYPE_NEC);
+#else
+DECLARE_IR_KEYTABLE(nec_terratec_cinergy_xs);
+#endif
diff --git a/include/media/keycodes/norwood.h b/include/media/keycodes/norwood.h
new file mode 100644
index 0000000..7f6cc4c
--- /dev/null
+++ b/include/media/keycodes/norwood.h
@@ -0,0 +1,61 @@
+/* norwood.h - Keytable for norwood Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Norwood Micro (non-Pro) TV Tuner
+   By Peter Naulls <peter@chocky.org>
+   Key comments are the functions given in the manual */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode norwood[] = {
+	/* Keys 0 to 9 */
+	{ 0x20, KEY_0 },
+	{ 0x21, KEY_1 },
+	{ 0x22, KEY_2 },
+	{ 0x23, KEY_3 },
+	{ 0x24, KEY_4 },
+	{ 0x25, KEY_5 },
+	{ 0x26, KEY_6 },
+	{ 0x27, KEY_7 },
+	{ 0x28, KEY_8 },
+	{ 0x29, KEY_9 },
+
+	{ 0x78, KEY_TUNER },		/* Video Source        */
+	{ 0x2c, KEY_EXIT },		/* Open/Close software */
+	{ 0x2a, KEY_SELECT },		/* 2 Digit Select      */
+	{ 0x69, KEY_AGAIN },		/* Recall              */
+
+	{ 0x32, KEY_BRIGHTNESSUP },	/* Brightness increase */
+	{ 0x33, KEY_BRIGHTNESSDOWN },	/* Brightness decrease */
+	{ 0x6b, KEY_KPPLUS },		/* (not named >>>>>)   */
+	{ 0x6c, KEY_KPMINUS },		/* (not named <<<<<)   */
+
+	{ 0x2d, KEY_MUTE },		/* Mute                */
+	{ 0x30, KEY_VOLUMEUP },		/* Volume up           */
+	{ 0x31, KEY_VOLUMEDOWN },	/* Volume down         */
+	{ 0x60, KEY_CHANNELUP },	/* Channel up          */
+	{ 0x61, KEY_CHANNELDOWN },	/* Channel down        */
+
+	{ 0x3f, KEY_RECORD },		/* Record              */
+	{ 0x37, KEY_PLAY },		/* Play                */
+	{ 0x36, KEY_PAUSE },		/* Pause               */
+	{ 0x2b, KEY_STOP },		/* Stop                */
+	{ 0x67, KEY_FASTFORWARD },	/* Foward              */
+	{ 0x66, KEY_REWIND },		/* Rewind              */
+	{ 0x3e, KEY_SEARCH },		/* Auto Scan           */
+	{ 0x2e, KEY_CAMERA },		/* Capture Video       */
+	{ 0x6d, KEY_MENU },		/* Show/Hide Control   */
+	{ 0x2f, KEY_ZOOM },		/* Full Screen         */
+	{ 0x34, KEY_RADIO },		/* FM                  */
+	{ 0x65, KEY_POWER },		/* Computer power      */
+};
+DEFINE_LEGACY_IR_KEYTABLE(norwood);
+#else
+DECLARE_IR_KEYTABLE(norwood);
+#endif
diff --git a/include/media/keycodes/npgtech.h b/include/media/keycodes/npgtech.h
new file mode 100644
index 0000000..dd1ba82
--- /dev/null
+++ b/include/media/keycodes/npgtech.h
@@ -0,0 +1,57 @@
+/* npgtech.h - Keytable for npgtech Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode npgtech[] = {
+	{ 0x1d, KEY_SWITCHVIDEOMODE },	/* switch inputs */
+	{ 0x2a, KEY_FRONT },
+
+	{ 0x3e, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x06, KEY_3 },
+	{ 0x0a, KEY_4 },
+	{ 0x0e, KEY_5 },
+	{ 0x12, KEY_6 },
+	{ 0x16, KEY_7 },
+	{ 0x1a, KEY_8 },
+	{ 0x1e, KEY_9 },
+	{ 0x3a, KEY_0 },
+	{ 0x22, KEY_NUMLOCK },		/* -/-- */
+	{ 0x20, KEY_REFRESH },
+
+	{ 0x03, KEY_BRIGHTNESSDOWN },
+	{ 0x28, KEY_AUDIO },
+	{ 0x3c, KEY_CHANNELUP },
+	{ 0x3f, KEY_VOLUMEDOWN },
+	{ 0x2e, KEY_MUTE },
+	{ 0x3b, KEY_VOLUMEUP },
+	{ 0x00, KEY_CHANNELDOWN },
+	{ 0x07, KEY_BRIGHTNESSUP },
+	{ 0x2c, KEY_TEXT },
+
+	{ 0x37, KEY_RECORD },
+	{ 0x17, KEY_PLAY },
+	{ 0x13, KEY_PAUSE },
+	{ 0x26, KEY_STOP },
+	{ 0x18, KEY_FASTFORWARD },
+	{ 0x14, KEY_REWIND },
+	{ 0x33, KEY_ZOOM },
+	{ 0x32, KEY_KEYBOARD },
+	{ 0x30, KEY_GOTO },		/* Pointing arrow */
+	{ 0x36, KEY_MACRO },		/* Maximize/Minimize (yellow) */
+	{ 0x0b, KEY_RADIO },
+	{ 0x10, KEY_POWER },
+
+};
+DEFINE_LEGACY_IR_KEYTABLE(npgtech);
+#else
+DECLARE_IR_KEYTABLE(npgtech);
+#endif
diff --git a/include/media/keycodes/pctv-sedna.h b/include/media/keycodes/pctv-sedna.h
new file mode 100644
index 0000000..b1d511f
--- /dev/null
+++ b/include/media/keycodes/pctv-sedna.h
@@ -0,0 +1,56 @@
+/* pctv-sedna.h - Keytable for pctv_sedna Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Mapping for the 28 key remote control as seen at
+   http://www.sednacomputer.com/photo/cardbus-tv.jpg
+   Pavel Mihaylov <bin@bash.info>
+   Also for the remote bundled with Kozumi KTV-01C card */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode pctv_sedna[] = {
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	{ 0x0a, KEY_AGAIN },	/* Recall */
+	{ 0x0b, KEY_CHANNELUP },
+	{ 0x0c, KEY_VOLUMEUP },
+	{ 0x0d, KEY_MODE },	/* Stereo */
+	{ 0x0e, KEY_STOP },
+	{ 0x0f, KEY_PREVIOUSSONG },
+	{ 0x10, KEY_ZOOM },
+	{ 0x11, KEY_TUNER },	/* Source */
+	{ 0x12, KEY_POWER },
+	{ 0x13, KEY_MUTE },
+	{ 0x15, KEY_CHANNELDOWN },
+	{ 0x18, KEY_VOLUMEDOWN },
+	{ 0x19, KEY_CAMERA },	/* Snapshot */
+	{ 0x1a, KEY_NEXTSONG },
+	{ 0x1b, KEY_TIME },	/* Time Shift */
+	{ 0x1c, KEY_RADIO },	/* FM Radio */
+	{ 0x1d, KEY_RECORD },
+	{ 0x1e, KEY_PAUSE },
+	/* additional codes for Kozumi's remote */
+	{ 0x14, KEY_INFO },	/* OSD */
+	{ 0x16, KEY_OK },	/* OK */
+	{ 0x17, KEY_DIGITS },	/* Plus */
+	{ 0x1f, KEY_PLAY },	/* Play */
+};
+DEFINE_LEGACY_IR_KEYTABLE(pctv_sedna);
+#else
+DECLARE_IR_KEYTABLE(pctv_sedna);
+#endif
diff --git a/include/media/keycodes/pinnacle-color.h b/include/media/keycodes/pinnacle-color.h
new file mode 100644
index 0000000..a08eaeb
--- /dev/null
+++ b/include/media/keycodes/pinnacle-color.h
@@ -0,0 +1,71 @@
+/* pinnacle-color.h - Keytable for pinnacle_color Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode pinnacle_color[] = {
+	{ 0x59, KEY_MUTE },
+	{ 0x4a, KEY_POWER },
+
+	{ 0x18, KEY_TEXT },
+	{ 0x26, KEY_TV },
+	{ 0x3d, KEY_PRINT },
+
+	{ 0x48, KEY_RED },
+	{ 0x04, KEY_GREEN },
+	{ 0x11, KEY_YELLOW },
+	{ 0x00, KEY_BLUE },
+
+	{ 0x2d, KEY_VOLUMEUP },
+	{ 0x1e, KEY_VOLUMEDOWN },
+
+	{ 0x49, KEY_MENU },
+
+	{ 0x16, KEY_CHANNELUP },
+	{ 0x17, KEY_CHANNELDOWN },
+
+	{ 0x20, KEY_UP },
+	{ 0x21, KEY_DOWN },
+	{ 0x22, KEY_LEFT },
+	{ 0x23, KEY_RIGHT },
+	{ 0x0d, KEY_SELECT },
+
+	{ 0x08, KEY_BACK },
+	{ 0x07, KEY_REFRESH },
+
+	{ 0x2f, KEY_ZOOM },
+	{ 0x29, KEY_RECORD },
+
+	{ 0x4b, KEY_PAUSE },
+	{ 0x4d, KEY_REWIND },
+	{ 0x2e, KEY_PLAY },
+	{ 0x4e, KEY_FORWARD },
+	{ 0x53, KEY_PREVIOUS },
+	{ 0x4c, KEY_STOP },
+	{ 0x54, KEY_NEXT },
+
+	{ 0x69, KEY_0 },
+	{ 0x6a, KEY_1 },
+	{ 0x6b, KEY_2 },
+	{ 0x6c, KEY_3 },
+	{ 0x6d, KEY_4 },
+	{ 0x6e, KEY_5 },
+	{ 0x6f, KEY_6 },
+	{ 0x70, KEY_7 },
+	{ 0x71, KEY_8 },
+	{ 0x72, KEY_9 },
+
+	{ 0x74, KEY_CHANNEL },
+	{ 0x0a, KEY_BACKSPACE },
+};
+DEFINE_LEGACY_IR_KEYTABLE(pinnacle_color);
+#else
+DECLARE_IR_KEYTABLE(pinnacle_color);
+#endif
diff --git a/include/media/keycodes/pinnacle-grey.h b/include/media/keycodes/pinnacle-grey.h
new file mode 100644
index 0000000..3fd2504
--- /dev/null
+++ b/include/media/keycodes/pinnacle-grey.h
@@ -0,0 +1,66 @@
+/* pinnacle-grey.h - Keytable for pinnacle_grey Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode pinnacle_grey[] = {
+	{ 0x3a, KEY_0 },
+	{ 0x31, KEY_1 },
+	{ 0x32, KEY_2 },
+	{ 0x33, KEY_3 },
+	{ 0x34, KEY_4 },
+	{ 0x35, KEY_5 },
+	{ 0x36, KEY_6 },
+	{ 0x37, KEY_7 },
+	{ 0x38, KEY_8 },
+	{ 0x39, KEY_9 },
+
+	{ 0x2f, KEY_POWER },
+
+	{ 0x2e, KEY_P },
+	{ 0x1f, KEY_L },
+	{ 0x2b, KEY_I },
+
+	{ 0x2d, KEY_SCREEN },
+	{ 0x1e, KEY_ZOOM },
+	{ 0x1b, KEY_VOLUMEUP },
+	{ 0x0f, KEY_VOLUMEDOWN },
+	{ 0x17, KEY_CHANNELUP },
+	{ 0x1c, KEY_CHANNELDOWN },
+	{ 0x25, KEY_INFO },
+
+	{ 0x3c, KEY_MUTE },
+
+	{ 0x3d, KEY_LEFT },
+	{ 0x3b, KEY_RIGHT },
+
+	{ 0x3f, KEY_UP },
+	{ 0x3e, KEY_DOWN },
+	{ 0x1a, KEY_ENTER },
+
+	{ 0x1d, KEY_MENU },
+	{ 0x19, KEY_AGAIN },
+	{ 0x16, KEY_PREVIOUSSONG },
+	{ 0x13, KEY_NEXTSONG },
+	{ 0x15, KEY_PAUSE },
+	{ 0x0e, KEY_REWIND },
+	{ 0x0d, KEY_PLAY },
+	{ 0x0b, KEY_STOP },
+	{ 0x07, KEY_FORWARD },
+	{ 0x27, KEY_RECORD },
+	{ 0x26, KEY_TUNER },
+	{ 0x29, KEY_TEXT },
+	{ 0x2a, KEY_MEDIA },
+	{ 0x18, KEY_EPG },
+};
+DEFINE_LEGACY_IR_KEYTABLE(pinnacle_grey);
+#else
+DECLARE_IR_KEYTABLE(pinnacle_grey);
+#endif
diff --git a/include/media/keycodes/pinnacle-pctv-hd.h b/include/media/keycodes/pinnacle-pctv-hd.h
new file mode 100644
index 0000000..be72d50
--- /dev/null
+++ b/include/media/keycodes/pinnacle-pctv-hd.h
@@ -0,0 +1,49 @@
+/* pinnacle-pctv-hd.h - Keytable for pinnacle_pctv_hd Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Pinnacle PCTV HD 800i mini remote */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode pinnacle_pctv_hd[] = {
+
+	{ 0x0f, KEY_1 },
+	{ 0x15, KEY_2 },
+	{ 0x10, KEY_3 },
+	{ 0x18, KEY_4 },
+	{ 0x1b, KEY_5 },
+	{ 0x1e, KEY_6 },
+	{ 0x11, KEY_7 },
+	{ 0x21, KEY_8 },
+	{ 0x12, KEY_9 },
+	{ 0x27, KEY_0 },
+
+	{ 0x24, KEY_ZOOM },
+	{ 0x2a, KEY_SUBTITLE },
+
+	{ 0x00, KEY_MUTE },
+	{ 0x01, KEY_ENTER },	/* Pinnacle Logo */
+	{ 0x39, KEY_POWER },
+
+	{ 0x03, KEY_VOLUMEUP },
+	{ 0x09, KEY_VOLUMEDOWN },
+	{ 0x06, KEY_CHANNELUP },
+	{ 0x0c, KEY_CHANNELDOWN },
+
+	{ 0x2d, KEY_REWIND },
+	{ 0x30, KEY_PLAYPAUSE },
+	{ 0x33, KEY_FASTFORWARD },
+	{ 0x3c, KEY_STOP },
+	{ 0x36, KEY_RECORD },
+	{ 0x3f, KEY_EPG },	/* Labeled "?" */
+};
+DEFINE_LEGACY_IR_KEYTABLE(pinnacle_pctv_hd);
+#else
+DECLARE_IR_KEYTABLE(pinnacle_pctv_hd);
+#endif
diff --git a/include/media/keycodes/pixelview-new.h b/include/media/keycodes/pixelview-new.h
new file mode 100644
index 0000000..76ed0c3
--- /dev/null
+++ b/include/media/keycodes/pixelview-new.h
@@ -0,0 +1,59 @@
+/* pixelview-new.h - Keytable for pixelview_new Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+   Mauro Carvalho Chehab <mchehab@infradead.org>
+   present on PV MPEG 8000GT
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode pixelview_new[] = {
+	{ 0x3c, KEY_TIME },		/* Timeshift */
+	{ 0x12, KEY_POWER },
+
+	{ 0x3d, KEY_1 },
+	{ 0x38, KEY_2 },
+	{ 0x18, KEY_3 },
+	{ 0x35, KEY_4 },
+	{ 0x39, KEY_5 },
+	{ 0x15, KEY_6 },
+	{ 0x36, KEY_7 },
+	{ 0x3a, KEY_8 },
+	{ 0x1e, KEY_9 },
+	{ 0x3e, KEY_0 },
+
+	{ 0x1c, KEY_AGAIN },		/* LOOP	*/
+	{ 0x3f, KEY_MEDIA },		/* Source */
+	{ 0x1f, KEY_LAST },		/* +100 */
+	{ 0x1b, KEY_MUTE },
+
+	{ 0x17, KEY_CHANNELDOWN },
+	{ 0x16, KEY_CHANNELUP },
+	{ 0x10, KEY_VOLUMEUP },
+	{ 0x14, KEY_VOLUMEDOWN },
+	{ 0x13, KEY_ZOOM },
+
+	{ 0x19, KEY_CAMERA },		/* SNAPSHOT */
+	{ 0x1a, KEY_SEARCH },		/* scan */
+
+	{ 0x37, KEY_REWIND },		/* << */
+	{ 0x32, KEY_RECORD },		/* o (red) */
+	{ 0x33, KEY_FORWARD },		/* >> */
+	{ 0x11, KEY_STOP },		/* square */
+	{ 0x3b, KEY_PLAY },		/* > */
+	{ 0x30, KEY_PLAYPAUSE },	/* || */
+
+	{ 0x31, KEY_TV },
+	{ 0x34, KEY_RADIO },
+};
+DEFINE_LEGACY_IR_KEYTABLE(pixelview_new);
+#else
+DECLARE_IR_KEYTABLE(pixelview_new);
+#endif
diff --git a/include/media/keycodes/pixelview.h b/include/media/keycodes/pixelview.h
new file mode 100644
index 0000000..e048277
--- /dev/null
+++ b/include/media/keycodes/pixelview.h
@@ -0,0 +1,59 @@
+/* pixelview.h - Keytable for pixelview Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode pixelview[] = {
+
+	{ 0x1e, KEY_POWER },	/* power */
+	{ 0x07, KEY_MEDIA },	/* source */
+	{ 0x1c, KEY_SEARCH },	/* scan */
+
+
+	{ 0x03, KEY_TUNER },		/* TV/FM */
+
+	{ 0x00, KEY_RECORD },
+	{ 0x08, KEY_STOP },
+	{ 0x11, KEY_PLAY },
+
+	{ 0x1a, KEY_PLAYPAUSE },	/* freeze */
+	{ 0x19, KEY_ZOOM },		/* zoom */
+	{ 0x0f, KEY_TEXT },		/* min */
+
+	{ 0x01, KEY_1 },
+	{ 0x0b, KEY_2 },
+	{ 0x1b, KEY_3 },
+	{ 0x05, KEY_4 },
+	{ 0x09, KEY_5 },
+	{ 0x15, KEY_6 },
+	{ 0x06, KEY_7 },
+	{ 0x0a, KEY_8 },
+	{ 0x12, KEY_9 },
+	{ 0x02, KEY_0 },
+	{ 0x10, KEY_LAST },		/* +100 */
+	{ 0x13, KEY_LIST },		/* recall */
+
+	{ 0x1f, KEY_CHANNELUP },	/* chn down */
+	{ 0x17, KEY_CHANNELDOWN },	/* chn up */
+	{ 0x16, KEY_VOLUMEUP },		/* vol down */
+	{ 0x14, KEY_VOLUMEDOWN },	/* vol up */
+
+	{ 0x04, KEY_KPMINUS },		/* <<< */
+	{ 0x0e, KEY_SETUP },		/* function */
+	{ 0x0c, KEY_KPPLUS },		/* >>> */
+
+	{ 0x0d, KEY_GOTO },		/* mts */
+	{ 0x1d, KEY_REFRESH },		/* reset */
+	{ 0x18, KEY_MUTE },		/* mute/unmute */
+};
+DEFINE_LEGACY_IR_KEYTABLE(pixelview);
+#else
+DECLARE_IR_KEYTABLE(pixelview);
+#endif
diff --git a/include/media/keycodes/powercolor-real-angel.h b/include/media/keycodes/powercolor-real-angel.h
new file mode 100644
index 0000000..098c4a9
--- /dev/null
+++ b/include/media/keycodes/powercolor-real-angel.h
@@ -0,0 +1,57 @@
+/* powercolor-real-angel.h - Keytable for powercolor_real_angel Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * Remote control for Powercolor Real Angel 330
+ * Daniel Fraga <fragabr@gmail.com>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode powercolor_real_angel[] = {
+	{ 0x38, KEY_SWITCHVIDEOMODE },	/* switch inputs */
+	{ 0x0c, KEY_MEDIA },		/* Turn ON/OFF App */
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+	{ 0x0a, KEY_DIGITS },		/* single, double, tripple digit */
+	{ 0x29, KEY_PREVIOUS },		/* previous channel */
+	{ 0x12, KEY_BRIGHTNESSUP },
+	{ 0x13, KEY_BRIGHTNESSDOWN },
+	{ 0x2b, KEY_MODE },		/* stereo/mono */
+	{ 0x2c, KEY_TEXT },		/* teletext */
+	{ 0x20, KEY_CHANNELUP },	/* channel up */
+	{ 0x21, KEY_CHANNELDOWN },	/* channel down */
+	{ 0x10, KEY_VOLUMEUP },		/* volume up */
+	{ 0x11, KEY_VOLUMEDOWN },	/* volume down */
+	{ 0x0d, KEY_MUTE },
+	{ 0x1f, KEY_RECORD },
+	{ 0x17, KEY_PLAY },
+	{ 0x16, KEY_PAUSE },
+	{ 0x0b, KEY_STOP },
+	{ 0x27, KEY_FASTFORWARD },
+	{ 0x26, KEY_REWIND },
+	{ 0x1e, KEY_SEARCH },		/* autoscan */
+	{ 0x0e, KEY_CAMERA },		/* snapshot */
+	{ 0x2d, KEY_SETUP },
+	{ 0x0f, KEY_SCREEN },		/* full screen */
+	{ 0x14, KEY_RADIO },		/* FM radio */
+	{ 0x25, KEY_POWER },		/* power */
+};
+DEFINE_LEGACY_IR_KEYTABLE(powercolor_real_angel);
+#else
+DECLARE_IR_KEYTABLE(powercolor_real_angel);
+#endif
diff --git a/include/media/keycodes/proteus-2309.h b/include/media/keycodes/proteus-2309.h
new file mode 100644
index 0000000..1993702
--- /dev/null
+++ b/include/media/keycodes/proteus-2309.h
@@ -0,0 +1,45 @@
+/* proteus-2309.h - Keytable for proteus_2309 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Michal Majchrowicz <mmajchrowicz@gmail.com> */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode proteus_2309[] = {
+	/* numeric */
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	{ 0x5c, KEY_POWER },		/* power       */
+	{ 0x20, KEY_ZOOM },		/* full screen */
+	{ 0x0f, KEY_BACKSPACE },	/* recall      */
+	{ 0x1b, KEY_ENTER },		/* mute        */
+	{ 0x41, KEY_RECORD },		/* record      */
+	{ 0x43, KEY_STOP },		/* stop        */
+	{ 0x16, KEY_S },
+	{ 0x1a, KEY_POWER2 },		/* off         */
+	{ 0x2e, KEY_RED },
+	{ 0x1f, KEY_CHANNELDOWN },	/* channel -   */
+	{ 0x1c, KEY_CHANNELUP },	/* channel +   */
+	{ 0x10, KEY_VOLUMEDOWN },	/* volume -    */
+	{ 0x1e, KEY_VOLUMEUP },		/* volume +    */
+	{ 0x14, KEY_F1 },
+};
+DEFINE_LEGACY_IR_KEYTABLE(proteus_2309);
+#else
+DECLARE_IR_KEYTABLE(proteus_2309);
+#endif
diff --git a/include/media/keycodes/purpletv.h b/include/media/keycodes/purpletv.h
new file mode 100644
index 0000000..1496264
--- /dev/null
+++ b/include/media/keycodes/purpletv.h
@@ -0,0 +1,58 @@
+/* purpletv.h - Keytable for purpletv Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode purpletv[] = {
+	{ 0x03, KEY_POWER },
+	{ 0x6f, KEY_MUTE },
+	{ 0x10, KEY_BACKSPACE },	/* Recall */
+
+	{ 0x11, KEY_0 },
+	{ 0x04, KEY_1 },
+	{ 0x05, KEY_2 },
+	{ 0x06, KEY_3 },
+	{ 0x08, KEY_4 },
+	{ 0x09, KEY_5 },
+	{ 0x0a, KEY_6 },
+	{ 0x0c, KEY_7 },
+	{ 0x0d, KEY_8 },
+	{ 0x0e, KEY_9 },
+	{ 0x12, KEY_DOT },	/* 100+ */
+
+	{ 0x07, KEY_VOLUMEUP },
+	{ 0x0b, KEY_VOLUMEDOWN },
+	{ 0x1a, KEY_KPPLUS },
+	{ 0x18, KEY_KPMINUS },
+	{ 0x15, KEY_UP },
+	{ 0x1d, KEY_DOWN },
+	{ 0x0f, KEY_CHANNELUP },
+	{ 0x13, KEY_CHANNELDOWN },
+	{ 0x48, KEY_ZOOM },
+
+	{ 0x1b, KEY_VIDEO },	/* Video source */
+	{ 0x1f, KEY_CAMERA },	/* Snapshot */
+	{ 0x49, KEY_LANGUAGE },	/* MTS Select */
+	{ 0x19, KEY_SEARCH },	/* Auto Scan */
+
+	{ 0x4b, KEY_RECORD },
+	{ 0x46, KEY_PLAY },
+	{ 0x45, KEY_PAUSE },	/* Pause */
+	{ 0x44, KEY_STOP },
+	{ 0x43, KEY_TIME },	/* Time Shift */
+	{ 0x17, KEY_CHANNEL },	/* SURF CH */
+	{ 0x40, KEY_FORWARD },	/* Forward ? */
+	{ 0x42, KEY_REWIND },	/* Backward ? */
+
+};
+DEFINE_LEGACY_IR_KEYTABLE(purpletv);
+#else
+DECLARE_IR_KEYTABLE(purpletv);
+#endif
diff --git a/include/media/keycodes/pv951.h b/include/media/keycodes/pv951.h
new file mode 100644
index 0000000..33a8bf7
--- /dev/null
+++ b/include/media/keycodes/pv951.h
@@ -0,0 +1,54 @@
+/* pv951.h - Keytable for pv951 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Mark Phalan <phalanm@o2.ie> */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode pv951[] = {
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	{ 0x12, KEY_POWER },
+	{ 0x10, KEY_MUTE },
+	{ 0x1f, KEY_VOLUMEDOWN },
+	{ 0x1b, KEY_VOLUMEUP },
+	{ 0x1a, KEY_CHANNELUP },
+	{ 0x1e, KEY_CHANNELDOWN },
+	{ 0x0e, KEY_PAGEUP },
+	{ 0x1d, KEY_PAGEDOWN },
+	{ 0x13, KEY_SOUND },
+
+	{ 0x18, KEY_KPPLUSMINUS },	/* CH +/- */
+	{ 0x16, KEY_SUBTITLE },		/* CC */
+	{ 0x0d, KEY_TEXT },		/* TTX */
+	{ 0x0b, KEY_TV },		/* AIR/CBL */
+	{ 0x11, KEY_PC },		/* PC/TV */
+	{ 0x17, KEY_OK },		/* CH RTN */
+	{ 0x19, KEY_MODE },		/* FUNC */
+	{ 0x0c, KEY_SEARCH },		/* AUTOSCAN */
+
+	/* Not sure what to do with these ones! */
+	{ 0x0f, KEY_SELECT },		/* SOURCE */
+	{ 0x0a, KEY_KPPLUS },		/* +100 */
+	{ 0x14, KEY_EQUAL },		/* SYNC */
+	{ 0x1c, KEY_MEDIA },		/* PC/TV */
+};
+DEFINE_LEGACY_IR_KEYTABLE(pv951);
+#else
+DECLARE_IR_KEYTABLE(pv951);
+#endif
diff --git a/include/media/keycodes/rc5-hauppauge-new.h b/include/media/keycodes/rc5-hauppauge-new.h
new file mode 100644
index 0000000..f02b59a
--- /dev/null
+++ b/include/media/keycodes/rc5-hauppauge-new.h
@@ -0,0 +1,79 @@
+/* rc5-hauppauge-new.h - Keytable for rc5_hauppauge_new Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * Hauppauge:the newer, gray remotes (seems there are multiple
+ * slightly different versions), shipped with cx88+ivtv cards.
+ *
+ * This table contains the complete RC5 code, instead of just the data part
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode rc5_hauppauge_new[] = {
+	/* Keys 0 to 9 */
+	{ 0x1e00, KEY_0 },
+	{ 0x1e01, KEY_1 },
+	{ 0x1e02, KEY_2 },
+	{ 0x1e03, KEY_3 },
+	{ 0x1e04, KEY_4 },
+	{ 0x1e05, KEY_5 },
+	{ 0x1e06, KEY_6 },
+	{ 0x1e07, KEY_7 },
+	{ 0x1e08, KEY_8 },
+	{ 0x1e09, KEY_9 },
+
+	{ 0x1e0a, KEY_TEXT },		/* keypad asterisk as well */
+	{ 0x1e0b, KEY_RED },		/* red button */
+	{ 0x1e0c, KEY_RADIO },
+	{ 0x1e0d, KEY_MENU },
+	{ 0x1e0e, KEY_SUBTITLE },		/* also the # key */
+	{ 0x1e0f, KEY_MUTE },
+	{ 0x1e10, KEY_VOLUMEUP },
+	{ 0x1e11, KEY_VOLUMEDOWN },
+	{ 0x1e12, KEY_PREVIOUS },		/* previous channel */
+	{ 0x1e14, KEY_UP },
+	{ 0x1e15, KEY_DOWN },
+	{ 0x1e16, KEY_LEFT },
+	{ 0x1e17, KEY_RIGHT },
+	{ 0x1e18, KEY_VIDEO },		/* Videos */
+	{ 0x1e19, KEY_AUDIO },		/* Music */
+	/* 0x1e1a: Pictures - presume this means
+	   "Multimedia Home Platform" -
+	   no "PICTURES" key in input.h
+	 */
+	{ 0x1e1a, KEY_MHP },
+
+	{ 0x1e1b, KEY_EPG },		/* Guide */
+	{ 0x1e1c, KEY_TV },
+	{ 0x1e1e, KEY_NEXTSONG },		/* skip >| */
+	{ 0x1e1f, KEY_EXIT },		/* back/exit */
+	{ 0x1e20, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x1e21, KEY_CHANNELDOWN },	/* channel / program - */
+	{ 0x1e22, KEY_CHANNEL },		/* source (old black remote) */
+	{ 0x1e24, KEY_PREVIOUSSONG },	/* replay |< */
+	{ 0x1e25, KEY_ENTER },		/* OK */
+	{ 0x1e26, KEY_SLEEP },		/* minimize (old black remote) */
+	{ 0x1e29, KEY_BLUE },		/* blue key */
+	{ 0x1e2e, KEY_GREEN },		/* green button */
+	{ 0x1e30, KEY_PAUSE },		/* pause */
+	{ 0x1e32, KEY_REWIND },		/* backward << */
+	{ 0x1e34, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x1e35, KEY_PLAY },
+	{ 0x1e36, KEY_STOP },
+	{ 0x1e37, KEY_RECORD },		/* recording */
+	{ 0x1e38, KEY_YELLOW },		/* yellow key */
+	{ 0x1e3b, KEY_SELECT },		/* top right button */
+	{ 0x1e3c, KEY_ZOOM },		/* full */
+	{ 0x1e3d, KEY_POWER },		/* system power (green button) */
+};
+DEFINE_IR_KEYTABLE(rc5_hauppauge_new, IR_TYPE_RC5);
+#else
+DECLARE_IR_KEYTABLE(rc5_hauppauge_new);
+#endif
diff --git a/include/media/keycodes/rc5-tv.h b/include/media/keycodes/rc5-tv.h
new file mode 100644
index 0000000..a429a54
--- /dev/null
+++ b/include/media/keycodes/rc5-tv.h
@@ -0,0 +1,57 @@
+/* rc5-tv.h - Keytable for rc5_tv Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* generic RC5 keytable                                          */
+/* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
+/* used by old (black) Hauppauge remotes                         */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode rc5_tv[] = {
+	/* Keys 0 to 9 */
+	{ 0x00, KEY_0 },
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+
+	{ 0x0b, KEY_CHANNEL },		/* channel / program (japan: 11) */
+	{ 0x0c, KEY_POWER },		/* standby */
+	{ 0x0d, KEY_MUTE },		/* mute / demute */
+	{ 0x0f, KEY_TV },		/* display */
+	{ 0x10, KEY_VOLUMEUP },
+	{ 0x11, KEY_VOLUMEDOWN },
+	{ 0x12, KEY_BRIGHTNESSUP },
+	{ 0x13, KEY_BRIGHTNESSDOWN },
+	{ 0x1e, KEY_SEARCH },		/* search + */
+	{ 0x20, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x21, KEY_CHANNELDOWN },	/* channel / program - */
+	{ 0x22, KEY_CHANNEL },		/* alt / channel */
+	{ 0x23, KEY_LANGUAGE },		/* 1st / 2nd language */
+	{ 0x26, KEY_SLEEP },		/* sleeptimer */
+	{ 0x2e, KEY_MENU },		/* 2nd controls (USA: menu) */
+	{ 0x30, KEY_PAUSE },
+	{ 0x32, KEY_REWIND },
+	{ 0x33, KEY_GOTO },
+	{ 0x35, KEY_PLAY },
+	{ 0x36, KEY_STOP },
+	{ 0x37, KEY_RECORD },		/* recording */
+	{ 0x3c, KEY_TEXT },		/* teletext submode (Japan: 12) */
+	{ 0x3d, KEY_SUSPEND },		/* system standby */
+
+};
+DEFINE_LEGACY_IR_KEYTABLE(rc5_tv);
+#else
+DECLARE_IR_KEYTABLE(rc5_tv);
+#endif
diff --git a/include/media/keycodes/real-audio-220-32-keys.h b/include/media/keycodes/real-audio-220-32-keys.h
new file mode 100644
index 0000000..5f6835d
--- /dev/null
+++ b/include/media/keycodes/real-audio-220-32-keys.h
@@ -0,0 +1,54 @@
+/* real-audio-220-32-keys.h - Keytable for real_audio_220_32_keys Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Zogis Real Audio 220 - 32 keys IR */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode real_audio_220_32_keys[] = {
+	{ 0x1c, KEY_RADIO},
+	{ 0x12, KEY_POWER2},
+
+	{ 0x01, KEY_1},
+	{ 0x02, KEY_2},
+	{ 0x03, KEY_3},
+	{ 0x04, KEY_4},
+	{ 0x05, KEY_5},
+	{ 0x06, KEY_6},
+	{ 0x07, KEY_7},
+	{ 0x08, KEY_8},
+	{ 0x09, KEY_9},
+	{ 0x00, KEY_0},
+
+	{ 0x0c, KEY_VOLUMEUP},
+	{ 0x18, KEY_VOLUMEDOWN},
+	{ 0x0b, KEY_CHANNELUP},
+	{ 0x15, KEY_CHANNELDOWN},
+	{ 0x16, KEY_ENTER},
+
+	{ 0x11, KEY_LIST},		/* Source */
+	{ 0x0d, KEY_AUDIO},		/* stereo */
+
+	{ 0x0f, KEY_PREVIOUS},		/* Prev */
+	{ 0x1b, KEY_TIME},		/* Timeshift */
+	{ 0x1a, KEY_NEXT},		/* Next */
+
+	{ 0x0e, KEY_STOP},
+	{ 0x1f, KEY_PLAY},
+	{ 0x1e, KEY_PLAYPAUSE},		/* Pause */
+
+	{ 0x1d, KEY_RECORD},
+	{ 0x13, KEY_MUTE},
+	{ 0x19, KEY_CAMERA},		/* Snapshot */
+
+};
+DEFINE_LEGACY_IR_KEYTABLE(real_audio_220_32_keys);
+#else
+DECLARE_IR_KEYTABLE(real_audio_220_32_keys);
+#endif
diff --git a/include/media/keycodes/tbs-nec.h b/include/media/keycodes/tbs-nec.h
new file mode 100644
index 0000000..156985e
--- /dev/null
+++ b/include/media/keycodes/tbs-nec.h
@@ -0,0 +1,50 @@
+/* tbs-nec.h - Keytable for tbs_nec Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode tbs_nec[] = {
+	{ 0x04, KEY_POWER2},	/*power*/
+	{ 0x14, KEY_MUTE},	/*mute*/
+	{ 0x07, KEY_1},
+	{ 0x06, KEY_2},
+	{ 0x05, KEY_3},
+	{ 0x0b, KEY_4},
+	{ 0x0a, KEY_5},
+	{ 0x09, KEY_6},
+	{ 0x0f, KEY_7},
+	{ 0x0e, KEY_8},
+	{ 0x0d, KEY_9},
+	{ 0x12, KEY_0},
+	{ 0x16, KEY_CHANNELUP},	/*ch+*/
+	{ 0x11, KEY_CHANNELDOWN},/*ch-*/
+	{ 0x13, KEY_VOLUMEUP},	/*vol+*/
+	{ 0x0c, KEY_VOLUMEDOWN},/*vol-*/
+	{ 0x03, KEY_RECORD},	/*rec*/
+	{ 0x18, KEY_PAUSE},	/*pause*/
+	{ 0x19, KEY_OK},	/*ok*/
+	{ 0x1a, KEY_CAMERA},	/* snapshot */
+	{ 0x01, KEY_UP},
+	{ 0x10, KEY_LEFT},
+	{ 0x02, KEY_RIGHT},
+	{ 0x08, KEY_DOWN},
+	{ 0x15, KEY_FAVORITES},
+	{ 0x17, KEY_SUBTITLE},
+	{ 0x1d, KEY_ZOOM},
+	{ 0x1f, KEY_EXIT},
+	{ 0x1e, KEY_MENU},
+	{ 0x1c, KEY_EPG},
+	{ 0x00, KEY_PREVIOUS},
+	{ 0x1b, KEY_MODE},
+};
+DEFINE_LEGACY_IR_KEYTABLE(tbs_nec);
+#else
+DECLARE_IR_KEYTABLE(tbs_nec);
+#endif
diff --git a/include/media/keycodes/terratec-cinergy-xs.h b/include/media/keycodes/terratec-cinergy-xs.h
new file mode 100644
index 0000000..8f50fae
--- /dev/null
+++ b/include/media/keycodes/terratec-cinergy-xs.h
@@ -0,0 +1,68 @@
+/* terratec-cinergy-xs.h - Keytable for terratec_cinergy_xs Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Terratec Cinergy Hybrid T USB XS
+   Devin Heitmueller <dheitmueller@linuxtv.org>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode terratec_cinergy_xs[] = {
+	{ 0x41, KEY_HOME},
+	{ 0x01, KEY_POWER},
+	{ 0x42, KEY_MENU},
+	{ 0x02, KEY_1},
+	{ 0x03, KEY_2},
+	{ 0x04, KEY_3},
+	{ 0x43, KEY_SUBTITLE},
+	{ 0x05, KEY_4},
+	{ 0x06, KEY_5},
+	{ 0x07, KEY_6},
+	{ 0x44, KEY_TEXT},
+	{ 0x08, KEY_7},
+	{ 0x09, KEY_8},
+	{ 0x0a, KEY_9},
+	{ 0x45, KEY_DELETE},
+	{ 0x0b, KEY_TUNER},
+	{ 0x0c, KEY_0},
+	{ 0x0d, KEY_MODE},
+	{ 0x46, KEY_TV},
+	{ 0x47, KEY_DVD},
+	{ 0x49, KEY_VIDEO},
+	{ 0x4b, KEY_AUX},
+	{ 0x10, KEY_UP},
+	{ 0x11, KEY_LEFT},
+	{ 0x12, KEY_OK},
+	{ 0x13, KEY_RIGHT},
+	{ 0x14, KEY_DOWN},
+	{ 0x0f, KEY_EPG},
+	{ 0x16, KEY_INFO},
+	{ 0x4d, KEY_BACKSPACE},
+	{ 0x1c, KEY_VOLUMEUP},
+	{ 0x4c, KEY_PLAY},
+	{ 0x1b, KEY_CHANNELUP},
+	{ 0x1e, KEY_VOLUMEDOWN},
+	{ 0x1d, KEY_MUTE},
+	{ 0x1f, KEY_CHANNELDOWN},
+	{ 0x17, KEY_RED},
+	{ 0x18, KEY_GREEN},
+	{ 0x19, KEY_YELLOW},
+	{ 0x1a, KEY_BLUE},
+	{ 0x58, KEY_RECORD},
+	{ 0x48, KEY_STOP},
+	{ 0x40, KEY_PAUSE},
+	{ 0x54, KEY_LAST},
+	{ 0x4e, KEY_REWIND},
+	{ 0x4f, KEY_FASTFORWARD},
+	{ 0x5c, KEY_NEXT},
+};
+DEFINE_LEGACY_IR_KEYTABLE(terratec_cinergy_xs);
+#else
+DECLARE_IR_KEYTABLE(terratec_cinergy_xs);
+#endif
diff --git a/include/media/keycodes/tevii-nec.h b/include/media/keycodes/tevii-nec.h
new file mode 100644
index 0000000..6a8ea03
--- /dev/null
+++ b/include/media/keycodes/tevii-nec.h
@@ -0,0 +1,65 @@
+/* tevii-nec.h - Keytable for tevii_nec Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode tevii_nec[] = {
+	{ 0x0a, KEY_POWER2},
+	{ 0x0c, KEY_MUTE},
+	{ 0x11, KEY_1},
+	{ 0x12, KEY_2},
+	{ 0x13, KEY_3},
+	{ 0x14, KEY_4},
+	{ 0x15, KEY_5},
+	{ 0x16, KEY_6},
+	{ 0x17, KEY_7},
+	{ 0x18, KEY_8},
+	{ 0x19, KEY_9},
+	{ 0x10, KEY_0},
+	{ 0x1c, KEY_MENU},
+	{ 0x0f, KEY_VOLUMEDOWN},
+	{ 0x1a, KEY_LAST},
+	{ 0x0e, KEY_OPEN},
+	{ 0x04, KEY_RECORD},
+	{ 0x09, KEY_VOLUMEUP},
+	{ 0x08, KEY_CHANNELUP},
+	{ 0x07, KEY_PVR},
+	{ 0x0b, KEY_TIME},
+	{ 0x02, KEY_RIGHT},
+	{ 0x03, KEY_LEFT},
+	{ 0x00, KEY_UP},
+	{ 0x1f, KEY_OK},
+	{ 0x01, KEY_DOWN},
+	{ 0x05, KEY_TUNER},
+	{ 0x06, KEY_CHANNELDOWN},
+	{ 0x40, KEY_PLAYPAUSE},
+	{ 0x1e, KEY_REWIND},
+	{ 0x1b, KEY_FAVORITES},
+	{ 0x1d, KEY_BACK},
+	{ 0x4d, KEY_FASTFORWARD},
+	{ 0x44, KEY_EPG},
+	{ 0x4c, KEY_INFO},
+	{ 0x41, KEY_AB},
+	{ 0x43, KEY_AUDIO},
+	{ 0x45, KEY_SUBTITLE},
+	{ 0x4a, KEY_LIST},
+	{ 0x46, KEY_F1},
+	{ 0x47, KEY_F2},
+	{ 0x5e, KEY_F3},
+	{ 0x5c, KEY_F4},
+	{ 0x52, KEY_F5},
+	{ 0x5a, KEY_F6},
+	{ 0x56, KEY_MODE},
+	{ 0x58, KEY_SWITCHVIDEOMODE},
+};
+DEFINE_LEGACY_IR_KEYTABLE(tevii_nec);
+#else
+DECLARE_IR_KEYTABLE(tevii_nec);
+#endif
diff --git a/include/media/keycodes/tt-1500.h b/include/media/keycodes/tt-1500.h
new file mode 100644
index 0000000..45ffcba
--- /dev/null
+++ b/include/media/keycodes/tt-1500.h
@@ -0,0 +1,58 @@
+/* tt-1500.h - Keytable for tt_1500 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* for the Technotrend 1500 bundled remotes (grey and black): */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode tt_1500[] = {
+	{ 0x01, KEY_POWER },
+	{ 0x02, KEY_SHUFFLE },		/* ? double-arrow key */
+	{ 0x03, KEY_1 },
+	{ 0x04, KEY_2 },
+	{ 0x05, KEY_3 },
+	{ 0x06, KEY_4 },
+	{ 0x07, KEY_5 },
+	{ 0x08, KEY_6 },
+	{ 0x09, KEY_7 },
+	{ 0x0a, KEY_8 },
+	{ 0x0b, KEY_9 },
+	{ 0x0c, KEY_0 },
+	{ 0x0d, KEY_UP },
+	{ 0x0e, KEY_LEFT },
+	{ 0x0f, KEY_OK },
+	{ 0x10, KEY_RIGHT },
+	{ 0x11, KEY_DOWN },
+	{ 0x12, KEY_INFO },
+	{ 0x13, KEY_EXIT },
+	{ 0x14, KEY_RED },
+	{ 0x15, KEY_GREEN },
+	{ 0x16, KEY_YELLOW },
+	{ 0x17, KEY_BLUE },
+	{ 0x18, KEY_MUTE },
+	{ 0x19, KEY_TEXT },
+	{ 0x1a, KEY_MODE },		/* ? TV/Radio */
+	{ 0x21, KEY_OPTION },
+	{ 0x22, KEY_EPG },
+	{ 0x23, KEY_CHANNELUP },
+	{ 0x24, KEY_CHANNELDOWN },
+	{ 0x25, KEY_VOLUMEUP },
+	{ 0x26, KEY_VOLUMEDOWN },
+	{ 0x27, KEY_SETUP },
+	{ 0x3a, KEY_RECORD },		/* these keys are only in the black remote */
+	{ 0x3b, KEY_PLAY },
+	{ 0x3c, KEY_STOP },
+	{ 0x3d, KEY_REWIND },
+	{ 0x3e, KEY_PAUSE },
+	{ 0x3f, KEY_FORWARD },
+};
+DEFINE_LEGACY_IR_KEYTABLE(tt_1500);
+#else
+DECLARE_IR_KEYTABLE(tt_1500);
+#endif
diff --git a/include/media/keycodes/videomate-s350.h b/include/media/keycodes/videomate-s350.h
new file mode 100644
index 0000000..ff38424
--- /dev/null
+++ b/include/media/keycodes/videomate-s350.h
@@ -0,0 +1,62 @@
+/* videomate-s350.h - Keytable for videomate_s350 Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode videomate_s350[] = {
+	{ 0x00, KEY_TV},
+	{ 0x01, KEY_DVD},
+	{ 0x04, KEY_RECORD},
+	{ 0x05, KEY_VIDEO},	/* TV/Video */
+	{ 0x07, KEY_STOP},
+	{ 0x08, KEY_PLAYPAUSE},
+	{ 0x0a, KEY_REWIND},
+	{ 0x0f, KEY_FASTFORWARD},
+	{ 0x10, KEY_CHANNELUP},
+	{ 0x12, KEY_VOLUMEUP},
+	{ 0x13, KEY_CHANNELDOWN},
+	{ 0x14, KEY_MUTE},
+	{ 0x15, KEY_VOLUMEDOWN},
+	{ 0x16, KEY_1},
+	{ 0x17, KEY_2},
+	{ 0x18, KEY_3},
+	{ 0x19, KEY_4},
+	{ 0x1a, KEY_5},
+	{ 0x1b, KEY_6},
+	{ 0x1c, KEY_7},
+	{ 0x1d, KEY_8},
+	{ 0x1e, KEY_9},
+	{ 0x1f, KEY_0},
+	{ 0x21, KEY_SLEEP},
+	{ 0x24, KEY_ZOOM},
+	{ 0x25, KEY_LAST},	/* Recall */
+	{ 0x26, KEY_SUBTITLE},	/* CC */
+	{ 0x27, KEY_LANGUAGE},	/* MTS */
+	{ 0x29, KEY_CHANNEL},	/* SURF */
+	{ 0x2b, KEY_A},
+	{ 0x2c, KEY_B},
+	{ 0x2f, KEY_CAMERA},	/* Snapshot */
+	{ 0x23, KEY_RADIO},
+	{ 0x02, KEY_PREVIOUSSONG},
+	{ 0x06, KEY_NEXTSONG},
+	{ 0x03, KEY_EPG},
+	{ 0x09, KEY_SETUP},
+	{ 0x22, KEY_BACKSPACE},
+	{ 0x0c, KEY_UP},
+	{ 0x0e, KEY_DOWN},
+	{ 0x0b, KEY_LEFT},
+	{ 0x0d, KEY_RIGHT},
+	{ 0x11, KEY_ENTER},
+	{ 0x20, KEY_TEXT},
+};
+DEFINE_LEGACY_IR_KEYTABLE(videomate_s350);
+#else
+DECLARE_IR_KEYTABLE(videomate_s350);
+#endif
diff --git a/include/media/keycodes/videomate-tv-pvr.h b/include/media/keycodes/videomate-tv-pvr.h
new file mode 100644
index 0000000..f77375d
--- /dev/null
+++ b/include/media/keycodes/videomate-tv-pvr.h
@@ -0,0 +1,64 @@
+/* videomate-tv-pvr.h - Keytable for videomate_tv_pvr Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode videomate_tv_pvr[] = {
+	{ 0x14, KEY_MUTE },
+	{ 0x24, KEY_ZOOM },
+
+	{ 0x01, KEY_DVD },
+	{ 0x23, KEY_RADIO },
+	{ 0x00, KEY_TV },
+
+	{ 0x0a, KEY_REWIND },
+	{ 0x08, KEY_PLAYPAUSE },
+	{ 0x0f, KEY_FORWARD },
+
+	{ 0x02, KEY_PREVIOUS },
+	{ 0x07, KEY_STOP },
+	{ 0x06, KEY_NEXT },
+
+	{ 0x0c, KEY_UP },
+	{ 0x0e, KEY_DOWN },
+	{ 0x0b, KEY_LEFT },
+	{ 0x0d, KEY_RIGHT },
+	{ 0x11, KEY_OK },
+
+	{ 0x03, KEY_MENU },
+	{ 0x09, KEY_SETUP },
+	{ 0x05, KEY_VIDEO },
+	{ 0x22, KEY_CHANNEL },
+
+	{ 0x12, KEY_VOLUMEUP },
+	{ 0x15, KEY_VOLUMEDOWN },
+	{ 0x10, KEY_CHANNELUP },
+	{ 0x13, KEY_CHANNELDOWN },
+
+	{ 0x04, KEY_RECORD },
+
+	{ 0x16, KEY_1 },
+	{ 0x17, KEY_2 },
+	{ 0x18, KEY_3 },
+	{ 0x19, KEY_4 },
+	{ 0x1a, KEY_5 },
+	{ 0x1b, KEY_6 },
+	{ 0x1c, KEY_7 },
+	{ 0x1d, KEY_8 },
+	{ 0x1e, KEY_9 },
+	{ 0x1f, KEY_0 },
+
+	{ 0x20, KEY_LANGUAGE },
+	{ 0x21, KEY_SLEEP },
+};
+DEFINE_LEGACY_IR_KEYTABLE(videomate_tv_pvr);
+#else
+DECLARE_IR_KEYTABLE(videomate_tv_pvr);
+#endif
diff --git a/include/media/keycodes/winfast-usbii-deluxe.h b/include/media/keycodes/winfast-usbii-deluxe.h
new file mode 100644
index 0000000..0d2c14f
--- /dev/null
+++ b/include/media/keycodes/winfast-usbii-deluxe.h
@@ -0,0 +1,58 @@
+/* winfast-usbii-deluxe.h - Keytable for winfast_usbii_deluxe Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Leadtek Winfast TV USB II Deluxe remote
+   Magnus Alm <magnus.alm@gmail.com>
+ */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode winfast_usbii_deluxe[] = {
+	{ 0x62, KEY_0},
+	{ 0x75, KEY_1},
+	{ 0x76, KEY_2},
+	{ 0x77, KEY_3},
+	{ 0x79, KEY_4},
+	{ 0x7a, KEY_5},
+	{ 0x7b, KEY_6},
+	{ 0x7d, KEY_7},
+	{ 0x7e, KEY_8},
+	{ 0x7f, KEY_9},
+
+	{ 0x38, KEY_CAMERA},		/* SNAPSHOT */
+	{ 0x37, KEY_RECORD},		/* RECORD */
+	{ 0x35, KEY_TIME},		/* TIMESHIFT */
+
+	{ 0x74, KEY_VOLUMEUP},		/* VOLUMEUP */
+	{ 0x78, KEY_VOLUMEDOWN},	/* VOLUMEDOWN */
+	{ 0x64, KEY_MUTE},		/* MUTE */
+
+	{ 0x21, KEY_CHANNEL},		/* SURF */
+	{ 0x7c, KEY_CHANNELUP},		/* CHANNELUP */
+	{ 0x60, KEY_CHANNELDOWN},	/* CHANNELDOWN */
+	{ 0x61, KEY_LAST},		/* LAST CHANNEL (RECALL) */
+
+	{ 0x72, KEY_VIDEO}, 		/* INPUT MODES (TV/FM) */
+
+	{ 0x70, KEY_POWER2},		/* TV ON/OFF */
+
+	{ 0x39, KEY_CYCLEWINDOWS},	/* MINIMIZE (BOSS) */
+	{ 0x3a, KEY_NEW},		/* PIP */
+	{ 0x73, KEY_ZOOM},		/* FULLSECREEN */
+
+	{ 0x66, KEY_INFO},		/* OSD (DISPLAY) */
+
+	{ 0x31, KEY_DOT},		/* '.' */
+	{ 0x63, KEY_ENTER},		/* ENTER */
+
+};
+DEFINE_LEGACY_IR_KEYTABLE(winfast_usbii_deluxe);
+#else
+DECLARE_IR_KEYTABLE(winfast_usbii_deluxe);
+#endif
diff --git a/include/media/keycodes/winfast.h b/include/media/keycodes/winfast.h
new file mode 100644
index 0000000..4f42e24
--- /dev/null
+++ b/include/media/keycodes/winfast.h
@@ -0,0 +1,78 @@
+/* winfast.h - Keytable for winfast Remote Controller
+ *
+ * Imported from ir-keymaps.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/* Table for Leadtek Winfast Remote Controls - used by both bttv and cx88 */
+
+#ifdef IR_KEYMAPS
+static struct ir_scancode winfast[] = {
+	/* Keys 0 to 9 */
+	{ 0x12, KEY_0 },
+	{ 0x05, KEY_1 },
+	{ 0x06, KEY_2 },
+	{ 0x07, KEY_3 },
+	{ 0x09, KEY_4 },
+	{ 0x0a, KEY_5 },
+	{ 0x0b, KEY_6 },
+	{ 0x0d, KEY_7 },
+	{ 0x0e, KEY_8 },
+	{ 0x0f, KEY_9 },
+
+	{ 0x00, KEY_POWER },
+	{ 0x1b, KEY_AUDIO },		/* Audio Source */
+	{ 0x02, KEY_TUNER },		/* TV/FM, not on Y0400052 */
+	{ 0x1e, KEY_VIDEO },		/* Video Source */
+	{ 0x16, KEY_INFO },		/* Display information */
+	{ 0x04, KEY_VOLUMEUP },
+	{ 0x08, KEY_VOLUMEDOWN },
+	{ 0x0c, KEY_CHANNELUP },
+	{ 0x10, KEY_CHANNELDOWN },
+	{ 0x03, KEY_ZOOM },		/* fullscreen */
+	{ 0x1f, KEY_TEXT },		/* closed caption/teletext */
+	{ 0x20, KEY_SLEEP },
+	{ 0x29, KEY_CLEAR },		/* boss key */
+	{ 0x14, KEY_MUTE },
+	{ 0x2b, KEY_RED },
+	{ 0x2c, KEY_GREEN },
+	{ 0x2d, KEY_YELLOW },
+	{ 0x2e, KEY_BLUE },
+	{ 0x18, KEY_KPPLUS },		/* fine tune + , not on Y040052 */
+	{ 0x19, KEY_KPMINUS },		/* fine tune - , not on Y040052 */
+	{ 0x2a, KEY_MEDIA },		/* PIP (Picture in picture */
+	{ 0x21, KEY_DOT },
+	{ 0x13, KEY_ENTER },
+	{ 0x11, KEY_LAST },		/* Recall (last channel */
+	{ 0x22, KEY_PREVIOUS },
+	{ 0x23, KEY_PLAYPAUSE },
+	{ 0x24, KEY_NEXT },
+	{ 0x25, KEY_TIME },		/* Time Shifting */
+	{ 0x26, KEY_STOP },
+	{ 0x27, KEY_RECORD },
+	{ 0x28, KEY_SAVE },		/* Screenshot */
+	{ 0x2f, KEY_MENU },
+	{ 0x30, KEY_CANCEL },
+	{ 0x31, KEY_CHANNEL },		/* Channel Surf */
+	{ 0x32, KEY_SUBTITLE },
+	{ 0x33, KEY_LANGUAGE },
+	{ 0x34, KEY_REWIND },
+	{ 0x35, KEY_FASTFORWARD },
+	{ 0x36, KEY_TV },
+	{ 0x37, KEY_RADIO },		/* FM */
+	{ 0x38, KEY_DVD },
+
+	{ 0x1a, KEY_MODE},		/* change to MCE mode on Y04G0051 */
+	{ 0x3e, KEY_F21 },		/* MCE +VOL, on Y04G0033 */
+	{ 0x3a, KEY_F22 },		/* MCE -VOL, on Y04G0033 */
+	{ 0x3b, KEY_F23 },		/* MCE +CH,  on Y04G0033 */
+	{ 0x3f, KEY_F24 }		/* MCE -CH,  on Y04G0033 */
+};
+DEFINE_LEGACY_IR_KEYTABLE(winfast);
+#else
+DECLARE_IR_KEYTABLE(winfast);
+#endif
-- 
1.6.6.1


