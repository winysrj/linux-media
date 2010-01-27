Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:53026 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0A0LCQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 06:02:16 -0500
Date: Wed, 27 Jan 2010 12:02:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Daro <ghost-rider@aster.pl>, Roman Kellner <muzungu@gmx.net>
Subject: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135 variants
Message-ID: <20100127120211.2d022375@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean Delvare <khali@linux-fr.org>
Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants

Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
Analog (card=146). However, by the time we find out, some
card-specific initialization is missed. In particular, the fact that
the IR is GPIO-based. Set it when we change the card type.

We also have to move the initialization of IR until after the card
number has been changed. I hope that this won't cause any problem.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Daro <ghost-rider@aster.pl>
Cc: Roman Kellner <muzungu@gmx.net>
---
This needs testing, both from ASUS TV-FM 7135 users, and from other
users of the saa7134 driver. I don't have any supported device so I
couldn't test this change.

 linux/drivers/media/video/saa7134/saa7134-cards.c |    1 +
 linux/drivers/media/video/saa7134/saa7134-core.c  |    2 +-
 linux/drivers/media/video/saa7134/saa7134-input.c |    2 +-
 linux/drivers/media/video/saa7134/saa7134.h       |    2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-25 21:25:58.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-27 10:22:35.000000000 +0100
@@ -7299,6 +7299,7 @@ int saa7134_board_init2(struct saa7134_d
 		       printk(KERN_INFO "%s: P7131 analog only, using "
 						       "entry of %s\n",
 		       dev->name, saa7134_boards[dev->board].name);
+			dev->has_remote = SAA7134_REMOTE_GPIO;
 	       }
 	       break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-core.c	2010-01-25 21:25:50.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-core.c	2010-01-27 10:39:55.000000000 +0100
@@ -735,7 +735,6 @@ static int saa7134_hwinit1(struct saa713
 	saa7134_vbi_init1(dev);
 	if (card_has_mpeg(dev))
 		saa7134_ts_init1(dev);
-	saa7134_input_init1(dev);
 
 	saa7134_hw_enable1(dev);
 
@@ -781,6 +780,7 @@ static int saa7134_hwinit2(struct saa713
 
 	dprintk("hwinit2\n");
 
+	saa7134_input_init2(dev);
 	saa7134_video_init2(dev);
 	saa7134_tvaudio_init2(dev);
 
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2010-01-25 21:25:50.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2010-01-27 10:33:23.000000000 +0100
@@ -506,7 +506,7 @@ void saa7134_ir_stop(struct saa7134_dev
 		del_timer_sync(&dev->remote->timer);
 }
 
-int saa7134_input_init1(struct saa7134_dev *dev)
+int saa7134_input_init2(struct saa7134_dev *dev)
 {
 	struct card_ir *ir;
 	struct input_dev *input_dev;
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134.h	2010-01-25 21:25:50.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h	2010-01-27 10:34:57.000000000 +0100
@@ -812,7 +812,7 @@ void saa7134_irq_oss_done(struct saa7134
 /* ----------------------------------------------------------- */
 /* saa7134-input.c                                             */
 
-int  saa7134_input_init1(struct saa7134_dev *dev);
+int  saa7134_input_init2(struct saa7134_dev *dev);
 void saa7134_input_fini(struct saa7134_dev *dev);
 void saa7134_input_irq(struct saa7134_dev *dev);
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)


-- 
Jean Delvare
