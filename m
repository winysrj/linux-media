Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:62574 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964951AbeALR7b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 12:59:31 -0500
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
CC: "tfiga@chromium.org" <tfiga@chromium.org>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH 1/2] media: intel-ipu3: cio2: fix a crash with
 out-of-bounds access
Date: Fri, 12 Jan 2018 17:59:25 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A5972FEFF72@FMSMSX114.amr.corp.intel.com>
References: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

> -----Original Message-----
> From: Zhi, Yong
> Sent: Wednesday, January 03, 2018 6:57 PM
> To: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com
> Cc: tfiga@chromium.org; Mani, Rajmohan <rajmohan.mani@intel.com>; Zhi,
> Yong <yong.zhi@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>
> Subject: [PATCH 1/2] media: intel-ipu3: cio2: fix a crash with out-of-bounds
> access
> 
> When dmabuf is used for BLOB type frame, the frame buffers allocated by
> gralloc will hold more pages than the valid frame data due to height alignment.
> 
> In this case, the page numbers in sg list could exceed the FBPT upper limit
> value - max_lops(8)*1024 to cause crash.
> 
> Limit the LOP access to the valid data length to avoid FBPT sub-entries
> overflow.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Cao Bing Bu <bingbu.cao@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 941caa987dab..949f43d206ad 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -838,8 +838,9 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
>  		container_of(vb, struct cio2_buffer, vbb.vb2_buf);
>  	static const unsigned int entries_per_page =
>  		CIO2_PAGE_SIZE / sizeof(u32);
> -	unsigned int pages = DIV_ROUND_UP(vb->planes[0].length,
> CIO2_PAGE_SIZE);
> -	unsigned int lops = DIV_ROUND_UP(pages + 1, entries_per_page);
> +	unsigned int pages = DIV_ROUND_UP(vb->planes[0].length,
> +					  CIO2_PAGE_SIZE) + 1;
> +	unsigned int lops = DIV_ROUND_UP(pages, entries_per_page);
>  	struct sg_table *sg;
>  	struct sg_page_iter sg_iter;
>  	int i, j;
> @@ -869,6 +870,8 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
> 
>  	i = j = 0;

Nit: separate assignments are preferred over multiple assignments

>  	for_each_sg_page(sg->sgl, &sg_iter, sg->nents, 0) {
> +		if (!pages--)
> +			break;
>  		b->lop[i][j] = sg_page_iter_dma_address(&sg_iter) >>
> PAGE_SHIFT;
>  		j++;
>  		if (j == entries_per_page) {
> --
> 2.7.4
