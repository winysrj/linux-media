Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbcCYKpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:04 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 40/54] v4l: vsp1: Allocate pipelines on demand
Date: Fri, 25 Mar 2016 12:44:14 +0200
Message-Id: <1458902668-1141-41-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of embedding pipelines in the vsp1_video objects allocate them
on demand when they are needed. This fixes the streamon race condition
where pipelines objects from different video nodes could be used for the
same pipeline.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c   |   1 +
 drivers/media/platform/vsp1/vsp1_drv.c   |   1 +
 drivers/media/platform/vsp1/vsp1_pipe.c  |   1 +
 drivers/media/platform/vsp1/vsp1_pipe.h  |   5 +-
 drivers/media/platform/vsp1/vsp1_rpf.c   |   1 +
 drivers/media/platform/vsp1/vsp1_video.c | 124 +++++++++++++++++--------------
 drivers/media/platform/vsp1/vsp1_video.h |   2 -
 drivers/media/platform/vsp1/vsp1_wpf.c   |   1 +
 8 files changed, 75 insertions(+), 61 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 820c3c90a4a6..972526b5239e 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -19,6 +19,7 @@
 #include "vsp1.h"
 #include "vsp1_bru.h"
 #include "vsp1_dl.h"
+#include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_video.h"
 
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index f1be2680013d..596f26d81494 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -30,6 +30,7 @@
 #include "vsp1_hsit.h"
 #include "vsp1_lif.h"
 #include "vsp1_lut.h"
+#include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_sru.h"
 #include "vsp1_uds.h"
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 8ac080f87b08..4913b933562c 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -194,6 +194,7 @@ void vsp1_pipeline_init(struct vsp1_pipeline *pipe)
 	mutex_init(&pipe->lock);
 	spin_lock_init(&pipe->irqlock);
 	init_waitqueue_head(&pipe->wq);
+	kref_init(&pipe->kref);
 
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 9fd688bfe638..7b56113511dd 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -13,6 +13,7 @@
 #ifndef __VSP1_PIPE_H__
 #define __VSP1_PIPE_H__
 
+#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
@@ -63,7 +64,7 @@ enum vsp1_pipeline_state {
  * @wq: work queue to wait for state change completion
  * @frame_end: frame end interrupt handler
  * @lock: protects the pipeline use count and stream count
- * @use_count: number of video nodes using the pipeline
+ * @kref: pipeline reference count
  * @stream_count: number of streaming video nodes
  * @buffers_ready: bitmask of RPFs and WPFs with at least one buffer available
  * @num_inputs: number of RPFs
@@ -86,7 +87,7 @@ struct vsp1_pipeline {
 	void (*frame_end)(struct vsp1_pipeline *pipe);
 
 	struct mutex lock;
-	unsigned int use_count;
+	struct kref kref;
 	unsigned int stream_count;
 	unsigned int buffers_ready;
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index e373f1473c1f..bc94427c0740 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -17,6 +17,7 @@
 
 #include "vsp1.h"
 #include "vsp1_dl.h"
+#include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_video.h"
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 4396018d1408..a9aec5c0bec6 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -399,14 +399,10 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 	unsigned int i;
 	int ret;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	/* Walk the graph to locate the entities and video nodes. */
 	ret = media_entity_graph_walk_init(&graph, mdev);
-	if (ret) {
-		mutex_unlock(&mdev->graph_mutex);
+	if (ret)
 		return ret;
-	}
 
 	media_entity_graph_walk_start(&graph, entity);
 
@@ -439,15 +435,11 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 		}
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
-
 	media_entity_graph_walk_cleanup(&graph);
 
 	/* We need one output and at least one input. */
-	if (pipe->num_inputs == 0 || !pipe->output) {
-		ret = -EPIPE;
-		goto error;
-	}
+	if (pipe->num_inputs == 0 || !pipe->output)
+		return -EPIPE;
 
 	/* Follow links downstream for each input and make sure the graph
 	 * contains no loop and that all branches end at the output WPF.
@@ -459,47 +451,66 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 		ret = vsp1_video_pipeline_build_branch(pipe, pipe->inputs[i],
 						       pipe->output);
 		if (ret < 0)
-			goto error;
+			return ret;
 	}
 
 	return 0;
-
-error:
-	vsp1_pipeline_reset(pipe);
-	return ret;
 }
 
 static int vsp1_video_pipeline_init(struct vsp1_pipeline *pipe,
 				    struct vsp1_video *video)
 {
+	vsp1_pipeline_init(pipe);
+
+	pipe->frame_end = vsp1_video_pipeline_frame_end;
+
+	return vsp1_video_pipeline_build(pipe, video);
+}
+
+static struct vsp1_pipeline *vsp1_video_pipeline_get(struct vsp1_video *video)
+{
+	struct vsp1_pipeline *pipe;
 	int ret;
 
-	mutex_lock(&pipe->lock);
+	/* Get a pipeline object for the video node. If a pipeline has already
+	 * been allocated just increment its reference count and return it.
+	 * Otherwise allocate a new pipeline and initialize it, it will be freed
+	 * when the last reference is released.
+	 */
+	if (!video->rwpf->pipe) {
+		pipe = kzalloc(sizeof(*pipe), GFP_KERNEL);
+		if (!pipe)
+			return ERR_PTR(-ENOMEM);
 
-	/* If we're the first user build and validate the pipeline. */
-	if (pipe->use_count == 0) {
-		ret = vsp1_video_pipeline_build(pipe, video);
-		if (ret < 0)
-			goto done;
+		ret = vsp1_video_pipeline_init(pipe, video);
+		if (ret < 0) {
+			vsp1_pipeline_reset(pipe);
+			kfree(pipe);
+			return ERR_PTR(ret);
+		}
+	} else {
+		pipe = video->rwpf->pipe;
+		kref_get(&pipe->kref);
 	}
 
-	pipe->use_count++;
-	ret = 0;
-
-done:
-	mutex_unlock(&pipe->lock);
-	return ret;
+	return pipe;
 }
 
-static void vsp1_video_pipeline_cleanup(struct vsp1_pipeline *pipe)
+static void vsp1_video_pipeline_release(struct kref *kref)
 {
-	mutex_lock(&pipe->lock);
+	struct vsp1_pipeline *pipe = container_of(kref, typeof(*pipe), kref);
 
-	/* If we're the last user clean up the pipeline. */
-	if (--pipe->use_count == 0)
-		vsp1_pipeline_reset(pipe);
+	vsp1_pipeline_reset(pipe);
+	kfree(pipe);
+}
 
-	mutex_unlock(&pipe->lock);
+static void vsp1_video_pipeline_put(struct vsp1_pipeline *pipe)
+{
+	struct media_device *mdev = &pipe->output->entity.vsp1->media_dev;
+
+	mutex_lock(&mdev->graph_mutex);
+	kref_put(&pipe->kref, vsp1_video_pipeline_release);
+	mutex_unlock(&mdev->graph_mutex);
 }
 
 /* -----------------------------------------------------------------------------
@@ -674,8 +685,8 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	}
 	mutex_unlock(&pipe->lock);
 
-	vsp1_video_pipeline_cleanup(pipe);
 	media_entity_pipeline_stop(&video->video.entity);
+	vsp1_video_pipeline_put(pipe);
 
 	/* Remove all buffers from the IRQ queue. */
 	spin_lock_irqsave(&video->irqlock, flags);
@@ -787,6 +798,7 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 {
 	struct v4l2_fh *vfh = file->private_data;
 	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
+	struct media_device *mdev = &video->vsp1->media_dev;
 	struct vsp1_pipeline *pipe;
 	int ret;
 
@@ -795,20 +807,25 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	video->sequence = 0;
 
-	/* Start streaming on the pipeline. No link touching an entity in the
-	 * pipeline can be activated or deactivated once streaming is started.
-	 *
-	 * Use the VSP1 pipeline object embedded in the first video object that
-	 * starts streaming.
-	 *
-	 * FIXME: This is racy, the ioctl is only protected by the video node
-	 * lock.
+	/* Get a pipeline for the video node and start streaming on it. No link
+	 * touching an entity in the pipeline can be activated or deactivated
+	 * once streaming is started.
 	 */
-	pipe = video->rwpf->pipe ? video->rwpf->pipe : &video->pipe;
+	mutex_lock(&mdev->graph_mutex);
 
-	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
-	if (ret < 0)
-		return ret;
+	pipe = vsp1_video_pipeline_get(video);
+	if (IS_ERR(pipe)) {
+		mutex_unlock(&mdev->graph_mutex);
+		return PTR_ERR(pipe);
+	}
+
+	ret = __media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
+	if (ret < 0) {
+		mutex_unlock(&mdev->graph_mutex);
+		goto err_pipe;
+	}
+
+	mutex_unlock(&mdev->graph_mutex);
 
 	/* Verify that the configured format matches the output of the connected
 	 * subdev.
@@ -817,21 +834,17 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret < 0)
 		goto err_stop;
 
-	ret = vsp1_video_pipeline_init(pipe, video);
-	if (ret < 0)
-		goto err_stop;
-
 	/* Start the queue. */
 	ret = vb2_streamon(&video->queue, type);
 	if (ret < 0)
-		goto err_cleanup;
+		goto err_stop;
 
 	return 0;
 
-err_cleanup:
-	vsp1_video_pipeline_cleanup(pipe);
 err_stop:
 	media_entity_pipeline_stop(&video->video.entity);
+err_pipe:
+	vsp1_video_pipeline_put(pipe);
 	return ret;
 }
 
@@ -947,9 +960,6 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	spin_lock_init(&video->irqlock);
 	INIT_LIST_HEAD(&video->irqqueue);
 
-	vsp1_pipeline_init(&video->pipe);
-	video->pipe.frame_end = vsp1_video_pipeline_frame_end;
-
 	/* Initialize the media entity... */
 	ret = media_entity_pads_init(&video->video.entity, 1, &video->pad);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 64abd39ee1e7..867b00807c46 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -18,7 +18,6 @@
 
 #include <media/videobuf2-v4l2.h>
 
-#include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 
 struct vsp1_vb2_buffer {
@@ -44,7 +43,6 @@ struct vsp1_video {
 
 	struct mutex lock;
 
-	struct vsp1_pipeline pipe;
 	unsigned int pipe_index;
 
 	struct vb2_queue queue;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 5aa5eb4b8121..a88ed0fc69ac 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -17,6 +17,7 @@
 
 #include "vsp1.h"
 #include "vsp1_dl.h"
+#include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_video.h"
 
-- 
2.7.3

