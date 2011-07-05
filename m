Return-path: <mchehab@localhost>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58015 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab1GETER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 15:04:17 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p65J4DhW015297
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 5 Jul 2011 14:04:15 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "JAIN, AMBER" <amber@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Wed, 6 Jul 2011 00:34:11 +0530
Subject: RE: [PATCH 2/6] V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers in
 qbuf and dqbuf
Message-ID: <19F8576C6E063C45BE387C64729E739404E3485E6C@dbde02.ent.ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
 <1307458058-29030-3-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-3-git-send-email-amber@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>


> -----Original Message-----
> From: JAIN, AMBER
> Sent: Tuesday, June 07, 2011 8:18 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav; Semwal, Sumit; JAIN, AMBER
> Subject: [PATCH 2/6] V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers in
> qbuf and dqbuf
> 
[Hiremath, Vaibhav] few minor comments below -

> Add support to map the buffer using dma_map_single during qbuf which
> inturn
> calls cache flush and unmap the same during dqbuf. This is done to prevent
> the artifacts seen because of cache-coherency issues on OMAP4
> 
> Signed-off-by: Amber Jain <amber@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |   29 +++++++++++++++++++++++++++--
>  1 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 6fe7efa..435fe65 100644
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
> @@ -768,6 +769,17 @@ static int omap_vout_buffer_prepare(struct
> videobuf_queue *q,
>  		vout->queued_buf_addr[vb->i] = (u8 *)
>  			omap_vout_uservirt_to_phys(vb->baddr);
>  	} else {
> +		int addr, dma_addr;
[Hiremath, Vaibhav] Why is it "int"? It should be either u32 or unsigned long or dma_addr_t. Also you don't need type casting everywhere with this.

> +		unsigned long size;
> +
> +		addr = (unsigned long) vout->buf_virt_addr[vb->i];
> +		size = (unsigned long) vb->size;
> +
> +		dma_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void
> *) addr,
> +				(unsigned) size, DMA_TO_DEVICE);
[Hiremath, Vaibhav] Why type casting required here?

> +		if (dma_mapping_error(vout->vid_dev->v4l2_dev.dev, dma_addr))
> +			printk(KERN_ERR "dma_map_single failed\n");
[Hiremath, Vaibhav] Can this be changed to v4l2_err?

> +
>  		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb-
> >i];
>  	}
> 
> @@ -1549,15 +1561,28 @@ static int vidioc_dqbuf(struct file *file, void
> *fh, struct v4l2_buffer *b)
>  	struct omap_vout_device *vout = fh;
>  	struct videobuf_queue *q = &vout->vbq;
> 
> +	unsigned long size;
> +	u32 addr;
> +	struct videobuf_buffer *vb;
> +	int ret;
> +
[Hiremath, Vaibhav] Just for readability can you put them in order (lengthwise)?

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
> +				(unsigned) size, DMA_TO_DEVICE);
[Hiremath, Vaibhav] Type cast???

Thanks,
Vaibhav

> +	return ret;
>  }
> 
>  static int vidioc_streamon(struct file *file, void *fh, enum
> v4l2_buf_type i)
> --
> 1.7.1

