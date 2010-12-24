Return-path: <mchehab@gaivota>
Received: from banach.math.auburn.edu ([131.204.45.3]:50747 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0LXT3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 14:29:46 -0500
Date: Fri, 24 Dec 2010 14:06:04 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Adds the Lego Bionicle to existing sq905c
In-Reply-To: <4D14ABEE.40206@redhat.com>
Message-ID: <alpine.LNX.2.00.1012241358210.29054@banach.math.auburn.edu>
References: <4D11E170.6050500@redhat.com> <4D14ABEE.40206@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch adds the Vendor:Product number of the Lego Bionicle camera to
the existing gspca/sq905c.c and also a line for the camera in gspca.txt.
The camera works "out of the box" with these small changes. So this is 
just in time for Christmas. Think of the children.

Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>

---------------------------------------------
diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
index 6a562ee..261776e 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -366,6 +366,7 @@ t613		17a1:0128	TASCORP JPEG Webcam, NGS Cyclops
 vc032x		17ef:4802	Lenovo Vc0323+MI1310_SOC
 pac207		2001:f115	D-Link DSB-C120
 sq905c		2770:9050	Disney pix micro (CIF)
+sq905c		2770:9051	Lego Bionicle
 sq905c		2770:9052	Disney pix micro 2 (VGA)
 sq905c		2770:905c	All 11 known cameras with this ID
 sq905		2770:9120	All 24 known cameras with this ID
diff --git a/drivers/media/video/gspca/sq905c.c b/drivers/media/video/gspca/sq905c.c
index c2e88b5..8ba1995 100644
--- a/drivers/media/video/gspca/sq905c.c
+++ b/drivers/media/video/gspca/sq905c.c
@@ -301,6 +301,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 static const __devinitdata struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x2770, 0x905c)},
 	{USB_DEVICE(0x2770, 0x9050)},
+	{USB_DEVICE(0x2770, 0x9051)},
 	{USB_DEVICE(0x2770, 0x9052)},
 	{USB_DEVICE(0x2770, 0x913d)},
 	{}

