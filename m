Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:56020 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbcGSOXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:11 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 05/16] [media] rcar-vin: do not use v4l2_device_call_until_err()
Date: Tue, 19 Jul 2016 16:20:56 +0200
Message-Id: <20160719142107.22358-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a error from the original driver where v4l2_device_call_until_err()
where used for the pad specific v4l2 operation set_fmt.  Also fix up the
error path from this fix so if there is an error it will be propagated
to the caller.

The error path label have also been renamed as a result from a
nitpicking review comment since we are fixing other issues here.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 10a5c10..5dceff8 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -114,10 +114,9 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	format.pad = vin->src_pad_idx;
 
-	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
-					 pad_cfg, &format);
-	if (ret < 0)
-		goto cleanup;
+	ret = v4l2_subdev_call(sd, pad, set_fmt, pad_cfg, &format);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto done;
 
 	v4l2_fill_pix_format(pix, &format.format);
 
@@ -127,9 +126,9 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
 		source->height);
 
-cleanup:
+done:
 	v4l2_subdev_free_pad_config(pad_cfg);
-	return 0;
+	return ret;
 }
 
 static int __rvin_try_format(struct rvin_dev *vin,
-- 
2.9.0

