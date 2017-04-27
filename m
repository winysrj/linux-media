Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:55214 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755330AbdD0UeA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 16:34:00 -0400
Subject: [PATCH 1/6] rc-core: fix input repeat handling
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Thu, 27 Apr 2017 22:33:58 +0200
Message-ID: <149332523796.32431.14044805351907177736.stgit@zeus.hardeman.nu>
In-Reply-To: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The call to input_register_device() needs to take place
before the repeat parameters are set or the input subsystem
repeat handling will be disabled (as was already noted in
the comments in that function).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6ec73357fa47..802e559cc30e 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1703,6 +1703,16 @@ static int rc_setup_rx_device(struct rc_dev *dev)
 	if (dev->close)
 		dev->input_dev->close = ir_close;
 
+	dev->input_dev->dev.parent = &dev->dev;
+	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
+	dev->input_dev->phys = dev->input_phys;
+	dev->input_dev->name = dev->input_name;
+
+	/* rc_open will be called here */
+	rc = input_register_device(dev->input_dev);
+	if (rc)
+		goto out_table;
+
 	/*
 	 * Default delay of 250ms is too short for some protocols, especially
 	 * since the timeout is currently set to 250ms. Increase it to 500ms,
@@ -1718,16 +1728,6 @@ static int rc_setup_rx_device(struct rc_dev *dev)
 	 */
 	dev->input_dev->rep[REP_PERIOD] = 125;
 
-	dev->input_dev->dev.parent = &dev->dev;
-	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
-	dev->input_dev->phys = dev->input_phys;
-	dev->input_dev->name = dev->input_name;
-
-	/* rc_open will be called here */
-	rc = input_register_device(dev->input_dev);
-	if (rc)
-		goto out_table;
-
 	return 0;
 
 out_table:
