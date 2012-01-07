Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:42099 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2AGOSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 09:18:54 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-media@vger.kernel.org, mchehab@infradead.org,
	dheitmueller@kernellabs.com, rankincj@yahoo.com, crope@iki.fi,
	jarod@redhat.com
Cc: gregory.clement@free-electrons.com,
	maxime.ripard@free-electrons.com,
	michael.opdenacker@free-electrons.com
Subject: [PATCH] em28xx: simplify argument passing to em28xx_init_dev()
Date: Sat,  7 Jan 2012 15:18:45 +0100
Message-Id: <1325945925-3645-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'struct em28xx *' pointer was passed by reference to the
em28xx_init_dev() function, for no reason. Instead, just pass it by
value, which is much more logical and simple.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 9b747c2..789054d 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2832,11 +2832,10 @@ void em28xx_release_resources(struct em28xx *dev)
  * em28xx_init_dev()
  * allocates and inits the device structs, registers i2c bus and v4l device
  */
-static int em28xx_init_dev(struct em28xx **devhandle, struct usb_device *udev,
+static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			   struct usb_interface *interface,
 			   int minor)
 {
-	struct em28xx *dev = *devhandle;
 	int retval;
 
 	dev->udev = udev;
@@ -3226,7 +3225,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	/* allocate device struct */
 	mutex_init(&dev->lock);
 	mutex_lock(&dev->lock);
-	retval = em28xx_init_dev(&dev, udev, interface, nr);
+	retval = em28xx_init_dev(dev, udev, interface, nr);
 	if (retval) {
 		mutex_unlock(&dev->lock);
 		kfree(dev->alt_max_pkt_size);
-- 
1.7.4.1

