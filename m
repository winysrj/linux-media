Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:46397 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab0FBOFB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jun 2010 10:05:01 -0400
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 1AE3C77C588
	for <linux-media@vger.kernel.org>; Wed,  2 Jun 2010 16:04:56 +0200 (CEST)
Received: from [192.168.168.1] (guy78-3-82-239-224-122.fbx.proxad.net [82.239.224.122])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 726A34B018E
	for <linux-media@vger.kernel.org>; Wed,  2 Jun 2010 16:04:20 +0200 (CEST)
Message-ID: <4C0664E2.4080003@trilogic.fr>
Date: Wed, 02 Jun 2010 16:04:18 +0200
From: Perceval Anichini <perceval@trilogic.fr>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] hdpvr: Fixes probing function.
Content-Type: multipart/mixed;
 boundary="------------030307040301030709060901"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030307040301030709060901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

	Hello everyone,

The error handling part of the hdpvr_probe () function
wasn't properly destroying the workqueue created at the
top of the function.

This patch fixes this bug.

Best regards,

Perceval.

--------------030307040301030709060901
Content-Type: text/x-diff;
 name="patch-hdpvr-probe.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch-hdpvr-probe.diff"

From: Perceval Anichini <perceval@trilogic.fr>

In the hdpvr_probe () function, when an error occurs while probing the device,
the workqueue created by the create_single_thread () call is not properly
destroyed.

Signed-off-by: Perceval Anichini <perceval@trilogic.fr>
---

diff -r 304cfde05b3f linux/drivers/media/video/hdpvr/hdpvr-core.c
--- a/linux/drivers/media/video/hdpvr/hdpvr-core.c	Tue May 25 23:50:51 2010 -0400
+++ b/linux/drivers/media/video/hdpvr/hdpvr-core.c	Wed Jun 02 15:42:17 2010 +0200
@@ -286,6 +286,8 @@
 		goto error;
 	}
 
+	dev->workqueue = 0;
+
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
 		err("v4l2_device_register failed");
@@ -380,6 +382,9 @@
 
 error:
 	if (dev) {
+		/* Destroy single thread */
+		if (dev->workqueue)
+			destroy_workqueue(dev->workqueue);
 		/* this frees allocated memory */
 		hdpvr_delete(dev);
 	}

--------------030307040301030709060901--
