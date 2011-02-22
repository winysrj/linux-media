Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab1BVCUx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 21:20:53 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2Kqig015641
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:20:52 -0500
Received: from pedra (vpn-224-79.phx2.redhat.com [10.3.224.79])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2HksW012926
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:20:51 -0500
Date: Mon, 21 Feb 2011 23:17:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] em28xx: properly handle subdev controls
Message-ID: <20110221231740.66317ca6@pedra>
In-Reply-To: <cover.1298340861.git.mchehab@redhat.com>
References: <cover.1298340861.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Subdev controls return codes are evil, as they return -EINVAL to mean
both unsupported and invalid arguments. Due to that, we need to use a
trick to identify what controls are supported by a subdev.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 19b8284..23e7742 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1387,6 +1387,27 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 		return -EINVAL;
 }
 
+/*
+ * FIXME: This is an indirect way to check if a control exists at a
+ * subdev. Instead of that hack, maybe the better would be to change all
+ * subdevs to return -ENOIOCTLCMD, if an ioctl is not supported.
+ */
+static int check_subdev_ctrl(struct em28xx *dev, int id)
+{
+	struct v4l2_queryctrl qc;
+
+	memset(&qc, 0, sizeof(qc));
+	qc.id = id;
+
+	/* enumerate V4L2 device controls */
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, queryctrl, &qc);
+
+	if (qc.type)
+		return 0;
+	else
+		return -EINVAL;
+}
+
 static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
@@ -1399,7 +1420,6 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 		return rc;
 	rc = 0;
 
-
 	/* Set an AC97 control */
 	if (dev->audio_mode.ac97 != EM28XX_NO_AC97)
 		rc = ac97_get_ctrl(dev, ctrl);
@@ -1408,6 +1428,9 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 
 	/* It were not an AC97 control. Sends it to the v4l2 dev interface */
 	if (rc == 1) {
+		if (check_subdev_ctrl(dev, ctrl->id))
+			return -EINVAL;
+
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_ctrl, ctrl);
 		rc = 0;
 	}
@@ -1434,8 +1457,10 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 	/* It isn't an AC97 control. Sends it to the v4l2 dev interface */
 	if (rc == 1) {
-		rc = v4l2_device_call_until_err(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
-
+		rc = check_subdev_ctrl(dev, ctrl->id);
+		if (!rc)
+			v4l2_device_call_all(&dev->v4l2_dev, 0,
+					     core, s_ctrl, ctrl);
 		/*
 		 * In the case of non-AC97 volume controls, we still need
 		 * to do some setups at em28xx, in order to mute/unmute
-- 
1.7.1

