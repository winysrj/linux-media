Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:60007 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1CJP3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 10:29:40 -0500
Date: Thu, 10 Mar 2011 16:29:21 +0100 (CET)
From: Issa Gorissen <flop.m@usa.net>
To: linux-media@vger.kernel.org
cc: rjkm@metzlerbros.de
Subject: [PATCH] Ngene cam device name
Message-ID: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As the cxd20099 driver is in staging due to abuse of the sec0 device, this
patch renames it to cam0. The sec0 device is not in use and can be removed

Signed-off-by: Issa Gorissen <flop.m@usa.net>
---
 drivers/media/dvb/dvb-core/dvbdev.h  |    2 +-
 drivers/media/dvb/ngene/ngene-core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.h 
b/drivers/media/dvb/dvb-core/dvbdev.h
index fcc6ae9..dcac27d 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.h
+++ b/drivers/media/dvb/dvb-core/dvbdev.h
@@ -40,7 +40,7 @@
 
 #define DVB_DEVICE_VIDEO      0
 #define DVB_DEVICE_AUDIO      1
-#define DVB_DEVICE_SEC        2
+#define DVB_DEVICE_CAM        2
 #define DVB_DEVICE_FRONTEND   3
 #define DVB_DEVICE_DEMUX      4
 #define DVB_DEVICE_DVR        5
diff --git a/drivers/media/dvb/ngene/ngene-core.c 
b/drivers/media/dvb/ngene/ngene-core.c
index 175a0f6..6be2d7c 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -1523,7 +1523,7 @@ static int init_channel(struct ngene_channel *chan)
                set_transfer(&chan->dev->channel[2], 1);
                dvb_register_device(adapter, &chan->ci_dev,
                                    &ngene_dvbdev_ci, (void *) chan,
-                                   DVB_DEVICE_SEC);
+                                   DVB_DEVICE_CAM);
                if (!chan->ci_dev)
                        goto err;
        }
