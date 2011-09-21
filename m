Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40426 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab1IUIkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 04:40:23 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 21 Sep 2011 14:10:14 +0530
Subject: RE: [PATCH 1/5] [media]: OMAP_VOUT: Fix check in reqbuf & mmap for
 buf_size allocation
Message-ID: <19F8576C6E063C45BE387C64729E739404EC941E1C@dbde02.ent.ti.com>
References: <1316167233-1437-1-git-send-email-archit@ti.com>
 <1316167233-1437-2-git-send-email-archit@ti.com>
In-Reply-To: <1316167233-1437-2-git-send-email-archit@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Taneja, Archit
> Sent: Friday, September 16, 2011 3:30 PM
> To: Hiremath, Vaibhav
> Cc: Valkeinen, Tomi; linux-omap@vger.kernel.org; Semwal, Sumit; linux-
> media@vger.kernel.org; Taneja, Archit
> Subject: [PATCH 1/5] [media]: OMAP_VOUT: Fix check in reqbuf & mmap for
> buf_size allocation
> 
> The commit 383e4f69879d11c86ebdd38b3356f6d0690fb4cc makes reqbuf and mmap
> prevent
> requesting a larger size buffer than what is allocated at kernel boot
> during
> omap_vout_probe.
> 
> The requested size is compared with vout->buffer_size, this isn't correct
> as
> vout->buffer_size is later set to the size requested in reqbuf. When the
> video
> device is opened the next time, this check will prevent us to allocate a
> buffer
> which is larger than what we requested the last time.
> 
> Don't use vout->buffer_size, always check with the parameters
> video1_bufsize
> or video2_bufsize.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 95daf98..e14c82b 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -664,10 +664,14 @@ static int omap_vout_buffer_setup(struct
> videobuf_queue *q, unsigned int *count,
>  	u32 phy_addr = 0, virt_addr = 0;
>  	struct omap_vout_device *vout = q->priv_data;
>  	struct omapvideo_info *ovid = &vout->vid_info;
> +	int vid_max_buf_size;
> 
>  	if (!vout)
>  		return -EINVAL;
> 
> +	vid_max_buf_size = vout->vid == OMAP_VIDEO1 ? video1_bufsize :
> +		video2_bufsize;
> +
>  	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != q->type)
>  		return -EINVAL;
> 
> @@ -690,7 +694,7 @@ static int omap_vout_buffer_setup(struct
> videobuf_queue *q, unsigned int *count,
>  		video1_numbuffers : video2_numbuffers;
> 
>  	/* Check the size of the buffer */
> -	if (*size > vout->buffer_size) {
> +	if (*size > vid_max_buf_size) {
Good catch !!!

>  		v4l2_err(&vout->vid_dev->v4l2_dev,
>  				"buffer allocation mismatch [%u] [%u]\n",
>  				*size, vout->buffer_size);
> @@ -865,6 +869,8 @@ static int omap_vout_mmap(struct file *file, struct
> vm_area_struct *vma)
>  	unsigned long size = (vma->vm_end - vma->vm_start);
>  	struct omap_vout_device *vout = file->private_data;
>  	struct videobuf_queue *q = &vout->vbq;
> +	int vid_max_buf_size = vout->vid == OMAP_VIDEO1 ? video1_bufsize :
> +		video2_bufsize;
> 
>  	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
>  			" %s pgoff=0x%lx, start=0x%lx, end=0x%lx\n", __func__,
> @@ -887,7 +893,7 @@ static int omap_vout_mmap(struct file *file, struct
> vm_area_struct *vma)
>  		return -EINVAL;
>  	}
>  	/* Check the size of the buffer */
> -	if (size > vout->buffer_size) {
> +	if (size > vid_max_buf_size) {
Don't you think in case of mmap we should still check for the 
vout->buffer_size, since this is the size user has requested in req_buf.

Thanks,
Vaibhav


>  		v4l2_err(&vout->vid_dev->v4l2_dev,
>  				"insufficient memory [%lu] [%u]\n",
>  				size, vout->buffer_size);
> --
> 1.7.1

