Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49446 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752978AbcKBN3g (ORCPT
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
Subject: [PATCH 03/32] media: rcar-vin: reset bytesperline and sizeimage when resetting format
Date: Wed,  2 Nov 2016 14:23:00 +0100
Message-Id: <20161102132329.436-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two fields where forgotten when refactoring the format reset code
path. If they are not also reset at the same time as width and hight the
format read using G_FMT will not match realty.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 2bbe6d4..69bc4cf 100644
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
2.10.2

