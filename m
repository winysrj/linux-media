Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49455 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753543AbcKBN3g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:36 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 04/32] media: rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
Date: Wed,  2 Nov 2016 14:23:01 +0100
Message-Id: <20161102132329.436-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use rvin_reset_format() in rvin_s_dv_timings() instead if just resetting
a few fields. This fixes an issue where the field format was not
properly set after S_DV_TIMINGS.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 69bc4cf..7ca2759 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -573,12 +573,8 @@ static int rvin_s_dv_timings(struct file *file, void *priv_fh,
 	if (ret)
 		return ret;
 
-	vin->source.width = timings->bt.width;
-	vin->source.height = timings->bt.height;
-	vin->format.width = timings->bt.width;
-	vin->format.height = timings->bt.height;
-
-	return 0;
+	/* Changing the timings will change the width/height */
+	return rvin_reset_format(vin);
 }
 
 static int rvin_g_dv_timings(struct file *file, void *priv_fh,
-- 
2.10.2

