Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:53428 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3A0TqD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 14:46:03 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 7/7] saa7134: v4l2-compliance: remove bogus audio input support
Date: Sun, 27 Jan 2013 20:45:12 +0100
Message-Id: <1359315912-1767-8-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: remove empty g_audio and s_audio
functions and don't set audioset in enum_input

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |   30 -----------------------------
 1 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index fff6735..b63cdad 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1750,7 +1750,6 @@ static int saa7134_enum_input(struct file *file, void *priv,
 	strcpy(i->name, card_in(dev, n).name);
 	if (card_in(dev, n).tv)
 		i->type = V4L2_INPUT_TYPE_TUNER;
-	i->audioset = 1;
 	if (n == dev->ctl_input) {
 		int v1 = saa_readb(SAA7134_STATUS_VIDEO1);
 		int v2 = saa_readb(SAA7134_STATUS_VIDEO2);
@@ -2079,17 +2078,6 @@ static int saa7134_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int saa7134_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
-{
-	strcpy(a->name, "audio");
-	return 0;
-}
-
-static int saa7134_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
-{
-	return 0;
-}
-
 static int saa7134_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
@@ -2330,20 +2318,6 @@ static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
 	return 0;
 }
 
-static int radio_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	memset(a, 0, sizeof(*a));
-	strcpy(a->name, "Radio");
-	return 0;
-}
-
-static int radio_s_audio(struct file *file, void *priv,
-					const struct v4l2_audio *a)
-{
-	return 0;
-}
-
 static int radio_s_input(struct file *filp, void *priv, unsigned int i)
 {
 	return 0;
@@ -2394,8 +2368,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
 	.vidioc_try_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
-	.vidioc_g_audio			= saa7134_g_audio,
-	.vidioc_s_audio			= saa7134_s_audio,
 	.vidioc_cropcap			= saa7134_cropcap,
 	.vidioc_reqbufs			= saa7134_reqbufs,
 	.vidioc_querybuf		= saa7134_querybuf,
@@ -2440,9 +2412,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_querycap	= saa7134_querycap,
 	.vidioc_g_tuner		= radio_g_tuner,
 	.vidioc_enum_input	= radio_enum_input,
-	.vidioc_g_audio		= radio_g_audio,
 	.vidioc_s_tuner		= radio_s_tuner,
-	.vidioc_s_audio		= radio_s_audio,
 	.vidioc_s_input		= radio_s_input,
 	.vidioc_s_std		= radio_s_std,
 	.vidioc_queryctrl	= radio_queryctrl,
-- 
Ondrej Zary

