Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EA9C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD95C2085A
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfAOIzH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:55:07 -0500
Received: from shell.v3.sk ([90.176.6.54]:51314 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbfAOIzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 03:55:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 7F9514CBA5;
        Tue, 15 Jan 2019 09:55:03 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id CPw88NyThV2q; Tue, 15 Jan 2019 09:54:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 7E1304CC9B;
        Tue, 15 Jan 2019 09:54:54 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BgJ-Z2JX1Irm; Tue, 15 Jan 2019 09:54:53 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 1AAFB4CA17;
        Tue, 15 Jan 2019 09:54:53 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v4 2/5] media: ov7670: hook s_power onto v4l2 core
Date:   Tue, 15 Jan 2019 09:54:45 +0100
Message-Id: <20190115085448.1400135-3-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190115085448.1400135-1-lkundrak@v3.sk>
References: <20190115085448.1400135-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The commit 71862f63f351 ("media: ov7670: Add the ov7670_s_power function"=
)
added a power control routing. However, it was not good enough to use as
a s_power() callback: it merely flipped on the power GPIOs without
restoring the register settings.

Fix this now and register an actual power callback.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov7670.c | 50 +++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 61c47c61c693..4679aa9dc430 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -242,6 +242,7 @@ struct ov7670_info {
 	struct v4l2_mbus_framefmt format;
 	struct ov7670_format_struct *fmt;  /* Current format */
 	struct clk *clk;
+	int on;
 	struct gpio_desc *resetb_gpio;
 	struct gpio_desc *pwdn_gpio;
 	unsigned int mbus_config;	/* Media bus configuration flags */
@@ -1603,19 +1604,54 @@ static int ov7670_s_register(struct v4l2_subdev *=
sd, const struct v4l2_dbg_regis
 }
 #endif
=20
-static int ov7670_s_power(struct v4l2_subdev *sd, int on)
+static void ov7670_power_on(struct v4l2_subdev *sd)
 {
 	struct ov7670_info *info =3D to_state(sd);
=20
+	if (info->on)
+		return;
+
 	if (info->pwdn_gpio)
-		gpiod_set_value(info->pwdn_gpio, !on);
-	if (on && info->resetb_gpio) {
+		gpiod_set_value(info->pwdn_gpio, 0);
+	if (info->resetb_gpio) {
 		gpiod_set_value(info->resetb_gpio, 1);
 		usleep_range(500, 1000);
 		gpiod_set_value(info->resetb_gpio, 0);
 		usleep_range(3000, 5000);
 	}
=20
+	info->on =3D true;
+}
+
+static void ov7670_power_off(struct v4l2_subdev *sd)
+{
+	struct ov7670_info *info =3D to_state(sd);
+
+	if (!info->on)
+		return;
+
+	if (info->pwdn_gpio)
+		gpiod_set_value(info->pwdn_gpio, 1);
+
+	info->on =3D false;
+}
+
+static int ov7670_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct ov7670_info *info =3D to_state(sd);
+
+	if (info->on =3D=3D on)
+		return 0;
+
+	if (on) {
+		ov7670_power_on (sd);
+		ov7670_apply_fmt(sd);
+		ov7675_apply_framerate(sd);
+		v4l2_ctrl_handler_setup(&info->hdl);
+	} else {
+		ov7670_power_off (sd);
+	}
+
 	return 0;
 }
=20
@@ -1648,6 +1684,7 @@ static int ov7670_open(struct v4l2_subdev *sd, stru=
ct v4l2_subdev_fh *fh)
 static const struct v4l2_subdev_core_ops ov7670_core_ops =3D {
 	.reset =3D ov7670_reset,
 	.init =3D ov7670_init,
+	.s_power =3D ov7670_s_power,
 	.log_status =3D v4l2_ctrl_subdev_log_status,
 	.subscribe_event =3D v4l2_ctrl_subdev_subscribe_event,
 	.unsubscribe_event =3D v4l2_event_subdev_unsubscribe,
@@ -1812,6 +1849,7 @@ static int ov7670_probe(struct i2c_client *client,
 		else
 			return ret;
 	}
+
 	if (info->clk) {
 		ret =3D clk_prepare_enable(info->clk);
 		if (ret)
@@ -1828,7 +1866,7 @@ static int ov7670_probe(struct i2c_client *client,
 	if (ret)
 		goto clk_disable;
=20
-	ov7670_s_power(sd, 1);
+	ov7670_power_on(sd);
=20
 	/* Make sure it's an ov7670 */
 	ret =3D ov7670_detect(sd);
@@ -1915,7 +1953,7 @@ static int ov7670_probe(struct i2c_client *client,
 hdl_free:
 	v4l2_ctrl_handler_free(&info->hdl);
 power_off:
-	ov7670_s_power(sd, 0);
+	ov7670_power_off(sd);
 clk_disable:
 	clk_disable_unprepare(info->clk);
 	return ret;
@@ -1931,7 +1969,7 @@ static int ov7670_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&info->hdl);
 	clk_disable_unprepare(info->clk);
 	media_entity_cleanup(&info->sd.entity);
-	ov7670_s_power(sd, 0);
+	ov7670_power_off(sd);
 	return 0;
 }
=20
--=20
2.20.1

