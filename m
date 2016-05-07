Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:58448 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbcEGFOt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2016 01:14:49 -0400
Subject: Re: [RESEND PATCH] [media] s5p-mfc: don't close instance after free
 OUTPUT buffers
To: linux-kernel@vger.kernel.org
References: <1462572682-5195-1-git-send-email-javier@osg.samsung.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: ayaka <ayaka@soulik.info>
Message-ID: <572D786D.2040105@soulik.info>
Date: Sat, 7 May 2016 13:09:01 +0800
MIME-Version: 1.0
In-Reply-To: <1462572682-5195-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please also notice those patches (A few patches make s5p-mfc work with 
Gstreamer)
  I resent to mail recently.
Without them, the encoder won't work with Gstreamer either. I hope it 
will be
merged as soon as possible.

在 2016年05月07日 06:11, Javier Martinez Canillas 写道:
> From: ayaka <ayaka@soulik.info>
>
> User-space applications can use the VIDIOC_REQBUFS ioctl to determine if a
> memory mapped, user pointer or DMABUF based I/O is supported by the driver.
>
> So a set of VIDIOC_REQBUFS ioctl calls will be made with count 0 and then
> the real VIDIOC_REQBUFS call with count == n. But for count 0, the driver
> not only frees the buffer but also closes the MFC instance and s5p_mfc_ctx
> state is set to MFCINST_FREE.
>
> The VIDIOC_REQBUFS handler for the output device checks if the s5p_mfc_ctx
> state is set to MFCINST_INIT (which happens on an VIDIOC_S_FMT) and fails
> otherwise. So after a VIDIOC_REQBUFS(n), future VIDIOC_REQBUFS(n) calls
> will fails unless a VIDIOC_S_FMT ioctl calls happens before the reqbufs.
>
> But applications may first set the format and then attempt to determine
> the I/O methods supported by the driver (for example Gstramer does it) so
> the state won't be set to MFCINST_INIT again and VIDIOC_REQBUFS will fail.
>
> To avoid this issue, only free the buffers on VIDIOC_REQBUFS(0) but don't
> close the MFC instance to allow future VIDIOC_REQBUFS(n) calls to succeed.
>
> Signed-off-by: ayaka <ayaka@soulik.info>
> [javier: Rewrote changelog to explain the problem more detailed]
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>
> ---
> Hello,
>
> This is a resend of a patch posted by Ayaka some time ago [0].
> Without $SUBJECT, trying to decode a video using Gstramer fails
> on an Exynos5422 Odroid XU4 board with following error message:
>
> $ gst-launch-1.0 filesrc location=test.mov ! qtdemux ! h264parse ! v4l2video0dec ! videoconvert ! autovideosink
>
> Setting pipeline to PAUSED ...
> Pipeline is PREROLLING ...
> [ 3947.114756] vidioc_reqbufs:576: Only V4L2_MEMORY_MAP is supported
> [ 3947.114771] vidioc_reqbufs:576: Only V4L2_MEMORY_MAP is supported
> [ 3947.114903] reqbufs_output:484: Reqbufs called in an invalid state
> [ 3947.114913] reqbufs_output:510: Failed allocating buffers for OUTPUT queue
> ERROR: from element /GstPipeline:pipeline0/v4l2video0dec:v4l2video0dec0: Failed to allocate required memory.
> Additional debug info:
> gstv4l2videodec.c(575): gst_v4l2_video_dec_handle_frame (): /GstPipeline:pipeline0/v4l2video0dec:v4l2video0dec0:
> Buffer pool activation failed
> ERROR: pipeline doesn't want to preroll.
> Setting pipeline to NULL ...
> Freeing pipeline ...
>
> [0]: https://patchwork.linuxtv.org/patch/32794/
>
> Best regards,
> Javier
>
>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index f2d6376ce618..8b9467de2d6a 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -474,7 +474,6 @@ static int reqbufs_output(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
>   		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
>   		if (ret)
>   			goto out;
> -		s5p_mfc_close_mfc_inst(dev, ctx);
>   		ctx->src_bufs_cnt = 0;
>   		ctx->output_state = QUEUE_FREE;
>   	} else if (ctx->output_state == QUEUE_FREE) {

