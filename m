Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:38413 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750758AbeEKOQn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 10:16:43 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/2] rcar-vin: fix crop and compose handling for Gen3
Date: Fri, 11 May 2018 16:15:41 +0200
Message-Id: <20180511141541.3164-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180511141541.3164-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180511141541.3164-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When refactoring the Gen3 enablement series crop and compose handling
where broken. This went unnoticed but can result in writing out side the
capture buffer. Fix this by restoring the crop and compose to reflect
the format dimensions as we have not yet enabled the scaler for Gen3.

Fixes: 5e7c623632fcf8f5 ("media: rcar-vin: use different v4l2 operations in media controller mode")
Reported-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 2fb8587116f25a4f..e78fba84d59028ef 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -702,6 +702,12 @@ static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	vin->format = f->fmt.pix;
 
+	vin->crop.top = 0;
+	vin->crop.left = 0;
+	vin->crop.width = vin->format.width;
+	vin->crop.height = vin->format.height;
+	vin->compose = vin->crop;
+
 	return 0;
 }
 
-- 
2.17.0
