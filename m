Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:40013 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755779Ab1KCLqL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Nov 2011 07:46:11 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH v2] Add version number to all siano modules description lines.
Date: Thu, 3 Nov 2011 13:34:12 +0200
Message-ID: <D945C405928A9949A0F33C69E64A1A3BD8D5D7@s-mail.siano-ms.ent>
From: "Doron Cohen" <doronc@siano-ms.com>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



>From 595a6726947b032ce355ac0d838f07d937ed7f57 Mon Sep 17 00:00:00 2001
From: Doron Cohen <lab@Doron-Ubuntu.(none)>
Date: Thu, 15 Sep 2011 11:38:53 +0300
Subject: [PATCH 2/2] Add version number to all siano modules description
line.

Signed-off-by: Doron Cohen <doronc@siano-ms.com>
---
 drivers/media/dvb/siano/smscoreapi.c |    3 ++-
 drivers/media/dvb/siano/smscoreapi.h |   13 +++++++++++++
 drivers/media/dvb/siano/smsdvb.c     |    3 ++-
 drivers/media/dvb/siano/smssdio.c    |    3 ++-
 drivers/media/dvb/siano/smsspidrv.c  |    3 ++-
 drivers/media/dvb/siano/smsusb.c     |    3 ++-
 6 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c 
b/drivers/media/dvb/siano/smscoreapi.c
index c0acacc..dfbc648 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -1639,6 +1639,7 @@ static void __exit smscore_module_exit(void)
 module_init(smscore_module_init);
 module_exit(smscore_module_exit);
 
+MODULE_VERSION(VERSION_STRING);
 MODULE_DESCRIPTION("Siano MDTV Core module");
-MODULE_AUTHOR("Siano Mobile Silicon, Inc. (uris@siano-ms.com)");
+MODULE_AUTHOR(MODULE_AUTHOR_STRING);
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/siano/smscoreapi.h 
b/drivers/media/dvb/siano/smscoreapi.h
index bd1cafc..aabcad3 100644
--- a/drivers/media/dvb/siano/smscoreapi.h
+++ b/drivers/media/dvb/siano/smscoreapi.h
@@ -35,6 +35,19 @@ along with this program.  If not, see 
<http://www.gnu.org/licenses/>.
 
 #include "smsir.h"
 
+
+#define MAJOR_VERSION 2
+#define MINOR_VERSION 3
+#define SUB_VERSION 0
+
+#define STRINGIZE2(z) #z
+#define STRINGIZE(z) STRINGIZE2(z)
+
+#define VERSION_STRING "Version: " STRINGIZE(MAJOR_VERSION) "." \
+STRINGIZE(MINOR_VERSION) "." STRINGIZE(SUB_VERSION)
+
+#define MODULE_AUTHOR_STRING "Siano Mobile Silicon, Inc.
(doronc@siano-ms.com)"
+
 #define kmutex_init(_p_) mutex_init(_p_)
 #define kmutex_lock(_p_) mutex_lock(_p_)
 #define kmutex_trylock(_p_) mutex_trylock(_p_)
diff --git a/drivers/media/dvb/siano/smsdvb.c
b/drivers/media/dvb/siano/smsdvb.c
index b1f4911..dc0e73f 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -953,6 +953,7 @@ static void __exit smsdvb_module_exit(void)
 module_init(smsdvb_module_init);
 module_exit(smsdvb_module_exit);
 
+MODULE_VERSION(VERSION_STRING);
 MODULE_DESCRIPTION("SMS DVB subsystem adaptation module");
-MODULE_AUTHOR("Siano Mobile Silicon, Inc. (uris@siano-ms.com)");
+MODULE_AUTHOR(MODULE_AUTHOR_STRING);
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/siano/smssdio.c 
b/drivers/media/dvb/siano/smssdio.c
index e57d38b..e735949 100644
--- a/drivers/media/dvb/siano/smssdio.c
+++ b/drivers/media/dvb/siano/smssdio.c
@@ -359,6 +359,7 @@ static void __exit smssdio_module_exit(void)
 module_init(smssdio_module_init);
 module_exit(smssdio_module_exit);
 
+MODULE_VERSION(VERSION_STRING);
 MODULE_DESCRIPTION("Siano SMS1xxx SDIO driver");
-MODULE_AUTHOR("Pierre Ossman");
+MODULE_AUTHOR(MODULE_AUTHOR_STRING);
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/siano/smsspidrv.c 
b/drivers/media/dvb/siano/smsspidrv.c
index 4526cb8..c855fa2 100644
--- a/drivers/media/dvb/siano/smsspidrv.c
+++ b/drivers/media/dvb/siano/smsspidrv.c
@@ -467,6 +467,7 @@ static void __exit smsspi_module_exit(void)
 module_init(smsspi_module_init);
 module_exit(smsspi_module_exit);
 
+MODULE_VERSION(VERSION_STRING);
 MODULE_DESCRIPTION("Siano MDTV SPI device driver");
-MODULE_AUTHOR("Siano Mobile Silicon, Inc. (doronc@siano-ms.com)");
+MODULE_AUTHOR(MODULE_AUTHOR_STRING);
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/siano/smsusb.c
b/drivers/media/dvb/siano/smsusb.c
index f8dca55..cc688c5 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -573,6 +573,7 @@ static void __exit smsusb_module_exit(void)
 module_init(smsusb_module_init);
 module_exit(smsusb_module_exit);
 
+MODULE_VERSION(VERSION_STRING);
 MODULE_DESCRIPTION("Driver for the Siano SMS1xxx USB dongle");
-MODULE_AUTHOR("Siano Mobile Silicon, INC. (uris@siano-ms.com)");
+MODULE_AUTHOR(MODULE_AUTHOR_STRING);
 MODULE_LICENSE("GPL");
-- 
1.7.4.1
