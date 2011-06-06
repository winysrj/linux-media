Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:64628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1FFRQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:16:51 -0400
Date: Mon, 6 Jun 2011 19:16:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH] V4L: tw9910: remove bogus ENUMINPUT implementation
Message-ID: <Pine.LNX.4.64.1106061915210.11169@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

tw9910 is a TV decoder, it doesn't have a tuner. Besides, the
.enum_input soc-camera operation is optional and normally not needed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/tw9910.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 0347bbe..a722f66 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -552,16 +552,6 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 	return ret;
 }
 
-static int tw9910_enum_input(struct soc_camera_device *icd,
-			     struct v4l2_input *inp)
-{
-	inp->type = V4L2_INPUT_TYPE_TUNER;
-	inp->std  = V4L2_STD_UNKNOWN;
-	strcpy(inp->name, "Video");
-
-	return 0;
-}
-
 static int tw9910_g_chip_ident(struct v4l2_subdev *sd,
 			       struct v4l2_dbg_chip_ident *id)
 {
@@ -891,7 +881,6 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 static struct soc_camera_ops tw9910_ops = {
 	.set_bus_param		= tw9910_set_bus_param,
 	.query_bus_param	= tw9910_query_bus_param,
-	.enum_input		= tw9910_enum_input,
 };
 
 static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
-- 
1.7.2.5

