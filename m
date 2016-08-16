Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:36335 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbcHPGcT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 02:32:19 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 04/13] media: platform: pxa_camera: convert to vb2
References: <1471287723-25451-1-git-send-email-robert.jarzmik@free.fr>
	<1471287723-25451-5-git-send-email-robert.jarzmik@free.fr>
Date: Tue, 16 Aug 2016 08:32:15 +0200
In-Reply-To: <1471287723-25451-5-git-send-email-robert.jarzmik@free.fr>
	(Robert Jarzmik's message of "Mon, 15 Aug 2016 21:01:54 +0200")
Message-ID: <877fbhql5c.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Convert pxa_camera from videobuf to videobuf2.
>
> As the soc_camera was already compatible with videobuf2, the port is
> quite straightforward.
>
> The special case of this code in which the vb2 to prepare is "too
> big" in terms of size for the new capture format, the pxa_camera will
> fail.
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
...zip...

> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index 2aaf4a8f71a0..5bf97c6b6810 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> -static void pxa_camera_init_videobuf(struct videobuf_queue *q,
> -			      struct soc_camera_device *icd)
> +static int pxa_camera_init_videobuf2(struct vb2_queue *vq,
> +				     struct soc_camera_device *icd)
>  {
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct pxa_camera_dev *pcdev = ici->priv;
> +	int ret;
>  
> -	/*
> -	 * We must pass NULL as dev pointer, then all pci_* dma operations
> -	 * transform to normal dma_* ones.
> -	 */
> -	videobuf_queue_sg_init(q, &pxa_videobuf_ops, NULL, &pcdev->lock,
> -				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
> -				sizeof(struct pxa_buffer), icd, &ici->host_lock);
> +	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	vq->drv_priv = pcdev;
> +	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	vq->buf_struct_size = sizeof(struct pxa_buffer);
> +	vq->dev = pcdev->v4l2_dev.dev;

This last line breaks bisectability as the v4l2_dev only appears in patch 10
... I'm afraid at least this will trigger a v5 respin of the patches.

Cheers.

--
Robert
