Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23191 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753841AbeASOHW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 09:07:22 -0500
Date: Fri, 19 Jan 2018 16:07:19 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, rajmohan.mani@intel.com,
        tfiga@chromium.org, Cao Bing Bu <bingbu.cao@intel.com>
Subject: Re: [PATCH] media: intel-ipu3: cio2: fixup off-by-one bug in
 cio2_vb2_buf_init
Message-ID: <20180119140719.ialotrz5ealgtafv@kekkonen.localdomain>
References: <1516343254-14297-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516343254-14297-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Thanks for the patch.

On Fri, Jan 19, 2018 at 12:27:34AM -0600, Yong Zhi wrote:
> With "pages" initialized to vb length + 1 pages, the condition
> check if(!pages--) will break at one more page than intended,
> this can result in out-of-bound access to b->lop[i][j] when setting
> the last dummy page.
> 
> Fix: commit c7cbef1fdb54 ("media: intel-ipu3: cio2: fix a crash with out-of-bounds access")

Fixes: c7cbef1fdb54 ("media: intel-ipu3: cio2: fix a crash with out-of-bounds access")

I've applied the patch with that change.

> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Cao Bing Bu <bingbu.cao@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 9db752a7f363..8c9f8f56f5df 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -839,9 +839,8 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
>  		container_of(vb, struct cio2_buffer, vbb.vb2_buf);
>  	static const unsigned int entries_per_page =
>  		CIO2_PAGE_SIZE / sizeof(u32);
> -	unsigned int pages = DIV_ROUND_UP(vb->planes[0].length,
> -					  CIO2_PAGE_SIZE) + 1;
> -	unsigned int lops = DIV_ROUND_UP(pages, entries_per_page);
> +	unsigned int pages = DIV_ROUND_UP(vb->planes[0].length, CIO2_PAGE_SIZE);
> +	unsigned int lops = DIV_ROUND_UP(pages + 1, entries_per_page);
>  	struct sg_table *sg;
>  	struct sg_page_iter sg_iter;
>  	int i, j;

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
