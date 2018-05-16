Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:52410 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751210AbeEPXEq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 19:04:46 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-csi2: set default format if a unsupported one is requested
Date: Thu, 17 May 2018 01:04:33 +0200
Message-Id: <20180516230433.29194-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of failing the set_fmt() if a unsupported format is requested
set a default one and return the changed format to the user.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reported-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index e64f07fe184e7675..daef72d410a3425d 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -613,7 +613,7 @@ static int rcsi2_set_pad_format(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *framefmt;
 
 	if (!rcsi2_code_to_fmt(format->format.code))
-		return -EINVAL;
+		format->format.code = rcar_csi2_formats[0].code;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		priv->mf = format->format;
-- 
2.17.0
