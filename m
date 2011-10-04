Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501Ab1JDTxc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Oct 2011 15:53:32 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p94JrWA1028881
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 4 Oct 2011 15:53:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv2 8/8] [media] em28xx: Add VIDIOC_QUERYSTD support
Date: Tue,  4 Oct 2011 16:53:20 -0300
Message-Id: <1317758000-21154-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1317758000-21154-7-git-send-email-mchehab@redhat.com>
References: <1317758000-21154-1-git-send-email-mchehab@redhat.com>
 <1317758000-21154-2-git-send-email-mchehab@redhat.com>
 <1317758000-21154-3-git-send-email-mchehab@redhat.com>
 <1317758000-21154-4-git-send-email-mchehab@redhat.com>
 <1317758000-21154-5-git-send-email-mchehab@redhat.com>
 <1317758000-21154-6-git-send-email-mchehab@redhat.com>
 <1317758000-21154-7-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow subdevs to return the detected standards

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/em28xx/em28xx-video.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 61f35c8..62182e3 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1156,6 +1156,21 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 	return 0;
 }
 
+static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct em28xx_fh   *fh  = priv;
+	struct em28xx      *dev = fh->dev;
+	int                rc;
+
+	rc = check_dev(dev);
+	if (rc < 0)
+		return rc;
+
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
+
+	return 0;
+}
+
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
 	struct em28xx_fh   *fh  = priv;
@@ -2354,6 +2369,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_qbuf                = vidioc_qbuf,
 	.vidioc_dqbuf               = vidioc_dqbuf,
 	.vidioc_g_std               = vidioc_g_std,
+	.vidioc_querystd            = vidioc_querystd,
 	.vidioc_s_std               = vidioc_s_std,
 	.vidioc_g_parm		    = vidioc_g_parm,
 	.vidioc_s_parm		    = vidioc_s_parm,
-- 
1.7.6.4

