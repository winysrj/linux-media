Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:39088 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbeK2EWC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 23:22:02 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 2/6] media: ov7740: get rid of extra ifdefs
Date: Wed, 28 Nov 2018 18:19:14 +0100
Message-Id: <20181128171918.160643-3-lkundrak@v3.sk>
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
 drivers/media/i2c/ov7740.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 6e9c233cfbe3..781ddcc743d4 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -780,9 +780,7 @@ static int ov7740_set_fmt(struct v4l2_subdev *sd,
 	struct ov7740 *ov7740 =3D container_of(sd, struct ov7740, subdev);
 	const struct ov7740_pixfmt *ovfmt;
 	const struct ov7740_framesize *fsize;
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	struct v4l2_mbus_framefmt *mbus_fmt;
-#endif
 	int ret;
=20
 	mutex_lock(&ov7740->mutex);
@@ -795,16 +793,15 @@ static int ov7740_set_fmt(struct v4l2_subdev *sd,
 		ret =3D ov7740_try_fmt_internal(sd, &format->format, NULL, NULL);
 		if (ret)
 			goto error;
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		mbus_fmt =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
+		if (IS_ERR(mbus_fmt)) {
+			ret =3D PTR_ERR(mbus_fmt);
+			goto error;
+		}
 		*mbus_fmt =3D format->format;
=20
 		mutex_unlock(&ov7740->mutex);
 		return 0;
-#else
-		ret =3D -ENOTTY;
-		goto error;
-#endif
 	}
=20
 	ret =3D ov7740_try_fmt_internal(sd, &format->format, &ovfmt, &fsize);
@@ -827,20 +824,18 @@ static int ov7740_get_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_format *format)
 {
 	struct ov7740 *ov7740 =3D container_of(sd, struct ov7740, subdev);
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	struct v4l2_mbus_framefmt *mbus_fmt;
-#endif
 	int ret =3D 0;
=20
 	mutex_lock(&ov7740->mutex);
 	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		mbus_fmt =3D v4l2_subdev_get_try_format(sd, cfg, 0);
-		format->format =3D *mbus_fmt;
-		ret =3D 0;
-#else
-		ret =3D -ENOTTY;
-#endif
+		if (IS_ERR(mbus_fmt)) {
+			ret =3D PTR_ERR(mbus_fmt);
+		} else {
+			format->format =3D *mbus_fmt;
+			ret =3D 0;
+		}
 	} else {
 		format->format =3D ov7740->format;
 	}
--=20
2.19.1
