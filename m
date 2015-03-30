Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60951 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbbC3LLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 07/12] [media] tc358743: also set TCLK_TRAILCNT and TCLK_POSTCNT
Date: Mon, 30 Mar 2015 13:10:51 +0200
Message-Id: <1427713856-10240-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 34acfed..a510a14 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -749,6 +749,8 @@ static void tc358743_set_csi(struct v4l2_subdev *sd)
 	i2c_wr32(sd, THS_HEADERCNT, pdata->ths_headercnt);
 	i2c_wr32(sd, TWAKEUP, pdata->twakeup);
 	i2c_wr32(sd, THS_TRAILCNT, pdata->ths_trailcnt);
+	i2c_wr32(sd, TCLK_TRAILCNT, pdata->tclk_trailcnt);
+	i2c_wr32(sd, TCLK_POSTCNT, pdata->tclk_postcnt);
 	i2c_wr32(sd, HSTXVREGCNT, pdata->hstxvregcnt);
 
 	i2c_wr32(sd, HSTXVREGEN,
-- 
2.1.4

