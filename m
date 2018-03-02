Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:24353 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1163926AbeCBB7E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:04 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 11/32] rcar-vin: set a default field to fallback on
Date: Fri,  2 Mar 2018 02:57:30 +0100
Message-Id: <20180302015751.25596-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
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
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index c2265324c7c96308..ebcd78b1bb6e8cb6 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -23,6 +23,7 @@
 #include "rcar-vin.h"
 
 #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
+#define RVIN_DEFAULT_FIELD	V4L2_FIELD_NONE
 
 /* -----------------------------------------------------------------------------
  * Format Conversions
@@ -143,7 +144,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
 	case V4L2_FIELD_INTERLACED:
 		break;
 	default:
-		vin->format.field = V4L2_FIELD_NONE;
+		vin->format.field = RVIN_DEFAULT_FIELD;
 		break;
 	}
 
@@ -213,10 +214,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	u32 walign;
 	int ret;
 
-	/* Keep current field if no specific one is asked for */
-	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = vin->format.field;
-
 	/* If requested format is not supported fallback to the default */
 	if (!rvin_format_from_pixel(pix->pixelformat)) {
 		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
@@ -246,7 +243,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	case V4L2_FIELD_INTERLACED:
 		break;
 	default:
-		pix->field = V4L2_FIELD_NONE;
+		pix->field = RVIN_DEFAULT_FIELD;
 		break;
 	}
 
-- 
2.16.2
