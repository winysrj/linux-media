Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37922 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753042AbdLANrj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 08:47:39 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 5/7] media: rc keymaps: add SPDX identifiers to the code I wrote
Date: Fri,  1 Dec 2017 11:47:11 -0200
Message-Id: <9a50a60d1564aca065f4d4d7a4880ed2f0fc6e63.1512135871.git.mchehab@s-opensource.com>
In-Reply-To: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
In-Reply-To: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're now using SPDX identifiers, on the several
RC keymap files I wrote, add the proper SPDX, identifying
the license I meant.

As we're now using the short license, it doesn't make sense to
keep the original license text.

Also, fix MODULE_LICENSE to identify GPL v2, as this is the
minimal license requirement for those modles.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    | 17 +++++--------
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        | 17 +++++--------
 drivers/media/rc/keymaps/rc-asus-pc39.c            | 17 +++++--------
 drivers/media/rc/keymaps/rc-asus-ps3-100.c         | 17 +++++--------
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c | 17 +++++--------
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       | 17 +++++--------
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    | 17 +++++--------
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       | 17 +++++--------
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      | 15 ++++-------
 drivers/media/rc/keymaps/rc-avermedia.c            | 17 +++++--------
 drivers/media/rc/keymaps/rc-avertv-303.c           | 17 +++++--------
 drivers/media/rc/keymaps/rc-behold-columbus.c      | 17 +++++--------
 drivers/media/rc/keymaps/rc-behold.c               | 17 +++++--------
 drivers/media/rc/keymaps/rc-budget-ci-old.c        | 17 +++++--------
 drivers/media/rc/keymaps/rc-cinergy-1400.c         | 17 +++++--------
 drivers/media/rc/keymaps/rc-cinergy.c              | 17 +++++--------
 drivers/media/rc/keymaps/rc-dib0700-nec.c          | 27 ++++++++------------
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          | 27 ++++++++------------
 drivers/media/rc/keymaps/rc-dm1105-nec.c           | 17 +++++--------
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      | 17 +++++--------
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   | 17 +++++--------
 drivers/media/rc/keymaps/rc-em-terratec.c          | 17 +++++--------
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    | 17 +++++--------
 drivers/media/rc/keymaps/rc-encore-enltv.c         | 17 +++++--------
 drivers/media/rc/keymaps/rc-encore-enltv2.c        | 17 +++++--------
 drivers/media/rc/keymaps/rc-evga-indtube.c         | 17 +++++--------
 drivers/media/rc/keymaps/rc-eztv.c                 | 17 +++++--------
 drivers/media/rc/keymaps/rc-flydvb.c               | 17 +++++--------
 drivers/media/rc/keymaps/rc-flyvideo.c             | 17 +++++--------
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       | 17 +++++--------
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        | 17 +++++--------
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   | 17 +++++--------
 drivers/media/rc/keymaps/rc-gotview7135.c          | 17 +++++--------
 drivers/media/rc/keymaps/rc-hauppauge.c            | 29 +++++++++-------------
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        | 17 +++++--------
 drivers/media/rc/keymaps/rc-kaiomy.c               | 17 +++++--------
 drivers/media/rc/keymaps/rc-kworld-315u.c          | 17 +++++--------
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    | 17 +++++--------
 drivers/media/rc/keymaps/rc-manli.c                | 17 +++++--------
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  | 17 +++++--------
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       | 17 +++++--------
 drivers/media/rc/keymaps/rc-nebula.c               | 17 +++++--------
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  | 17 +++++--------
 drivers/media/rc/keymaps/rc-norwood.c              | 17 +++++--------
 drivers/media/rc/keymaps/rc-npgtech.c              | 17 +++++--------
 drivers/media/rc/keymaps/rc-pctv-sedna.c           | 17 +++++--------
 drivers/media/rc/keymaps/rc-pinnacle-color.c       | 17 +++++--------
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        | 17 +++++--------
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     | 17 +++++--------
 drivers/media/rc/keymaps/rc-pixelview-002t.c       | 17 +++++--------
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       | 17 +++++--------
 drivers/media/rc/keymaps/rc-pixelview-new.c        | 17 +++++--------
 drivers/media/rc/keymaps/rc-pixelview.c            | 17 +++++--------
 .../media/rc/keymaps/rc-powercolor-real-angel.c    | 17 +++++--------
 drivers/media/rc/keymaps/rc-proteus-2309.c         | 17 +++++--------
 drivers/media/rc/keymaps/rc-purpletv.c             | 17 +++++--------
 drivers/media/rc/keymaps/rc-pv951.c                | 17 +++++--------
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   | 17 +++++--------
 drivers/media/rc/keymaps/rc-tbs-nec.c              | 17 +++++--------
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  | 17 +++++--------
 drivers/media/rc/keymaps/rc-tevii-nec.c            | 17 +++++--------
 drivers/media/rc/keymaps/rc-tt-1500.c              | 17 +++++--------
 drivers/media/rc/keymaps/rc-videomate-s350.c       | 17 +++++--------
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     | 17 +++++--------
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c | 17 +++++--------
 drivers/media/rc/keymaps/rc-winfast.c              | 17 +++++--------
 66 files changed, 411 insertions(+), 741 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index 2d303c2cee3b..732687ce0637 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -1,14 +1,9 @@
-/* adstech-dvb-t-pci.h - Keytable for adstech_dvb_t_pci Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// adstech-dvb-t-pci.h - Keytable for adstech_dvb_t_pci Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
index 65bc8957d9c3..af2e7fdc7b85 100644
--- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -1,14 +1,9 @@
-/* apac-viewcomp.h - Keytable for apac_viewcomp Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// apac-viewcomp.h - Keytable for apac_viewcomp Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
index 530e1d1158d1..13a935c3ac59 100644
--- a/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -1,14 +1,9 @@
-/* asus-pc39.h - Keytable for asus_pc39 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// asus-pc39.h - Keytable for asus_pc39 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-asus-ps3-100.c b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
index c91ba332984c..7f836fcc68ac 100644
--- a/drivers/media/rc/keymaps/rc-asus-ps3-100.c
+++ b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
@@ -1,14 +1,9 @@
-/* asus-ps3-100.h - Keytable for asus_ps3_100 Remote Controller
- *
- * Copyright (c) 2012 by Mauro Carvalho Chehab
- *
- * Based on a previous patch from Remi Schwartz <remi.schwartz@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// asus-ps3-100.h - Keytable for asus_ps3_100 Remote Controller
+//
+// Copyright (c) 2012 by Mauro Carvalho Chehab
+//
+// Based on a previous patch from Remi Schwartz <remi.schwartz@gmail.com>
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
index 11b4bdd2392b..b4b7932c0c5a 100644
--- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -1,14 +1,9 @@
-/* ati-tv-wonder-hd-600.h - Keytable for ati_tv_wonder_hd_600 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// ati-tv-wonder-hd-600.h - Keytable for ati_tv_wonder_hd_600 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
index 510dc90ebf49..5549c043cfe4 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -1,14 +1,9 @@
-/* avermedia-a16d.h - Keytable for avermedia_a16d Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// avermedia-a16d.h - Keytable for avermedia_a16d Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
index 4bbc1e68d1b8..74edcd82e685 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -1,14 +1,9 @@
-/* avermedia-cardbus.h - Keytable for avermedia_cardbus Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// avermedia-cardbus.h - Keytable for avermedia_cardbus Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index f6b8547dbad3..796184160a48 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -1,14 +1,9 @@
-/* avermedia-dvbt.h - Keytable for avermedia_dvbt Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// avermedia-dvbt.h - Keytable for avermedia_dvbt Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 6d5a73b7ccec..f6977df1a75b 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -1,13 +1,8 @@
-/* avermedia-m135a.c - Keytable for Avermedia M135A Remote Controllers
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- * Copyright (c) 2010 by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// avermedia-m135a.c - Keytable for Avermedia M135A Remote Controllers
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
+// Copyright (c) 2010 by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
index 6503f11c7df5..631ff52564f0 100644
--- a/drivers/media/rc/keymaps/rc-avermedia.c
+++ b/drivers/media/rc/keymaps/rc-avermedia.c
@@ -1,14 +1,9 @@
-/* avermedia.h - Keytable for avermedia Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// avermedia.h - Keytable for avermedia Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
index fbdd7ada57ce..47ca8b7ea532 100644
--- a/drivers/media/rc/keymaps/rc-avertv-303.c
+++ b/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -1,14 +1,9 @@
-/* avertv-303.h - Keytable for avertv_303 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// avertv-303.h - Keytable for avertv_303 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index d256743be998..61f679fec45c 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -1,14 +1,9 @@
-/* behold-columbus.h - Keytable for behold_columbus Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// behold-columbus.h - Keytable for behold_columbus Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index 93dc795adc67..9b1b57e3c875 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -1,14 +1,9 @@
-/* behold.h - Keytable for behold Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// behold.h - Keytable for behold Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index 81ea1424d9e5..56f051af6154 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -1,14 +1,9 @@
-/* budget-ci-old.h - Keytable for budget_ci_old Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// budget-ci-old.h - Keytable for budget_ci_old Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
index bcb96b3dda85..dacb13c53bb4 100644
--- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -1,14 +1,9 @@
-/* cinergy-1400.h - Keytable for cinergy_1400 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// cinergy-1400.h - Keytable for cinergy_1400 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index fd56c402aae5..6ab2e51b764d 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -1,14 +1,9 @@
-/* cinergy.h - Keytable for cinergy Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// cinergy.h - Keytable for cinergy Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index 1b4df106b7b5..4ee801acb089 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -1,19 +1,14 @@
-/* rc-dvb0700-big.c - Keytable for devices in dvb0700
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * TODO: This table is a real mess, as it merges RC codes from several
- * devices into a big table. It also has both RC-5 and NEC codes inside.
- * It should be broken into small tables, and the protocols should properly
- * be identificated.
- *
- * The table were imported from dib0700_devices.c.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// rc-dvb0700-big.c - Keytable for devices in dvb0700
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
+//
+// TODO: This table is a real mess, as it merges RC codes from several
+// devices into a big table. It also has both RC-5 and NEC codes inside.
+// It should be broken into small tables, and the protocols should properly
+// be identificated.
+//
+// The table were imported from dib0700_devices.c.
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index b0f8151bb824..ef4085a0fda3 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -1,19 +1,14 @@
-/* rc-dvb0700-big.c - Keytable for devices in dvb0700
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * TODO: This table is a real mess, as it merges RC codes from several
- * devices into a big table. It also has both RC-5 and NEC codes inside.
- * It should be broken into small tables, and the protocols should properly
- * be identificated.
- *
- * The table were imported from dib0700_devices.c.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// rc-dvb0700-big.c - Keytable for devices in dvb0700
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
+//
+// TODO: This table is a real mess, as it merges RC codes from several
+// devices into a big table. It also has both RC-5 and NEC codes inside.
+// It should be broken into small tables, and the protocols should properly
+// be identificated.
+//
+// The table were imported from dib0700_devices.c.
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
index c353445d10ed..d853cd9a0936 100644
--- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
@@ -1,14 +1,9 @@
-/* dm1105-nec.h - Keytable for dm1105_nec Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// dm1105-nec.h - Keytable for dm1105_nec Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index 5bafd5b70f5e..cdc1d8c990cb 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -1,14 +1,9 @@
-/* dntv-live-dvb-t.h - Keytable for dntv_live_dvb_t Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// dntv-live-dvb-t.h - Keytable for dntv_live_dvb_t Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
index 360167c8829b..38e1d1b837da 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
@@ -1,14 +1,9 @@
-/* dntv-live-dvbt-pro.h - Keytable for dntv_live_dvbt_pro Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// dntv-live-dvbt-pro.h - Keytable for dntv_live_dvbt_pro Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
index 18e1a2679c20..cbbba21484fb 100644
--- a/drivers/media/rc/keymaps/rc-em-terratec.c
+++ b/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -1,14 +1,9 @@
-/* em-terratec.h - Keytable for em_terratec Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// em-terratec.h - Keytable for em_terratec Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index 72ffd5cb0108..e4e78c1f4123 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -1,14 +1,9 @@
-/* encore-enltv-fm53.h - Keytable for encore_enltv_fm53 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// encore-enltv-fm53.h - Keytable for encore_enltv_fm53 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index e0381e7aa964..5b4e832d5fac 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -1,14 +1,9 @@
-/* encore-enltv.h - Keytable for encore_enltv Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// encore-enltv.h - Keytable for encore_enltv Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index e9b0bfba319c..c3d4437a6fda 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -1,14 +1,9 @@
-/* encore-enltv2.h - Keytable for encore_enltv2 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// encore-enltv2.h - Keytable for encore_enltv2 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
index b77c5e908668..f4398444330b 100644
--- a/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -1,14 +1,9 @@
-/* evga-indtube.h - Keytable for evga_indtube Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// evga-indtube.h - Keytable for evga_indtube Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
index 5013b3b2aa93..0e481d51fcb5 100644
--- a/drivers/media/rc/keymaps/rc-eztv.c
+++ b/drivers/media/rc/keymaps/rc-eztv.c
@@ -1,14 +1,9 @@
-/* eztv.h - Keytable for eztv Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// eztv.h - Keytable for eztv Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index 418b32521273..45940d7c92d0 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -1,14 +1,9 @@
-/* flydvb.h - Keytable for flydvb Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// flydvb.h - Keytable for flydvb Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
index 93fb87ecf061..b2d4e4c7b192 100644
--- a/drivers/media/rc/keymaps/rc-flyvideo.c
+++ b/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -1,14 +1,9 @@
-/* flyvideo.h - Keytable for flyvideo Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// flyvideo.h - Keytable for flyvideo Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
index 9ed3f749262b..1c63fc7d4576 100644
--- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -1,14 +1,9 @@
-/* fusionhdtv-mce.h - Keytable for fusionhdtv_mce Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// fusionhdtv-mce.h - Keytable for fusionhdtv_mce Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
index 3443b721d092..4a0a9786914f 100644
--- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -1,14 +1,9 @@
-/* gadmei-rm008z.h - Keytable for gadmei_rm008z Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// gadmei-rm008z.h - Keytable for gadmei_rm008z Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
index d140e8d45bcc..cc876a85cc31 100644
--- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -1,14 +1,9 @@
-/* genius-tvgo-a11mce.h - Keytable for genius_tvgo_a11mce Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// genius-tvgo-a11mce.h - Keytable for genius_tvgo_a11mce Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
index 51230fbb52ba..6b94bd39d977 100644
--- a/drivers/media/rc/keymaps/rc-gotview7135.c
+++ b/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -1,14 +1,9 @@
-/* gotview7135.h - Keytable for gotview7135 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// gotview7135.h - Keytable for gotview7135 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
index 890164b68d64..582aa9012443 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge.c
@@ -1,20 +1,15 @@
-/* rc-hauppauge.c - Keytable for Hauppauge Remote Controllers
- *
- * keymap imported from ir-keymaps.c
- *
- * This map currently contains the code for four different RCs:
- *	- New Hauppauge Gray;
- *	- Old Hauppauge Gray (with a golden screen for media keys);
- *	- Hauppauge Black;
- *	- DSR-0112 remote bundled with Haupauge MiniStick.
- *
- * Copyright (c) 2010-2011 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// rc-hauppauge.c - Keytable for Hauppauge Remote Controllers
+//
+// keymap imported from ir-keymaps.c
+//
+// This map currently contains the code for four different RCs:
+//	- New Hauppauge Gray;
+//	- Old Hauppauge Gray (with a golden screen for media keys);
+//	- Hauppauge Black;
+//	- DSR-0112 remote bundled with Haupauge MiniStick.
+//
+// Copyright (c) 2010-2011 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
index 8cf87a15c4f2..6ced43458f2a 100644
--- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -1,14 +1,9 @@
-/* iodata-bctv7e.h - Keytable for iodata_bctv7e Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// iodata-bctv7e.h - Keytable for iodata_bctv7e Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index e791f1e1b43b..f0f88df18606 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -1,14 +1,9 @@
-/* kaiomy.h - Keytable for kaiomy Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// kaiomy.h - Keytable for kaiomy Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index 71dce0138f0e..ed0e0586dea2 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -1,14 +1,9 @@
-/* kworld-315u.h - Keytable for kworld_315u Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// kworld-315u.h - Keytable for kworld_315u Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index e0322ed16c94..453e04377de7 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -1,14 +1,9 @@
-/* kworld-plus-tv-analog.h - Keytable for kworld_plus_tv_analog Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// kworld-plus-tv-analog.h - Keytable for kworld_plus_tv_analog Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index da566902a4dd..29c9feaf413b 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -1,14 +1,9 @@
-/* manli.h - Keytable for manli Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// manli.h - Keytable for manli Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index dfa0ed1d7667..78cf2c286083 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -1,14 +1,9 @@
-/* msi-tvanywhere-plus.h - Keytable for msi_tvanywhere_plus Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// msi-tvanywhere-plus.h - Keytable for msi_tvanywhere_plus Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
index 2111816a3f59..359a57be3a66 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -1,14 +1,9 @@
-/* msi-tvanywhere.h - Keytable for msi_tvanywhere Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// msi-tvanywhere.h - Keytable for msi_tvanywhere Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index 109b6e1a8b1a..17d7c1b324da 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -1,14 +1,9 @@
-/* nebula.h - Keytable for nebula Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// nebula.h - Keytable for nebula Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index bb2d3a2962c0..76beef44a8d7 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -1,14 +1,9 @@
-/* nec-terratec-cinergy-xs.h - Keytable for nec_terratec_cinergy_xs Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// nec-terratec-cinergy-xs.h - Keytable for nec_terratec_cinergy_xs Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index cd25df336749..3765705c5549 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -1,14 +1,9 @@
-/* norwood.h - Keytable for norwood Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// norwood.h - Keytable for norwood Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
index 140bbc20a764..abaf7f6d4cb7 100644
--- a/drivers/media/rc/keymaps/rc-npgtech.c
+++ b/drivers/media/rc/keymaps/rc-npgtech.c
@@ -1,14 +1,9 @@
-/* npgtech.h - Keytable for npgtech Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// npgtech.h - Keytable for npgtech Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index 52b4558b7bd0..e3462c5c8984 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -1,14 +1,9 @@
-/* pctv-sedna.h - Keytable for pctv_sedna Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// pctv-sedna.h - Keytable for pctv_sedna Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
index 973c9c34e304..63c2851e9dfe 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -1,14 +1,9 @@
-/* pinnacle-color.h - Keytable for pinnacle_color Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// pinnacle-color.h - Keytable for pinnacle_color Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
index 22e44b0d2a93..31794d4180db 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -1,14 +1,9 @@
-/* pinnacle-grey.h - Keytable for pinnacle_grey Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// pinnacle-grey.h - Keytable for pinnacle_grey Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
index 186dcf8e0491..876aeb6e1d9c 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -1,14 +1,9 @@
-/* pinnacle-pctv-hd.h - Keytable for pinnacle_pctv_hd Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// pinnacle-pctv-hd.h - Keytable for pinnacle_pctv_hd Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
index b235ada2e28f..4ed85f61d0ee 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-002t.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -1,14 +1,9 @@
-/* rc-pixelview-mk12.h - Keytable for pixelview Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// rc-pixelview-mk12.h - Keytable for pixelview Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 453d52d663fe..6ded64b732a5 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -1,14 +1,9 @@
-/* rc-pixelview-mk12.h - Keytable for pixelview Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// rc-pixelview-mk12.h - Keytable for pixelview Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index ef97095ec8f1..791130f108ff 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -1,14 +1,9 @@
-/* pixelview-new.h - Keytable for pixelview_new Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// pixelview-new.h - Keytable for pixelview_new Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index cfd8f80d3617..988919735165 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -1,14 +1,9 @@
-/* pixelview.h - Keytable for pixelview Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// pixelview.h - Keytable for pixelview Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index b63f82bcf29a..4988e71c524c 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -1,14 +1,9 @@
-/* powercolor-real-angel.h - Keytable for powercolor_real_angel Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// powercolor-real-angel.h - Keytable for powercolor_real_angel Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
index be34c517e4e1..d2c13d0e7bff 100644
--- a/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -1,14 +1,9 @@
-/* proteus-2309.h - Keytable for proteus_2309 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// proteus-2309.h - Keytable for proteus_2309 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
index 84c40b97ee00..c8011f4d96ea 100644
--- a/drivers/media/rc/keymaps/rc-purpletv.c
+++ b/drivers/media/rc/keymaps/rc-purpletv.c
@@ -1,14 +1,9 @@
-/* purpletv.h - Keytable for purpletv Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// purpletv.h - Keytable for purpletv Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index be190ddebfc4..5235ee899c30 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -1,14 +1,9 @@
-/* pv951.h - Keytable for pv951 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// pv951.h - Keytable for pv951 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
index 957fa21747ea..1cf786649675 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -1,14 +1,9 @@
-/* real-audio-220-32-keys.h - Keytable for real_audio_220_32_keys Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// real-audio-220-32-keys.h - Keytable for real_audio_220_32_keys Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 05facc043272..42766cb877c3 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -1,14 +1,9 @@
-/* tbs-nec.h - Keytable for tbs_nec Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// tbs-nec.h - Keytable for tbs_nec Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
index 3d0f6f7e5bea..6cf53a56bce4 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -1,14 +1,9 @@
-/* terratec-cinergy-xs.h - Keytable for terratec_cinergy_xs Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// terratec-cinergy-xs.h - Keytable for terratec_cinergy_xs Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
index 31f8a0fd1f2c..58fcc72f528e 100644
--- a/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -1,14 +1,9 @@
-/* tevii-nec.h - Keytable for tevii_nec Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// tevii-nec.h - Keytable for tevii_nec Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index 374c230705d2..52f239d2c025 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -1,14 +1,9 @@
-/* tt-1500.h - Keytable for tt_1500 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// tt-1500.h - Keytable for tt_1500 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
index b4f103269872..e4d4dff06a24 100644
--- a/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -1,14 +1,9 @@
-/* videomate-s350.h - Keytable for videomate_s350 Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// videomate-s350.h - Keytable for videomate_s350 Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
index c431fdf44057..7c4890944407 100644
--- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -1,14 +1,9 @@
-/* videomate-tv-pvr.h - Keytable for videomate_tv_pvr Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// videomate-tv-pvr.h - Keytable for videomate_tv_pvr Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
index 5a437e61bd5d..30495673cddd 100644
--- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -1,14 +1,9 @@
-/* winfast-usbii-deluxe.h - Keytable for winfast_usbii_deluxe Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// winfast-usbii-deluxe.h - Keytable for winfast_usbii_deluxe Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index 53685d1f9a47..ee7f4c349fd6 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -1,14 +1,9 @@
-/* winfast.h - Keytable for winfast Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+// SPDX-License-Identifier: GPL-2.0+
+// winfast.h - Keytable for winfast Remote Controller
+//
+// keymap imported from ir-keymaps.c
+//
+// Copyright (c) 2010 by Mauro Carvalho Chehab
 
 #include <media/rc-map.h>
 #include <linux/module.h>
-- 
2.14.3
