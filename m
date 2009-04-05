Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110814.mail.gq1.yahoo.com ([67.195.13.237]:43977 "HELO
	web110814.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757865AbZDEKZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 06:25:08 -0400
Message-ID: <225276.3555.qm@web110814.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 03:25:06 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_12] Siano: unified the debug filter module parameter (dvb and core)
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238744721 -10800
# Node ID 5b86da897fbaf03ea4f5bca50abeaad15634f1d9
# Parent  01979ae55ffec22d74b77681613f38bd606be227
[PATCH] [0904_12] Siano: unified the debug filter module parameter (dvb and core)

From: Uri Shkolnik <uris@siano-ms.com>

The sms_debug module parameter sets the debug filter
for the smsmdtv module. It has been moved to the core
component, and replace the smsdvb's.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 01979ae55ffe -r 5b86da897fba linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Fri Apr 03 10:26:48 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Fri Apr 03 10:45:21 2009 +0300
@@ -34,8 +34,8 @@
 #include "smscoreapi.h"
 #include "sms-cards.h"
 
-static int sms_dbg;
-module_param_named(debug, sms_dbg, int, 0644);
+int sms_debug;
+module_param_named(debug, sms_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
 struct smscore_device_notifyee_t {
diff -r 01979ae55ffe -r 5b86da897fba linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Fri Apr 03 10:26:48 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Fri Apr 03 10:45:21 2009 +0300
@@ -627,6 +627,7 @@ int smscore_led_state(struct smscore_dev
 int smscore_led_state(struct smscore_device_t *core, int led);
 
 /* ------------------------------------------------------------------------ */
+extern int sms_debug;
 
 #define DBG_INFO 1
 #define DBG_ADV  2
@@ -635,7 +636,7 @@ int smscore_led_state(struct smscore_dev
 	printk(kern "%s: " fmt "\n", __func__, ##arg)
 
 #define dprintk(kern, lvl, fmt, arg...) do {\
-	if (sms_dbg & lvl) \
+	if (sms_debug & lvl) \
 		sms_printk(kern, fmt, ##arg); } while (0)
 
 #define sms_log(fmt, arg...) sms_printk(KERN_INFO, fmt, ##arg)
diff -r 01979ae55ffe -r 5b86da897fba linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 10:26:48 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 10:45:21 2009 +0300
@@ -63,9 +63,6 @@ static struct list_head g_smsdvb_clients
 static struct list_head g_smsdvb_clients;
 static struct mutex g_smsdvb_clientslock;
 
-static int sms_dbg;
-module_param_named(debug, sms_dbg, int, 0644);
-MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
 /* Events that may come from DVB v3 adapter */
 static void sms_board_dvb3_event(struct smscore_device_t *coredev,



      
