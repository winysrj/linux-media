Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49787 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbcLILrA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 06:47:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH v2 4/6] v4l: tvp5150: Reset device at probe time, not in get/set format handlers
Date: Fri,  9 Dec 2016 13:47:17 +0200
Message-Id: <1481284039-7960-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
getting the format.

However, removing the tvp5150_reset() from the get/set format handlers
results in the function not being called at all if the bridge driver
doesn't use the .reset() operation. The operation is nowadays abused and
shouldn't be used, so shouldn't expect bridge drivers to call it. To
make sure the device is properly initialize, move the reset call from
the format handlers to the probe function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp5150.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 3a0fe8cc64e9..a30bfcb4eec6 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -861,8 +861,6 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 
 	f = &format->format;
 
-	tvp5150_reset(sd, 0);
-
 	f->width = decoder->rect.width;
 	f->height = decoder->rect.height / 2;
 
@@ -1524,7 +1522,6 @@ static int tvp5150_probe(struct i2c_client *c,
 		res = core->hdl.error;
 		goto err;
 	}
-	v4l2_ctrl_handler_setup(&core->hdl);
 
 	/* Default is no cropping */
 	core->rect.top = 0;
@@ -1535,6 +1532,8 @@ static int tvp5150_probe(struct i2c_client *c,
 	core->rect.left = 0;
 	core->rect.width = TVP5150_H_MAX;
 
+	tvp5150_reset(sd, 0);	/* Calls v4l2_ctrl_handler_setup() */
+
 	res = v4l2_async_register_subdev(sd);
 	if (res < 0)
 		goto err;
-- 
Regards,

Laurent Pinchart

