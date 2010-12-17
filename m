Return-path: <mchehab@gaivota>
Received: from comal.ext.ti.com ([198.47.26.152]:60998 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0LQIdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 03:33:12 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 17 Dec 2010 14:03:07 +0530
Subject: RE: [PATCH v4 1/2] OMAP_VOUT: CLEANUP: Move some functions and
 macros from omap_vout
Message-ID: <19F8576C6E063C45BE387C64729E739404BD0DBA13@dbde02.ent.ti.com>
References: <1292568208-16049-1-git-send-email-archit@ti.com>
 <1292568208-16049-2-git-send-email-archit@ti.com>
In-Reply-To: <1292568208-16049-2-git-send-email-archit@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Taneja, Archit
> Sent: Friday, December 17, 2010 12:13 PM
> To: linux-media@vger.kernel.org
> Cc: linux-omap@vger.kernel.org; Taneja, Archit
> Subject: [PATCH v4 1/2] OMAP_VOUT: CLEANUP: Move some functions and macros
> from omap_vout
> 
> Move some inline functions from omap_vout.c to omap_voutdef.h and
> independent
> functions like omap_vout_alloc_buffer/omap_vout_free_buffer to
> omap_voutlib.c.
> 
[Hiremath, Vaibhav] Thanks, Archit.

Tested-By Vaibhav Hiremath <hvaibhav@ti.com>
Acked-By Vaibhav Hiremath <hvaibhav@ti.com>


Thanks,
Vaibhav

> Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c    |  109 --------------------------
> -----
>  drivers/media/video/omap/omap_voutdef.h |   62 +++++++++++++++++
>  drivers/media/video/omap/omap_voutlib.c |   44 ++++++++++++
>  drivers/media/video/omap/omap_voutlib.h |    2 +
>  4 files changed, 108 insertions(+), 109 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 15f8793..e1df01c 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -35,17 +35,14 @@
>  #include <linux/sched.h>
>  #include <linux/types.h>
>  #include <linux/platform_device.h>
> -#include <linux/dma-mapping.h>
>  #include <linux/irq.h>
>  #include <linux/videodev2.h>
> -#include <linux/slab.h>
> 
>  #include <media/videobuf-dma-contig.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> 
>  #include <plat/dma.h>
> -#include <plat/vram.h>
>  #include <plat/vrfb.h>
>  #include <plat/display.h>
> 
> @@ -56,7 +53,6 @@ MODULE_AUTHOR("Texas Instruments");
>  MODULE_DESCRIPTION("OMAP Video for Linux Video out driver");
>  MODULE_LICENSE("GPL");
> 
> -
>  /* Driver Configuration macros */
>  #define VOUT_NAME		"omap_vout"
> 
> @@ -65,31 +61,6 @@ enum omap_vout_channels {
>  	OMAP_VIDEO2,
>  };
> 
> -enum dma_channel_state {
> -	DMA_CHAN_NOT_ALLOTED,
> -	DMA_CHAN_ALLOTED,
> -};
> -
> -#define QQVGA_WIDTH		160
> -#define QQVGA_HEIGHT		120
> -
> -/* Max Resolution supported by the driver */
> -#define VID_MAX_WIDTH		1280	/* Largest width */
> -#define VID_MAX_HEIGHT		720	/* Largest height */
> -
> -/* Mimimum requirement is 2x2 for DSS */
> -#define VID_MIN_WIDTH		2
> -#define VID_MIN_HEIGHT		2
> -
> -/* 2048 x 2048 is max res supported by OMAP display controller */
> -#define MAX_PIXELS_PER_LINE     2048
> -
> -#define VRFB_TX_TIMEOUT         1000
> -#define VRFB_NUM_BUFS		4
> -
> -/* Max buffer size tobe allocated during init */
> -#define OMAP_VOUT_MAX_BUF_SIZE (VID_MAX_WIDTH*VID_MAX_HEIGHT*4)
> -
>  static struct videobuf_queue_ops video_vbq_ops;
>  /* Variables configurable through module params*/
>  static u32 video1_numbuffers = 3;
> @@ -172,49 +143,6 @@ const static struct v4l2_fmtdesc omap_formats[] = {
>  #define NUM_OUTPUT_FORMATS (ARRAY_SIZE(omap_formats))
> 
>  /*
> - * Allocate buffers
> - */
> -static unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr)
> -{
> -	u32 order, size;
> -	unsigned long virt_addr, addr;
> -
> -	size = PAGE_ALIGN(buf_size);
> -	order = get_order(size);
> -	virt_addr = __get_free_pages(GFP_KERNEL | GFP_DMA, order);
> -	addr = virt_addr;
> -
> -	if (virt_addr) {
> -		while (size > 0) {
> -			SetPageReserved(virt_to_page(addr));
> -			addr += PAGE_SIZE;
> -			size -= PAGE_SIZE;
> -		}
> -	}
> -	*phys_addr = (u32) virt_to_phys((void *) virt_addr);
> -	return virt_addr;
> -}
> -
> -/*
> - * Free buffers
> - */
> -static void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size)
> -{
> -	u32 order, size;
> -	unsigned long addr = virtaddr;
> -
> -	size = PAGE_ALIGN(buf_size);
> -	order = get_order(size);
> -
> -	while (size > 0) {
> -		ClearPageReserved(virt_to_page(addr));
> -		addr += PAGE_SIZE;
> -		size -= PAGE_SIZE;
> -	}
> -	free_pages((unsigned long) virtaddr, order);
> -}
> -
> -/*
>   * Function for allocating video buffers
>   */
>  static int omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
> @@ -369,43 +297,6 @@ static void omap_vout_release_vrfb(struct
> omap_vout_device *vout)
>  }
> 
>  /*
> - * Return true if rotation is 90 or 270
> - */
> -static inline int rotate_90_or_270(const struct omap_vout_device *vout)
> -{
> -	return (vout->rotation == dss_rotation_90_degree ||
> -			vout->rotation == dss_rotation_270_degree);
> -}
> -
> -/*
> - * Return true if rotation is enabled
> - */
> -static inline int rotation_enabled(const struct omap_vout_device *vout)
> -{
> -	return vout->rotation || vout->mirror;
> -}
> -
> -/*
> - * Reverse the rotation degree if mirroring is enabled
> - */
> -static inline int calc_rotation(const struct omap_vout_device *vout)
> -{
> -	if (!vout->mirror)
> -		return vout->rotation;
> -
> -	switch (vout->rotation) {
> -	case dss_rotation_90_degree:
> -		return dss_rotation_270_degree;
> -	case dss_rotation_270_degree:
> -		return dss_rotation_90_degree;
> -	case dss_rotation_180_degree:
> -		return dss_rotation_0_degree;
> -	default:
> -		return dss_rotation_180_degree;
> -	}
> -}
> -
> -/*
>   * Free the V4L2 buffers
>   */
>  static void omap_vout_free_buffers(struct omap_vout_device *vout)
> diff --git a/drivers/media/video/omap/omap_voutdef.h
> b/drivers/media/video/omap/omap_voutdef.h
> index ea3a047..8609500 100644
> --- a/drivers/media/video/omap/omap_voutdef.h
> +++ b/drivers/media/video/omap/omap_voutdef.h
> @@ -27,6 +27,31 @@
>  #define MAX_DISPLAYS	3
>  #define MAX_MANAGERS	3
> 
> +#define QQVGA_WIDTH		160
> +#define QQVGA_HEIGHT		120
> +
> +/* Max Resolution supported by the driver */
> +#define VID_MAX_WIDTH		1280	/* Largest width */
> +#define VID_MAX_HEIGHT		720	/* Largest height */
> +
> +/* Mimimum requirement is 2x2 for DSS */
> +#define VID_MIN_WIDTH		2
> +#define VID_MIN_HEIGHT		2
> +
> +/* 2048 x 2048 is max res supported by OMAP display controller */
> +#define MAX_PIXELS_PER_LINE     2048
> +
> +#define VRFB_TX_TIMEOUT         1000
> +#define VRFB_NUM_BUFS		4
> +
> +/* Max buffer size tobe allocated during init */
> +#define OMAP_VOUT_MAX_BUF_SIZE (VID_MAX_WIDTH*VID_MAX_HEIGHT*4)
> +
> +enum dma_channel_state {
> +	DMA_CHAN_NOT_ALLOTED,
> +	DMA_CHAN_ALLOTED,
> +};
> +
>  /* Enum for Rotation
>   * DSS understands rotation in 0, 1, 2, 3 context
>   * while V4L2 driver understands it as 0, 90, 180, 270
> @@ -144,4 +169,41 @@ struct omap_vout_device {
>  	int io_allowed;
> 
>  };
> +
> +/*
> + * Return true if rotation is 90 or 270
> + */
> +static inline int rotate_90_or_270(const struct omap_vout_device *vout)
> +{
> +	return (vout->rotation == dss_rotation_90_degree ||
> +			vout->rotation == dss_rotation_270_degree);
> +}
> +
> +/*
> + * Return true if rotation is enabled
> + */
> +static inline int rotation_enabled(const struct omap_vout_device *vout)
> +{
> +	return vout->rotation || vout->mirror;
> +}
> +
> +/*
> + * Reverse the rotation degree if mirroring is enabled
> + */
> +static inline int calc_rotation(const struct omap_vout_device *vout)
> +{
> +	if (!vout->mirror)
> +		return vout->rotation;
> +
> +	switch (vout->rotation) {
> +	case dss_rotation_90_degree:
> +		return dss_rotation_270_degree;
> +	case dss_rotation_270_degree:
> +		return dss_rotation_90_degree;
> +	case dss_rotation_180_degree:
> +		return dss_rotation_0_degree;
> +	default:
> +		return dss_rotation_180_degree;
> +	}
> +}
>  #endif	/* ifndef OMAP_VOUTDEF_H */
> diff --git a/drivers/media/video/omap/omap_voutlib.c
> b/drivers/media/video/omap/omap_voutlib.c
> index b941c76..c27b737 100644
> --- a/drivers/media/video/omap/omap_voutlib.c
> +++ b/drivers/media/video/omap/omap_voutlib.c
> @@ -24,6 +24,8 @@
>  #include <linux/types.h>
>  #include <linux/videodev2.h>
> 
> +#include <linux/dma-mapping.h>
> +
>  #include <plat/cpu.h>
> 
>  MODULE_AUTHOR("Texas Instruments");
> @@ -291,3 +293,45 @@ void omap_vout_new_format(struct v4l2_pix_format *pix,
>  }
>  EXPORT_SYMBOL_GPL(omap_vout_new_format);
> 
> +/*
> + * Allocate buffers
> + */
> +unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr)
> +{
> +	u32 order, size;
> +	unsigned long virt_addr, addr;
> +
> +	size = PAGE_ALIGN(buf_size);
> +	order = get_order(size);
> +	virt_addr = __get_free_pages(GFP_KERNEL | GFP_DMA, order);
> +	addr = virt_addr;
> +
> +	if (virt_addr) {
> +		while (size > 0) {
> +			SetPageReserved(virt_to_page(addr));
> +			addr += PAGE_SIZE;
> +			size -= PAGE_SIZE;
> +		}
> +	}
> +	*phys_addr = (u32) virt_to_phys((void *) virt_addr);
> +	return virt_addr;
> +}
> +
> +/*
> + * Free buffers
> + */
> +void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size)
> +{
> +	u32 order, size;
> +	unsigned long addr = virtaddr;
> +
> +	size = PAGE_ALIGN(buf_size);
> +	order = get_order(size);
> +
> +	while (size > 0) {
> +		ClearPageReserved(virt_to_page(addr));
> +		addr += PAGE_SIZE;
> +		size -= PAGE_SIZE;
> +	}
> +	free_pages((unsigned long) virtaddr, order);
> +}
> diff --git a/drivers/media/video/omap/omap_voutlib.h
> b/drivers/media/video/omap/omap_voutlib.h
> index a60b16e..1d722be 100644
> --- a/drivers/media/video/omap/omap_voutlib.h
> +++ b/drivers/media/video/omap/omap_voutlib.h
> @@ -30,5 +30,7 @@ extern int omap_vout_new_window(struct v4l2_rect *crop,
>  extern void omap_vout_new_format(struct v4l2_pix_format *pix,
>  		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
>  		struct v4l2_window *win);
> +extern unsigned long omap_vout_alloc_buffer(u32 buf_size, u32
> *phys_addr);
> +extern void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size);
>  #endif	/* #ifndef OMAP_VOUTLIB_H */
> 
> --
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
