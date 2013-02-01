Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:59767 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984Ab3BAXC3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Feb 2013 18:02:29 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 7/8] saa7134: v4l2-compliance: remove bogus g_parm
Date: Sat,  2 Feb 2013 00:01:20 +0100
Message-Id: <1359759681-27549-8-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359759681-27549-1-git-send-email-linux@rainbow-software.org>
References: <1359759681-27549-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: remove empty g_parm function

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index f7e6d5c..eeee8b4 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2237,12 +2237,6 @@ static int saa7134_streamoff(struct file *file, void *priv,
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
@@ -2395,7 +2389,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fbuf			= saa7134_g_fbuf,
 	.vidioc_s_fbuf			= saa7134_s_fbuf,
 	.vidioc_overlay			= saa7134_overlay,
-	.vidioc_g_parm			= saa7134_g_parm,
 	.vidioc_g_frequency		= saa7134_g_frequency,
 	.vidioc_s_frequency		= saa7134_s_frequency,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-- 
Ondrej Zary

