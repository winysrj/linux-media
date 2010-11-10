Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab0KJDO0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 22:14:26 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAA3EQ5A004436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:14:26 -0500
Received: from pedra (vpn-229-171.phx2.redhat.com [10.3.229.171])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oAA3DKlX031781
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:14:25 -0500
Date: Wed, 10 Nov 2010 01:13:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] Rename rc-core files from ir- to rc-
Message-ID: <20101110011309.4c771d9b@pedra>
In-Reply-To: <cover.1289358255.git.mchehab@redhat.com>
References: <cover.1289358255.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As protocol decoders are specific to InfraRed, keep their names as-is.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 rename drivers/media/rc/{ir-core-priv.h => rc-core-priv.h} (100%)
 rename drivers/media/rc/{ir-keytable.c => rc-main.c} (99%)
 rename drivers/media/rc/{ir-raw-event.c => rc-raw.c} (99%)
 rename drivers/media/rc/{ir-sysfs.c => rc-sysfs.c} (99%)

diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 38873cf..479a8f4 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,9 +1,9 @@
 ir-common-objs  := ir-functions.o
-ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o rc-map.o
+rc-core-objs	:= rc-main.o rc-sysfs.o rc-raw.o rc-map.o
 
 obj-y += keymaps/
 
-obj-$(CONFIG_IR_CORE) += ir-core.o
+obj-$(CONFIG_IR_CORE) += rc-core.o
 obj-$(CONFIG_IR_LEGACY) += ir-common.o
 obj-$(CONFIG_LIRC) += lirc_dev.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
diff --git a/drivers/media/rc/ir-functions.c b/drivers/media/rc/ir-functions.c
index ec021c9..14397d0 100644
--- a/drivers/media/rc/ir-functions.c
+++ b/drivers/media/rc/ir-functions.c
@@ -24,7 +24,7 @@
 #include <linux/string.h>
 #include <linux/jiffies.h>
 #include <media/ir-common.h>
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 /* -------------------------------------------------------------------------- */
 
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 63dca6e..d83a5f6 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/bitrev.h>
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 #define JVC_NBITS		16		/* dev(8) + func(8) */
 #define JVC_UNIT		525000		/* ns */
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 1d9c6b0..aed69ed 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -17,7 +17,7 @@
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 #include <media/ir-core.h>
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 #define LIRCBUF_SIZE 256
 
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 70993f7..cad4e99 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/bitrev.h>
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 #define NEC_NBITS		32
 #define NEC_UNIT		562500  /* ns */
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 572ed4c..c07f6e0 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -20,7 +20,7 @@
  * the first two bits are start bits, and a third one is a filing bit
  */
 
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 #define RC5_NBITS		14
 #define RC5X_NBITS		20
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index 7c41350..0c3b6eb 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -20,7 +20,7 @@
  * the first two bits are start bits, and a third one is a filing bit
  */
 
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 #define RC5_SZ_NBITS		15
 #define RC5_UNIT		888888 /* ns */
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index d25da91..48e82be 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -12,7 +12,7 @@
  * GNU General Public License for more details.
  */
 
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 /*
  * This decoder currently supports:
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index 2d15730..0a5cadb 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/bitrev.h>
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 #define SONY_UNIT		600000 /* ns */
 #define SONY_HEADER_PULSE	(4 * SONY_UNIT)
diff --git a/drivers/media/rc/ir-core-priv.h b/drivers/media/rc/rc-core-priv.h
similarity index 100%
rename from drivers/media/rc/ir-core-priv.h
rename to drivers/media/rc/rc-core-priv.h
diff --git a/drivers/media/rc/ir-keytable.c b/drivers/media/rc/rc-main.c
similarity index 99%
rename from drivers/media/rc/ir-keytable.c
rename to drivers/media/rc/rc-main.c
index d0c3c0e..af7119f 100644
--- a/drivers/media/rc/ir-keytable.c
+++ b/drivers/media/rc/rc-main.c
@@ -15,7 +15,7 @@
 
 #include <linux/input.h>
 #include <linux/slab.h>
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
 #define IR_TAB_MIN_SIZE	256
diff --git a/drivers/media/rc/ir-raw-event.c b/drivers/media/rc/rc-raw.c
similarity index 99%
rename from drivers/media/rc/ir-raw-event.c
rename to drivers/media/rc/rc-raw.c
index a06a07e..d6c556e 100644
--- a/drivers/media/rc/ir-raw-event.c
+++ b/drivers/media/rc/rc-raw.c
@@ -16,7 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/freezer.h>
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 /* Define the max number of pulse/space transitions to buffer */
 #define MAX_IR_EVENT_SIZE      512
diff --git a/drivers/media/rc/ir-sysfs.c b/drivers/media/rc/rc-sysfs.c
similarity index 99%
rename from drivers/media/rc/ir-sysfs.c
rename to drivers/media/rc/rc-sysfs.c
index 38423a8..a5f81d1 100644
--- a/drivers/media/rc/ir-sysfs.c
+++ b/drivers/media/rc/rc-sysfs.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/device.h>
-#include "ir-core-priv.h"
+#include "rc-core-priv.h"
 
 #define IRRCV_NUM_DEVICES	256
 
-- 
1.7.1


