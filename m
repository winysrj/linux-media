Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:41827
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459Ab0E0Qku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 12:40:50 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: Markus Demleitner <msdemlei@tucana.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC v2 4/8] dsbr100: remove disconnected indicator
Date: Thu, 27 May 2010 12:39:12 -0400
Message-Id: <1274978356-25836-5-git-send-email-david@identd.dyndns.org>
In-Reply-To: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
References: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
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

