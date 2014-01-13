Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2698 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaAMJ6Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 04:58:16 -0500
Message-ID: <52D3B8B4.3000507@xs4all.nl>
Date: Mon, 13 Jan 2014 10:58:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: tomdev@freenet.de
Subject: [PATCH] solo6x10: fix broken PAL support.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video_type was never set correctly for PAL: it's not a bool, instead
it is a register value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: tomdev@freenet.de
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 2 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2.c     | 7 ++++---
 drivers/staging/media/solo6x10/solo6x10.h          | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index e86c96a..bb59750 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -966,7 +966,7 @@ static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id std)
 {
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
 
-	return solo_set_video_type(solo_enc->solo_dev, std & V4L2_STD_PAL);
+	return solo_set_video_type(solo_enc->solo_dev, std & V4L2_STD_625_50);
 }
 
 static int solo_enum_framesizes(struct file *file, void *priv,
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2.c b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
index 7b26de3..47e72da 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
@@ -527,7 +527,7 @@ static int solo_g_std(struct file *file, void *priv, v4l2_std_id *i)
 	return 0;
 }
 
-int solo_set_video_type(struct solo_dev *solo_dev, bool type)
+int solo_set_video_type(struct solo_dev *solo_dev, bool is_50hz)
 {
 	int i;
 
@@ -537,7 +537,8 @@ int solo_set_video_type(struct solo_dev *solo_dev, bool type)
 	for (i = 0; i < solo_dev->nr_chans; i++)
 		if (vb2_is_busy(&solo_dev->v4l2_enc[i]->vidq))
 			return -EBUSY;
-	solo_dev->video_type = type;
+	solo_dev->video_type = is_50hz ? SOLO_VO_FMT_TYPE_PAL :
+					 SOLO_VO_FMT_TYPE_NTSC;
 	/* Reconfigure for the new standard */
 	solo_disp_init(solo_dev);
 	solo_enc_init(solo_dev);
@@ -551,7 +552,7 @@ static int solo_s_std(struct file *file, void *priv, v4l2_std_id std)
 {
 	struct solo_dev *solo_dev = video_drvdata(file);
 
-	return solo_set_video_type(solo_dev, std & V4L2_STD_PAL);
+	return solo_set_video_type(solo_dev, std & V4L2_STD_625_50);
 }
 
 static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index f1bbb8c..8964f8b 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -398,7 +398,7 @@ int solo_p2m_dma_desc(struct solo_dev *solo_dev,
 		      int desc_cnt);
 
 /* Global s_std ioctl */
-int solo_set_video_type(struct solo_dev *solo_dev, bool type);
+int solo_set_video_type(struct solo_dev *solo_dev, bool is_50hz);
 void solo_update_mode(struct solo_enc_dev *solo_enc);
 
 /* Set the threshold for motion detection */
-- 
1.8.5.1

