Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62562 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZDWFi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 01:38:57 -0400
Received: by ewy24 with SMTP id 24so330424ewy.37
        for <linux-media@vger.kernel.org>; Wed, 22 Apr 2009 22:38:55 -0700 (PDT)
Date: Thu, 23 Apr 2009 15:40:46 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] FM1216ME_MK3 AUX byte for FM mode
Message-ID: <20090423154046.7b54f7cc@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Gwq3G9pRUJuzf//2RRBtERO"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/Gwq3G9pRUJuzf//2RRBtERO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Write AUX byte to FM1216ME_MK3 when FM mode, better sensitivity. It can be
usefull for other tuners.

diff -r 00a84f86671d linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Mon Apr 20 22:07:44 2009 +0000
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Thu Apr 23 10:26:54 2009 +1000
@@ -751,6 +751,17 @@
 	if (4 != rc)
 		tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
 
+	/* Write AUX byte */
+	switch (priv->type) {
+	case TUNER_PHILIPS_FM1216ME_MK3:
+		buffer[2] = 0x98;
+		buffer[3] = 0x20; /* set TOP AGC */
+		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
+		if (4 != rc)
+			tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
+		break;
+	}
+
 	return 0;
 }
 
Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/Gwq3G9pRUJuzf//2RRBtERO
Content-Type: text/x-patch; name=behold_mk3_fm.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_mk3_fm.patch

diff -r 00a84f86671d linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Mon Apr 20 22:07:44 2009 +0000
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Thu Apr 23 10:26:54 2009 +1000
@@ -751,6 +751,17 @@
 	if (4 != rc)
 		tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
 
+	/* Write AUX byte */
+	switch (priv->type) {
+	case TUNER_PHILIPS_FM1216ME_MK3:
+		buffer[2] = 0x98;
+		buffer[3] = 0x20; /* set TOP AGC */
+		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
+		if (4 != rc)
+			tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
+		break;
+	}
+
 	return 0;
 }
 
Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/Gwq3G9pRUJuzf//2RRBtERO--
