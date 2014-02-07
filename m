Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33204 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaBGKgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 05:36:10 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media, edac] Change my email address
Date: Fri,  7 Feb 2014 08:06:07 -0200
Message-Id: <1391767567-2271-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several left overs with my old email address.
Remove their occurrences and add myself at CREDITS, to
allow people to be able to reach me on my new addresses.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 CREDITS                                               | 7 +++++++
 Documentation/edac.txt                                | 2 +-
 drivers/edac/edac_mc_sysfs.c                          | 2 +-
 drivers/edac/ghes_edac.c                              | 2 +-
 drivers/edac/i5400_edac.c                             | 4 ++--
 drivers/edac/i7300_edac.c                             | 4 ++--
 drivers/edac/i7core_edac.c                            | 4 ++--
 drivers/edac/sb_edac.c                                | 4 ++--
 drivers/media/common/siano/smsdvb-debugfs.c           | 2 +-
 drivers/media/dvb-frontends/mb86a20s.c                | 4 ++--
 drivers/media/dvb-frontends/mb86a20s.h                | 2 +-
 drivers/media/dvb-frontends/s921.c                    | 4 ++--
 drivers/media/dvb-frontends/s921.h                    | 2 +-
 drivers/media/i2c/mt9v011.c                           | 4 ++--
 drivers/media/i2c/sr030pc30.c                         | 2 +-
 drivers/media/rc/ir-nec-decoder.c                     | 4 ++--
 drivers/media/rc/ir-raw.c                             | 2 +-
 drivers/media/rc/ir-rc5-decoder.c                     | 4 ++--
 drivers/media/rc/ir-rc5-sz-decoder.c                  | 2 +-
 drivers/media/rc/ir-sanyo-decoder.c                   | 4 ++--
 drivers/media/rc/ir-sharp-decoder.c                   | 2 +-
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c       | 4 ++--
 drivers/media/rc/keymaps/rc-apac-viewcomp.c           | 4 ++--
 drivers/media/rc/keymaps/rc-asus-pc39.c               | 4 ++--
 drivers/media/rc/keymaps/rc-asus-ps3-100.c            | 4 ++--
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c    | 4 ++--
 drivers/media/rc/keymaps/rc-avermedia-a16d.c          | 4 ++--
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c       | 4 ++--
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c          | 4 ++--
 drivers/media/rc/keymaps/rc-avermedia-m135a.c         | 4 ++--
 drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c   | 2 +-
 drivers/media/rc/keymaps/rc-avermedia.c               | 4 ++--
 drivers/media/rc/keymaps/rc-avertv-303.c              | 4 ++--
 drivers/media/rc/keymaps/rc-behold-columbus.c         | 4 ++--
 drivers/media/rc/keymaps/rc-behold.c                  | 4 ++--
 drivers/media/rc/keymaps/rc-budget-ci-old.c           | 4 ++--
 drivers/media/rc/keymaps/rc-cinergy-1400.c            | 4 ++--
 drivers/media/rc/keymaps/rc-cinergy.c                 | 4 ++--
 drivers/media/rc/keymaps/rc-dib0700-nec.c             | 4 ++--
 drivers/media/rc/keymaps/rc-dib0700-rc5.c             | 4 ++--
 drivers/media/rc/keymaps/rc-dm1105-nec.c              | 4 ++--
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c         | 4 ++--
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c      | 4 ++--
 drivers/media/rc/keymaps/rc-em-terratec.c             | 4 ++--
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c       | 4 ++--
 drivers/media/rc/keymaps/rc-encore-enltv.c            | 4 ++--
 drivers/media/rc/keymaps/rc-encore-enltv2.c           | 4 ++--
 drivers/media/rc/keymaps/rc-evga-indtube.c            | 4 ++--
 drivers/media/rc/keymaps/rc-eztv.c                    | 4 ++--
 drivers/media/rc/keymaps/rc-flydvb.c                  | 4 ++--
 drivers/media/rc/keymaps/rc-flyvideo.c                | 4 ++--
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c          | 4 ++--
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c           | 4 ++--
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c      | 4 ++--
 drivers/media/rc/keymaps/rc-gotview7135.c             | 4 ++--
 drivers/media/rc/keymaps/rc-hauppauge.c               | 4 ++--
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c           | 4 ++--
 drivers/media/rc/keymaps/rc-kaiomy.c                  | 4 ++--
 drivers/media/rc/keymaps/rc-kworld-315u.c             | 4 ++--
 drivers/media/rc/keymaps/rc-kworld-pc150u.c           | 2 +-
 drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c   | 4 ++--
 drivers/media/rc/keymaps/rc-manli.c                   | 4 ++--
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c     | 4 ++--
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c          | 4 ++--
 drivers/media/rc/keymaps/rc-nebula.c                  | 4 ++--
 drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c | 6 +++---
 drivers/media/rc/keymaps/rc-norwood.c                 | 4 ++--
 drivers/media/rc/keymaps/rc-npgtech.c                 | 4 ++--
 drivers/media/rc/keymaps/rc-pctv-sedna.c              | 4 ++--
 drivers/media/rc/keymaps/rc-pinnacle-color.c          | 4 ++--
 drivers/media/rc/keymaps/rc-pinnacle-grey.c           | 4 ++--
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c        | 4 ++--
 drivers/media/rc/keymaps/rc-pixelview-002t.c          | 4 ++--
 drivers/media/rc/keymaps/rc-pixelview-mk12.c          | 4 ++--
 drivers/media/rc/keymaps/rc-pixelview-new.c           | 4 ++--
 drivers/media/rc/keymaps/rc-pixelview.c               | 4 ++--
 drivers/media/rc/keymaps/rc-powercolor-real-angel.c   | 4 ++--
 drivers/media/rc/keymaps/rc-proteus-2309.c            | 4 ++--
 drivers/media/rc/keymaps/rc-purpletv.c                | 4 ++--
 drivers/media/rc/keymaps/rc-pv951.c                   | 4 ++--
 drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c  | 4 ++--
 drivers/media/rc/keymaps/rc-tbs-nec.c                 | 4 ++--
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c     | 4 ++--
 drivers/media/rc/keymaps/rc-tevii-nec.c               | 4 ++--
 drivers/media/rc/keymaps/rc-tt-1500.c                 | 4 ++--
 drivers/media/rc/keymaps/rc-videomate-s350.c          | 4 ++--
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c        | 4 ++--
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c    | 4 ++--
 drivers/media/rc/keymaps/rc-winfast.c                 | 4 ++--
 drivers/media/rc/rc-core-priv.h                       | 2 +-
 drivers/media/rc/rc-main.c                            | 4 ++--
 drivers/media/tuners/mt2063.c                         | 4 ++--
 drivers/media/tuners/r820t.c                          | 4 ++--
 drivers/media/usb/cx231xx/cx231xx-input.c             | 2 +-
 drivers/media/usb/dvb-usb-v2/az6007.c                 | 4 ++--
 drivers/media/usb/em28xx/em28xx-audio.c               | 2 +-
 drivers/media/usb/em28xx/em28xx-input.c               | 2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c                | 4 ++--
 drivers/media/usb/tm6000/tm6000-dvb.c                 | 2 +-
 drivers/media/usb/tm6000/tm6000-stds.c                | 2 +-
 include/media/rc-core.h                               | 2 +-
 include/media/rc-map.h                                | 2 +-
 102 files changed, 190 insertions(+), 183 deletions(-)

diff --git a/CREDITS b/CREDITS
index e371c5504a50..9f21a011b3e3 100644
--- a/CREDITS
+++ b/CREDITS
@@ -630,6 +630,13 @@ N: Michael Elizabeth Chastain
 E: mec@shout.net
 D: Configure, Menuconfig, xconfig
 
+N: Mauro Carvalho Chehab
+E: m.chehab@samsung.org
+E: mchehab@infradead.org
+D: Media subsystem (V4L/DVB) drivers and core
+D: EDAC drivers and EDAC 3.0 core rework
+S: Brazil
+
 N: Raymond Chen
 E: raymondc@microsoft.com
 D: Author of Configure script
diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 56c7e936430f..cb4c2cefd45a 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -6,7 +6,7 @@ Written by Doug Thompson <dougthompson@xmission.com>
 7 Dec 2005
 17 Jul 2007	Updated
 
-(c) Mauro Carvalho Chehab <mchehab@redhat.com>
+(c) Mauro Carvalho Chehab
 05 Aug 2009	Nehalem interface
 
 EDAC is maintained and written by:
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 51c0362acf5c..3c0d67381a34 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -7,7 +7,7 @@
  *
  * Written Doug Thompson <norsk5@xmission.com> www.softwarebitmaker.com
  *
- * (c) 2012-2013 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * (c) 2012-2013 - Mauro Carvalho Chehab
  *	The entire API were re-written, and ported to use struct device
  *
  */
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index d5a98a45c062..8399b4e16fe0 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -4,7 +4,7 @@
  * This file may be distributed under the terms of the GNU General Public
  * License version 2.
  *
- * Copyright (c) 2013 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2013 by Mauro Carvalho Chehab
  *
  * Red Hat Inc. http://www.redhat.com
  */
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index e080cbfa8fc9..f189c333f406 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -6,7 +6,7 @@
  *
  * Copyright (c) 2008 by:
  *	 Ben Woodard <woodard@redhat.com>
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	 Mauro Carvalho Chehab
  *
  * Red Hat Inc. http://www.redhat.com
  *
@@ -1467,7 +1467,7 @@ module_exit(i5400_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ben Woodard <woodard@redhat.com>");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel I5400 memory controllers - "
 		   I5400_REVISION);
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index d63f4798f7d0..aea80a5e2bba 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -5,7 +5,7 @@
  * GNU General Public License version 2 only.
  *
  * Copyright (c) 2010 by:
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	 Mauro Carvalho Chehab
  *
  * Red Hat Inc. http://www.redhat.com
  *
@@ -1207,7 +1207,7 @@ module_init(i7300_init);
 module_exit(i7300_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel I7300 memory controllers - "
 		   I7300_REVISION);
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 87533ca7752e..40a228da4547 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -9,7 +9,7 @@
  * GNU General Public License version 2 only.
  *
  * Copyright (c) 2009-2010 by:
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	 Mauro Carvalho Chehab
  *
  * Red Hat Inc. http://www.redhat.com
  *
@@ -2456,7 +2456,7 @@ module_init(i7core_init);
 module_exit(i7core_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel i7 Core memory controllers - "
 		   I7CORE_REVISION);
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 54e2abe671f7..3fa13dbf2859 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -7,7 +7,7 @@
  * GNU General Public License version 2 only.
  *
  * Copyright (c) 2011 by:
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	 Mauro Carvalho Chehab
  */
 
 #include <linux/module.h>
@@ -2176,7 +2176,7 @@ module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel Sandy Bridge and Ivy Bridge memory controllers - "
 		   SBRIDGE_REVISION);
diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 0bb4430535f9..2408d7e9451e 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -1,6 +1,6 @@
 /***********************************************************************
  *
- * Copyright(c) 2013 Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright(c) 2013 Mauro Carvalho Chehab
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 2c7217fb1415..2f458bb188c7 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -1,7 +1,7 @@
 /*
  *   Fujitu mb86a20s ISDB-T/ISDB-Tsb Module driver
  *
- *   Copyright (C) 2010-2013 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2010-2013 Mauro Carvalho Chehab
  *   Copyright (C) 2009-2010 Douglas Landgraf <dougsland@redhat.com>
  *
  *   This program is free software; you can redistribute it and/or
@@ -2156,5 +2156,5 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 };
 
 MODULE_DESCRIPTION("DVB Frontend module for Fujitsu mb86A20s hardware");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
index 6627a3976087..cbeb941fba7c 100644
--- a/drivers/media/dvb-frontends/mb86a20s.h
+++ b/drivers/media/dvb-frontends/mb86a20s.h
@@ -1,7 +1,7 @@
 /*
  *   Fujitsu mb86a20s driver
  *
- *   Copyright (C) 2010 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2010 Mauro Carvalho Chehab
  *
  *   This program is free software; you can redistribute it and/or
  *   modify it under the terms of the GNU General Public License as
diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index a271ac3eaec0..69862e1fd9e9 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -2,7 +2,7 @@
  *   Sharp VA3A5JZ921 One Seg Broadcast Module driver
  *   This device is labeled as just S. 921 at the top of the frontend can
  *
- *   Copyright (C) 2009-2010 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2009-2010 Mauro Carvalho Chehab
  *   Copyright (C) 2009-2010 Douglas Landgraf <dougsland@redhat.com>
  *
  *   Developed for Leadership SBTVD 1seg device sold in Brazil
@@ -539,6 +539,6 @@ static struct dvb_frontend_ops s921_ops = {
 };
 
 MODULE_DESCRIPTION("DVB Frontend module for Sharp S921 hardware");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Douglas Landgraf <dougsland@redhat.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/s921.h b/drivers/media/dvb-frontends/s921.h
index 8d5e2a6e187c..9b20c9e0eb88 100644
--- a/drivers/media/dvb-frontends/s921.h
+++ b/drivers/media/dvb-frontends/s921.h
@@ -1,7 +1,7 @@
 /*
  *   Sharp s921 driver
  *
- *   Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2009 Mauro Carvalho Chehab
  *   Copyright (C) 2009 Douglas Landgraf <dougsland@redhat.com>
  *
  *   This program is free software; you can redistribute it and/or
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index f74698cf14c9..47e475319a24 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -1,7 +1,7 @@
 /*
  * mt9v011 -Micron 1/4-Inch VGA Digital Image Sensor
  *
- * Copyright (c) 2009 Mauro Carvalho Chehab (mchehab@redhat.com)
+ * Copyright (c) 2009 Mauro Carvalho Chehab
  * This code is placed under the terms of the GNU General Public License v2
  */
 
@@ -16,7 +16,7 @@
 #include <media/mt9v011.h>
 
 MODULE_DESCRIPTION("Micron mt9v011 sensor driver");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
 
 static int debug;
diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index ae9432637fcb..118f8ee88465 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -8,7 +8,7 @@
  * and HeungJun Kim <riverful.kim@samsung.com>.
  *
  * Based on mt9v011 Micron Digital Image Sensor driver
- * Copyright (c) 2009 Mauro Carvalho Chehab (mchehab@redhat.com)
+ * Copyright (c) 2009 Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 1bab7ea686fc..e687a4247052 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -1,6 +1,6 @@
 /* ir-nec-decoder.c - handle NEC IR Pulse/Space protocol
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -225,6 +225,6 @@ module_init(ir_nec_decode_init);
 module_exit(ir_nec_decode_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("NEC IR protocol decoder");
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 79a9cb653604..f0656fa1a01a 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -1,6 +1,6 @@
 /* ir-raw.c - handle IR pulse/space events
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 4e53a319c5d8..1085e173270a 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -1,6 +1,6 @@
 /* ir-rc5-decoder.c - handle RC5(x) IR Pulse/Space protocol
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -193,6 +193,6 @@ module_init(ir_rc5_decode_init);
 module_exit(ir_rc5_decode_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("RC5(x) IR protocol decoder");
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index 865fe84fd854..984e5b9f5bc3 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -1,6 +1,6 @@
 /* ir-rc5-sz-decoder.c - handle RC5 Streamzap IR Pulse/Space protocol
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab
  * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 0a06205b5677..e1351ed61629 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -1,6 +1,6 @@
 /* ir-sanyo-decoder.c - handle SANYO IR Pulse/Space protocol
  *
- * Copyright (C) 2011 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2011 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -200,6 +200,6 @@ module_init(ir_sanyo_decode_init);
 module_exit(ir_sanyo_decode_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("SANYO IR protocol decoder");
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index 4c17be5d68ba..4895bc752f97 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2013-2014 Imagination Technologies Ltd.
  *
  * Based on NEC decoder:
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index b0e42df7ff82..01d901fbfc8b 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -87,4 +87,4 @@ module_init(init_rc_map_adstech_dvb_t_pci)
 module_exit(exit_rc_map_adstech_dvb_t_pci)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
index 8c92ff95f94d..bf9efa007e1c 100644
--- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -78,4 +78,4 @@ module_init(init_rc_map_apac_viewcomp)
 module_exit(exit_rc_map_apac_viewcomp)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
index 2caf2117759b..9e674ba5dd4f 100644
--- a/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -89,4 +89,4 @@ module_init(init_rc_map_asus_pc39)
 module_exit(exit_rc_map_asus_pc39)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-asus-ps3-100.c b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
index ba76609c5936..e45de35f528f 100644
--- a/drivers/media/rc/keymaps/rc-asus-ps3-100.c
+++ b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
@@ -1,6 +1,6 @@
 /* asus-ps3-100.h - Keytable for asus_ps3_100 Remote Controller
  *
- * Copyright (c) 2012 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 by Mauro Carvalho Chehab
  *
  * Based on a previous patch from Remi Schwartz <remi.schwartz@gmail.com>
  *
@@ -88,4 +88,4 @@ module_init(init_rc_map_asus_ps3_100)
 module_exit(exit_rc_map_asus_ps3_100)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
index 2031224a2027..91392d4cfd6d 100644
--- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -67,4 +67,4 @@ module_init(init_rc_map_ati_tv_wonder_hd_600)
 module_exit(exit_rc_map_ati_tv_wonder_hd_600)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
index 894939ac17f2..ff30a71d623e 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -73,4 +73,4 @@ module_init(init_rc_map_avermedia_a16d)
 module_exit(exit_rc_map_avermedia_a16d)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
index d2aaf5b9e39f..d7471a6de9b4 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -95,4 +95,4 @@ module_init(init_rc_map_avermedia_cardbus)
 module_exit(exit_rc_map_avermedia_cardbus)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index dc2baf062398..e2417d6331fe 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_avermedia_dvbt)
 module_exit(exit_rc_map_avermedia_dvbt)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 04269d31fa19..843598a5f1b5 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -1,6 +1,6 @@
 /* avermedia-m135a.c - Keytable for Avermedia M135A Remote Controllers
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  * Copyright (c) 2010 by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -145,4 +145,4 @@ module_init(init_rc_map_avermedia_m135a)
 module_exit(exit_rc_map_avermedia_m135a)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
index e83b1a1939bf..b24e7481ac21 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -93,4 +93,4 @@ module_init(init_rc_map_avermedia_m733a_rm_k6)
 module_exit(exit_rc_map_avermedia_m733a_rm_k6)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
index c6063dfcd507..3f68fbecc188 100644
--- a/drivers/media/rc/keymaps/rc-avermedia.c
+++ b/drivers/media/rc/keymaps/rc-avermedia.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -84,4 +84,4 @@ module_init(init_rc_map_avermedia)
 module_exit(exit_rc_map_avermedia)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
index 14f78451e64e..c35bc5b835c4 100644
--- a/drivers/media/rc/keymaps/rc-avertv-303.c
+++ b/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -83,4 +83,4 @@ module_init(init_rc_map_avertv_303)
 module_exit(exit_rc_map_avertv_303)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index 086b4b1f19e1..1fc344e9daa7 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -106,4 +106,4 @@ module_init(init_rc_map_behold_columbus)
 module_exit(exit_rc_map_behold_columbus)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index 0877e3480941..d6519f8ac95a 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -139,4 +139,4 @@ module_init(init_rc_map_behold)
 module_exit(exit_rc_map_behold)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index 8311e092c098..b196a5f436a3 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -91,4 +91,4 @@ module_init(init_rc_map_budget_ci_old)
 module_exit(exit_rc_map_budget_ci_old)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
index 0c87fbaf99ab..a099c080bf8c 100644
--- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -82,4 +82,4 @@ module_init(init_rc_map_cinergy_1400)
 module_exit(exit_rc_map_cinergy_1400)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index 309e9e3fb6f3..b0f4328bdd6f 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_cinergy)
 module_exit(exit_rc_map_cinergy)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index 492a05ade7e1..a0fa543c9f9e 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -1,6 +1,6 @@
 /* rc-dvb0700-big.c - Keytable for devices in dvb0700
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * TODO: This table is a real mess, as it merges RC codes from several
  * devices into a big table. It also has both RC-5 and NEC codes inside.
@@ -122,4 +122,4 @@ module_init(init_rc_map)
 module_exit(exit_rc_map)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index 454ea596a7ee..907941145eb7 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -1,6 +1,6 @@
 /* rc-dvb0700-big.c - Keytable for devices in dvb0700
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * TODO: This table is a real mess, as it merges RC codes from several
  * devices into a big table. It also has both RC-5 and NEC codes inside.
@@ -233,4 +233,4 @@ module_init(init_rc_map)
 module_exit(exit_rc_map)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
index 67fc9fb0c007..46e7ae414cc8 100644
--- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -74,4 +74,4 @@ module_init(init_rc_map_dm1105_nec)
 module_exit(exit_rc_map_dm1105_nec)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index 91ea91de9179..d2826b46fea2 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_dntv_live_dvb_t)
 module_exit(exit_rc_map_dntv_live_dvb_t)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
index fd680d4d3eb6..0d74769467b5 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -95,4 +95,4 @@ module_init(init_rc_map_dntv_live_dvbt_pro)
 module_exit(exit_rc_map_dntv_live_dvbt_pro)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
index d1fcd64c0f90..7f1e06be175b 100644
--- a/drivers/media/rc/keymaps/rc-em-terratec.c
+++ b/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -67,4 +67,4 @@ module_init(init_rc_map_em_terratec)
 module_exit(exit_rc_map_em_terratec)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index 2fe45e41fe49..4fc3904daf06 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -79,4 +79,4 @@ module_init(init_rc_map_encore_enltv_fm53)
 module_exit(exit_rc_map_encore_enltv_fm53)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index 223de75a6d1c..f1914e23d203 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -110,4 +110,4 @@ module_init(init_rc_map_encore_enltv)
 module_exit(exit_rc_map_encore_enltv)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index 669cbff22b7e..9c6c55240d18 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -88,4 +88,4 @@ module_init(init_rc_map_encore_enltv2)
 module_exit(exit_rc_map_encore_enltv2)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
index 2c647fc25916..2370d2a3deb6 100644
--- a/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -59,4 +59,4 @@ module_init(init_rc_map_evga_indtube)
 module_exit(exit_rc_map_evga_indtube)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
index 76921445c1d9..b5c96ed84376 100644
--- a/drivers/media/rc/keymaps/rc-eztv.c
+++ b/drivers/media/rc/keymaps/rc-eztv.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -94,4 +94,4 @@ module_init(init_rc_map_eztv)
 module_exit(exit_rc_map_eztv)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index 3a6bba311b08..25cb89fac03c 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -75,4 +75,4 @@ module_init(init_rc_map_flydvb)
 module_exit(exit_rc_map_flydvb)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
index bf9da584643b..e71377dd0534 100644
--- a/drivers/media/rc/keymaps/rc-flyvideo.c
+++ b/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -68,4 +68,4 @@ module_init(init_rc_map_flyvideo)
 module_exit(exit_rc_map_flyvideo)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
index 2f0970fe7832..cf0608dc83d5 100644
--- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -96,4 +96,4 @@ module_init(init_rc_map_fusionhdtv_mce)
 module_exit(exit_rc_map_fusionhdtv_mce)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
index 0e98ec467c34..03575bdb2eca 100644
--- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -79,4 +79,4 @@ module_init(init_rc_map_gadmei_rm008z)
 module_exit(exit_rc_map_gadmei_rm008z)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
index a2e2faa1d1b3..b2ab13b0dcb1 100644
--- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -82,4 +82,4 @@ module_init(init_rc_map_genius_tvgo_a11mce)
 module_exit(exit_rc_map_genius_tvgo_a11mce)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
index 864614e19314..229a36ac7f0a 100644
--- a/drivers/media/rc/keymaps/rc-gotview7135.c
+++ b/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -77,4 +77,4 @@ module_init(init_rc_map_gotview7135)
 module_exit(exit_rc_map_gotview7135)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
index 929bbbc16393..36d57f7c532b 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge.c
@@ -8,7 +8,7 @@
  *	- Hauppauge Black;
  *	- DSR-0112 remote bundled with Haupauge MiniStick.
  *
- * Copyright (c) 2010-2011 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010-2011 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -290,4 +290,4 @@ module_init(init_rc_map_rc5_hauppauge_new)
 module_exit(exit_rc_map_rc5_hauppauge_new)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
index 34540dfc3df5..9ee154cb0c6b 100644
--- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -86,4 +86,4 @@ module_init(init_rc_map_iodata_bctv7e)
 module_exit(exit_rc_map_iodata_bctv7e)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index 4264a787c150..60803a732c08 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -85,4 +85,4 @@ module_init(init_rc_map_kaiomy)
 module_exit(exit_rc_map_kaiomy)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index e48cd267dda6..ba087eed1ed9 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -81,4 +81,4 @@ module_init(init_rc_map_kworld_315u)
 module_exit(exit_rc_map_kworld_315u)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-kworld-pc150u.c b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
index 233bb5ee087f..b92e571f4def 100644
--- a/drivers/media/rc/keymaps/rc-kworld-pc150u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
@@ -4,7 +4,7 @@
  *
  * Copyright (c) 2010 by Kyle Strickland
  *   (based on kworld-plus-tv-analog.c by
- *    Mauro Carvalho Chehab <mchehab@redhat.com>)
+ *    Mauro Carvalho Chehab)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index 32998d6b787d..edc868564f99 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -97,4 +97,4 @@ module_init(init_rc_map_kworld_plus_tv_analog)
 module_exit(exit_rc_map_kworld_plus_tv_analog)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index e7038bb71bf6..92424ef2aaa6 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -132,4 +132,4 @@ module_init(init_rc_map_manli)
 module_exit(exit_rc_map_manli)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index c393d8a50bca..fd7a55c56167 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -121,4 +121,4 @@ module_init(init_rc_map_msi_tvanywhere_plus)
 module_exit(exit_rc_map_msi_tvanywhere_plus)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
index a7003d3a3c8a..4233a8d4d63e 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -67,4 +67,4 @@ module_init(init_rc_map_msi_tvanywhere)
 module_exit(exit_rc_map_msi_tvanywhere)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index 3f0ddd7afd30..8ec881adb7cf 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -94,4 +94,4 @@ module_init(init_rc_map_nebula)
 module_exit(exit_rc_map_nebula)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index 8d4dae2e2ece..292bbad35d21 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -14,7 +14,7 @@
 #include <linux/module.h>
 
 /* Terratec Cinergy Hybrid T USB XS FM
-   Mauro Carvalho Chehab <mchehab@redhat.com>
+   Mauro Carvalho Chehab
  */
 
 static struct rc_map_table nec_terratec_cinergy_xs[] = {
@@ -155,4 +155,4 @@ module_init(init_rc_map_nec_terratec_cinergy_xs)
 module_exit(exit_rc_map_nec_terratec_cinergy_xs)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index 9e65f07157ab..ca1b82a2c54f 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -83,4 +83,4 @@ module_init(init_rc_map_norwood)
 module_exit(exit_rc_map_norwood)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
index 65d0cfc3c33b..1fb946024512 100644
--- a/drivers/media/rc/keymaps/rc-npgtech.c
+++ b/drivers/media/rc/keymaps/rc-npgtech.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -78,4 +78,4 @@ module_init(init_rc_map_npgtech)
 module_exit(exit_rc_map_npgtech)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index bf2cbdfe2e32..5ef01ab3fd50 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -78,4 +78,4 @@ module_init(init_rc_map_pctv_sedna)
 module_exit(exit_rc_map_pctv_sedna)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
index b46cd8fe6438..a218b471a4ca 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -92,4 +92,4 @@ module_init(init_rc_map_pinnacle_color)
 module_exit(exit_rc_map_pinnacle_color)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
index d525df9ad868..4a3f467a47a2 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -87,4 +87,4 @@ module_init(init_rc_map_pinnacle_grey)
 module_exit(exit_rc_map_pinnacle_grey)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
index a4603d035374..e89cc10b68bf 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -68,4 +68,4 @@ module_init(init_rc_map_pinnacle_pctv_hd)
 module_exit(exit_rc_map_pinnacle_pctv_hd)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
index 33eb64333c6f..d967c3816fdc 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-002t.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -75,4 +75,4 @@ module_init(init_rc_map_pixelview)
 module_exit(exit_rc_map_pixelview)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 21f4dd25c2ec..224d0efaa6e5 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -81,4 +81,4 @@ module_init(init_rc_map_pixelview)
 module_exit(exit_rc_map_pixelview)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index f944ad2cac2b..781d788d6b6d 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -81,4 +81,4 @@ module_init(init_rc_map_pixelview_new)
 module_exit(exit_rc_map_pixelview_new)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index a6020eea7b95..39e6feaa35a3 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -80,4 +80,4 @@ module_init(init_rc_map_pixelview)
 module_exit(exit_rc_map_pixelview)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index e74c571a5e44..e96fa3ab9f4b 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -79,4 +79,4 @@ module_init(init_rc_map_powercolor_real_angel)
 module_exit(exit_rc_map_powercolor_real_angel)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
index adee8035ce96..eef626ee02df 100644
--- a/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -67,4 +67,4 @@ module_init(init_rc_map_proteus_2309)
 module_exit(exit_rc_map_proteus_2309)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
index 722597a20e4a..cec6fe466829 100644
--- a/drivers/media/rc/keymaps/rc-purpletv.c
+++ b/drivers/media/rc/keymaps/rc-purpletv.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -79,4 +79,4 @@ module_init(init_rc_map_purpletv)
 module_exit(exit_rc_map_purpletv)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index 0105d63c07a9..5ac89ce8c053 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_pv951)
 module_exit(exit_rc_map_pv951)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
index 073694d50f49..9f778bd091db 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_real_audio_220_32_keys)
 module_exit(exit_rc_map_real_audio_220_32_keys)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 5039be782bc5..24ce2a252502 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -73,4 +73,4 @@ module_init(init_rc_map_tbs_nec)
 module_exit(exit_rc_map_tbs_nec)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
index 53629fb0151f..97eb83ab5a35 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -90,4 +90,4 @@ module_init(init_rc_map_terratec_cinergy_xs)
 module_exit(exit_rc_map_terratec_cinergy_xs)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
index f2c3b75d8580..38e0c0875596 100644
--- a/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -86,4 +86,4 @@ module_init(init_rc_map_tevii_nec)
 module_exit(exit_rc_map_tevii_nec)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index 80217ffc91db..c766d3b2b6b0 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -80,4 +80,4 @@ module_init(init_rc_map_tt_1500)
 module_exit(exit_rc_map_tt_1500)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
index 8bfc3e8d909d..8a354775a2d8 100644
--- a/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -83,4 +83,4 @@ module_init(init_rc_map_videomate_s350)
 module_exit(exit_rc_map_videomate_s350)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
index 390ce9431b35..eb0cda7766c4 100644
--- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -85,4 +85,4 @@ module_init(init_rc_map_videomate_tv_pvr)
 module_exit(exit_rc_map_videomate_tv_pvr)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
index 2852bf705064..c1dd598e828e 100644
--- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -80,4 +80,4 @@ module_init(init_rc_map_winfast_usbii_deluxe)
 module_exit(exit_rc_map_winfast_usbii_deluxe)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index 2df1cba23600..8a779da1e973 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -100,4 +100,4 @@ module_init(init_rc_map_winfast)
 module_exit(exit_rc_map_winfast)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index dc3b0b798035..da536c93c978 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -1,7 +1,7 @@
 /*
  * Remote Controller core raw events header
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index fa8b9575a84c..2ec60f8d2777 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1,6 +1,6 @@
 /* rc-main.c - Remote Controller core module
  *
- * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -1398,5 +1398,5 @@ int rc_core_debug;    /* ir_debug level (0,1,2) */
 EXPORT_SYMBOL_GPL(rc_core_debug);
 module_param_named(debug, rc_core_debug, int, 0644);
 
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 20cca405bf45..f640dcf4a81d 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -1,7 +1,7 @@
 /*
  * Driver for mt2063 Micronas tuner
  *
- * Copyright (c) 2011 Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2011 Mauro Carvalho Chehab
  *
  * This driver came from a driver originally written by:
  *		Henry Wang <Henry.wang@AzureWave.com>
@@ -2298,6 +2298,6 @@ static int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 }
 #endif
 
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_DESCRIPTION("MT2063 Silicon tuner");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index d9ee43fae62d..319adc4f0561 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1,7 +1,7 @@
 /*
  * Rafael Micro R820T driver
  *
- * Copyright (C) 2013 Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2013 Mauro Carvalho Chehab
  *
  * This driver was written from scratch, based on an existing driver
  * that it is part of rtl-sdr git tree, released under GPLv2:
@@ -2351,5 +2351,5 @@ err_no_gate:
 EXPORT_SYMBOL_GPL(r820t_attach);
 
 MODULE_DESCRIPTION("Rafael Micro r820t silicon tuner driver");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 0f7b42446826..46d52fac8680 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -1,7 +1,7 @@
 /*
  *   cx231xx IR glue driver
  *
- *   Copyright (C) 2010 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2010 Mauro Carvalho Chehab
  *
  *   Polaris (cx231xx) has its support for IR's with a design close to MCE.
  *   however, a few designs are using an external I2C chip for IR, instead
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index c1051c347744..c3c4b98733bf 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -7,7 +7,7 @@
  *	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
  * The original driver's license is GPL, as declared with MODULE_LICENSE()
  *
- * Copyright (c) 2010-2012 Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010-2012 Mauro Carvalho Chehab
  *	Driver modified by in order to work with upstream drxk driver, and
  *	tons of bugs got fixed, and converted to use dvb-usb-v2.
  *
@@ -975,7 +975,7 @@ static struct usb_driver az6007_usb_driver = {
 module_usb_driver(az6007_usb_driver);
 
 MODULE_AUTHOR("Henry Wang <Henry.wang@AzureWave.com>");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_DESCRIPTION("Driver for AzureWave 6007 DVB-C/T USB2.0 and clones");
 MODULE_VERSION("2.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index dfdfa772eb1e..566fa096eaf8 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -1008,7 +1008,7 @@ static void __exit em28xx_alsa_unregister(void)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Markus Rechberger <mrechberger@gmail.com>");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_DESCRIPTION(DRIVER_DESC " - audio interface");
 MODULE_VERSION(EM28XX_VERSION);
 
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 18f65d89d4bc..048e5b680499 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -845,7 +845,7 @@ static void __exit em28xx_rc_unregister(void)
 }
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_DESCRIPTION(DRIVER_DESC " - input interface");
 MODULE_VERSION(EM28XX_VERSION);
 
diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index 813c1ec53608..2c2a3818a8d9 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -1,7 +1,7 @@
 /*
  *
  *  Support for audio capture for tm5600/6000/6010
- *    (c) 2007-2008 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *    (c) 2007-2008 Mauro Carvalho Chehab
  *
  *  Based on cx88-alsa.c
  *
@@ -56,7 +56,7 @@ MODULE_PARM_DESC(index, "Index value for tm6000x capture interface(s).");
  ****************************************************************************/
 
 MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000/tm6010 based TV cards");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Trident,tm5600},"
 			"{{Trident,tm6000},"
diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 9fc1e940a82b..095f5db1a790 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -32,7 +32,7 @@
 #include "xc5000.h"
 
 MODULE_DESCRIPTION("DVB driver extension module for tm5600/6000/6010 based TV cards");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
 
 MODULE_SUPPORTED_DEVICE("{{Trident, tm5600},"
diff --git a/drivers/media/usb/tm6000/tm6000-stds.c b/drivers/media/usb/tm6000/tm6000-stds.c
index 5e28d6a2412f..93a4b2434b6e 100644
--- a/drivers/media/usb/tm6000/tm6000-stds.c
+++ b/drivers/media/usb/tm6000/tm6000-stds.c
@@ -1,7 +1,7 @@
 /*
  *  tm6000-stds.c - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
- *  Copyright (C) 2007 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *  Copyright (C) 2007 Mauro Carvalho Chehab
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 4a72176e04f6..5e7197e40c14 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -1,7 +1,7 @@
 /*
  * Remote Controller core header
  *
- * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index b3224edf1b46..e5aa2409c0ea 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -1,7 +1,7 @@
 /*
  * rc-map.h - define RC map names used by RC drivers
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.8.3.1

