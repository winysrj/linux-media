Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:19743 "EHLO
        bin-vsp-out-03.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751639AbeA2Qfk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 11:35:40 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v10 19/30] rcar-vin: set a default field to fallback on
Date: Mon, 29 Jan 2018 17:34:24 +0100
Message-Id: <20180129163435.24936-20-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the field is not supported by the driver it should not try to keep
the current field. Instead it should set it to a default fallback. Since
trying a format should always result in the same state regardless of the
current state of the device.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 6403650aff22a2ed..f69ae76b3fda50c7 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -23,6 +23,7 @@
 #include "rcar-vin.h"
 
 #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
+#define RVIN_DEFAULT_FIELD	V4L2_FIELD_NONE
 #define RVIN_DEFAULT_COLORSPACE	V4L2_COLORSPACE_SRGB
 
 /* -----------------------------------------------------------------------------
@@ -171,7 +172,7 @@ static int rvin_get_source_format(struct rvin_dev *vin,
 		fmt.format.height *= 2;
 		break;
 	default:
-		vin->format.field = V4L2_FIELD_NONE;
+		vin->format.field = RVIN_DEFAULT_FIELD;
 		break;
 	}
 
@@ -267,9 +268,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
 {
 	int ret;
 
-	/* Keep current field if no specific one is asked for */
 	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = vin->format.field;
+		pix->field = RVIN_DEFAULT_FIELD;
 
 	/* Limit to source capabilities */
 	ret = __rvin_try_format_source(vin, which, pix);
-- 
2.16.1
