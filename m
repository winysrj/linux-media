Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:50152 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbeKTUcf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:32:35 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: [PATCH v3 10/14] [media] marvell-ccic/mmp: enable clock before accessing registers
Date: Tue, 20 Nov 2018 11:03:15 +0100
Message-Id: <20181120100318.367987-11-lkundrak@v3.sk>
In-Reply-To: <20181120100318.367987-1-lkundrak@v3.sk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The access to REG_CLKCTRL or REG_CTRL1 without the clock enabled hangs
the machine. Enable the clock first.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/platform/marvell-ccic/mmp-driver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/m=
edia/platform/marvell-ccic/mmp-driver.c
index f2e43b23af18..05cba74c0d13 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -144,6 +144,7 @@ static int mmpcam_power_up(struct mcam_camera *mcam)
  * Turn on power and clocks to the controller.
  */
 	mmpcam_power_up_ctlr(cam);
+	mcam_clk_enable(mcam);
 /*
  * Provide power to the sensor.
  */
@@ -157,8 +158,6 @@ static int mmpcam_power_up(struct mcam_camera *mcam)
 	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
 	mdelay(5);
=20
-	mcam_clk_enable(mcam);
-
 	return 0;
 }
=20
--=20
2.19.1
