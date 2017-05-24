Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:46773 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765686AbdEXARE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:17:04 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 17/17] rcar-vin: fix bug in pixelformat selection
Date: Wed, 24 May 2017 02:15:40 +0200
Message-Id: <20170524001540.13613-18-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

If the requested pixelformat is not supported fallback to the default
format, do not revert the entire format.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index de71e5fa8b10cb5e..81ff59c3b4744075 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -206,7 +206,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 			     struct v4l2_pix_format *pix,
 			     struct rvin_source_fmt *source)
 {
-	const struct rvin_video_format *info;
 	u32 rwidth, rheight, walign;
 	int ret;
 
@@ -218,17 +217,11 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	if (pix->field == V4L2_FIELD_ANY)
 		pix->field = vin->format.field;
 
-	/*
-	 * Retrieve format information and select the current format if the
-	 * requested format isn't supported.
-	 */
-	info = rvin_format_from_pixel(pix->pixelformat);
-	if (!info) {
-		vin_dbg(vin, "Format %x not found, keeping %x\n",
-			pix->pixelformat, vin->format.pixelformat);
-		*pix = vin->format;
-		pix->width = rwidth;
-		pix->height = rheight;
+	/* If requested format is not supported fallback to the default */
+	if (!rvin_format_from_pixel(pix->pixelformat)) {
+		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
+			pix->pixelformat, RVIN_DEFAULT_FORMAT);
+		pix->pixelformat = RVIN_DEFAULT_FORMAT;
 	}
 
 	/* Always recalculate */
-- 
2.13.0
