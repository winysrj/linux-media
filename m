Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59549 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938739AbcKXLBc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 06:01:32 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/3] [media] ivtv: prepare to convert to pr_foo()
Date: Thu, 24 Nov 2016 09:01:20 -0200
Message-Id: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the pr_fmt() macro to ivtv_driver.h and ensure that it
will be the first file to be included on all ivtv files.

While here, put the includes inside ivtv-driver.h on
alphabetic order.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ivtv/ivtv-alsa-main.c  | 15 +++---------
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c | 13 ++++------
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c   | 15 +++++-------
 drivers/media/pci/ivtv/ivtv-driver.h     | 41 +++++++++++++++++---------------
 drivers/media/pci/ivtv/ivtv-mailbox.c    |  4 ++--
 drivers/media/pci/ivtv/ivtvfb.c          | 19 ++++++---------
 6 files changed, 44 insertions(+), 63 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index 374f45f81ab3..67ab73ef2bca 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -22,24 +22,15 @@
  *  02111-1307  USA
  */
 
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/spinlock.h>
-
-#include <media/v4l2-device.h>
-
-#include <sound/core.h>
-#include <sound/initval.h>
-
 #include "ivtv-driver.h"
 #include "ivtv-version.h"
 #include "ivtv-alsa.h"
 #include "ivtv-alsa-mixer.h"
 #include "ivtv-alsa-pcm.h"
 
+#include <sound/core.h>
+#include <sound/initval.h>
+
 int ivtv_alsa_debug;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-mixer.c b/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
index 79b24bde4a39..a5a92c856d8c 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-mixer.c
@@ -20,21 +20,16 @@
  *  02111-1307  USA
  */
 
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/spinlock.h>
+#include "ivtv-alsa.h"
+#include "ivtv-alsa-mixer.h"
+#include "ivtv-driver.h"
+
 #include <linux/videodev2.h>
 
-#include <media/v4l2-device.h>
-
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/tlv.h>
 
-#include "ivtv-alsa.h"
-#include "ivtv-driver.h"
-
 /*
  * Note the cx25840-core volume scale is funny, due to the alignment of the
  * scale with another chip's range:
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index a26f9800eca3..912a85f64e0e 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -23,15 +23,6 @@
  *  02111-1307  USA
  */
 
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/vmalloc.h>
-
-#include <media/v4l2-device.h>
-
-#include <sound/core.h>
-#include <sound/pcm.h>
-
 #include "ivtv-driver.h"
 #include "ivtv-queue.h"
 #include "ivtv-streams.h"
@@ -39,6 +30,12 @@
 #include "ivtv-alsa.h"
 #include "ivtv-alsa-pcm.h"
 
+#include <linux/vmalloc.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+
+
 static unsigned int pcm_debug;
 module_param(pcm_debug, int, 0644);
 MODULE_PARM_DESC(pcm_debug, "enable debug messages for pcm");
diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index 10cba305dbd2..b2b0fa27b1a7 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -22,6 +22,8 @@
 #ifndef IVTV_DRIVER_H
 #define IVTV_DRIVER_H
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* Internal header for ivtv project:
  * Driver for the cx23415/6 chip.
  * Author: Kevin Thayer (nufan_wfk at yahoo.com)
@@ -36,38 +38,39 @@
  *                using information provided by Jiun-Kuei Jung @ AVerMedia.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
+#include <asm/byteorder.h>
+#include <asm/uaccess.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
+#include <linux/device.h>
+#include <linux/dvb/audio.h>
+#include <linux/dvb/video.h>
 #include <linux/fs.h>
-#include <linux/pci.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ivtv.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/list.h>
-#include <linux/unistd.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/pagemap.h>
+#include <linux/pci.h>
 #include <linux/scatterlist.h>
-#include <linux/kthread.h>
-#include <linux/mutex.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
-#include <asm/byteorder.h>
+#include <linux/spinlock.h>
+#include <linux/unistd.h>
 
-#include <linux/dvb/video.h>
-#include <linux/dvb/audio.h>
+#include <media/drv-intf/cx2341x.h>
+#include <media/i2c/ir-kbd-i2c.h>
+#include <media/tuner.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
-#include <media/tuner.h>
-#include <media/drv-intf/cx2341x.h>
-#include <media/i2c/ir-kbd-i2c.h>
-
-#include <linux/ivtv.h>
+#include <media/v4l2-ioctl.h>
 
 /* Memory layout */
 #define IVTV_ENCODER_OFFSET	0x00000000
diff --git a/drivers/media/pci/ivtv/ivtv-mailbox.c b/drivers/media/pci/ivtv/ivtv-mailbox.c
index e3ce96763785..9a2506a5edbe 100644
--- a/drivers/media/pci/ivtv/ivtv-mailbox.c
+++ b/drivers/media/pci/ivtv/ivtv-mailbox.c
@@ -19,11 +19,11 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <stdarg.h>
-
 #include "ivtv-driver.h"
 #include "ivtv-mailbox.h"
 
+#include <stdarg.h>
+
 /* Firmware mailbox flags*/
 #define IVTV_MBOX_FIRMWARE_DONE 0x00000004
 #define IVTV_MBOX_DRIVER_DONE   0x00000002
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 612a8402cf4d..b59b60d605eb 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -38,18 +38,6 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/fb.h>
-#include <linux/ivtvfb.h>
-#include <linux/slab.h>
-
-#ifdef CONFIG_X86_64
-#include <asm/pat.h>
-#endif
-
 #include "ivtv-driver.h"
 #include "ivtv-cards.h"
 #include "ivtv-i2c.h"
@@ -57,6 +45,13 @@
 #include "ivtv-mailbox.h"
 #include "ivtv-firmware.h"
 
+#include <linux/fb.h>
+#include <linux/ivtvfb.h>
+
+#ifdef CONFIG_X86_64
+#include <asm/pat.h>
+#endif
+
 /* card parameters */
 static int ivtvfb_card_id = -1;
 static int ivtvfb_debug = 0;
-- 
2.9.3

