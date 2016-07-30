Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51575 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbcG3NTm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2016 09:19:42 -0400
From: Ole Ernst <olebowle@gmx.com>
To: m.chehab@samsung.com
Cc: hias@horus.com, linux-media@vger.kernel.org,
	Ole Ernst <olebowle@gmx.com>
Subject: [PATCH] Partly revert "[media] rc-core: allow calling rc_open with device not initialized"
Date: Sat, 30 Jul 2016 15:19:27 +0200
Message-Id: <20160730131927.10308-1-olebowle@gmx.com>
In-Reply-To: <20160726115225.GA15199@camel2.lan>
References: <20160726115225.GA15199@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This partly reverts commit 078600f514a12fd763ac84c86af68ef5b5267563.

Due to the relocation of input_register_device() call, holding down a
button on an IR remote no longer resulted in repeated key down events.

Signed-off-by: Ole Ernst <olebowle@gmx.com>
---
 drivers/media/rc/rc-main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 8e7f292..26fd63b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1460,6 +1460,10 @@ int rc_register_device(struct rc_dev *dev)
 	dev->input_dev->phys = dev->input_phys;
 	dev->input_dev->name = dev->input_name;
 
+	rc = input_register_device(dev->input_dev);
+	if (rc)
+		goto out_table;
+
 	/*
 	 * Default delay of 250ms is too short for some protocols, especially
 	 * since the timeout is currently set to 250ms. Increase it to 500ms,
@@ -1475,11 +1479,6 @@ int rc_register_device(struct rc_dev *dev)
 	 */
 	dev->input_dev->rep[REP_PERIOD] = 125;
 
-	/* rc_open will be called here */
-	rc = input_register_device(dev->input_dev);
-	if (rc)
-		goto out_table;
-
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	dev_info(&dev->dev, "%s as %s\n",
 		dev->input_name ?: "Unspecified device", path ?: "N/A");
-- 
2.9.0

