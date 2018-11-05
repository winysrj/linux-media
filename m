Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:49512 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727537AbeKEQti (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 11:49:38 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 01/11] media: ov7670: hook s_power onto v4l2 core
Date: Mon,  5 Nov 2018 08:30:44 +0100
Message-Id: <20181105073054.24407-2-lkundrak@v3.sk>
In-Reply-To: <20181105073054.24407-1-lkundrak@v3.sk>
References: <20181105073054.24407-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The commit 71862f63f351 ("media: ov7670: Add the ov7670_s_power function"=
)
added a s_power function. For some reason it didn't register it with v4l2=
,
only uses it internally. Fix this now.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/i2c/ov7670.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index bc68a3a5b4ec..d87f2362bf40 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1651,6 +1651,7 @@ static int ov7670_open(struct v4l2_subdev *sd, stru=
ct v4l2_subdev_fh *fh)
 static const struct v4l2_subdev_core_ops ov7670_core_ops =3D {
 	.reset =3D ov7670_reset,
 	.init =3D ov7670_init,
+	.s_power =3D ov7670_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register =3D ov7670_g_register,
 	.s_register =3D ov7670_s_register,
--=20
2.19.1
