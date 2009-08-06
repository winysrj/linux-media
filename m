Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360AbZHFXBV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 19:01:21 -0400
Message-Id: <200908062301.n76N1FSB029967@imap1.linux-foundation.org>
Subject: [patch 3/9] media: strncpy does not null terminate string
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	roel.kluin@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 06 Aug 2009 16:01:14 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/dvb-usb-i2c.c |    2 +-
 drivers/media/video/pwc/pwc-v4l.c       |    2 +-
 drivers/media/video/zoran/zoran_card.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/dvb-usb-i2c.c~media-strncpy-does-not-null-terminate-string drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
--- a/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c~media-strncpy-does-not-null-terminate-string
+++ a/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
@@ -19,7 +19,7 @@ int dvb_usb_i2c_init(struct dvb_usb_devi
 		return -EINVAL;
 	}
 
-	strncpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
+	strlcpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
 	d->i2c_adap.class = I2C_CLASS_TV_DIGITAL,
 	d->i2c_adap.algo      = d->props.i2c_algo;
 	d->i2c_adap.algo_data = NULL;
diff -puN drivers/media/video/pwc/pwc-v4l.c~media-strncpy-does-not-null-terminate-string drivers/media/video/pwc/pwc-v4l.c
--- a/drivers/media/video/pwc/pwc-v4l.c~media-strncpy-does-not-null-terminate-string
+++ a/drivers/media/video/pwc/pwc-v4l.c
@@ -1033,7 +1033,7 @@ long pwc_video_do_ioctl(struct file *fil
 			if (std->index != 0)
 				return -EINVAL;
 			std->id = V4L2_STD_UNKNOWN;
-			strncpy(std->name, "webcam", sizeof(std->name));
+			strlcpy(std->name, "webcam", sizeof(std->name));
 			return 0;
 		}
 
diff -puN drivers/media/video/zoran/zoran_card.c~media-strncpy-does-not-null-terminate-string drivers/media/video/zoran/zoran_card.c
--- a/drivers/media/video/zoran/zoran_card.c~media-strncpy-does-not-null-terminate-string
+++ a/drivers/media/video/zoran/zoran_card.c
@@ -1169,7 +1169,7 @@ zoran_setup_videocodec (struct zoran *zr
 	m->type = 0;
 
 	m->flags = CODEC_FLAG_ENCODER | CODEC_FLAG_DECODER;
-	strncpy(m->name, ZR_DEVNAME(zr), sizeof(m->name));
+	strlcpy(m->name, ZR_DEVNAME(zr), sizeof(m->name));
 	m->data = zr;
 
 	switch (type)
_
