Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1880 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3CROMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 10:12:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 4/6] v4l2: add const to argument of write-only s_register ioctl.
Date: Mon, 18 Mar 2013 15:12:03 +0100
Message-Id: <1363615925-19507-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl>
References: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This ioctl is defined as IOW, so pass the argument as const.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c    |    2 +-
 drivers/media/i2c/ad9389b.c                     |    2 +-
 drivers/media/i2c/adv7183.c                     |    2 +-
 drivers/media/i2c/adv7604.c                     |    2 +-
 drivers/media/i2c/ak881x.c                      |    2 +-
 drivers/media/i2c/cs5345.c                      |    2 +-
 drivers/media/i2c/cx25840/cx25840-core.c        |    2 +-
 drivers/media/i2c/m52790.c                      |    2 +-
 drivers/media/i2c/mt9m032.c                     |    2 +-
 drivers/media/i2c/mt9v011.c                     |    2 +-
 drivers/media/i2c/ov7670.c                      |    2 +-
 drivers/media/i2c/saa7115.c                     |    2 +-
 drivers/media/i2c/saa7127.c                     |    2 +-
 drivers/media/i2c/saa717x.c                     |    2 +-
 drivers/media/i2c/soc_camera/mt9m001.c          |    2 +-
 drivers/media/i2c/soc_camera/mt9m111.c          |    2 +-
 drivers/media/i2c/soc_camera/mt9t031.c          |    2 +-
 drivers/media/i2c/soc_camera/mt9t112.c          |    2 +-
 drivers/media/i2c/soc_camera/mt9v022.c          |    2 +-
 drivers/media/i2c/soc_camera/ov2640.c           |    2 +-
 drivers/media/i2c/soc_camera/ov5642.c           |    2 +-
 drivers/media/i2c/soc_camera/ov6650.c           |    2 +-
 drivers/media/i2c/soc_camera/ov772x.c           |    2 +-
 drivers/media/i2c/soc_camera/ov9640.c           |    2 +-
 drivers/media/i2c/soc_camera/ov9740.c           |    2 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c       |    2 +-
 drivers/media/i2c/soc_camera/tw9910.c           |    2 +-
 drivers/media/i2c/tvp5150.c                     |    2 +-
 drivers/media/i2c/tvp7002.c                     |    2 +-
 drivers/media/i2c/upd64031a.c                   |    2 +-
 drivers/media/i2c/upd64083.c                    |    2 +-
 drivers/media/i2c/vs6624.c                      |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c           |    5 +--
 drivers/media/pci/cx18/cx18-av-core.c           |    2 +-
 drivers/media/pci/cx18/cx18-ioctl.c             |   36 +++++++---------
 drivers/media/pci/cx23885/cx23885-ioctl.c       |    9 ++--
 drivers/media/pci/cx23885/cx23885-ioctl.h       |    2 +-
 drivers/media/pci/cx23885/cx23888-ir.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c       |    2 +-
 drivers/media/pci/cx25821/cx25821-video.h       |    2 +-
 drivers/media/pci/cx88/cx88-video.c             |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c             |   51 ++++++++++++-----------
 drivers/media/pci/saa7134/saa7134-video.c       |    2 +-
 drivers/media/pci/saa7146/mxb.c                 |    3 +-
 drivers/media/pci/saa7164/saa7164-encoder.c     |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c  |    2 +-
 drivers/media/platform/davinci/vpbe_display.c   |    2 +-
 drivers/media/platform/davinci/vpif_capture.c   |    3 +-
 drivers/media/platform/davinci/vpif_display.c   |    3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c |    2 +-
 drivers/media/platform/sh_vou.c                 |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c  |    2 +-
 drivers/media/usb/au0828/au0828-video.c         |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c       |    2 +-
 drivers/media/usb/cx231xx/cx231xx.h             |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c         |    2 +-
 drivers/media/usb/gspca/gspca.c                 |    2 +-
 drivers/media/usb/gspca/gspca.h                 |    8 ++--
 drivers/media/usb/gspca/pac7302.c               |    2 +-
 drivers/media/usb/gspca/sn9c20x.c               |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c         |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h         |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c        |    2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c         |    2 +-
 drivers/media/usb/usbvision/usbvision-video.c   |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c            |    2 +-
 include/media/v4l2-ioctl.h                      |    2 +-
 include/media/v4l2-subdev.h                     |    2 +-
 68 files changed, 115 insertions(+), 123 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 5243ba6..526902b 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -583,7 +583,7 @@ static int au8522_g_register(struct v4l2_subdev *sd,
 }
 
 static int au8522_s_register(struct v4l2_subdev *sd,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct au8522_state *state = to_state(sd);
diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index c2886b6..58344b6 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -354,7 +354,7 @@ static int ad9389b_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 	return 0;
 }
 
-static int ad9389b_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int ad9389b_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 6fed5b7..56a1fa4 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -507,7 +507,7 @@ static int adv7183_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 	return 0;
 }
 
-static int adv7183_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int adv7183_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index f47555b..31a63c9 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -699,7 +699,7 @@ static int adv7604_g_register(struct v4l2_subdev *sd,
 }
 
 static int adv7604_s_register(struct v4l2_subdev *sd,
-					struct v4l2_dbg_register *reg)
+					const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index ba67465..fd47465 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -101,7 +101,7 @@ static int ak881x_g_register(struct v4l2_subdev *sd,
 }
 
 static int ak881x_s_register(struct v4l2_subdev *sd,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/cs5345.c b/drivers/media/i2c/cs5345.c
index c8581e2..1d2f7c8 100644
--- a/drivers/media/i2c/cs5345.c
+++ b/drivers/media/i2c/cs5345.c
@@ -110,7 +110,7 @@ static int cs5345_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 	return 0;
 }
 
-static int cs5345_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int cs5345_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 234b7c6..12fb9b2 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1671,7 +1671,7 @@ static int cx25840_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 	return 0;
 }
 
-static int cx25840_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int cx25840_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/m52790.c b/drivers/media/i2c/m52790.c
index 0991576..39f50fd 100644
--- a/drivers/media/i2c/m52790.c
+++ b/drivers/media/i2c/m52790.c
@@ -96,7 +96,7 @@ static int m52790_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 	return 0;
 }
 
-static int m52790_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int m52790_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct m52790_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index f80c1d7e..2526b66 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -548,7 +548,7 @@ static int mt9m032_g_register(struct v4l2_subdev *sd,
 }
 
 static int mt9m032_s_register(struct v4l2_subdev *sd,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	struct mt9m032 *sensor = to_mt9m032(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 73b7688..3f415fd 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -421,7 +421,7 @@ static int mt9v011_g_register(struct v4l2_subdev *sd,
 }
 
 static int mt9v011_s_register(struct v4l2_subdev *sd,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 05ed5b8..617ad3f 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1487,7 +1487,7 @@ static int ov7670_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 	return ret;
 }
 
-static int ov7670_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int ov7670_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 6b6788c..5d9d033 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1428,7 +1428,7 @@ static int saa711x_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 	return 0;
 }
 
-static int saa711x_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int saa711x_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/saa7127.c b/drivers/media/i2c/saa7127.c
index b745f68..8a47ac1 100644
--- a/drivers/media/i2c/saa7127.c
+++ b/drivers/media/i2c/saa7127.c
@@ -672,7 +672,7 @@ static int saa7127_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 	return 0;
 }
 
-static int saa7127_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int saa7127_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 5608b93..cf3a0aa 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -988,7 +988,7 @@ static int saa717x_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 	return 0;
 }
 
-static int saa717x_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int saa717x_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	u16 addr = reg->reg & 0xffff;
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index bcdc861..dd90898 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -360,7 +360,7 @@ static int mt9m001_g_register(struct v4l2_subdev *sd,
 }
 
 static int mt9m001_s_register(struct v4l2_subdev *sd,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index bbc4ff9..5f71196 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -641,7 +641,7 @@ static int mt9m111_g_register(struct v4l2_subdev *sd,
 }
 
 static int mt9m111_s_register(struct v4l2_subdev *sd,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index d80d044..26a15b8 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -430,7 +430,7 @@ static int mt9t031_g_register(struct v4l2_subdev *sd,
 }
 
 static int mt9t031_s_register(struct v4l2_subdev *sd,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 188e29b..a7256b7 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -766,7 +766,7 @@ static int mt9t112_g_register(struct v4l2_subdev *sd,
 }
 
 static int mt9t112_s_register(struct v4l2_subdev *sd,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret;
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index a5e65d6..0d917b6 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -488,7 +488,7 @@ static int mt9v022_g_register(struct v4l2_subdev *sd,
 }
 
 static int mt9v022_s_register(struct v4l2_subdev *sd,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 0f520f6..e316842 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -756,7 +756,7 @@ static int ov2640_g_register(struct v4l2_subdev *sd,
 }
 
 static int ov2640_s_register(struct v4l2_subdev *sd,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 9d53309..9aa56de 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -708,7 +708,7 @@ static int ov5642_get_register(struct v4l2_subdev *sd, struct v4l2_dbg_register
 	return ret;
 }
 
-static int ov5642_set_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int ov5642_set_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index dbe4f56..991202d 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -421,7 +421,7 @@ static int ov6650_get_register(struct v4l2_subdev *sd,
 }
 
 static int ov6650_set_register(struct v4l2_subdev *sd,
-				struct v4l2_dbg_register *reg)
+				const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index fbeb5b2..713d62e 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -652,7 +652,7 @@ static int ov772x_g_register(struct v4l2_subdev *sd,
 }
 
 static int ov772x_s_register(struct v4l2_subdev *sd,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 0599304..20ca62d 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -322,7 +322,7 @@ static int ov9640_get_register(struct v4l2_subdev *sd,
 }
 
 static int ov9640_set_register(struct v4l2_subdev *sd,
-				struct v4l2_dbg_register *reg)
+				const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 2f236da..012bd62 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -835,7 +835,7 @@ static int ov9740_get_register(struct v4l2_subdev *sd,
 }
 
 static int ov9740_set_register(struct v4l2_subdev *sd,
-			       struct v4l2_dbg_register *reg)
+			       const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 5c92679..1f9ec3b 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -1161,7 +1161,7 @@ static int rj54n1_g_register(struct v4l2_subdev *sd,
 }
 
 static int rj54n1_s_register(struct v4l2_subdev *sd,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 7d20746..bad90b1 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -554,7 +554,7 @@ static int tw9910_g_register(struct v4l2_subdev *sd,
 }
 
 static int tw9910_s_register(struct v4l2_subdev *sd,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 5967e1a0..485159a 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1067,7 +1067,7 @@ static int tvp5150_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 	return 0;
 }
 
-static int tvp5150_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int tvp5150_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 537f6b4..598ed25 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -824,7 +824,7 @@ static int tvp7002_g_register(struct v4l2_subdev *sd,
  * -EPERM if call not allowed.
  */
 static int tvp7002_s_register(struct v4l2_subdev *sd,
-						struct v4l2_dbg_register *reg)
+						const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/upd64031a.c b/drivers/media/i2c/upd64031a.c
index d15cfd9..f0a0921 100644
--- a/drivers/media/i2c/upd64031a.c
+++ b/drivers/media/i2c/upd64031a.c
@@ -175,7 +175,7 @@ static int upd64031a_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register
 	return 0;
 }
 
-static int upd64031a_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int upd64031a_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/upd64083.c b/drivers/media/i2c/upd64083.c
index 75d6acc..343e021 100644
--- a/drivers/media/i2c/upd64083.c
+++ b/drivers/media/i2c/upd64083.c
@@ -133,7 +133,7 @@ static int upd64083_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register
 	return 0;
 }
 
-static int upd64083_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int upd64083_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 9ac1b8c3..f366fad 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -748,7 +748,7 @@ static int vs6624_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 	return 0;
 }
 
-static int vs6624_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+static int vs6624_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 79dc12c..1560591 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1943,7 +1943,7 @@ static int bttv_g_register(struct file *file, void *f,
 }
 
 static int bttv_s_register(struct file *file, void *f,
-					struct v4l2_dbg_register *reg)
+					const struct v4l2_dbg_register *reg)
 {
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
@@ -1959,8 +1959,7 @@ static int bttv_s_register(struct file *file, void *f,
 	}
 
 	/* bt848 has a 12-bit register space */
-	reg->reg &= 0xfff;
-	btwrite(reg->val, reg->reg);
+	btwrite(reg->val, reg->reg & 0xfff);
 
 	return 0;
 }
diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index c22242b..38b1d64 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -1266,7 +1266,7 @@ static int cx18_av_g_register(struct v4l2_subdev *sd,
 }
 
 static int cx18_av_s_register(struct v4l2_subdev *sd,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	struct cx18 *cx = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 254c50f..7dbd5a9 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -415,42 +415,34 @@ static int cx18_g_chip_ident(struct file *file, void *fh,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int cx18_cxc(struct cx18 *cx, unsigned int cmd, void *arg)
-{
-	struct v4l2_dbg_register *regs = arg;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	if (regs->reg >= CX18_MEM_OFFSET + CX18_MEM_SIZE)
-		return -EINVAL;
-
-	regs->size = 4;
-	if (cmd == VIDIOC_DBG_S_REGISTER)
-		cx18_write_enc(cx, regs->val, regs->reg);
-	else
-		regs->val = cx18_read_enc(cx, regs->reg);
-	return 0;
-}
-
 static int cx18_g_register(struct file *file, void *fh,
 				struct v4l2_dbg_register *reg)
 {
 	struct cx18 *cx = fh2id(fh)->cx;
 
-	if (v4l2_chip_match_host(&reg->match))
-		return cx18_cxc(cx, VIDIOC_DBG_G_REGISTER, reg);
+	if (v4l2_chip_match_host(&reg->match)) {
+		if (reg->reg >= CX18_MEM_OFFSET + CX18_MEM_SIZE)
+			return -EINVAL;
+		reg->size = 4;
+		reg->val = cx18_read_enc(cx, reg->reg);
+		return 0;
+	}
 	/* FIXME - errors shouldn't be ignored */
 	cx18_call_all(cx, core, g_register, reg);
 	return 0;
 }
 
 static int cx18_s_register(struct file *file, void *fh,
-				struct v4l2_dbg_register *reg)
+				const struct v4l2_dbg_register *reg)
 {
 	struct cx18 *cx = fh2id(fh)->cx;
 
-	if (v4l2_chip_match_host(&reg->match))
-		return cx18_cxc(cx, VIDIOC_DBG_S_REGISTER, reg);
+	if (v4l2_chip_match_host(&reg->match)) {
+		if (reg->reg >= CX18_MEM_OFFSET + CX18_MEM_SIZE)
+			return -EINVAL;
+		cx18_write_enc(cx, reg->val, reg->reg);
+		return 0;
+	}
 	/* FIXME - errors shouldn't be ignored */
 	cx18_call_all(cx, core, s_register, reg);
 	return 0;
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.c b/drivers/media/pci/cx23885/cx23885-ioctl.c
index ea9a614..acdb6d5 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.c
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.c
@@ -158,18 +158,17 @@ int cx23885_g_register(struct file *file, void *fh,
 }
 
 static int cx23885_s_host_register(struct cx23885_dev *dev,
-				   struct v4l2_dbg_register *reg)
+				   const struct v4l2_dbg_register *reg)
 {
 	if ((reg->reg & 0x3) != 0 || reg->reg >= pci_resource_len(dev->pci, 0))
 		return -EINVAL;
 
-	reg->size = 4;
 	cx_write(reg->reg, reg->val);
 	return 0;
 }
 
 static int cx23417_s_register(struct cx23885_dev *dev,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	if (dev->v4l_device == NULL)
 		return -EINVAL;
@@ -179,13 +178,11 @@ static int cx23417_s_register(struct cx23885_dev *dev,
 
 	if (mc417_register_write(dev, (u16) reg->reg, (u32) reg->val))
 		return -EINVAL; /* V4L2 spec, but -EREMOTEIO really */
-
-	reg->size = 4;
 	return 0;
 }
 
 int cx23885_s_register(struct file *file, void *fh,
-		       struct v4l2_dbg_register *reg)
+		       const struct v4l2_dbg_register *reg)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
 
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.h b/drivers/media/pci/cx23885/cx23885-ioctl.h
index 315be0c..a608096 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.h
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.h
@@ -33,7 +33,7 @@ int cx23885_g_register(struct file *file, void *fh,
 
 
 int cx23885_s_register(struct file *file, void *fh,
-		       struct v4l2_dbg_register *reg);
+		       const struct v4l2_dbg_register *reg);
 
 #endif
 #endif
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index d51eed0..fa672fe 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -1124,7 +1124,7 @@ static int cx23888_ir_g_register(struct v4l2_subdev *sd,
 }
 
 static int cx23888_ir_s_register(struct v4l2_subdev *sd,
-				 struct v4l2_dbg_register *reg)
+				 const struct v4l2_dbg_register *reg)
 {
 	struct cx23888_ir_state *state = to_state(sd);
 	u32 addr = CX23888_IR_REG_BASE + (u32) reg->reg;
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 93c7d57..1465591 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -1364,7 +1364,7 @@ int cx25821_vidioc_g_register(struct file *file, void *fh,
 }
 
 int cx25821_vidioc_s_register(struct file *file, void *fh,
-		      struct v4l2_dbg_register *reg)
+		      const struct v4l2_dbg_register *reg)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)fh)->dev;
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index 239f63c..11ba5eb 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -155,7 +155,7 @@ extern int cx25821_vidioc_s_frequency(struct file *file, void *priv,
 extern int cx25821_vidioc_g_register(struct file *file, void *fh,
 				     struct v4l2_dbg_register *reg);
 extern int cx25821_vidioc_s_register(struct file *file, void *fh,
-				     struct v4l2_dbg_register *reg);
+				     const struct v4l2_dbg_register *reg);
 extern int cx25821_vidioc_g_tuner(struct file *file, void *priv,
 				  struct v4l2_tuner *t);
 extern int cx25821_vidioc_s_tuner(struct file *file, void *priv,
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index ead5be5..e3f6181 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1380,7 +1380,7 @@ static int vidioc_g_register (struct file *file, void *fh,
 }
 
 static int vidioc_s_register (struct file *file, void *fh,
-				struct v4l2_dbg_register *reg)
+				const struct v4l2_dbg_register *reg)
 {
 	struct cx88_core *core = ((struct cx8800_fh*)fh)->dev->core;
 
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 080f179..15e08aa 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -711,49 +711,50 @@ static int ivtv_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip_i
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int ivtv_itvc(struct ivtv *itv, unsigned int cmd, void *arg)
+static volatile u8 __iomem *ivtv_itvc_start(struct ivtv *itv,
+		const struct v4l2_dbg_register *regs)
 {
-	struct v4l2_dbg_register *regs = arg;
-	volatile u8 __iomem *reg_start;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (regs->reg >= IVTV_REG_OFFSET && regs->reg < IVTV_REG_OFFSET + IVTV_REG_SIZE)
-		reg_start = itv->reg_mem - IVTV_REG_OFFSET;
-	else if (itv->has_cx23415 && regs->reg >= IVTV_DECODER_OFFSET &&
+		return itv->reg_mem - IVTV_REG_OFFSET;
+	if (itv->has_cx23415 && regs->reg >= IVTV_DECODER_OFFSET &&
 			regs->reg < IVTV_DECODER_OFFSET + IVTV_DECODER_SIZE)
-		reg_start = itv->dec_mem - IVTV_DECODER_OFFSET;
-	else if (regs->reg < IVTV_ENCODER_SIZE)
-		reg_start = itv->enc_mem;
-	else
-		return -EINVAL;
-
-	regs->size = 4;
-	if (cmd == VIDIOC_DBG_G_REGISTER)
-		regs->val = readl(regs->reg + reg_start);
-	else
-		writel(regs->val, regs->reg + reg_start);
-	return 0;
+		return itv->dec_mem - IVTV_DECODER_OFFSET;
+	if (regs->reg < IVTV_ENCODER_SIZE)
+		return itv->enc_mem;
+	return NULL;
 }
 
 static int ivtv_g_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
 
-	if (v4l2_chip_match_host(&reg->match))
-		return ivtv_itvc(itv, VIDIOC_DBG_G_REGISTER, reg);
+	if (v4l2_chip_match_host(&reg->match)) {
+		volatile u8 __iomem *reg_start = ivtv_itvc_start(itv, reg);
+
+		if (reg_start == NULL)
+			return -EINVAL;
+		reg->size = 4;
+		reg->val = readl(reg->reg + reg_start);
+		return 0;
+	}
 	/* TODO: subdev errors should not be ignored, this should become a
 	   subdev helper function. */
 	ivtv_call_all(itv, core, g_register, reg);
 	return 0;
 }
 
-static int ivtv_s_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
+static int ivtv_s_register(struct file *file, void *fh, const struct v4l2_dbg_register *reg)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
 
-	if (v4l2_chip_match_host(&reg->match))
-		return ivtv_itvc(itv, VIDIOC_DBG_S_REGISTER, reg);
+	if (v4l2_chip_match_host(&reg->match)) {
+		volatile u8 __iomem *reg_start = ivtv_itvc_start(itv, reg);
+
+		if (reg_start == NULL)
+			return -EINVAL;
+		writel(reg->val, reg->reg + reg_start);
+		return 0;
+	}
 	/* TODO: subdev errors should not be ignored, this should become a
 	   subdev helper function. */
 	ivtv_call_all(itv, core, s_register, reg);
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index a6c69a4..1363e97 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2300,7 +2300,7 @@ static int vidioc_g_register (struct file *file, void *priv,
 }
 
 static int vidioc_s_register (struct file *file, void *priv,
-				struct v4l2_dbg_register *reg)
+				const struct v4l2_dbg_register *reg)
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 9dd044b..71e8bea 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -680,7 +680,7 @@ static int vidioc_g_register(struct file *file, void *fh, struct v4l2_dbg_regist
 	return 0;
 }
 
-static int vidioc_s_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
+static int vidioc_s_register(struct file *file, void *fh, const struct v4l2_dbg_register *reg)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
@@ -688,7 +688,6 @@ static int vidioc_s_register(struct file *file, void *fh, struct v4l2_dbg_regist
 		return -EPERM;
 	if (v4l2_chip_match_host(&reg->match)) {
 		saa7146_write(dev, reg->reg, reg->val);
-		reg->size = 4;
 		return 0;
 	}
 	return call_all(dev, core, s_register, reg);
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 538de52..0b74fb2 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -1313,7 +1313,7 @@ static int saa7164_g_register(struct file *file, void *fh,
 }
 
 static int saa7164_s_register(struct file *file, void *fh,
-			      struct v4l2_dbg_register *reg)
+			      const struct v4l2_dbg_register *reg)
 {
 	struct saa7164_port *port = ((struct saa7164_encoder_fh *)fh)->port;
 	struct saa7164_dev *dev = port->dev;
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index fcf39b2..ce8937c 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -890,7 +890,7 @@ static int bcap_dbg_g_register(struct file *file, void *priv,
 }
 
 static int bcap_dbg_s_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg)
+		const struct v4l2_dbg_register *reg)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
 
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 1311cdf..4b00ad1 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1601,7 +1601,7 @@ static int vpbe_display_g_register(struct file *file, void *priv,
 }
 
 static int vpbe_display_s_register(struct file *file, void *priv,
-			struct v4l2_dbg_register *reg)
+			const struct v4l2_dbg_register *reg)
 {
 	return 0;
 }
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 4e78839..cba34cd 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1924,7 +1924,8 @@ static int vpif_dbg_g_register(struct file *file, void *priv,
  * Returns zero or -EINVAL if write operations fails.
  */
 static int vpif_dbg_s_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg){
+		const struct v4l2_dbg_register *reg)
+{
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index dced173..94087cf 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1568,7 +1568,8 @@ static int vpif_dbg_g_register(struct file *file, void *priv,
  * Returns zero or -EINVAL if write operations fails.
  */
 static int vpif_dbg_s_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg){
+		const struct v4l2_dbg_register *reg)
+{
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 76a8623..64ab91e 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1445,7 +1445,7 @@ static int mcam_vidioc_g_register(struct file *file, void *priv,
 }
 
 static int mcam_vidioc_s_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg)
+		const struct v4l2_dbg_register *reg)
 {
 	struct mcam_camera *cam = priv;
 
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index ea8a1ee..6cc1313 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1266,7 +1266,7 @@ static int sh_vou_g_register(struct file *file, void *fh,
 }
 
 static int sh_vou_s_register(struct file *file, void *fh,
-				 struct v4l2_dbg_register *reg)
+				 const struct v4l2_dbg_register *reg)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 3592968..bf55abf 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1042,7 +1042,7 @@ static int soc_camera_g_register(struct file *file, void *fh,
 }
 
 static int soc_camera_s_register(struct file *file, void *fh,
-				 struct v4l2_dbg_register *reg)
+				 const struct v4l2_dbg_register *reg)
 {
 	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index e9dd01c..79f1d51 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1754,7 +1754,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 }
 
 static int vidioc_s_register(struct file *file, void *priv,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 4cff2f4..cd22147 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1404,7 +1404,7 @@ int cx231xx_g_register(struct file *file, void *priv,
 }
 
 int cx231xx_s_register(struct file *file, void *priv,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 4e37d0f..5b0eb59 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -948,7 +948,7 @@ int cx231xx_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip_ident
 int cx231xx_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg);
 int cx231xx_s_register(struct file *file, void *priv,
-			     struct v4l2_dbg_register *reg);
+			     const struct v4l2_dbg_register *reg);
 
 /* Provided by cx231xx-cards.c */
 extern void cx231xx_pre_card_setup(struct cx231xx *dev);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 98cdc4f..c7a7301 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1321,7 +1321,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 }
 
 static int vidioc_s_register(struct file *file, void *priv,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 5800d65..23a019a 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1040,7 +1040,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 }
 
 static int vidioc_s_register(struct file *file, void *priv,
-			struct v4l2_dbg_register *reg)
+			const struct v4l2_dbg_register *reg)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index c3af321..ef8efeb 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -74,8 +74,10 @@ typedef int (*cam_get_jpg_op) (struct gspca_dev *,
 				struct v4l2_jpegcompression *);
 typedef int (*cam_set_jpg_op) (struct gspca_dev *,
 				const struct v4l2_jpegcompression *);
-typedef int (*cam_reg_op) (struct gspca_dev *,
+typedef int (*cam_get_reg_op) (struct gspca_dev *,
 				struct v4l2_dbg_register *);
+typedef int (*cam_set_reg_op) (struct gspca_dev *,
+				const struct v4l2_dbg_register *);
 typedef int (*cam_ident_op) (struct gspca_dev *,
 				struct v4l2_dbg_chip_ident *);
 typedef void (*cam_streamparm_op) (struct gspca_dev *,
@@ -108,8 +110,8 @@ struct sd_desc {
 	cam_streamparm_op get_streamparm;
 	cam_streamparm_op set_streamparm;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	cam_reg_op set_register;
-	cam_reg_op get_register;
+	cam_set_reg_op set_register;
+	cam_get_reg_op get_register;
 #endif
 	cam_ident_op get_chip_ident;
 #if IS_ENABLED(CONFIG_INPUT)
diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 682ef33..6008c8d 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -840,7 +840,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int sd_dbg_s_register(struct gspca_dev *gspca_dev,
-			struct v4l2_dbg_register *reg)
+			const struct v4l2_dbg_register *reg)
 {
 	u8 index;
 	u8 value;
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 4ec544f..ead9a1f 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -1598,7 +1598,7 @@ static int sd_dbg_g_register(struct gspca_dev *gspca_dev,
 }
 
 static int sd_dbg_s_register(struct gspca_dev *gspca_dev,
-			struct v4l2_dbg_register *reg)
+			const struct v4l2_dbg_register *reg)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 299751a..e11267f 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -5165,7 +5165,7 @@ static int pvr2_hdw_get_eeprom_addr(struct pvr2_hdw *hdw)
 
 
 int pvr2_hdw_register_access(struct pvr2_hdw *hdw,
-			     struct v4l2_dbg_match *match, u64 reg_id,
+			     const struct v4l2_dbg_match *match, u64 reg_id,
 			     int setFl, u64 *val_ptr)
 {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
index 8060fc6..91bae93 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
@@ -240,7 +240,7 @@ void pvr2_hdw_v4l_store_minor_number(struct pvr2_hdw *,
    setFl   - true to set the register, false to read it
    val_ptr - storage location for source / result. */
 int pvr2_hdw_register_access(struct pvr2_hdw *,
-			     struct v4l2_dbg_match *match, u64 reg_id,
+			     const struct v4l2_dbg_match *match, u64 reg_id,
 			     int setFl, u64 *val_ptr);
 
 /* The following entry points are all lower level things you normally don't
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index a7774e3..a8a65fa 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -815,7 +815,7 @@ static int pvr2_g_register(struct file *file, void *priv, struct v4l2_dbg_regist
 	return ret;
 }
 
-static int pvr2_s_register(struct file *file, void *priv, struct v4l2_dbg_register *req)
+static int pvr2_s_register(struct file *file, void *priv, const struct v4l2_dbg_register *req)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index f6a6cdc..c4c723b 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -500,7 +500,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 }
 
 static int vidioc_s_register(struct file *file, void *priv,
-			     struct v4l2_dbg_register *reg)
+			     const struct v4l2_dbg_register *reg)
 {
 	struct stk1160 *dev = video_drvdata(file);
 
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 041f19e..d34c2af 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -483,7 +483,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 }
 
 static int vidioc_s_register(struct file *file, void *priv,
-				struct v4l2_dbg_register *reg)
+				const struct v4l2_dbg_register *reg)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 	int err_code;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index d80d8af..2abd13a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1805,7 +1805,7 @@ static int v4l_dbg_s_register(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	struct v4l2_dbg_register *p = arg;
+	const struct v4l2_dbg_register *p = arg;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index ee7b7c6..a4175cd 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -242,7 +242,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_register)       (struct file *file, void *fh,
 					struct v4l2_dbg_register *reg);
 	int (*vidioc_s_register)       (struct file *file, void *fh,
-					struct v4l2_dbg_register *reg);
+					const struct v4l2_dbg_register *reg);
 #endif
 	int (*vidioc_g_chip_ident)     (struct file *file, void *fh,
 					struct v4l2_dbg_chip_ident *chip);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 79784fc..8158a08 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -165,7 +165,7 @@ struct v4l2_subdev_core_ops {
 	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
-	int (*s_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
+	int (*s_register)(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg);
 #endif
 	int (*s_power)(struct v4l2_subdev *sd, int on);
 	int (*interrupt_service_routine)(struct v4l2_subdev *sd,
-- 
1.7.10.4

