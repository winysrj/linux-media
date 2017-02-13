Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:36507 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751456AbdBMLkv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 06:40:51 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 2/4] media-ctl: print the configured frame interval
Date: Mon, 13 Feb 2017 12:40:45 +0100
Message-Id: <1486986047-18128-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1486986047-18128-1-git-send-email-p.zabel@pengutronix.de>
References: <1486986047-18128-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After the pad format, also print the frame interval, if already configured.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/media-ctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index 572bcf7..383fbfa 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -79,6 +79,7 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 	unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	struct v4l2_mbus_framefmt format;
+	struct v4l2_fract interval = { 0, 0 };
 	struct v4l2_rect rect;
 	int ret;
 
@@ -86,10 +87,17 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 	if (ret != 0)
 		return;
 
+	ret = v4l2_subdev_get_frame_interval(entity, &interval, pad);
+	if (ret != 0 && ret != -ENOTTY)
+		return;
+
 	printf("\t\t[fmt:%s/%ux%u",
 	       v4l2_subdev_pixelcode_to_string(format.code),
 	       format.width, format.height);
 
+	if (interval.numerator || interval.denominator)
+		printf("@%u/%u", interval.numerator, interval.denominator);
+
 	if (format.field)
 		printf(" field:%s", v4l2_subdev_field_to_string(format.field));
 
-- 
2.1.4
