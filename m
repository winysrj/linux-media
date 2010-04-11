Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0DKDUP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 23:20:15 -0400
Date: Sun, 11 Apr 2010 00:20:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] ir-core: Remove the quotation mark from the uevent
 names
Message-ID: <20100411002000.3dead0ed@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need to use quotation marks at the uevent names for the
driver and table.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index a222d4f..40d9abf 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -159,9 +159,9 @@ static int ir_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 	struct ir_input_dev *ir_dev = dev_get_drvdata(device);
 
 	if (ir_dev->rc_tab.name)
-		ADD_HOTPLUG_VAR("NAME=\"%s\"", ir_dev->rc_tab.name);
+		ADD_HOTPLUG_VAR("NAME=%s", ir_dev->rc_tab.name);
 	if (ir_dev->driver_name)
-		ADD_HOTPLUG_VAR("DRV_NAME=\"%s\"", ir_dev->driver_name);
+		ADD_HOTPLUG_VAR("DRV_NAME=%s", ir_dev->driver_name);
 
 	return 0;
 }
-- 
1.6.6.1


