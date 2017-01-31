Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44273 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbdAaPt5 (ORCPT
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
Subject: [PATCH 09/11] media: rcar-vin: use pad information when verifying media bus format
Date: Tue, 31 Jan 2017 16:40:14 +0100
Message-Id: <20170131154016.15526-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use information about pad index when enumerating mbus codes.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index e9373d9ab97fb827..50058fe9e37d8771 100644
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
2.11.0

