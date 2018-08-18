Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45506 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbeHRSrZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 14:47:25 -0400
Subject: Re: [PATCH 08/14] staging: media: tegra-vde: Track struct device *
To: Thierry Reding <thierry.reding@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
References: <20180813145027.16346-1-thierry.reding@gmail.com>
 <20180813145027.16346-9-thierry.reding@gmail.com>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <930d8dcf-0647-f41e-2bd4-4a753835dd1a@gmail.com>
Date: Sat, 18 Aug 2018 18:39:14 +0300
MIME-Version: 1.0
In-Reply-To: <20180813145027.16346-9-thierry.reding@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.08.2018 17:50, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The pointer to the struct device is frequently used, so store it in
> struct tegra_vde. Also, pass around a pointer to a struct tegra_vde
> instead of struct device in some cases to prepare for subsequent
> patches referencing additional data from that structure.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/staging/media/tegra-vde/tegra-vde.c | 63 ++++++++++++---------
>  1 file changed, 36 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
> index 41cf86dc5dbd..2496a03fd158 100644
> --- a/drivers/staging/media/tegra-vde/tegra-vde.c
> +++ b/drivers/staging/media/tegra-vde/tegra-vde.c
> @@ -71,6 +71,7 @@ struct tegra_vde_soc {
>  };
>  
>  struct tegra_vde {
> +	struct device *dev;
>  	const struct tegra_vde_soc *soc;
>  	void __iomem *sxe;
>  	void __iomem *bsev;
> @@ -644,7 +645,7 @@ static void tegra_vde_detach_and_put_dmabuf(struct dma_buf_attachment *a,
>  	dma_buf_put(dmabuf);
>  }
>  
> -static int tegra_vde_attach_dmabuf(struct device *dev,
> +static int tegra_vde_attach_dmabuf(struct tegra_vde *vde,
>  				   int fd,
>  				   unsigned long offset,
>  				   size_t min_size,
> @@ -662,38 +663,40 @@ static int tegra_vde_attach_dmabuf(struct device *dev,
>  
>  	dmabuf = dma_buf_get(fd);
>  	if (IS_ERR(dmabuf)) {
> -		dev_err(dev, "Invalid dmabuf FD: %d\n", fd);
> +		dev_err(vde->dev, "Invalid dmabuf FD: %d\n", fd);
>  		return PTR_ERR(dmabuf);
>  	}
>  
>  	if (dmabuf->size & (align_size - 1)) {
> -		dev_err(dev, "Unaligned dmabuf 0x%zX, should be aligned to 0x%zX\n",
> +		dev_err(vde->dev,
> +			"Unaligned dmabuf 0x%zX, should be aligned to 0x%zX\n",
>  			dmabuf->size, align_size);
>  		return -EINVAL;
>  	}
>  
>  	if ((u64)offset + min_size > dmabuf->size) {
> -		dev_err(dev, "Too small dmabuf size %zu @0x%lX, should be at least %zu\n",
> +		dev_err(vde->dev,
> +			"Too small dmabuf size %zu @0x%lX, should be at least %zu\n",
>  			dmabuf->size, offset, min_size);
>  		return -EINVAL;
>  	}
>  
> -	attachment = dma_buf_attach(dmabuf, dev);
> +	attachment = dma_buf_attach(dmabuf, vde->dev);
>  	if (IS_ERR(attachment)) {
> -		dev_err(dev, "Failed to attach dmabuf\n");
> +		dev_err(vde->dev, "Failed to attach dmabuf\n");
>  		err = PTR_ERR(attachment);
>  		goto err_put;
>  	}
>  
>  	sgt = dma_buf_map_attachment(attachment, dma_dir);
>  	if (IS_ERR(sgt)) {
> -		dev_err(dev, "Failed to get dmabufs sg_table\n");
> +		dev_err(vde->dev, "Failed to get dmabufs sg_table\n");
>  		err = PTR_ERR(sgt);
>  		goto err_detach;
>  	}
>  
>  	if (sgt->nents != 1) {
> -		dev_err(dev, "Sparse DMA region is unsupported\n");
> +		dev_err(vde->dev, "Sparse DMA region is unsupported\n");
>  		err = -EINVAL;
>  		goto err_unmap;
>  	}
> @@ -717,7 +720,7 @@ static int tegra_vde_attach_dmabuf(struct device *dev,
>  	return err;
>  }
>  
> -static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
> +static int tegra_vde_attach_dmabufs_to_frame(struct tegra_vde *vde,
>  					     struct video_frame *frame,
>  					     struct tegra_vde_h264_frame *src,
>  					     enum dma_data_direction dma_dir,
> @@ -726,7 +729,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
>  {
>  	int err;
>  
> -	err = tegra_vde_attach_dmabuf(dev, src->y_fd,
> +	err = tegra_vde_attach_dmabuf(vde, src->y_fd,
>  				      src->y_offset, lsize, SZ_256,
>  				      &frame->y_dmabuf_attachment,
>  				      &frame->y_addr,
> @@ -735,7 +738,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
>  	if (err)
>  		return err;
>  
> -	err = tegra_vde_attach_dmabuf(dev, src->cb_fd,
> +	err = tegra_vde_attach_dmabuf(vde, src->cb_fd,
>  				      src->cb_offset, csize, SZ_256,
>  				      &frame->cb_dmabuf_attachment,
>  				      &frame->cb_addr,
> @@ -744,7 +747,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
>  	if (err)
>  		goto err_release_y;
>  
> -	err = tegra_vde_attach_dmabuf(dev, src->cr_fd,
> +	err = tegra_vde_attach_dmabuf(vde, src->cr_fd,
>  				      src->cr_offset, csize, SZ_256,
>  				      &frame->cr_dmabuf_attachment,
>  				      &frame->cr_addr,
> @@ -758,7 +761,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
>  		return 0;
>  	}
>  
> -	err = tegra_vde_attach_dmabuf(dev, src->aux_fd,
> +	err = tegra_vde_attach_dmabuf(vde, src->aux_fd,
>  				      src->aux_offset, csize, SZ_256,
>  				      &frame->aux_dmabuf_attachment,
>  				      &frame->aux_addr,
> @@ -770,33 +773,35 @@ static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
>  	return 0;
>  
>  err_release_cr:
> -	tegra_vde_detach_and_put_dmabuf(frame->cr_dmabuf_attachment,
> +	tegra_vde_detach_and_put_dmabuf(vde, frame->cr_dmabuf_attachment,
>  					frame->cr_sgt, dma_dir);
>  err_release_cb:
> -	tegra_vde_detach_and_put_dmabuf(frame->cb_dmabuf_attachment,
> +	tegra_vde_detach_and_put_dmabuf(vde, frame->cb_dmabuf_attachment,
>  					frame->cb_sgt, dma_dir);
>  err_release_y:
> -	tegra_vde_detach_and_put_dmabuf(frame->y_dmabuf_attachment,
> +	tegra_vde_detach_and_put_dmabuf(vde, frame->y_dmabuf_attachment,
>  					frame->y_sgt, dma_dir);
>  
>  	return err;
>  }
>  
> -static void tegra_vde_release_frame_dmabufs(struct video_frame *frame,
> +static void tegra_vde_release_frame_dmabufs(struct tegra_vde *vde,
> +					    struct video_frame *frame,
>  					    enum dma_data_direction dma_dir,
>  					    bool baseline_profile)
>  {
>  	if (!baseline_profile)
> -		tegra_vde_detach_and_put_dmabuf(frame->aux_dmabuf_attachment,
> +		tegra_vde_detach_and_put_dmabuf(vde,
> +						frame->aux_dmabuf_attachment,
>  						frame->aux_sgt, dma_dir);
>  
> -	tegra_vde_detach_and_put_dmabuf(frame->cr_dmabuf_attachment,
> +	tegra_vde_detach_and_put_dmabuf(vde, frame->cr_dmabuf_attachment,
>  					frame->cr_sgt, dma_dir);
>  
> -	tegra_vde_detach_and_put_dmabuf(frame->cb_dmabuf_attachment,
> +	tegra_vde_detach_and_put_dmabuf(vde, frame->cb_dmabuf_attachment,
>  					frame->cb_sgt, dma_dir);
>  
> -	tegra_vde_detach_and_put_dmabuf(frame->y_dmabuf_attachment,
> +	tegra_vde_detach_and_put_dmabuf(vde, frame->y_dmabuf_attachment,
>  					frame->y_sgt, dma_dir);
>  }
>  
> @@ -937,7 +942,7 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
>  	if (ret)
>  		return ret;
>  
> -	ret = tegra_vde_attach_dmabuf(dev, ctx.bitstream_data_fd,
> +	ret = tegra_vde_attach_dmabuf(vde, ctx.bitstream_data_fd,
>  				      ctx.bitstream_data_offset,
>  				      SZ_16K, SZ_16K,
>  				      &bitstream_data_dmabuf_attachment,
> @@ -949,7 +954,7 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
>  		return ret;
>  
>  	if (vde->soc->supports_ref_pic_marking) {
> -		ret = tegra_vde_attach_dmabuf(dev, ctx.secure_fd,
> +		ret = tegra_vde_attach_dmabuf(vde, ctx.secure_fd,
>  					      ctx.secure_offset, 0, SZ_256,
>  					      &secure_attachment,
>  					      &secure_addr,
> @@ -992,7 +997,7 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
>  
>  		dma_dir = (i == 0) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>  
> -		ret = tegra_vde_attach_dmabufs_to_frame(dev, &dpb_frames[i],
> +		ret = tegra_vde_attach_dmabufs_to_frame(vde, &dpb_frames[i],
>  							&frame, dma_dir,
>  							ctx.baseline_profile,
>  							lsize, csize);
> @@ -1081,7 +1086,7 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
>  	while (i--) {
>  		dma_dir = (i == 0) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>  
> -		tegra_vde_release_frame_dmabufs(&dpb_frames[i], dma_dir,
> +		tegra_vde_release_frame_dmabufs(vde, &dpb_frames[i], dma_dir,
>  						ctx.baseline_profile);
>  	}
>  
> @@ -1089,10 +1094,12 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
>  
>  release_bitstream_dmabuf:
>  	if (secure_attachment)
> -		tegra_vde_detach_and_put_dmabuf(secure_attachment, secure_sgt,
> +		tegra_vde_detach_and_put_dmabuf(vde, secure_attachment,
> +						secure_sgt,
>  						DMA_TO_DEVICE);
>  
> -	tegra_vde_detach_and_put_dmabuf(bitstream_data_dmabuf_attachment,
> +	tegra_vde_detach_and_put_dmabuf(vde,
> +					bitstream_data_dmabuf_attachment,
>  					bitstream_sgt, DMA_TO_DEVICE);
>  
>  	return ret;
> @@ -1190,6 +1197,8 @@ static int tegra_vde_probe(struct platform_device *pdev)
>  	if (!vde)
>  		return -ENOMEM;
>  
> +	vde->dev = &pdev->dev;
> +
>  	platform_set_drvdata(pdev, vde);
>  
>  	vde->soc = of_device_get_match_data(&pdev->dev);
> 

This patch fails to compile.

drivers/staging/media/tegra-vde/tegra-vde.c: In function
‘tegra_vde_attach_dmabufs_to_frame’:
drivers/staging/media/tegra-vde/tegra-vde.c:776:34: error: passing argument 1 of
‘tegra_vde_detach_and_put_dmabuf’ from incompatible pointer type
[-Werror=incompatible-pointer-types]
  tegra_vde_detach_and_put_dmabuf(vde, frame->cr_dmabuf_attachment,
                                  ^~~
drivers/staging/media/tegra-vde/tegra-vde.c:637:13: note: expected ‘struct
dma_buf_attachment *’ but argument is of type ‘struct tegra_vde *’
 static void tegra_vde_detach_and_put_dmabuf(struct dma_buf_attachment *a
...

You need to rebase this patch properly.
