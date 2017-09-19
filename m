Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:28471 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750972AbdISNJc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 09:09:32 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8JD9UD7006048
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 14:09:30 +0100
Received: from mail-wm0-f72.google.com (mail-wm0-f72.google.com [74.125.82.72])
        by mx07-00252a01.pphosted.com with ESMTP id 2d0sc01jc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 14:09:30 +0100
Received: by mail-wm0-f72.google.com with SMTP id u138so3873605wmu.2
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 06:09:30 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH 1/3] [media] tc358743: Correct clock mode reported in g_mbus_config
Date: Tue, 19 Sep 2017 14:08:51 +0100
Message-Id: <f6e576dde2640bcf6a79d157f83c96ca13c453a3.1505826082.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for non-continuous clock had previously been added via
device tree, but a comment and the value reported by g_mbus_config
still stated that it wasn't supported.
Remove the comment, and return the correct value in g_mbus_config.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
 drivers/media/i2c/tc358743.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e6f5c36..6b0fd07 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1461,8 +1461,9 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 
 	cfg->type = V4L2_MBUS_CSI2;
 
-	/* Support for non-continuous CSI-2 clock is missing in the driver */
-	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	cfg->flags = state->bus.flags &
+			(V4L2_MBUS_CSI2_CONTINUOUS_CLOCK |
+			 V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK);
 
 	switch (state->csi_lanes_in_use) {
 	case 1:
-- 
2.7.4
