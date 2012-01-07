Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.enix.org ([193.19.211.146]:35194 "EHLO smtp.enix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab2AGOBz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 09:01:55 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	srinivasa.deevi@conexant.com
Cc: gregory.clement@free-electrons.com,
	maxime.ripard@free-electrons.com,
	michael.opdenacker@free-electrons.com
Subject: [PATCH 4/4] cx231xx: simplify argument passing to cx231xx_init_dev()
Date: Sat,  7 Jan 2012 14:52:40 +0100
Message-Id: <1325944360-28964-5-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1325944360-28964-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1325944360-28964-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'struct cx231xx *' pointer was passed by reference to the
cx231xx_init_dev() function, for no reason. Instead, just pass it by
value, which is much more logical and simple.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/media/video/cx231xx/cx231xx-cards.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 2a28882..6dbf2da 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -858,10 +858,9 @@ void cx231xx_release_resources(struct cx231xx *dev)
  * cx231xx_init_dev()
  * allocates and inits the device structs, registers i2c bus and v4l device
  */
-static int cx231xx_init_dev(struct cx231xx **devhandle, struct usb_device *udev,
+static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 			    int minor)
 {
-	struct cx231xx *dev = *devhandle;
 	int retval = -ENOMEM;
 	int errCode;
 	unsigned int maxh, maxw;
@@ -1144,7 +1143,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		return -EIO;
 	}
 	/* allocate device struct */
-	retval = cx231xx_init_dev(&dev, udev, nr);
+	retval = cx231xx_init_dev(dev, udev, nr);
 	if (retval) {
 		cx231xx_devused &= ~(1 << dev->devno);
 		v4l2_device_unregister(&dev->v4l2_dev);
-- 
1.7.4.1

