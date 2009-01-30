Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0U3oSU6031682
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 22:50:28 -0500
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0U3oDBr008583
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 22:50:13 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Curran, Dominic" <dcurran@ti.com>, linux-omap
	<linux-omap@vger.kernel.org>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Fri, 30 Jan 2009 09:20:01 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403FA7901FC@dbde02.ent.ti.com>
In-Reply-To: <200901291853.31318.dcurran@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "greg.hofer@hp.com" <greg.hofer@hp.com>
Subject: RE: [OMAPZOOM][PATCH 2/6] Increase isp workaround buffer size for
 8MP	sensor.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> bounces@redhat.com] On Behalf Of Curran, Dominic
> Sent: Friday, January 30, 2009 6:24 AM
> To: linux-omap; video4linux-list@redhat.com
> Cc: greg.hofer@hp.com
> Subject: [OMAPZOOM][PATCH 2/6] Increase isp workaround buffer size
> for 8MP sensor.
> 
> From: Dominic Curran <dcurran@ti.com>
> Subject: [OMAPZOOM][PATCH 2/6] Increase isp workaround buffer size
> for 8MP
> sensor.
> 
> A temporary buffer is created to hold the image while it is written
> by
> Previewer module and then read by Resizer module. This is called LSC
> Workaround. To take into account the Sony IMX046 8MP sensor that
> buffer
> needs to be increased in size.
> Changed the #defines to be upper case.
> Patch also fixes the initialization of a couple of CCDC values.
> 
> Signed-off-by: Dominic Curran <dcurran@ti.com>
> ---
>  drivers/media/video/isp/isp.c     |   10 +++++-----
>  drivers/media/video/isp/isp.h     |    4 ++--
>  drivers/media/video/isp/ispccdc.c |    2 ++
>  3 files changed, 9 insertions(+), 7 deletions(-)
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
>  		return -ENOMEM;
>  	}
> 
> -	sglist_alloc = videobuf_vmalloc_to_sg(buff_addr, no_of_pages);
> +	sglist_alloc = videobuf_vmalloc_to_sg(buff_addr,
> ISP_BUFFER_MAX_PAGES);
>  	if (!sglist_alloc) {
>  		printk(KERN_ERR "videobuf_vmalloc_to_sg error");
>  		return -ENOMEM;
>  	}
> -	num_sc = dma_map_sg(NULL, sglist_alloc, no_of_pages, 1);
> -	buff_addr_mapped = ispmmu_map_sg(sglist_alloc, no_of_pages);
> +	num_sc = dma_map_sg(NULL, sglist_alloc, ISP_BUFFER_MAX_PAGES,
> 1);
> +	buff_addr_mapped = ispmmu_map_sg(sglist_alloc,
> ISP_BUFFER_MAX_PAGES);
>  	if (!buff_addr_mapped) {
>  		printk(KERN_ERR "ispmmu_map_sg mapping failed ");
>  		return -ENOMEM;
> @@ -1217,7 +1217,7 @@ void isp_buf_free(void)
>  {
>  	if (alloc_done == 1) {
>  		ispmmu_unmap(buff_addr_mapped);
> -		dma_unmap_sg(NULL, sglist_alloc, no_of_pages, 1);
> +		dma_unmap_sg(NULL, sglist_alloc, ISP_BUFFER_MAX_PAGES,
> 1);
>  		kfree(sglist_alloc);
>  		vfree(buff_addr);
>  		alloc_done = 0;
> Index: omapzoom04/drivers/media/video/isp/isp.h
> ===================================================================
> --- omapzoom04.orig/drivers/media/video/isp/isp.h
> +++ omapzoom04/drivers/media/video/isp/isp.h
> @@ -69,8 +69,8 @@
>  #define NUM_ISP_CAPTURE_FORMATS 	(sizeof(isp_formats) /\
>  							sizeof(isp_formats[0]))
>  #define ISP_WORKAROUND 1
> -#define buffer_size (1024 * 1024 * 10)
> -#define no_of_pages (buffer_size / (4 * 1024))
> +#define ISP_BUFFER_MAX_SIZE (1024 * 1024 * 16)
> +#define ISP_BUFFER_MAX_PAGES (ISP_BUFFER_MAX_SIZE / (4 * 1024))
> 
[Hiremath, Vaibhav] Is here (4 * 1024) indicates ISP-MMUSG page size configuration or normal kernel page size?

If it is kernel page size, then we can use PAGE_SIZE macro instead of hard coding.

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
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-
> request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
