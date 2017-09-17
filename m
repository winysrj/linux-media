Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:59728 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbdIQURU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 16:17:20 -0400
Subject: [PATCH 1/8] [media] cx231xx: Delete eight error messages for a failed
 memory allocation
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Johan Hovold <johan@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Message-ID: <dd754a24-d113-2b6b-5f5c-01e9e6454ad9@users.sourceforge.net>
Date: Sun, 17 Sep 2017 22:16:50 +0200
MIME-Version: 1.0
In-Reply-To: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 17:43:47 +0200

Omit extra messages for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 14 ++------------
 drivers/media/usb/cx231xx/cx231xx-dvb.c  |  7 ++-----
 drivers/media/usb/cx231xx/cx231xx-vbi.c  | 11 +----------
 3 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index f372ad3917a8..d9f4ae50e869 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1038,12 +1038,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
-	if (!dev->video_mode.isoc_ctl.urb) {
-		dev_err(dev->dev,
-			"cannot alloc memory for usb buffers\n");
+	if (!dev->video_mode.isoc_ctl.urb)
 		return -ENOMEM;
-	}
 
 	dev->video_mode.isoc_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.isoc_ctl.transfer_buffer) {
-		dev_err(dev->dev,
-			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.isoc_ctl.urb);
@@ -1173,12 +1168,7 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
-	if (!dev->video_mode.bulk_ctl.urb) {
-		dev_err(dev->dev,
-			"cannot alloc memory for usb buffers\n");
+	if (!dev->video_mode.bulk_ctl.urb)
 		return -ENOMEM;
-	}
 
 	dev->video_mode.bulk_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->video_mode.bulk_ctl.transfer_buffer) {
-		dev_err(dev->dev,
-			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.bulk_ctl.urb);
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index c18bb33e060e..248b62e2099c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -618,9 +618,6 @@ static int dvb_init(struct cx231xx *dev)
-
-	if (dvb == NULL) {
-		dev_info(dev->dev,
-			 "cx231xx_dvb: memory allocation failed\n");
+	if (!dvb)
 		return -ENOMEM;
-	}
+
 	dev->dvb = dvb;
 	dev->cx231xx_set_analog_freq = cx231xx_set_analog_freq;
 	dev->cx231xx_reset_analog_tuner = cx231xx_reset_analog_tuner;
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 76e901920f6f..9c27db16db2a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -420,12 +420,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
-	if (!dev->vbi_mode.bulk_ctl.urb) {
-		dev_err(dev->dev,
-			"cannot alloc memory for usb buffers\n");
+	if (!dev->vbi_mode.bulk_ctl.urb)
 		return -ENOMEM;
-	}
 
 	dev->vbi_mode.bulk_ctl.transfer_buffer =
 	    kzalloc(sizeof(void *) * num_bufs, GFP_KERNEL);
 	if (!dev->vbi_mode.bulk_ctl.transfer_buffer) {
-		dev_err(dev->dev,
-			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->vbi_mode.bulk_ctl.urb);
@@ -453,8 +448,4 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 		if (!dev->vbi_mode.bulk_ctl.transfer_buffer[i]) {
-			dev_err(dev->dev,
-				"unable to allocate %i bytes for transfer buffer %i%s\n",
-				sb_size, i,
-				in_interrupt() ? " while in int" : "");
 			cx231xx_uninit_vbi_isoc(dev);
 			return -ENOMEM;
 		}
-- 
2.14.1
