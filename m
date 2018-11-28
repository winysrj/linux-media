Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:39078 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbeK2EWC (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 4/6] media: ov2680: get rid of extra ifdefs
Date: Wed, 28 Nov 2018 18:19:16 +0100
Message-Id: <20181128171918.160643-5-lkundrak@v3.sk>
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
 drivers/media/i2c/ov2680.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 0e34e15b67b3..f8b873aaacec 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -680,11 +680,9 @@ static int ov2680_get_fmt(struct v4l2_subdev *sd,
 	mutex_lock(&sensor->lock);
=20
 	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		fmt =3D v4l2_subdev_get_try_format(&sensor->sd, cfg, format->pad);
-#else
-		ret =3D -ENOTTY;
-#endif
+		if (IS_ERR(fmt))
+			return PTR_ERR(fmt);
 	} else {
 		fmt =3D &sensor->fmt;
 	}
@@ -703,9 +701,7 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 {
 	struct ov2680_dev *sensor =3D to_ov2680_dev(sd);
 	struct v4l2_mbus_framefmt *fmt =3D &format->format;
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	struct v4l2_mbus_framefmt *try_fmt;
-#endif
 	const struct ov2680_mode_info *mode;
 	int ret =3D 0;
=20
@@ -728,12 +724,11 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 	}
=20
 	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		try_fmt =3D v4l2_subdev_get_try_format(sd, cfg, 0);
-		format->format =3D *try_fmt;
-#else
-		ret =3D -ENOTTY;
-#endif
+		if (IS_ERR(try_fmt))
+			ret =3D PTR_ERR(try_fmt);
+		else
+			format->format =3D *try_fmt;
=20
 		goto unlock;
 	}
--=20
2.19.1
