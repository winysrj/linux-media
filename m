Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2366 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1LOOP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 09:15:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 8/8] ivtv: add IVTV_IOC_PASSTHROUGH_MODE.
Date: Thu, 15 Dec 2011 15:15:37 +0100
Message-Id: <a8513db7bb3c0ba6e1645786b28dc6d167d2d1c4.1323957539.git.hans.verkuil@cisco.com>
In-Reply-To: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
References: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
References: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

With this private ioctl it is possible to use the ivtv decoder without
requiring the dvb/video.h and dvb/audio.h headers.

Eventually support for those DVB APIs will be dropped from ivtv.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-ioctl.c |    8 ++++++++
 include/linux/ivtv.h                  |    6 +++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index 736ba8e..1cf264f 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1618,6 +1618,12 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		return ivtv_yuv_prep_frame(itv, args);
 	}
 
+	case IVTV_IOC_PASSTHROUGH_MODE:
+		IVTV_DEBUG_IOCTL("IVTV_IOC_PASSTHROUGH_MODE\n");
+		if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
+			return -EINVAL;
+		return ivtv_passthrough_mode(itv, *(int *)arg != 0);
+
 	case VIDEO_GET_PTS: {
 		s64 *pts = arg;
 		s64 frame;
@@ -1779,6 +1785,7 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 
 	if (!valid_prio) {
 		switch (cmd) {
+		case IVTV_IOC_PASSTHROUGH_MODE:
 		case VIDEO_PLAY:
 		case VIDEO_STOP:
 		case VIDEO_FREEZE:
@@ -1804,6 +1811,7 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 	}
 
 	case IVTV_IOC_DMA_FRAME:
+	case IVTV_IOC_PASSTHROUGH_MODE:
 	case VIDEO_GET_PTS:
 	case VIDEO_GET_FRAME_COUNT:
 	case VIDEO_GET_EVENT:
diff --git a/include/linux/ivtv.h b/include/linux/ivtv.h
index 062d20f..42bf725 100644
--- a/include/linux/ivtv.h
+++ b/include/linux/ivtv.h
@@ -58,7 +58,11 @@ struct ivtv_dma_frame {
 	__u32 src_height;
 };
 
-#define IVTV_IOC_DMA_FRAME  _IOW ('V', BASE_VIDIOC_PRIVATE+0, struct ivtv_dma_frame)
+#define IVTV_IOC_DMA_FRAME		_IOW ('V', BASE_VIDIOC_PRIVATE+0, struct ivtv_dma_frame)
+
+/* Select the passthrough mode (if the argument is non-zero). In the passthrough
+   mode the output of the encoder is passed immediately into the decoder. */
+#define IVTV_IOC_PASSTHROUGH_MODE	_IOW ('V', BASE_VIDIOC_PRIVATE+1, int)
 
 /* Deprecated defines: applications should use the defines from videodev2.h */
 #define IVTV_SLICED_TYPE_TELETEXT_B     V4L2_MPEG_VBI_IVTV_TELETEXT_B
-- 
1.7.7.3

