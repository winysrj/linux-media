Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44325 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdAaPuD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:50:03 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 02/11] media: rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
Date: Tue, 31 Jan 2017 16:40:07 +0100
Message-Id: <20170131154016.15526-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
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
index 69bc4cfea6a8aeb5..7ca27599b9982ffc 100644
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
2.11.0

