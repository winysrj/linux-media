Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:54264 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbcHOPHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 11:07:20 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	sergei.shtylyov@cogentembedded.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 02/10] [media] rcar-vin: reduce indentation in rvin_s_dv_timings()
Date: Mon, 15 Aug 2016 17:06:27 +0200
Message-Id: <20160815150635.22637-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Align style with the rest of the driver.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index f26e3cd..72fe6bc 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -504,16 +504,18 @@ static int rvin_s_dv_timings(struct file *file, void *priv_fh,
 {
 	struct rvin_dev *vin = video_drvdata(file);
 	struct v4l2_subdev *sd = vin_to_source(vin);
-	int err;
-
-	err = v4l2_subdev_call(sd, video, s_dv_timings, timings);
-	if (!err) {
-		vin->source.width = timings->bt.width;
-		vin->source.height = timings->bt.height;
-		vin->format.width = timings->bt.width;
-		vin->format.height = timings->bt.height;
-	}
-	return err;
+	int ret;
+
+	ret = v4l2_subdev_call(sd, video, s_dv_timings, timings);
+	if (ret)
+		return ret;
+
+	vin->source.width = timings->bt.width;
+	vin->source.height = timings->bt.height;
+	vin->format.width = timings->bt.width;
+	vin->format.height = timings->bt.height;
+
+	return 0;
 }
 
 static int rvin_g_dv_timings(struct file *file, void *priv_fh,
-- 
2.9.2

