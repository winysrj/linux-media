Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39242 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915AbZC0Jd7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 05:33:59 -0400
Message-ID: <49CC9DEF.8020009@redhat.com>
Date: Fri, 27 Mar 2009 10:35:43 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org,
	Ricardo Jorge da Fonseca Marques Ferreira
	<storm@sys49152.net>
Subject: [PATCH]: gspca: use usb interface as parent
Content-Type: multipart/mixed;
 boundary="------------000400080905020709020107"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000400080905020709020107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

As discussed in the:
"v4l parent for usb device interface or device?"
thread, here is a patch for gspca to make it use
the usb interface as its parent device, instead
of the usb device.

Regards,

Hans

p.s.

I'll also push a patch to my libv4l repo, with
matching libv4l changes so that libv4l's upside
down cam detections stays working with this change.

Note: this libv4l patch also fixes libv4l upside
down detection for the new device numbering style.

--------------000400080905020709020107
Content-Type: text/plain;
 name="gspca-use-usb-interface-as-parent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gspca-use-usb-interface-as-parent.patch"

diff -r c28651a2c2c3 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Thu Mar 26 09:44:15 2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Fri Mar 27 10:32:24 2009 +0100
@@ -1958,7 +1958,7 @@
 
 	/* init video stuff */
 	memcpy(&gspca_dev->vdev, &gspca_template, sizeof gspca_template);
-	gspca_dev->vdev.parent = &dev->dev;
+	gspca_dev->vdev.parent = &intf->dev;
 	gspca_dev->module = module;
 	gspca_dev->present = 1;
 	ret = video_register_device(&gspca_dev->vdev,

--------------000400080905020709020107--
