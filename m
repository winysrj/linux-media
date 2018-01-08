Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1.7nn.fshared.sendgrid.net ([167.89.55.65]:48559 "EHLO
        o1.7nn.fshared.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753879AbeAHRjh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 12:39:37 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: i2c: adv748x: fix HDMI field heights
Date: Mon, 08 Jan 2018 17:39:30 +0000 (UTC)
Message-Id: <1515433167-15912-1-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV748x handles interlaced media using V4L2_FIELD_ALTERNATE field
types.  The correct specification for the height on the mbus is the
image height, in this instance, the field height.

The AFE component already correctly adjusts the height on the mbus, but
the HDMI component got left behind.

Adjust the mbus height to correctly describe the image height of the
fields when processing interlaced video for HDMI pipelines.

Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/i2c/adv748x/adv748x-hdmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
index 4da4253553fc..0e2f76f3f029 100644
--- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
+++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
@@ -105,6 +105,10 @@ static void adv748x_hdmi_fill_format(struct adv748x_hdmi *hdmi,
 
 	fmt->width = hdmi->timings.bt.width;
 	fmt->height = hdmi->timings.bt.height;
+
+	/* Propagate field height on the mbus for FIELD_ALTERNATE fmts */
+	if (hdmi->timings.bt.interlaced)
+		fmt->height /= 2;
 }
 
 static void adv748x_fill_optional_dv_timings(struct v4l2_dv_timings *timings)
-- 
2.7.4
