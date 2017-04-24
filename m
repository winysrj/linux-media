Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1428406AbdDXSNy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 14:13:54 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: niklas.soderlund@ragnatech.se
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 1/2] rcar-vin: Verify pads on linkage
Date: Mon, 24 Apr 2017 19:13:47 +0100
Message-Id: <1493057627-27881-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The current code determines the pad from the identifiers in the DTB.
This is accepted without bounds in the driver.

Invalid port/reg addresses defined in the DTB will cause a kernel panic
when dereferencing non-existing pads.

Protect the linkage with a check that the pad numbers are valid.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 893018963847..48557628e76d 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -613,6 +613,18 @@ static int rvin_group_add_link(struct rvin_dev *vin,
 	struct media_pad *source_pad, *sink_pad;
 	int ret = 0;
 
+	if (source_idx >= source->num_pads) {
+		vin_err(vin, "Source pad idx %d is greater than pad count %d\n",
+			source_idx, source->num_pads);
+		return -EINVAL;
+	}
+
+	if (sink_idx >= sink->num_pads) {
+		vin_err(vin, "Sink pad idx %d is greater than pad count %d\n",
+			source_idx, source->num_pads);
+		return -EINVAL;
+	}
+
 	source_pad = &source->pads[source_idx];
 	sink_pad = &sink->pads[sink_idx];
 
-- 
2.7.4
