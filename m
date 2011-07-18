Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35312 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1GRSRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 14:17:02 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p6IIGxD3013387
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 13:17:02 -0500
Received: from dbde71.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id p6IIGxYx024792
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 23:46:59 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "JAIN, AMBER" <amber@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 18 Jul 2011 23:46:59 +0530
Subject: RE: [PATCH v2 2/3] V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers
 in qbuf and dqbuf
Message-ID: <19F8576C6E063C45BE387C64729E739404E3737BA8@dbde02.ent.ti.com>
References: <1310041278-8810-1-git-send-email-amber@ti.com>
 <1310041278-8810-3-git-send-email-amber@ti.com>
In-Reply-To: <1310041278-8810-3-git-send-email-amber@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: JAIN, AMBER
> Sent: Thursday, July 07, 2011 5:51 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav; JAIN, AMBER
> Subject: [PATCH v2 2/3] V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers
> in qbuf and dqbuf
> 
> Add support to map the buffer using dma_map_single during qbuf which
> inturn
> calls cache flush and unmap the same during dqbuf. This is done to prevent
> the artifacts seen because of cache-coherency issues on OMAP4
> 
> Signed-off-by: Amber Jain <amber@ti.com>
> ---
> Changes from v1:
> - Changed the definition of address variables to be u32 instead of int.
> - Removed extra typedef for size variable.
> 
>  drivers/media/video/omap/omap_vout.c |   29 +++++++++++++++++++++++++++--
>  1 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 6cd3622..7d3410a 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -37,6 +37,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/irq.h>
>  #include <linux/videodev2.h>
> +#include <linux/dma-mapping.h>
> 
>  #include <media/videobuf-dma-contig.h>
>  #include <media/v4l2-device.h>
> @@ -778,6 +779,17 @@ static int omap_vout_buffer_prepare(struct
> videobuf_queue *q,
>  		vout->queued_buf_addr[vb->i] = (u8 *)
>  			omap_vout_uservirt_to_phys(vb->baddr);
>  	} else {
> +		u32 addr, dma_addr;
> +		unsigned long size;
> +
> +		addr = (unsigned long) vout->buf_virt_addr[vb->i];
> +		size = (unsigned long) vb->size;
> +
> +		dma_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void
> *) addr,
> +				size, DMA_TO_DEVICE);
> +		if (dma_mapping_error(vout->vid_dev->v4l2_dev.dev, dma_addr))
> +			v4l2_err(&vout->vid_dev->v4l2_dev, "dma_map_single
> failed\n");
> +
>  		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb-
> >i];
>  	}
> 
> @@ -1567,15 +1579,28 @@ static int vidioc_dqbuf(struct file *file, void
> *fh, struct v4l2_buffer *b)
>  	struct omap_vout_device *vout = fh;
>  	struct videobuf_queue *q = &vout->vbq;
> 
> +	int ret;
> +	u32 addr;
> +	unsigned long size;
> +	struct videobuf_buffer *vb;
> +
> +	vb = q->bufs[b->index];
> +
>  	if (!vout->streaming)
>  		return -EINVAL;
> 
>  	if (file->f_flags & O_NONBLOCK)
>  		/* Call videobuf_dqbuf for non blocking mode */
> -		return videobuf_dqbuf(q, (struct v4l2_buffer *)b, 1);
> +		ret = videobuf_dqbuf(q, (struct v4l2_buffer *)b, 1);
>  	else
>  		/* Call videobuf_dqbuf for  blocking mode */
> -		return videobuf_dqbuf(q, (struct v4l2_buffer *)b, 0);
> +		ret = videobuf_dqbuf(q, (struct v4l2_buffer *)b, 0);
> +
> +	addr = (unsigned long) vout->buf_phy_addr[vb->i];
> +	size = (unsigned long) vb->size;
> +	dma_unmap_single(vout->vid_dev->v4l2_dev.dev,  addr,
> +				size, DMA_TO_DEVICE);
> +	return ret;
>  }
> 
>  static int vidioc_streamon(struct file *file, void *fh, enum
> v4l2_buf_type i)
[Hiremath, Vaibhav] Acked-By: Vaibhav Hiremath <hvaibhav@ti.com>

Thanks,
Vaibhav
> --
> 1.7.1

