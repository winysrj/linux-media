Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:22545 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZAaPH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jan 2009 10:07:58 -0500
Subject: Re: [OMAPZOOM][PATCH v2 2/6] Increase isp workaround buffer size
 for 8MP sensor.
From: Alexey Klimov <klimov.linux@gmail.com>
To: Dominic Curran <dcurran@ti.com>
Cc: linux-media@vger.kernel.org,
	linux-omap <linux-omap@vger.kernel.org>, greg.hofer@hp.com
In-Reply-To: <200901301745.54348.dcurran@ti.com>
References: <200901301745.54348.dcurran@ti.com>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 18:08:29 +0300
Message-Id: <1233414510.19658.18.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Dominic
May i ask few questions ?

Well, looks like it's unrelated to your patch. Lines that don't looks
okay to me appear in your patch.

On Fri, 2009-01-30 at 17:45 -0600, Dominic Curran wrote:
> From: Dominic Curran <dcurran@ti.com>
> Subject: [OMAPZOOM][PATCH v2 2/6] Increase isp workaround buffer size for 8MP 
> sensor.
> 
> A temporary buffer is created to hold the image while it is written by
> Previewer module and then read by Resizer module. This is called LSC
> Workaround. To take into account the Sony IMX046 8MP sensor that buffer
> needs to be increased in size.
> Changed the #defines to be upper case.
> Patch also fixes the initialization of a couple of CCDC values.
> 
> Signed-off-by: Dominic Curran <dcurran@ti.com>
> ---
>  drivers/media/video/isp/isp.c     |   10 +++++-----
>  drivers/media/video/isp/isp.h     |    7 +++++--
>  drivers/media/video/isp/ispccdc.c |    2 ++
>  drivers/media/video/isp/ispmmu.h  |    3 +++
>  4 files changed, 15 insertions(+), 7 deletions(-)
> 
> Index: omapzoom04/drivers/media/video/isp/isp.c
> ===================================================================
> --- omapzoom04.orig/drivers/media/video/isp/isp.c
> +++ omapzoom04/drivers/media/video/isp/isp.c
> @@ -1172,20 +1172,20 @@ void omapisp_unset_callback()
>   **/
>  u32 isp_buf_allocation(void)
>  {
> -	buff_addr = (void *) vmalloc(buffer_size);
> +	buff_addr = (void *) vmalloc(ISP_BUFFER_MAX_SIZE);
>  
>  	if (!buff_addr) {
>  		printk(KERN_ERR "Cannot allocate memory ");

Will user understand what module (or system of kernel) provide this
printk message ? Should module name be here ?

>  		return -ENOMEM;
>  	}
>  
> -	sglist_alloc = videobuf_vmalloc_to_sg(buff_addr, no_of_pages);
> +	sglist_alloc = videobuf_vmalloc_to_sg(buff_addr, ISP_BUFFER_MAX_PAGES);
>  	if (!sglist_alloc) {
>  		printk(KERN_ERR "videobuf_vmalloc_to_sg error");

Well, may be here too..
By the way, why there is no "\n" in the end of messages in this
function ?

>  		return -ENOMEM;
>  	}
> -	num_sc = dma_map_sg(NULL, sglist_alloc, no_of_pages, 1);
> -	buff_addr_mapped = ispmmu_map_sg(sglist_alloc, no_of_pages);
> +	num_sc = dma_map_sg(NULL, sglist_alloc, ISP_BUFFER_MAX_PAGES, 1);
> +	buff_addr_mapped = ispmmu_map_sg(sglist_alloc, ISP_BUFFER_MAX_PAGES);
>  	if (!buff_addr_mapped) {
>  		printk(KERN_ERR "ispmmu_map_sg mapping failed ");

Probably the same thing here.
May be someone can correct sitation if necessary..

>  		return -ENOMEM;
> @@ -1217,7 +1217,7 @@ void isp_buf_free(void)
>  {
>  	if (alloc_done == 1) {
>  		ispmmu_unmap(buff_addr_mapped);
> -		dma_unmap_sg(NULL, sglist_alloc, no_of_pages, 1);
> +		dma_unmap_sg(NULL, sglist_alloc, ISP_BUFFER_MAX_PAGES, 1);
>  		kfree(sglist_alloc);
>  		vfree(buff_addr);
>  		alloc_done = 0;
> Index: omapzoom04/drivers/media/video/isp/isp.h
> ===================================================================
> --- omapzoom04.orig/drivers/media/video/isp/isp.h
> +++ omapzoom04/drivers/media/video/isp/isp.h
> @@ -26,6 +26,9 @@
>  #define OMAP_ISP_TOP_H
>  #include <media/videobuf-dma-sg.h>
>  #include <linux/videodev2.h>
> +
> +#include "ispmmu.h"
> +
>  #define OMAP_ISP_CCDC		(1 << 0)
>  #define OMAP_ISP_PREVIEW	(1 << 1)
>  #define OMAP_ISP_RESIZER	(1 << 2)
> @@ -69,8 +72,8 @@
>  #define NUM_ISP_CAPTURE_FORMATS 	(sizeof(isp_formats) /\
>  							sizeof(isp_formats[0]))
>  #define ISP_WORKAROUND 1
> -#define buffer_size (1024 * 1024 * 10)
> -#define no_of_pages (buffer_size / (4 * 1024))
> +#define ISP_BUFFER_MAX_SIZE (1024 * 1024 * 16)
> +#define ISP_BUFFER_MAX_PAGES (ISP_BUFFER_MAX_SIZE / ISPMMU_PAGE_SIZE)
>  
>  typedef int (*isp_vbq_callback_ptr) (struct videobuf_buffer *vb);
>  typedef void (*isp_callback_t) (unsigned long status,
> Index: omapzoom04/drivers/media/video/isp/ispccdc.c
> ===================================================================
> --- omapzoom04.orig/drivers/media/video/isp/ispccdc.c
> +++ omapzoom04/drivers/media/video/isp/ispccdc.c
> @@ -1265,6 +1265,8 @@ int ispccdc_config_size(u32 input_w, u32
>  	}
>  
>  	if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP) {
> +		ispccdc_obj.ccdcin_woffset = 0;
> +		ispccdc_obj.ccdcin_hoffset = 0;
>  		omap_writel((ispccdc_obj.ccdcin_woffset <<
>  					ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
>  					(ispccdc_obj.ccdcin_w <<
> Index: omapzoom04/drivers/media/video/isp/ispmmu.h
> ===================================================================
> --- omapzoom04.orig/drivers/media/video/isp/ispmmu.h
> +++ omapzoom04/drivers/media/video/isp/ispmmu.h
> @@ -59,6 +59,9 @@
>  /* Number of entries per L2 Page table */
>  #define ISPMMU_L2D_ENTRIES_NR		256
>  
> +/* Size of MMU page in bytes */
> +#define ISPMMU_PAGE_SIZE		4096
> +
>  /*
>   * Statically allocate 16KB for L2 page tables. 16KB can be used for
>   * up to 16 L2 page tables which cover up to 16MB space. We use an array of 16
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Best regards, Klimov Alexey

