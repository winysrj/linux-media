Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57416 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab2K0OMz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 09:12:55 -0500
Date: Tue, 27 Nov 2012 15:12:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH 10/15] [media] marvell-ccic: split mcam core into 2 parts
 for soc_camera support
In-Reply-To: <1353677652-24288-1-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1211271405340.22273@axis700.grange>
References: <1353677652-24288-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Nov 2012, Albert Wang wrote:

> This patch splits mcam core into 2 parts to prepare for soc_camera support.
> 
> The first part remains in mcam-core. This part includes the HW operations
> and vb2 callback functions.
> 
> The second part is moved to mcam-core-standard.c. This part is relevant with
> the implementation of using v4l2.
> 
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> Signed-off-by: Albert Wang <twang13@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/Makefile       |    4 +-
>  .../platform/marvell-ccic/mcam-core-standard.c     |  767 +++++++++++++++++
>  .../platform/marvell-ccic/mcam-core-standard.h     |   28 +
>  drivers/media/platform/marvell-ccic/mcam-core.c    |  873 +-------------------
>  drivers/media/platform/marvell-ccic/mcam-core.h    |   45 +
>  5 files changed, 883 insertions(+), 834 deletions(-)
>  create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-standard.c
>  create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-standard.h

Nice :-) I hope, you'll excuse me, that I won't be verifying this patch 
thoroughly, instead, I'll trust you to move the code around without actually 
changing anything in it. Actually, you did change a couple of things - like
replaced printk() with cam_err(), and actually here:

> +		cam_err(cam, "marvell-cam: Cafe can't do S/G I/O," \
> +			"attempting vmalloc mode instead\n");

and here

> +			cam_warn(cam, "Unable to alloc DMA buffers at load" \
> +					"will try again later\n");

the backslashes are not needed... Also in these declarations:

> -static inline int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
> +inline int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
>  {
>  	return 0;
>  }
>  
> -static inline void mcam_free_dma_bufs(struct mcam_camera *cam)
> +inline void mcam_free_dma_bufs(struct mcam_camera *cam)
>  {
>  	return;
>  }
>  
> -static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
> +inline int mcam_check_dma_buffers(struct mcam_camera *cam)
>  {
>  	return 0;
>  }

please also remove "inline." Yet another hunk:

> -static void mcam_ctlr_stop(struct mcam_camera *cam)
> +void mcam_ctlr_stop(struct mcam_camera *cam)

doesn't seem to be needed. In the header:

> diff --git a/drivers/media/platform/marvell-ccic/mcam-core-standard.h b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
> new file mode 100644
> index 0000000..148a1a1
> --- /dev/null
> +++ b/drivers/media/platform/marvell-ccic/mcam-core-standard.h
> @@ -0,0 +1,28 @@
> +/*
> + * Marvell camera core structures.
> + *
> + * Copyright 2011 Jonathan Corbet corbet@lwn.net
> + */
> +extern bool alloc_bufs_at_read;
> +extern int n_dma_bufs;
> +extern int buffer_mode;
> +extern const struct vb2_ops mcam_vb2_sg_ops;
> +extern const struct vb2_ops mcam_vb2_ops;

Do all these variables really have to be exported? If yes - please prefix 
them all with "mcam_..." to avoid polluting the kernel name-space. You 
don't want to make a symbol named like "n_dma_bufs" or "buffer_mode" be 
visible to the entire kernel;-) In function declarations:

> +extern void mcam_ctlr_stop_dma(struct mcam_camera *cam);
> +extern int mcam_config_mipi(struct mcam_camera *mcam, int enable);
> +extern void mcam_ctlr_power_up(struct mcam_camera *cam);
> +extern void mcam_ctlr_power_down(struct mcam_camera *cam);
> +extern void mcam_ctlr_init(struct mcam_camera *cam);
> +extern int mcam_cam_init(struct mcam_camera *cam);
> +extern void mcam_free_dma_bufs(struct mcam_camera *cam);
> +extern void mcam_ctlr_dma_sg(struct mcam_camera *cam);
> +extern void mcam_dma_sg_done(struct mcam_camera *cam, int frame);
> +extern int mcam_check_dma_buffers(struct mcam_camera *cam);
> +extern void mcam_set_config_needed(struct mcam_camera *cam, int needed);
> +extern int __mcam_cam_reset(struct mcam_camera *cam);
> +extern int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime);
> +extern void mcam_ctlr_dma_contig(struct mcam_camera *cam);
> +extern void mcam_dma_contig_done(struct mcam_camera *cam, int frame);
> +extern void mcam_ctlr_dma_vmalloc(struct mcam_camera *cam);
> +extern void mcam_vmalloc_done(struct mcam_camera *cam, int frame);

the keyword "extern" isn't needed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
