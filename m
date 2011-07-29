Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1G2FyJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 01:54:09 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6T5s9eD006260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 01:54:09 -0400
Received: from localhost.localdomain (vpn-227-36.phx2.redhat.com [10.3.227.36])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6T5s61S013209
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 01:54:08 -0400
Date: Fri, 29 Jul 2011 02:53:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] rc-main: Fix device de-registration logic
Message-ID: <20110729025356.28cc99e8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rc unregister logic were deadly broken, preventing some drivers to
be removed. Among the broken things, rc_dev_uevent() is being called
during device_del(), causing a data filling on an area that it is
not ready anymore.

Also, some drivers have a stop callback defined, that needs to be called
before data removal, as it stops data polling.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 51a23f4..666d4bb 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -928,10 +928,6 @@ out:
 
 static void rc_dev_release(struct device *device)
 {
-	struct rc_dev *dev = to_rc_dev(device);
-
-	kfree(dev);
-	module_put(THIS_MODULE);
 }
 
 #define ADD_HOTPLUG_VAR(fmt, val...)					\
@@ -945,6 +941,9 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 {
 	struct rc_dev *dev = to_rc_dev(device);
 
+	if (!dev || !dev->input_dev)
+		return -ENODEV;
+
 	if (dev->rc_map.name)
 		ADD_HOTPLUG_VAR("NAME=%s", dev->rc_map.name);
 	if (dev->driver_name)
@@ -1013,10 +1012,16 @@ EXPORT_SYMBOL_GPL(rc_allocate_device);
 
 void rc_free_device(struct rc_dev *dev)
 {
-	if (dev) {
+	if (!dev)
+		return;
+
+	if (dev->input_dev)
 		input_free_device(dev->input_dev);
-		put_device(&dev->dev);
-	}
+
+	put_device(&dev->dev);
+
+	kfree(dev);
+	module_put(THIS_MODULE);
 }
 EXPORT_SYMBOL_GPL(rc_free_device);
 
@@ -1143,14 +1148,18 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
-	input_unregister_device(dev->input_dev);
-	dev->input_dev = NULL;
-
+	/* Freeing the table should also call the stop callback */
 	ir_free_table(&dev->rc_map);
 	IR_dprintk(1, "Freed keycode table\n");
 
-	device_unregister(&dev->dev);
+	input_unregister_device(dev->input_dev);
+	dev->input_dev = NULL;
+
+	device_del(&dev->dev);
+
+	rc_free_device(dev);
 }
+
 EXPORT_SYMBOL_GPL(rc_unregister_device);
 
 /*
-- 
1.7.1


