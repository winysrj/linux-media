Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49502 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754253AbcKBN3j (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:39 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 10/32] media: rcar-vin: use pad information when verifying media bus format
Date: Wed,  2 Nov 2016 14:23:07 +0100
Message-Id: <20161102132329.436-11-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the pad information is present in struct rvin_graph_entity use
it when verifying the media bus format.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 2c40b6a..fb6368c 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -48,6 +48,7 @@ static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
 	};
 
 	code.index = 0;
+	code.pad = entity->source_pad_idx;
 	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
 		code.index++;
 		switch (code.code) {
-- 
2.10.2

