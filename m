Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36493 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752469AbcIORdg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 13:33:36 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, ulrich.hecht+renesas@gmail.com,
        laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk
Subject: [PATCH v9 2/2] media: rcar-vin: use sink pad index for DV timings
Date: Thu, 15 Sep 2016 19:33:24 +0200
Message-Id: <20160915173324.24539-3-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <20160915173324.24539-1-ulrich.hecht+renesas@gmail.com>
References: <20160915173324.24539-1-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index f35005c..2bbe6d4 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -550,7 +550,7 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
 	int pad, ret;
 
 	pad = timings->pad;
-	timings->pad = vin->src_pad_idx;
+	timings->pad = vin->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
 
@@ -604,7 +604,7 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
 	int pad, ret;
 
 	pad = cap->pad;
-	cap->pad = vin->src_pad_idx;
+	cap->pad = vin->sink_pad_idx;
 
 	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
 
-- 
2.9.3

