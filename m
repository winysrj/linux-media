Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46671 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbeJFGBK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2018 02:01:10 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        jacopo@jmondi.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v11 3/3] [media] imx214: Fix range for V4L2_CID_EXPOSURE
Date: Sat,  6 Oct 2018 01:00:14 +0200
Message-Id: <20181005230014.5952-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Going above 3184 changes the frame-rate of the sensor. Without this
patch there is no way to change the exposure without affecting the
frame-rate.

With the proper documentation we should be able the change the
frame-rate at wish, but until that happens we just cap what the sensor
can do.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/imx214.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
index fe01a13f13c5..284b9b49ebde 100644
--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -1029,7 +1029,7 @@ static int imx214_probe(struct i2c_client *client)
 	 */
 	imx214->exposure = v4l2_ctrl_new_std(&imx214->ctrls, &imx214_ctrl_ops,
 					     V4L2_CID_EXPOSURE,
-					     0, 0xffff, 1, 0x0c70);
+					     0, 3184, 1, 0x0c70);
 
 	ret = imx214->ctrls.error;
 	if (ret) {
-- 
2.19.0
