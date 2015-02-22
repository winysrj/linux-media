Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/10] [media] siano: get rid of sms_dbg parameter
Date: Sun, 22 Feb 2015 13:11:39 -0300
Message-Id: <1424621501-17466-9-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All siano modules have a sms_dbg parameter. Now that we're using
the standard pr_debug() macro, we can get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/sms-cards.c   | 4 ----
 drivers/media/common/siano/smscoreapi.c  | 4 ----
 drivers/media/common/siano/smsdvb-main.c | 5 -----
 drivers/media/usb/siano/smsusb.c         | 4 ----
 4 files changed, 17 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 3745a2610ef9..ca2f80c7740c 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -21,10 +21,6 @@
 #include "smsir.h"
 #include <linux/module.h>
 
-static int sms_dbg;
-module_param_named(cards_dbg, sms_dbg, int, 0644);
-MODULE_PARM_DESC(cards_dbg, "set debug level (info=1, adv=2 (or-able))");
-
 static struct sms_board sms_boards[] = {
 	[SMS_BOARD_UNKNOWN] = {
 		.name	= "Unknown board",
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 36b44ce1373e..cb7515ba2193 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -39,10 +39,6 @@
 #include "sms-cards.h"
 #include "smsir.h"
 
-static int sms_dbg;
-module_param_named(debug, sms_dbg, int, 0644);
-MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
-
 struct smscore_device_notifyee_t {
 	struct list_head entry;
 	hotplug_t hotplug;
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 43bd45871b95..e6c41a4941f4 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -40,11 +40,6 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 static struct list_head g_smsdvb_clients;
 static struct mutex g_smsdvb_clientslock;
 
-static int sms_dbg;
-module_param_named(debug, sms_dbg, int, 0644);
-MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
-
-
 static u32 sms_to_guard_interval_table[] = {
 	[0] = GUARD_INTERVAL_1_32,
 	[1] = GUARD_INTERVAL_1_16,
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 29ef7d8dab7b..7d57b2677130 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -31,10 +31,6 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include "sms-cards.h"
 #include "smsendian.h"
 
-static int sms_dbg;
-module_param_named(debug, sms_dbg, int, 0644);
-MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
-
 #define USB1_BUFFER_SIZE		0x1000
 #define USB2_BUFFER_SIZE		0x2000
 
-- 
2.1.0

