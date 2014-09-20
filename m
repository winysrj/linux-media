Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2903 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbaITMmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/16] cx88: drop mpeg_active field.
Date: Sat, 20 Sep 2014 14:41:47 +0200
Message-Id: <1411216911-7950-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vb2 framework knows if streaming is in progress, no need to use
a separate field for that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c | 11 +++++------
 drivers/media/pci/cx88/cx88.h           |  1 -
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 58e5254..13b8ed3 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -536,9 +536,6 @@ static int blackbird_initialize_codec(struct cx8802_dev *dev)
 	dprintk(1,"Initialize codec\n");
 	retval = blackbird_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0); /* ping */
 	if (retval < 0) {
-
-		dev->mpeg_active = 0;
-
 		/* ping was not successful, reset and upload firmware */
 		cx_write(MO_SRST_IO, 0); /* SYS_RSTO=0 */
 		cx_write(MO_SRST_IO, 1); /* SYS_RSTO=1 */
@@ -622,7 +619,6 @@ static int blackbird_start_codec(struct cx8802_dev *dev)
 			BLACKBIRD_RAW_BITS_NONE
 		);
 
-	dev->mpeg_active = 1;
 	return 0;
 }
 
@@ -636,7 +632,6 @@ static int blackbird_stop_codec(struct cx8802_dev *dev)
 
 	cx2341x_handler_set_busy(&dev->cxhdl, 0);
 
-	dev->mpeg_active = 0;
 	return 0;
 }
 
@@ -875,18 +870,22 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 {
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
+	bool streaming;
 
 	if (unlikely(UNSET == core->board.tuner_type))
 		return -EINVAL;
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
-	if (dev->mpeg_active)
+	streaming = dev->vb2_mpegq.start_streaming_called;
+	if (streaming)
 		blackbird_stop_codec(dev);
 
 	cx88_set_freq (core,f);
 	blackbird_initialize_codec(dev);
 	cx88_set_scale(core, core->width, core->height,
 			core->field);
+	if (streaming)
+		blackbird_start_codec(dev);
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index 862c609..93bc7cf 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -557,7 +557,6 @@ struct cx8802_dev {
 #if IS_ENABLED(CONFIG_VIDEO_CX88_BLACKBIRD)
 	struct video_device        *mpeg_dev;
 	u32                        mailbox;
-	unsigned char              mpeg_active; /* nonzero if mpeg encoder is active */
 
 	/* mpeg params */
 	struct cx2341x_handler     cxhdl;
-- 
2.1.0

