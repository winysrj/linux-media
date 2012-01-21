Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4h9D021353
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/35] [media] az6007: Get rid of az6007.h
Date: Sat, 21 Jan 2012 14:04:10 -0200
Message-Id: <1327161877-16784-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-8-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The header file serves for no purpose and exports some things
that should be static.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   11 +++++++++--
 drivers/media/dvb/dvb-usb/az6007.h |   18 ------------------
 2 files changed, 9 insertions(+), 20 deletions(-)
 delete mode 100644 drivers/media/dvb/dvb-usb/az6007.h

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index a709cec..1791cb0 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -3,13 +3,15 @@
  * see Documentation/dvb/README.dvb-usb for more information
  */
 
-#include "az6007.h"
 #include "drxk.h"
 #include "mt2063.h"
 #include "dvb_ca_en50221.h"
+#include "dvb-usb.h"
+
+#define DVB_USB_LOG_PREFIX "az6007"
 
 /* HACK: Should be moved to the right place */
-#define USB_PID_AZUREWAVE_6007		0xccd
+#define USB_PID_AZUREWAVE_6007		0x0ccd
 #define USB_PID_TERRATEC_H7		0x10b4
 
 /* debug */
@@ -18,6 +20,11 @@ module_param_named(debug, dvb_usb_az6007_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))."
 		 DVB_USB_DEBUG_STATUS);
 
+#define deb_info(args...) dprintk(dvb_usb_az6007_debug, 0x01, args)
+#define deb_xfer(args...) dprintk(dvb_usb_az6007_debug, 0x02, args)
+#define deb_rc(args...)   dprintk(dvb_usb_az6007_debug, 0x04, args)
+#define deb_fe(args...)   dprintk(dvb_usb_az6007_debug, 0x08, args)
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct az6007_device_state {
diff --git a/drivers/media/dvb/dvb-usb/az6007.h b/drivers/media/dvb/dvb-usb/az6007.h
deleted file mode 100644
index aefa5b5..0000000
--- a/drivers/media/dvb/dvb-usb/az6007.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef _DVB_USB_AZ6007_H_
-#define _DVB_USB_AZ6007_H_
-
-#define DVB_USB_LOG_PREFIX "az6007"
-#include "dvb-usb.h"
-
-
-extern int dvb_usb_az6007_debug;
-#define deb_info(args...) dprintk(dvb_usb_az6007_debug,0x01,args)
-#define deb_xfer(args...) dprintk(dvb_usb_az6007_debug,0x02,args)
-#define deb_rc(args...)   dprintk(dvb_usb_az6007_debug,0x04,args)
-#define deb_fe(args...)   dprintk(dvb_usb_az6007_debug,0x08,args)
-
-
-extern int vp702x_usb_out_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i, int ilen, int msec);
-extern int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
-
-#endif
-- 
1.7.8

