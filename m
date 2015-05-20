Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56409 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932126AbbEUJC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:02:59 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 18/20] media: adv7604: Always query_dv_timings in adv76xx_fill_format
Date: Wed, 20 May 2015 17:39:38 +0100
Message-Id: <1432139980-12619-19-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure we're always reporting the current format of the input.
Fixes start of day bugs.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/i2c/adv7604.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d77ee1f..526fa4e 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1787,8 +1787,12 @@ static int adv76xx_enum_mbus_code(struct v4l2_subdev *sd,
 static void adv76xx_fill_format(struct adv76xx_state *state,
 				struct v4l2_mbus_framefmt *format)
 {
+	struct v4l2_subdev *sd = &state->sd;
+
 	memset(format, 0, sizeof(*format));
 
+	v4l2_subdev_call(sd, video, query_dv_timings, &state->timings);
+
 	format->width = state->timings.bt.width;
 	format->height = state->timings.bt.height;
 
-- 
1.7.10.4

