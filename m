Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45471 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966068AbeFOQbD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 12:31:03 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH v4 07/26] media: dvb: point to the location of the old README.dvb-usb file
Date: Fri, 15 Jun 2018 13:30:35 -0300
Message-Id: <9f028dba79080f23867ec96bdce84bd0d91f2974.1529079119.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1529079119.git.mchehab+samsung@kernel.org>
References: <cover.1529079119.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1529079119.git.mchehab+samsung@kernel.org>
References: <cover.1529079119.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file got renamed, but the references still point to the
old place.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/dib3000.h        | 2 +-
 drivers/media/dvb-frontends/dib3000mb.c      | 2 +-
 drivers/media/dvb-frontends/eds1547.h        | 2 +-
 drivers/media/dvb-frontends/z0194a.h         | 2 +-
 drivers/media/usb/dvb-usb-v2/Kconfig         | 2 +-
 drivers/media/usb/dvb-usb-v2/gl861.c         | 2 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c       | 2 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.h       | 2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c      | 2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.h      | 2 +-
 drivers/media/usb/dvb-usb/Kconfig            | 2 +-
 drivers/media/usb/dvb-usb/a800.c             | 2 +-
 drivers/media/usb/dvb-usb/af9005-fe.c        | 2 +-
 drivers/media/usb/dvb-usb/af9005-remote.c    | 2 +-
 drivers/media/usb/dvb-usb/af9005.c           | 2 +-
 drivers/media/usb/dvb-usb/af9005.h           | 2 +-
 drivers/media/usb/dvb-usb/az6027.c           | 2 +-
 drivers/media/usb/dvb-usb/cxusb.c            | 2 +-
 drivers/media/usb/dvb-usb/dibusb-common.c    | 2 +-
 drivers/media/usb/dvb-usb/dibusb-mb.c        | 2 +-
 drivers/media/usb/dvb-usb/dibusb-mc-common.c | 2 +-
 drivers/media/usb/dvb-usb/dibusb-mc.c        | 2 +-
 drivers/media/usb/dvb-usb/dibusb.h           | 2 +-
 drivers/media/usb/dvb-usb/digitv.c           | 2 +-
 drivers/media/usb/dvb-usb/dtt200u-fe.c       | 2 +-
 drivers/media/usb/dvb-usb/dtt200u.c          | 2 +-
 drivers/media/usb/dvb-usb/dtt200u.h          | 2 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c     | 2 +-
 drivers/media/usb/dvb-usb/dw2102.c           | 2 +-
 drivers/media/usb/dvb-usb/friio-fe.c         | 2 +-
 drivers/media/usb/dvb-usb/friio.c            | 2 +-
 drivers/media/usb/dvb-usb/friio.h            | 2 +-
 drivers/media/usb/dvb-usb/gp8psk.c           | 2 +-
 drivers/media/usb/dvb-usb/gp8psk.h           | 2 +-
 drivers/media/usb/dvb-usb/m920x.c            | 2 +-
 drivers/media/usb/dvb-usb/nova-t-usb2.c      | 2 +-
 drivers/media/usb/dvb-usb/opera1.c           | 2 +-
 drivers/media/usb/dvb-usb/ttusb2.c           | 2 +-
 drivers/media/usb/dvb-usb/ttusb2.h           | 2 +-
 drivers/media/usb/dvb-usb/umt-010.c          | 2 +-
 drivers/media/usb/dvb-usb/vp702x-fe.c        | 2 +-
 drivers/media/usb/dvb-usb/vp702x.c           | 2 +-
 drivers/media/usb/dvb-usb/vp7045-fe.c        | 2 +-
 drivers/media/usb/dvb-usb/vp7045.c           | 2 +-
 drivers/media/usb/dvb-usb/vp7045.h           | 2 +-
 45 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib3000.h b/drivers/media/dvb-frontends/dib3000.h
index d5dfafb4ef13..d2b7523a22b5 100644
--- a/drivers/media/dvb-frontends/dib3000.h
+++ b/drivers/media/dvb-frontends/dib3000.h
@@ -17,7 +17,7 @@
  *  Amaury Demol from DiBcom for providing specs and driver
  *  sources, on which this driver (and the dvb-dibusb) are based.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  *
  */
 
diff --git a/drivers/media/dvb-frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
index de3ce2786c72..5861f346db49 100644
--- a/drivers/media/dvb-frontends/dib3000mb.c
+++ b/drivers/media/dvb-frontends/dib3000mb.c
@@ -17,7 +17,7 @@
  *  Amaury Demol from DiBcom for providing specs and driver
  *  sources, on which this driver (and the dvb-dibusb) are based.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  *
  */
 
diff --git a/drivers/media/dvb-frontends/eds1547.h b/drivers/media/dvb-frontends/eds1547.h
index c983f2f85802..30f067fc1f56 100644
--- a/drivers/media/dvb-frontends/eds1547.h
+++ b/drivers/media/dvb-frontends/eds1547.h
@@ -6,7 +6,7 @@
 *	under the terms of the GNU General Public License as published by the
 *	Free Software Foundation, version 2.
 *
-* see Documentation/dvb/README.dvb-usb for more information
+* see Documentation/media/dvb-drivers/dvb-usb.rst for more information
 */
 
 #ifndef EDS1547
diff --git a/drivers/media/dvb-frontends/z0194a.h b/drivers/media/dvb-frontends/z0194a.h
index 96d86d6eb473..0871c1ade94c 100644
--- a/drivers/media/dvb-frontends/z0194a.h
+++ b/drivers/media/dvb-frontends/z0194a.h
@@ -6,7 +6,7 @@
 *	under the terms of the GNU General Public License as published by the
 *	Free Software Foundation, version 2.
 *
-* see Documentation/dvb/README.dvb-usb for more information
+* see Documentation/media/dvb-drivers/dvb-usb.rst for more information
 */
 
 #ifndef Z0194A
diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 37053477b84d..082b8d67244b 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -6,7 +6,7 @@ config DVB_USB_V2
 	  USB1.1 and USB2.0 DVB devices.
 
 	  Almost every USB device needs a firmware, please look into
-	  <file:Documentation/dvb/README.dvb-usb>.
+	  <file:Documentation/media/dvb-drivers/dvb-usb.rst>.
 
 	  For a complete list of supported USB devices see the LinuxTV DVB Wiki:
 	  <https://linuxtv.org/wiki/index.php/DVB_USB>
diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index 4817dfd3e659..9d154fdae45b 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -4,7 +4,7 @@
  *	under the terms of the GNU General Public License as published by the
  *	Free Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "gl861.h"
 
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 39db6dc4b5cd..0750a975bcb8 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -49,7 +49,7 @@
  * GNU General Public License for more details.
  *
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  *
  * Known Issues :
  *	LME2510: Non Intel USB chipsets fail to maintain High Speed on
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.h b/drivers/media/usb/dvb-usb-v2/lmedm04.h
index e9c207205c2f..c4ae37c19512 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.h
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.h
@@ -16,7 +16,7 @@
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation,  version 2.
  * *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #ifndef _DVB_USB_LME2510_H_
 #define _DVB_USB_LME2510_H_
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 67953360fda5..4713ba65e1c2 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -5,7 +5,7 @@
  *   under the terms of the GNU General Public License as published by the Free
  *   Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 
 #include <linux/vmalloc.h>
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.h b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
index 3e6f5880bd1e..22253d4908eb 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
@@ -5,7 +5,7 @@
  *   under the terms of the GNU General Public License as published by the Free
  *   Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 
 #ifndef _DVB_USB_MXL111SF_H_
diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 2651ae277347..b8a1c62a0682 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -6,7 +6,7 @@ config DVB_USB
 	  USB1.1 and USB2.0 DVB devices.
 
 	  Almost every USB device needs a firmware, please look into
-	  <file:Documentation/dvb/README.dvb-usb>.
+	  <file:Documentation/media/dvb-drivers/dvb-usb.rst>.
 
 	  For a complete list of supported USB devices see the LinuxTV DVB Wiki:
 	  <https://linuxtv.org/wiki/index.php/DVB_USB>
diff --git a/drivers/media/usb/dvb-usb/a800.c b/drivers/media/usb/dvb-usb/a800.c
index 540886b3bb29..198bd5eadb3f 100644
--- a/drivers/media/usb/dvb-usb/a800.c
+++ b/drivers/media/usb/dvb-usb/a800.c
@@ -11,7 +11,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "dibusb.h"
 
diff --git a/drivers/media/usb/dvb-usb/af9005-fe.c b/drivers/media/usb/dvb-usb/af9005-fe.c
index 544bdf18fb2f..7fbbc954da16 100644
--- a/drivers/media/usb/dvb-usb/af9005-fe.c
+++ b/drivers/media/usb/dvb-usb/af9005-fe.c
@@ -15,7 +15,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "af9005.h"
 #include "af9005-script.h"
diff --git a/drivers/media/usb/dvb-usb/af9005-remote.c b/drivers/media/usb/dvb-usb/af9005-remote.c
index 9b29ffa93075..f7cdcc8424a8 100644
--- a/drivers/media/usb/dvb-usb/af9005-remote.c
+++ b/drivers/media/usb/dvb-usb/af9005-remote.c
@@ -17,7 +17,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "af9005.h"
 /* debug */
diff --git a/drivers/media/usb/dvb-usb/af9005.c b/drivers/media/usb/dvb-usb/af9005.c
index 986763b1b2b3..16e946e01d2c 100644
--- a/drivers/media/usb/dvb-usb/af9005.c
+++ b/drivers/media/usb/dvb-usb/af9005.c
@@ -15,7 +15,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "af9005.h"
 
diff --git a/drivers/media/usb/dvb-usb/af9005.h b/drivers/media/usb/dvb-usb/af9005.h
index a1eae0fa02ed..7ae4dc3a968b 100644
--- a/drivers/media/usb/dvb-usb/af9005.h
+++ b/drivers/media/usb/dvb-usb/af9005.h
@@ -15,7 +15,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #ifndef _DVB_USB_AF9005_H_
 #define _DVB_USB_AF9005_H_
diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index f0d10ac03a37..6321b8e30261 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -7,7 +7,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "az6027.h"
 
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index b70d289dc738..5b51ed7d6243 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -21,7 +21,7 @@
  *   under the terms of the GNU General Public License as published by the Free
  *   Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include <media/tuner.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index bcacb0f22028..fb1b4f2d5f9d 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -6,7 +6,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 
 #include "dibusb.h"
diff --git a/drivers/media/usb/dvb-usb/dibusb-mb.c b/drivers/media/usb/dvb-usb/dibusb-mb.c
index a0057641cc86..408920577716 100644
--- a/drivers/media/usb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/usb/dvb-usb/dibusb-mb.c
@@ -10,7 +10,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "dibusb.h"
 
diff --git a/drivers/media/usb/dvb-usb/dibusb-mc-common.c b/drivers/media/usb/dvb-usb/dibusb-mc-common.c
index 0c2bc97436d5..ec3a20a95b04 100644
--- a/drivers/media/usb/dvb-usb/dibusb-mc-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-mc-common.c
@@ -6,7 +6,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 
 #include "dibusb.h"
diff --git a/drivers/media/usb/dvb-usb/dibusb-mc.c b/drivers/media/usb/dvb-usb/dibusb-mc.c
index 08fb8a3f6e0c..bce8ffe640ca 100644
--- a/drivers/media/usb/dvb-usb/dibusb-mc.c
+++ b/drivers/media/usb/dvb-usb/dibusb-mc.c
@@ -10,7 +10,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "dibusb.h"
 
diff --git a/drivers/media/usb/dvb-usb/dibusb.h b/drivers/media/usb/dvb-usb/dibusb.h
index 697be2a17ade..943df579b98b 100644
--- a/drivers/media/usb/dvb-usb/dibusb.h
+++ b/drivers/media/usb/dvb-usb/dibusb.h
@@ -6,7 +6,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #ifndef _DVB_USB_DIBUSB_H_
 #define _DVB_USB_DIBUSB_H_
diff --git a/drivers/media/usb/dvb-usb/digitv.c b/drivers/media/usb/dvb-usb/digitv.c
index 475a3c0cdee7..49b9d63e5885 100644
--- a/drivers/media/usb/dvb-usb/digitv.c
+++ b/drivers/media/usb/dvb-usb/digitv.c
@@ -9,7 +9,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "digitv.h"
 
diff --git a/drivers/media/usb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
index 00f565fe7cc2..7e75aae34fb8 100644
--- a/drivers/media/usb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/usb/dvb-usb/dtt200u-fe.c
@@ -7,7 +7,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "dtt200u.h"
 
diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index 512370786696..f03d26954517 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -9,7 +9,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "dtt200u.h"
 
diff --git a/drivers/media/usb/dvb-usb/dtt200u.h b/drivers/media/usb/dvb-usb/dtt200u.h
index efccc399b1cb..ea2a096c1650 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.h
+++ b/drivers/media/usb/dvb-usb/dtt200u.h
@@ -7,7 +7,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #ifndef _DVB_USB_DTT200U_H_
 #define _DVB_USB_DTT200U_H_
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 84308569e7dc..40ca4eafb137 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -9,7 +9,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "dvb-usb-common.h"
 
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 716711ecce32..0d4fdd34a710 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -11,7 +11,7 @@
  *	under the terms of the GNU General Public License as published by the
  *	Free Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include <media/dvb-usb-ids.h>
 #include "dw2102.h"
diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index b2830c157548..932f262452eb 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -8,7 +8,7 @@
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include <linux/init.h>
 #include <linux/string.h>
diff --git a/drivers/media/usb/dvb-usb/friio.c b/drivers/media/usb/dvb-usb/friio.c
index 16875945e662..fe799a7ad44b 100644
--- a/drivers/media/usb/dvb-usb/friio.c
+++ b/drivers/media/usb/dvb-usb/friio.c
@@ -8,7 +8,7 @@
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "friio.h"
 
diff --git a/drivers/media/usb/dvb-usb/friio.h b/drivers/media/usb/dvb-usb/friio.h
index 0f461ca10cb9..a53af56d035c 100644
--- a/drivers/media/usb/dvb-usb/friio.h
+++ b/drivers/media/usb/dvb-usb/friio.h
@@ -8,7 +8,7 @@
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #ifndef _DVB_USB_FRIIO_H_
 #define _DVB_USB_FRIIO_H_
diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 1ad8dfb10aa4..13e96b0aeb0f 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -12,7 +12,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "gp8psk.h"
 #include "gp8psk-fe.h"
diff --git a/drivers/media/usb/dvb-usb/gp8psk.h b/drivers/media/usb/dvb-usb/gp8psk.h
index d8975b866dee..fd063e385eaf 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.h
+++ b/drivers/media/usb/dvb-usb/gp8psk.h
@@ -12,7 +12,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #ifndef _DVB_USB_GP8PSK_H_
 #define _DVB_USB_GP8PSK_H_
diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 32081c2ce0da..51b026fa6bfb 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -6,7 +6,7 @@
  *	under the terms of the GNU General Public License as published by the
  *	Free Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 
 #include "m920x.h"
diff --git a/drivers/media/usb/dvb-usb/nova-t-usb2.c b/drivers/media/usb/dvb-usb/nova-t-usb2.c
index 1babd3341910..43e0e0fd715b 100644
--- a/drivers/media/usb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/usb/dvb-usb/nova-t-usb2.c
@@ -7,7 +7,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "dibusb.h"
 
diff --git a/drivers/media/usb/dvb-usb/opera1.c b/drivers/media/usb/dvb-usb/opera1.c
index eeafa3cdbbdc..61a377e2373d 100644
--- a/drivers/media/usb/dvb-usb/opera1.c
+++ b/drivers/media/usb/dvb-usb/opera1.c
@@ -7,7 +7,7 @@
 *	under the terms of the GNU General Public License as published by the Free
 *	Software Foundation, version 2.
 *
-* see Documentation/dvb/README.dvb-usb for more information
+* see Documentation/media/dvb-drivers/dvb-usb.rst for more information
 */
 
 #define DVB_USB_LOG_PREFIX "opera"
diff --git a/drivers/media/usb/dvb-usb/ttusb2.c b/drivers/media/usb/dvb-usb/ttusb2.c
index 12de89665d60..b4d681151599 100644
--- a/drivers/media/usb/dvb-usb/ttusb2.c
+++ b/drivers/media/usb/dvb-usb/ttusb2.c
@@ -20,7 +20,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #define DVB_USB_LOG_PREFIX "ttusb2"
 #include "dvb-usb.h"
diff --git a/drivers/media/usb/dvb-usb/ttusb2.h b/drivers/media/usb/dvb-usb/ttusb2.h
index 52a63af40896..8b6525e5fb24 100644
--- a/drivers/media/usb/dvb-usb/ttusb2.h
+++ b/drivers/media/usb/dvb-usb/ttusb2.h
@@ -9,7 +9,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #ifndef _DVB_USB_TTUSB2_H_
 #define _DVB_USB_TTUSB2_H_
diff --git a/drivers/media/usb/dvb-usb/umt-010.c b/drivers/media/usb/dvb-usb/umt-010.c
index 58ad5b4f856c..920bc67c3bcb 100644
--- a/drivers/media/usb/dvb-usb/umt-010.c
+++ b/drivers/media/usb/dvb-usb/umt-010.c
@@ -7,7 +7,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "dibusb.h"
 
diff --git a/drivers/media/usb/dvb-usb/vp702x-fe.c b/drivers/media/usb/dvb-usb/vp702x-fe.c
index 7ff31baa3682..ae48146e005c 100644
--- a/drivers/media/usb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/usb/dvb-usb/vp702x-fe.c
@@ -15,7 +15,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  *
  */
 #include "vp702x.h"
diff --git a/drivers/media/usb/dvb-usb/vp702x.c b/drivers/media/usb/dvb-usb/vp702x.c
index 40de33de90a7..c3529ea59da9 100644
--- a/drivers/media/usb/dvb-usb/vp702x.c
+++ b/drivers/media/usb/dvb-usb/vp702x.c
@@ -12,7 +12,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "vp702x.h"
 #include <linux/mutex.h>
diff --git a/drivers/media/usb/dvb-usb/vp7045-fe.c b/drivers/media/usb/dvb-usb/vp7045-fe.c
index 4520ad9c2014..f86040173b8d 100644
--- a/drivers/media/usb/dvb-usb/vp7045-fe.c
+++ b/drivers/media/usb/dvb-usb/vp7045-fe.c
@@ -9,7 +9,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  *
  */
 #include "vp7045.h"
diff --git a/drivers/media/usb/dvb-usb/vp7045.c b/drivers/media/usb/dvb-usb/vp7045.c
index 2527b88beb87..e2c8a8530554 100644
--- a/drivers/media/usb/dvb-usb/vp7045.c
+++ b/drivers/media/usb/dvb-usb/vp7045.c
@@ -10,7 +10,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #include "vp7045.h"
 
diff --git a/drivers/media/usb/dvb-usb/vp7045.h b/drivers/media/usb/dvb-usb/vp7045.h
index 66499932ca76..2fdafd8f8cd6 100644
--- a/drivers/media/usb/dvb-usb/vp7045.h
+++ b/drivers/media/usb/dvb-usb/vp7045.h
@@ -9,7 +9,7 @@
  *	under the terms of the GNU General Public License as published by the Free
  *	Software Foundation, version 2.
  *
- * see Documentation/dvb/README.dvb-usb for more information
+ * see Documentation/media/dvb-drivers/dvb-usb.rst for more information
  */
 #ifndef _DVB_USB_VP7045_H_
 #define _DVB_USB_VP7045_H_
-- 
2.17.1
