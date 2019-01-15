Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9D4C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 194D62085A
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfAOIzK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:55:10 -0500
Received: from shell.v3.sk ([90.176.6.54]:51325 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbfAOIzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 03:55:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 90CE14CBD8;
        Tue, 15 Jan 2019 09:55:06 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id xGVEljyiuti4; Tue, 15 Jan 2019 09:54:56 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id D82EC4C9F0;
        Tue, 15 Jan 2019 09:54:55 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id eV9xLOG7BPLE; Tue, 15 Jan 2019 09:54:53 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 738024CBD8;
        Tue, 15 Jan 2019 09:54:53 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH v4 4/5] media: ov7670: split register setting from set_fmt() logic
Date:   Tue, 15 Jan 2019 09:54:47 +0100
Message-Id: <20190115085448.1400135-5-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190115085448.1400135-1-lkundrak@v3.sk>
References: <20190115085448.1400135-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This will allow us to restore the last set format after the device return=
s
from a power off.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/i2c/ov7670.c | 80 ++++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 93c055502bb9..d0f40d5f6ca0 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -241,6 +241,7 @@ struct ov7670_info {
 	};
 	struct v4l2_mbus_framefmt format;
 	struct ov7670_format_struct *fmt;  /* Current format */
+	struct ov7670_win_size *wsize;
 	struct clk *clk;
 	int on;
 	struct gpio_desc *resetb_gpio;
@@ -1001,48 +1002,20 @@ static int ov7670_try_fmt_internal(struct v4l2_su=
bdev *sd,
 	return 0;
 }
=20
-/*
- * Set a format.
- */
-static int ov7670_set_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+static int ov7670_apply_fmt(struct v4l2_subdev *sd)
 {
-	struct ov7670_format_struct *ovfmt;
-	struct ov7670_win_size *wsize;
 	struct ov7670_info *info =3D to_state(sd);
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
-	struct v4l2_mbus_framefmt *mbus_fmt;
-#endif
+	struct ov7670_win_size *wsize =3D info->wsize;
 	unsigned char com7, com10 =3D 0;
 	int ret;
=20
-	if (format->pad)
-		return -EINVAL;
-
-	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
-		ret =3D ov7670_try_fmt_internal(sd, &format->format, NULL, NULL);
-		if (ret)
-			return ret;
-#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
-		mbus_fmt =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
-		*mbus_fmt =3D format->format;
-		return 0;
-#else
-		return -ENOTTY;
-#endif
-	}
-
-	ret =3D ov7670_try_fmt_internal(sd, &format->format, &ovfmt, &wsize);
-	if (ret)
-		return ret;
 	/*
 	 * COM7 is a pain in the ass, it doesn't like to be read then
 	 * quickly written afterward.  But we have everything we need
 	 * to set it absolutely here, as long as the format-specific
 	 * register sets list it first.
 	 */
-	com7 =3D ovfmt->regs[0].value;
+	com7 =3D info->fmt->regs[0].value;
 	com7 |=3D wsize->com7_bit;
 	ret =3D ov7670_write(sd, REG_COM7, com7);
 	if (ret)
@@ -1064,7 +1037,7 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	/*
 	 * Now write the rest of the array.  Also store start/stops
 	 */
-	ret =3D ov7670_write_array(sd, ovfmt->regs + 1);
+	ret =3D ov7670_write_array(sd, info->fmt->regs + 1);
 	if (ret)
 		return ret;
=20
@@ -1079,8 +1052,6 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 			return ret;
 	}
=20
-	info->fmt =3D ovfmt;
-
 	/*
 	 * If we're running RGB565, we must rewrite clkrc after setting
 	 * the other parameters or the image looks poor.  If we're *not*
@@ -1098,6 +1069,46 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
=20
+/*
+ * Set a format.
+ */
+static int ov7670_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
+{
+	struct ov7670_info *info =3D to_state(sd);
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+	struct v4l2_mbus_framefmt *mbus_fmt;
+#endif
+	int ret;
+
+	if (format->pad)
+		return -EINVAL;
+
+	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
+		ret =3D ov7670_try_fmt_internal(sd, &format->format, NULL, NULL);
+		if (ret)
+			return ret;
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+		mbus_fmt =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
+		*mbus_fmt =3D format->format;
+		return 0;
+#else
+		return -ENOTTY;
+#endif
+	}
+
+	ret =3D ov7670_try_fmt_internal(sd, &format->format, &info->fmt, &info-=
>wsize);
+	if (ret)
+		return ret;
+
+	ret =3D ov7670_apply_fmt(sd);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int ov7670_get_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *format)
@@ -1882,6 +1893,7 @@ static int ov7670_probe(struct i2c_client *client,
=20
 	info->devtype =3D &ov7670_devdata[id->driver_data];
 	info->fmt =3D &ov7670_formats[0];
+	info->wsize =3D &info->devtype->win_sizes[0];
=20
 	ov7670_get_default_format(sd, &info->format);
=20
--=20
2.20.1

