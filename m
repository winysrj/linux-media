Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:51871 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751075AbeDNMAB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 08:00:01 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v14 11/33] rcar-vin: set a default field to fallback on
Date: Sat, 14 Apr 2018 13:57:04 +0200
Message-Id: <20180414115726.5075-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
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
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

---

* Changes since v12
- Moved field != V4L2_FIELD_ANY check from a later commit 'rcar-vin:
  simplify how formats are set and reset' in the series. This is to
  avoid ignoring the field returned from the sensor if FIELD_ANY was
  requested by the user. This was only a problem between this change and
  a few patches later, but better to fix it now. Reported by Hans,
  thanks for spotting this.
- Add review tag from Hans.
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index c2265324c7c96308..16e895657c3f51c5 100644
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
 
@@ -193,7 +194,9 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	source->width = pix->width;
 	source->height = pix->height;
 
-	pix->field = field;
+	if (field != V4L2_FIELD_ANY)
+		pix->field = field;
+
 	pix->width = width;
 	pix->height = height;
 
@@ -213,10 +216,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	u32 walign;
 	int ret;
 
-	/* Keep current field if no specific one is asked for */
-	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = vin->format.field;
-
 	/* If requested format is not supported fallback to the default */
 	if (!rvin_format_from_pixel(pix->pixelformat)) {
 		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
@@ -246,7 +245,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	case V4L2_FIELD_INTERLACED:
 		break;
 	default:
-		pix->field = V4L2_FIELD_NONE;
+		pix->field = RVIN_DEFAULT_FIELD;
 		break;
 	}
 
-- 
2.16.2
