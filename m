Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab2AZQEU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 11:04:20 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, stable@vger.kernel.org,
	Corinna Vinschen <vinschen@redhat.com>
Subject: [PATCH] imon: don't wedge hardware after early callbacks
Date: Thu, 26 Jan 2012 11:04:11 -0500
Message-Id: <1327593851-5511-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1327592027-4999-1-git-send-email-jarod@redhat.com>
References: <1327592027-4999-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is just a minor update to one titled "imon: Input from ffdc
device type ignored" from Corinna Vinschen. An earlier patch to prevent
an oops when we got early callbacks also has the nasty side-effect of
wedging imon hardware, as we don't acknowledge the urb. Rework the check
slightly here to bypass processing the packet, as the driver isn't yet
fully initialized, but still acknowlege the urb and submit a new rx_urb.
Do this for both interfaces -- irrelevant for ffdc hardware, but
relevant for newer hardware, though newer hardware doesn't spew the
constant stream of data as soon as the hardware is initialized like the
older ffdc devices, so they'd be less likely to trigger this anyway...

Tested with both an ffdc device and an 0042 device.

v2: Per Corinna's suggestion and prior precedent, increment driver
version number so we can more easily tell if a user has this fix.

v3: cc stable, as this fixes a functional regression in 3.2

CC: stable@vger.kernel.org
CC: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/imon.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 6ed9646..3f175eb 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -47,7 +47,7 @@
 #define MOD_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
 #define MOD_DESC	"Driver for SoundGraph iMON MultiMedia IR/Display"
 #define MOD_NAME	"imon"
-#define MOD_VERSION	"0.9.3"
+#define MOD_VERSION	"0.9.4"
 
 #define DISPLAY_MINOR_BASE	144
 #define DEVICE_NAME	"lcd%d"
@@ -1658,9 +1658,17 @@ static void usb_rx_callback_intf0(struct urb *urb)
 		return;
 
 	ictx = (struct imon_context *)urb->context;
-	if (!ictx || !ictx->dev_present_intf0)
+	if (!ictx)
 		return;
 
+	/*
+	 * if we get a callback before we're done configuring the hardware, we
+	 * can't yet process the data, as there's nowhere to send it, but we
+	 * still need to submit a new rx URB to avoid wedging the hardware
+	 */
+	if (!ictx->dev_present_intf0)
+		goto out;
+
 	switch (urb->status) {
 	case -ENOENT:		/* usbcore unlink successful! */
 		return;
@@ -1678,6 +1686,7 @@ static void usb_rx_callback_intf0(struct urb *urb)
 		break;
 	}
 
+out:
 	usb_submit_urb(ictx->rx_urb_intf0, GFP_ATOMIC);
 }
 
@@ -1690,9 +1699,17 @@ static void usb_rx_callback_intf1(struct urb *urb)
 		return;
 
 	ictx = (struct imon_context *)urb->context;
-	if (!ictx || !ictx->dev_present_intf1)
+	if (!ictx)
 		return;
 
+	/*
+	 * if we get a callback before we're done configuring the hardware, we
+	 * can't yet process the data, as there's nowhere to send it, but we
+	 * still need to submit a new rx URB to avoid wedging the hardware
+	 */
+	if (!ictx->dev_present_intf1)
+		goto out;
+
 	switch (urb->status) {
 	case -ENOENT:		/* usbcore unlink successful! */
 		return;
@@ -1710,6 +1727,7 @@ static void usb_rx_callback_intf1(struct urb *urb)
 		break;
 	}
 
+out:
 	usb_submit_urb(ictx->rx_urb_intf1, GFP_ATOMIC);
 }
 
@@ -2242,7 +2260,7 @@ find_endpoint_failed:
 	mutex_unlock(&ictx->lock);
 	usb_free_urb(rx_urb);
 rx_urb_alloc_failed:
-	dev_err(ictx->dev, "unable to initialize intf0, err %d\n", ret);
+	dev_err(ictx->dev, "unable to initialize intf1, err %d\n", ret);
 
 	return NULL;
 }
-- 
1.7.1

