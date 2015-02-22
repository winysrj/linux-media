Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48109 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/10] [media] siano: use pr_* print functions
Date: Sun, 22 Feb 2015 13:11:33 -0300
Message-Id: <1424621501-17466-3-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of defining its own set of printk functions, let's
use the common Kernel debug logic provided by pr_foo functions.

As a first step, let's just define the existing macros as the
Kernel ones.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/sms-cards.h   |  3 ++-
 drivers/media/common/siano/smscoreapi.c  |  3 ++-
 drivers/media/common/siano/smscoreapi.h  | 27 ++++++++++++---------------
 drivers/media/common/siano/smsdvb-main.c |  3 ++-
 drivers/media/common/siano/smsir.c       |  3 ++-
 drivers/media/usb/siano/smsusb.c         |  3 ++-
 6 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.h b/drivers/media/common/siano/sms-cards.h
index 4c4caddf9869..bb3d733f092b 100644
--- a/drivers/media/common/siano/sms-cards.h
+++ b/drivers/media/common/siano/sms-cards.h
@@ -20,8 +20,9 @@
 #ifndef __SMS_CARDS_H__
 #define __SMS_CARDS_H__
 
-#include <linux/usb.h>
 #include "smscoreapi.h"
+
+#include <linux/usb.h>
 #include "smsir.h"
 
 #define SMS_BOARD_UNKNOWN 0
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index a3677438205e..26dc4392c3e1 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -21,6 +21,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "smscoreapi.h"
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -34,7 +36,6 @@
 #include <linux/wait.h>
 #include <asm/byteorder.h>
 
-#include "smscoreapi.h"
 #include "sms-cards.h"
 #include "smsir.h"
 
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index efe4ab090aec..b5d85fd0bee8 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -22,6 +22,8 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #ifndef __SMS_CORE_API_H__
 #define __SMS_CORE_API_H__
 
+#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__
+
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/mm.h>
@@ -1177,22 +1179,17 @@ int smscore_led_state(struct smscore_device_t *core, int led);
 #define DBG_INFO 1
 #define DBG_ADV  2
 
-#define sms_printk(kern, fmt, arg...) \
-	printk(kern "%s: " fmt "\n", __func__, ##arg)
-
-#define dprintk(kern, lvl, fmt, arg...) do {\
-	if (sms_dbg & lvl) \
-		sms_printk(kern, fmt, ##arg); \
+#define sms_log(fmt, arg...) pr_info(fmt "\n", ##arg)
+#define sms_err(fmt, arg...) pr_err(fmt " on line: %d\n", ##arg, __LINE__)
+#define sms_warn(fmt, arg...) pr_warn(fmt "\n", ##arg)
+#define sms_info(fmt, arg...) do {\
+	if (sms_dbg & DBG_INFO) \
+		pr_info(fmt "\n", ##arg); \
 } while (0)
 
-#define sms_log(fmt, arg...) sms_printk(KERN_INFO, fmt, ##arg)
-#define sms_err(fmt, arg...) \
-	sms_printk(KERN_ERR, "line: %d: " fmt, __LINE__, ##arg)
-#define sms_warn(fmt, arg...)  sms_printk(KERN_WARNING, fmt, ##arg)
-#define sms_info(fmt, arg...) \
-	dprintk(KERN_INFO, DBG_INFO, fmt, ##arg)
-#define sms_debug(fmt, arg...) \
-	dprintk(KERN_DEBUG, DBG_ADV, fmt, ##arg)
-
+#define sms_debug(fmt, arg...) do {\
+        if (sms_dbg & DBG_ADV) \
+                printk(KERN_DEBUG pr_fmt(fmt "\n"), ##arg); \
+} while (0)
 
 #endif /* __SMS_CORE_API_H__ */
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 042515915e20..6eb1b14092cb 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -19,6 +19,8 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 ****************************************************************/
 
+#include "smscoreapi.h"
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -29,7 +31,6 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include "dvb_demux.h"
 #include "dvb_frontend.h"
 
-#include "smscoreapi.h"
 #include "sms-cards.h"
 
 #include "smsdvb.h"
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 35d0e887bd65..2dcae6ace282 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -25,10 +25,11 @@
  ****************************************************************/
 
 
+#include "smscoreapi.h"
+
 #include <linux/types.h>
 #include <linux/input.h>
 
-#include "smscoreapi.h"
 #include "smsir.h"
 #include "sms-cards.h"
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 4b6db7557e33..426455118d02 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -19,6 +19,8 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 ****************************************************************/
 
+#include "smscoreapi.h"
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/usb.h>
@@ -26,7 +28,6 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include <linux/slab.h>
 #include <linux/module.h>
 
-#include "smscoreapi.h"
 #include "sms-cards.h"
 #include "smsendian.h"
 
-- 
2.1.0

