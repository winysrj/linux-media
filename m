Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59980 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754341AbcJNRfC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:35:02 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 11/21] [media] tc358743: put lanes in STOP state before starting streaming
Date: Fri, 14 Oct 2016 19:34:31 +0200
Message-Id: <1476466481-24030-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without calling tc358743_set_csi after stopping streaming (or calling
tc358743_s_dv_timings or tc358743_set_fmt from userspace after stopping
the stream), the i.MX6 MIPI CSI2 input fails waiting for lanes to enter
STOP state when streaming is started again.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Change since v1:
 - Put lanes in stop state again after stopping streaming
---
 drivers/media/i2c/tc358743.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 1e3a0dd2..7f82932 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1466,6 +1466,10 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	enable_stream(sd, enable);
+	if (!enable) {
+		/* Put all lanes in PL-11 state (STOPSTATE) */
+		tc358743_set_csi(sd);
+	}
 
 	return 0;
 }
-- 
2.9.3

