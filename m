Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbaG0T1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 15:27:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 5/6] cx231xx: move analog init code to a separate function
Date: Sun, 27 Jul 2014 16:27:31 -0300
Message-Id: <1406489252-30636-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
References: <1406489252-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That makes easier to understand the code. It would also help
to add support for having boards with just digital support
on some latter patch, as allowed by some PCB configs.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 220 ++++++++++++++++--------------
 1 file changed, 114 insertions(+), 106 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 3f0e309a54d8..338417fee8b6 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1262,6 +1262,117 @@ static void flush_request_modules(struct cx231xx *dev)
 #define flush_request_modules(dev)
 #endif /* CONFIG_MODULES */
 
+static int cx231xx_init_v4l2(struct cx231xx *dev,
+			     struct usb_device *udev,
+			     struct usb_interface *interface,
+			     int isoc_pipe)
+{
+	struct usb_interface *uif;
+	int i, idx;
+
+	/* Video Init */
+
+	/* compute alternate max packet sizes for video */
+	idx = dev->current_pcb_config.hs_config_info[0].interface_info.video_index + 1;
+	if (idx >= dev->max_iad_interface_count) {
+		cx231xx_errdev("Video PCB interface #%d doesn't exist\n", idx);
+		return -ENODEV;
+	}
+
+	uif = udev->actconfig->interface[idx];
+
+	dev->video_mode.end_point_addr = uif->altsetting[0].endpoint[isoc_pipe].desc.bEndpointAddress;
+	dev->video_mode.num_alt = uif->num_altsetting;
+
+	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+		     dev->video_mode.end_point_addr,
+		     dev->video_mode.num_alt);
+
+	dev->video_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->video_mode.num_alt, GFP_KERNEL);
+	if (dev->video_mode.alt_max_pkt_size == NULL) {
+		cx231xx_errdev("out of memory!\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < dev->video_mode.num_alt; i++) {
+		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
+		dev->video_mode.alt_max_pkt_size[i] = (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
+		cx231xx_info("Alternate setting %i, max size= %i\n", i,
+			     dev->video_mode.alt_max_pkt_size[i]);
+	}
+
+	/* VBI Init */
+
+	idx = dev->current_pcb_config.hs_config_info[0].interface_info.vanc_index + 1;
+	if (idx >= dev->max_iad_interface_count) {
+		cx231xx_errdev("VBI PCB interface #%d doesn't exist\n", idx);
+		return -ENODEV;
+	}
+	uif = udev->actconfig->interface[idx];
+
+	dev->vbi_mode.end_point_addr =
+	    uif->altsetting[0].endpoint[isoc_pipe].desc.
+			bEndpointAddress;
+
+	dev->vbi_mode.num_alt = uif->num_altsetting;
+	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+		     dev->vbi_mode.end_point_addr,
+		     dev->vbi_mode.num_alt);
+
+	/* compute alternate max packet sizes for vbi */
+	dev->vbi_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->vbi_mode.num_alt, GFP_KERNEL);
+	if (dev->vbi_mode.alt_max_pkt_size == NULL) {
+		cx231xx_errdev("out of memory!\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < dev->vbi_mode.num_alt; i++) {
+		u16 tmp =
+		    le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
+				desc.wMaxPacketSize);
+		dev->vbi_mode.alt_max_pkt_size[i] =
+		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
+		cx231xx_info("Alternate setting %i, max size= %i\n", i,
+			     dev->vbi_mode.alt_max_pkt_size[i]);
+	}
+
+	/* Sliced CC VBI init */
+
+	/* compute alternate max packet sizes for sliced CC */
+	idx = dev->current_pcb_config.hs_config_info[0].interface_info.hanc_index + 1;
+	if (idx >= dev->max_iad_interface_count) {
+		cx231xx_errdev("Sliced CC PCB interface #%d doesn't exist\n", idx);
+		return -ENODEV;
+	}
+	uif = udev->actconfig->interface[idx];
+
+	dev->sliced_cc_mode.end_point_addr =
+	    uif->altsetting[0].endpoint[isoc_pipe].desc.
+			bEndpointAddress;
+
+	dev->sliced_cc_mode.num_alt = uif->num_altsetting;
+	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
+		     dev->sliced_cc_mode.end_point_addr,
+		     dev->sliced_cc_mode.num_alt);
+	dev->sliced_cc_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->sliced_cc_mode.num_alt, GFP_KERNEL);
+
+	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL) {
+		cx231xx_errdev("out of memory!\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < dev->sliced_cc_mode.num_alt; i++) {
+		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
+				desc.wMaxPacketSize);
+		dev->sliced_cc_mode.alt_max_pkt_size[i] =
+		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
+		cx231xx_info("Alternate setting %i, max size= %i\n", i,
+			     dev->sliced_cc_mode.alt_max_pkt_size[i]);
+	}
+
+	return 0;
+}
+
 /*
  * cx231xx_usb_probe()
  * checks for supported devices
@@ -1379,124 +1490,21 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
 
-	/*
-	 * AV device initialization - only done at the last interface
-	 */
-
 	/* Create v4l2 device */
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		cx231xx_errdev("v4l2_device_register failed\n");
-		retval = -EIO;
 		goto err_v4l2;
 	}
+
 	/* allocate device struct */
 	retval = cx231xx_init_dev(dev, udev, nr);
 	if (retval)
 		goto err_init;
 
-	/* compute alternate max packet sizes for video */
-	idx = dev->current_pcb_config.hs_config_info[0].interface_info.video_index + 1;
-	if (idx >= dev->max_iad_interface_count) {
-		cx231xx_errdev("Video PCB interface #%d doesn't exist\n", idx);
-		retval = -ENODEV;
+	retval = cx231xx_init_v4l2(dev, udev, interface, isoc_pipe);
+	if (retval)
 		goto err_init;
-	}
-	uif = udev->actconfig->interface[idx];
-
-	dev->video_mode.end_point_addr = uif->altsetting[0].
-			endpoint[isoc_pipe].desc.bEndpointAddress;
-
-	dev->video_mode.num_alt = uif->num_altsetting;
-	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
-		     dev->video_mode.end_point_addr,
-		     dev->video_mode.num_alt);
-
-	dev->video_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->video_mode.num_alt, GFP_KERNEL);
-	if (dev->video_mode.alt_max_pkt_size == NULL) {
-		cx231xx_errdev("out of memory!\n");
-		retval = -ENOMEM;
-		goto err_video_alt;
-	}
-
-	for (i = 0; i < dev->video_mode.num_alt; i++) {
-		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
-				desc.wMaxPacketSize);
-		dev->video_mode.alt_max_pkt_size[i] =
-		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		cx231xx_info("Alternate setting %i, max size= %i\n", i,
-			     dev->video_mode.alt_max_pkt_size[i]);
-	}
-
-	/* compute alternate max packet sizes for vbi */
-
-	idx = dev->current_pcb_config.hs_config_info[0].interface_info.vanc_index + 1;
-	if (idx >= dev->max_iad_interface_count) {
-		cx231xx_errdev("VBI PCB interface #%d doesn't exist\n", idx);
-		retval = -ENODEV;
-		goto err_video_alt;
-	}
-	uif = udev->actconfig->interface[idx];
-
-	dev->vbi_mode.end_point_addr =
-	    uif->altsetting[0].endpoint[isoc_pipe].desc.
-			bEndpointAddress;
-
-	dev->vbi_mode.num_alt = uif->num_altsetting;
-	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
-		     dev->vbi_mode.end_point_addr,
-		     dev->vbi_mode.num_alt);
-
-	dev->vbi_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->vbi_mode.num_alt, GFP_KERNEL);
-	if (dev->vbi_mode.alt_max_pkt_size == NULL) {
-		cx231xx_errdev("out of memory!\n");
-		retval = -ENOMEM;
-		goto err_video_alt;
-	}
-
-	for (i = 0; i < dev->vbi_mode.num_alt; i++) {
-		u16 tmp =
-		    le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
-				desc.wMaxPacketSize);
-		dev->vbi_mode.alt_max_pkt_size[i] =
-		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		cx231xx_info("Alternate setting %i, max size= %i\n", i,
-			     dev->vbi_mode.alt_max_pkt_size[i]);
-	}
-
-	/* compute alternate max packet sizes for sliced CC */
-	idx = dev->current_pcb_config.hs_config_info[0].interface_info.hanc_index + 1;
-	if (idx >= dev->max_iad_interface_count) {
-		cx231xx_errdev("Sliced CC PCB interface #%d doesn't exist\n", idx);
-		retval = -ENODEV;
-		goto err_video_alt;
-	}
-	uif = udev->actconfig->interface[idx];
-
-	dev->sliced_cc_mode.end_point_addr =
-	    uif->altsetting[0].endpoint[isoc_pipe].desc.
-			bEndpointAddress;
-
-	dev->sliced_cc_mode.num_alt = uif->num_altsetting;
-	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
-		     dev->sliced_cc_mode.end_point_addr,
-		     dev->sliced_cc_mode.num_alt);
-	dev->sliced_cc_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->sliced_cc_mode.num_alt, GFP_KERNEL);
-
-	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL) {
-		cx231xx_errdev("out of memory!\n");
-		retval = -ENOMEM;
-		goto err_video_alt;
-	}
-
-	for (i = 0; i < dev->sliced_cc_mode.num_alt; i++) {
-		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
-				desc.wMaxPacketSize);
-		dev->sliced_cc_mode.alt_max_pkt_size[i] =
-		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-		cx231xx_info("Alternate setting %i, max size= %i\n", i,
-			     dev->sliced_cc_mode.alt_max_pkt_size[i]);
-	}
 
 	if (dev->current_pcb_config.ts1_source != 0xff) {
 		/* compute alternate max packet sizes for TS1 */
-- 
1.9.3

