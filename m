Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47988 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEPBxd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 May 2014 21:53:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] tvp5150: Replace container_of() with to_tvp5150()
Date: Fri, 16 May 2014 03:53:31 +0200
Message-Id: <1400205211-24161-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the driver-specific inline function to cast from a subdev pointer to
a tvp5150 pointer instead of the generic container_of().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp5150.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 4fd3688..07dee44 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -913,7 +913,7 @@ static int tvp5150_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 
 static int tvp5150_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
-	struct tvp5150 *decoder = container_of(sd, struct tvp5150, sd);
+	struct tvp5150 *decoder = to_tvp5150(sd);
 
 	a->c	= decoder->rect;
 	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -923,7 +923,7 @@ static int tvp5150_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 
 static int tvp5150_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
-	struct tvp5150 *decoder = container_of(sd, struct tvp5150, sd);
+	struct tvp5150 *decoder = to_tvp5150(sd);
 	v4l2_std_id std;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-- 
1.8.5.5

