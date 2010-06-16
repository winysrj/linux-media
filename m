Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab0FPUHl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 16:07:41 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5GK7fhk008717
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 16:07:41 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o5GK7esr005002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 16:07:41 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o5GK7dY6009786
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 16:07:40 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o5GK7d00009784
	for linux-media@vger.kernel.org; Wed, 16 Jun 2010 16:07:39 -0400
Date: Wed, 16 Jun 2010 16:07:39 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/imon: use the proper ir-core device unregister function
Message-ID: <20100616200739.GA9781@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Was using input_unregister_device directly, instead of using
ir_input_unregister, which tears down a bunch of other things in
addition to eventually calling input_unregister_device.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 5e20456..4b1fe9b 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -1941,7 +1941,7 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 	return ictx;
 
 urb_submit_failed:
-	input_unregister_device(ictx->idev);
+	ir_input_unregister(ictx->idev);
 	input_free_device(ictx->idev);
 idev_setup_failed:
 find_endpoint_failed:
@@ -2299,7 +2299,7 @@ static void __devexit imon_disconnect(struct usb_interface *interface)
 	if (ifnum == 0) {
 		ictx->dev_present_intf0 = 0;
 		usb_kill_urb(ictx->rx_urb_intf0);
-		input_unregister_device(ictx->idev);
+		ir_input_unregister(ictx->idev);
 		if (ictx->display_supported) {
 			if (ictx->display_type == IMON_DISPLAY_TYPE_LCD)
 				usb_deregister_dev(interface, &imon_lcd_class);
-- 
1.6.5.2

-- 
Jarod Wilson
jarod@redhat.com

