Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:48165
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab0EERhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 13:37:20 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC 4/7] dsbr100: remove disconnected indicator
Date: Wed,  5 May 2010 13:05:27 -0400
Message-Id: <1273079130-21999-5-git-send-email-david@identd.dyndns.org>
In-Reply-To: <1273079130-21999-1-git-send-email-david@identd.dyndns.org>
References: <1273079130-21999-1-git-send-email-david@identd.dyndns.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/dsbr100.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index b62fe40..c949ace 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -151,7 +151,6 @@ struct dsbr100_device {
 	struct mutex lock;	/* buffer locking */
 	int curfreq;
 	int stereo;
-	int removed;
 	int status;
 };
 
@@ -353,7 +352,7 @@ static void usb_dsbr100_disconnect(struct usb_interface *intf)
 	usb_set_intfdata (intf, NULL);
 
 	mutex_lock(&radio->lock);
-	radio->removed = 1;
+	radio->usbdev = NULL;
 	mutex_unlock(&radio->lock);
 
 	v4l2_device_disconnect(&radio->v4l2_dev);
@@ -521,7 +520,7 @@ static long usb_dsbr100_ioctl(struct file *file, unsigned int cmd,
 
 	mutex_lock(&radio->lock);
 
-	if (radio->removed) {
+	if (!radio->usbdev) {
 		retval = -EIO;
 		goto unlock;
 	}
@@ -649,7 +648,6 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 
 	mutex_init(&radio->lock);
 
-	radio->removed = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = FREQ_MIN * FREQ_MUL;
 	radio->status = STOPPED;
-- 
1.7.1

