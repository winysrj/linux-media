Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.9]:50619 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1AaMSm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 07:18:42 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: [PATCH 1/2 v2] v4l: soc-camera: start stream after queueing the buffers
Date: Mon, 31 Jan 2011 13:19:32 +0100
Message-Id: <1296476372-10388-1-git-send-email-agust@denx.de>
In-Reply-To: <1296031789-1721-2-git-send-email-agust@denx.de>
References: <1296031789-1721-2-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some camera systems have strong requirement for capturing
an exact number of frames after starting the stream and do
not tolerate losing captured frames. By starting the stream
after the videobuf has queued the buffers, we ensure that
no frame will be lost.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
v2:
    Check for return value of videobuf_streamon() before
    starting the stream, as suggested by Guennadi.

 drivers/media/video/soc_camera.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a66811b..e09bec0 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -646,11 +646,12 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	v4l2_subdev_call(sd, video, s_stream, 1);
-
 	/* This calls buf_queue from host driver's videobuf_queue_ops */
 	ret = videobuf_streamon(&icd->vb_vidq);
 
+	if (!ret)
+		v4l2_subdev_call(sd, video, s_stream, 1);
+
 	return ret;
 }
 
-- 
1.7.1

