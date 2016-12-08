Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46481 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932349AbcLHWW2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 17:22:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 4/6] v4l: tvp5150: Don't reset device in get/set format handlers
Date: Fri,  9 Dec 2016 00:22:44 +0200
Message-Id: <1481235766-24469-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1481235766-24469-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1481235766-24469-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tvp5150 doesn't support format setting through the subdev pad API
and thus implements the set format handler as a get format operation.
The single handler, tvp5150_fill_fmt(), resets the device by calling
tvp5150_reset(). This causes malfunction as the device can be reset at
will, possibly from userspace when the subdev userspace API is enabled.

The reset call was added in commit ec2c4f3f93cb ("[media] media:
tvp5150: Add mbus_fmt callbacks"), probably as an attempt to set the
device to a known state before detecting the current TV standard.
However, the get format handler doesn't access the hardware to get the
TV standard since commit 963ddc63e20d ("[media] media: tvp5150: Add
cropping support"). There is thus no need to reset the device when
getting the format. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp5150.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 3a0fe8cc64e9..19b79028cac5 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -861,8 +861,6 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 
 	f = &format->format;
 
-	tvp5150_reset(sd, 0);
-
 	f->width = decoder->rect.width;
 	f->height = decoder->rect.height / 2;
 
-- 
Regards,

Laurent Pinchart

