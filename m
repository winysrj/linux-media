Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52732 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1FGJFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 05:05:18 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5795E9J016227
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 04:05:17 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id p5795DBN029076
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 14:35:14 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 7 Jun 2011 14:35:12 +0530
Subject: RE: [PATCH 1/2] OMAP_VOUT: CLEANUP: Move some functions and macros
 from omap_vout
Message-ID: <19F8576C6E063C45BE387C64729E739404E2EEF11C@dbde02.ent.ti.com>
References: <1306479677-23540-1-git-send-email-archit@ti.com>
 <1306479677-23540-2-git-send-email-archit@ti.com>
In-Reply-To: <1306479677-23540-2-git-send-email-archit@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: Taneja, Archit
> Sent: Friday, May 27, 2011 12:31 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav; Taneja, Archit
> Subject: [PATCH 1/2] OMAP_VOUT: CLEANUP: Move some functions and macros
> from omap_vout
> 
[Hiremath, Vaibhav] You may want to give patch revision here. 
Cosmetic comment - 

Consider changing the subject line to something - 

OMAP_VOUT: CLEANUP: Move generic functions and macros to common files

 
> Move some inline functions from omap_vout.c to omap_voutdef.h and
> independent
> functions like omap_vout_alloc_buffer/omap_vout_free_buffer to
> omap_voutlib.c.
> 
[Hiremath, Vaibhav] Ditto here, word "some" doesn't convey anything.

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
> index 4ada9be..6433e7b 100644
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
>  #include <video/omapdss.h>
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
[Hiremath, Vaibhav] As part of this cleanup I would suggest to rename these API's to self descriptive, something like - 

rotation_enabled => is_rotation_enabled
rotate_90_or_270 => is_rotation_90_or_270


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
> index 659497b..31e6261 100644
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
> index 2aa6a76..c28ef05 100644
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
> @@ -291,3 +293,45 @@ void omap_vout_new_format(struct v4l2_pix_format
> *pix,
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
[Hiremath, Vaibhav] We do not need to use externs here; this should be another cleanup candidate which can be done with this patch series.

Thanks,
Vaibhav
> --
> 1.7.1

