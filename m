Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:27599 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751125AbdFBMSu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 08:18:50 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v52CDLsZ011757
        for <linux-media@vger.kernel.org>; Fri, 2 Jun 2017 13:18:49 +0100
Received: from mail-wm0-f71.google.com (mail-wm0-f71.google.com [74.125.82.71])
        by mx07-00252a01.pphosted.com with ESMTP id 2apxuyawfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 13:18:49 +0100
Received: by mail-wm0-f71.google.com with SMTP id r203so16818213wmb.2
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 05:18:49 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH 1/3] [media] tc358743: Add enum_mbus_code
Date: Fri,  2 Jun 2017 13:18:12 +0100
Message-Id: <bca85f68840a079ca4702d5d859e1f02f7f55dcd.1496398217.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
References: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1496398217.git.dave.stevenson@raspberrypi.org>
References: <cover.1496398217.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was no way to query the supported mbus formats from this
driver. enum_mbus_code is the function to expose that, so
implement it.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
 drivers/media/i2c/tc358743.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 3251cba..06bfdca 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1473,6 +1473,23 @@ static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
 
 /* --------------- PAD OPS --------------- */
 
+static int tc358743_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
+{
+	switch (code->index) {
+	case 0:
+		code->code = MEDIA_BUS_FMT_RGB888_1X24;
+		break;
+	case 1:
+		code->code = MEDIA_BUS_FMT_UYVY8_1X16;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int tc358743_get_fmt(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *format)
@@ -1642,6 +1659,7 @@ static const struct v4l2_subdev_video_ops tc358743_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops tc358743_pad_ops = {
+	.enum_mbus_code = tc358743_enum_mbus_code,
 	.set_fmt = tc358743_set_fmt,
 	.get_fmt = tc358743_get_fmt,
 	.get_edid = tc358743_g_edid,
-- 
2.7.4
