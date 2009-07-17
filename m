Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:53038 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964790AbZGQPjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 11:39:39 -0400
Received: by ewy26 with SMTP id 26so952373ewy.37
        for <linux-media@vger.kernel.org>; Fri, 17 Jul 2009 08:39:38 -0700 (PDT)
Message-ID: <4A609BAA.6090204@gmail.com>
Date: Fri, 17 Jul 2009 17:41:30 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] media: strncpy does not null terminate string
References: <4A607185.6020302@gmail.com>
In-Reply-To: <4A607185.6020302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c b/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
index 326f760..cead089 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
@@ -19,7 +19,7 @@ int dvb_usb_i2c_init(struct dvb_usb_device *d)
 		return -EINVAL;
 	}
 
-	strncpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
+	strlcpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
 	d->i2c_adap.class = I2C_CLASS_TV_DIGITAL,
 	d->i2c_adap.algo      = d->props.i2c_algo;
 	d->i2c_adap.algo_data = NULL;
diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index 2876ce0..bdb4ced 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -1033,7 +1033,7 @@ long pwc_video_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			if (std->index != 0)
 				return -EINVAL;
 			std->id = V4L2_STD_UNKNOWN;
-			strncpy(std->name, "webcam", sizeof(std->name));
+			strlcpy(std->name, "webcam", sizeof(std->name));
 			return 0;
 		}
 
diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
index 03dc2f3..9f43695 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -1169,7 +1169,7 @@ zoran_setup_videocodec (struct zoran *zr,
 	m->type = 0;
 
 	m->flags = CODEC_FLAG_ENCODER | CODEC_FLAG_DECODER;
-	strncpy(m->name, ZR_DEVNAME(zr), sizeof(m->name));
+	strlcpy(m->name, ZR_DEVNAME(zr), sizeof(m->name));
 	m->data = zr;
 
 	switch (type)
