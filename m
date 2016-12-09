Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49790 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753610AbcLILq7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 06:46:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH v2 2/6] v4l: tvp5150: Don't inline the tvp5150_selmux() function
Date: Fri,  9 Dec 2016 13:47:15 +0200
Message-Id: <1481284039-7960-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function is large and called in several places, don't inline it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp5150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 08384951c9e5..febe6833a504 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -258,7 +258,7 @@ static int tvp5150_log_status(struct v4l2_subdev *sd)
 			Basic functions
  ****************************************************************************/
 
-static inline void tvp5150_selmux(struct v4l2_subdev *sd)
+static void tvp5150_selmux(struct v4l2_subdev *sd)
 {
 	int opmode = 0;
 	struct tvp5150 *decoder = to_tvp5150(sd);
-- 
Regards,

Laurent Pinchart

