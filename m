Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56565 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932170AbbEUJDN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:13 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 16/20] media: adv7180: Fix set_pad_format() passing wrong format
Date: Wed, 20 May 2015 17:39:36 +0100
Message-Id: <1432139980-12619-17-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return a usable format (and resolution) from adv7180_set_pad_format()
in the TRY_FORMAT case

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Tested-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/i2c/adv7180.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 09a96df..ba0b92d5 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -686,12 +686,14 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 			adv7180_set_field_mode(state);
 			adv7180_set_power(state, true);
 		}
+		adv7180_mbus_fmt(sd, framefmt);
 	} else {
 		framefmt = v4l2_subdev_get_try_format(sd, cfg, 0);
 		*framefmt = format->format;
+		adv7180_mbus_fmt(sd, framefmt);
+		format->format = *framefmt;
 	}
-
-	return adv7180_mbus_fmt(sd, framefmt);
+	return 0;
 }
 
 static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
-- 
1.7.10.4

