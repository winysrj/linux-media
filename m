Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60960 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbbC3LLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:20 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 11/12] [media] tc358743: don't return E2BIG from G_EDID
Date: Mon, 30 Mar 2015 13:10:55 +0200
Message-Id: <1427713856-10240-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

E2BIG is meant to be returned by S_EDID if userspace provided more data than
the hardware can handle. If userspace requested too much data with G_EDID, we
should silently correct the number of EDID blocks downwards.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 02b131b..7d70acc 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1560,10 +1560,11 @@ static int tc358743_g_edid(struct v4l2_subdev *sd,
 	if (edid->blocks == 0)
 		return -EINVAL;
 
-	if (edid->start_block + edid->blocks > 8) {
-		edid->blocks = 8;
-		return -E2BIG;
-	}
+	if (edid->start_block >= 8)
+		return -EINVAL;
+
+	if (edid->start_block + edid->blocks > 8)
+		edid->blocks = 8 - edid->start_block;
 
 	if (!edid->edid)
 		return -EINVAL;
-- 
2.1.4

