Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:37581 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbZFVOcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 10:32:51 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: mt312: Fix checkpatch warnings
Date: Mon, 22 Jun 2009 16:32:47 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QY5PKpeQ96Qqouq"
Message-Id: <200906221632.48271.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_QY5PKpeQ96Qqouq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi list!

This patch fixes some checkpatch warnings in mt312-driver.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Regards
Matthias

--Boundary-00=_QY5PKpeQ96Qqouq
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="mt312-coding-style.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mt312-coding-style.diff"

Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
@@ -85,7 +85,7 @@ static int mt312_read(struct mt312_state
 		int i;
 		dprintk("R(%d):", reg & 0x7f);
 		for (i = 0; i < count; i++)
-			printk(" %02x", buf[i]);
+			printk(KERN_CONT " %02x", buf[i]);
 		printk("\n");
 	}
 
@@ -103,7 +103,7 @@ static int mt312_write(struct mt312_stat
 		int i;
 		dprintk("W(%d):", reg & 0x7f);
 		for (i = 0; i < count; i++)
-			printk(" %02x", src[i]);
+			printk(KERN_CONT " %02x", src[i]);
 		printk("\n");
 	}
 
@@ -744,7 +744,8 @@ static struct dvb_frontend_ops mt312_ops
 		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
-		.frequency_stepsize = (MT312_PLL_CLK / 1000) / 128, /* FIXME: adjust freq to real used xtal */
+		/* FIXME: adjust freq to real used xtal */
+		.frequency_stepsize = (MT312_PLL_CLK / 1000) / 128,
 		.symbol_rate_min = MT312_SYS_CLK / 128, /* FIXME as above */
 		.symbol_rate_max = MT312_SYS_CLK / 2,
 		.caps =
Index: v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/zl10036.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.c
@@ -29,7 +29,7 @@
 
 #include <linux/module.h>
 #include <linux/dvb/frontend.h>
-#include <asm/types.h>
+#include <linux/types.h>
 #include "compat.h"
 
 #include "zl10036.h"

--Boundary-00=_QY5PKpeQ96Qqouq--
