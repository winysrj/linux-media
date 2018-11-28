Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:39112 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729251AbeK2EWH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 23:22:07 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 5/6] media: ov5695: get rid of extra ifdefs
Date: Wed, 28 Nov 2018 18:19:17 +0100
Message-Id: <20181128171918.160643-6-lkundrak@v3.sk>
In-Reply-To: <20181128171918.160643-1-lkundrak@v3.sk>
References: <20181128171918.160643-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stubbed v4l2_subdev_get_try_format() will return a correct error when
configured without CONFIG_VIDEO_V4L2_SUBDEV_API.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/i2c/ov5695.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/ov5695.c b/drivers/media/i2c/ov5695.c
index 5d107c53364d..1469e8b90e1a 100644
--- a/drivers/media/i2c/ov5695.c
+++ b/drivers/media/i2c/ov5695.c
@@ -810,6 +810,7 @@ static int ov5695_set_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct ov5695 *ov5695 =3D to_ov5695(sd);
+	struct v4l2_mbus_framefmt *try_fmt;
 	const struct ov5695_mode *mode;
 	s64 h_blank, vblank_def;
=20
@@ -821,12 +822,12 @@ static int ov5695_set_fmt(struct v4l2_subdev *sd,
 	fmt->format.height =3D mode->height;
 	fmt->format.field =3D V4L2_FIELD_NONE;
 	if (fmt->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
-		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) =3D fmt->format;
-#else
-		mutex_unlock(&ov5695->mutex);
-		return -ENOTTY;
-#endif
+		try_fmt =3D v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
+		if (IS_ERR(try_fmt)) {
+			mutex_unlock(&ov5695->mutex);
+			return PTR_ERR(try_fmt);
+		}
+		*try_fmt =3D fmt->format;
 	} else {
 		ov5695->cur_mode =3D mode;
 		h_blank =3D mode->hts_def - mode->width;
@@ -845,24 +846,25 @@ static int ov5695_set_fmt(struct v4l2_subdev *sd,
=20
 static int ov5695_get_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
-			  struct v4l2_subdev_format *fmt)
+			  struct v4l2_subdev_format *format)
 {
 	struct ov5695 *ov5695 =3D to_ov5695(sd);
+	struct v4l2_mbus_framefmt *fmt;
 	const struct ov5695_mode *mode =3D ov5695->cur_mode;
=20
 	mutex_lock(&ov5695->mutex);
-	if (fmt->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
-		fmt->format =3D *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
-#else
-		mutex_unlock(&ov5695->mutex);
-		return -ENOTTY;
-#endif
+	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
+		fmt =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
+		if (IS_ERR(fmt)) {
+			mutex_unlock(&ov5695->mutex);
+			return PTR_ERR(fmt);
+		}
+		format->format =3D *fmt;
 	} else {
-		fmt->format.width =3D mode->width;
-		fmt->format.height =3D mode->height;
-		fmt->format.code =3D MEDIA_BUS_FMT_SBGGR10_1X10;
-		fmt->format.field =3D V4L2_FIELD_NONE;
+		format->format.width =3D mode->width;
+		format->format.height =3D mode->height;
+		format->format.code =3D MEDIA_BUS_FMT_SBGGR10_1X10;
+		format->format.field =3D V4L2_FIELD_NONE;
 	}
 	mutex_unlock(&ov5695->mutex);
=20
--=20
2.19.1
