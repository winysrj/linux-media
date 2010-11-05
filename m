Return-path: <mchehab@gaivota>
Received: from zone0.gcu-squad.org ([212.85.147.21]:7656 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0KEUIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Nov 2010 16:08:00 -0400
Date: Fri, 5 Nov 2010 21:07:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Cc: Michael Hunold <michael@mihu.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/3] i2c: Drivers shouldn't include <linux/i2c-id.h>
Message-ID: <20101105210753.4d1a03bc@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Drivers don't need to include <linux/i2c-id.h>, especially not when
they don't use anything that header file provides.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Michael Hunold <michael@mihu.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/common/saa7146_i2c.c    |    1 -
 drivers/media/video/ir-kbd-i2c.c      |    1 -
 drivers/staging/olpc_dcon/olpc_dcon.c |    1 -
 3 files changed, 3 deletions(-)

--- linux-2.6.37-rc1.orig/drivers/media/common/saa7146_i2c.c	2010-11-02 09:19:35.000000000 +0100
+++ linux-2.6.37-rc1/drivers/media/common/saa7146_i2c.c	2010-11-05 15:34:25.000000000 +0100
@@ -391,7 +391,6 @@ static int saa7146_i2c_xfer(struct i2c_a
 
 /*****************************************************************************/
 /* i2c-adapter helper functions                                              */
-#include <linux/i2c-id.h>
 
 /* exported algorithm data */
 static struct i2c_algorithm saa7146_algo = {
--- linux-2.6.37-rc1.orig/drivers/media/video/ir-kbd-i2c.c	2010-11-02 09:19:35.000000000 +0100
+++ linux-2.6.37-rc1/drivers/media/video/ir-kbd-i2c.c	2010-11-05 15:34:18.000000000 +0100
@@ -44,7 +44,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/i2c-id.h>
 #include <linux/workqueue.h>
 
 #include <media/ir-core.h>
--- linux-2.6.37-rc1.orig/drivers/staging/olpc_dcon/olpc_dcon.c	2010-11-02 09:19:37.000000000 +0100
+++ linux-2.6.37-rc1/drivers/staging/olpc_dcon/olpc_dcon.c	2010-11-05 15:34:14.000000000 +0100
@@ -17,7 +17,6 @@
 #include <linux/console.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
-#include <linux/i2c-id.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/interrupt.h>


-- 
Jean Delvare
