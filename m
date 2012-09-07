Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1547 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab2IGN3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 21/28] v4l2: make vidioc_s_audout const.
Date: Fri,  7 Sep 2012 15:29:21 +0200
Message-Id: <1bd0bb8b0d2d0d4521de180dbd3ee2ed8e229363.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Write-only ioctls should have a const argument in the ioctl op.

Do this conversion for vidioc_s_audout.

Adding const for write-only ioctls was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c |    6 ++++--
 drivers/media/radio/radio-si4713.c  |    2 +-
 include/media/v4l2-ioctl.h          |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 99e35dd..d5cbb61 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -813,11 +813,13 @@ static int ivtv_g_audout(struct file *file, void *fh, struct v4l2_audioout *vin)
 	return ivtv_get_audio_output(itv, vin->index, vin);
 }
 
-static int ivtv_s_audout(struct file *file, void *fh, struct v4l2_audioout *vout)
+static int ivtv_s_audout(struct file *file, void *fh, const struct v4l2_audioout *vout)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
 
-	return ivtv_get_audio_output(itv, vout->index, vout);
+	if (itv->card->video_outputs == NULL || vout->index != 0)
+		return -EINVAL;
+	return 0;
 }
 
 static int ivtv_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 5f366d1..1e04101 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -83,7 +83,7 @@ static int radio_si4713_g_audout(struct file *file, void *priv,
 }
 
 static int radio_si4713_s_audout(struct file *file, void *priv,
-					struct v4l2_audioout *vao)
+					const struct v4l2_audioout *vao)
 {
 	return vao->index ? -EINVAL : 0;
 }
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index babbe09..d4c7729 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -175,7 +175,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_audout)         (struct file *file, void *fh,
 					struct v4l2_audioout *a);
 	int (*vidioc_s_audout)         (struct file *file, void *fh,
-					struct v4l2_audioout *a);
+					const struct v4l2_audioout *a);
 	int (*vidioc_g_modulator)      (struct file *file, void *fh,
 					struct v4l2_modulator *a);
 	int (*vidioc_s_modulator)      (struct file *file, void *fh,
-- 
1.7.10.4

