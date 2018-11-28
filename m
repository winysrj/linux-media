Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:39088 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbeK2EWE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 23:22:04 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 6/6] media: ov7670: get rid of extra ifdefs
Date: Wed, 28 Nov 2018 18:19:18 +0100
Message-Id: <20181128171918.160643-7-lkundrak@v3.sk>
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
 drivers/media/i2c/ov7670.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index bc68a3a5b4ec..7d1fdf51bd91 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1013,9 +1013,7 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	struct ov7670_format_struct *ovfmt;
 	struct ov7670_win_size *wsize;
 	struct ov7670_info *info =3D to_state(sd);
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	struct v4l2_mbus_framefmt *mbus_fmt;
-#endif
 	unsigned char com7, com10 =3D 0;
 	int ret;
=20
@@ -1026,13 +1024,11 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 		ret =3D ov7670_try_fmt_internal(sd, &format->format, NULL, NULL);
 		if (ret)
 			return ret;
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		mbus_fmt =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
+		if (IS_ERR(mbus_fmt))
+			return PTR_ERR(mbus_fmt);
 		*mbus_fmt =3D format->format;
 		return 0;
-#else
-		return -ENOTTY;
-#endif
 	}
=20
 	ret =3D ov7670_try_fmt_internal(sd, &format->format, &ovfmt, &wsize);
@@ -1105,18 +1101,14 @@ static int ov7670_get_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_format *format)
 {
 	struct ov7670_info *info =3D to_state(sd);
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	struct v4l2_mbus_framefmt *mbus_fmt;
-#endif
=20
 	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		mbus_fmt =3D v4l2_subdev_get_try_format(sd, cfg, 0);
+		if (IS_ERR(mbus_fmt))
+			return PTR_ERR(mbus_fmt);
 		format->format =3D *mbus_fmt;
 		return 0;
-#else
-		return -ENOTTY;
-#endif
 	} else {
 		format->format =3D info->format;
 	}
--=20
2.19.1
