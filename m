Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:32775 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbbHJVlb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 17:41:31 -0400
From: Junsu Shin <jjunes0@gmail.com>
To: mchehab@osg.samsung.com
Cc: hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	mahfouz.saif.elyazal@gmail.com, boris.brezillon@free-electrons.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Junsu Shin <jjunes0@gmail.com>
Subject: [PATCH v2] Staging: media: davinci_vpfe: Fix over 80 characters coding style issue
Date: Mon, 10 Aug 2015 16:40:59 -0500
Message-Id: <1439242859-12268-1-git-send-email-jjunes0@gmail.com>
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

