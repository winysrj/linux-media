Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49774 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753610AbcLILq5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 06:46:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH v2 1/6] v4l: tvp5150: Compile tvp5150_link_setup out if !CONFIG_MEDIA_CONTROLLER
Date: Fri,  9 Dec 2016 13:47:14 +0200
Message-Id: <1481284039-7960-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function is only referenced as a handler in the tvp5150_sd_media_ops
structure, which is only used when CONFIG_MEDIA_CONTROLLER is set. Don't
define the function and the structure when the configuration option is
unset to avoid an unused function warning.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp5150.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 6737685d5be5..08384951c9e5 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1013,11 +1013,11 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
 			Media entity ops
  ****************************************************************************/
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 static int tvp5150_link_setup(struct media_entity *entity,
 			      const struct media_pad *local,
 			      const struct media_pad *remote, u32 flags)
 {
-#ifdef CONFIG_MEDIA_CONTROLLER
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	int i;
@@ -1034,7 +1034,6 @@ static int tvp5150_link_setup(struct media_entity *entity,
 	decoder->input = i;
 
 	tvp5150_selmux(sd);
-#endif
 
 	return 0;
 }
@@ -1042,6 +1041,7 @@ static int tvp5150_link_setup(struct media_entity *entity,
 static const struct media_entity_operations tvp5150_sd_media_ops = {
 	.link_setup = tvp5150_link_setup,
 };
+#endif
 
 /****************************************************************************
 			I2C Command
-- 
Regards,

Laurent Pinchart

