Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54597 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaG0T1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 15:27:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 2/6] cx231xx: Don't let an interface number to go past the array
Date: Sun, 27 Jul 2014 16:27:28 -0300
Message-Id: <1406489252-30636-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
References: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some newer boards, like HVR-930C HD, the information at
the PCB tables are sometimes higher than the ones actually
available on the device. That causes the probing code to
go past the interfaces array.

Add checks to the interface number before going past the
array.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 42 ++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index d40284536beb..499d395544cd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1275,6 +1275,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	int nr = 0, ifnum;
 	int i, isoc_pipe = 0;
 	char *speed;
+	u8 idx;
 	struct usb_interface_assoc_descriptor *assoc_desc;
 
 	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
@@ -1394,8 +1395,13 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		goto err_init;
 
 	/* compute alternate max packet sizes for video */
-	uif = udev->actconfig->interface[dev->current_pcb_config.
-		       hs_config_info[0].interface_info.video_index + 1];
+	idx = dev->current_pcb_config.hs_config_info[0].interface_info.video_index + 1;
+	if (idx >= dev->max_iad_interface_count) {
+		cx231xx_errdev("Video PCB interface #%d doesn't exist\n", idx);
+		retval = -ENODEV;
+		goto err_init;
+	}
+	uif = udev->actconfig->interface[idx];
 
 	dev->video_mode.end_point_addr = uif->altsetting[0].
 			endpoint[isoc_pipe].desc.bEndpointAddress;
@@ -1423,9 +1429,14 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	}
 
 	/* compute alternate max packet sizes for vbi */
-	uif = udev->actconfig->interface[dev->current_pcb_config.
-				       hs_config_info[0].interface_info.
-				       vanc_index + 1];
+
+	idx = dev->current_pcb_config.hs_config_info[0].interface_info.vanc_index + 1;
+	if (idx >= dev->max_iad_interface_count) {
+		cx231xx_errdev("VBI PCB interface #%d doesn't exist\n", idx);
+		retval = -ENODEV;
+		goto err_vbi_alt;
+	}
+	uif = udev->actconfig->interface[idx];
 
 	dev->vbi_mode.end_point_addr =
 	    uif->altsetting[0].endpoint[isoc_pipe].desc.
@@ -1455,9 +1466,13 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	}
 
 	/* compute alternate max packet sizes for sliced CC */
-	uif = udev->actconfig->interface[dev->current_pcb_config.
-				       hs_config_info[0].interface_info.
-				       hanc_index + 1];
+	idx = dev->current_pcb_config.hs_config_info[0].interface_info.hanc_index + 1;
+	if (idx >= dev->max_iad_interface_count) {
+		cx231xx_errdev("Sliced CC PCB interface #%d doesn't exist\n", idx);
+		retval = -ENODEV;
+		goto err_sliced_cc_alt;
+	}
+	uif = udev->actconfig->interface[idx];
 
 	dev->sliced_cc_mode.end_point_addr =
 	    uif->altsetting[0].endpoint[isoc_pipe].desc.
@@ -1487,10 +1502,13 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	if (dev->current_pcb_config.ts1_source != 0xff) {
 		/* compute alternate max packet sizes for TS1 */
-		uif = udev->actconfig->interface[dev->current_pcb_config.
-					       hs_config_info[0].
-					       interface_info.
-					       ts1_index + 1];
+		idx = dev->current_pcb_config.hs_config_info[0].interface_info.ts1_index + 1;
+		if (idx >= dev->max_iad_interface_count) {
+			cx231xx_errdev("TS1 PCB interface #%d doesn't exist\n", idx);
+			retval = -ENODEV;
+			goto err_ts1_alt;
+		}
+		uif = udev->actconfig->interface[idx];
 
 		dev->ts1_mode.end_point_addr =
 		    uif->altsetting[0].endpoint[isoc_pipe].
-- 
1.9.3

