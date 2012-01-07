Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.enix.org ([193.19.211.146]:35193 "EHLO smtp.enix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2AGOBy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 09:01:54 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	srinivasa.deevi@conexant.com
Cc: gregory.clement@free-electrons.com,
	maxime.ripard@free-electrons.com,
	michael.opdenacker@free-electrons.com
Subject: [PATCH 3/4] cx231xx: remove useless 'lif' variable in cx231xx_usb_probe()
Date: Sat,  7 Jan 2012 14:52:39 +0100
Message-Id: <1325944360-28964-4-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1325944360-28964-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1325944360-28964-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we set the intfdata on the right interface, the 'lif'
variable is useless.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/media/video/cx231xx/cx231xx-cards.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index bfcc8ab..2a28882 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -1016,7 +1016,6 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	int i, isoc_pipe = 0;
 	char *speed;
 	char descr[255] = "";
-	struct usb_interface *lif = NULL;
 	struct usb_interface_assoc_descriptor *assoc_desc;
 
 	udev = usb_get_dev(interface_to_usbdev(interface));
@@ -1071,9 +1070,6 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	/* init CIR module TBD */
 
-	/* store the current interface */
-	lif = interface;
-
 	/*mode_tv: digital=1 or analog=0*/
 	dev->mode_tv = 0;
 
@@ -1113,9 +1109,6 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	     le16_to_cpu(udev->descriptor.idProduct),
 	     dev->max_iad_interface_count);
 
-	/* store the interface 0 back */
-	lif = udev->actconfig->interface[0];
-
 	/* increment interface count */
 	dev->interface_count++;
 
-- 
1.7.4.1

