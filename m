Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:1909 "EHLO
        bin-vsp-out-03.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751630AbeA2Qfh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 11:35:37 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v10 17/30] rcar-vin: update pixelformat check for M1
Date: Mon, 29 Jan 2018 17:34:22 +0100
Message-Id: <20180129163435.24936-18-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the pixelformat is not supported it should not fail but be set to
something that works. While we are at it move the check together with
other pixelformat checks of this function.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index bca6e204a574772f..841d62ca27e026d7 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -97,6 +97,10 @@ static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
 		pix->pixelformat = RVIN_DEFAULT_FORMAT;
 	}
 
+	if (vin->info->model == RCAR_M1 &&
+	    pix->pixelformat == V4L2_PIX_FMT_XBGR32)
+		pix->pixelformat = RVIN_DEFAULT_FORMAT;
+
 	/* Reject ALTERNATE  until support is added to the driver */
 	switch (pix->field) {
 	case V4L2_FIELD_TOP:
@@ -121,12 +125,6 @@ static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
 	pix->bytesperline = rvin_format_bytesperline(pix);
 	pix->sizeimage = rvin_format_sizeimage(pix);
 
-	if (vin->info->model == RCAR_M1 &&
-	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
-		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
-		return -EINVAL;
-	}
-
 	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
 		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
 
-- 
2.16.1
