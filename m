Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39136 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752931AbdHKJ5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:22 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 04/20] v4l2-core: check that both pads in a link are muxed if one are
Date: Fri, 11 Aug 2017 11:56:47 +0200
Message-Id: <20170811095703.6170-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since multiplexed pads carry multiple streams it's not possible to
verify the format for a specific stream at this time. Instead make sure
both pads are marked as multiplexed and skip the format checking.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 43fefa73e0a3f64f..d6c1a3b777dd2fcd 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -547,6 +547,15 @@ int v4l2_subdev_link_validate(struct media_link *link)
 	struct v4l2_subdev_format sink_fmt, source_fmt;
 	int rval;
 
+	/* Require both pads in a link to be multiplexed if one is */
+	if ((link->source->flags | link->sink->flags) & MEDIA_PAD_FL_MUXED) {
+		if ((link->source->flags & MEDIA_PAD_FL_MUXED) == 0)
+			return -EINVAL;
+		if ((link->sink->flags & MEDIA_PAD_FL_MUXED) == 0)
+			return -EINVAL;
+		return 0;
+	}
+
 	rval = v4l2_subdev_link_validate_get_format(
 		link->source, &source_fmt);
 	if (rval < 0)
-- 
2.13.3
