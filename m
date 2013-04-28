Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab3D1Pl1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:41:27 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFfRJU025130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:41:27 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] cx88: make core less verbose
Date: Sun, 28 Apr 2013 12:41:18 -0300
Message-Id: <1367163678-10877-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Along the time, several debug messages were added at cx88-cards.
While those are still useful to track some troubles with
tuners, they're too verbose:
[ 5768.281801] cx88[0]: Calling XC2028/3028 callback
[ 5768.287388] cx88[0]: Calling XC2028/3028 callback
[ 5768.292575] cx88[0]: Calling XC2028/3028 callback
[ 5768.299408] cx88[0]: Calling XC2028/3028 callback
[ 5768.306244] cx88[0]: Calling XC2028/3028 callback
...

and, most of the time, useless.

So, disable them, except if core_debug modprobe parameter
is used.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx88/cx88-cards.c | 29 ++++++++++++++++-------------
 drivers/media/pci/cx88/cx88-core.c  | 12 +++++++-----
 drivers/media/pci/cx88/cx88.h       |  2 ++
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 07b700a..a87a0e1 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -59,6 +59,11 @@ MODULE_PARM_DESC(disable_ir, "Disable IR support");
 #define err_printk(core, fmt, arg...) \
 	printk(KERN_ERR "%s: " fmt, core->name , ## arg)
 
+#define dprintk(level,fmt, arg...)	do {				\
+	if (cx88_core_debug >= level)					\
+		printk(KERN_DEBUG "%s: " fmt, core->name , ## arg);	\
+	} while(0)
+
 
 /* ------------------------------------------------------------------ */
 /* board config info                                                  */
@@ -3134,7 +3139,7 @@ static int cx88_xc2028_tuner_callback(struct cx88_core *core,
 	case XC2028_TUNER_RESET:
 		switch (INPUT(core->input).type) {
 		case CX88_RADIO:
-			info_printk(core, "setting GPIO to radio!\n");
+			dprintk(1, "setting GPIO to radio!\n");
 			cx_write(MO_GP0_IO, 0x4ff);
 			mdelay(250);
 			cx_write(MO_GP2_IO, 0xff);
@@ -3142,7 +3147,7 @@ static int cx88_xc2028_tuner_callback(struct cx88_core *core,
 			break;
 		case CX88_VMUX_DVB:	/* Digital TV*/
 		default:		/* Analog TV */
-			info_printk(core, "setting GPIO to TV!\n");
+			dprintk(1, "setting GPIO to TV!\n");
 			break;
 		}
 		cx_write(MO_GP1_IO, 0x101010);
@@ -3200,8 +3205,7 @@ static int cx88_xc5000_tuner_callback(struct cx88_core *core,
 			   not having any tuning at all. */
 			return 0;
 		} else {
-			err_printk(core, "xc5000: unknown tuner "
-				   "callback command.\n");
+			dprintk(1, "xc5000: unknown tuner callback command.\n");
 			return -EINVAL;
 		}
 		break;
@@ -3212,8 +3216,7 @@ static int cx88_xc5000_tuner_callback(struct cx88_core *core,
 			cx_set(MO_GP0_IO, 0x00000010);
 			return 0;
 		} else {
-			printk(KERN_ERR
-				"xc5000: unknown tuner callback command.\n");
+			dprintk(1, "xc5000: unknown tuner callback command.\n");
 			return -EINVAL;
 		}
 		break;
@@ -3243,13 +3246,13 @@ int cx88_tuner_callback(void *priv, int component, int command, int arg)
 
 	switch (core->board.tuner_type) {
 		case TUNER_XC2028:
-			info_printk(core, "Calling XC2028/3028 callback\n");
+			dprintk(1, "Calling XC2028/3028 callback\n");
 			return cx88_xc2028_tuner_callback(core, command, arg);
 		case TUNER_XC4000:
-			info_printk(core, "Calling XC4000 callback\n");
+			dprintk(1, "Calling XC4000 callback\n");
 			return cx88_xc4000_tuner_callback(core, command, arg);
 		case TUNER_XC5000:
-			info_printk(core, "Calling XC5000 callback\n");
+			dprintk(1, "Calling XC5000 callback\n");
 			return cx88_xc5000_tuner_callback(core, command, arg);
 	}
 	err_printk(core, "Error: Calling callback for tuner %d\n",
@@ -3590,8 +3593,8 @@ static void cx88_card_setup(struct cx88_core *core)
 		memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
-		info_printk(core, "Asking xc2028/3028 to load firmware %s\n",
-			    ctl.fname);
+		dprintk(1, "Asking xc2028/3028 to load firmware %s\n",
+			ctl.fname);
 		call_all(core, tuner, s_config, &xc2028_cfg);
 	}
 	call_all(core, core, s_power, 0);
@@ -3760,8 +3763,8 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	if (radio[core->nr] != UNSET)
 		core->board.radio_type = radio[core->nr];
 
-	info_printk(core, "TV tuner type %d, Radio tuner type %d\n",
-		    core->board.tuner_type, core->board.radio_type);
+	dprintk(1, "TV tuner type %d, Radio tuner type %d\n",
+		core->board.tuner_type, core->board.radio_type);
 
 	/* init hardware */
 	cx88_reset(core);
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 39f095c..c8f3dcc 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -48,9 +48,9 @@ MODULE_LICENSE("GPL");
 
 /* ------------------------------------------------------------------ */
 
-static unsigned int core_debug;
-module_param(core_debug,int,0644);
-MODULE_PARM_DESC(core_debug,"enable debug messages [core]");
+unsigned int cx88_core_debug;
+module_param_named(core_debug, cx88_core_debug, int, 0644);
+MODULE_PARM_DESC(core_debug, "enable debug messages [core]");
 
 static unsigned int nicam;
 module_param(nicam,int,0644);
@@ -60,8 +60,10 @@ static unsigned int nocomb;
 module_param(nocomb,int,0644);
 MODULE_PARM_DESC(nocomb,"disable comb filter");
 
-#define dprintk(level,fmt, arg...)	if (core_debug >= level)	\
-	printk(KERN_DEBUG "%s: " fmt, core->name , ## arg)
+#define dprintk(level,fmt, arg...)	do {				\
+	if (cx88_core_debug >= level)					\
+		printk(KERN_DEBUG "%s: " fmt, core->name , ## arg);	\
+	} while(0)
 
 static unsigned int cx88_devcount;
 static LIST_HEAD(cx88_devlist);
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 4e29c9d..51ce2c0 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -618,6 +618,8 @@ struct cx8802_dev {
 /* ----------------------------------------------------------- */
 /* cx88-core.c                                                 */
 
+extern unsigned int cx88_core_debug;
+
 extern void cx88_print_irqbits(const char *name, const char *tag, const char *strings[],
 			       int len, u32 bits, u32 mask);
 
-- 
1.8.1.4

