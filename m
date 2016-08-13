Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:50758 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbcHMJZy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 05:25:54 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 05/14] media: platform: pxa_camera: convert to vb2
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
	<1470684652-16295-6-git-send-email-robert.jarzmik@free.fr>
Date: Sat, 13 Aug 2016 11:25:37 +0200
In-Reply-To: <1470684652-16295-6-git-send-email-robert.jarzmik@free.fr>
	(Robert Jarzmik's message of "Mon, 8 Aug 2016 21:30:43 +0200")
Message-ID: <87zioht3zi.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Robert Jarzmik <robert.jarzmik@free.fr> writes:
> Convert pxa_camera from videobuf to videobuf2.
...zip...

> +static int pxac_vb2_queue_setup(struct vb2_queue *vq,
> +				unsigned int *nbufs,
> +				unsigned int *num_planes, unsigned int sizes[],
> +				void *alloc_ctxs[])

There is an API change here that happened since I wrote this code, ie. void
*alloc_ctxs became struct device *alloc_devs.

I made the incremental patch in [1] accrodingly to prepare the v4 iteration, but
it triggers new errors in v4l2-compliance -s :
Streaming ioctls:
	test read/write: OK (Not Supported)
		fail: v4l2-test-buffers.cpp(293): !(g_flags() & V4L2_BUF_FLAG_DONE)
		fail: v4l2-test-buffers.cpp(703): buf.check(q, last_seq)
		fail: v4l2-test-buffers.cpp(976): captureBufs(node, q, m2m_q, frame_count, false)
	test MMAP: FAIL
		fail: v4l2-test-buffers.cpp(1075): can_stream && ret != EINVAL
	test USERPTR: FAIL
	test DMABUF: Cannot test, specify --expbuf-device
Total: 45, Succeeded: 43, Failed: 2, Warnings: 6

I'm a bit puzzled how this change brought this in, so in case you've already
encountered this, it could save me investigating more. If nothing obvious
appears to you, I'll dig in.

Cheers.

-- 
Robert

[1]
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index a161b64d420d..41359a183e83 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -269,8 +269,6 @@ struct pxa_camera_dev {
 	struct tasklet_struct	task_eof;
 
 	u32			save_cicr[5];
-
-	void			*alloc_ctx;
 };
 
 struct pxa_cam {
@@ -1043,7 +1041,7 @@ static int pxac_vb2_init(struct vb2_buffer *vb)
 static int pxac_vb2_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbufs,
 				unsigned int *num_planes, unsigned int sizes[],
-				void *alloc_ctxs[])
+				struct device *alloc_devs[])
 {
 	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
 	int size = pcdev->current_pix.sizeimage;
@@ -1069,7 +1067,6 @@ static int pxac_vb2_queue_setup(struct vb2_queue *vq,
 		return -EINVAL;
 	}
 
-	alloc_ctxs[0] = pcdev->alloc_ctx;
 	if (!*nbufs)
 		*nbufs = 1;
 
@@ -1125,6 +1122,7 @@ static int pxa_camera_init_videobuf2(struct pxa_camera_dev *pcdev)
 	vq->drv_priv = pcdev;
 	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	vq->buf_struct_size = sizeof(struct pxa_buffer);
+	vq->dev = pcdev->v4l2_dev.dev;
 
 	vq->ops = &pxac_vb2_ops;
 	vq->mem_ops = &vb2_dma_sg_memops;
@@ -1918,10 +1916,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	pcdev->alloc_ctx = vb2_dma_sg_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx))
-		return PTR_ERR(pcdev->alloc_ctx);
-
 	pcdev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pcdev->clk))
 		return PTR_ERR(pcdev->clk);
@@ -2091,9 +2085,8 @@ static int pxa_camera_remove(struct platform_device *pdev)
 	dma_release_channel(pcdev->dma_chans[0]);
 	dma_release_channel(pcdev->dma_chans[1]);
 	dma_release_channel(pcdev->dma_chans[2]);
-	vb2_dma_sg_cleanup_ctx(pcdev->alloc_ctx);
-	v4l2_clk_unregister(pcdev->mclk_clk);
 
+	v4l2_clk_unregister(pcdev->mclk_clk);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 
 	dev_info(&pdev->dev, "PXA Camera driver unloaded\n");
