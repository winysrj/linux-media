Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47141 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdCNTKH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:10:07 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 15/16] rcar-vin: add missing error check to propagate error
Date: Tue, 14 Mar 2017 19:59:56 +0100
Message-Id: <20170314185957.25253-16-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The return value of __rvin_try_format_source is not checked, add a check
and propagate the error.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index c40f5bc3e3d26472..956092ba6ef9bc6f 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -208,6 +208,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
 {
 	const struct rvin_video_format *info;
 	u32 rwidth, rheight, walign;
+	int ret;
 
 	/* Requested */
 	rwidth = pix->width;
@@ -235,7 +236,9 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	pix->sizeimage = 0;
 
 	/* Limit to source capabilities */
-	__rvin_try_format_source(vin, which, pix, source);
+	ret = __rvin_try_format_source(vin, which, pix, source);
+	if (ret)
+		return ret;
 
 	switch (pix->field) {
 	case V4L2_FIELD_TOP:
-- 
2.12.0
