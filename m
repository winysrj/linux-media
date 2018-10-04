Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:37145 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbeJEEY2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 00:24:28 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>, stable@vger.kernel.org
Subject: [PATCH] [media] ov7670: make "xclk" clock optional
Date: Thu,  4 Oct 2018 23:29:03 +0200
Message-Id: <20181004212903.364064-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the "xclk" clock was added, it was made mandatory. This broke the
driver on an OLPC plaform which doesn't know such clock. Make it
optional.

Tested on a OLPC XO-1 laptop.

Cc: stable@vger.kernel.org # 4.11+
Fixes: 0a024d634cee ("[media] ov7670: get xclk")
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/i2c/ov7670.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 31bf577b0bd3..64d1402882c8 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1808,17 +1808,24 @@ static int ov7670_probe(struct i2c_client *client=
,
 			info->pclk_hb_disable =3D true;
 	}
=20
-	info->clk =3D devm_clk_get(&client->dev, "xclk");
-	if (IS_ERR(info->clk))
-		return PTR_ERR(info->clk);
-	ret =3D clk_prepare_enable(info->clk);
-	if (ret)
-		return ret;
+	info->clk =3D devm_clk_get(&client->dev, "xclk"); /* optional */
+	if (IS_ERR(info->clk)) {
+		ret =3D PTR_ERR(info->clk);
+		if (ret =3D=3D -ENOENT)
+			info->clk =3D NULL;
+		else
+			return ret;
+	}
+	if (info->clk) {
+		ret =3D clk_prepare_enable(info->clk);
+		if (ret)
+			return ret;
=20
-	info->clock_speed =3D clk_get_rate(info->clk) / 1000000;
-	if (info->clock_speed < 10 || info->clock_speed > 48) {
-		ret =3D -EINVAL;
-		goto clk_disable;
+		info->clock_speed =3D clk_get_rate(info->clk) / 1000000;
+		if (info->clock_speed < 10 || info->clock_speed > 48) {
+			ret =3D -EINVAL;
+			goto clk_disable;
+		}
 	}
=20
 	ret =3D ov7670_init_gpio(client, info);
--=20
2.19.0
