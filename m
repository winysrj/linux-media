Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49787 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753698AbcLILq7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 06:46:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH v2 3/6] v4l: tvp5150: Add missing break in set control handler
Date: Fri,  9 Dec 2016 13:47:16 +0200
Message-Id: <1481284039-7960-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A break is missing resulting in the hue control enabling or disabling
the decode completely. Fix it.

Fixes: c43875f66140 ("[media] tvp5150: replace MEDIA_ENT_F_CONN_TEST by a control")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp5150.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index febe6833a504..3a0fe8cc64e9 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -818,6 +818,7 @@ static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
 		return 0;
 	case V4L2_CID_HUE:
 		tvp5150_write(sd, TVP5150_HUE_CTL, ctrl->val);
+		break;
 	case V4L2_CID_TEST_PATTERN:
 		decoder->enable = ctrl->val ? false : true;
 		tvp5150_selmux(sd);
-- 
Regards,

Laurent Pinchart

