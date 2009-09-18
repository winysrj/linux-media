Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:2238 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758704AbZIRXDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 19:03:12 -0400
Received: by ey-out-2122.google.com with SMTP id 4so226419eyf.5
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 16:03:15 -0700 (PDT)
Message-ID: <4AB41364.20106@gmail.com>
Date: Sat, 19 Sep 2009 01:10:28 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] V4L/DVB (7969): kmalloc failure ignored in m920x_firmware_download()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevent NULL dereference if kmalloc() fails.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with sed: http://kernelnewbies.org/roelkluin

Build tested.

diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index aec7a19..ef9b7be 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -337,6 +337,8 @@ static int m920x_firmware_download(struct usb_device *udev, const struct firmwar
 	int i, pass, ret = 0;
 
 	buff = kmalloc(65536, GFP_KERNEL);
+	if (buff == NULL)
+		return -ENOMEM;
 
 	if ((ret = m920x_read(udev, M9206_FILTER, 0x0, 0x8000, read, 4)) != 0)
 		goto done;
