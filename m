Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbEMRRp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 13:17:45 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Heinrich Schuchardt <xypron.glpk@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mikhail Domrachev <mihail.domrychev@comexp.ru>
Subject: [PATCH 1/2] [media] saa7134: avoid complex macro warnings
Date: Wed, 13 May 2015 14:17:24 -0300
Message-Id: <45f38cb3b80311ade3c87000f7d7a8f6ebd60a43.1431537416.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The debug macros are not properly defined, as they generate warnings
like:

ERROR: Macros with complex values should be enclosed in parentheses
+#define core_dbg(fmt, arg...)    if (core_debug) \
+	printk(KERN_DEBUG pr_fmt("core: " fmt), ## arg)

Use do { } while (0) for those macros.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index e88e4ec8c0ee..02a08770507d 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -102,11 +102,15 @@ static unsigned int saa7134_devcount;
 int (*saa7134_dmasound_init)(struct saa7134_dev *dev);
 int (*saa7134_dmasound_exit)(struct saa7134_dev *dev);
 
-#define core_dbg(fmt, arg...)    if (core_debug) \
-	printk(KERN_DEBUG pr_fmt("core: " fmt), ## arg)
+#define core_dbg(fmt, arg...) do { \
+	if (core_debug) \
+		printk(KERN_DEBUG pr_fmt("core: " fmt), ## arg); \
+	} while (0)
 
-#define irq_dbg(level, fmt, arg...)    if (irq_debug > level) \
-	printk(KERN_DEBUG pr_fmt("irq: " fmt), ## arg)
+#define irq_dbg(level, fmt, arg...)  do {\
+	if (irq_debug > level) \
+		printk(KERN_DEBUG pr_fmt("irq: " fmt), ## arg); \
+	} while (0)
 
 void saa7134_track_gpio(struct saa7134_dev *dev, char *msg)
 {
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index d04fbdb49158..b90434b41efe 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -41,11 +41,15 @@ static unsigned int i2c_scan;
 module_param(i2c_scan, int, 0444);
 MODULE_PARM_DESC(i2c_scan,"scan i2c bus at insmod time");
 
-#define i2c_dbg(level, fmt, arg...)    if (i2c_debug == level) \
-	printk(KERN_DEBUG pr_fmt("i2c: " fmt), ## arg)
+#define i2c_dbg(level, fmt, arg...) do { \
+	if (i2c_debug == level) \
+		printk(KERN_DEBUG pr_fmt("i2c: " fmt), ## arg); \
+	} while (0)
 
-#define i2c_cont(level, fmt, arg...)    if (i2c_debug == level) \
-	pr_cont(fmt, ## arg)
+#define i2c_cont(level, fmt, arg...) do { \
+	if (i2c_debug == level) \
+		pr_cont(fmt, ## arg); \
+	} while (0)
 
 #define I2C_WAIT_DELAY  32
 #define I2C_WAIT_RETRY  16
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index c6036557b468..e92bcfe9bbcb 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -41,10 +41,14 @@ static int pinnacle_remote;
 module_param(pinnacle_remote, int, 0644);    /* Choose Pinnacle PCTV remote */
 MODULE_PARM_DESC(pinnacle_remote, "Specify Pinnacle PCTV remote: 0=coloured, 1=grey (defaults to 0)");
 
-#define input_dbg(fmt, arg...)	if (ir_debug) \
-	printk(KERN_DEBUG pr_fmt("input: " fmt), ## arg)
-#define ir_dbg(ir, fmt, arg...)    if (ir_debug) \
-	printk(KERN_DEBUG pr_fmt("ir %s: " fmt), ir->name, ## arg)
+#define input_dbg(fmt, arg...) do { \
+	if (ir_debug) \
+		printk(KERN_DEBUG pr_fmt("input: " fmt), ## arg); \
+	} while (0)
+#define ir_dbg(ir, fmt, arg...) do { \
+	if (ir_debug) \
+		printk(KERN_DEBUG pr_fmt("ir %s: " fmt), ir->name, ## arg); \
+	} while (0)
 
 /* Helper function for raw decoding at GPIO16 or GPIO18 */
 static int saa7134_raw_decode_irq(struct saa7134_dev *dev);
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 5d7c4afac8e6..07ca32f1b6d9 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -35,8 +35,10 @@ static unsigned int ts_debug;
 module_param(ts_debug, int, 0644);
 MODULE_PARM_DESC(ts_debug,"enable debug messages [ts]");
 
-#define ts_dbg(fmt, arg...)	if (ts_debug) \
-	printk(KERN_DEBUG pr_fmt("ts: " fmt), ## arg)
+#define ts_dbg(fmt, arg...) do { \
+	if (ts_debug) \
+		printk(KERN_DEBUG pr_fmt("ts: " fmt), ## arg); \
+	} while (0)
 
 /* ------------------------------------------------------------------ */
 static int buffer_activate(struct saa7134_dev *dev,
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index 6320b64d3528..1a960a1b07b5 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -49,8 +49,10 @@ static int audio_clock_tweak;
 module_param(audio_clock_tweak, int, 0644);
 MODULE_PARM_DESC(audio_clock_tweak, "Audio clock tick fine tuning for cards with audio crystal that's slightly off (range [-1024 .. 1024])");
 
-#define audio_dbg(level, fmt, arg...)    if (audio_debug >= level) \
-       printk(KERN_DEBUG pr_fmt("audio: " fmt), ## arg)
+#define audio_dbg(level, fmt, arg...) do { \
+	if (audio_debug >= level) \
+		printk(KERN_DEBUG pr_fmt("audio: " fmt), ## arg); \
+	} while (0)
 
 /* msecs */
 #define SCAN_INITIAL_DELAY     1000
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index face07bf420d..4d36586ad752 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -38,8 +38,10 @@ static unsigned int vbibufs = 4;
 module_param(vbibufs, int, 0444);
 MODULE_PARM_DESC(vbibufs,"number of vbi buffers, range 2-32");
 
-#define vbi_dbg(fmt, arg...)	if (vbi_debug) \
-	printk(KERN_DEBUG pr_fmt("vbi: " fmt), ## arg)
+#define vbi_dbg(fmt, arg...) do { \
+	if (vbi_debug) \
+		printk(KERN_DEBUG pr_fmt("vbi: " fmt), ## arg); \
+	} while (0)
 
 /* ------------------------------------------------------------------ */
 
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 525ae6837fb3..f874b0c9fe4a 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -52,8 +52,10 @@ module_param_string(secam, secam, sizeof(secam), 0644);
 MODULE_PARM_DESC(secam, "force SECAM variant, either DK,L or Lc");
 
 
-#define video_dbg(fmt, arg...)	if (video_debug & 0x04) \
-	printk(KERN_DEBUG pr_fmt("video: " fmt), ## arg)
+#define video_dbg(fmt, arg...) do { \
+	if (video_debug & 0x04) \
+		printk(KERN_DEBUG pr_fmt("video: " fmt), ## arg); \
+	} while (0)
 
 /* ------------------------------------------------------------------ */
 /* Defines for Video Output Port Register at address 0x191            */
-- 
2.1.0

