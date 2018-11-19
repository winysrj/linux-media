Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:42383 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728614AbeKSVcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 16:32:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2 4/4] vivid: add queue_setup_(un)lock ops
Date: Mon, 19 Nov 2018 12:09:03 +0100
Message-Id: <20181119110903.24383-5-hverkuil@xs4all.nl>
In-Reply-To: <20181119110903.24383-1-hverkuil@xs4all.nl>
References: <20181119110903.24383-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add these ops to serialize queue_setup with VIDIOC_S_FMT.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/platform/vivid/vivid-core.c    | 14 ++++++++++++++
 drivers/media/platform/vivid/vivid-core.h    |  3 +++
 drivers/media/platform/vivid/vivid-sdr-cap.c |  2 ++
 drivers/media/platform/vivid/vivid-vbi-cap.c |  2 ++
 drivers/media/platform/vivid/vivid-vbi-out.c |  2 ++
 drivers/media/platform/vivid/vivid-vid-cap.c |  2 ++
 drivers/media/platform/vivid/vivid-vid-out.c |  2 ++
 7 files changed, 27 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 38389af97b16..51b0a5c99365 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -475,6 +475,20 @@ static int vivid_fop_release(struct file *file)
 	return v4l2_fh_release(file);
 }
 
+void vivid_queue_setup_lock(struct vb2_queue *q)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(q);
+
+	mutex_lock(&dev->mutex);
+}
+
+void vivid_queue_setup_unlock(struct vb2_queue *q)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(q);
+
+	mutex_unlock(&dev->mutex);
+}
+
 static const struct v4l2_file_operations vivid_fops = {
 	.owner		= THIS_MODULE,
 	.open           = v4l2_fh_open,
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 337ccb563f9b..78c97c1dcd25 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -564,4 +564,7 @@ static inline bool vivid_is_hdmi_out(const struct vivid_dev *dev)
 	return dev->output_type[dev->output] == HDMI;
 }
 
+void vivid_queue_setup_lock(struct vb2_queue *q);
+void vivid_queue_setup_unlock(struct vb2_queue *q);
+
 #endif
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 5dfb598af742..bac0dc47e24e 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -318,6 +318,8 @@ static void sdr_cap_buf_request_complete(struct vb2_buffer *vb)
 
 const struct vb2_ops vivid_sdr_cap_qops = {
 	.queue_setup		= sdr_cap_queue_setup,
+	.queue_setup_lock	= vivid_queue_setup_lock,
+	.queue_setup_unlock	= vivid_queue_setup_unlock,
 	.buf_prepare		= sdr_cap_buf_prepare,
 	.buf_queue		= sdr_cap_buf_queue,
 	.start_streaming	= sdr_cap_start_streaming,
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 903cebeb5ce5..b5c0ea8b848c 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -231,6 +231,8 @@ static void vbi_cap_buf_request_complete(struct vb2_buffer *vb)
 
 const struct vb2_ops vivid_vbi_cap_qops = {
 	.queue_setup		= vbi_cap_queue_setup,
+	.queue_setup_lock	= vivid_queue_setup_lock,
+	.queue_setup_unlock	= vivid_queue_setup_unlock,
 	.buf_prepare		= vbi_cap_buf_prepare,
 	.buf_queue		= vbi_cap_buf_queue,
 	.start_streaming	= vbi_cap_start_streaming,
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 9357c07e30d6..8f8ce00edaa2 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -126,6 +126,8 @@ static void vbi_out_buf_request_complete(struct vb2_buffer *vb)
 
 const struct vb2_ops vivid_vbi_out_qops = {
 	.queue_setup		= vbi_out_queue_setup,
+	.queue_setup_lock	= vivid_queue_setup_lock,
+	.queue_setup_unlock	= vivid_queue_setup_unlock,
 	.buf_prepare		= vbi_out_buf_prepare,
 	.buf_queue		= vbi_out_buf_queue,
 	.start_streaming	= vbi_out_start_streaming,
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 9c8e8be81ce3..f315f5f72616 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -271,6 +271,8 @@ static void vid_cap_buf_request_complete(struct vb2_buffer *vb)
 
 const struct vb2_ops vivid_vid_cap_qops = {
 	.queue_setup		= vid_cap_queue_setup,
+	.queue_setup_lock	= vivid_queue_setup_lock,
+	.queue_setup_unlock	= vivid_queue_setup_unlock,
 	.buf_prepare		= vid_cap_buf_prepare,
 	.buf_finish		= vid_cap_buf_finish,
 	.buf_queue		= vid_cap_buf_queue,
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index aaf13f03d5d4..0fe7f449e416 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -190,6 +190,8 @@ static void vid_out_buf_request_complete(struct vb2_buffer *vb)
 
 const struct vb2_ops vivid_vid_out_qops = {
 	.queue_setup		= vid_out_queue_setup,
+	.queue_setup_lock	= vivid_queue_setup_lock,
+	.queue_setup_unlock	= vivid_queue_setup_unlock,
 	.buf_prepare		= vid_out_buf_prepare,
 	.buf_queue		= vid_out_buf_queue,
 	.start_streaming	= vid_out_start_streaming,
-- 
2.19.1
