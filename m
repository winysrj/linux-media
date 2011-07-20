Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:35541 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751075Ab1GTL4L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 07:56:11 -0400
Subject: [PATCH] siano: apply debug flag to module level.
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 15:07:36 +0300
Message-ID: <1311163656.32566.6.camel@doron-ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Siano modules already had sms_dbg flag which is a module parameter which
sets the debug mode so module prints messages to dmesg for debugging.
The variable was static therefore apply only to the file which defines
the module. In modules as smsmdtv.ko that contain a few files, the debug
flag applied only for functions in that main file.
flag was changed to be non-static and therefore can be accessed by all
module files (although it is still not exported out of the module).

Thanks,
Doron



Signed-off-by: Doron Cohen <doronc@siano-ms.com>
---
 drivers/media/dvb/siano/sms-cards.c  |    4 ----
 drivers/media/dvb/siano/smscoreapi.c |    2 +-
 drivers/media/dvb/siano/smscoreapi.h |    1 +
 drivers/media/dvb/siano/smsdvb.c     |    2 +-
 drivers/media/dvb/siano/smsusb.c     |    2 +-
 5 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/siano/sms-cards.c
b/drivers/media/dvb/siano/sms-cards.c
index af121db..cf442dc 100644
--- a/drivers/media/dvb/siano/sms-cards.c
+++ b/drivers/media/dvb/siano/sms-cards.c
@@ -20,10 +20,6 @@
 #include "sms-cards.h"
 #include "smsir.h"
 
-static int sms_dbg;
-module_param_named(cards_dbg, sms_dbg, int, 0644);
-MODULE_PARM_DESC(cards_dbg, "set debug level (info=1, adv=2
(or-able))");
-
 static struct sms_board sms_boards[] = {
 	[SMS_BOARD_UNKNOWN] = {
 		.name	= "Unknown board",
diff --git a/drivers/media/dvb/siano/smscoreapi.c
b/drivers/media/dvb/siano/smscoreapi.c
index 78765ed..239f453 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -39,7 +39,7 @@
 #include "smsir.h"
 #include "smsendian.h"
 
-static int sms_dbg;
+int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
diff --git a/drivers/media/dvb/siano/smscoreapi.h
b/drivers/media/dvb/siano/smscoreapi.h
index 8ecadec..05dd9f6 100644
--- a/drivers/media/dvb/siano/smscoreapi.h
+++ b/drivers/media/dvb/siano/smscoreapi.h
@@ -752,6 +752,7 @@ int smscore_led_state(struct smscore_device_t *core,
int led);
 
 
 /*
------------------------------------------------------------------------
*/
+extern int sms_dbg;
 
 #define DBG_INFO 1
 #define DBG_ADV  2
diff --git a/drivers/media/dvb/siano/smsdvb.c
b/drivers/media/dvb/siano/smsdvb.c
index 37c594f..9fbf022 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -60,7 +60,7 @@ struct smsdvb_client_t {
 static struct list_head g_smsdvb_clients;
 static struct mutex g_smsdvb_clientslock;
 
-static int sms_dbg;
+int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
diff --git a/drivers/media/dvb/siano/smsusb.c
b/drivers/media/dvb/siano/smsusb.c
index 0b8da57..da4628d 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -29,7 +29,7 @@ along with this program.  If not, see
<http://www.gnu.org/licenses/>.
 #include "sms-cards.h"
 #include "smsendian.h"
 
-static int sms_dbg;
+int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
-- 

