Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:54957 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726669AbeI0D4H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 23:56:07 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        jacopo mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-vin: fix redeclaration of symbol
Date: Wed, 26 Sep 2018 23:40:06 +0200
Message-Id: <20180926214006.28486-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding support for parallel subdev for Gen3 it was missed that the
symbol 'i' in rvin_group_link_notify() was already declare, remove the
dupe as it's only used as a loop variable this have no functional
change. This fixes warning:

    rcar-core.c:117:52: originally declared here
    rcar-core.c:173:30: warning: symbol 'i' shadows an earlier one

Fixes: 1284605dc821cebd ("media: rcar-vin: Handle parallel subdev in link_notify")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 5dd16af3625c333b..01e418c2d4c6792e 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -170,7 +170,6 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 
 	if (csi_id == -ENODEV) {
 		struct v4l2_subdev *sd;
-		unsigned int i;
 
 		/*
 		 * Make sure the source entity subdevice is registered as
-- 
2.19.0
