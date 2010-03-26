Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61806 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0CZF0l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 01:26:41 -0400
Received: by gyg13 with SMTP id 13so37824gyg.19
        for <linux-media@vger.kernel.org>; Thu, 25 Mar 2010 22:26:40 -0700 (PDT)
Message-ID: <4BAC60DA.9030606@gmail.com>
Date: Fri, 26 Mar 2010 03:23:06 -0400
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] gspca: Add CONFIG_INPUT to gspca_input_connect()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>

diff --git a/drivers/media/video/gspca/gspca.c 
b/drivers/media/video/gspca/gspca.c
index 1830ea9..df44eca 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -2281,9 +2281,11 @@ int gspca_dev_probe(struct usb_interface *intf,
  		goto out;
  	gspca_set_default_mode(gspca_dev);

+#ifdef CONFIG_INPUT
  	ret = gspca_input_connect(gspca_dev);
  	if (ret)
  		goto out;
+#endif

  	mutex_init(&gspca_dev->usb_lock);
  	mutex_init(&gspca_dev->read_lock);
