Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C53DC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 106C820656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbfAOIzJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:55:09 -0500
Received: from shell.v3.sk ([90.176.6.54]:51321 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfAOIzI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 03:55:08 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 04A7F4CC79;
        Tue, 15 Jan 2019 09:55:05 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id pUa6pf8zgCmH; Tue, 15 Jan 2019 09:54:55 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 5A9B04B474;
        Tue, 15 Jan 2019 09:54:55 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NiRCJD-8NAhI; Tue, 15 Jan 2019 09:54:53 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 4627C4CBA5;
        Tue, 15 Jan 2019 09:54:53 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v4 3/5] media: ov7670: control clock along with power
Date:   Tue, 15 Jan 2019 09:54:46 +0100
Message-Id: <20190115085448.1400135-4-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190115085448.1400135-1-lkundrak@v3.sk>
References: <20190115085448.1400135-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This provides more power saving when the sensor is off.

While at that, do the delay on power/clock enable even if the sensor driv=
er
itself doesn't control the GPIOs. This is required for the OLPC XO-1
platform, that lacks the proper power/reset properties in its DT, but
needs the delay after the sensor is clocked up.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov7670.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 4679aa9dc430..93c055502bb9 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1611,14 +1611,17 @@ static void ov7670_power_on(struct v4l2_subdev *s=
d)
 	if (info->on)
 		return;
=20
+	clk_prepare_enable(info->clk);
+
 	if (info->pwdn_gpio)
 		gpiod_set_value(info->pwdn_gpio, 0);
 	if (info->resetb_gpio) {
 		gpiod_set_value(info->resetb_gpio, 1);
 		usleep_range(500, 1000);
 		gpiod_set_value(info->resetb_gpio, 0);
-		usleep_range(3000, 5000);
 	}
+	if (info->pwdn_gpio || info->resetb_gpio || info->clk)
+		usleep_range(3000, 5000);
=20
 	info->on =3D true;
 }
@@ -1630,6 +1633,8 @@ static void ov7670_power_off(struct v4l2_subdev *sd=
)
 	if (!info->on)
 		return;
=20
+	clk_disable_unprepare(info->clk);
+
 	if (info->pwdn_gpio)
 		gpiod_set_value(info->pwdn_gpio, 1);
=20
@@ -1850,24 +1855,20 @@ static int ov7670_probe(struct i2c_client *client=
,
 			return ret;
 	}
=20
-	if (info->clk) {
-		ret =3D clk_prepare_enable(info->clk);
-		if (ret)
-			return ret;
+	ret =3D ov7670_init_gpio(client, info);
+	if (ret)
+		return ret;
=20
+	ov7670_power_on(sd);
+
+	if (info->clk) {
 		info->clock_speed =3D clk_get_rate(info->clk) / 1000000;
 		if (info->clock_speed < 10 || info->clock_speed > 48) {
 			ret =3D -EINVAL;
-			goto clk_disable;
+			goto power_off;
 		}
 	}
=20
-	ret =3D ov7670_init_gpio(client, info);
-	if (ret)
-		goto clk_disable;
-
-	ov7670_power_on(sd);
-
 	/* Make sure it's an ov7670 */
 	ret =3D ov7670_detect(sd);
 	if (ret) {
@@ -1946,6 +1947,7 @@ static int ov7670_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto entity_cleanup;
=20
+	ov7670_power_off(sd);
 	return 0;
=20
 entity_cleanup:
@@ -1954,12 +1956,9 @@ static int ov7670_probe(struct i2c_client *client,
 	v4l2_ctrl_handler_free(&info->hdl);
 power_off:
 	ov7670_power_off(sd);
-clk_disable:
-	clk_disable_unprepare(info->clk);
 	return ret;
 }
=20
-
 static int ov7670_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
@@ -1967,7 +1966,6 @@ static int ov7670_remove(struct i2c_client *client)
=20
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
-	clk_disable_unprepare(info->clk);
 	media_entity_cleanup(&info->sd.entity);
 	ov7670_power_off(sd);
 	return 0;
--=20
2.20.1

