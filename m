Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2GaGpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 02:45:54 -0400
Date: Tue, 31 Jul 2012 08:45:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Gershgorin <alexg@meprolight.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: mx3_camera: buf_init() add buffer state check
In-Reply-To: <1343675227-9061-1-git-send-email-alexg@meprolight.com>
Message-ID: <Pine.LNX.4.64.1207310838110.27888@axis700.grange>
References: <1343675227-9061-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex

On Mon, 30 Jul 2012, Alex Gershgorin wrote:

> This patch check the state of the buffer when calling buf_init() method.
> The thread http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/48587
> also includes report witch can show the problem. This patch solved the problem.
> Both MMAP and USERPTR methods was successfully tested.
> 
> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> ---
>  drivers/media/video/mx3_camera.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index f13643d..950a8fe 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -405,13 +405,15 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)

Sorry, don't understand. As we see in the thread, mentioned above, the 
Oops happened in mx3_videobuf_release(). If my analysis was correct in 
that thread, that Oops happened, when .buf_cleanup() was called without 
.buf_init() being called. This your patch modifies mx3_videobuf_init(). 
which isn't even called in the problem case. How does this help?

Thanks
Guennadi

>  	struct mx3_camera_dev *mx3_cam = ici->priv;
>  	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
>  
> -	/* This is for locking debugging only */
> -	INIT_LIST_HEAD(&buf->queue);
> -	sg_init_table(&buf->sg, 1);
> +	if (buf->state != CSI_BUF_PREPARED) {
> +		/* This is for locking debugging only */
> +		INIT_LIST_HEAD(&buf->queue);
> +		sg_init_table(&buf->sg, 1);
>  
> -	buf->state = CSI_BUF_NEEDS_INIT;
> +		buf->state = CSI_BUF_NEEDS_INIT;
>  
> -	mx3_cam->buf_total += vb2_plane_size(vb, 0);
> +		mx3_cam->buf_total += vb2_plane_size(vb, 0);
> +	}
>  
>  	return 0;
>  }
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
