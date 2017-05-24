Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:46719 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765571AbdEXAQ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:16:59 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 01/17] rcar-vin: reset bytesperline and sizeimage when resetting format
Date: Wed, 24 May 2017 02:15:24 +0200
Message-Id: <20170524001540.13613-2-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

These two were forgotten when refactoring the format reset code. If
they are not also reset at the same time as width and height the format
returned from G_FMT will not match reality.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 2bbe6d495fa634da..69bc4cfea6a8aeb5 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -151,6 +151,9 @@ static int rvin_reset_format(struct rvin_dev *vin)
 
 	rvin_reset_crop_compose(vin);
 
+	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
+	vin->format.sizeimage = rvin_format_sizeimage(&vin->format);
+
 	return 0;
 }
 
-- 
2.13.0
