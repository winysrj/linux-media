Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44257 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbdAaPt5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:49:57 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com, Wolfram Sang <wsa@the-dreams.de>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 01/11] media: rcar-vin: reset bytesperline and sizeimage when resetting format
Date: Tue, 31 Jan 2017 16:40:06 +0100
Message-Id: <20170131154016.15526-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two fields where forgotten when refactoring the format reset code
path. If they are not also reset at the same time as width and hight the
format read using G_FMT will not match reality.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
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
2.11.0

