Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41057 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbaCXKN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 06:13:59 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so5236218pab.36
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 03:13:59 -0700 (PDT)
Message-ID: <53300566.c947440a.1a01.1b19@mx.google.com>
From: Mike Sampson <mike@sambodata.com>
To: Luca Risolia <luca.risolia@studio.unibo.it>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org
CC: linux-media@vger.kernel.org
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
CC: trivial@kernel.org
Date: Mon, 24 Mar 2014 20:04:49 +1100
Subject: [PATCH] next-20140324 drivers/staging/media/sn9c102/sn9c102_hv7131r.c fix style warnings flagged by checkpatch.pl.
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mike Sampson <mike@sambodata.com>

---
 drivers/staging/media/sn9c102/sn9c102_hv7131r.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/sn9c102/sn9c102_hv7131r.c b/drivers/staging/media/sn9c102/sn9c102_hv7131r.c
index 26a9111..51b24e0 100644
--- a/drivers/staging/media/sn9c102/sn9c102_hv7131r.c
+++ b/drivers/staging/media/sn9c102/sn9c102_hv7131r.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"
 
 
-static int hv7131r_init(struct sn9c102_device* cam)
+static int hv7131r_init(struct sn9c102_device *cam)
 {
 	int err = 0;
 
@@ -137,8 +137,8 @@ static int hv7131r_init(struct sn9c102_device* cam)
 }
 
 
-static int hv7131r_get_ctrl(struct sn9c102_device* cam,
-			    struct v4l2_control* ctrl)
+static int hv7131r_get_ctrl(struct sn9c102_device *cam,
+			    struct v4l2_control *ctrl)
 {
 	switch (ctrl->id) {
 	case V4L2_CID_GAIN:
@@ -176,8 +176,8 @@ static int hv7131r_get_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int hv7131r_set_ctrl(struct sn9c102_device* cam,
-			    const struct v4l2_control* ctrl)
+static int hv7131r_set_ctrl(struct sn9c102_device *cam,
+			    const struct v4l2_control *ctrl)
 {
 	int err = 0;
 
@@ -197,6 +197,7 @@ static int hv7131r_set_ctrl(struct sn9c102_device* cam,
 	case V4L2_CID_BLACK_LEVEL:
 		{
 			int r = sn9c102_i2c_read(cam, 0x01);
+
 			if (r < 0)
 				return -EIO;
 			err += sn9c102_i2c_write(cam, 0x01,
@@ -211,10 +212,10 @@ static int hv7131r_set_ctrl(struct sn9c102_device* cam,
 }
 
 
-static int hv7131r_set_crop(struct sn9c102_device* cam,
-			    const struct v4l2_rect* rect)
+static int hv7131r_set_crop(struct sn9c102_device *cam,
+			    const struct v4l2_rect *rect)
 {
-	struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+	struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
 	int err = 0;
 	u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 1,
 	   v_start = (u8)(rect->top - s->cropcap.bounds.top) + 1;
@@ -226,8 +227,8 @@ static int hv7131r_set_crop(struct sn9c102_device* cam,
 }
 
 
-static int hv7131r_set_pix_format(struct sn9c102_device* cam,
-				  const struct v4l2_pix_format* pix)
+static int hv7131r_set_pix_format(struct sn9c102_device *cam,
+				  const struct v4l2_pix_format *pix)
 {
 	int err = 0;
 
@@ -347,7 +348,7 @@ static const struct sn9c102_sensor hv7131r = {
 };
 
 
-int sn9c102_probe_hv7131r(struct sn9c102_device* cam)
+int sn9c102_probe_hv7131r(struct sn9c102_device *cam)
 {
 	int devid, err;
 
-- 
1.7.10.4

