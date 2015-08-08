Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34160 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbbHHGbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2015 02:31:00 -0400
From: Junsu Shin <jjunes0@gmail.com>
To: mchehab@osg.samsung.com, gregkh@linuxfoundation.org
Cc: hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	boris.brezillon@free-electrons.com, mahfouz.saif.elyazal@gmail.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Junsu Shin <jjunes0@gmail.com>
Subject: [PATCH] Staging: media: davinci_vpfe: Fix over 80 characters coding style issue
Date: Sat,  8 Aug 2015 01:30:48 -0500
Message-Id: <1439015448-4599-1-git-send-email-jjunes0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a patch to the dm365_ipipe.c that fixes over 80 characters warning detected.
Signed-off-by: Junsu Shin <jjunes0@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 1bbb90c..a474adf 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1536,8 +1536,9 @@ ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
  * @fse: pointer to v4l2_subdev_frame_size_enum structure.
  */
 static int
-ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
-			  struct v4l2_subdev_frame_size_enum *fse)
+ipipe_enum_frame_size(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
+		       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt format;
-- 
1.9.1

