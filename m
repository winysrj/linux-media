Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54463 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753163AbeB0Pkp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:40:45 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 02/13] media: tw9910: Empty line before end-of-function return
Date: Tue, 27 Feb 2018 16:40:19 +0100
Message-Id: <1519746030-15407-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an empty line before return at the end of functions.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/tw9910.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index 70e0ae2..3e4b530 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -753,6 +753,7 @@ static int tw9910_get_selection(struct v4l2_subdev *sd,
 		sel->r.width	= 768;
 		sel->r.height	= 576;
 	}
+
 	return 0;
 }
 
@@ -804,6 +805,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
 		mf->width	= width;
 		mf->height	= height;
 	}
+
 	return ret;
 }
 
@@ -842,6 +844,7 @@ static int tw9910_set_fmt(struct v4l2_subdev *sd,
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		return tw9910_s_fmt(sd, mf);
 	cfg->try_fmt = *mf;
+
 	return 0;
 }
 
@@ -887,6 +890,7 @@ static int tw9910_video_probe(struct i2c_client *client)
 
 done:
 	tw9910_s_power(&priv->subdev, 0);
+
 	return ret;
 }
 
@@ -906,12 +910,14 @@ static int tw9910_enum_mbus_code(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
+
 	return 0;
 }
 
 static int tw9910_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
 {
 	*norm = V4L2_STD_NTSC | V4L2_STD_PAL;
+
 	return 0;
 }
 
-- 
2.7.4
