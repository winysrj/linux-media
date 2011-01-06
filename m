Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:60255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab1AFT77 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 14:59:59 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p06JxxGk017238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 6 Jan 2011 14:59:59 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 3/6] rc/imon: need to submit urb before ffdc type check
Date: Thu,  6 Jan 2011 14:59:34 -0500
Message-Id: <1294343977-31929-4-git-send-email-jarod@redhat.com>
In-Reply-To: <1294343839-31784-1-git-send-email-jarod@redhat.com>
References: <1294343839-31784-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Otherwise, we have a null receive buffer, and the logic all falls down,
goes boom, all ffdc devs wind up as imon IR w/VFD. Oops.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/imon.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index a30bd99..7034207 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2110,18 +2110,6 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 		goto find_endpoint_failed;
 	}
 
-	ictx->idev = imon_init_idev(ictx);
-	if (!ictx->idev) {
-		dev_err(dev, "%s: input device setup failed\n", __func__);
-		goto idev_setup_failed;
-	}
-
-	ictx->rdev = imon_init_rdev(ictx);
-	if (!ictx->rdev) {
-		dev_err(dev, "%s: rc device setup failed\n", __func__);
-		goto rdev_setup_failed;
-	}
-
 	usb_fill_int_urb(ictx->rx_urb_intf0, ictx->usbdev_intf0,
 		usb_rcvintpipe(ictx->usbdev_intf0,
 			ictx->rx_endpoint_intf0->bEndpointAddress),
@@ -2135,13 +2123,25 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 		goto urb_submit_failed;
 	}
 
+	ictx->idev = imon_init_idev(ictx);
+	if (!ictx->idev) {
+		dev_err(dev, "%s: input device setup failed\n", __func__);
+		goto idev_setup_failed;
+	}
+
+	ictx->rdev = imon_init_rdev(ictx);
+	if (!ictx->rdev) {
+		dev_err(dev, "%s: rc device setup failed\n", __func__);
+		goto rdev_setup_failed;
+	}
+
 	return ictx;
 
-urb_submit_failed:
-	rc_unregister_device(ictx->rdev);
 rdev_setup_failed:
 	input_unregister_device(ictx->idev);
 idev_setup_failed:
+	usb_kill_urb(ictx->rx_urb_intf0);
+urb_submit_failed:
 find_endpoint_failed:
 	mutex_unlock(&ictx->lock);
 	usb_free_urb(tx_urb);
-- 
1.7.3.4

