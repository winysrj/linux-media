Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43224 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab1AJWSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 17:18:47 -0500
Received: by gxk9 with SMTP id 9so5106158gxk.19
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 14:18:47 -0800 (PST)
From: Roberto Rodriguez Alcala <rralcala@gmail.com>
To: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Cc: Roberto Rodriguez Alcala <rralcala@gmail.com>
Subject: [PATCH 2/2] [media] ov7670: Allow configuration of night mode
Date: Mon, 10 Jan 2011 19:18:27 -0300
Message-Id: <1294697907-1714-3-git-send-email-rralcala@gmail.com>
In-Reply-To: <1294697907-1714-1-git-send-email-rralcala@gmail.com>
References: <1294697907-1714-1-git-send-email-rralcala@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Roberto Rodriguez Alcala <rralcala@gmail.com> 


Signed-off-by: Roberto Rodriguez Alcala <rralcala@gmail.com>
---
 drivers/media/video/ov7670.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index c881a64..cfe96e5 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -1255,6 +1255,36 @@ static int ov7670_s_gain(struct v4l2_subdev *sd, int value)
 }
 
 /*
+ * Get or Set Night Mode.
+ */
+static int ov7670_g_nightmode(struct v4l2_subdev *sd, __s32 *value)
+{
+	int ret;
+	unsigned char com11;
+
+	ret = ov7670_read(sd, REG_COM11, &com11);
+	*value = (com11 & COM11_NIGHT) != 0;
+	return ret;
+}
+
+static int ov7670_s_nightmode(struct v4l2_subdev *sd, int value)
+{
+	int ret;
+	unsigned char com11;
+
+	ret = ov7670_read(sd, REG_COM11, &com11);
+	if (ret == 0) {
+		if (value)
+			com11 |= COM11_NIGHT;
+		else
+			com11 &= ~COM11_NIGHT;
+		ret = ov7670_write(sd, REG_COM11, com11);
+	}
+	return ret;
+}
+
+
+/*
  * Tweak autogain.
  */
 static int ov7670_g_autogain(struct v4l2_subdev *sd, __s32 *value)
@@ -1382,6 +1412,8 @@ static int ov7670_queryctrl(struct v4l2_subdev *sd,
 		return v4l2_ctrl_query_fill(qc, 0, 65535, 1, 500);
 	case V4L2_CID_EXPOSURE_AUTO:
 		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
+	case V4L2_CID_NIGHT_MODE:
+		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
 	}
 	return -EINVAL;
 }
@@ -1409,6 +1441,8 @@ static int ov7670_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		return ov7670_g_exp(sd, &ctrl->value);
 	case V4L2_CID_EXPOSURE_AUTO:
 		return ov7670_g_autoexp(sd, &ctrl->value);
+	case V4L2_CID_NIGHT_MODE:
+		return ov7670_g_nightmode(sd, &ctrl->value);
 	}
 	return -EINVAL;
 }
@@ -1437,6 +1471,8 @@ static int ov7670_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	case V4L2_CID_EXPOSURE_AUTO:
 		return ov7670_s_autoexp(sd,
 				(enum v4l2_exposure_auto_type) ctrl->value);
+	case V4L2_CID_NIGHT_MODE:
+		return ov7670_s_nightmode(sd, ctrl->value);
 	}
 	return -EINVAL;
 }
-- 
1.7.3.2

