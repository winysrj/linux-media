Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38769 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117AbbDBLfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 07:35:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 2/3] cx18: fix VIDIOC_ENUMINPUT: wrong std value
Date: Thu,  2 Apr 2015 13:34:30 +0200
Message-Id: <1427974471-24804-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1427974471-24804-1-git-send-email-hverkuil@xs4all.nl>
References: <1427974471-24804-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The std field of v4l2_input is always V4L2_STD_ALL. For tuner inputs
this should be cx->tuner_std.

This fixes a v4l2-compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/cx18/cx18-ioctl.c   | 8 ++++++++
 drivers/media/pci/cx18/cx18-streams.c | 6 +++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 6f8324d..35d75311 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -514,6 +514,9 @@ int cx18_s_input(struct file *file, void *fh, unsigned int inp)
 {
 	struct cx18_open_id *id = fh2id(fh);
 	struct cx18 *cx = id->cx;
+	v4l2_std_id std = V4L2_STD_ALL;
+	const struct cx18_card_video_input *card_input =
+				cx->card->video_inputs + inp;
 
 	if (inp >= cx->nof_inputs)
 		return -EINVAL;
@@ -529,6 +532,11 @@ int cx18_s_input(struct file *file, void *fh, unsigned int inp)
 	cx->active_input = inp;
 	/* Set the audio input to whatever is appropriate for the input type. */
 	cx->audio_input = cx->card->video_inputs[inp].audio_index;
+	if (card_input->video_type == V4L2_INPUT_TYPE_TUNER)
+		std = cx->tuner_std;
+	cx->streams[CX18_ENC_STREAM_TYPE_MPG].video_dev.tvnorms = std;
+	cx->streams[CX18_ENC_STREAM_TYPE_YUV].video_dev.tvnorms = std;
+	cx->streams[CX18_ENC_STREAM_TYPE_VBI].video_dev.tvnorms = std;
 
 	/* prevent others from messing with the streams until
 	   we're finished changing inputs. */
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index cf7ddaf..c82d25d 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -304,6 +304,7 @@ static void cx18_stream_init(struct cx18 *cx, int type)
 		/* Assume the previous pixel default */
 		s->pixelformat = V4L2_PIX_FMT_HM12;
 		s->vb_bytes_per_frame = cx->cxhdl.height * 720 * 3 / 2;
+		s->vb_bytes_per_line = 720;
 	}
 }
 
@@ -372,7 +373,10 @@ static int cx18_prep_dev(struct cx18 *cx, int type)
 	s->video_dev.v4l2_dev = &cx->v4l2_dev;
 	s->video_dev.fops = &cx18_v4l2_enc_fops;
 	s->video_dev.release = video_device_release_empty;
-	s->video_dev.tvnorms = V4L2_STD_ALL;
+	if (cx->card->video_inputs->video_type == CX18_CARD_INPUT_VID_TUNER)
+		s->video_dev.tvnorms = cx->tuner_std;
+	else
+		s->video_dev.tvnorms = V4L2_STD_ALL;
 	s->video_dev.lock = &cx->serialize_lock;
 	cx18_set_funcs(&s->video_dev);
 	return 0;
-- 
2.1.4

