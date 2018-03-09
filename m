Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38822 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeCIIay (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 03:30:54 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Colin Ian King <colin.king@canonical.com>,
        Peter Rosin <peda@axentia.se>,
        Romain Reignier <r.reignier@robopec.com>
Subject: [PATCH 1/2] media: cx231xx: get rid of videobuf-dvb dependency
Date: Fri,  9 Mar 2018 05:30:47 -0300
Message-Id: <dd7ed7485c5c2bdff0aa157579ed578e19e8f178.1520584203.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver doesn't use videobuf-dvb. So, stop adding an
unused struct and unused header on it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/Kconfig       | 1 -
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 6 +++++-
 drivers/media/usb/cx231xx/cx231xx.h     | 3 ---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 6276d9b2198b..7ba05a10b36d 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -42,7 +42,6 @@ config VIDEO_CX231XX_ALSA
 config VIDEO_CX231XX_DVB
 	tristate "DVB/ATSC Support for Cx231xx based TV cards"
 	depends on VIDEO_CX231XX && DVB_CORE
-	select VIDEOBUF_DVB
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index fb5654062b1a..a5d371f64e8b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -23,8 +23,12 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
+#include <media/dvbdev.h>
+#include <media/dmxdev.h>
+#include <media/dvb_demux.h>
+#include <media/dvb_net.h>
+#include <media/dvb_frontend.h>
 #include <media/v4l2-common.h>
-#include <media/videobuf-vmalloc.h>
 #include <media/tuner.h>
 
 #include "xc5000.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 65b039cf80be..dc391551de18 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -38,7 +38,6 @@
 #include <media/v4l2-fh.h>
 #include <media/rc-core.h>
 #include <media/i2c/ir-kbd-i2c.h>
-#include <media/videobuf-dvb.h>
 
 #include "cx231xx-reg.h"
 #include "cx231xx-pcb-cfg.h"
@@ -543,8 +542,6 @@ struct cx231xx_tsport {
 	int                        nr;
 	int                        sram_chno;
 
-	struct videobuf_dvb_frontends frontends;
-
 	/* dma queues */
 
 	u32                        ts_packet_size;
-- 
2.14.3
