Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:39096 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729200AbeK2EWD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 23:22:03 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 3/6] media: ov2659: get rid of extra ifdefs
Date: Wed, 28 Nov 2018 18:19:15 +0100
Message-Id: <20181128171918.160643-4-lkundrak@v3.sk>
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
 drivers/media/i2c/ov2659.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 799acce803fe..a66c12c8f278 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1046,17 +1046,15 @@ static int ov2659_get_fmt(struct v4l2_subdev *sd,
 	dev_dbg(&client->dev, "ov2659_get_fmt\n");
=20
 	if (fmt->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		struct v4l2_mbus_framefmt *mf;
=20
 		mf =3D v4l2_subdev_get_try_format(sd, cfg, 0);
+		if (IS_ERR(mf))
+			return PTR_ERR(mf);
 		mutex_lock(&ov2659->lock);
 		fmt->format =3D *mf;
 		mutex_unlock(&ov2659->lock);
 		return 0;
-#else
-	return -ENOTTY;
-#endif
 	}
=20
 	mutex_lock(&ov2659->lock);
@@ -1126,12 +1124,10 @@ static int ov2659_set_fmt(struct v4l2_subdev *sd,
 	mutex_lock(&ov2659->lock);
=20
 	if (fmt->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		mf =3D v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
+		if (IS_ERR(mf))
+			return PTR_ERR(mf);
 		*mf =3D fmt->format;
-#else
-		return -ENOTTY;
-#endif
 	} else {
 		s64 val;
=20
--=20
2.19.1
