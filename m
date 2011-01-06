Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:52697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab1AFT5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 14:57:47 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p06Jvl6g023684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 6 Jan 2011 14:57:47 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/6] rc/imon: fix ffdc device detection oops
Date: Thu,  6 Jan 2011 14:57:14 -0500
Message-Id: <1294343839-31784-2-git-send-email-jarod@redhat.com>
In-Reply-To: <1294343839-31784-1-git-send-email-jarod@redhat.com>
References: <1294343839-31784-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

There's a nasty bug that slipped in when the rc device interface was
altered, only affecting the older 0xffdc imon devices. We were trying
to access ictx->rdev->allowed_protos before ictx->rdev had been set.

There's also an issue with call ordering that meant the correct
keymap wasn't getting loaded for MCE IR type 0xffdc devices.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/imon.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 6811512..a30bd99 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1756,7 +1756,6 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 	printk(KERN_CONT " (id 0x%02x)\n", ffdc_cfg_byte);
 
 	ictx->display_type = detected_display_type;
-	ictx->rdev->allowed_protos = allowed_protos;
 	ictx->rc_type = allowed_protos;
 }
 
@@ -1839,10 +1838,6 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 	rdev->allowed_protos = RC_TYPE_OTHER | RC_TYPE_RC6; /* iMON PAD or MCE */
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
-	if (ictx->rc_type == RC_TYPE_RC6)
-		rdev->map_name = RC_MAP_IMON_MCE;
-	else
-		rdev->map_name = RC_MAP_IMON_PAD;
 
 	/* Enable front-panel buttons and/or knobs */
 	memcpy(ictx->usb_tx_buf, &fp_packet, sizeof(fp_packet));
@@ -1851,11 +1846,18 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 	if (ret)
 		dev_info(ictx->dev, "panel buttons/knobs setup failed\n");
 
-	if (ictx->product == 0xffdc)
+	if (ictx->product == 0xffdc) {
 		imon_get_ffdc_type(ictx);
+		rdev->allowed_protos = ictx->rc_type;
+	}
 
 	imon_set_display_type(ictx);
 
+	if (ictx->rc_type == RC_TYPE_RC6)
+		rdev->map_name = RC_MAP_IMON_MCE;
+	else
+		rdev->map_name = RC_MAP_IMON_PAD;
+
 	ret = rc_register_device(rdev);
 	if (ret < 0) {
 		dev_err(ictx->dev, "remote input dev register failed\n");
-- 
1.7.3.4

