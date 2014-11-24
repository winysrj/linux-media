Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:38469 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbaKXJhp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 04:37:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 1/6] cx18: add device_caps support
Date: Mon, 24 Nov 2014 10:37:21 +0100
Message-Id: <1416821846-7677-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
References: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This was missing in this driver, so add this functionality.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/cx18/cx18-cards.h   | 3 ++-
 drivers/media/pci/cx18/cx18-driver.h  | 1 +
 drivers/media/pci/cx18/cx18-ioctl.c   | 7 ++++---
 drivers/media/pci/cx18/cx18-streams.c | 9 +++++++++
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-cards.h b/drivers/media/pci/cx18/cx18-cards.h
index add7391..f6b921f 100644
--- a/drivers/media/pci/cx18/cx18-cards.h
+++ b/drivers/media/pci/cx18/cx18-cards.h
@@ -57,7 +57,8 @@
 /* V4L2 capability aliases */
 #define CX18_CAP_ENCODER (V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER | \
 			  V4L2_CAP_AUDIO | V4L2_CAP_READWRITE | \
-			  V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE)
+			  V4L2_CAP_STREAMING | V4L2_CAP_VBI_CAPTURE | \
+			  V4L2_CAP_SLICED_VBI_CAPTURE)
 
 struct cx18_card_video_input {
 	u8  video_type; 	/* video input type */
diff --git a/drivers/media/pci/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
index 57f4688..dcfd7a1 100644
--- a/drivers/media/pci/cx18/cx18-driver.h
+++ b/drivers/media/pci/cx18/cx18-driver.h
@@ -379,6 +379,7 @@ struct cx18_stream {
 	const char *name;		/* name of the stream */
 	int type;			/* stream type */
 	u32 handle;			/* task handle */
+	u32 v4l2_dev_caps;		/* device capabilities */
 	unsigned int mdl_base_idx;
 
 	u32 id;
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 71963db..b8e4b68 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -393,15 +393,16 @@ static int cx18_querycap(struct file *file, void *fh,
 				struct v4l2_capability *vcap)
 {
 	struct cx18_open_id *id = fh2id(fh);
+	struct cx18_stream *s = video_drvdata(file);
 	struct cx18 *cx = id->cx;
 
 	strlcpy(vcap->driver, CX18_DRIVER_NAME, sizeof(vcap->driver));
 	strlcpy(vcap->card, cx->card_name, sizeof(vcap->card));
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
 		 "PCI:%s", pci_name(cx->pci_dev));
-	vcap->capabilities = cx->v4l2_cap; 	    /* capabilities */
-	if (id->type == CX18_ENC_STREAM_TYPE_YUV)
-		vcap->capabilities |= V4L2_CAP_STREAMING;
+	vcap->capabilities = cx->v4l2_cap;	/* capabilities */
+	vcap->device_caps = s->v4l2_dev_caps;	/* device capabilities */
+	vcap->capabilities |= V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index f3541b5..369445f 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -58,11 +58,14 @@ static struct {
 	int vfl_type;
 	int num_offset;
 	int dma;
+	u32 caps;
 } cx18_stream_info[] = {
 	{	/* CX18_ENC_STREAM_TYPE_MPG */
 		"encoder MPEG",
 		VFL_TYPE_GRABBER, 0,
 		PCI_DMA_FROMDEVICE,
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+		V4L2_CAP_AUDIO | V4L2_CAP_TUNER
 	},
 	{	/* CX18_ENC_STREAM_TYPE_TS */
 		"TS",
@@ -73,11 +76,15 @@ static struct {
 		"encoder YUV",
 		VFL_TYPE_GRABBER, CX18_V4L2_ENC_YUV_OFFSET,
 		PCI_DMA_FROMDEVICE,
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+		V4L2_CAP_STREAMING | V4L2_CAP_AUDIO | V4L2_CAP_TUNER
 	},
 	{	/* CX18_ENC_STREAM_TYPE_VBI */
 		"encoder VBI",
 		VFL_TYPE_VBI, 0,
 		PCI_DMA_FROMDEVICE,
+		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE |
+		V4L2_CAP_READWRITE | V4L2_CAP_TUNER
 	},
 	{	/* CX18_ENC_STREAM_TYPE_PCM */
 		"encoder PCM audio",
@@ -93,6 +100,7 @@ static struct {
 		"encoder radio",
 		VFL_TYPE_RADIO, 0,
 		PCI_DMA_NONE,
+		V4L2_CAP_RADIO | V4L2_CAP_TUNER
 	},
 };
 
@@ -260,6 +268,7 @@ static void cx18_stream_init(struct cx18 *cx, int type)
 	s->handle = CX18_INVALID_TASK_HANDLE;
 
 	s->dma = cx18_stream_info[type].dma;
+	s->v4l2_dev_caps = cx18_stream_info[type].caps;
 	s->buffers = cx->stream_buffers[type];
 	s->buf_size = cx->stream_buf_size[type];
 	INIT_LIST_HEAD(&s->buf_pool);
-- 
2.1.3

