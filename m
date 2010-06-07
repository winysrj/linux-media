Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51242 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab0FGTc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 15:32:58 -0400
Subject: [PATCH 8/8] ir-core: merge rc-map.h into ir-core.h
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Date: Mon, 07 Jun 2010 21:32:53 +0200
Message-ID: <20100607193253.21236.98706.stgit@localhost.localdomain>
In-Reply-To: <20100607192830.21236.69701.stgit@localhost.localdomain>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Haven't discussed this patch on the linux-media list yet, but
merging rc-map.h into ir-core.h at least makes it much easier
for me to get a good overview of the entire rc-core subsystem
(and to make sweeping changes). Not sure if everyone agrees?

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c    |    2 
 drivers/media/IR/keymaps/rc-apac-viewcomp.c        |    2 
 drivers/media/IR/keymaps/rc-asus-pc39.c            |    2 
 drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c |    2 
 drivers/media/IR/keymaps/rc-avermedia-a16d.c       |    2 
 drivers/media/IR/keymaps/rc-avermedia-cardbus.c    |    2 
 drivers/media/IR/keymaps/rc-avermedia-dvbt.c       |    2 
 .../media/IR/keymaps/rc-avermedia-m135a-rm-jx.c    |    2 
 drivers/media/IR/keymaps/rc-avermedia.c            |    2 
 drivers/media/IR/keymaps/rc-avertv-303.c           |    2 
 drivers/media/IR/keymaps/rc-behold-columbus.c      |    2 
 drivers/media/IR/keymaps/rc-behold.c               |    2 
 drivers/media/IR/keymaps/rc-budget-ci-old.c        |    2 
 drivers/media/IR/keymaps/rc-cinergy-1400.c         |    2 
 drivers/media/IR/keymaps/rc-cinergy.c              |    2 
 drivers/media/IR/keymaps/rc-dm1105-nec.c           |    2 
 drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c      |    2 
 drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c   |    2 
 drivers/media/IR/keymaps/rc-em-terratec.c          |    2 
 drivers/media/IR/keymaps/rc-empty.c                |    2 
 drivers/media/IR/keymaps/rc-encore-enltv-fm53.c    |    2 
 drivers/media/IR/keymaps/rc-encore-enltv.c         |    2 
 drivers/media/IR/keymaps/rc-encore-enltv2.c        |    2 
 drivers/media/IR/keymaps/rc-evga-indtube.c         |    2 
 drivers/media/IR/keymaps/rc-eztv.c                 |    2 
 drivers/media/IR/keymaps/rc-flydvb.c               |    2 
 drivers/media/IR/keymaps/rc-flyvideo.c             |    2 
 drivers/media/IR/keymaps/rc-fusionhdtv-mce.c       |    2 
 drivers/media/IR/keymaps/rc-gadmei-rm008z.c        |    2 
 drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c   |    2 
 drivers/media/IR/keymaps/rc-gotview7135.c          |    2 
 drivers/media/IR/keymaps/rc-hauppauge-new.c        |    2 
 drivers/media/IR/keymaps/rc-imon-mce.c             |    2 
 drivers/media/IR/keymaps/rc-imon-pad.c             |    2 
 drivers/media/IR/keymaps/rc-iodata-bctv7e.c        |    2 
 drivers/media/IR/keymaps/rc-kaiomy.c               |    2 
 drivers/media/IR/keymaps/rc-kworld-315u.c          |    2 
 .../media/IR/keymaps/rc-kworld-plus-tv-analog.c    |    2 
 drivers/media/IR/keymaps/rc-manli.c                |    2 
 drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c  |    2 
 drivers/media/IR/keymaps/rc-msi-tvanywhere.c       |    2 
 drivers/media/IR/keymaps/rc-nebula.c               |    2 
 .../media/IR/keymaps/rc-nec-terratec-cinergy-xs.c  |    2 
 drivers/media/IR/keymaps/rc-norwood.c              |    2 
 drivers/media/IR/keymaps/rc-npgtech.c              |    2 
 drivers/media/IR/keymaps/rc-pctv-sedna.c           |    2 
 drivers/media/IR/keymaps/rc-pinnacle-color.c       |    2 
 drivers/media/IR/keymaps/rc-pinnacle-grey.c        |    2 
 drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c     |    2 
 drivers/media/IR/keymaps/rc-pixelview-mk12.c       |    2 
 drivers/media/IR/keymaps/rc-pixelview-new.c        |    2 
 drivers/media/IR/keymaps/rc-pixelview.c            |    2 
 .../media/IR/keymaps/rc-powercolor-real-angel.c    |    2 
 drivers/media/IR/keymaps/rc-proteus-2309.c         |    2 
 drivers/media/IR/keymaps/rc-purpletv.c             |    2 
 drivers/media/IR/keymaps/rc-pv951.c                |    2 
 drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c    |    2 
 drivers/media/IR/keymaps/rc-rc5-tv.c               |    2 
 .../media/IR/keymaps/rc-real-audio-220-32-keys.c   |    2 
 drivers/media/IR/keymaps/rc-tbs-nec.c              |    2 
 drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c  |    2 
 drivers/media/IR/keymaps/rc-tevii-nec.c            |    2 
 drivers/media/IR/keymaps/rc-tt-1500.c              |    2 
 drivers/media/IR/keymaps/rc-videomate-s350.c       |    2 
 drivers/media/IR/keymaps/rc-videomate-tv-pvr.c     |    2 
 drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c |    2 
 drivers/media/IR/keymaps/rc-winfast.c              |    2 
 include/media/ir-core.h                            |  112 ++++++++++++++++++-
 include/media/rc-map.h                             |  121 --------------------
 69 files changed, 178 insertions(+), 189 deletions(-)
 delete mode 100644 include/media/rc-map.h

diff --git a/drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c
index b172831..8d5655a 100644
--- a/drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* ADS Tech Instant TV DVB-T PCI Remote */
 
diff --git a/drivers/media/IR/keymaps/rc-apac-viewcomp.c b/drivers/media/IR/keymaps/rc-apac-viewcomp.c
index 0ef2b56..fa9c9a7 100644
--- a/drivers/media/IR/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/IR/keymaps/rc-apac-viewcomp.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Attila Kondoros <attila.kondoros@chello.hu> */
 
diff --git a/drivers/media/IR/keymaps/rc-asus-pc39.c b/drivers/media/IR/keymaps/rc-asus-pc39.c
index 2aa068c..d6bd983 100644
--- a/drivers/media/IR/keymaps/rc-asus-pc39.c
+++ b/drivers/media/IR/keymaps/rc-asus-pc39.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
  * Marc Fargas <telenieko@telenieko.com>
diff --git a/drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c
index 8edfd29..cb4ddc8 100644
--- a/drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* ATI TV Wonder HD 600 USB
    Devin Heitmueller <devin.heitmueller@gmail.com>
diff --git a/drivers/media/IR/keymaps/rc-avermedia-a16d.c b/drivers/media/IR/keymaps/rc-avermedia-a16d.c
index 12f0435..332de38 100644
--- a/drivers/media/IR/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/IR/keymaps/rc-avermedia-a16d.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode avermedia_a16d[] = {
 	{ 0x20, KEY_LIST},
diff --git a/drivers/media/IR/keymaps/rc-avermedia-cardbus.c b/drivers/media/IR/keymaps/rc-avermedia-cardbus.c
index 2a945b0..c7bf603 100644
--- a/drivers/media/IR/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/IR/keymaps/rc-avermedia-cardbus.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Oldrich Jedlicka <oldium.pro@seznam.cz> */
 
diff --git a/drivers/media/IR/keymaps/rc-avermedia-dvbt.c b/drivers/media/IR/keymaps/rc-avermedia-dvbt.c
index 39dde62..32339c8 100644
--- a/drivers/media/IR/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/IR/keymaps/rc-avermedia-dvbt.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Matt Jesson <dvb@jesson.eclipse.co.uk */
 
diff --git a/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c b/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
index 101e7ea..fe7a76f 100644
--- a/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
+++ b/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
  * Avermedia M135A with IR model RM-JX
diff --git a/drivers/media/IR/keymaps/rc-avermedia.c b/drivers/media/IR/keymaps/rc-avermedia.c
index 21effd5..ebb6ff4 100644
--- a/drivers/media/IR/keymaps/rc-avermedia.c
+++ b/drivers/media/IR/keymaps/rc-avermedia.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Alex Hermann <gaaf@gmx.net> */
 
diff --git a/drivers/media/IR/keymaps/rc-avertv-303.c b/drivers/media/IR/keymaps/rc-avertv-303.c
index 971c59d..a2d7372 100644
--- a/drivers/media/IR/keymaps/rc-avertv-303.c
+++ b/drivers/media/IR/keymaps/rc-avertv-303.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* AVERTV STUDIO 303 Remote */
 
diff --git a/drivers/media/IR/keymaps/rc-behold-columbus.c b/drivers/media/IR/keymaps/rc-behold-columbus.c
index 9f56c98..1702137 100644
--- a/drivers/media/IR/keymaps/rc-behold-columbus.c
+++ b/drivers/media/IR/keymaps/rc-behold-columbus.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Beholder Intl. Ltd. 2008
  * Dmitry Belimov d.belimov@google.com
diff --git a/drivers/media/IR/keymaps/rc-behold.c b/drivers/media/IR/keymaps/rc-behold.c
index abc140b..5f30f5d 100644
--- a/drivers/media/IR/keymaps/rc-behold.c
+++ b/drivers/media/IR/keymaps/rc-behold.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
  * Igor Kuznetsov <igk72@ya.ru>
diff --git a/drivers/media/IR/keymaps/rc-budget-ci-old.c b/drivers/media/IR/keymaps/rc-budget-ci-old.c
index 64c2ac9..fdc9f1a 100644
--- a/drivers/media/IR/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/IR/keymaps/rc-budget-ci-old.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* From reading the following remotes:
  * Zenith Universal 7 / TV Mode 807 / VCR Mode 837
diff --git a/drivers/media/IR/keymaps/rc-cinergy-1400.c b/drivers/media/IR/keymaps/rc-cinergy-1400.c
index 074f2c2..f45761a 100644
--- a/drivers/media/IR/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/IR/keymaps/rc-cinergy-1400.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Cinergy 1400 DVB-T */
 
diff --git a/drivers/media/IR/keymaps/rc-cinergy.c b/drivers/media/IR/keymaps/rc-cinergy.c
index cf84c3d..656cada 100644
--- a/drivers/media/IR/keymaps/rc-cinergy.c
+++ b/drivers/media/IR/keymaps/rc-cinergy.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode cinergy[] = {
 	{ 0x00, KEY_0 },
diff --git a/drivers/media/IR/keymaps/rc-dm1105-nec.c b/drivers/media/IR/keymaps/rc-dm1105-nec.c
index 90684d0..8ffedf0 100644
--- a/drivers/media/IR/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/IR/keymaps/rc-dm1105-nec.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* DVBWorld remotes
    Igor M. Liplianin <liplianin@me.by>
diff --git a/drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c
index 8a4027a..7bf9674 100644
--- a/drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* DigitalNow DNTV Live DVB-T Remote */
 
diff --git a/drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c
index 6f4d607..8815a60 100644
--- a/drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* DigitalNow DNTV Live! DVB-T Pro Remote */
 
diff --git a/drivers/media/IR/keymaps/rc-em-terratec.c b/drivers/media/IR/keymaps/rc-em-terratec.c
index 3130c9c..6c16941 100644
--- a/drivers/media/IR/keymaps/rc-em-terratec.c
+++ b/drivers/media/IR/keymaps/rc-em-terratec.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode em_terratec[] = {
 	{ 0x01, KEY_CHANNEL },
diff --git a/drivers/media/IR/keymaps/rc-empty.c b/drivers/media/IR/keymaps/rc-empty.c
index 3b338d8..6091b96 100644
--- a/drivers/media/IR/keymaps/rc-empty.c
+++ b/drivers/media/IR/keymaps/rc-empty.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* empty keytable, can be used as placeholder for not-yet created keytables */
 
diff --git a/drivers/media/IR/keymaps/rc-encore-enltv-fm53.c b/drivers/media/IR/keymaps/rc-encore-enltv-fm53.c
index 4b81696..c55dd20 100644
--- a/drivers/media/IR/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/IR/keymaps/rc-encore-enltv-fm53.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Encore ENLTV-FM v5.3
    Mauro Carvalho Chehab <mchehab@infradead.org>
diff --git a/drivers/media/IR/keymaps/rc-encore-enltv.c b/drivers/media/IR/keymaps/rc-encore-enltv.c
index 9fabffd..06049c3 100644
--- a/drivers/media/IR/keymaps/rc-encore-enltv.c
+++ b/drivers/media/IR/keymaps/rc-encore-enltv.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Encore ENLTV-FM  - black plastic, white front cover with white glowing buttons
     Juan Pablo Sormani <sorman@gmail.com> */
diff --git a/drivers/media/IR/keymaps/rc-encore-enltv2.c b/drivers/media/IR/keymaps/rc-encore-enltv2.c
index efefd51..3795eb8 100644
--- a/drivers/media/IR/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/IR/keymaps/rc-encore-enltv2.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Encore ENLTV2-FM  - silver plastic - "Wand Media" written at the botton
     Mauro Carvalho Chehab <mchehab@infradead.org> */
diff --git a/drivers/media/IR/keymaps/rc-evga-indtube.c b/drivers/media/IR/keymaps/rc-evga-indtube.c
index 3f3fb13..adf78e1 100644
--- a/drivers/media/IR/keymaps/rc-evga-indtube.c
+++ b/drivers/media/IR/keymaps/rc-evga-indtube.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* EVGA inDtube
    Devin Heitmueller <devin.heitmueller@gmail.com>
diff --git a/drivers/media/IR/keymaps/rc-eztv.c b/drivers/media/IR/keymaps/rc-eztv.c
index 660907a..c00078c 100644
--- a/drivers/media/IR/keymaps/rc-eztv.c
+++ b/drivers/media/IR/keymaps/rc-eztv.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Alfons Geser <a.geser@cox.net>
  * updates from Job D. R. Borges <jobdrb@ig.com.br> */
diff --git a/drivers/media/IR/keymaps/rc-flydvb.c b/drivers/media/IR/keymaps/rc-flydvb.c
index a173c81..c694b54 100644
--- a/drivers/media/IR/keymaps/rc-flydvb.c
+++ b/drivers/media/IR/keymaps/rc-flydvb.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode flydvb[] = {
 	{ 0x01, KEY_ZOOM },		/* Full Screen */
diff --git a/drivers/media/IR/keymaps/rc-flyvideo.c b/drivers/media/IR/keymaps/rc-flyvideo.c
index 9c73043..c59fbe4 100644
--- a/drivers/media/IR/keymaps/rc-flyvideo.c
+++ b/drivers/media/IR/keymaps/rc-flyvideo.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode flyvideo[] = {
 	{ 0x0f, KEY_0 },
diff --git a/drivers/media/IR/keymaps/rc-fusionhdtv-mce.c b/drivers/media/IR/keymaps/rc-fusionhdtv-mce.c
index cdb1038..e2e09a1 100644
--- a/drivers/media/IR/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/IR/keymaps/rc-fusionhdtv-mce.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* DViCO FUSION HDTV MCE remote */
 
diff --git a/drivers/media/IR/keymaps/rc-gadmei-rm008z.c b/drivers/media/IR/keymaps/rc-gadmei-rm008z.c
index c16c0d1..f77ab33 100644
--- a/drivers/media/IR/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/IR/keymaps/rc-gadmei-rm008z.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* GADMEI UTV330+ RM008Z remote
    Shine Liu <shinel@foxmail.com>
diff --git a/drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c
index 89f8e38..b36ede9 100644
--- a/drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
  * Remote control for the Genius TVGO A11MCE
diff --git a/drivers/media/IR/keymaps/rc-gotview7135.c b/drivers/media/IR/keymaps/rc-gotview7135.c
index 52f025b..3b6048b 100644
--- a/drivers/media/IR/keymaps/rc-gotview7135.c
+++ b/drivers/media/IR/keymaps/rc-gotview7135.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Mike Baikov <mike@baikov.com> */
 
diff --git a/drivers/media/IR/keymaps/rc-hauppauge-new.c b/drivers/media/IR/keymaps/rc-hauppauge-new.c
index c6f8cd7..7d6c146 100644
--- a/drivers/media/IR/keymaps/rc-hauppauge-new.c
+++ b/drivers/media/IR/keymaps/rc-hauppauge-new.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Hauppauge: the newer, gray remotes (seems there are multiple
  * slightly different versions), shipped with cx88+ivtv cards.
diff --git a/drivers/media/IR/keymaps/rc-imon-mce.c b/drivers/media/IR/keymaps/rc-imon-mce.c
index e49f350..4e014f3 100644
--- a/drivers/media/IR/keymaps/rc-imon-mce.c
+++ b/drivers/media/IR/keymaps/rc-imon-mce.c
@@ -9,7 +9,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* mce-mode imon mce remote key table */
 static struct ir_scancode imon_mce[] = {
diff --git a/drivers/media/IR/keymaps/rc-imon-pad.c b/drivers/media/IR/keymaps/rc-imon-pad.c
index bc4db72..68194ff 100644
--- a/drivers/media/IR/keymaps/rc-imon-pad.c
+++ b/drivers/media/IR/keymaps/rc-imon-pad.c
@@ -9,7 +9,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
  * standard imon remote key table, which isn't really entirely
diff --git a/drivers/media/IR/keymaps/rc-iodata-bctv7e.c b/drivers/media/IR/keymaps/rc-iodata-bctv7e.c
index ef66002..76ff936 100644
--- a/drivers/media/IR/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/IR/keymaps/rc-iodata-bctv7e.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* IO-DATA BCTV7E Remote */
 
diff --git a/drivers/media/IR/keymaps/rc-kaiomy.c b/drivers/media/IR/keymaps/rc-kaiomy.c
index 4c7883b..20bf013 100644
--- a/drivers/media/IR/keymaps/rc-kaiomy.c
+++ b/drivers/media/IR/keymaps/rc-kaiomy.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Kaiomy TVnPC U2
    Mauro Carvalho Chehab <mchehab@infradead.org>
diff --git a/drivers/media/IR/keymaps/rc-kworld-315u.c b/drivers/media/IR/keymaps/rc-kworld-315u.c
index 618c817..e140ea0 100644
--- a/drivers/media/IR/keymaps/rc-kworld-315u.c
+++ b/drivers/media/IR/keymaps/rc-kworld-315u.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Kworld 315U
  */
diff --git a/drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c
index 366732f..21ebbfd 100644
--- a/drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Kworld Plus TV Analog Lite PCI IR
    Mauro Carvalho Chehab <mchehab@infradead.org>
diff --git a/drivers/media/IR/keymaps/rc-manli.c b/drivers/media/IR/keymaps/rc-manli.c
index 1e9fbfa..d062775 100644
--- a/drivers/media/IR/keymaps/rc-manli.c
+++ b/drivers/media/IR/keymaps/rc-manli.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Michael Tokarev <mjt@tls.msk.ru>
    http://www.corpit.ru/mjt/beholdTV/remote_control.jpg
diff --git a/drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c
index eb8e42c..7173c5d 100644
--- a/drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
   Keycodes for remote on the MSI TV@nywhere Plus. The controller IC on the card
diff --git a/drivers/media/IR/keymaps/rc-msi-tvanywhere.c b/drivers/media/IR/keymaps/rc-msi-tvanywhere.c
index ef41185..6897c07 100644
--- a/drivers/media/IR/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/IR/keymaps/rc-msi-tvanywhere.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* MSI TV@nywhere MASTER remote */
 
diff --git a/drivers/media/IR/keymaps/rc-nebula.c b/drivers/media/IR/keymaps/rc-nebula.c
index ccc50eb..ec98473 100644
--- a/drivers/media/IR/keymaps/rc-nebula.c
+++ b/drivers/media/IR/keymaps/rc-nebula.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode nebula[] = {
 	{ 0x00, KEY_0 },
diff --git a/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c
index e1b54d2..2ebd496 100644
--- a/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Terratec Cinergy Hybrid T USB XS FM
    Mauro Carvalho Chehab <mchehab@redhat.com>
diff --git a/drivers/media/IR/keymaps/rc-norwood.c b/drivers/media/IR/keymaps/rc-norwood.c
index e5849a6..f3d379a 100644
--- a/drivers/media/IR/keymaps/rc-norwood.c
+++ b/drivers/media/IR/keymaps/rc-norwood.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Norwood Micro (non-Pro) TV Tuner
    By Peter Naulls <peter@chocky.org>
diff --git a/drivers/media/IR/keymaps/rc-npgtech.c b/drivers/media/IR/keymaps/rc-npgtech.c
index b9ece1e..ecf616c 100644
--- a/drivers/media/IR/keymaps/rc-npgtech.c
+++ b/drivers/media/IR/keymaps/rc-npgtech.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode npgtech[] = {
 	{ 0x1d, KEY_SWITCHVIDEOMODE },	/* switch inputs */
diff --git a/drivers/media/IR/keymaps/rc-pctv-sedna.c b/drivers/media/IR/keymaps/rc-pctv-sedna.c
index 4129bb4..13b7f9d 100644
--- a/drivers/media/IR/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/IR/keymaps/rc-pctv-sedna.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Mapping for the 28 key remote control as seen at
    http://www.sednacomputer.com/photo/cardbus-tv.jpg
diff --git a/drivers/media/IR/keymaps/rc-pinnacle-color.c b/drivers/media/IR/keymaps/rc-pinnacle-color.c
index 326e023..1f06180 100644
--- a/drivers/media/IR/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/IR/keymaps/rc-pinnacle-color.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode pinnacle_color[] = {
 	{ 0x59, KEY_MUTE },
diff --git a/drivers/media/IR/keymaps/rc-pinnacle-grey.c b/drivers/media/IR/keymaps/rc-pinnacle-grey.c
index 14cb772..d0f6d6c 100644
--- a/drivers/media/IR/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/IR/keymaps/rc-pinnacle-grey.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode pinnacle_grey[] = {
 	{ 0x3a, KEY_0 },
diff --git a/drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c
index 835bf4e..55b1ca1 100644
--- a/drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Pinnacle PCTV HD 800i mini remote */
 
diff --git a/drivers/media/IR/keymaps/rc-pixelview-mk12.c b/drivers/media/IR/keymaps/rc-pixelview-mk12.c
index 5a735d5..1417384 100644
--- a/drivers/media/IR/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/IR/keymaps/rc-pixelview-mk12.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
  * Keytable for MK-F12 IR remote provided together with Pixelview
diff --git a/drivers/media/IR/keymaps/rc-pixelview-new.c b/drivers/media/IR/keymaps/rc-pixelview-new.c
index 7bbbbf5..10b9ef7 100644
--- a/drivers/media/IR/keymaps/rc-pixelview-new.c
+++ b/drivers/media/IR/keymaps/rc-pixelview-new.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
    Mauro Carvalho Chehab <mchehab@infradead.org>
diff --git a/drivers/media/IR/keymaps/rc-pixelview.c b/drivers/media/IR/keymaps/rc-pixelview.c
index 82ff12e..7d50692 100644
--- a/drivers/media/IR/keymaps/rc-pixelview.c
+++ b/drivers/media/IR/keymaps/rc-pixelview.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode pixelview[] = {
 
diff --git a/drivers/media/IR/keymaps/rc-powercolor-real-angel.c b/drivers/media/IR/keymaps/rc-powercolor-real-angel.c
index 7cef819..e2379db 100644
--- a/drivers/media/IR/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/IR/keymaps/rc-powercolor-real-angel.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
  * Remote control for Powercolor Real Angel 330
diff --git a/drivers/media/IR/keymaps/rc-proteus-2309.c b/drivers/media/IR/keymaps/rc-proteus-2309.c
index 22e92d3..ef941e4 100644
--- a/drivers/media/IR/keymaps/rc-proteus-2309.c
+++ b/drivers/media/IR/keymaps/rc-proteus-2309.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Michal Majchrowicz <mmajchrowicz@gmail.com> */
 
diff --git a/drivers/media/IR/keymaps/rc-purpletv.c b/drivers/media/IR/keymaps/rc-purpletv.c
index 4e20fc2..fdae1cb 100644
--- a/drivers/media/IR/keymaps/rc-purpletv.c
+++ b/drivers/media/IR/keymaps/rc-purpletv.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode purpletv[] = {
 	{ 0x03, KEY_POWER },
diff --git a/drivers/media/IR/keymaps/rc-pv951.c b/drivers/media/IR/keymaps/rc-pv951.c
index 36679e7..45842c5 100644
--- a/drivers/media/IR/keymaps/rc-pv951.c
+++ b/drivers/media/IR/keymaps/rc-pv951.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Mark Phalan <phalanm@o2.ie> */
 
diff --git a/drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c
index cc6b8f5..2055e2e 100644
--- a/drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c
+++ b/drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /*
  * Hauppauge:the newer, gray remotes (seems there are multiple
diff --git a/drivers/media/IR/keymaps/rc-rc5-tv.c b/drivers/media/IR/keymaps/rc-rc5-tv.c
index 73cce2f..7ffbd25 100644
--- a/drivers/media/IR/keymaps/rc-rc5-tv.c
+++ b/drivers/media/IR/keymaps/rc-rc5-tv.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* generic RC5 keytable                                          */
 /* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
diff --git a/drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c
index ab1a6d2..51508c3 100644
--- a/drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Zogis Real Audio 220 - 32 keys IR */
 
diff --git a/drivers/media/IR/keymaps/rc-tbs-nec.c b/drivers/media/IR/keymaps/rc-tbs-nec.c
index 3309631..1c01270 100644
--- a/drivers/media/IR/keymaps/rc-tbs-nec.c
+++ b/drivers/media/IR/keymaps/rc-tbs-nec.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode tbs_nec[] = {
 	{ 0x04, KEY_POWER2},	/*power*/
diff --git a/drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c
index 5326a0b..1699c3f 100644
--- a/drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Terratec Cinergy Hybrid T USB XS
    Devin Heitmueller <dheitmueller@linuxtv.org>
diff --git a/drivers/media/IR/keymaps/rc-tevii-nec.c b/drivers/media/IR/keymaps/rc-tevii-nec.c
index e30d411..6edc662 100644
--- a/drivers/media/IR/keymaps/rc-tevii-nec.c
+++ b/drivers/media/IR/keymaps/rc-tevii-nec.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode tevii_nec[] = {
 	{ 0x0a, KEY_POWER2},
diff --git a/drivers/media/IR/keymaps/rc-tt-1500.c b/drivers/media/IR/keymaps/rc-tt-1500.c
index bc88de0..79b5d19 100644
--- a/drivers/media/IR/keymaps/rc-tt-1500.c
+++ b/drivers/media/IR/keymaps/rc-tt-1500.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* for the Technotrend 1500 bundled remotes (grey and black): */
 
diff --git a/drivers/media/IR/keymaps/rc-videomate-s350.c b/drivers/media/IR/keymaps/rc-videomate-s350.c
index 4df7fcd..9fe9f4e 100644
--- a/drivers/media/IR/keymaps/rc-videomate-s350.c
+++ b/drivers/media/IR/keymaps/rc-videomate-s350.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode videomate_s350[] = {
 	{ 0x00, KEY_TV},
diff --git a/drivers/media/IR/keymaps/rc-videomate-tv-pvr.c b/drivers/media/IR/keymaps/rc-videomate-tv-pvr.c
index 776b0a6..e80ef1c 100644
--- a/drivers/media/IR/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/IR/keymaps/rc-videomate-tv-pvr.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 static struct ir_scancode videomate_tv_pvr[] = {
 	{ 0x14, KEY_MUTE },
diff --git a/drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c
index 9d2d550..9bcb541 100644
--- a/drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Leadtek Winfast TV USB II Deluxe remote
    Magnus Alm <magnus.alm@gmail.com>
diff --git a/drivers/media/IR/keymaps/rc-winfast.c b/drivers/media/IR/keymaps/rc-winfast.c
index 0e90a3b..7a4a30b 100644
--- a/drivers/media/IR/keymaps/rc-winfast.c
+++ b/drivers/media/IR/keymaps/rc-winfast.c
@@ -10,7 +10,7 @@
  * (at your option) any later version.
  */
 
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 /* Table for Leadtek Winfast Remote Controls - used by both bttv and cx88 */
 
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index ad1303f..fc13aad 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -20,7 +20,7 @@
 #include <linux/kfifo.h>
 #include <linux/time.h>
 #include <linux/timer.h>
-#include <media/rc-map.h>
+#include <linux/input.h>
 
 extern int ir_core_debug;
 #define IR_dprintk(level, fmt, arg...)	if (ir_core_debug >= level) \
@@ -31,6 +31,14 @@ enum rc_driver_type {
 	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
 };
 
+#define IR_TYPE_UNKNOWN	0
+#define IR_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
+#define IR_TYPE_NEC	(1  << 1)
+#define IR_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
+#define IR_TYPE_JVC	(1  << 3)	/* JVC protocol */
+#define IR_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
+#define IR_TYPE_OTHER	(1u << 31)
+
 /**
  * struct ir_dev_props - Allow caller drivers to set special properties
  * @driver_type: specifies if the driver or hardware have already a decoder,
@@ -58,6 +66,27 @@ struct ir_dev_props {
 	void			(*close)(void *priv);
 };
 
+struct ir_scancode {
+	u32	scancode;
+	u32	keycode;
+};
+
+struct ir_scancode_table {
+	struct ir_scancode	*scan;
+	unsigned int		size;	/* Max number of entries */
+	unsigned int		len;	/* Used number of entries */
+	unsigned int		alloc;	/* Size of *scan in bytes */
+	u64			ir_type;
+	char			*name;
+	spinlock_t		lock;
+};
+
+struct rc_keymap {
+	struct list_head	 list;
+	struct ir_scancode_table map;
+};
+
+
 struct ir_input_dev {
 	struct device			dev;		/* device */
 	char				*driver_name;	/* Name of the driver module */
@@ -86,6 +115,12 @@ enum raw_event_type {
 
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
 
+/* From rc-map.c */
+int ir_register_map(struct rc_keymap *map);
+void ir_unregister_map(struct rc_keymap *map);
+struct ir_scancode_table *get_rc_map(const char *name);
+void rc_map_init(void);
+
 /* From ir-keytable.c */
 int __ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
@@ -145,4 +180,79 @@ static inline void ir_raw_event_reset(struct input_dev *input_dev)
 	ir_raw_event_handle(input_dev);
 }
 
+/* Names of the several keytables defined in-kernel */
+
+#define RC_MAP_ADSTECH_DVB_T_PCI         "rc-adstech-dvb-t-pci"
+#define RC_MAP_APAC_VIEWCOMP             "rc-apac-viewcomp"
+#define RC_MAP_ASUS_PC39                 "rc-asus-pc39"
+#define RC_MAP_ATI_TV_WONDER_HD_600      "rc-ati-tv-wonder-hd-600"
+#define RC_MAP_AVERMEDIA_A16D            "rc-avermedia-a16d"
+#define RC_MAP_AVERMEDIA_CARDBUS         "rc-avermedia-cardbus"
+#define RC_MAP_AVERMEDIA_DVBT            "rc-avermedia-dvbt"
+#define RC_MAP_AVERMEDIA_M135A_RM_JX     "rc-avermedia-m135a-rm-jx"
+#define RC_MAP_AVERMEDIA                 "rc-avermedia"
+#define RC_MAP_AVERTV_303                "rc-avertv-303"
+#define RC_MAP_BEHOLD_COLUMBUS           "rc-behold-columbus"
+#define RC_MAP_BEHOLD                    "rc-behold"
+#define RC_MAP_BUDGET_CI_OLD             "rc-budget-ci-old"
+#define RC_MAP_CINERGY_1400              "rc-cinergy-1400"
+#define RC_MAP_CINERGY                   "rc-cinergy"
+#define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
+#define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
+#define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
+#define RC_MAP_EMPTY                     "rc-empty"
+#define RC_MAP_EM_TERRATEC               "rc-em-terratec"
+#define RC_MAP_ENCORE_ENLTV2             "rc-encore-enltv2"
+#define RC_MAP_ENCORE_ENLTV_FM53         "rc-encore-enltv-fm53"
+#define RC_MAP_ENCORE_ENLTV              "rc-encore-enltv"
+#define RC_MAP_EVGA_INDTUBE              "rc-evga-indtube"
+#define RC_MAP_EZTV                      "rc-eztv"
+#define RC_MAP_FLYDVB                    "rc-flydvb"
+#define RC_MAP_FLYVIDEO                  "rc-flyvideo"
+#define RC_MAP_FUSIONHDTV_MCE            "rc-fusionhdtv-mce"
+#define RC_MAP_GADMEI_RM008Z             "rc-gadmei-rm008z"
+#define RC_MAP_GENIUS_TVGO_A11MCE        "rc-genius-tvgo-a11mce"
+#define RC_MAP_GOTVIEW7135               "rc-gotview7135"
+#define RC_MAP_HAUPPAUGE_NEW             "rc-hauppauge-new"
+#define RC_MAP_IMON_MCE                  "rc-imon-mce"
+#define RC_MAP_IMON_PAD                  "rc-imon-pad"
+#define RC_MAP_IODATA_BCTV7E             "rc-iodata-bctv7e"
+#define RC_MAP_KAIOMY                    "rc-kaiomy"
+#define RC_MAP_KWORLD_315U               "rc-kworld-315u"
+#define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
+#define RC_MAP_MANLI                     "rc-manli"
+#define RC_MAP_MSI_TVANYWHERE_PLUS       "rc-msi-tvanywhere-plus"
+#define RC_MAP_MSI_TVANYWHERE            "rc-msi-tvanywhere"
+#define RC_MAP_NEBULA                    "rc-nebula"
+#define RC_MAP_NEC_TERRATEC_CINERGY_XS   "rc-nec-terratec-cinergy-xs"
+#define RC_MAP_NORWOOD                   "rc-norwood"
+#define RC_MAP_NPGTECH                   "rc-npgtech"
+#define RC_MAP_PCTV_SEDNA                "rc-pctv-sedna"
+#define RC_MAP_PINNACLE_COLOR            "rc-pinnacle-color"
+#define RC_MAP_PINNACLE_GREY             "rc-pinnacle-grey"
+#define RC_MAP_PINNACLE_PCTV_HD          "rc-pinnacle-pctv-hd"
+#define RC_MAP_PIXELVIEW_NEW             "rc-pixelview-new"
+#define RC_MAP_PIXELVIEW                 "rc-pixelview"
+#define RC_MAP_PIXELVIEW_MK12            "rc-pixelview-mk12"
+#define RC_MAP_POWERCOLOR_REAL_ANGEL     "rc-powercolor-real-angel"
+#define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
+#define RC_MAP_PURPLETV                  "rc-purpletv"
+#define RC_MAP_PV951                     "rc-pv951"
+#define RC_MAP_RC5_HAUPPAUGE_NEW         "rc-rc5-hauppauge-new"
+#define RC_MAP_RC5_TV                    "rc-rc5-tv"
+#define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
+#define RC_MAP_TBS_NEC                   "rc-tbs-nec"
+#define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
+#define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
+#define RC_MAP_TT_1500                   "rc-tt-1500"
+#define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
+#define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
+#define RC_MAP_WINFAST                   "rc-winfast"
+#define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
+/*
+ * Please, do not just append newer Remote Controller names at the end.
+ * The names should be ordered in alphabetical order
+ */
+
 #endif /* _IR_CORE */
+
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
deleted file mode 100644
index 5833966..0000000
--- a/include/media/rc-map.h
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- * rc-map.h - define RC map names used by RC drivers
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/input.h>
-
-#define IR_TYPE_UNKNOWN	0
-#define IR_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
-#define IR_TYPE_NEC	(1  << 1)
-#define IR_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
-#define IR_TYPE_JVC	(1  << 3)	/* JVC protocol */
-#define IR_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
-#define IR_TYPE_OTHER	(1u << 31)
-
-struct ir_scancode {
-	u32	scancode;
-	u32	keycode;
-};
-
-struct ir_scancode_table {
-	struct ir_scancode	*scan;
-	unsigned int		size;	/* Max number of entries */
-	unsigned int		len;	/* Used number of entries */
-	unsigned int		alloc;	/* Size of *scan in bytes */
-	u64			ir_type;
-	char			*name;
-	spinlock_t		lock;
-};
-
-struct rc_keymap {
-	struct list_head	 list;
-	struct ir_scancode_table map;
-};
-
-/* Routines from rc-map.c */
-
-int ir_register_map(struct rc_keymap *map);
-void ir_unregister_map(struct rc_keymap *map);
-struct ir_scancode_table *get_rc_map(const char *name);
-void rc_map_init(void);
-
-/* Names of the several keytables defined in-kernel */
-
-#define RC_MAP_ADSTECH_DVB_T_PCI         "rc-adstech-dvb-t-pci"
-#define RC_MAP_APAC_VIEWCOMP             "rc-apac-viewcomp"
-#define RC_MAP_ASUS_PC39                 "rc-asus-pc39"
-#define RC_MAP_ATI_TV_WONDER_HD_600      "rc-ati-tv-wonder-hd-600"
-#define RC_MAP_AVERMEDIA_A16D            "rc-avermedia-a16d"
-#define RC_MAP_AVERMEDIA_CARDBUS         "rc-avermedia-cardbus"
-#define RC_MAP_AVERMEDIA_DVBT            "rc-avermedia-dvbt"
-#define RC_MAP_AVERMEDIA_M135A_RM_JX     "rc-avermedia-m135a-rm-jx"
-#define RC_MAP_AVERMEDIA                 "rc-avermedia"
-#define RC_MAP_AVERTV_303                "rc-avertv-303"
-#define RC_MAP_BEHOLD_COLUMBUS           "rc-behold-columbus"
-#define RC_MAP_BEHOLD                    "rc-behold"
-#define RC_MAP_BUDGET_CI_OLD             "rc-budget-ci-old"
-#define RC_MAP_CINERGY_1400              "rc-cinergy-1400"
-#define RC_MAP_CINERGY                   "rc-cinergy"
-#define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
-#define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
-#define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
-#define RC_MAP_EMPTY                     "rc-empty"
-#define RC_MAP_EM_TERRATEC               "rc-em-terratec"
-#define RC_MAP_ENCORE_ENLTV2             "rc-encore-enltv2"
-#define RC_MAP_ENCORE_ENLTV_FM53         "rc-encore-enltv-fm53"
-#define RC_MAP_ENCORE_ENLTV              "rc-encore-enltv"
-#define RC_MAP_EVGA_INDTUBE              "rc-evga-indtube"
-#define RC_MAP_EZTV                      "rc-eztv"
-#define RC_MAP_FLYDVB                    "rc-flydvb"
-#define RC_MAP_FLYVIDEO                  "rc-flyvideo"
-#define RC_MAP_FUSIONHDTV_MCE            "rc-fusionhdtv-mce"
-#define RC_MAP_GADMEI_RM008Z             "rc-gadmei-rm008z"
-#define RC_MAP_GENIUS_TVGO_A11MCE        "rc-genius-tvgo-a11mce"
-#define RC_MAP_GOTVIEW7135               "rc-gotview7135"
-#define RC_MAP_HAUPPAUGE_NEW             "rc-hauppauge-new"
-#define RC_MAP_IMON_MCE                  "rc-imon-mce"
-#define RC_MAP_IMON_PAD                  "rc-imon-pad"
-#define RC_MAP_IODATA_BCTV7E             "rc-iodata-bctv7e"
-#define RC_MAP_KAIOMY                    "rc-kaiomy"
-#define RC_MAP_KWORLD_315U               "rc-kworld-315u"
-#define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
-#define RC_MAP_MANLI                     "rc-manli"
-#define RC_MAP_MSI_TVANYWHERE_PLUS       "rc-msi-tvanywhere-plus"
-#define RC_MAP_MSI_TVANYWHERE            "rc-msi-tvanywhere"
-#define RC_MAP_NEBULA                    "rc-nebula"
-#define RC_MAP_NEC_TERRATEC_CINERGY_XS   "rc-nec-terratec-cinergy-xs"
-#define RC_MAP_NORWOOD                   "rc-norwood"
-#define RC_MAP_NPGTECH                   "rc-npgtech"
-#define RC_MAP_PCTV_SEDNA                "rc-pctv-sedna"
-#define RC_MAP_PINNACLE_COLOR            "rc-pinnacle-color"
-#define RC_MAP_PINNACLE_GREY             "rc-pinnacle-grey"
-#define RC_MAP_PINNACLE_PCTV_HD          "rc-pinnacle-pctv-hd"
-#define RC_MAP_PIXELVIEW_NEW             "rc-pixelview-new"
-#define RC_MAP_PIXELVIEW                 "rc-pixelview"
-#define RC_MAP_PIXELVIEW_MK12            "rc-pixelview-mk12"
-#define RC_MAP_POWERCOLOR_REAL_ANGEL     "rc-powercolor-real-angel"
-#define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
-#define RC_MAP_PURPLETV                  "rc-purpletv"
-#define RC_MAP_PV951                     "rc-pv951"
-#define RC_MAP_RC5_HAUPPAUGE_NEW         "rc-rc5-hauppauge-new"
-#define RC_MAP_RC5_TV                    "rc-rc5-tv"
-#define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
-#define RC_MAP_TBS_NEC                   "rc-tbs-nec"
-#define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
-#define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
-#define RC_MAP_TT_1500                   "rc-tt-1500"
-#define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
-#define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
-#define RC_MAP_WINFAST                   "rc-winfast"
-#define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
-/*
- * Please, do not just append newer Remote Controller names at the end.
- * The names should be ordered in alphabetical order
- */

