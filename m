Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:50247 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbZIUSX5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 14:23:57 -0400
Date: Mon, 21 Sep 2009 20:23:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [origin tree build failure] [PATCH] media: video: Fix build in
	saa7164
Message-ID: <20090921182345.GA25100@elte.hu>
References: <20090919014930.7dd90f77@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919014930.7dd90f77@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> This series also contains several new drivers:
> 
>    - new driver for NXP saa7164;

-tip testing found that an allyesconfig build buglet found its way into 
this driver - find the fix below.

Thanks,

	Ingo

--------------------->
>From 67a0d8c7dfdf2de72ddec3d821ae87a80ecaed83 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 21 Sep 2009 20:14:47 +0200
Subject: [PATCH] media: video: Fix build in saa7164

-tip testing found that the x86 build (64-bit allyesconfig) fails due to:

  LD      vmlinux.o
  drivers/built-in.o:(.bss+0x4b648): multiple definition of `debug'
  arch/x86/built-in.o:(.kprobes.text+0x88): first defined here
  ld: Warning: size of symbol `debug' changed from 90 in arch/x86/built-in.o to 4 in drivers/built-in.o
 make: *** [vmlinux.o] Error 1

This is because recent saa7164 changes introduced a global symbol
named 'debug'. The x86 platform code already defines a 'debug'
symbol. (which is named in a too generic way as well - but it
can be used nicely to weed out too generic symbols in drivers ;-)

Rename it to saa_debug.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/saa7164/saa7164-api.c  |    8 ++++----
 drivers/media/video/saa7164/saa7164-cmd.c  |    2 +-
 drivers/media/video/saa7164/saa7164-core.c |    6 +++---
 drivers/media/video/saa7164/saa7164.h      |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-api.c b/drivers/media/video/saa7164/saa7164-api.c
index bb6df1b..6f094a9 100644
--- a/drivers/media/video/saa7164/saa7164-api.c
+++ b/drivers/media/video/saa7164/saa7164-api.c
@@ -415,7 +415,7 @@ int saa7164_api_enum_subdevs(struct saa7164_dev *dev)
 		goto out;
 	}
 
-	if (debug & DBGLVL_API)
+	if (saa_debug & DBGLVL_API)
 		saa7164_dumphex16(dev, buf, (buflen/16)*16);
 
 	saa7164_api_dump_subdevs(dev, buf, buflen);
@@ -480,7 +480,7 @@ int saa7164_api_i2c_read(struct saa7164_i2c *bus, u8 addr, u32 reglen, u8 *reg,
 
 	dprintk(DBGLVL_API, "%s() len = %d bytes\n", __func__, len);
 
-	if (debug & DBGLVL_I2C)
+	if (saa_debug & DBGLVL_I2C)
 		saa7164_dumphex16(dev, buf, 2 * 16);
 
 	ret = saa7164_cmd_send(bus->dev, unitid, GET_CUR,
@@ -488,7 +488,7 @@ int saa7164_api_i2c_read(struct saa7164_i2c *bus, u8 addr, u32 reglen, u8 *reg,
 	if (ret != SAA_OK)
 		printk(KERN_ERR "%s() error, ret(2) = 0x%x\n", __func__, ret);
 	else {
-		if (debug & DBGLVL_I2C)
+		if (saa_debug & DBGLVL_I2C)
 			saa7164_dumphex16(dev, buf, sizeof(buf));
 		memcpy(data, (buf + 2 * sizeof(u32) + reglen), datalen);
 	}
@@ -548,7 +548,7 @@ int saa7164_api_i2c_write(struct saa7164_i2c *bus, u8 addr, u32 datalen,
 	*((u32 *)(buf + 1 * sizeof(u32))) = datalen - reglen;
 	memcpy((buf + 2 * sizeof(u32)), data, datalen);
 
-	if (debug & DBGLVL_I2C)
+	if (saa_debug & DBGLVL_I2C)
 		saa7164_dumphex16(dev, buf, sizeof(buf));
 
 	ret = saa7164_cmd_send(bus->dev, unitid, SET_CUR,
diff --git a/drivers/media/video/saa7164/saa7164-cmd.c b/drivers/media/video/saa7164/saa7164-cmd.c
index e097f1a..c45966e 100644
--- a/drivers/media/video/saa7164/saa7164-cmd.c
+++ b/drivers/media/video/saa7164/saa7164-cmd.c
@@ -250,7 +250,7 @@ int saa7164_cmd_wait(struct saa7164_dev *dev, u8 seqno)
 	unsigned long stamp;
 	int r;
 
-	if (debug >= 4)
+	if (saa_debug >= 4)
 		saa7164_bus_dump(dev);
 
 	dprintk(DBGLVL_CMD, "%s(seqno=%d)\n", __func__, seqno);
diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/video/saa7164/saa7164-core.c
index f0dbead..60f3214 100644
--- a/drivers/media/video/saa7164/saa7164-core.c
+++ b/drivers/media/video/saa7164/saa7164-core.c
@@ -45,8 +45,8 @@ MODULE_LICENSE("GPL");
  32 bus
  */
 
-unsigned int debug;
-module_param(debug, int, 0644);
+unsigned int saa_debug;
+module_param(saa_debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
 
 unsigned int waitsecs = 10;
@@ -653,7 +653,7 @@ static int __devinit saa7164_initdev(struct pci_dev *pci_dev,
 		printk(KERN_ERR "%s() Unsupported board detected, "
 			"registering without firmware\n", __func__);
 
-	dprintk(1, "%s() parameter debug = %d\n", __func__, debug);
+	dprintk(1, "%s() parameter debug = %d\n", __func__, saa_debug);
 	dprintk(1, "%s() parameter waitsecs = %d\n", __func__, waitsecs);
 
 fail_fw:
diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
index 6753008..42660b5 100644
--- a/drivers/media/video/saa7164/saa7164.h
+++ b/drivers/media/video/saa7164/saa7164.h
@@ -375,9 +375,9 @@ extern int saa7164_buffer_dealloc(struct saa7164_tsport *port,
 
 /* ----------------------------------------------------------- */
 
-extern unsigned int debug;
+extern unsigned int saa_debug;
 #define dprintk(level, fmt, arg...)\
-	do { if (debug & level)\
+	do { if (saa_debug & level)\
 		printk(KERN_DEBUG "%s: " fmt, dev->name, ## arg);\
 	} while (0)
 
