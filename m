Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51719 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751423Ab0BIJZT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 04:25:19 -0500
Date: Tue, 9 Feb 2010 10:25:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>,
	Magnus Damm <damm@opensource.se>
Subject: [PATCH 2/2] sh_mobile_ceu_camera: pass .set_parm and .get_parm down
 to subdevices
In-Reply-To: <Pine.LNX.4.64.1002090856050.4585@axis700.grange>
Message-ID: <Pine.LNX.4.64.1002091024290.4585@axis700.grange>
References: <u1vi3wnt2.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.1002090856050.4585@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index f09c714..cb34e74 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1748,6 +1748,22 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
 				       icd);
 }
 
+static int sh_mobile_ceu_get_parm(struct soc_camera_device *icd,
+				  struct v4l2_streamparm *parm)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
+	return v4l2_subdev_call(sd, video, g_parm, parm);
+}
+
+static int sh_mobile_ceu_set_parm(struct soc_camera_device *icd,
+				  struct v4l2_streamparm *parm)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+
+	return v4l2_subdev_call(sd, video, s_parm, parm);
+}
+
 static int sh_mobile_ceu_get_ctrl(struct soc_camera_device *icd,
 				  struct v4l2_control *ctrl)
 {
@@ -1808,6 +1824,8 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.try_fmt	= sh_mobile_ceu_try_fmt,
 	.set_ctrl	= sh_mobile_ceu_set_ctrl,
 	.get_ctrl	= sh_mobile_ceu_get_ctrl,
+	.set_parm	= sh_mobile_ceu_set_parm,
+	.get_parm	= sh_mobile_ceu_get_parm,
 	.reqbufs	= sh_mobile_ceu_reqbufs,
 	.poll		= sh_mobile_ceu_poll,
 	.querycap	= sh_mobile_ceu_querycap,
