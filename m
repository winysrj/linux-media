Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33007 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424313AbcBTBTq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 20:19:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] [media] vsp1_drm.h: add missing prototypes
Date: Sat, 20 Feb 2016 03:20:21 +0200
Message-ID: <1679640.4cqBRYXBxQ@avalon>
In-Reply-To: <18922936dc2817488ebba985c5aaf3498f2ef96d.1455883689.git.mchehab@osg.samsung.com>
References: <18922936dc2817488ebba985c5aaf3498f2ef96d.1455883689.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Friday 19 February 2016 10:08:21 Mauro Carvalho Chehab wrote:
> drivers/media/platform/vsp1/vsp1_drm.c:47:5: warning: no previous prototype
> for 'vsp1_du_init' [-Wmissing-prototypes] int vsp1_du_init(struct device
> *dev)
>      ^
> drivers/media/platform/vsp1/vsp1_drm.c:76:5: warning: no previous prototype
> for 'vsp1_du_setup_lif' [-Wmissing-prototypes] int vsp1_du_setup_lif(struct
> device *dev, unsigned int width,
>      ^
> drivers/media/platform/vsp1/vsp1_drm.c:221:6: warning: no previous prototype
> for 'vsp1_du_atomic_begin' [-Wmissing-prototypes] void
> vsp1_du_atomic_begin(struct device *dev)
>       ^
> drivers/media/platform/vsp1/vsp1_drm.c:273:5: warning: no previous prototype
> for 'vsp1_du_atomic_update' [-Wmissing-prototypes] int
> vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index, ^
> drivers/media/platform/vsp1/vsp1_drm.c:451:6: warning: no previous prototype
> for 'vsp1_du_atomic_flush' [-Wmissing-prototypes] void
> vsp1_du_atomic_flush(struct device *dev)

The functions are declared in include/media/vsp1.h, but the file isn't 
included in vsp1_drm.c due to a typo. I've included <linux/vsp1.h> instead of 
<media/vsp1.h>. I'll send a fix (the DRM patches don't depend on it, so it's 
not urgent), sorry about that.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/platform/vsp1/vsp1_drm.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h
> b/drivers/media/platform/vsp1/vsp1_drm.h index 7704038c3add..f68056838319
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -35,4 +35,15 @@ int vsp1_drm_init(struct vsp1_device *vsp1);
>  void vsp1_drm_cleanup(struct vsp1_device *vsp1);
>  int vsp1_drm_create_links(struct vsp1_device *vsp1);
> 
> +int vsp1_du_init(struct device *dev);
> +int vsp1_du_setup_lif(struct device *dev, unsigned int width,
> +		      unsigned int height);
> +void vsp1_du_atomic_begin(struct device *dev);
> +int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
> +			  u32 pixelformat, unsigned int pitch,
> +			  dma_addr_t mem[2], const struct v4l2_rect *src,
> +			  const struct v4l2_rect *dst);
> +void vsp1_du_atomic_flush(struct device *dev);
> +
> +
>  #endif /* __VSP1_DRM_H__ */

-- 
Regards,

Laurent Pinchart

