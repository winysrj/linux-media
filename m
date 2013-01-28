Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:41271 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab3A1OME (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 09:12:04 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 8/7] saa7134: v4l2-compliance: remove bogus g_parm
Date: Mon, 28 Jan 2013 15:11:50 +0100
Cc: linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201301281511.50411.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: remove empty g_parm function

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c 
b/drivers/media/pci/saa7134/saa7134-video.c
index b63cdad..3e88041 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2232,12 +2232,6 @@ static int saa7134_streamoff(struct file *file, void 
*priv,
 	return 0;
 }
 
-static int saa7134_g_parm(struct file *file, void *fh,
-				struct v4l2_streamparm *parm)
-{
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register (struct file *file, void *priv,
 			      struct v4l2_dbg_register *reg)
@@ -2390,7 +2384,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fbuf			= saa7134_g_fbuf,
 	.vidioc_s_fbuf			= saa7134_s_fbuf,
 	.vidioc_overlay			= saa7134_overlay,
-	.vidioc_g_parm			= saa7134_g_parm,
 	.vidioc_g_frequency		= saa7134_g_frequency,
 	.vidioc_s_frequency		= saa7134_s_frequency,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-- 
Ondrej Zary

