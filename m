Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33414 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965402AbcKLNNk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:40 -0500
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
Subject: [PATCHv2 04/32] media: rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
Date: Sat, 12 Nov 2016 14:11:48 +0100
Message-Id: <20161112131216.22635-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
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

