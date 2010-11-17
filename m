Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:34737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606Ab0KQWJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 17:09:24 -0500
Date: Wed, 17 Nov 2010 17:09:21 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Paul Bender <pebender@gmail.com>
Subject: [PATCH] rc: fix sysfs entry for mceusb and streamzap
Message-ID: <20101117220921.GE24814@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From 4c13334d96e667dfbad90882ffe671d598d30d7f Mon Sep 17 00:00:00 2001
From: Paul Bender <pebender@gmail.com>
Date: Wed, 17 Nov 2010 14:56:17 -0500
Subject: [PATCH] rc: fix sysfs entry for mceusb and streamzap

When trying to create persistent device names for mceusb and streamzap
devices, I noticed that their respective drivers are not creating the rc
device as a child of the USB device. Rather it creates it as virtual
device. As a result, udev cannot use the USB device information to
create persistent device names for event and lirc devices associated
with the rc device. Not having persistent device names makes it more
difficult to make use of the devices in userspace as their names can
change.

Signed-off-by: Paul Bender <pebender@gmail.com>

Forward-ported to media_tree staging/for_v2.6.38 and tested with
both streamzap and mceusb devices:

$ ll /dev/input/by-id/
...
lrwxrwxrwx. 1 root root 9 Nov 17 17:06 usb-Streamzap__Inc._Streamzap_Remote_Control-event-if00 -> ../event6
lrwxrwxrwx. 1 root root 9 Nov 17 17:05 usb-Topseed_Technology_Corp._eHome_Infrared_Transceiver_TS000BzY-event-if00 -> ../event5

Previously, nada.

Tested-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c    |    5 ++++-
 drivers/media/rc/streamzap.c |    3 +++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 968cf1f..2cca983 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
+#include <linux/usb/input.h>
 #include <media/ir-core.h>
 
 #define DRIVER_VERSION	"1.91"
@@ -1044,7 +1045,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 
 	snprintf(ir->name, sizeof(ir->name), "%s (%04x:%04x)",
 		 mceusb_model[ir->model].name ?
-		 	mceusb_model[ir->model].name :
+			mceusb_model[ir->model].name :
 			"Media Center Ed. eHome Infrared Remote Transceiver",
 		 le16_to_cpu(ir->usbdev->descriptor.idVendor),
 		 le16_to_cpu(ir->usbdev->descriptor.idProduct));
@@ -1053,6 +1054,8 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 
 	rc->input_name = ir->name;
 	rc->input_phys = ir->phys;
+	usb_to_input_id(ir->usbdev, &rc->input_id);
+	rc->dev.parent = dev;
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protos = IR_TYPE_ALL;
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 19652d4..b2eef51 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
+#include <linux/usb/input.h>
 #include <media/ir-core.h>
 
 #define DRIVER_VERSION	"1.61"
@@ -315,6 +316,8 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 
 	rdev->input_name = sz->name;
 	rdev->input_phys = sz->phys;
+	usb_to_input_id(sz->usbdev, &rdev->input_id);
+	rdev->dev.parent = dev;
 	rdev->priv = sz;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protos = IR_TYPE_ALL;
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

