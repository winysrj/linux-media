Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54170 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbeDVK2r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 06:28:47 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/3] v4l: rcar_fdp1: Fix indentation oddities
Date: Sun, 22 Apr 2018 13:28:49 +0300
Message-Id: <20180422102849.2481-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422102849.2481-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180422102849.2481-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Indentation is odd in several places, especially when printing messages
to the kernel log. Fix it to match the usual coding style.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar_fdp1.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index b13dec3081e5..81e8a761b924 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -949,7 +949,7 @@ static void fdp1_configure_wpf(struct fdp1_ctx *ctx,
 	u32 rndctl;
 
 	pstride = q_data->format.plane_fmt[0].bytesperline
-			<< FD1_WPF_PSTRIDE_Y_SHIFT;
+		<< FD1_WPF_PSTRIDE_Y_SHIFT;
 
 	if (q_data->format.num_planes > 1)
 		pstride |= q_data->format.plane_fmt[1].bytesperline
@@ -1143,8 +1143,8 @@ static int fdp1_m2m_job_ready(void *priv)
 	int dstbufs = 1;
 
 	dprintk(ctx->fdp1, "+ Src: %d : Dst: %d\n",
-			v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx),
-			v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx));
+		v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx),
+		v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx));
 
 	/* One output buffer is required for each field */
 	if (V4L2_FIELD_HAS_BOTH(src_q_data->format.field))
@@ -1282,7 +1282,7 @@ static void fdp1_m2m_device_run(void *priv)
 
 		fdp1_queue_field(ctx, fbuf);
 		dprintk(fdp1, "Queued Buffer [%d] last_field:%d\n",
-				i, fbuf->last_field);
+			i, fbuf->last_field);
 	}
 
 	/* Queue as many jobs as our data provides for */
@@ -1341,7 +1341,7 @@ static void device_frame_end(struct fdp1_dev *fdp1,
 	fdp1_job_free(fdp1, job);
 
 	dprintk(fdp1, "curr_ctx->num_processed %d curr_ctx->translen %d\n",
-			ctx->num_processed, ctx->translen);
+		ctx->num_processed, ctx->translen);
 
 	if (ctx->num_processed == ctx->translen ||
 			ctx->aborting) {
@@ -1366,7 +1366,7 @@ static int fdp1_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, DRIVER_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
-			"platform:%s", DRIVER_NAME);
+		 "platform:%s", DRIVER_NAME);
 	return 0;
 }
 
@@ -1997,13 +1997,13 @@ static void fdp1_stop_streaming(struct vb2_queue *q)
 		/* Free smsk_data */
 		if (ctx->smsk_cpu) {
 			dma_free_coherent(ctx->fdp1->dev, ctx->smsk_size,
-					ctx->smsk_cpu, ctx->smsk_addr[0]);
+					  ctx->smsk_cpu, ctx->smsk_addr[0]);
 			ctx->smsk_addr[0] = ctx->smsk_addr[1] = 0;
 			ctx->smsk_cpu = NULL;
 		}
 
 		WARN(!list_empty(&ctx->fields_queue),
-				"Buffer queue not empty");
+		     "Buffer queue not empty");
 	} else {
 		/* Empty Capture queues (Jobs) */
 		struct fdp1_job *job;
@@ -2025,10 +2025,10 @@ static void fdp1_stop_streaming(struct vb2_queue *q)
 		fdp1_field_complete(ctx, ctx->previous);
 
 		WARN(!list_empty(&ctx->fdp1->queued_job_list),
-				"Queued Job List not empty");
+		     "Queued Job List not empty");
 
 		WARN(!list_empty(&ctx->fdp1->hw_job_list),
-				"HW Job list not empty");
+		     "HW Job list not empty");
 	}
 }
 
@@ -2114,7 +2114,7 @@ static int fdp1_open(struct file *file)
 				     fdp1_ctrl_deint_menu);
 
 	ctrl = v4l2_ctrl_new_std(&ctx->hdl, &fdp1_ctrl_ops,
-			V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, 1, 2, 1, 1);
+				 V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, 1, 2, 1, 1);
 	if (ctrl)
 		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
@@ -2351,8 +2351,8 @@ static int fdp1_probe(struct platform_device *pdev)
 		goto release_m2m;
 	}
 
-	v4l2_info(&fdp1->v4l2_dev,
-			"Device registered as /dev/video%d\n", vfd->num);
+	v4l2_info(&fdp1->v4l2_dev, "Device registered as /dev/video%d\n",
+		  vfd->num);
 
 	/* Power up the cells to read HW */
 	pm_runtime_enable(&pdev->dev);
@@ -2371,7 +2371,7 @@ static int fdp1_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
-				hw_version);
+			hw_version);
 	}
 
 	/* Allow the hw to sleep until an open call puts it to use */
-- 
Regards,

Laurent Pinchart
