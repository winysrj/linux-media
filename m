Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbD3OJB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:09:01 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Takashi Iwai <tiwai@suse.de>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Mikhail Domrachev <mihail.domrychev@comexp.ru>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Heinrich Schuchardt <xypron.glpk@gmx.de>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH 07/22] saa7134: prepare to use pr_foo macros
Date: Thu, 30 Apr 2015 11:08:27 -0300
Message-Id: <35f1e43640f04ad8e3018171e15fe735f512a8e5.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a pr_fmt macro, and move saa7134.h header to the beginning,
to avoid warnings when using the pr_foo macros.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index ac3cd74e824e..d5b0610a91fb 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -16,6 +16,9 @@
  *
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/time.h>
@@ -29,9 +32,6 @@
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
 
-#include "saa7134.h"
-#include "saa7134-reg.h"
-
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug,"enable debug messages [alsa]");
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index d48fd5338db5..20de0b12c818 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -20,13 +20,14 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
 #include "tuner-xc2028.h"
 #include <media/v4l2-common.h>
 #include <media/tveeprom.h>
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index a349e964e0bc..76e8ba98e4aa 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -20,6 +20,9 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -33,9 +36,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/pm.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
-
 MODULE_DESCRIPTION("v4l2 driver module for saa7130/34 based TV cards");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index bcfebd56fa2b..e1fe006c8ff9 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -20,6 +20,9 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -28,8 +31,6 @@
 #include <linux/kthread.h>
 #include <linux/suspend.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
 #include <media/v4l2-common.h>
 #include "dvb-pll.h"
 #include <dvb_frontend.h>
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 594dc3ad4750..d421c279a01a 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -17,6 +17,9 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -26,9 +29,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
-
 /* ------------------------------------------------------------------ */
 
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
index 54e650b4dff1..da7c4be4bed2 100644
--- a/drivers/media/pci/saa7134/saa7134-go7007.c
+++ b/drivers/media/pci/saa7134/saa7134-go7007.c
@@ -11,6 +11,9 @@
  * GNU General Public License for more details.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -27,8 +30,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
-#include "saa7134.h"
-#include "saa7134-reg.h"
 #include "go7007-priv.h"
 
 /*#define GO7007_HPI_DEBUG*/
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index f4da674e7f26..b69c47546d29 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -20,14 +20,15 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
 #include <media/v4l2-common.h>
 
 /* ----------------------------------------------------------- */
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index dc3d6516edf7..9406d5d7cdde 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -18,15 +18,15 @@
  *
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
-
 #define MODULE_NAME "saa7134"
 
 static unsigned int disable_ir;
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 2709b83d57b1..8a2938c34d32 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -20,15 +20,15 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
-
 /* ------------------------------------------------------------------ */
 
 static unsigned int ts_debug;
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index 3afbcb70b518..d020dff04bfe 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -20,6 +20,9 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -29,9 +32,6 @@
 #include <linux/freezer.h>
 #include <asm/div64.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
-
 /* ------------------------------------------------------------------ */
 
 static unsigned int audio_debug;
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 5306e549e526..109c2ffeab93 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -20,14 +20,14 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
-
 /* ------------------------------------------------------------------ */
 
 static unsigned int vbi_debug;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 99d09a7566d3..5cef84a84863 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -20,6 +20,9 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "saa7134.h"
+#include "saa7134-reg.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -31,9 +34,6 @@
 #include <media/v4l2-event.h>
 #include <media/saa6588.h>
 
-#include "saa7134-reg.h"
-#include "saa7134.h"
-
 /* ------------------------------------------------------------------ */
 
 unsigned int video_debug;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 8bf0553b8d2f..6fec01711680 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -21,6 +21,8 @@
 
 #define SAA7134_VERSION "0, 2, 17"
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
-- 
2.1.0

